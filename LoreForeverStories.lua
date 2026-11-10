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
    "Edward Heartweaver searched the graveyard in the Lordaeron ruins every week. His son had been lost when Arthas razed the city. This time Edward had not come back.",
    "Edward Heartweaver's wife had warned him against the overrun ruins above the city. Days after he left, she still had no word.",
    "Edward's wife learned what had become of him in the ruins. She said it had not been fair to ask, and gave what thanks she could.",
    "The search for Edward was over. His wife hoped their next meeting would carry less sorrow.",
    false, {"part1_corpus.txt #92401 (objective: the disappearance of Edward Heartweaver)"})
q(92415, "Remember That I Love You", "Ruins of Lordaeron", 22, "heartweaver", 5,
    "A torn, stained bundle of parchment from the graveyard spoke of a missing child of the Heartweaver family.",
    "A letter had survived the undead-trodden graves above the {p:Undercity}. It named a Heartweaver child, and the orphan matron in {p:Stormwind} might know the name.",
    "Matron Nightingale remembered little Jeremy Heartweaver. He had come to the orphanage after Lordaeron fell, and a woman in {p:Duskwood} had lately adopted him.",
    "By the account of the orphanage in {p:Stormwind}, Jeremy Heartweaver had lost both parents in the attack on Lordaeron. A new mother in {p:Duskwood} had taken him in.",
    true, {"LoreForever quest:92415 (wiki: in-game quest text)"})
q(95161, "Remember That I Love You", "Duskwood", 22, "heartweaver", 5,
    "The letter from the ruins was meant for Jeremy Heartweaver, now the adopted son of Avette Fellwood.",
    "Matron Nightingale sent the letter on to Avette Fellwood, Jeremy's new mother. She asked that the boy hear the orphanage was thinking of him.",
    "Avette took the letter but would not show it to Jeremy yet. The boy had not spoken since Lordaeron fell, and she meant to give it to him when he was older.",
    "Avette kept the letter for a later day. She would not hide his past from Jeremy, but she would not force it on a silent child either.",
    true, {"LoreForever quest:95161 (wiki: in-game quest text)"})
fallback("Remember That I Love You", "Ruins of Lordaeron", "heartweaver", "92415, 95161",
    "A stained letter from the graveyard of the Lordaeron ruins named a child of the Heartweaver family.",
    "The Heartweaver letter had survived the ruins. Someone in the Alliance's care might still be meant to read it.",
    "The Heartweaver letter moved one step closer to the child it named.",
    "The letter from the ruins was in kinder hands than the graveyard's.")
q(92421, "Light's Justice", "Ruins of Lordaeron", 22, "ruins", 4,
    "A Forsaken paladin needed flesh from the Scourge above the {p:Undercity}. The Forsaken's decaying bodies could not be mended without replacements.",
    "Captain Garek Bandarion was gone. One of his paladins believed he would have wished his work finished and the Forsaken healed.",
    "Parts taken from the Scourge gave the Forsaken's wounded a chance to see another day.",
    "With replacement parts for the wounded, the paladin said the work did Captain Bandarion proud.")
q(92422, "The Wrath of Rath'mael", "Ruins of Lordaeron", 22, "ruins", 6,
    "Scouts at {p:Lordamere Overlook} reported an unholy fog in the streets and graveyard of the fallen city. A necromancer named Rath'mael was behind it.",
    "Under the fog, the Scourge moved unseen above the {p:Undercity}. Deathguard Kristof in {p:Brill} wanted its maker driven out and could not afford to wait.",
    "Rath'mael was dead. Deathguard Kristof expected the Scourge to find another like him, but hoped their ranks would thin in the meantime.",
    "The necromancer behind the fog had fallen, though Deathguard Kristof expected another of his kind to take his place.",
    false, {"part1_corpus.txt #92422 (Deathguard Kristof in Brill)"}).highlight = {
    "Rath'mael, the necromancer who had hidden the Scourge in fog, was dead.",
    "The fog's maker had fallen, and Deathguard Kristof of {p:Brill} hoped the Scourge would be thinner for a while."}
q(95189, "Crest of Lordaeron", "Ruins of Lordaeron", 22, "relics", 3,
    "A weathered crest of Lordaeron had survived the kingdom's fall, and few such relics were left.",
    "Lady Dena Kennedy in {p:Stormwind} was keen to have any relic of Lordaeron. A weathered crest from the rubble bore the old kingdom's mark.",
    "Lady Kennedy marveled at the crest's condition. She set her best people to restoring it, a piece of Alliance history.",
    "The crest reached Lady Kennedy's gallery, where her people would restore it.",
    true, {"LoreForever quest:95189 (wiki: in-game quest text; Lady Dena Kennedy)"})
q(95204, "Crest of Lordaeron", "Ruins of Lordaeron", 22, "relics", 3,
    "A weathered crest of Lordaeron had come out of the rubble. Oran Snakewrithe in the {p:Undercity} wanted relics of the old kingdom.",
    "Few relics remained after Lordaeron fell, and Oran Snakewrithe of the {p:Undercity} wanted a weathered crest of the old kingdom. The Forsaken still counted Lordaeron as their home.",
    "Biting the crest to test it, Oran called it a genuine relic of home. He promised to handle it with care.",
    "For Oran, the crest was a piece of the Forsaken's history restored.",
    true, {"part1_corpus.txt #95204 (Oran Snakewrithe in Undercity)"})
fallback("Crest of Lordaeron", "Ruins of Lordaeron", "relics", "95189, 95204",
    "A weathered crest of Lordaeron lay among the ruins above the {p:Undercity}.",
    "Relics of the fallen kingdom were rare, and both {p:Stormwind} and the {p:Undercity} wanted them.",
    "The crest left the ruins for safekeeping.",
    "One more relic of Lordaeron was out of the rubble.")
q(95195, "Bloodied Insignia", "Ruins of Lordaeron", 22, "relics", 3,
    "Old Alliance insignia of Lordaeron's soldiers lay all through the rubble. Living kin might still want them back.",
    "Many of Lordaeron's people had fled to {p:Stormwind} when the kingdom fell to the Scourge. Their dead soldiers' medals had stayed behind.",
    "The bloodied insignia went to {p:Stormwind}, to be handed on to the soldiers' next of kin.",
    "Stormwind would pass the insignia to whatever kin remained, though few were left to claim them.",
    false, {"part1_corpus.txt #95195 (objective: collect 10)"})
q(95216, "The New Plague", "Ruins of Lordaeron", 22, "apothecary", 4,
    "Theodore Griffs of the Royal Apothecary Society had heard of a creature whose venom ate through undead flesh. He wanted a sample of it.",
    "Witherfang, a venomous creature, stalked the streets above the {p:Undercity}. Theodore Griffs of the Apothecarium wished to test its toxin for himself.",
    "Witherfang had been killed, which put Griffs out. Still, the ichor was enough to reverse engineer the strain.",
    "Griffs had the creature's toxic strain at the Apothecarium, and meant to learn how it worked.",
    false, {"part1_corpus.txt #95216 (Theodore Griffs in Undercity; Witherfang)"})
-- The Baron's head (Horde, 97288 to 97292). Othmar's name is first spoken in
-- 97289; 97288 keeps it unsaid.
q(97288, "Unending Torment", "Ruins of Lordaeron", 21, "othmar", 4,
    "Many times over, the head of the abomination called {n:the Baron} had been sewn back on. Each time, the join grew weaker.",
    "When {n:the Baron} fell, its head came loose. Someone in the city below might know more about so unusual an abomination.",
    "The head was recognized at once, and its new keeper already had a use for it.",
    "{n:The Baron}'s head reached the {p:Undercity}, where its old owner was known and its next purpose already planned.",
    true, {"part1_corpus.txt #97288"})
q(97289, "Unending Torment", "Undercity", 21, "othmar", 4,
    "Before it was {n:the Baron}'s, the head had belonged to Othmar. He was a Grand Marshal of the Alliance, killed by the Dark Lady herself.",
    "In the next room lay a body, and the apothecaries wanted the head set beside it. Othmar's secrets might yet be made to talk.",
    "Set beside the body, the head brought it twitching to life, and Othmar relived his final moments.",
    "Once the head lay beside it, Othmar's body stirred in a panic.",
    true, {"part1_corpus.txt #97289 (Head of the Baron; the body of Othmar)"})
q(97290, "Unending Torment", "Undercity", 21, "othmar", 3,
    "Othmar's head spoke again, but only to refuse.",
    "Revived, the Grand Marshal answered in broken words and would not help the apothecaries.",
    "The apothecary welcomed the refusal as a challenge.",
    "That defiance pleased the apothecary in charge of Othmar.",
    true, {"part1_corpus.txt #97290"})
q(97291, "Unending Torment", "Undercity", 21, "othmar", 3,
    "Master Apothecary Faranell meant to bind Othmar to the Dark Lady's will with a potion.",
    "Master Apothecary Faranell's potion needed a Toxic Skullcap from Tawny Grisette, blisterweed from the herbalists and a vial of Essence of Agony.",
    "Faranell had his reagents and looked forward to testing how much bravado Othmar had left.",
    "With the ingredients in hand, the potion could be brewed.",
    true, {"part1_corpus.txt #97291 (Master Apothecary Faranell; Tawny Grisette)"})
q(97292, "Unending Torment", "Undercity", 21, "othmar", 5,
    "Faranell's Hissing Serum was to drip into the workings above Othmar's body. It would teach him the value of loyal service.",
    "For Othmar's crimes against the Dark Lady, Master Apothecary Faranell wanted him placed beneath an oozing specimen.",
    "The serum went into the workings above the body. Faranell left the flesh to simmer and spoke of many plans for Othmar's future.",
    "Dripping onto the Grand Marshal, the serum was in place. The master apothecary meant to let his new guest acclimate.",
    true, {"part1_corpus.txt #97292 (Hissing Serum)"})
fallback("Unending Torment", "Undercity", "othmar", "97288 to 97292",
    "The head of an abomination from the ruins had caught the interest of the apothecaries in the {p:Undercity}.",
    "The apothecaries of the {p:Undercity} had plans for {n:the Baron}'s head.",
    "One step of the apothecaries' work on {n:the Baron}'s head was done.",
    "The apothecaries' work on the head from the ruins went on.")
q(97891, "Prompt Potion Runner", "Undercity", 16, "apothecary", 2,
    "Alessandro's potion would spoil unless it crossed the slime canal quickly. His own knees popped out of joint whenever he ran.",
    "Doctor Martin Felben in the Apothecarium was waiting on a potion with a very short shelf life.",
    "The potion reached Doctor Felben in time. Six before it had gone bad on the way.",
    "Felben had Alessandro's potion at last, still stable, and went back to his experiments.",
    false, {"part1_corpus.txt #97891"})

---------------------------------------------------------------- Dun Morogh and the Hall of Thanes (Forever dungeon, 13-18)
-- Givers: LoreForever quest:96408 (Beldin Steelgrill to Earthseer Farsen),
-- quest:96390/96392 (Earthseer Farsen), quest:96393 (to King Magni Bronzebeard).
q(96408, "A Visitor to Dun Morogh", "Dun Morogh", 13, "thanes", 3,
    "A mountaineer had seen a campfire at night on a hillside above the Gol'Bolar Quarry. Beldin Steelgrill wanted to know whose it was.",
    "Most likely the fire above the quarry was nothing. If its keepers were not friendly, the mountaineers wanted them dealt with.",
    "The camp above the quarry was friendly. Its keeper, Earthseer Farsen, had a cheerful greeting ready.",
    "Earthseer Farsen kept the fire, and welcomed his visitor as a friend.",
    false, {"LoreForever quest:96408 (wiki: World of Warcraft: Forever)"})
q(96392, "Farsen's Watch", "Dun Morogh", 13, "thanes", 3,
    "On his way down from Aerie Peak, Earthseer Farsen had noticed a Dark Iron problem.",
    "Farsen offered to show the trouble with a bit of his own magic. His farsight could see a great deal from the sky.",
    "Seen from the sky, the Dark Irons were thick as cockroaches, Farsen said. He wanted something done about them.",
    "Farsen's farsight showed the Dark Irons from the sky, and he asked for a bit of violence.",
    false, {"LoreForever quest:96392 (wiki: World of Warcraft: Forever)"})
q(96390, "Nip 'Em in the Bud", "Dun Morogh", 13, "thanes", 3,
    "Dark Iron spies had slipped into the dwarves' lands, and they had to be stopped before their purpose could grow.",
    "At Ironband's Compound in the east the spies were gathering, and no one yet knew what they wanted.",
    "The spies at Ironband's Compound were cut down. Farsen called the Dark Irons cousins but not family, and shed no tears for them.",
    "Breaking up the band at Ironband's Compound, Farsen hoped, would put the Dark Irons off further incursions.",
    false, {"part1_corpus.txt #96390 (objective: slay 10)", "LoreForever quest:96390 (wiki: World of Warcraft: Forever)"})
q(96391, "Underground Map", "Dun Morogh", 15, "thanes", 4,
    "A Dark Iron map showed tunnels and highways that met at a point beneath {p:Ironforge} itself.",
    "Dark Iron runes covered the map in their jagged script, but the tunnels needed no translation.",
    "Farsen read the map as a plan to break into the vaults beneath {p:Ironforge}. The spies at the compound had been a scouting force.",
    "To Farsen, the map was a road into the vaults below {p:Ironforge}. He wanted to get there before the Dark Irons did.",
    false, {"part1_corpus.txt #96391 (Dark Iron Map to Earthseer Farsen)"})
q(96393, "Old Ironforge Incursion", "The Hall of Thanes", 16, "thanes", 6,
    "Farsen had made out one name on the Dark Iron map. Durgen Dirgehammer, he guessed, commanded the incursion.",
    "Down in the caverns beneath {p:Old Ironforge}, the way to the Dark Irons ran to the lowest vaults of the tombs.",
    "King Magni Bronzebeard heard of the incursion beneath his feet and was relieved its commander was dead. His guards would clear the rest and seal the breaches.",
    "Dirgehammer's head reached King Magni, who ordered the lower levels reinforced. He also asked that his old friend Farsen come for a proper visit.",
    false, {"part1_corpus.txt #96393", "LoreForever quest:96393 (wiki: Hall of Thanes (instance))"}).highlight = {
    "Durgen Dirgehammer, the Dark Iron commander, was dead, and his head reached King Magni. The breaches beneath Ironforge would be sealed.",
    "King Magni took the Dark Iron commander's head as proof of the incursion beneath his city. He sent his guards to clear the rest."}
q(96394, "The Restless Dead", "The Hall of Thanes", 15, "tombs", 3,
    "Something had disturbed the tombs of the thanes. Strange noises came up from the vaults.",
    "Light sleepers, the keepers of the hall called the dead. Whatever was happening below had woken them.",
    "The woken dead were put back down. Nothing now kept the keepers out of the hall.",
    "The restless dead lay still again, to the relief of the keeper who asked. Everyone else had refused to enter the hall on account of ghosts.",
    false, {"part1_corpus.txt #96394 (objective: kill 15)"})
q(96395, "An Ancient Grudge", "The Hall of Thanes", 15, "tombs", 4,
    "A ghostly attendant among the tombs begged in a few words at a time. It wanted rest for its master, the thane.",
    "Faldrim Anvilmar, a thane of old, was so consumed by an ancient grudge that his spirit could not rest.",
    "The thane's spirit was put to rest, as the ghost of his attendant had asked.",
    "The old thane lay quiet at last, as the spirit who served him had begged.",
    false, {"part1_corpus.txt #96395 (objective: put the spirit of Faldrim Anvilmar to rest)", "LoreForever quest:96395 (wiki: in-game quest text)"})
q(96403, "Important Heirlooms", "The Hall of Thanes", 15, "tombs", 3,
    "A gnome named Thom, who said he had been patrolling the vaults, wanted their heirlooms saved from the Dark Irons.",
    "Dark Irons had come out of the depths in mole machines. Thom, a gnome in the vaults, feared for the priceless loot. Cultural heirlooms, he corrected himself.",
    "Thom took the recovered heirlooms to catalogue them, though he slipped and called it appraising.",
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
    "Shen'dar Village sent each newcomer to the elder of their own tradition. For a Windshaper, that was Illaya Amberwind near the center of town.",
    "In Shen'dar it was said that a Windshaper left a little static on the skin. Illaya Amberwind, the village elder of that tradition, waited outside.",
    "The High Order and the Windshapers were at odds those days, but in Shen'dar they kept things civil. Everyone there knew the village had bigger problems.",
    "With the elder met, Shen'dar had work waiting, starting with its bandits.",
    true)
q(93461, "Welcome to Shen'dar Village", "Zephras Isle", 6, "traditions", 2,
    "In Shen'dar it was said that those of Highborne blood had a twinkle in their eyes. Rathiril Sunlance, the village's High Order elder, kept to the main lodge.",
    "A newcomer to Shen'dar Village with the look of the High Order was sent first to its elder, Rathiril Sunlance.",
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
    "Every soul with the skysight mattered, Illaya taught. Only with them could the shen'dorei hope to speak with the spirits of the winds again.",
    "The dangers, Illaya said, were the Al'Aketh and the uncertain safety of Skywall. Against them, the Windshapers' gifts were the way to save their home.")
q(92596, "The High Order", "Zephras Isle", 6, "traditions", 3,
    "Rathiril Sunlance felt a strong aura of arcane energy even in those never initiated as mages.",
    "Rathiril wished to speak of the High Order and the nature of the arcane on the island.",
    "High as he held the elemental benefactors, Rathiril said plainly that they were gone. The shen'dorei were on their own.",
    "As descendants of the Highborne of Eldre'Thalas, Rathiril said, the High Order would see the shen'dorei stand on their own again.")
q(92515, "The Problem With Prideclaws", "Zephras Isle", 6, "shendar", 2,
    "Prideclaws had grown thick in the hills around Shen'dar and bolder by the day, and the village feared for its pets and children.",
    "Culling the prideclaws before a tragedy seemed a mercy. Their pelts could be made into goods the village needed.",
    "The pelts came in. No one had promised clean work, the villager who wanted them pointed out.",
    "Shen'dar had its stack of prideclaw pelts.")
q(92516, "Hippogryph Harrassment", "Zephras Isle", 7, "shendar", 2,
    "A flock of hippogryphs had made nesting grounds southeast of Shen'dar and were attacking travelers on the road.",
    "Hippogryphs nesting near Shen'dar struck at whoever passed, and the road had grown dangerous.",
    "The hippogryph flock was thinned, and the road near Shen'dar was safer for it.",
    "Fewer hippogryphs nested by the road now. The work had been quick enough to earn a word of praise.")
q(93951, "A Little Beauty", "Zephras Isle", 7, "shendar", 2,
    "Many skyborne liked bright plumes in their hair. Hippogryph down was the most vibrant and the softest.",
    "Fallen feathers lay around the hippogryph nests near Shen'dar, though the wild birds did not welcome visitors.",
    "The feathers went to a crafter who admitted it seemed a vain thing in such times. Small joys mattered all the more, the crafter held.",
    "From the down, Shen'dar's crafter hoped to make something that would bring someone joy.")
q(92553, "Restocking the Larders", "Zephras Isle", 6, "shendar", 2,
    "With the danger growing, no one in Shen'dar had found time to hunt or forage, and the village needed eggs and strider meat.",
    "Shen'dar's cook promised one of a set of famous recipes in return for fresh eggs and strider meat.",
    "The eggs were hard to come by, and the cook swore they were delicious fried in ursera tallow.",
    "The larders had fresh eggs and strider meat again, and the cook offered to share a few tricks of the trade.")
q(93319, "Pilfered Windstones", "Zephras Isle", 7, "shendar", 3,
    "Windstones kept in reserve for emergencies had been going missing from Shen'dar's stores, and stolen stones had turned up on captured bandits.",
    "Stolen windstones were thought to lie in the bandits' cave to the north. Constable Aonda would not spare peacekeepers for a raid while the cult grew at Falaath.",
    "Some of the windstones came back from the bandit cave. It was enough to get by, unless the supply routes failed.",
    "The reclaimed windstones eased Shen'dar's shortage for now. If the supply routes could not be fixed, stolen stones were the smaller worry.")
q(94411, "Meddlesome Mages", "Zephras Isle", 6, "traditions", 3,
    "Mages of the High Order kept meddling at the Windshapers' sacred standing stones north of Shen'dar, despite every warning.",
    "Loath as they were to shed shen'dorei blood, the Windshapers wanted the High Order driven from the standing stones.",
    "The mages were driven from the stones. Fighting their own kin weakened the shen'dorei, the Windshapers held, but they feared the High Order's meddling more.",
    "The standing stones were clear of the High Order. To the Windshapers, one careless spell could undo the fragile forces that bound the island.",
    false, {"part1_corpus.txt #94411 (objective: slay 6)"})
q(94413, "A Magical Affront", "Zephras Isle", 6, "traditions", 3,
    "Ley lines had broken the surface of the island, and the High Order valued the new access to its magic.",
    "To the Windshapers, the ley lines were scars to be healed. High Order mages meant to drive them from the one in the southwestern forest.",
    "The Windshapers were driven from the ley line. To the High Order, their refusal to change was hard to tell from the zealotry of the Al'Aketh.",
    "The ley line was the High Order's for now. If the winds truly guided the shen'dorei, the order held, the Windshapers should be flowing with them.")
q(93036, "Infiltrating the Cult", "Zephras Isle", 8, "forever_cult", 4,
    "Sania Silverstream, a missionary of the Al'Aketh, recruited openly in Shen'dar, and the village had tolerated her to avoid open conflict.",
    "Peace with the cult would not last. Shen'dar needed someone unknown to get close to Sania and learn the cult's plans.",
    "The missionary introduced herself as a junior priestess of the Order of the Al'Aketh. She spoke of the Windlord's table, with room for the righteous and the repentant.",
    "The missionary offered to teach more of Al'Akir, the Windlord her order served.")
q(92529, "Falaath Village", "Zephras Isle", 8, "forever_cult", 4,
    "To Sania, the spirits of the wind had left the shen'dorei because of their pride. Only contrition, she preached, would bring them back.",
    "New recruits went on to Falaath Village, marked by Sania so the faithful there would know them.",
    "Missionary Jasaan welcomed an acolyte sent by Sister Sania, and called the day blessed by the four winds.",
    "Missionary Jasaan took the mark at face value and welcomed a supposed new acolyte of Al'Akir.")
q(92551, "Stolen Supplies", "Zephras Isle", 8, "forever_cult", 3,
    "For months the Al'Aketh had raided Shen'dar's supply caravans and blamed the bandits, but the goods all ended up in the same place.",
    "Food and windstones taken from Shen'dar's caravans might still be stored in Falaath Village.",
    "With the constable's help, the recovered supplies were to be shared out to the townsfolk in most dire need.",
    "Without its deliveries, Shen'dar had been barely getting by, and the caches from Falaath bought it some relief.")
q(92550, "Havoc in the Highlands", "Zephras Isle", 8, "forever_cult", 5,
    "An attack from Falaath was expected, and Shen'dar meant to strike first at the cultists and their commander.",
    "The village readied its few peacekeepers and armed its citizens. In Falaath, the cult's commander was marked for death.",
    "The commander's head reached Shen'dar. Sania Silverstream had slipped out of town as the people armed themselves.",
    "With the commander dead, Shen'dar had turned the tables. If the cult came back to the highlands, it would not find an easy target.").highlight = {
    "The cult's commander at Falaath was dead, and Shen'dar was ready if the zealots came back.",
    "Shen'dar struck first at Falaath, and Sania Silverstream, the cult's missionary, fled the village as its people armed."}
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
    "Aonda's letter reached Valennia. She trusted the constable's word and began planning for a cult attack on Valanaar.",
    true)
q(92699, "The Supreme Magister", "Zephras Isle", 9, "traditions", 3,
    "Elaadrin Evengale, the Supreme Magister, led the High Order from its lodge in the southeast of Valanaar.",
    "Valanaar's peacekeepers would not tolerate faction violence in the streets, and warned the High Order to give the Windshapers a wide berth.",
    "A missive from Rathiril had reached Elaadrin, and he saw promise in a vibrant arcane aura. Whether it came with boldness and strength, he said, remained to be seen.",
    "The Supreme Magister welcomed Rathiril's recommendation. Few shen'dorei, he said, still had the aptitude and the will to save their home.")
q(92700, "The Grand Skyseer", "Zephras Isle", 9, "traditions", 3,
    "From the lodge near the center of town, the Grand Skyseer led the Windshapers of Valanaar.",
    "Valanaar's peacekeepers would not tolerate faction violence in the streets, and warned the Windshapers to give the High Order a wide berth.",
    "The Grand Skyseer already had Elder Amberwind's message about Shen'dar, and gave a warm welcome.",
    "Fewer and fewer shen'dorei had the skysight, the Grand Skyseer said, and the island needed every one of them.")
q(93948, "Deliver the Signet", "Zephras Isle", 9, "forever_cult", 4,
    "A signet ring had been recovered from the western watchtower. It belonged with Talaanis Shadowsong, the High Elder, and so did the news of his nephew.",
    "Talaanis Shadowsong was well loved by the people despite their hardships. Whoever sent the ring dreaded how he would take the news of his nephew.",
    "Talaanis was sorry to learn that his nephew was dead. He thanked the bearer for bringing back the ring.",
    "The High Elder took back the signet and the news of his nephew's death. Then he pointed toward Valennia Stormfist, who needed all the help she could get.")
q(92679, "Blood Tithe", "Zephras Isle", 9, "windfield", 4,
    "Alvarion Windfield had come to Valanaar badly hurt, looking for fighters to save his farm.",
    "Alvarion's wife Aamelia kept their stormapple orchard in the lowlands west of Valanaar, and he wanted help sent to her.",
    "His wife Aamelia was relieved that Alvarion was safe in Valanaar. He had likely sent help there to die for nothing, she warned.",
    "At the orchard, Alvarion's wife Aamelia learned what had become of him. This was not a stranger's fight, she said plainly.")
q(92682, "Make Yourself Useful", "Zephras Isle", 9, "windfield", 3,
    "Ferauu's bandits were due to collect their take of the Windfield harvest. Some of his people had come early to tamper with the stormapples.",
    "Help had to work for its meals at the orchard. Aamelia wanted stormapples gathered and the bandits among the trees cleared out.",
    "From her window, Aamelia had watched the bandits fall, and she judged it not bad.",
    "The day's stormapples were in, and the bandits in the orchard were dead.")
q(92683, "Flutterfly Dust", "Zephras Isle", 9, "windfield", 2,
    "Giant flutterflies drifted over the fields near the orchard, and their wing dust had uses about the house.",
    "A swat with Aamelia's flutterfly swatter usually sent the big bugs off with a shake and a pile of dust.",
    "Aamelia had her dust at last, a chore put off for weeks while bandits lurked near the house. She would not say what it was for.",
    "The flutterfly dust got everywhere, as Aamelia had warned, and she kept its use to herself.")
q(92684, "Ornery Ornery Galestriders", "Zephras Isle", 9, "windfield", 2,
    "Galestriders had been raiding the orchard for stormapples in a year when the harvest was already light.",
    "Lowland galestriders were bigger and angrier than the highland kind, and a well-timed kick could put a fighter down for good.",
    "The galestrider tenderloins were big ones. For the first time in too long, Aamelia could cook a real meat supper.",
    "The galestriders were culled, and their meat went to Aamelia's kitchen.")
q(92685, "The Hills Have Eyes", "Zephras Isle", 9, "windfield", 4,
    "Ferauu's bandits kept a small camp in the hills north of the orchard. Aamelia meant to hit them before they came for her.",
    "Aamelia wanted the masks of Ferauu's bandits, the bloodier the better.",
    "The masks were bloody enough to please Aamelia. She had spent weeks waiting for the end, she said, and now had hope again.",
    "With the hill camp broken, Aamelia had begun to hope. Ferauu and his thugs were due any time.")
q(92693, "Standing Our Ground", "Zephras Isle", 9, "windfield", 6,
    "At last Ferauu and his thugs came for their share of the harvest. Aamelia walked out to meet them with her head held high.",
    "Aamelia offered one last chance to go back to Valanaar. She meant to face Ferauu whatever happened.",
    "It was over, and Aamelia could hardly believe it. She had to stop and calm herself before her heart leapt out of her chest.",
    "Aamelia's stand against Ferauu was over. There were not stormapples enough in Skywall to repay it, she said.").highlight = {
    "Aamelia Windfield faced Ferauu's bandits at her orchard, and when it was over she could hardly believe it.",
    "The stand against Ferauu's bandits at the Windfield orchard was over, and Aamelia needed a moment to calm herself."}
q(92698, "What Is My Purpose?", "Zephras Isle", 9, "forever_winds", 3,
    "A great construct wandered the fields by the orchard, repeating fragments of words from beneath its armor plates.",
    "Under its armor, an old construct muttered of function errors and questions. No one nearby could say what it wanted.",
    "Aamelia Windfield said the construct had wandered the fields since the wind elementals left. Her husband Alvarion thought it had once hauled harvests or tended livestock.",
    "The Windshapers had once kept such constructs, Aamelia Windfield said, but no one had ever asked them to look at this one.")
q(92703, "Deliver the News", "Zephras Isle", 9, "windfield", 5,
    "Aamelia wanted Alvarion told what had happened at the orchard. She asked that he bring a Windshaper to look over the old construct once he was on his feet.",
    "Aamelia wanted the old construct made safe for her family, for a reason she was keeping from Alvarion for now.",
    "Alvarion wept as he heard what had happened at the orchard. He had come to Valanaar on a vain hope, he said, and found a hero instead.",
    "Alvarion promised a welcome at the Windfield home, and said he would never forget what had been done for them.")
q(93317, "Crab Season", "Zephras Isle", 9, "shendar", 2,
    "Windsong crawlers lived only in Windsong Lake, and could be harvested just a few weeks of the year.",
    "Cult activity had kept the crab gatherer away from the lake, and the season was nearly over.",
    "The crawler meat looked fantastic. It had once been a delicacy on Anvilas and Siroccas, back when the skystreams were open.",
    "The season's crawlers were in. Before the skystreams closed, the crab gatherer had sold them on Anvilas and Siroccas.")
q(93318, "WANTED: Vulgara the Insatiable", "Zephras Isle", 9, "shendar", 3,
    "Constable Aonda had put a bounty on Vulgara the Insatiable, a winged vuldren that terrorized the Shen'dar highlands.",
    "Vulgara the Insatiable, a winged vuldren with a bounty on her head, had last been seen on a hilltop southwest of Shen'dar Village. Peacekeepers called her highly dangerous.",
    "Vulgara's head went to Danarii Bellowveil, and the bounty was paid.",
    "The highlands were rid of Vulgara. With the cult and the bandits to face, Shen'dar was glad to see one danger gone.",
    false, {"part1_corpus.txt #93318 (Vulgara in the Shen'dar Highlands)"})
q(93736, "Unwelcome Spirits", "Zephras Isle", 9, "forever_winds", 4,
    "After the spirits of the wind left, strange wind sprites called hollows had appeared in Shadowgale Forest. The Windshapers wanted to know why.",
    "Hollows were to be dispersed in Shadowgale Forest, and Endaria of the Windshapers wanted their remains brought back for study.",
    "Endaria of the Windshapers felt a malevolent, regretful aura from the hollows' essences. She did not look forward to studying them.",
    "Endaria, a Windshaper, shuddered as she handled the remains of the hollows.")
q(93738, "The Broken Construct", "Zephras Isle", 9, "forever_winds", 4,
    "The construct's missing parts led to Belathaan Brightwish of the High Order. That order was forbidden by the Windshapers to meddle with their knowledge.",
    "Who had stripped the broken construct was news for Ayessa Dawnsinger of the Windshapers. She would decide what came next.",
    "Ayessa Dawnsinger was disappointed. Belathaan, Valennia Stormfist's cousin and the son of a Windshaper, had a hand in the broken construct.",
    "Hearing that the High Order was behind the broken construct, Ayessa needed a moment to reflect.",
    true)
q(94003, "The Skybreaker Bulwark", "Zephras Isle", 10, "forever_cult", 4,
    "Seena was the last of the Skybreakers on the island. The Al'Aketh had murdered the rest.",
    "A cultist named Zaal Stormshield carried the Skybreaker Bulwark, Seena's ancestral shield, at the Shrine of Akir.",
    "With the Skybreaker Bulwark back in Seena's hands, her family's honor was restored. In thanks she offered to teach the Skybreaker Defense.",
    "Seena had her family's shield again. She offered the Skybreaker Defense, a secret few were thought worthy of. The shield she no longer needed she gave away.")
P.threads.fv_windfield = "the Windfield orchard"

---------------------------------------------------------------- Zephras Isle, the war with the Al'Aketh (11-13)
-- LoreHordeStories.lua tells 92640, 92643, 92644, 92646/93835, 94369 and 94485;
-- these are the stages between them. The Windshaper and High Order versions of
-- the Belathaan affair (93746 in LoreHordeStories.lua, 92834 here) each keep
-- their own side's account.
q(93320, "Tower Defense", "Zephras Isle", 11, "forever_cult", 4,
    "Cultists were attacking the pylon watchtower east of Valanaar. Valennia had sent her last spare peacekeepers to break through to the defenders.",
    "Valennia's lieutenant Yorana Windyreed had led the relief force to the east watchtower, if she still lived.",
    "Yorana's fighters were holding the cult off for now. But they were outnumbered and tiring, and the stalemate had to break soon.",
    "The defenders at the east watchtower still held, though the cult had greater numbers.")
q(92642, "Disrupting Logistics", "Zephras Isle", 11, "forever_cult", 3,
    "Yorana could hardly believe Valennia had sent a single fighter against a full assault, but she would take what she could get.",
    "Yorana wanted the cult's healers taken out, for they kept its attackers coming at the east watchtower.",
    "Below the hill, the cult's healers were cut down. Yorana called it a small miracle that anyone came back alive.",
    "With the healers dead, Yorana hoped her people could rally and push the attackers back.")
q(92645, "Breaking the Breaker", "Zephras Isle", 11, "forever_cult", 5,
    "Belguilos the Breaker commanded the cult's assault from a villa at the foot of the hill. She had been a peacekeeper once, and even then something about her was off.",
    "While Belguilos the Breaker lived, Yorana believed, the attack on the watchtower could not be broken.",
    "Belguilos was dead, and Yorana began to think her people might come out of it alive.",
    "The cult's commander at the east watchtower had fallen, and Yorana blessed the four winds for it.").highlight = {
    "Belguilos the Breaker, who led the cult's assault, was dead. The east watchtower might hold after all.",
    "The cult lost its commander at the east watchtower, a former peacekeeper called Belguilos the Breaker."}
q(92880, "Return to Valanaar", "Zephras Isle", 11, "forever_cult", 3,
    "Mopping up would take time, but the east watchtower was stable, and Yorana's report had to reach Valennia.",
    "A report went back from Yorana to Valanaar. The watchtower was stable, and the chances of holding it far better.",
    "Valennia was visibly relieved to hear that the eastern watchtower held.",
    "Valennia had the report from the eastern watchtower, and thanked the winds.",
    false, {"part1_corpus.txt #92880 (Yorna's Report)"})
q(92881, "The High Elder's Request", "Zephras Isle", 11, "forever_cult", 4,
    "The attacks on both watchtowers were no coincidence. After what the skypriest had done at the western tower, the peacekeepers guessed the cult was after the anchor pylons.",
    "High Elder Shadowsong had a lead that might explain what the cult wanted with the anchor pylons.",
    "The High Elder had a small matter that needed an adventurer's kind of help.",
    "The High Elder was ready to share his lead on the cult's designs.")
q(94568, "The Cult's True Plans", "Zephras Isle", 11, "forever_cult", 4,
    "Fear of the cult's plans had driven the turncoat to defect, and he had died before he could tell them.",
    "All that remained of the turncoat's attempt to warn Valanaar was the damaged crystal he had carried.",
    "Open battle with the cult would go badly for the peacekeepers, and Valanaar would need a different approach.",
    "Valanaar's leaders weighed sending peacekeepers straight at the cult, and judged they would not fare well in open battle.")
q(92834, "Avenged Tenfold", "Zephras Isle", 11, "forever_cult", 5,
    "Elaadrin Evengale had sent his friend Belathaan Brightwish to the Shrine of Akir to open talks. A box came back holding Belathaan's tongue, dipped in silver pigment.",
    "Elaadrin had argued for dialogue while the Windshapers and peacekeepers postured. After Belathaan's death he wanted the cultists' prayer charms instead.",
    "Elaadrin's eyes crackled with arcane light. The cult had mistaken the High Order's prudence for weakness, he said, and was not ready to pay for that error.",
    "Elaadrin took the prayer charms and admitted the Windshapers had been right about the cult. His mistake had cost a friend's life.")
q(92840, "Catching Wind", "Zephras Isle", 11, "traditions", 4,
    "Magic that sustained the island lingered at the standing stones of the Shen'dar Highlands. They were sacred to the Windshapers and closed to the High Order's study.",
    "With the Windshapers busy elsewhere, the High Order wanted a device placed at the standing stones to gather data, discreetly.",
    "Windshaper blood had been spilled at the stones. The High Order laid the blame on the Windshapers, who would not retaliate in Valanaar but would not forget.",
    "The device gathered its data at the standing stones, and word of the fighting there spread quickly among the Windshapers.")
q(93740, "Blood for Blood", "Zephras Isle", 11, "forever_cult", 4,
    "Windshaper novices had been found dead in the highlands, and Ayessa suspected the Al'Aketh. Windshapers traded blood for blood.",
    "Ayessa wanted the Al'Aketh to the north killed and their windstone prayer charms brought back as proof.",
    "Shaken and distant, Ayessa took the windstone charms. It had been a trying day, she said.",
    "The prayer charms reached Ayessa, who called it only the start of the cult's reckoning.")
q(98512, "Al'Aketh Assassins", "Zephras Isle", 11, "forever_cult", 3,
    "A scout on patrol near the border had spotted Al'Aketh skulking around a house on the hill to the north.",
    "No one knew what the Al'Aketh wanted at the house on the hill, but it could not be good.",
    "The Al'Aketh at the house were dead. Glad of the help, the scout meant to mention it in the report to Valanaar.",
    "The assassins near the border were dealt with, though what they had been after remained a question.",
    false, {"part1_corpus.txt #98512 (objective: kill 10)"})
q(93065, "Prepare for Battle", "Zephras Isle", 12, "forever_cult", 4,
    "Valanaar's peacekeepers were mobilizing. Everyone was to meet on the eastern road north out of town for a final check before the march.",
    "Every fighter had preparations to make, for the peacekeepers of Valanaar were gearing up to march on the cult.",
    "At the eastern road, the peacekeepers said they were as ready as they would ever be.",
    "The final check was done, and the march on the cult could begin.")
q(92947, "Making Our Move", "Zephras Isle", 12, "forever_cult", 5,
    "Valennia sent a few of her best fighters through the shrine's front as a distraction. She led the Windshapers and the High Order in from the flank.",
    "Valennia's plan was to punch through quickly and reach the High Priestess. Others would cause trouble on the way to the shrine's steps.",
    "At the steps of the shrine, Hyusaa Quickbreeze said they had fought hard to get that far. It was not over yet.",
    "The assault had reached the shrine steps, where Valennia's second, Hyusaa Quickbreeze, waited. More fighting lay ahead.",
    false, {"part1_corpus.txt #92947 (objective: slay 8)"})
q(93958, "The Inner Sanctum", "Zephras Isle", 12, "forever_cult", 5,
    "Valennia's forces had breached the inner sanctum, and after thick fighting it had gone unsettlingly quiet.",
    "One fighter stayed at the entrance to watch the way back. Someone had to go in and find Valennia and whatever was left of her forces.",
    "Valennia was found inside, gravely wounded.",
    "Valennia was still alive in the sanctum, but gravely wounded.")
q(93459, "More Al'Aketh Ears", "Zephras Isle", 13, "shadowgale", 2,
    "Druids of Shadowgale Forest kept rumors of a haunting alive to keep folk away. Now the Al'Aketh had come anyway.",
    "Vayn Moonclaw offered coin, and in time the secrets of the order, for the ears of Al'Aketh cultists.",
    "The Al'Aketh ears were paid for, as Vayn Moonclaw had promised.",
    "A reward had been promised for Al'Aketh ears, and Vayn Moonclaw paid it.",
    false, {"part1_corpus.txt #93459 (Vayn Moonclaw in Shadowgale Forest)"})
q(92741, "Unwelcome Visitors", "Zephras Isle", 13, "shadowgale", 3,
    "Shrieklings had multiplied in Shadowgale Forest and begun spreading beyond the woods. A scholar of the High Order wanted their talons.",
    "Shriekling talons had alchemical properties, and the High Order saw scholarly gain in a much-needed culling.",
    "There was a whole haul to dig into, and the scholar could not wait.",
    "The talons went to the High Order. Its mages did not usually work as trappers, but would for a scholar's gain.")
P.threads.fv_shadowgale = "the dangers of Shadowgale Forest"

---------------------------------------------------------------- Zephras Isle, Shadowgale Forest (11-13)
-- The Nightfang Den: Elegael Thornpaw and the Nightclaw druids (94484 to 94491;
-- LoreHordeStories.lua tells 94485). The quest text spells the fallen village
-- Ban'aethall once and Ban'aethal elsewhere; the lines use Ban'aethal. 94487's
-- heirlooms are the coming-of-age relics of 92460. 94902 is a placeholder quest
-- (its text reads "[PH]") and is left out.
q(94484, "Unnerving Silence", "Zephras Isle", 11, "nightfang", 4,
    "Lotheluum in Valanaar had waited too long for word from the druid conclave in Shadowgale Forest. With Ban'aethal in ruins, he feared the worst.",
    "Long overdue with their letters, the druids of Shadowgale had gone silent, and Lotheluum wanted Elegael Thornpaw found.",
    "Elegael Thornpaw paled to learn that no reinforcements were coming. Her message had never reached Valanaar.",
    "Elegael Thornpaw's call for help had not got through. The druids would have to handle it on their own, she decided, and quickly.")
q(94493, "A Sacrifice in Vain", "Zephras Isle", 11, "nightfang", 4,
    "With no help coming from Valanaar, the druids of Elegael Thornpaw's den were in dire straits.",
    "An Al'Aketh ambush had struck the druids' den, and Elegael resolved to deal with it without waiting for Valanaar.",
    "Elegael told how the cultists had struck with little warning, leaving many in her den wounded or dying.",
    "Many there lay wounded or dying, and Elegael begged for help before it was too late.")
q(94486, "Feathers for Binding", "Zephras Isle", 11, "nightfang", 3,
    "Elegael's poultice needed feathers from young shrieklings, to cover the moss and keep its antiseptic sap from drying.",
    "Shadowgale's shrieklings were usually docile but had turned hostile. Elegael regretted asking for the young ones' feathers.",
    "Every feather would be used, Elegael promised, so the shrieklings' deaths would not be wasted.",
    "With the feathers, Elegael had what she still needed for her poultices.")
q(94487, "Unwanted and Unworthy", "Zephras Isle", 11, "nightfang", 4,
    "The Al'Aketh had ambushed the druids without warning. Elegael wanted the cultists slain and the heirlooms they wore taken from them.",
    "Elegael said the cultists did not deserve to be called shen'dorei, and that their ashes did not deserve the winds.",
    "Looking at the bloodied heirlooms, Elegael was distressed. So many young lives were gone, she said. The relics would wait in the High Elder's collection for a worthier generation.",
    "The cultists' heirlooms would go back to the High Elder, Elegael said, to wait for the next generation coming of age.")
q(94488, "The Ties That Bind", "Zephras Isle", 11, "nightfang", 5,
    "Haalien, a druid of the circle who had vanished months before, had joined the cultists who attacked his own kin.",
    "Elegael caught Haalien's scent over the bloodshed, and wanted his head for the blood he had spilled.",
    "Elegael grimaced at Haalien's head and nodded. He was her cousin, and she could not easily have struck him down herself.",
    "No one should mourn Haalien, Elegael said. His malice had killed many innocents that day.")
q(94490, "Ripped Missive", "Zephras Isle", 12, "nightfang", 5,
    "A torn, bloodstained note tucked behind Haalien's bracer held something of why the cult had attacked the druids' den.",
    "Haalien had carried orders behind his bracer, and Elegael would want to read them.",
    "The cult had come for the pylon, and the druids had died for being in the way. Since the orders seemed to come from Valanaar, Elegael sent the missive to Lotheluum.",
    "Elegael read that the cult had come for the pylon, and shook with rage. If the orders came from Valanaar, a traitor was likely hiding there.")
q(94489, "The Wounds of Betrayal", "Zephras Isle", 12, "nightfang", 5,
    "Elegael's poultices were ready for the druids in the Nightfang Den, too hurt to heal their own wounds. There were so few shen'dorei druids that every life was precious.",
    "Jorel Windsinger, Elegael's mate, had been in dire condition when she left the den. She asked that he be found.",
    "Hearing what had become of Jorel and the others, Elegael choked back a sob. She swore that anyone allied with the Al'Aketh would feel her wrath.",
    "The poultices reached the den, but the news of Jorel was worse than Elegael had feared. She swore the cult would pay.",
    false, {"part1_corpus.txt #94489 (the Nightfang Den; heal 7 druids)"})
q(94491, "The Fate of the Den", "Zephras Isle", 12, "nightfang", 6,
    "Someone in Valanaar was feeding the cult information. That news, and the names of those the den had lost, had to reach Lotheluum.",
    "In no shape to travel, Elegael stayed behind with cultists still to slay.",
    "Lotheluum looked terrified at the account of the den. If the missive was genuine, Valanaar held an accomplice or a traitor. He would take it straight to the High Elder.",
    "There were no words for the loss, Lotheluum said. He carried the missive to the High Elder, determined that the druids' sacrifice would not be in vain.").highlight = {
    "In Valanaar, Lotheluum heard how the druids of the Nightfang Den were slaughtered. A traitor in the town might be feeding the cult.",
    "Lotheluum of Valanaar received the cult's orders found at the Nightfang Den, and the High Elder would hear of a traitor in the town."}
q(93165, "Mercy Falls on Deaf Ears", "Zephras Isle", 13, "nightfang", 2,
    "Tragedy had come to the Nightclaw enclave with the Al'Aketh, and its druids meant to repay blood with blood.",
    "For the ears of slain cultists, the Nightclaw offered coin, and in time their secrets.",
    "Each ear was paid for. The Nightclaw hoped the cult understood that their resentments ran deep.",
    "Once the ears were counted and paid for, the Nightclaw asked for more.",
    false, {"part1_corpus.txt #93165 (objective: 10 cultist ears)"})
q(93159, "The Strange Hermit", "Zephras Isle", 13, "shadowgale", 2,
    "A hooded hermit lived alone in Shadowgale Forest, so long out of company that speaking came hard.",
    "Stammering, the hermit of Shadowgale offered a greeting and asked how the day was going.",
    "Friends and handmade things seemed enough for the hermit. Still, it was nice to talk to someone who talked back.",
    "Forest spirits tried to talk with the hermit, but only ever sang. A visitor who answered made a welcome change.")
q(93160, "The Forest's Bounty", "Zephras Isle", 13, "shadowgale", 2,
    "Acorns close to the hermit's home were gathered already. Raptor-birds roamed the rest of the forest floor.",
    "Rather than risk becoming a giant bird's lunch, the hermit offered to cook something tasty in return for acorns.",
    "The hermit swore the acorns were delicious roasted, and went off to cook them.",
    "With the acorns in, the roasting began.")
q(93172, "Free the Hollows", "Zephras Isle", 13, "shadowgale", 4,
    "Ghost-like spirits gathered at the old ruins northeast of the hermit's home. Some nights they seemed to sing something very sad.",
    "Something terrible had happened at the ruins, the hermit believed, and the spirits were trapped there.",
    "The hollows at the ruins were set free, and the hermit hoped they would find peace.",
    "The trapped spirits were released from the ruins, and the hermit gave quiet thanks.")
q(94896, "Aid For The Refugees", "Zephras Isle", 11, "banaethal", 3,
    "One night Ban'aethal, deep in Shadowgale Forest, had begun to fall into the sky. Its people fled with little more than their clothes.",
    "Ealaane and the other refugees could not go back to Ban'aethal, and hoped someone would recover what they had left behind.",
    "The recovered belongings would go back to their owners, Ealaane promised. It gave the refugees a place to start over.",
    "The belongings from Ban'aethal went back to the refugees, a small kindness after losing their home.",
    false, {"part1_corpus.txt #94896 (objective: collect 8)"})
q(94897, "The Fate of a Loved One", "Zephras Isle", 11, "banaethal", 5,
    "Resaan had gone back to Ban'aethal for supplies, though Ealaane begged him not to. A week had passed without word.",
    "Ealaane feared that Resaan, who had gone back to Ban'aethal, was dead. She asked that his heirloom be brought back if he was.",
    "When the heirloom came back, Ealaane wept. Their life together had only just begun, and now her home and her love were both gone.",
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
    "A scroll reeking of the Light had come to Deathknell for a newly risen paladin. Shadow Priest Sarvis asked that it be read well away from him.",
    "Paladins made Shadow Priest Sarvis uneasy, but the scroll he handed over sent a risen paladin to Aramis Hammerhand.",
    "Aramis Hammerhand said the training could begin in earnest. The Light would hurt now, and the pain, he said, was a crucible.",
    "Aramis warned against turning from the Light even for a moment, and urged that its pain be embraced.",
    false, {"LoreForever quest:98601 (wiki: World of Warcraft: Forever)"})
q(90902, "Rediscovering the Light", "Tirisfal Glades", 2, "risen", 4,
    "Another newly risen paladin had come to Aramis Hammerhand, who warned that healing with the Light would now hurt.",
    "Injured Deathguards near the chapel needed healing. Aramis taught that the only way past the pain of the Light was through it.",
    "The Forsaken were hardy to pain, Aramis said, and this pain was proof of still serving the Light.",
    "The injured Deathguards were healed, and Aramis called the pain that came with it a badge of honor.",
    false, {"part1_corpus.txt #90902 (objective: heal 5)", "LoreForever quest:90902 (wiki: World of Warcraft: Forever; Injured Deathguard)"})
q(91208, "Coming to Terms", "Tirisfal Glades", 4, "risen", 4,
    "A newly risen paladin had fled into the hills west of the chapel. She could not bear becoming what she had fought in life.",
    "Aramis hoped a kind word could lead the frightened paladin back into the Light, though many in her state turned violent.",
    "The frightened paladin could not be brought back. Aramis said a prayer for her, and called her end a clean one.",
    "Sometimes the best the Forsaken could give their risen was a clean end, Aramis said. He prayed to the Light for her.",
    false, {"LoreForever quest:91208 (wiki: World of Warcraft: Forever)"})
q(98389, "A Light in the Darkness", "Tirisfal Glades", 4, "risen", 3,
    "Some Forsaken feared their paladins would smite them as monsters, and Aramis meant to show otherwise.",
    "Freshly raised Forsaken were trapped by the spiders of Night Web's Hollow. Freeing them would prove what the paladins were for.",
    "The webbed Forsaken were freed. Aramis hoped Executor Arren and the others would see that the paladins lived to protect their people, as in life.",
    "Aramis believed the paladins would in time be seen as just as valuable to the Dark Lady as any other Forsaken.",
    false, {"LoreForever quest:98389 (wiki: World of Warcraft: Forever; Webbed Forsaken)"})
q(91209, "Continue Your Training", "Tirisfal Glades", 4, "risen", 3,
    "Risen paladins went on from Aramis to Shari Stilwell in {p:Brill}. Many in the Dark Lady's service distrusted those close to the Light, he warned.",
    "The lands of the Forsaken still needed protecting. Next, a paladin's training lay with Shari Stilwell in {p:Brill}.",
    "Shari Stilwell welcomed one more of their number. Once the people of {p:Brill} had seen proof of worth, she promised guidance.",
    "Shari Stilwell took over the training in {p:Brill}, where there was work for any paladin willing.",
    false, {"LoreForever quest:91209 (wiki: World of Warcraft: Forever; Aramis Hammerhand to Shari Stilwell)"})
q(91282, "A Second Home", "Tirisfal Glades", 11, "risen", 4,
    "Risen paladins were forming a new order at Bandarion Keep, a monastery on the bluffs of Northface Rock.",
    "Faith and fellowship would help the risen thrive, the paladins believed. Their new order held a keep northwest of the Solliden Farmstead.",
    "Breton Samuels of Bandarion Keep welcomed the new recruit to Tyr's Watch, as he called it.",
    "At Bandarion Keep, Breton Samuels took in another recruit.",
    false, {"part1_corpus.txt #91282 (Bandarion Keep; Breton Samuels)"})
q(91285, "Murlocs at the Gates", "Tirisfal Glades", 11, "risen", 2,
    "Vile Fin murlocs had once spawned where the keep now stood, and they had attacked it ever since the paladins drove them out.",
    "Breton Samuels found rebuilding the keep hard enough with murlocs lurking in the bluffs and around the lake.",
    "The murlocs were driven back for now. Breton Samuels hoped it would slow them, since rebuilding was hard enough without a spear in the back.",
    "The Vile Fin attacks would not stop entirely, Breton said, but the keep had some breathing room.",
    false, {"part1_corpus.txt #91285 (Vile Fin Attackers and Seers; Breton Samuels)"})
q(91294, "Touring the Grounds", "Tirisfal Glades", 11, "risen", 3,
    "With the murlocs under control, Breton Samuels encouraged a look around the keep before meeting its leader.",
    "Bandarion Keep was not much yet, Breton Samuels said, but it was home.",
    "Danitha Morr, the closest thing the keep had to a commander, offered fellowship to those still loyal to the Light.",
    "The keep's leader, Danitha Morr, welcomed help, for much work remained before the order was fully established.")
q(91316, "Making Repairs", "Tirisfal Glades", 11, "risen", 2,
    "Far from the Undercity, the keep was short of building materials, and an old root cellar in ruined Shadowvale might hold some.",
    "Imposing as the keep looked on its bluffs, the paladins admitted it was hard to supply so far from proper civilization.",
    "Sturdy lumber from Shadowvale reached the keep. More recruits would be sent to clear out the rest of the cellar.",
    "The Shadowvale cellar yielded its lumber, and the restoration of the keep could go on.",
    false, {"part1_corpus.txt #91316 (12 Sturdy Lumber from Shadowvale)"})
q(91317, "The Tarnished", "Tirisfal Glades", 12, "risen", 5,
    "Some risen paladins had carried their old prejudices into undeath. These Tarnished, holed up at Shadowvale, were killing other Forsaken.",
    "Every Forsaken the Tarnished killed made the people of the glades trust their paladins less. Bandarion Keep wanted their leader's head.",
    "Commander Rudolph Gelhardt's head was taken. It might help the order secure its place among the Forsaken, though acceptance could take decades.",
    "The Tarnished at Shadowvale were broken. Earning the Forsaken's trust, the order expected, could still take years.",
    false, {"part1_corpus.txt #91317 (Commander Rudolph Gelhardt)"})
q(95803, "A Token of Good Faith", "Undercity", 12, "risen", 6,
    "Sylvanas Windrunner mistrusted the paladins and all but openly disparaged them. Danitha Morr of Bandarion Keep sent her the Tarnished commander's head. It would show that the order kept its own house.",
    "Rudolph Gelhardt's head was a gift for the Dark Lady, proof of the paladins' devotion to the Forsaken.",
    "Sylvanas did not doubt Danitha's sincerity. Still, she expected more paladins to go mad and turn the Light on their own. The order would be watched.",
    "The Dark Lady received the head coldly. She might one day stop tolerating the order, she said, and told its paladins to serve diligently.",
    false, {"part1_corpus.txt #95803 (Rudolph Gelhardt's head to Sylvanas Windrunner)"}).highlight = {
    "Sylvanas took the head of the Tarnished paladins' commander, and warned that the risen paladins' order would be watched.",
    "The Dark Lady did not doubt the sincerity of Danitha Morr, leader of the risen paladins. One day, though, she might stop tolerating their order."}
q(96895, "The Argent Emissary", "Tirisfal Glades", 13, "argent", 3,
    "Two Forsaken emissaries of the Argent Dawn had passed through the glades. Not everyone liked them poking around unsupervised.",
    "One of the Argent emissaries had gone southeast, toward Scourge cultists snooping near the {p:Undercity}.",
    "Near the {p:Undercity}, the emissary was found watching a band of Scourge cultists, and warned to stay low.",
    "The emissary was found keeping watch on Scourge cultists, who were not to be trifled with.",
    false, {"part1_corpus.txt #96895"})
q(96896, "A Righteous Cause", "Tirisfal Glades", 13, "argent", 5,
    "When Naxxramas attacked the {p:Undercity}, Leonid Barthalomew the Revered had fought beside Danitha Morr and lost many friends.",
    "Garek Bandarion, after whom the keep was named, had died defending the {p:Undercity} from Naxxramas. He might have been the first Forsaken to wield the Light as a paladin.",
    "Leonid Barthalomew would stay a while among old friends. Then he would return to {p:Light's Hope Chapel}, where the Argent Dawn could always use more help.",
    "Leonid Barthalomew of the Argent Dawn saw Bandarion's legacy living on in Danitha Morr's order. He wished the rest of the Forsaken felt the same.",
    false, {"part1_corpus.txt #96896 (Danitha Morr and Leonid Barthalomew the Revered)"})
q(96897, "The Cult of the Damned", "Tirisfal Glades", 13, "argent", 3,
    "On the outskirts of the {p:Undercity}, the Cult of the Damned was at work. An Argent emissary wanted its cultists stopped.",
    "Between the mindless dead and the Scarlet Crusade, the glades had enough to deal with without the Scourge's living servants.",
    "The cultists were cut down. Only vigilance, the emissary warned, would keep Lordaeron's history from repeating.",
    "Dark Neophytes and Enforcers lay dead near the {p:Undercity}.",
    false, {"part1_corpus.txt #96897 (Dark Neophytes and Dark Enforcers)"})
q(96898, "Remnants of War", "Tirisfal Glades", 13, "argent", 4,
    "When Naxxramas bore down on the {p:Undercity}, the great necrotic crystal beneath the citadel had shattered. Its fragments lay scattered near the city.",
    "Most likely the cultists had come for the necrotic crystal fragments, and the Argent emissary meant to deny them.",
    "The most conspicuous fragments were gathered. Digging out the rest, the emissary expected, would keep the Forsaken busy for years.",
    "Twelve necrotic fragments were out of the Scourge's reach, and the cult's work near the {p:Undercity} was slowed.",
    false, {"part1_corpus.txt #96898 (12 Necrotic Crystal Fragments)"})
q(96899, "Bandarion Keep", "Tirisfal Glades", 13, "argent", 4,
    "Before the cultists turned up, the Argent emissary and his commander had been bound for Bandarion Keep.",
    "The emissary's commander, Leonid Barthalomew, waited at Bandarion Keep to the northwest.",
    "Leonid remembered the keep from the Argent Dawn's war against the Scourge in these glades. He was glad Danitha's paladins kept it now.",
    "Once the keep had been the Argent Dawn's, Leonid said. Danitha Morr had named it after a friend they shared.",
    false, {"part1_corpus.txt #96899 (Leonid Barthalomew at Bandarion Keep)"})
-- The order's errand in Silverpine (class quests, 22-26): Lumina Windsinger, a
-- Windshaper on Azeroth, and the Moonsilver Blade for Old Fire-Eye. Givers:
-- part1_corpus.txt objectives; LoreForever quest:91859 (Trevan Rol to
-- Deathguard Baldren). The seller of the Kor Gem lore in Ashenvale is unnamed.
q(91858, "Diplomatic Incident", "Silverpine Forest", 22, "lumina", 4,
    "Two dignitaries of the Earthen Ring had gone missing on their way to {p:Tarren Mill}. Danitha Morr saw a chance for the paladins of Bandarion Keep to prove their worth to the Horde.",
    "Rumor called the missing Earthen Ring travelers a diplomatic incident. Bandarion Keep's man at {p:the Sepulcher}, Trevan Rol, knew more.",
    "Trevan Rol already knew why Danitha had sent help, and called the business a damned fine mess.",
    "The search for the missing Earthen Ring travelers began at {p:the Sepulcher}, with Trevan Rol.",
    false, {"part1_corpus.txt #91858 (Trevan Rol at the Sepulcher)"})
q(91859, "A Curious Pair", "Silverpine Forest", 22, "lumina", 4,
    "No ordinary diplomats had gone missing. One was a tauren, and the other, Trevan would swear, a high elf.",
    "No one knew why an elf would travel with a tauren through Horde lands. Trevan sent the search on to Deathguard Baldren at the town's entrance.",
    "Deathguard Baldren cared little for paladins, but admitted the timing was impeccable.",
    "Deathguard Baldren had news to share, though he made no secret of his opinion of paladins.",
    false, {"LoreForever quest:91859 (wiki: World of Warcraft: Forever; Trevan Rol to Deathguard Baldren)"})
q(91860, "A Grim Fate", "Silverpine Forest", 22, "lumina", 4,
    "Gnolls had dumped a large body onto a pyre on {p:Fenris Isle}, Deathguard Baldren reported. He thought the elf was likely long dead.",
    "A lost cause, Baldren called the search, the kind paladins loved. He pointed the way to {p:Fenris Isle} anyway.",
    "The body on the pyre was a tauren's, heavily gnawed. There was no sign of the elf woman, and the fortress nearby might still hold her.",
    "Only the tauren had burned on the pyre. The elf might still be alive deeper in the fortress.",
    false, {"part1_corpus.txt #91860"})
q(91861, "Into Fenris Keep", "Silverpine Forest", 22, "lumina", 4,
    "Fenris Keep had to be searched for the missing elf.",
    "Somewhere in the fortress north of the pyre was the missing member of the Earthen Ring party.",
    "Deep in the keep, a captive asked whether her finder was one of the Forsaken. She begged to be freed while there was time.",
    "Caged and pleading for haste, the elf was found alive deep in the keep.",
    false, {"part1_corpus.txt #91861"})
q(91862, "Lumina Windsinger", "Silverpine Forest", 22, "lumina", 5,
    "The captive was no high elf. She was Lumina Windsinger, a Windshaper of the shen'dorei. As a guest of the Earthen Ring, she had come to study the elemental convergences of Arathi.",
    "Lumina Windsinger's cage key lay with the gnolls nearby, and she would tell the rest once safely away.",
    "Free at last, Lumina was not yet out of danger.",
    "The cage opened, and Lumina called the gnolls the second worst creatures she had met on Azeroth.",
    false, {"part1_corpus.txt #91862"})
q(96204, "The Windshaper's Wrath", "Silverpine Forest", 22, "lumina", 5,
    "Freed, Lumina meant to make the gnolls regret ever laying eyes on a Windshaper.",
    "Getting Lumina out of Fenris Keep was next, and she meant to make the gnolls pay on the way.",
    "At {p:the Sepulcher}, Lumina met Trevan. She had heard little good of paladins, but said they had a friend among the Windshapers.",
    "As a shen'dorei walking Horde lands, Lumina knew how easily prejudice took root. The paladins of Bandarion Keep, she said, had a friend among the Windshapers.",
    false, {"part1_corpus.txt #96204"}).highlight = {
    "Lumina Windsinger, the Windshaper held by the gnolls, was brought out of Fenris Keep. The paladins had gained a friend among the Windshapers.",
    "Lumina Windsinger reached the Sepulcher alive, and promised the paladins a friend among the Windshapers."}
q(95034, "The Debt", "Silverpine Forest", 24, "lumina", 5,
    "A worgen had been the first to attack Lumina and Banon on the road. Banon threw himself in its path and was badly bitten.",
    "Lumina wanted it known what had truly happened to Banon on the road through the forest.",
    "Pierced by gnoll blades and at the end of his strength, Banon had turned on Lumina. He still knew her, and could not stop himself. She swore on the sky to kill the creature that doomed him.",
    "Upon the sky, Lumina swore to see the worgen that doomed Banon dead, so it could never do the same to another.",
    false, {"part1_corpus.txt #95034"})
q(95036, "A Moon-Kissed Blade", "Silverpine Forest", 25, "lumina", 4,
    "The worgen that attacked Lumina was Old Fire-Eye, the biggest of his kind in the forest. Some magic kept him from staying dead.",
    "Putting Old Fire-Eye down would take a special weapon, and Trevan Rol had a list of what was needed to forge it.",
    "Trevan had the materials, and knew of a smith who could make the blade.",
    "The materials for the moon-kissed blade were gathered. Even the Light needed a good blade to guide, Trevan said.",
    false, {"part1_corpus.txt #95036 (Trevan Rol in the Sepulcher)"})
q(95042, "Seeking the Kor Gem", "Ashenvale", 25, "lumina", 3,
    "A scholar in the forest was amused to meet a Forsaken paladin. Kor Gems of the naga, the scholar said, could empower a weapon.",
    "The naga below {p:Blackfathom Deeps} still used Kor Gems, and the scholar warned against going alone.",
    "Naga witches had corrupted the gem. The scholar called the evil simple to dispel, and offered to buy the gem instead.",
    "To the scholar, the gem's corruption was simple to dispel, a shame given what might be learned from such power.",
    false, {"part1_corpus.txt #95042"})
q(95111, "An Underrated Talent", "Hillsbrad Foothills", 25, "lumina", 3,
    "Ott, a weaponsmith of {p:Tarren Mill}, sold plain blades to travelers. Yet smiths in the {p:Undercity} had once mistaken one of his swords for a master's work.",
    "Trevan wanted to give Ott, an unassuming orc, the chance to make something truly special.",
    "No one had ever asked Ott for a custom commission. He wondered why anyone would pass over the smiths of the {p:Undercity} for him.",
    "Ott accepted the commission. He made humble, honest weapons, he said, and sought no glory.",
    false, {"part1_corpus.txt #95111"})
q(95125, "Ott's Masterwork", "Hillsbrad Foothills", 25, "lumina", 4,
    "The materials were truly fine, Ott said. He hoped he could live up to the trust placed in him.",
    "With the materials in hand, Ott began to forge the blade.",
    "Ott called the blade his finest work, and said farewell in the orcish way.",
    "The blade was finished, the best Ott had ever made.")
q(95126, "The Moonsilver Blade", "Silverpine Forest", 25, "lumina", 4,
    "Back at {p:the Sepulcher}, Trevan Rol was to have the finished blade, with Ott's thanks for the chance.",
    "At {p:the Sepulcher}, Trevan waited to see whether Ott had managed the commission.",
    "Trevan inspected the Moonsilver Blade and declared it would do nicely. He had known Ott had it in him.",
    "The Moonsilver Blade passed Trevan's inspection. Only the beast remained.",
    false, {"part1_corpus.txt #95126"})
q(95140, "Old Fire-Eye", "Silverpine Forest", 26, "lumina", 6,
    "Old Fire-Eye hunted south of {p:the Sepulcher}, near the gates of Gilneas. The Moonsilver Blade had been made to end him.",
    "Lumina prayed the new blade would not fail against the worgen that had doomed Banon.",
    "Old Fire-Eye was destroyed, and Banon could rest in peace. Lumina laid a small measure of her people's magic on the bloodied blade.",
    "Lumina's oath was kept. She touched the bloodied blade with a little of her people's magic and prayed to the winds it would serve well.",
    false, {"part1_corpus.txt #95140 (Use the Moonsilver Blade to destroy Old Fire-Eye)"}).highlight = {
    "Old Fire-Eye fell to the Moonsilver Blade. Lumina Windsinger's oath for Banon, the tauren who had shielded her, was kept.",
    "With the worgen that doomed her fellow traveler Banon dead, Lumina Windsinger blessed the blade that killed it."}
P.threads.fv_lumina = "Lumina Windsinger and the Moonsilver Blade"
P.threads.fv_risen = "the risen paladins of Tirisfal"
P.threads.fv_argent = "the Argent Dawn in Tirisfal"

---------------------------------------------------------------- Westfall, Alba Fairmoon and the poisoned land (12-18)
-- Forever's Westfall chain: the poison in the soil traced from the wells to a
-- forge in the Deadmines. Givers: LoreForever quest:92742-92819 (Alba Fairmoon,
-- Sprite Jumpsprocket, Jasper Fel). 92819's verdict on Stormwind is Alba's own
-- and stays attributed. 93928 is a placeholder ("(PH) Thanks!") and is left out.
q(98021, "Journey to Sentinel Hill", "Westfall", 13, "alba", 3,
    "Newcomers who wished to do some good were sent from Stormwind to {p:Sentinel Hill}. The people there needed aid.",
    "To someone from another plane, the troubles of these farms might seem small. For the people living them, they meant everything.",
    "Gryan Stoutmantle had begged Stormwind for aid for months. All it sent, he grumbled, was a skinny elf, but beggars could not be choosers.",
    "Gryan Stoutmantle took the help Stormwind had sent and set about putting it to work.")
q(92742, "Testing the Wells", "Westfall", 12, "alba", 3,
    "Something was poisoning the land, and Alba Fairmoon meant to begin with the groundwater under the farms.",
    "Alba Fairmoon wanted water from the wells at the Jansen Stead and the Molsen Farm, to learn what was corrupting the land.",
    "The well samples went to Alba for testing.",
    "Now Alba had well water from two farms, the first step in finding the poison.")
-- Not in corpus_vanilla_quests.txt: the description comes from part1_corpus.txt
-- and the completion text was never captured, so the outcome stays minimal.
P.questIDs[92742].source = {"part1_corpus.txt quest 92742 (description only)"}
q(92744, "Murloc Gills", "Westfall", 12, "alba", 3,
    "Alba feared the corruption of the crops had reached the sea, and that tainted fish could bring famine to Stormwind.",
    "Murloc gills were sensitive to contaminants, and Alba meant to read the coast's seawater in them.",
    "For now the gills looked healthy. Alba would not let that make her complacent.",
    "By the evidence of the murloc gills, the coastal waters were still clean.")
q(92745, "The State of the Mines", "Westfall", 14, "alba", 3,
    "Toxic metals showed in the well samples. If the poisoning went on, it would be decades before crops grew in that soil again.",
    "The Defias held the mines and stripped them with creature labor. Alba wanted their miners at Jangolode and the Gold Coast Quarry cut down.",
    "The Defias miners were disrupted, but Alba feared the poison came from somewhere else.",
    "The miners at the {p:Jangolode Mine} and the Gold Coast Quarry were dealt with. Still, the source of the poison eluded Alba.")
q(92747, "Moonbrook Espionage", "Westfall", 16, "alba", 4,
    "None of the mines already searched held the source of the poison. That left the Deadmines beneath {p:Moonbrook}, abandoned since the First War.",
    "Alba wanted evidence from {p:Moonbrook} that the old Deadmines were working again.",
    "Industrial supplies came back from the town, and Alba asked what it all was.",
    "Moonbrook yielded a haul of suspicious industrial supplies for Alba to look over.",
    false, {"LoreForever quest:92747 (wiki: World of Warcraft: Forever; Suspicious Industrial Supplies)"})
q(92748, "Explosive Consultation", "Westfall", 16, "alba", 3,
    "Supplies from {p:Moonbrook} pointed to a massive industrial operation in the Deadmines, and to the source of the toxins.",
    "Whatever lay in the Deadmines would be hard to destroy. Alba wanted explosives from an engineer in Stormwind.",
    "In the Dwarven District, Sprite Jumpsprocket asked whether something needed blowing up.",
    "Sprite Jumpsprocket, an engineer of the Dwarven District, was ready to listen.",
    true, {"LoreForever quest:92748 (wiki: World of Warcraft: Forever; Alba Fairmoon to Sprite Jumpsprocket)"})
q(92749, "A Dynamite Plan", "Westfall", 16, "alba", 3,
    "Industrial sabotage caught Sprite Jumpsprocket's attention, and the plan began with dynamite.",
    "Sprite needed coarse dynamite for the bomb meant for the Deadmines.",
    "The dynamite was a great start, Sprite said, and needed only tying together and a little extra zing.",
    "With the dynamite in hand, Sprite set about building something with more zing.",
    false, {"LoreForever quest:92749 (wiki: World of Warcraft: Forever; Coarse Dynamite)"})
q(92750, "Detonation at a Distance", "Westfall", 16, "alba", 3,
    "For a remote detonator, Sprite suggested the sneaky folk of Stormwind Intelligence.",
    "A controlled explosion meant keeping all one's limbs, and that needed a remote detonator.",
    "At Stormwind Intelligence, Jasper Fel asked whether something specific was wanted.",
    "Stormwind Intelligence had been found, and Jasper Fel was listening.",
    true, {"LoreForever quest:92750 (wiki: World of Warcraft: Forever; Sprite Jumpsprocket to Jasper Fel)"})
q(92751, "Detonation at a Distance", "Westfall", 16, "alba", 4,
    "News of the search in {p:Moonbrook} had already reached Jasper Fel. He offered a prototype remote detonator, and asked that his part be kept from the elf.",
    "Being well outside the caves before any explosion was Jasper Fel's advice. With it came his engineers' newest detonator.",
    "Sprite was delighted, for it was just the detonator they needed.",
    "The prototype detonator reached Sprite, and the bomb could be finished.",
    true, {"LoreForever quest:92751 (wiki: World of Warcraft: Forever; Jasper Fel to Sprite Jumpsprocket)"})
q(92752, "Explosive Consultation", "Westfall", 16, "alba", 3,
    "Sprite's bomb was ready, and the detonator with it.",
    "With the bomb finished, Alba Fairmoon waited to hear of it.",
    "The bomb and its detonator came back, and Alba was glad to see them.",
    "The bomb reached Alba, ready for the Deadmines.",
    true, {"LoreForever quest:92752 (wiki: World of Warcraft: Forever; Sprite Jumpsprocket to Alba Fairmoon)"})
q(92753, "Destruction in Deadmines", "The Deadmines", 18, "alba", 5,
    "Alba believed the poison came from a large forge hidden in the mines, where the explosives had to be placed.",
    "Alba would wait in the hills behind {p:Moonbrook} until the forge was found and the bomb set. With the forge gone, the land might begin to heal.",
    "The forge was found and the bomb planted. Only the detonation remained.",
    "At the hidden forge the bomb lay ready, and Alba waited for the last step.",
    true)
q(92819, "Destruction in Deadmines", "Westfall", 18, "alba", 6,
    "With the bomb planted at the forge, all that was left was the detonator.",
    "In the hills, Alba Fairmoon waited for the end of it.",
    "The detonator was used and the forge destroyed. Alba could hardly believe that Stormwind would put its military ambitions before the livelihood of its people.",
    "The forge was gone. Alba was left with a bitter thought, that Stormwind had put its military ambitions over its own people.",
    true).highlight = {
    "The forge poisoning the land beneath {p:Moonbrook} was destroyed. Alba Fairmoon, who had hunted it down, saw Stormwind's military ambitions behind the poison.",
    "Blown apart in the Deadmines, the forge that poisoned the farmland was gone. Alba Fairmoon could hardly believe what Stormwind had put before its people."}
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
    "A tinkerer from Ironforge had come to recalibrate the harvest golems on the farms. Instead they had chased the poor tinkerer into a stable.",
    "Isosprings and gyrostabilizers from the harvesters could build a device to cover an escape from the stable.",
    "The tinkerer had the parts and set to work on an escape plan.",
    "The harvester parts reached the stable, and the escape plan could begin.",
    true)
q(92910, "Harvesting the Harvesters", "Westfall", 15, "harvesters", 2,
    "A part salvaged from a harvester was mostly intact, and someone interested in harvest golems would want to see it.",
    "Harvest golems on the farms had turned aggressive, and an intact piece of one was worth studying.",
    "The tinkerer from Ironforge took the salvaged part and looked it over.",
    "The salvaged assembly reached the tinkerer, who wanted to know what it was.",
    true)
q(92911, "Harvesting the Harvesters", "Westfall", 15, "harvesters", 3,
    "From the salvaged assembly, the tinkerer learned what made the harvesters tick. It gave an idea for overriding them, at least for a moment.",
    "More parts were needed for a device against the harvesters.",
    "The device was ready to try. Its maker would stay behind in the stable, which was starting to feel like home.",
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
    "Sirra Von'Indi kept a library in {p:Darkshire}, but had almost nothing on Raven Hill. Its history had died with its people.",
    "Sirra wanted Darkshire's heroes remembered as well as its foes, and asked for anything found at Raven Hill.",
    "The tome from Raven Hill was about the Valor family. Sirra had heard of a few of them, good folk, and made a copy.",
    "Whether the Valors merited a whole tome, Sirra doubted. Still, she copied it and asked for anything else about them.",
    true, {"part1_corpus.txt #96139 (Sirra Von'Indi in Darkshire)"})
q(96138, "Merrick's Bow", "Duskwood", 28, "valor", 3,
    "The spirit of Merrick Valor, a Watcher who had kept the roads safe, had left a bow behind. It hinted at his unfinished business.",
    "Merrick Valor's spirit wandered the roads near Raven Hill. Perhaps the Splint Fist ogres south of town were what troubled it.",
    "The Splint Fist warriors and taskmasters south of Raven Hill were cut down. Sirra Von'Indi heard of it in {p:Darkshire}.",
    "The ogres near Merrick's old home were dealt with, and Sirra Von'Indi was told.",
    false, {"part1_corpus.txt #96138 (8 Splint Fist Warriors, 4 Taskmasters; Sirra Von'Indi)"})
q(98447, "The Valor Family", "Duskwood", 27, "valor", 4,
    "Even with the Valor ghosts put down, the attacks around Raven Hill had not stopped. Their unfinished business, Sirra suspected, was still unsettled.",
    "All the Valors had vanished at once, Sirra believed, and she hoped their weapons would stir something at Raven Hill.",
    "The cause of the Valor ghosts was found at Raven Hill, as Sirra had hoped.",
    "At Raven Hill, the source of the Valor family's ghosts came to light for Sirra Von'Indi.",
    true, {"part1_corpus.txt #98447 (objective only: find the cause of the Valor family ghosts)"})
fallback("The Valor Family", "Duskwood", "valor", "96139, 98447",
    "Sirra Von'Indi of {p:Darkshire} wanted the Valor family of Raven Hill remembered.",
    "Raven Hill's history had died with its people, and Sirra searched for what was left of it.",
    "Sirra's search into the Valor family moved forward.",
    "One more piece of the Valors' history reached Sirra.")
q(98190, "A Friend of the Family", "Wetlands", 25, "terenas", 4,
    "A statuette of King Terenas had come to {p:Menethil Harbor}, and its keepers feared the Dragonmaw would loot it.",
    "Menethil was a calm harbor in a storm of enemies. From there the statuette was to go straight to Highlord Fordragon in {p:Stormwind}.",
    "The statuette reached Highlord Bolvar Fordragon in {p:Stormwind}.",
    "Bolvar Fordragon had the statuette, delivered past every rung of the chain of command.",
    true, {"LoreForever quest:98190 (wiki: World of Warcraft: Forever; to Highlord Bolvar Fordragon)"})
q(98191, "A Friend of the Family", "Stormwind City", 25, "terenas", 4,
    "Terenas had been a humble king who hated memorials, and few had survived Lordaeron's fall. In this one, the Light seemed to have gathered.",
    "By the Highlord's wish, the statuette was to be kept in the Cathedral of Light, with Lord Grayson Shadowbreaker.",
    "Lord Grayson Shadowbreaker took it into the Cathedral's safekeeping.",
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
    "Senir Whitebeard had sent mountaineers to learn about the wendigos spreading through the hills, and one of his reports had never come back.",
    "Whitebeard was late with his reports to Ironforge, and wanted someone to check on Mountaineer Gretchen west of town.",
    "Mountaineer Gretchen had Whitebeard's report, and called the whole situation a mess.",
    "Mountaineer Gretchen was found west of town, with news of a mess in the hills.",
    true, {"part1_corpus.txt #98322"})
q(98319, "Secure the Mountain", "Dun Morogh", 8, "grizzled", 4,
    "Wendigos had filled the Grizzled Den, and Gretchen's partner Cornelius had charged in head first.",
    "Without her partner Cornelius, Gretchen could not finish Whitebeard's report, and he had charged into the Grizzled Den head first.",
    "Cornelius was found in the den, and Gretchen grieved for the brave fool. They had their report, she said.",
    "The search for Cornelius ended in the Grizzled Den, and Gretchen had her answer for Whitebeard.",
    true, {"part1_corpus.txt #98319 (Mountaineer Cornelius in the Grizzled Den)"})
q(98323, "Secure the Mountain", "Dun Morogh", 8, "grizzled", 4,
    "Gretchen would send no one else into the Grizzled Den. Her letter for Senir Whitebeard called the cave a lost cause.",
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
    "The ore was back with Flintfire, and at least the miners had all got out alive.",
    false, {"part1_corpus.txt #98321"})
q(98326, "Frosthowl", "Dun Morogh", 9, "grizzled", 3,
    "A wendigo called Frosthowl had stolen a sack of fish that had taken days to catch on the frozen lake.",
    "Paxton the fisherman had fished the frozen lake for days. His wife could not bear to tell him the whole catch was lost to a wendigo.",
    "The fish came back from the Grizzled Den. Paxton would not have to spend another night on the lake, and there might be a real feast.",
    "Frosthowl was dead and the catch recovered, sparing Paxton's wife an awkward confession.",
    false, {"part1_corpus.txt #98326 (Frosthowl in the Grizzled Den)"})
q(99158, "Dawn in the Mountains", "Dun Morogh", 8, "gavin", 2,
    "Father Gavin of the Argent Dawn had fixed up an old building in the peaks as a rest for travelers. A shipment of holy candles was due to him.",
    "Father Gavin was a priest who would rather heal than fight. He lived in a hermitage among the mountains.",
    "The candles from Ironforge reached Father Gavin, one of the few things his hermitage needed from the city.",
    "The priest took the holy candles gladly. He lived mostly on his own, he said, but valued a few gifts from the city.")
q(99159, "Finding Warmth", "Dun Morogh", 8, "gavin", 2,
    "Father Gavin's hearth was open to any soul, but he had been too busy to gather firewood.",
    "Firewood was needed at the hermitage, and Father Gavin had other tasks on his mind.",
    "The firewood was stacked at the hermitage, the wet pieces left to dry.",
    "With his firewood in, the priest had more tasks for anyone willing.",
    false, {"part1_corpus.txt #99159 (14 pieces of firewood)"})
q(99160, "Rime's Wrath", "Dun Morogh", 8, "gavin", 3,
    "A shelf of rock and ice had fallen from the peaks and riled the elementals near Father Gavin's hermitage.",
    "Even without the elements taking form, the frozen road was treacherous. Father Gavin was no longer one for fighting.",
    "The elementals were put down. Father Gavin wished they could have been calmed instead, but they had been too dangerous to leave.",
    "The road near the hermitage was safer, though Father Gavin regretted that the spirits could not simply be placated.",
    true)
q(99161, "Rime's Wrath", "Dun Morogh", 8, "gavin", 4,
    "Larger than the rest, the first elemental to appear after the rockslide was one Father Gavin called Avala. It seemed to cause the sudden weather and the smaller slides.",
    "To Father Gavin, Avala had to be killed, and its core brought back as proof.",
    "Avala's core reached Father Gavin, who hoped the peaks would now claim fewer lives.",
    "With Avala dead, Father Gavin blessed the work that made the mountain road safer.",
    true)
fallback("Rime's Wrath", "Dun Morogh", "gavin", "99160, 99161",
    "A rockslide in the peaks of {p:Dun Morogh} had stirred the elementals near Father Gavin's hermitage.",
    "Father Gavin wanted the mountain road made safe from the restless elementals.",
    "Part of the trouble with the elementals was dealt with.",
    "The road near the hermitage was a little safer.")
q(99162, "Treacherous Cold", "Dun Morogh", 8, "gavin", 4,
    "After every slide, Father Gavin searched for survivors or victims, praying there was nothing to find. Now the restless elements kept him close to home.",
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
    "The pendants' binding spells were stripped away. It was a shame about the slain trolls, but their spirits could rest now.",
    "With the binding spells removed from the pendants, the spirits of Zalazane's thralls could rest.")
q(96874, "This Is Spinal Axe", "Durotar", 10, "durotar", 2,
    "Ug'thok of {p:Orgrimmar} thought the spines of the Thunder Ridge beasts would make a mighty axe head. Saru had laughed at him.",
    "Ug'thok's smithing lesson called for weathered spines from Thunder Ridge and rough grinding stones to sharpen them.",
    "The spines were tougher than Ug'thok expected. His axe might not come easily, but he would keep working on it.",
    "Ug'thok had his spines and grinding stones, and a harder job ahead than he had thought.",
    false, {"part1_corpus.txt #96874 (Ug'thok in Orgrimmar)"})
q(96875, "Beasts of Thunder Ridge", "Durotar", 10, "durotar", 2,
    "As Orgrimmar grew, Kamari supplied its peons with lizard hides from Thunder Ridge for the walls and roofs.",
    "A test of skill with leather, Kamari's task called for rough lizard hides and a few cured light hides.",
    "The hides went into Orgrimmar's new buildings. Kamari said the city grew with that work.",
    "Kamari took the hides for the builders, and called it work that helped Orgrimmar grow.",
    false, {"part1_corpus.txt #96875 (Kamari in Orgrimmar)"})
q(96877, "Halikor's Hoof", "Durotar", 12, "durotar", 3,
    "Halikor's enormous hoof was proof of victory over the mighty lizard of Thunder Ridge.",
    "Halikor had left behind a hoof big enough to make a fine trophy.",
    "The hoof drew admiration as a fine trophy, and talk of what a fight it must have been.",
    "The hoof was handed over and admired.")
q(97275, "Whuut's the Rush", "Orgrimmar", 15, "durotar", 2,
    "Whuut was an alchemy prodigy who burned through the rarest reagents without learning the basics. Yelmak wanted to slow him down.",
    "Yelmak brewed a potion from common plants by a quick tonic method. It was meant to show Whuut what careful work could do.",
    "Whuut was astonished that Yelmak's potion used only speargrass and cattail. Perhaps, he began to think, he had skipped too far ahead.",
    "Whuut took Yelmak's lesson to heart. There might be much he had missed by starting with the rarest flora.")
q(99108, "Sparring Match", "Mulgore", 6, "durotar", 2,
    "In the arena of the young, it did not matter who one's mother was or whether one fought with sword or bow.",
    "Any young one willing to face the novices could have a lesson in direct combat from the arena's teacher.",
    "The teacher was honored by the fight, and saw hope in the new generation.",
    "With the sparring done, the teacher handed over something to tend the wounds, for many more battles lay ahead.")
q(99123, "Lost in the Shadows", "Durotar", 8, "durotar", 3,
    "Scouting the crag alone, Pal'juh had run out of magic at the wrong moment and been stuck hiding ever since.",
    "A hunter named Pal'juh was trapped in the crag and needed help to escape.",
    "Out of the crag at last, Pal'juh was safe. It was not the first trouble she had found by going alone.",
    "Pal'juh was safe now, a promising hunter who tended to act more like a raptor than a tiger.",
    false, {"part1_corpus.txt #99123"})
q(98545, "Leonid's Letter", "Tirisfal Glades", 13, "argent", 3,
    "Leonid Barthalomew had a colorful history with the Dark Lady. He wanted a neutral hand to carry his letter to an old friend in the {p:Undercity}.",
    "Leonid's letter was for Glix Xizzix, a goblin of the Trade Quarter, who Leonid said would pay for the trouble.",
    "Glix Xizzix had not seen Leonid since Naxxramas rained hell on their heads. He took the letter, and grudgingly paid with junk from the lost and found.",
    "The old friend, Glix, took the letter. He had never agreed to any tip, but offered a pick from the lost and found.",
    false, {"part1_corpus.txt #98545 (Glix Xizzix in the Undercity)"})
q(98362, "To Thunder Bluff", "Thunder Bluff", 20, "durotar", 4,
    "Dendrite Starblaze sent a young druid back to Turak Runetotem to learn the shape of the cat.",
    "The trial of the Great Cat Spirit was done, and the lessons now led back to the druid's teacher.",
    "Turak Runetotem sensed the trial had been passed, and began teaching the cat's shape.",
    "Turak was proud. Every druid had to pass the Great Cat Spirit's trial, he said, and now came the cat's shape.",
    false, {"LoreForever quest:98362 (wiki: World of Warcraft: Forever; Dendrite Starblaze to Turak Runetotem)"})
q(97003, "Chol'aruk the Ravener", "The Barrens", 21, "durotar", 4,
    "Among the Razormane, there was talk of Chol'aruk the Ravener, a quilboar five times the size of any other. It laired in a cave at Thorn Hill.",
    "Most doubted the tales of Chol'aruk. The veteran who asked had fought one of its kind, and it had taken six fighters to bring it down.",
    "Chol'aruk's head would go to {p:Orgrimmar} with the veteran, so none would doubt his tales again. He would speak loudly of who had earned it.",
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
    "The log came back to camp. Gozwin would have one less thing to fret over, Grund said. Now he could put his energy into getting back on his feet.",
    "The log for Gozwin's mecha-walker came back from the hills. Grund was not surprised that the leopard had been after the boar they were roasting.",
    false, {"part1_corpus.txt #97277 (cat 77; camp in the northwestern hills)", "LoreForever quest:97277 (wiki: World of Warcraft: Forever; Grund a dwarf, Gozwin a gnome)"})
P.threads.fv_dunmorogh = "the camps in the hills of Dun Morogh"

-- Elwynn: Crystal Lake's fisherman and Remy "Two Times" (#99127 to #99131).
-- The giver of 99127-99129 is the fisherman Jason Mathers, per Lore Forever and
-- 99131; Lee only set the traps.
q(99127, "A Net Disaster", "Elwynn Forest", 7, "crystallake", 2,
    "A fisherman at {p:Crystal Lake} had not seen a single minnow in the water, and his hooks kept coming up empty.",
    "Lee had set traps in {p:Crystal Lake} overnight. The fisherman who depended on them wanted to know if anything had been caught.",
    "Every one of Lee's nets had been damaged. The fisherman saw that his new neighbors on the lake were doing more harm than anyone had known.",
    "Whatever had been at the nets was doing real damage. The fisherman feared he would go broke unless something was done.",
    false, {"LoreForever quest:99127 (wiki: World of Warcraft: Forever; Crystal Lake)"})
q(99128, "Slimy Menace", "Elwynn Forest", 7, "crystallake", 2,
    "Murlocs on the far side of {p:Crystal Lake} were to blame, the fisherman said. Soon, he feared, there would be no fish left in it.",
    "Murlocs across {p:Crystal Lake} had a vicious temper and teeth to match, and the fishing was suffering for it.",
    "The murlocs across the lake were thinned out. Still, the fisherman could hear their warbling, and expected their numbers back soon enough.",
    "That would slow the murlocs down, the fisherman said, though he had no doubt they would make up their numbers quickly.",
    false, {"LoreForever quest:99128 (wiki: World of Warcraft: Forever; Crystal Lake, Elwynn Forest)"})
q(99129, "A Man About a Murloc", "Elwynn Forest", 7, "crystallake", 2,
    "Jason Mathers, the fisherman at {p:Crystal Lake}, hoped Remy in {p:Goldshire} had some idea how to keep the murlocs away from his fish.",
    "Remy hated murlocs as much as Jason Mathers did. He might know how to keep them off the lake, the fisherman thought.",
    "Remy had been warning the guards about the murlocs, and they would not listen. He had a few ideas of his own for getting back at them.",
    "The guards had ignored Remy's warnings, so he meant to deal with the murlocs himself, once he had what he needed.",
    false, {"LoreForever quest:99129 (wiki: World of Warcraft: Forever; Jason to Remy Two Times)"})
q(99130, "An Enticing Offer", "Elwynn Forest", 7, "crystallake", 2,
    "Duskweed grew on the farms near {p:Goldshire}, and in large amounts its petals were toxic to most animals. Remy meant to turn it into murloc bait.",
    "Remy's plan against the murlocs was bait made from duskweed, which would clear a few farmers' fields in the bargain.",
    "The bait was simple, Remy said, but safe enough as long as nobody's pet got into it. He wanted Jason told not to eat any.",
    "The duskweed became murloc bait. Remy's only warning was that Jason should not eat it.",
    false, {"part1_corpus.txt #99130 (cat 12, Elwynn Forest; ingredients for murloc bait)"})
q(99131, "Baited for Success", "Elwynn Forest", 7, "crystallake", 3,
    "Later that day, Jason Mathers could pick up Remy's murloc bait, along with advice on how to use it.",
    "Remy hoped the bait would let Mathers sell his fish again, and leave fewer murlocs in the world.",
    "Mathers did not mind poisoned bait, as long as the fish would not eat it. He meant to visit Remy later to collect it.",
    "Mathers had his answer to the murlocs. As long as the fish left the poison alone, he hoped to sell his catch again.",
    false, {"LoreForever quest:99131 (wiki: World of Warcraft: Forever; Remy to Jason Mathers)"})
P.threads.fv_crystallake = "the murlocs of Crystal Lake"
-- 99143's angler is unnamed; Elwynn per the coordinator's zone check.
q(99143, "Bottles and Baubles", "Elwynn Forest", 7, "elwynn", 2,
    "An angler reasoned that murlocs must think like fish, so anything the murlocs liked, the fish would like too.",
    "Heaps of junk lay in the murlocs' camps, and an angler wanted anything there that might make good bait.",
    "The angler called the junk an interesting collection that should work well enough, and gave some older fishing supplies in return.",
    "The murlocs' baubles would serve as bait, the angler said. In return came old supplies for anyone finding their footing in fishing.",
    false, {"LoreForever quest:99143 (wiki: World of Warcraft: Forever; an angler and murloc junk)"})
P.threads.fv_elwynn = "small troubles around Elwynn Forest"

-- Tirisfal: Executor Zygand's Deathguard (#99134, #99141; Lore Forever names
-- the giver), Bareth Dawnstone of Bandarion Keep (#99144), and the Scourge
-- beneath Shadowvale (#99152 Hilda the Breaker, #99153 Ephram Barbaro).
q(99134, "Discipline", "Tirisfal Glades", 6, "zygand", 2,
    "Executor Zygand in {p:Brill} kept a ledger of Deathguards who had disappointed him. He wanted someone from outside the guard to punish them.",
    "Executor Zygand preferred an outsider for the work. Anyone who was not of the Deathguard had not yet had a chance to disappoint him.",
    "Pain was chief among the few delights left to the dead, Zygand said. The punishment pleased him, and so, he said, it pleased the Dark Lady.",
    "The Deathguards on Zygand's ledger had been punished. There might be further use for such work, the executor hinted.",
    false, {"LoreForever quest:99134 (wiki: World of Warcraft: Forever; Executor Zygand)"})
q(99141, "Patience", "Tirisfal Glades", 6, "zygand", 3,
    "Reports from several of Executor Zygand's Deathguards were overdue, and his patience had run out.",
    "Deathguard Dillinger by the graveyard and Deathguard Kristof at the waystation owed Executor Zygand reports. So did Gordo, an abomination who wandered near Stillwater Pond.",
    "The reports reached Zygand. Gordo's was of no use, and the executor wanted his lapse in trusting an abomination with a pen kept quiet.",
    "Zygand had his overdue reports at last, and allowed that there might be hope yet.",
    false, {"part1_corpus.txt #99141 (cat 85; Dillinger, Kristof and Gordo)", "LoreForever quest:99141 (wiki: World of Warcraft: Forever; Executor Zygand)"})
P.threads.fv_zygand = "Executor Zygand's Deathguard"
q(99144, "Seeking Refuge", "Tirisfal Glades", 7, "risen", 4,
    "Bareth Dawnstone, a risen paladin, had been captured on his way from Bandarion Keep to Shari Stilwell in {p:Brill}. His captors wielded the Light with hatred in their hearts.",
    "Bareth Dawnstone knew some still took issue with risen paladins, but swore their intentions were pure. He needed help to escape the zealots who held him.",
    "Dawnstone got away. His order was still taking root in the glades, and losing one so promising would have been a heavy blow.",
    "Bareth Dawnstone was free. His order welcomed any who sought guidance in the Light. Bandarion Keep stood on the bluffs northwest of the Solliden Farmstead.",
    false, {"part1_corpus.txt #99144 (cat 85; help Bareth Dawnstone)", "LoreForever quest:99144 (wiki: World of Warcraft: Forever; captured at Crusader's Outpost)"})
q(99152, "As Above, So Below", "Tirisfal Glades", 10, "shadowvale", 4,
    "Hilda the Breaker feared the cellars beneath Shadowvale would fester into a Scourge uprising against Bandarion Keep.",
    "There was trouble enough with the Tarnished in Shadowvale. Hilda the Breaker wanted bones from the Scourge below the town, still glowing with their first reanimation magic.",
    "With the glowing bones in hand, Hilda hoped to learn how the threat below the town had gone unnoticed for so long.",
    "The bones from the cellars went to Hilda. She meant to study how the Scourge had gathered beneath Shadowvale unseen.",
    false, {"part1_corpus.txt #99152 (cat 85; 6 bones beneath Shadowvale)", "LoreForever quest:99152 (wiki: World of Warcraft: Forever; Hilda the Breaker at Bandarion Keep)"})
q(99153, "The One That Got Away", "Tirisfal Glades", 10, "shadowvale", 4,
    "A cultist had slipped away from the remnants of the battle with Naxxramas, carrying a piece of a focusing crystal. It still had power in it.",
    "Ephram Barbaro believed the crystal fragment was somewhere beneath Shadowvale, either raising the dead or making them stronger.",
    "The hidden crystal fragment was found beneath Shadowvale, quickly enough to please Ephram Barbaro.",
    "The fragment was out of hiding before its power could get out of hand.",
    false, {"part1_corpus.txt #99153 (cat 85; Hidden Crystal Fragment beneath Shadowvale)", "LoreForever quest:99153 (wiki: World of Warcraft: Forever; Ephram Barbaro)"})
P.threads.fv_shadowvale = "the Scourge beneath Shadowvale"

-- Silverpine: the offering stone at Beren's Peril (#95884, #95883, #95885, in
-- that order). Object quests: nobody gives them, and the ritual's purpose is
-- never told, so the lines keep it unknown.
q(95884, "The Offering Stone", "Silverpine Forest", 23, "berens", 3,
    "A scrap of note, mostly illegible, spoke of preparations for an offering and a ritual at an offering stone.",
    "Someone had been preparing a ritual in Beren's Peril. A worn note pointed to an offering stone close by.",
    "The offering stone was found, its rough surface littered with strange implements.",
    "The stone named in the note was found, strange items scattered across it.",
    false, {"part1_corpus.txt #95884 (cat 130; the Offering Stone in Beren's Peril)"})
q(95883, "The Tortured Soul", "Silverpine Forest", 23, "berens", 3,
    "Whoever set the ritual on the offering stone had assembled it hastily. By the note's account it lacked only an offering of blood and a tortured soul.",
    "Around Beren's Peril, the undead looked tortured enough to supply the soul the ritual still needed.",
    "Brought to the offering stone, the tortured soul gave off a foul energy, and the ritual drew closer to its end.",
    "Once the tortured soul reached the offering stone, a foul energy stirred in its presence.",
    false, {"part1_corpus.txt #95883 (cat 130)"})
q(95885, "The Offering of Blood", "Silverpine Forest", 23, "berens", 4,
    "All the ritual still needed was an offering of blood. A willing sacrifice, the note called it.",
    "Blood, freely given, was the last step at the offering stone in Beren's Peril, by the note's account.",
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
    "A kobold had dropped a volume that looked half eaten. It seemed to belong to the small library Brother Paxton kept in the abbey.",
    "Kept inside {p:Northshire Abbey}, Brother Paxton's library seemed to be where the nibbled volume belonged.",
    "Brother Paxton recognized his volume and feared the kobolds were stealing his collection again, to eat it.",
    "One volume was back on Paxton's shelf. The rest of his collection was still missing.",
    false, {"part1_corpus.txt #91741 (cat 12; return the book to Brother Paxton)"})
q(92124, "Book Inventory", "Elwynn Forest", 2, "paxton", 2,
    "To count his missing books, Brother Paxton sent help to Daniel, an assistant more interested in the trade professions than in his duties.",
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
    "Kelsey Fargo, a new mining apprentice, worked just outside the tunnels. She had probably seen what the kobolds were doing with the books.",
    "Right outside the kobolds' tunnels worked Kelsey Fargo, a mining apprentice who might teach a little mining besides.",
    "Kelsey had seen kobolds running back and forth with books and yelling at each other. She thought they were stealing from the library in the abbey.",
    "Kelsey Fargo confirmed it. Kobolds were hauling books out of the abbey's library.",
    false, {"LoreForever quest:91745 (wiki: World of Warcraft: Forever; Kelsey Fargo at Echo Ridge Mine)"})
q(91752, "The Big Picture", "Elwynn Forest", 3, "paxton", 3,
    "Now and then a kobold came out of the tunnels yelling about pictures for Narf. Kelsey Fargo guessed Narf was a leader deep inside, with a whole sack of books.",
    "A kobold called Narf kept a sack of stolen books at the back of the tunnels. The kobolds there were a good deal meaner than those outside.",
    "Marshal McBride took the stolen books and promised to get them back to Brother Paxton at once.",
    "Narf's sack of books reached Marshal McBride, bound for Brother Paxton's shelves.",
    false, {"part1_corpus.txt #91752 (cat 12; type 1)", "LoreForever quest:91752 (wiki: World of Warcraft: Forever; Shinyfinder Narf, Marshal McBride)"})
q(91758, "Follow That Kobold!", "Elwynn Forest", 4, "paxton", 2,
    "Another kobold had left the tunnels with a large sack of books, Kelsey reported. Marshal McBride wanted it tracked down.",
    "Tordrin Sternblade, a hunter trainer newly arrived from {p:Ironforge}, kept to the stable behind the abbey. McBride thought he could help track the kobold thief.",
    "Tordrin agreed, and set about making something for the hunt.",
    "Tordrin Sternblade was ready to whip up something to follow the kobold's trail.")
q(91772, "Shhh! We're Hunting Kobolds", "Elwynn Forest", 4, "paxton", 3,
    "A tracking kit from Tordrin could follow the kobold that worried Marshal McBride. Tordrin suspected the thieves were up to something outside {p:Northshire}.",
    "Kobold tracks led out of {p:Northshire}, and Tordrin wanted whatever they showed taken to Marshal Dughan in {p:Goldshire}.",
    "Dughan was unimpressed. Of course the kobolds were headed for the {p:Fargodeep Mine}, he said, and someone would have to deal with that.",
    "By Dughan's reckoning the tracks led to the {p:Fargodeep Mine}, which he called infested with kobolds.",
    false, {"part1_corpus.txt #91772 (cat 12; follow the tracks and report to Marshal Dughan)"})
q(91775, "Book Return", "Elwynn Forest", 6, "paxton", 3,
    "Brother Paxton's books had gone to the {p:Fargodeep Mine}. He worried most about one called Fun with Elementals, which he thought even a kobold could use to summon a servant.",
    "Marshal Dughan sent a bag for the books down into the {p:Fargodeep Mine}. The kobolds had taken more of Paxton's library there.",
    "By Paxton's list, most of the missing books were found. The rest had likely gone to the {p:Jasperlode Mine}.",
    "Most of Paxton's books came out of Fargodeep. Only the last few were still unaccounted for, probably in Jasperlode.",
    false, {"part1_corpus.txt #91775 (cat 12; type 1)", "LoreForever quest:91775 (wiki: World of Warcraft: Forever; Marshal Dughan)"})
q(91777, "Rare Books", "Elwynn Forest", 7, "paxton", 4,
    "Of Brother Paxton's books, two were still unaccounted for. One was on geomancy, the other explained arcane magic in simple words.",
    "Even an apprentice kobold might summon an elemental from one of Paxton's books. There was no telling what its master at the {p:Jasperlode Mine} could do.",
    "Brother Paxton had his library back. He gave away one of the weapons meant for the militia in thanks.",
    "The last two books came home to {p:Northshire Abbey}, and Paxton said his library was saved.",
    false, {"part1_corpus.txt #91777 (cat 12; type 1)"}).highlight = {
    "Brother Paxton's last stolen books came back from the {p:Jasperlode Mine}, and his library was whole again.",
    "Brother Paxton had his library back from the kobolds, and gave a weapon meant for the militia in thanks."}
P.threads.fv_paxton = "Brother Paxton's stolen books"

-- Elwynn at level 7-10: the enchanters' lesson, Eastvale's carters and smith,
-- and two trophies. Givers from Lore Forever (Kitta Firewind, Ormin Pelford,
-- Hagar Lowe); the watch and the trophy buyer stay unnamed.
q(91753, "An Enchanting Lesson", "Elwynn Forest", 7, "elwynn", 2,
    "Kitta Firewind held that theory alone did not make an enchanter. Kobolds had no schooling, yet bound simple enchantments into wax effigies.",
    "Taking apart the crude enchantments in the kobolds' wax effigies was the practical half of an enchanter's lesson.",
    "Once the kobolds' charms were unpicked, Kitta said that theory and practice were two sides of a coin.",
    "With the effigies taken apart, Kitta Firewind's lesson was learned.",
    false, {"part1_corpus.txt #91753 (cat 12)", "LoreForever quest:91753 (wiki: World of Warcraft: Forever; Kitta Firewind at the Tower of Azora)"})
q(91733, "Downstream", "Elwynn Forest", 10, "elwynn", 2,
    "A wagon from the trading post had tipped over, and its supplies had washed downstream before anyone could catch them.",
    "Murlocs and wolves roamed the riverbank where the lost supplies had come to rest. Their owner could not face them alone.",
    "The supplies were pulled out of the river, and their owner apologized for the soaking.",
    "The lost shipment came back from downstream, though its finder came back damp.",
    false, {"part1_corpus.txt #91733 (cat 12)", "LoreForever quest:91733 (wiki: World of Warcraft: Forever; Ormin Pelford near Eastvale)"})
q(91732, "Good Steel", "Elwynn Forest", 10, "elwynn", 2,
    "Good steel had been scarce since the war, and the tools around {p:Eastvale} had suffered for it. Miners had once used fine picks in the {p:Jasperlode Mine}. Some might still lie in its depths.",
    "Hagar Lowe hoped to reuse the steel from the picks the miners had left in the depths of the {p:Jasperlode Mine}.",
    "The old Jasperlode picks still shone. Hagar Lowe said they did not make them like that anymore.",
    "Fine steel from the abandoned picks went to Hagar Lowe, to be made into new tools.",
    false, {"LoreForever quest:91732 (wiki: World of Warcraft: Forever; Hagar Lowe at Eastvale Logging Camp)"})
q(91740, "Croaky's Head", "Elwynn Forest", 10, "elwynn", 3,
    "Croaky, a murloc who had terrorized the local roads, was dead, and the watch would want to know.",
    "Croaky's head was proof that the murloc on the forest roads would trouble no one again.",
    "Two of the watch had fallen to the murlocs the week before. With their leader dead, the guards hoped to start pushing the murlocs out of the forest.",
    "The watch took Croaky's head, and hoped to drive the leaderless murlocs out of the forest.",
    false, {"part1_corpus.txt #91740 (cat 12)"})
q(91746, "Elmpaw's Head", "Elwynn Forest", 10, "elwynn", 2,
    "Elmpaw's head made an impressive trophy, and a local hunter or skinner might want to hear how it was won.",
    "Elmpaw was dead, and its head was worth something to the right buyer.",
    "The buyer was impressed, and knew a few collectors who would pay well to hang Elmpaw's head over their mantles.",
    "The head went to be prepared for some collector's mantle.",
    false, {"part1_corpus.txt #91746 (cat 12)"})

-- Teldrassil and Darnassus (cat 141 and 1657 where captured). Givers from Lore
-- Forever where the text leaves them out: Tarindrella (#97977), Byancie in
-- Dolanaar (#99050), Lynessa Duskblossom (#99053), Arynia Cloudsbreak (#98392).
-- Eralya Leafshadow's fate is never told: #99073 ends with her at peace, not
-- saved. 98391 (The Sisterhood of Elune) is a class referral and is left out.
q(97979, "The Goddess Provides", "Teldrassil", 1, "teldrassil", 3,
    "The Long Vigil that followed the defense of {p:Mount Hyjal} had ended. Now the kaldorei had joined an Alliance of other peoples, and their young learned the gifts of Mother Moon.",
    "Elune's grace could help a kaldorei strike true, or hide one as the moon may eclipse the sun. Every child of the stars was taught to know those gifts.",
    "The lesson was given, with a promise that the goddess would never forsake those who used her gifts well.",
    "The lesson in Elune's gifts was done. Use them well, the teaching went, and Mother Moon would never forsake her children.",
    false, {"LoreForever quest:97979 (wiki: World of Warcraft: Forever; a rite for young night elves)"})
q(97977, "Nature's Call", "Teldrassil", 3, "gnarlpine", 4,
    "For ages the Gnarlpine furbolg had been allies of the night elves. Tarindrella would not believe they had turned so readily. Their abandoned camps on the western edge of {p:Shadowglen} might hold the answer.",
    "Totems left in the Gnarlpine's abandoned homes bore engravings that might tell what had happened to the furbolg.",
    "The engravings told of nightmares. In them the Gnarlpine were wiped out by a great shadow, and their fear had turned to rage against their old elven friends.",
    "It was worse than Tarindrella had feared. A dread of some great shadow had driven the Gnarlpine mad, and that madness had turned on the kaldorei.",
    false, {"LoreForever quest:97977 (wiki: World of Warcraft: Forever; Tarindrella in Shadowglen)"}).highlight = {
    "Engravings on the Gnarlpine's own totems told how nightmares of a great shadow had turned the furbolg against the night elves.",
    "Engraved totems showed that the Gnarlpine had gone mad with fear before they turned on their allies."}
P.threads.fv_gnarlpine = "the madness of the Gnarlpine"
q(97236, "Fang of Githyiss", "Teldrassil", 5, "teldrassil", 2,
    "Githyiss was a spider of great size, and a fresh fang from it was quite a find. A spider scholar in {p:Aldrassil} would want it.",
    "Githyiss's fang was a rare specimen, and a scholar of spiders in {p:Aldrassil} might put it to use.",
    "The spider scholar in {p:Aldrassil} loved surprises, and said the fang would surely further the work.",
    "The fang went to its new keeper, to help the study of the forest's spiders.")
q(87288, "Soft Saber Pelts", "Teldrassil", 7, "teldrassil", 2,
    "A trader in {p:Dolanaar} needed nightsaber pelts. He called the cats beautiful, but the local ones were aggressive.",
    "Nightsabers near {p:Dolanaar} had grown aggressive enough to threaten the roads. A local trader had use for their pelts.",
    "It seemed a shame to the trader to fight such majestic animals. Still, the roads were safer, and the pelts would make blankets and shawls.",
    "The pelts went to the trader in {p:Dolanaar}, for blankets and shawls, and the roads were a little safer.")
P.threads.fv_teldrassil = "small tasks in the boughs of Teldrassil"

-- The Oracle Tree's runners (#99046, #99047, #99050, #99073, in order) and the
-- sentinel lost in Ban'ethil (#99053).
q(99046, "The Lost Runner", "Teldrassil", 9, "oracle", 4,
    "Sentinels ran the Oracle Tree's messages to the elders in {p:Darnassus}. The latest runner was long overdue. It would have been Eralya Leafshadow's turn, though she was still in training.",
    "Messages from the Oracle Tree came at odd intervals, but none had been this late. Someone needed to find the runner on the road west to the {p:Oracle Glade}.",
    "Eralya Leafshadow was found, gravely hurt, calling on Elune's grace.",
    "The missing runner, Eralya, was alive but gravely wounded.",
    false, {"LoreForever quest:99046 (wiki: World of Warcraft: Forever; the Oracle Tree's courier)"})
q(99047, "Not Dead Yet", "Teldrassil", 9, "oracle", 5,
    "Sent with her sisters to the Oracle Tree for a message, Eralya had found harpies everywhere. She begged for word to reach Byancie in {p:Dolanaar}.",
    "Coughing up blood, Eralya Leafshadow had no one else coming. Her only hope was Byancie in {p:Dolanaar}.",
    "Byancie knew the foulness spreading through the forest had touched the harpies, and Eralya with them. She did not think the sentinel had long.",
    "Word of Eralya reached {p:Dolanaar}. Byancie blamed the same foulness that had taken hold of the harpies, and meant to hurry.",
    false, {"LoreForever quest:99047 (wiki: World of Warcraft: Forever; Eralya to Byancie in Dolanaar)"})
q(99050, "The Great Tree Provides", "Teldrassil", 10, "oracle", 3,
    "A salve might hold Eralya's affliction back long enough for her to reach {p:Dolanaar}, Byancie hoped. Its core was the fronds of dewy lashers, found around {p:Lake Al'Ameth} and {p:Wellspring Lake}.",
    "The great tree was a living home and would provide, Byancie said. Lasher fronds, an empty vial and some spring water were all the salve needed.",
    "Byancie had her ingredients and set about making the salve. It would take only a moment.",
    "Byancie began the salve at once with the lasher fronds, vial and spring water.",
    false, {"part1_corpus.txt #99050 (cat 141; 6 dewy lasher fronds)"})
q(99073, "Easing Suffering", "Teldrassil", 10, "oracle", 5,
    "The salve was ready. Byancie did not know if it would cure Eralya, for the rot festered quickly. It would at least ease her suffering.",
    "The rot in Eralya grew stronger as it spread. Byancie's salve might not save her, but it could still ease her pain.",
    "Eralya took the salve, and her breathing calmed. She might not survive, but she was at peace.",
    "The salve reached Eralya in time to ease her. Whether she would live, no one could say.",
    false, {"part1_corpus.txt #99073 (cat 141; take the salve to Eralya)"}).highlight = {
    "Byancie's salve reached Eralya Leafshadow and eased her, though no one knew if she would survive.",
    "Eralya Leafshadow, the wounded runner from the Oracle Tree, was at peace, if not saved."}
q(99053, "Escaping Ban'ethil", "Teldrassil", 9, "oracle", 4,
    "Lynessa Duskblossom had carried a message from the Oracle Tree to the sleeping druids. She found {p:Ban'ethil Barrow Den} overrun by furbolg, and they dragged her underground.",
    "The Gnarlpine held a sentinel beneath {p:Ban'ethil Barrow Den}, and she feared she would be their next meal.",
    "Lynessa escaped the Gnarlpine. She was one of the best sentinels, said a friend who gave thanks for her safety.",
    "Lynessa Duskblossom was out of the barrow den and spared a dark fate.",
    false, {"part1_corpus.txt #99053 (cat 141)", "LoreForever quest:99053 (wiki: World of Warcraft: Forever; Sentinel Lynessa Duskblossom)"})
q(98392, "Darkness in the Glade", "Teldrassil", 12, "oracle", 5,
    "Harpy belts from the {p:Oracle Glade} had a taint running through the fibers of their leather. Arynia Cloudsbreak suspected its source, but needed proof.",
    "If the harpy leaders' necklaces carried the same darkness as their belts, Arynia Cloudsbreak would have her answer.",
    "Foul green swirls ran through the gems of the harpies' amulets. It was fel moss corruption, and Arynia went to tell her superiors at once.",
    "The harpy amulets confirmed it. Fel moss corruption was turning the great tree's own creatures against it, as reports from {p:Shadowglen} had warned.",
    false, {"LoreForever quest:98392 (wiki: World of Warcraft: Forever; Sentinel Arynia Cloudsbreak)"})
q(98398, "The Oracle Tree", "Teldrassil", 12, "oracle", 4,
    "A piece of bark had fallen from the Oracle Tree, and that usually meant it had a task it wished done.",
    "Fallen bark from the Oracle Tree was a summons, and the sentinel at the glade thought greater tasks lay ahead.",
    "From the bark, a calm voice spoke.",
    "Through the fallen bark, the Oracle Tree's message came gentle as a breeze through the leaves.")
P.threads.fv_oracle = "the Oracle Tree and its sentinels"
q(98067, "Eyes of the Sentinels", "Darnassus", 11, "teldrassil", 3,
    "General Feathermoon made sure every sentinel had time to pray to Elune. Something was amiss in Teldrassil, and sentinel owls were to watch the city in the meantime.",
    "Sentinel owls were needed at the tunnels below Cenarion Hold, the bank, the inn on the Craftsman's Terrace and the city gates.",
    "The owls were in place around the city. Their sentinel found peace in the daily rituals, but was glad of a moment to reflect.",
    "The city's watch was set, owl by owl, and the sentinel had a moment to reflect.",
    false, {"part1_corpus.txt #98067 (cat 1657; Sentinel Owls)", "LoreForever quest:98067 (wiki: World of Warcraft: Forever; Sentinel Dalia Sunblade)"})

-- Darkshore and the new ship to Stormwind (#97894, #97914, #97926), Auberdine's
-- bounty (#98025) and the guardian of Mathystra (#98028). Givers from Lore
-- Forever: Borgus Steelhand, Elder Thundris Windweaver. "The recent tragedy"
-- in Auberdine is never explained in the text, so it stays unexplained.
q(97894, "Business in Auberdine", "Darkshore", 17, "auberdine", 2,
    "Borgus Steelhand's brother Gorbold had joined a merchant stall in {p:Auberdine} weeks before, and Borgus had not heard from him since.",
    "A new ship sailed from {p:Stormwind} to {p:Auberdine}, and Borgus Steelhand wanted someone aboard to check on his brother.",
    "Gorbold Steelhand was glad his brother was looking out for him. Business in {p:Auberdine} had all but stopped since a recent tragedy, and he could use the help.",
    "Gorbold was found at his stall, where trade had nearly stopped since a recent tragedy.",
    false, {"LoreForever quest:97894 (wiki: World of Warcraft: Forever; Borgus Steelhand in Stormwind)"})
q(97914, "Expanding Horizons", "Stormwind City", 17, "auberdine", 3,
    "No one in {p:Darnassus} spoke of {p:Auberdine}, only of the cities the Sundering had taken. The village elder wanted its work known, and wrote to Baros Alexston across the sea.",
    "Supplies now came to {p:Auberdine} by sea. The village elder sent a letter back on the next voyage.",
    "Baros Alexston opened the elder's letter with a smile, and it faded as he read.",
    "Baros Alexston's good humor did not last the reading of the letter from {p:Auberdine}.",
    false, {"LoreForever quest:97914 (wiki: World of Warcraft: Forever; Thundris Windweaver)"})
q(97926, "Making Do", "Darkshore", 17, "auberdine", 4,
    "Help for {p:Auberdine} was beyond Baros Alexston, much as he wished to give it. The coffers of {p:Stormwind} were not what they had been, and what remained was spread thin. His reply went back across the sea.",
    "Many in the Alliance went without, Baros said. His answer to the elder of {p:Auberdine} was not what the village hoped for, but it was all he could offer.",
    "The elder took the news sadly. With neither {p:Stormwind} nor {p:Darnassus} coming to help, he said, {p:Auberdine}'s fate was its own to decide.",
    "No aid would come to {p:Auberdine}. Its elder resolved that the village would decide its fate alone.",
    false, {"part1_corpus.txt #97926 (cat 148)", "LoreForever quest:97926 (wiki: World of Warcraft: Forever; Elder Thundris Windweaver)"}).highlight = {
    "Stormwind's answer reached Auberdine. No aid was coming, and the elder said the village's fate was its own.",
    "Auberdine learned that neither Stormwind nor Darnassus would help it."}
P.threads.fv_auberdine = "Auberdine's plea across the sea"
q(98025, "WANTED: Jai'vhanel", "Darkshore", 13, "darkshore", 3,
    "In {p:Auberdine}, the village council offered a bounty on Jai'vhanel, an owl called Swordfeather. She had gone mad and attacked travelers on the road.",
    "Jai'vhanel, a maddened owl, had last been seen north of the ruins of Ameth'Aran. Sentinel Glynda Nal'Shea would pay for one of her jet black feathers.",
    "Glynda Nal'Shea was sad there had been no other way. Jai'vhanel had long been a guardian of the area, and no one knew what had driven her mad.",
    "The roads were safe again, and Sentinel Glynda Nal'Shea grieved a little for the owl who had once guarded them.",
    false, {"LoreForever quest:98025 (wiki: World of Warcraft: Forever; Sentinel Glynda Nal'Shea)"})
q(98028, "Baron Marinous", "Darkshore", 21, "darkshore", 5,
    "All that remained of Baron Marinous, the elemental guardian of the ruins, was a globe of water. Something clouded it that seemed to resist being seen.",
    "Whatever had happened to the elemental and the ruins it guarded was still at work. Only Onu, the Ancient of Lore at the Grove of the Ancients, might know more.",
    "Onu was as surprised as an ancient could be to hear of stairs leading down in Mathystra. He meant to confer with the others, and was glad it had been found before the naga or their cult allies.",
    "The clouded globe reached Onu, who would take word of Mathystra's hidden stairs to the other ancients.",
    false, {"part1_corpus.txt #98028 (cat 148; bring the globe to Onu)"})
P.threads.fv_darkshore = "the troubles along the Darkshore coast"

-- Redridge (cat 44). Givers from Lore Forever: Foreman Oslow, Marshal Marris,
-- Deputy Feldon; the bounty names Magistrate Solomon itself.
q(98407, "Show of Force", "Redridge Mountains", 17, "redridge", 2,
    "Gnolls were camping close to the humans of the valley, and seemed to respect strength above all else.",
    "Slaying the worst of the gnolls, their thrashers, might remind the pack to stay in the hills where it belonged.",
    "The thrashers' collars came back by the armful. It did not solve the gnoll problem, but they would think twice about pushing further.",
    "The gnolls had been discouraged from pushing closer to {p:Lakeshire}, though they were not gone.",
    false, {"part1_corpus.txt #98407 (cat 44; 5 collars)", "LoreForever quest:98407 (wiki: World of Warcraft: Forever; Deputy Feldon)"})
q(98386, "Alther's Mill", "Redridge Mountains", 21, "redridge", 2,
    "Orcs, gnolls and murlocs had already delayed the bridge at {p:Lakeshire}, and now tarantulas infested the lumber mill it depended on.",
    "Foreman Oslow could not safely send his workers to Alther's Mill while spiders were snatching them up.",
    "The mill was worse than Oslow had thought, but twelve of its tarantulas were dead.",
    "Twelve tarantulas at Alther's Mill were dead, and fewer spiders were left to snatch up Oslow's workers.",
    false, {"part1_corpus.txt #98386 (cat 44; slay 12)", "LoreForever quest:98386 (wiki: World of Warcraft: Forever; Foreman Oslow)"})
q(98387, "Blackrock Blockade", "Redridge Mountains", 21, "redridge", 4,
    "Blackrock orcs had pushed into Alliance land and now lived off the mountains. Marshal Marris called it a war of attrition, and meant to starve them.",
    "South of Stonewatch Keep, the orc camps held food and weapons. Most of it had been taken from {p:Lakeshire} in the first place.",
    "The Blackrock camps lost ten of their axes. Cut off from their allies in the Burning Steppes, Marris said, the orcs could not hold their foothold for long.",
    "The supplies taken from the Blackrock camps went back to {p:Lakeshire}, and the orcs were left hungrier and worse armed.",
    false, {"part1_corpus.txt #98387 (cat 44; Battleworn Axes)", "LoreForever quest:98387 (wiki: World of Warcraft: Forever; Marshal Marris)"})
q(95999, "WANTED: Incinerator Gar'im", "Redridge Mountains", 25, "redridge", 5,
    "Incinerator Gar'im led an orc incursion in Render's Valley and was said to work with the Blackrock of Stonewatch Keep. Magistrate Solomon offered a reward for proof of his death.",
    "Gar'im and his Shadowcasters were extremely dangerous, the bounty warned, and they held Render's Valley.",
    "Before he died, Gar'im had been preparing to strengthen the defenses of Stonewatch Keep. Now Magistrate Solomon thought the keep might yet be retaken.",
    "Incinerator Gar'im was dead, and {p:Lakeshire} began to hope of reclaiming Stonewatch Keep.",
    false, {"part1_corpus.txt #95999 (cat 44; type 1)"}).highlight = {
    "Incinerator Gar'im fell in Render's Valley, and Magistrate Solomon hoped to retake Stonewatch Keep.",
    "Incinerator Gar'im, the orc who was to fortify Stonewatch Keep, was dead."}
P.threads.fv_redridge = "the defense of Lakeshire"

-- The Wetlands and the ships from Auberdine. Valstag Ironjaw gives #98197 (Lore
-- Forever); #98461 leaves Tarrel's missing wife to the vanilla chain.
q(98197, "Spoils of War", "Wetlands", 22, "menethil", 3,
    "By Valstag Ironjaw's account, the Old Horde had first built {p:Menethil Harbor} to launch its fleet against Hillsbrad. They used timber and iron stolen from Khaz Modan, and much of it still lay under the water.",
    "With the Dragonmaw on the move, Valstag Ironjaw wanted the Old Horde's sunken materials raised to shore up the town's defenses.",
    "The timber and iron came up a bit damp. Valstag was glad not to rely only on shipments from Theramore or {p:Auberdine} for once.",
    "The Old Horde's sunken spoils came ashore, meant to bolster {p:Menethil}'s defenses.",
    false, {"LoreForever quest:98197 (wiki: World of Warcraft: Forever; Valstag Ironjaw in Menethil Harbor)"})
q(98459, "A Lack of Virtue", "Wetlands", 21, "menethil", 2,
    "Tom Half-fish sent a parcel to Bart Tidewater, whom he called a cheapskate and a cheat at poker. By his account, the captain was an actor who had won enough at cards to buy the Maiden's Virtue.",
    "Old Half-fish had a gift for Bart Tidewater, captain of the Maiden's Virtue in {p:Menethil Harbor}. He was to be told who it was from.",
    "Bart unwrapped the gift and swore. Half-fish was the cheat, he said, thrown out of their poker circle. Then he apologized and welcomed the courier to {p:Menethil Harbor}.",
    "Half-fish's gift reached Bart Tidewater. He answered the insult with one of his own, then welcomed the messenger to the harbor.",
    false, {"LoreForever quest:98459 (wiki: World of Warcraft: Forever; Tom Half-fish to Bart Tidewater)"})
q(98461, "Unrequited Love", "Wetlands", 21, "menethil", 3,
    "Hollee in {p:Auberdine} had studied with Tarrel Rockweaver, who left for the marshes after they finished school. She wanted to know he was all right, and sent him a note.",
    "Hollee had a note for her old classmate Tarrel, somewhere near {p:Menethil Harbor}. She mentioned his wife, Merrin, only as an afterthought.",
    "Tarrel read Hollee's note with pity. He was happily married, and would not reply. His wife was missing, and he had more pressing worries.",
    "Tarrel decided not to answer Hollee's note. He did not know how to let her down, and his wife Merrin was missing.",
    false, {"LoreForever quest:98461 (wiki: World of Warcraft: Forever; Hollee to Tarrel Rockweaver)"})
P.threads.fv_menethil = "the harbor at Menethil"

-- Loch Modan (cat 38).
q(86585, "Banner of the Fallen", "Loch Modan", 17, "lochmodan", 4,
    "A mountaineer lay dead in trogg country, killed by a blow to the head, and the standard of Ironforge she carried had been trampled.",
    "Raising her banner of Ironforge might call out the trogg that killed the mountaineer, if it was still near.",
    "Her name was Ylva. She had gone looking for a patrol that never came back, set on showing the troggs that Ironforge would never fall. Her banner would be cleaned and displayed.",
    "Now the fallen mountaineer had a name, Ylva. Her banner went back to be cleaned and hung, and her weapon was passed on to fight the troggs.",
    false, {"part1_corpus.txt #86585 (cat 38; raise the standard, call out the trogg)"})
q(86614, "Silver of the Waves", "Loch Modan", 20, "lochmodan", 2,
    "Among the rusty hooks and broken spools in some fishing debris lay an ornate silver hair clip marked K.D.",
    "A silver hair clip had turned up in the fishing debris, corroded but finely made. Someone had surely missed it.",
    "Its owner had thought the hair clip lost for good, and was sure a little work would make it shine again.",
    "The silver clip went back to its owner, who was busy with chores but glad to have it again.",
    false, {"part1_corpus.txt #86614 (cat 38)"})
q(86667, "Snowbound", "Loch Modan", 20, "lochmodan", 3,
    "Grenhild's old mentor Norric had sent a minor elemental asking for a jar of snow. She was busy learning the local elementals, and South Gate Pass had snow all year.",
    "Norric needed snow for his shamanic workings. His student Grenhild had learned long ago not to question his ways.",
    "Norric was delighted that Grenhild had sent his snow, though he had hoped she might come herself.",
    "The jar of snow reached Norric. He wished his old student had brought it in person.",
    false, {"part1_corpus.txt #86667 (cat 38)", "LoreForever quest:86667 (wiki: World of Warcraft: Forever; Grenhild and Norric Lochthane)"})
P.threads.fv_lochmodan = "small troubles around Loch Modan"

-- Stormwind (cat 1519): Roy Lewells's reading club and the library (#97234,
-- #97237), and old Gray at the harbor (#95065, Gilbert Gray per Lore Forever).
q(97234, "Reading Room", "Stormwind City", 18, "stormwind", 2,
    "Roy Lewells's reading club was trading some of its less popular works to the city library for more modern writing.",
    "The reading club had a wrapped parcel and a list of titles for the librarian, with refreshments promised for the courier.",
    "The librarian recognized Roy's way of wrapping. His club always returned what it borrowed in good condition, however provoking the words.",
    "Once the librarian had the parcel from Roy Lewells's club, the exchange was agreed.",
    false, {"part1_corpus.txt #97234 (cat 1519; Roy Lewells)"})
q(97237, "Shelf Picked", "Stormwind City", 18, "stormwind", 2,
    "Every title on Roy Lewells's list was in the library, but the librarian would not fetch them. They had to be found on the shelves.",
    "All of the reading club's selections were in the library. A courier could carry them back to Roy Lewells on the club's account.",
    "Roy was delighted with the new titles, some of which smelled exotic. He looked forward to lively talk about them in the cellar after hours.",
    "The reading club had its new material, and Roy kept his promise of refreshments on the house.",
    false, {"part1_corpus.txt #97237 (cat 1519)"})
q(95065, "Fishin' Time", "Stormwind City", 12, "stormwind", 2,
    "Old Gray was fishing in the city and the fish were biting, but he was down to his last bait. Catherine Leland sold fishing goods along the canals.",
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
    "According to the Razormane, Chol'aruk the Ravener was a beast in a cave on Thorn Hill. It was said to swallow an orc whole. An Alliance veteran believed the tales, because he had fought one like it.",
    "It had taken six fighters to bring down a beast like Chol'aruk, and all but two had died. Far from Alliance lands, the veteran still meant to honor his fallen brothers.",
    "Chol'aruk's head reached the veteran. His dead men would rest easier, he said, with one less of these monsters in the world.",
    "Chol'aruk was dead. The Alliance veteran called its slayer a true and stalwart defender of the Alliance.",
    true, {"part1_corpus.txt #97005 (cat 17; type 1)", "LoreForever quest:97005 (wiki: World of Warcraft: Forever; Bainham)"})
q(97281, "A Simmering Storm", "Durotar", 11, "durotar", 2,
    "A harpy had been carrying a dull orb with a dark mist swirling inside. Small sparks of lightning ran through it.",
    "Humming with a faint current, the harpy's orb might interest Rezlak the goblin.",
    "Rezlak loved the orb, and it reminded him of something his old boss Gazlowe used to say.",
    "Rezlak took the stormy orb, delighted with it.",
    false, {"part1_corpus.txt #97281 (cat 14; the Dull Stormy Orb to Rezlak)", "LoreForever quest:97281 (wiki: World of Warcraft: Forever; Dustwind harpies of Drygulch Ravine)"})
q(97282, "Stormy Potential", "Durotar", 11, "durotar", 3,
    "The harpies' orb was only drained, Rezlak thought. Charged organs from the thunder lizards in the gorge to the west could fill it again.",
    "Gazlowe had taught Rezlak to seize an opportunity when it came knocking. The goblin meant to recharge the orb, if someone brought him thunder lizard organs.",
    "Rezlak had his organs and hoped to charge the orb with them. He bet it would make the harpies think twice about attacking his caravan.",
    "Whether the orb would charge with the organs, Rezlak could only hope.",
    false, {"part1_corpus.txt #97282 (cat 14; 5 organs)"})
q(95328, "Whispering Horror Residue", "Tirisfal Glades", 10, "tirisfal", 2,
    "Remains of a creature from beneath the Whispering Forest were still squirming. Someone in the {p:Undercity} might have a use for them.",
    "A beast from under the Whispering Forest had left a residue behind, and the {p:Undercity} studied stranger things.",
    "The residue went to Father Lankester in the {p:Undercity}. He knew the Whispering Forest was touched by the void, and welcomed the mysteries of shadow.",
    "The squirming remains became a specimen in the {p:Undercity}, paid for gladly.",
    false, {"part1_corpus.txt #95328 (cat 85)", "LoreForever quest:95328 (wiki: World of Warcraft: Forever; Father Lankester)"})
P.threads.fv_tirisfal = "strange finds around Tirisfal"
q(91920, "Wild Eyes", "Silverpine Forest", 11, "silverpine", 2,
    "A Deathstalker had taken Apothecary Renferrel's potion and felt no better. Murloc eyes from Lake Lordamere might work, the Deathstalker wondered, where hearts had not.",
    "Apothecary Renferrel was obsessed with hearts lately, and an ailing Deathstalker risked his temper by suggesting murloc eyes instead.",
    "The potion had failed, Renferrel said, because it had been brewed with too few hearts. Still, he took the eyes, and offered some of his own hearts to restore the Deathstalker's strength.",
    "The murloc eyes reached Renferrel, who had not thought of using murloc parts until then.",
    false, {"part1_corpus.txt #91920 (cat 130; 3 eyes)"})
P.threads.fv_silverpine = "the Sepulcher's ailing Deathstalker"
q(97485, "Traditions of the Bluff", "Thunder Bluff", 10, "bluff", 3,
    "Scattering incense to the winds was a tauren tradition. Herbs, cedar, sinew thread and ceremonial flint for it came from the traders on the bluffs.",
    "Incense was scattered off the south cliff of Hunter's Rise for many reasons. It could ask the Earthmother's watch over someone, or bless a hunt.",
    "The incense was crafted and spread from the cliffs of Hunter's Rise, in the old way of the tauren.",
    "The incense went to the winds off Hunter's Rise. Its makings could always be bought again, for any other day worth giving thanks.",
    false, {"part1_corpus.txt #97485 (cat 1638; Nida, Nata, Mahu and Naal)"})
P.threads.fv_bluff = "the traditions of Thunder Bluff"

---------------------------------------------------------------- Remaining starter-zone stages (starters3 lane, 2026-11-05)
-- Orgrimmar (cat 1637): Yelmak's shop before Whuut's the Rush (#97275), and
-- Migi's lunches and games behind Grommash Hold. Kor'geld, Thatog and Thra
-- are named from Lore Forever; the rest is the quest text.
q(97242, "Yelmak's Medley", "Orgrimmar", 15, "durotar", 2,
    "Yelmak's apprentice Whuut had already broken things and was too proud to ask for help. Kor'geld wanted cattail and speargrass from the Valley of Honor for one of Yelmak's home brews.",
    "Kor'geld could not leave Yelmak's shop without Whuut guessing that everyone was humoring his mood. Cuttings for the medley grew by the water in the Valley of Honor.",
    "Cattail and speargrass like these grew only here, Kor'geld said, fed by mountain springs and the city's red dust. Yelmak would use them to win back Whuut's ear with a lesson at the bench.",
    "Yelmak had his cuttings, and hoped a lesson with his own hands would reach his proud apprentice.",
    false, {"part1_corpus.txt #97242 (cat 1637)", "LoreForever quest:97242 (wiki: in-game quest text; Kor'geld and Whuut)"})
q(97246, "Meal Appeal", "Orgrimmar", 15, "migi", 2,
    "Thatog's son Migi played behind Grommash Hold all day. He almost never stopped for the lunch his father had arranged at Borstan's. The boy came home starving, and Thatog's duties kept him at his post.",
    "Thatog could not watch over every meal his son Migi skipped. He asked that Borstan be told, at his firepit, that someone had come for Migi's lunch.",
    "Borstan knew the arrangement well. Migi was meant to collect a bagged lunch every day, and some weeks he skipped it several times.",
    "Borstan admitted that Migi often left his lunch behind. He wondered where the boy found the energy to play all day.",
    false, {"part1_corpus.txt #97246 (cat 1637)", "LoreForever quest:97246 (wiki: in-game quest text; Thatog)"})
q(97249, "Favorite Food", "Orgrimmar", 15, "migi", 3,
    "Migi's parents had made Borstan promise to vary the boy's lunches. Migi never missed lunch when sweetglazed hog belly came out of the smoker. So Borstan began crumbling the glazed bits over any meal.",
    "Borstan had a plan to bring Migi in for lunch, since crispy sweetglaze crumbs could go on any dish. The boy was behind Grommash Hold with his friends.",
    "Migi smelled the lunch and said it tasted like his favorite sweetglaze, only different. If it was this good every day, his friends would stop their game to eat with him.",
    "Borstan's lunch reached Migi behind Grommash Hold. The boy liked the strong crumbs and decided the game could wait while everyone ate.",
    false, {"part1_corpus.txt #97249 (cat 1637)", "LoreForever quest:97249 (wiki: in-game quest text; Borstan's Meats)"}).highlight = {
    "Borstan's sweetglaze crumbs won Migi over. The boy decided his friends could stop their game behind Grommash Hold to eat lunch.",
    "Borstan's lunch reached Migi behind Grommash Hold, and the boy called it his favorite."}
q(97326, "Rocks to Rests", "Orgrimmar", 15, "migi", 2,
    "Thra and the other children set up their figures in a clear patch of dirt. They had no rocks to use as chairs or tables.",
    "Thra wanted smooth, medium-sized rocks for the children's game behind Grommash Hold. They had to be flat enough to sit on when the children needed a rest.",
    "That anyone could carry so many boulders made Thra marvel. Most had a flat side, and the children could push them through the dirt wherever they wanted.",
    "Eight smooth rocks reached the clearing, and the children no longer had to sit in the dirt.",
    false, {"part1_corpus.txt #97326 (cat 1637; 8 rocks)", "LoreForever quest:97326 (wiki: in-game quest text; Thra)"})
P.threads.fv_migi = "the children behind Grommash Hold"

-- The Barrens (cat 17). #95621 comes before the Horde pack's Unwelcome Guests
-- (#95508): the tanner learns here that the soldiers want a deserter, and tells
-- his navy past there. Walton and Wrenix are named from Lore Forever. #95774
-- follows Mankrik's Lost in Battle (#4921, Horde pack). Stepping Stones
-- (#79192) is the world lane's.
q(95621, "Trouble in the Valley", "The Barrens", 18, "horde_vrang", 4,
    "Through his rifle's scope, the hermit tanner Walton had watched human soldiers search the valley below his ridge. They wore the livery of Kul Tiras.",
    "Walton, the hermit tanner, called the last of Daelin Proudmoore's fleet as rotten as the admiral had been. Its soldiers had camped by a wrecked caravan to the south, and he wanted to know why.",
    "The soldiers by the wrecked caravan had been looking for a deserter. His past, Walton said, had finally caught up with him.",
    "The Kul Tirans' purpose came out at the wrecked caravan. They were hunting a deserter, and the tanner knew it was him.",
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
    "With the stalkers and lizards below the tree thinned out, the walker promised to tell {p:Camp Taurajo} of the rescue. Then came the careful climb down.",
    "With the hyenas and lizards gone, the walker could climb down. It beat being stuck in the tree all day.",
    false, {"part1_corpus.txt #98093 (cat 17)"})
P.threads.fv_taurajo = "the fields around Camp Taurajo"

-- Dun Morogh (cat 1). Jemma Quikswitch, Amberstill Ranch and Quarrymaster
-- Thesten are named from Lore Forever. #98423 starts from a tablet in a vault;
-- Magni names his ancestor Madoran in the completion text.
q(95041, "Data Hoarders", "Dun Morogh", 10, "gnomes", 2,
    "Before fleeing Gnomeregan, Jemma Quikswitch had copied her family's archives onto punch cards. A hole in her pack had lost several of them in the snow outside the city.",
    "Arcanotechnical field equations, submarine hull designs from the Second War and Grandma Quikswitch's chili recipe filled the Quikswitch archives. Without the lost cards, the rest was too scrambled to read.",
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
    "Quarrymaster Thesten wanted his quarry's powder back from the troggs before they worked out how to light it.",
    "All the stolen powder was back. Thesten paid for it and asked that the little incident not be mentioned to anyone.",
    "The troggs no longer had the quarry's powder, and Thesten hoped no one else would hear of its loss.",
    false, {"part1_corpus.txt #95214 (cat 1)", "LoreForever quest:95214 (wiki: in-game quest text; Quarrymaster Thesten)"})
P.threads.fv_morogh = "work for the dwarves of Dun Morogh"
q(98423, "The Treaty of Understanding", "Ironforge", 16, "tombs", 5,
    "In a vault lay a tablet with the terms of a peace between the Bronzebeard and Wildhammer clans. It dated from just after the War of the Three Hammers, and King Magni would want it.",
    "Two of the three clans that had fought over the mountain had made peace on the old tablet, a piece of dwarven history.",
    "King Magni knew the treaty. His ancestor Madoran, the first Bronzebeard king, had drafted it after the civil war. The Wildhammers had signed it, and the Dark Irons had not.",
    "The tablet reached King Magni. Only the Bronzebeards and Wildhammers had signed it, he pointed out, and never the Dark Irons.",
    false, {"part1_corpus.txt #98423 (cat 1)", "LoreForever quest:98423 (wiki: in-game quest text; Madoran Bronzebeard)"}).highlight = {
    "King Magni received a treaty tablet from a vault. His ancestor Madoran had drafted it after the War of the Three Hammers, and the Dark Irons had never signed.",
    "King Magni recognized the tablet as the peace his ancestor Madoran had made with the Wildhammers. The Dark Iron clan's mark was missing from it."}

-- Mulgore. Three tests by one teacher who hoped to find talent for the
-- subtle arts. The giver is not named in the captured text, so neither is
-- here, and no class is inferred.
q(76156, "Stalk With The Earthmother", "Mulgore", 10, "earthmother", 2,
    "A teacher sensed a hidden talent for the subtle arts. The test was to wear a mask into the {p:Venture Co. Mine} and steal its supplies.",
    "A teacher handed over a mask for slipping into the {p:Venture Co. Mine}. It hardly looked convincing. A skilled rogue needed only a winning smile and a distraction, the teacher said.",
    "The teacher had heard the approach the moment it reached the mesa. Disguises, perhaps, were not the pupil's strength.",
    "The stolen supplies came back, but the teacher judged that disguises were not the hidden talent.",
    true)
q(76160, "Stalk With The Earthmother", "Mulgore", 11, "earthmother", 2,
    "Perhaps the talent lay in poisons. Harpies to the north nested in a tree whose fallen cones could be crushed into a searing salve for blades.",
    "For the second test, the teacher wanted a venomous salve from the cones beneath the harpies' nesting tree. Even a touch of it on skin would hurt.",
    "What came back was pine nut butter. The teacher thought it better spread on spice bread than on a dagger.",
    "The salve turned out to be pine nut butter. It was formidable only against a foe with a nut allergy, the teacher said.",
    true)
q(76240, "Stalk With The Earthmother", "Mulgore", 11, "earthmother", 3,
    "One idea remained, less direct than the others. A raw Brilliant Smallfish was to be cleaned and filleted with the teacher's daggers, without thinking too hard.",
    "There was still hidden talent to coax out, the teacher believed. This time the test was a fish and a pair of daggers.",
    "The filleting showed no rogue's precision, but an impressive ambidexterity. There was still one thing the teacher could teach.",
    "The daggers worked in both hands at once. This pupil would never train the teacher's people in the subtle arts. Still, the Horde would need such heroes, the teacher said.",
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

---------------------------------------------------------------- the character's side (pov)
-- The character's side of each stage (DESIGN §3.0; format in JournalBook.lua, QD.Story):
-- `act` folds into a grouped line, the numbered lines tell the moment from the
-- character's side. Written from the same quest text as why/after (pov-forever lane,
-- 2026-11-07). 98601, 90902, 91208, 98389, 91209, 99134 and 99144 have theirs in
-- JournalSelfWords.lua (W.pov) and take none here. `solo` marks class referrals and
-- personal moments. No {p:}/{n:} markup in these lines (the pov check bans colons).
local POV = {
    -- Tirisfal: Brill, Shadowvale and Bandarion Keep (6-13)
    [99141] = {act = "collected the overdue reports of Zygand's Deathguards", giver = "Executor Zygand",
        "Executor Zygand had run out of patience with Deathguards whose reports were overdue. {We} went round for all three, and one of them was an abomination named Gordo.",
        "{We} brought Executor Zygand his overdue reports, and the one from the abomination Gordo was of no use. Zygand had trusted him with a pen and wanted that kept quiet. There might be hope for {us} yet, he allowed."},
    [95328] = {act = "carried a horror's squirming remains to Father Lankester",
        "Against better judgement {we} scraped up the squirming remains of the horror beneath the Whispering Forest. Father Lankester in the Undercity called them an interesting specimen and paid for them.",
        "In the Undercity, Father Lankester was glad of the remains {we} brought from under the Whispering Forest. The place was touched by the void, he said. He welcomed the chance to explore the mysteries of shadow."},
    [99152] = {act = "brought glowing bones from the cellars beneath Shadowvale", giver = "Hilda the Breaker",
        "Hilda the Breaker called it a crash course. She sent {us} into the cellars beneath Shadowvale, where the Scourge had gathered unseen. {We} brought back the glowing bones she wanted. Something might be made of {us} yet, she allowed.",
        "Beneath the ruined town lay cellars full of Scourge. {We} gathered six bones still glowing with their first magic. Hilda meant to study them and learn how such a threat had gone unnoticed so long."},
    [99153] = {act = "found the crystal fragment a cultist hid beneath Shadowvale", giver = "Ephram Barbaro",
        "Word of {our} work against the cultists had reached Ephram Barbaro, and he had a loose end for {us}. One cultist had escaped with a piece of a focusing crystal. {We} found it hidden beneath Shadowvale, its power not yet spent.",
        "Beneath Shadowvale {we} searched for the crystal fragment a cultist had carried off. The thing was either raising the dead or making them stronger. {We} found it quickly, and Ephram Barbaro was pleased with the speed."},
    [91282] = {act = "went to join the order of risen paladins at Bandarion Keep", solo = true,
        "Paladins risen as {I} had been were founding an order of their own, and {I} went to find it. At Bandarion Keep, Breton Samuels welcomed {me} as one more recruit.",
        "The risen paladins believed that faith and fellowship would help them thrive. {I} went to join their order at Bandarion Keep, and Breton Samuels welcomed {me} to Tyr's Watch, as he called it."},
    [91285] = {act = "drove the murlocs back from the gates of Bandarion Keep", giver = "Breton Samuels",
        "There was no time for hospitality at the keep, for the murlocs who once spawned there kept attacking. {We} drove them back along the bluffs and around the lake. Breton Samuels hoped it would slow them down.",
        "Breton Samuels found rebuilding hard enough without a murloc spear in his back. {We} hunted the murlocs through the bluffs and the lakeside camps, and bought the keep a little breathing room."},
    [91294] = {act = "met the order's leader Danitha Morr", solo = true,
        "With the murlocs held off, Breton Samuels sent {us} to look around the keep. It was not much yet but was home. Up top {we} met Danitha Morr, who offered fellowship to all still loyal to the Light.",
        "{We} walked the grounds of Bandarion Keep and spoke with its people. Danitha Morr was the closest thing it had to a commander. She asked for help, since much remained to do before the order could stand on its own."},
    [91316] = {act = "scavenged lumber from a root cellar in Shadowvale",
        "The keep was short of building materials so far from the Undercity. {We} searched an old root cellar in ruined Shadowvale and came back with lumber.",
        "Down in a dark root cellar in Shadowvale {we} found the lumber the keep needed for its repairs. A fortress on the bluffs was hard to keep supplied, its paladins admitted."},
    [91317] = {act = "ended the Tarnished at Shadowvale and took their commander's head",
        "Not every risen paladin had left the prejudices of life behind. The Tarnished at Shadowvale were killing other Forsaken, and each killing made the glades trust the order less. {We} cut them down and took the head of their commander, Rudolph Gelhardt.",
        "The Tarnished were paladins risen as {I} had been, who had carried the hatreds of life into undeath. {We} fought them through Shadowvale and took the head of Rudolph Gelhardt, their commander. The order expected the trust of the Forsaken to take years yet."},
    [95803] = {act = "carried the Tarnished commander's head to the Dark Lady", giver = "Danitha Morr", solo = true,
        "Danitha Morr, who led the order, sent {me} to the Dark Lady with the Tarnished commander's head, proof that the paladins punished their own. Sylvanas did not doubt Danitha's sincerity, but expected more paladins to turn on the Forsaken, and said they would be watched.",
        "{I} stood before the Dark Lady herself with the head of the Tarnished commander. Sylvanas took it coldly, and said she might one day stop tolerating {my} order, so {I} had better serve {my} people diligently."},
    [96895] = {act = "followed an Argent emissary toward the cultists near the city",
        "Two Forsaken emissaries of the Argent Dawn had passed through, and not everyone liked them poking around unsupervised. {We} followed one southeast, toward the Undercity. The emissary was watching a band of Scourge cultists and warned {us} to stay low.",
        "{We} went southeast after an emissary of the Argent Dawn, toward Scourge cultists snooping near the Undercity. The emissary was keeping watch on them, and said they were not to be trifled with."},
    [96897] = {act = "cut down servants of the Cult of the Damned outside the Undercity",
        "The glades had enough trouble without the Scourge's living servants, and an Argent emissary wanted them stopped. {We} cut down the cultists outside the Undercity. Only vigilance, the emissary warned, would keep Lordaeron's history from repeating.",
        "Outside the Undercity {we} fought the Cult of the Damned, living men and women who served the Scourge. When they lay dead, an Argent emissary urged {us} to stay vigilant."},
    [96898] = {act = "gathered fragments of the crystal shattered beneath Naxxramas",
        "When Naxxramas bore down on the Undercity, the great crystal beneath it had shattered. {We} gathered twelve fragments before the cultists could, and touched them no more than {we} had to.",
        "{We} dug up fragments of the crystal that shattered when Naxxramas bore down on the city, spent but still dangerous. An emissary of the Argent Dawn expected the Forsaken to be digging them up for years."},
    [96899] = {act = "met Leonid Barthalomew of the Argent Dawn at Bandarion Keep",
        "An Argent emissary sent {us} to Bandarion Keep to meet his commander, Leonid Barthalomew. Leonid remembered the keep from the war against the Scourge, and was glad Danitha's paladins kept it now.",
        "At Bandarion Keep {we} found Leonid Barthalomew among old memories. The keep had once been the Argent Dawn's. He was glad Danitha Morr had taken it over, and had named it after a friend they shared."},
    [96896] = {act = "learned how Garek Bandarion fell when Naxxramas struck the Undercity",
        "Leonid Barthalomew told {us} of the day Naxxramas attacked the Undercity. Garek Bandarion fell defending it, and Bandarion Keep was named for him. He was perhaps the first of the Forsaken to wield the Light as a paladin.",
        "{We} listened as Leonid spoke of the friends he and Danitha Morr had lost to Naxxramas. He saw Garek Bandarion's legacy living on in her order, and wished the rest of the Forsaken felt the same."},
    [98545] = {act = "carried Leonid's letter to the goblin Glix Xizzix in the Undercity",
        "Leonid had a colorful history with the Dark Lady, so {we} carried his letter into the Undercity. The goblin Glix Xizzix had not seen him since Naxxramas, and paid {us} grudgingly from the lost and found.",
        "{We} brought Leonid's letter to his old friend Glix Xizzix, who had never agreed to any tip. He let {us} pick from the lost and found instead."},

    -- Silverpine: the Sepulcher's Deathstalker, the offering stone, and Lumina Windsinger (11-26)
    [91920] = {act = "brought Apothecary Renferrel murloc eyes for an ailing Deathstalker",
        "An ailing Deathstalker at the Sepulcher had taken Apothecary Renferrel's potion and felt no better. Murloc eyes might serve where hearts had not, the Deathstalker dared to suggest. {We} took three eyes from the murlocs of Lake Lordamere.",
        "Renferrel blamed his failed potion on too few hearts when {we} brought him the murloc eyes from Lake Lordamere. Still, he took them, and offered some of his own hearts to restore the Deathstalker's strength."},
    [91858] = {act = "took up the search for the missing envoys of the Earthen Ring", giver = "Danitha Morr", solo = true,
        "Two dignitaries of the Earthen Ring had gone missing on the road to Tarren Mill. Danitha Morr saw a chance for {my} order to prove its worth to the Horde. She sent {me} to Trevan Rol at the Sepulcher, who called it a damned fine mess.",
        "This time Danitha Morr trusted {me} with work that mattered to the whole order. If the lost envoys of the Earthen Ring were found, the paladins might win the legitimacy they needed. {I} went to Trevan Rol at the Sepulcher."},
    [91859] = {act = "learned from Trevan Rol that one of the missing was a high elf", solo = true,
        "Trevan Rol told {me} the missing dignitaries were no ordinary diplomats. One was a tauren and the other, he would bet his good pinky finger, a high elf. He sent {me} on to Deathguard Baldren at the town's entrance.",
        "Nobody at the Sepulcher knew why an elf would travel with a tauren through Horde lands. {I} took the question to Deathguard Baldren, who cared little for paladins but admitted {my} timing was impeccable."},
    [91860] = {act = "found a tauren's body on a gnoll pyre on Fenris Isle",
        "Deathguard Baldren had seen gnolls dump a large body onto a pyre on Fenris Isle. He called the search a lost cause, and {we} crossed to the isle anyway. The tauren lay there, heavily gnawed, but there was no sign of the elf woman.",
        "{We} went out to Fenris Isle, where the gnolls had built their pyre. Only the tauren lay on it, heavily gnawed. That left hope that the elf still lived somewhere in the fortress nearby."},
    [91861] = {act = "searched Fenris Keep and found the elf alive in a cage",
        "Finding only one body gave {us} hope, and {we} went into Fenris Keep to search for the missing elf. Deep inside {we} found her caged, and she begged {us} to free her while there was still time.",
        "Gnolls held Fenris Keep, and somewhere inside it was the last of the Earthen Ring party. {We} found her alive behind bars, pleading with {us} to hurry."},
    [91862] = {act = "freed Lumina Windsinger from the gnolls' cage",
        "The captive was no high elf, she told {us}. She was Lumina Windsinger, a shen'dorei of the Windshaper Skyborne, who had travelled with her companion Banon. {We} killed the gnolls nearby, took the key and opened her cage.",
        "Lumina Windsinger had come to Azeroth as a guest of the Earthen Ring. She called gnolls the second worst creatures she had met here. {We} took the cage key from them and set her free, though she warned that the danger was not over."},
    [96204] = {act = "brought Lumina Windsinger safely out of Fenris Keep",
        "Lumina meant to make the gnolls regret ever laying eyes on a Windshaper. {We} fought {our} way out of Fenris Keep beside her. At the Sepulcher she told {me} that paladins had a friend among the Windshapers.",
        "{We} brought Lumina back to the Sepulcher, though she had heard little good of paladins on her travels. As a shen'dorei in Horde lands she knew how easily prejudice took root. She promised {my} order a friend among the Windshapers."},
    [95884] = {act = "found the offering stone a torn note spoke of",
        "{We} found a scrap of note in Beren's Peril, mostly illegible, that spoke of an offering and a ritual. Close by {we} came upon the offering stone itself, its rough surface littered with strange implements.",
        "A worn note led {us} through Beren's Peril to an offering stone. Strange implements lay scattered across it, the makings of a ritual still waiting to be finished."},
    [95883] = {act = "took a tortured soul from the undead for the offering stone",
        "The ritual on the stone lacked only an offering of blood and a tortured soul. The undead around Beren's Peril looked tortured enough, and {we} took a soul from among them. It let out a foul energy when {we} brought it to the stone.",
        "{We} hunted the tortured undead of Beren's Peril for the soul the hasty ritual still needed. Laid before the offering stone, it gave off a foul energy. The ritual was a step closer to its end."},
    [95885] = {act = "finished the ritual at the offering stone with an offering of blood", solo = true,
        "The note asked for a willing sacrifice of blood. A deep dread came over {me} as {I} made the offering. The ritual drained the stone of its power, to what end {I} did not know. It cracked apart with something glittering inside.",
        "{I} gave the offering stone the blood the note had called a willing sacrifice, and the stone went still. Whatever the ritual had been for, it was over, and in the crumbled rock something glittered."},
    [95034] = {act = "heard from Lumina what had truly befallen Banon", solo = true,
        "Lumina told {me} it had been a worgen, not the gnolls, that first attacked them on the road. Banon took its bite to shield her. At the very end, pierced by gnoll blades, he turned on her while still knowing who she was.",
        "{I} heard Lumina out at the Sepulcher. Her companion Banon had been bitten by a worgen saving her, and she called his end the worst part. Upon the sky she swore to see the creature that doomed him dead."},
    [95036] = {act = "gathered the makings of a blade to kill Old Fire-Eye", giver = "Lumina Windsinger",
        "The worgen was Old Fire-Eye, the biggest and meanest of his kind, and some magic kept him from staying dead. Trevan Rol listed what a blade to end him would need, and {we} gathered every piece.",
        "Even the Light needed a good blade to guide, Trevan Rol said. {We} went out after the materials for one that could put Old Fire-Eye down. When {we} brought them in, Trevan knew of a smith to forge it."},
    [95042] = {act = "won a Kor Gem from the naga of Blackfathom Deeps",
        "A scholar in Ashenvale was amused to meet a Forsaken paladin, but told {us} where Kor Gems could be had. {We} went down among the naga of Blackfathom Deeps and took one. The scholar called the naga witches' corruption in it simple to dispel.",
        "{We} went down into Blackfathom Deeps, where the naga still used Kor Gems. The one {we} brought back was tainted by their witches. The scholar who had sent {us} offered to buy it, for academic pursuits."},
    [95111] = {act = "took the blade's materials to Ott, a smith in Tarren Mill", giver = "Trevan Rol",
        "Trevan had once bought a sword from Ott, a plain orc smith in Tarren Mill. The Undercity's smiths took it for a master's work. {We} carried Ott the materials and the commission. No one had ever asked him for one before, he admitted.",
        "In Tarren Mill {we} offered Ott the commission Trevan wanted him to have. He made humble, honest weapons, he said. He wondered why anyone would pass over the smiths of the Undercity for him."},
    [95125] = {act = "watched Ott forge the Moonsilver Blade",
        "Ott called {our} materials truly fine and asked {us} to stand back while he forged. When he was done he called the blade his finest work, and bid {us} farewell with Aka'Magosh.",
        "{We} stood back from Ott's forge as he worked, and he handed over the best blade he had ever made. He hoped it would serve {me} well, and thanked {us} for the chance."},
    [95126] = {act = "brought the Moonsilver Blade to Trevan Rol",
        "{We} carried Ott's blade back to the Sepulcher with his thanks for Trevan. Trevan inspected it carefully and said it would do nicely, for he had known Ott had it in him.",
        "Trevan Rol inspected the Moonsilver Blade {we} brought from Tarren Mill and approved it. Only the beast was left now, and Lumina was waiting."},
    [95140] = {act = "killed Old Fire-Eye with the Moonsilver Blade", giver = "Lumina Windsinger",
        "{We} hunted Old Fire-Eye near the gates of Gilneas and ended him with the Moonsilver Blade. Banon could rest in peace, Lumina said. Her eyes glowed blue as she laid a little of her people's magic on the bloodied steel.",
        "The worgen that would not stay dead fell at last to the blade made for him. Lumina's oath was kept. She touched the blade with the magic of the Windshapers and prayed to the winds it would serve {me} well."},

    -- The Undercity and the Ruins of Lordaeron (16-22)
    [97891] = {act = "ran Alessandro's potion across the slime canal to Doctor Felben",
        "Alessandro could not run without his knees popping out, so he shooed {us} off with a potion that would not keep. {We} hurried it across the slime canal to Doctor Martin Felben. The last six had gone bad on the way, the doctor said.",
        "{We} raced a potion across the Undercity's slime canal before it could spoil. Doctor Martin Felben took it just in time and paid {us}. Then he sent {us} off so he could get back to his experiments."},
    [92401] = {act = "searched the ruins for Edward Heartweaver",
        "Edward Heartweaver's wife had not seen him for days. Every week he searched the graveyard in the ruins for the son lost when Arthas razed the city. {We} went up among the Scourge to learn his fate.",
        "{We} brought word of Edward from the ruins to his wife. It had not been fair to ask it of a stranger, she said. She gave {us} what thanks she could, and hoped {our} next meeting would carry less sorrow."},
    [92421] = {act = "took parts from the Scourge to mend the Forsaken wounded",
        "A paladin of the Forsaken asked {us} for flesh from the Scourge that still roamed above the Undercity. Decaying bodies could not be mended without replacements. {We} brought back the parts, and the paladin said {we} did Captain Bandarion proud.",
        "Up in the ruins {we} cut parts from the Scourge to mend the Forsaken's wounded. It was the work Garek Bandarion had begun. With them, the paladin said, the wounded had hope to see another day."},
    [92422] = {act = "killed the necromancer Rath'mael in the fog of the ruins", giver = "Deathguard Kristof",
        "An unholy fog had settled over the streets and graveyard of the ruins, hiding the Scourge. Deathguard Kristof traced it to a necromancer named Rath'mael. {We} went up into the fog and killed him.",
        "{We} hunted Rath'mael through the fog he had conjured over the ruins and cut him down. Kristof expected another of his kind to take his place, but hoped the Scourge would thin in the meantime."},
    [95204] = {act = "brought a crest of Lordaeron to Oran Snakewrithe",
        "In the rubble of the ruins {we} found a weathered crest of Lordaeron, one of the kingdom's few relics. {We} took it down to Oran Snakewrithe in the Undercity. He bit it to be sure and called it a genuine piece of home.",
        "Oran Snakewrithe tested the crest of Lordaeron {we} brought him with his teeth. It was a genuine relic, mostly intact, and he thanked {us} for helping restore the Forsaken's history."},
    [95216] = {act = "killed Witherfang and brought its ichor to Theodore Griffs",
        "Theodore Griffs wanted a sample of a venom that ate through undead flesh, preferably from {our} own wounds. {We} killed the beast, Witherfang, instead. He was put out but took the ichor all the same.",
        "{We} brought Theodore Griffs ichor from Witherfang, the venomous beast stalking the ruins above the city. He had wanted to see it work through the blood, and sent {us} from his sight. Still, the sample would let him reverse engineer the strain."},
    [97288] = {act = "carried the Baron's loose head down to the Undercity",
        "When the Baron fell, its head toppled off, worn loose by many reattachings. {We} carried it down to the Undercity. An apothecary there knew the head at once and called it a cruel joke of the Dark Lady's.",
        "{We} took the Baron's head, sewn back on so often that it had finally come away, to the city below. The apothecary there recognized it and already had a use for it."},
    [97289] = {act = "set Othmar's head beside a waiting body",
        "The head had once belonged to Othmar, a Grand Marshal of the Alliance whom the Dark Lady had dispatched herself. {We} set it beside a body in the next room, as the apothecary asked. The body twitched to life, reliving its final moments in a panic.",
        "Othmar's secrets were what the apothecaries wanted, and {we} placed his head next to the body waiting for it. The flesh stirred and panicked, as though it lived through its death a second time."},
    [97290] = {act = "heard Othmar's broken refusal",
        "Revived, Othmar spoke only to refuse, calling {me} an abomination and telling {me} to be gone. {We} carried his answer back to the apothecary, who seemed pleased by the defiance.",
        "In broken words, Othmar refused to help those who had raised him. When {we} reported his answer, the apothecary called it excellent, being one who always loved a challenge."},
    [97291] = {act = "fetched poisons for Master Apothecary Faranell's potion",
        "Master Apothecary Faranell meant to bind Othmar to the Dark Lady's will. He sent {us} around the Undercity for a Toxic Skullcap, blisterweed and a vial of Essence of Agony. He looked forward to seeing how much bravado his guest had left.",
        "{We} gathered the reagents Faranell wanted from a poison vendor and the herbalists of the Undercity. They would do nicely, he said, for the potion meant to bind Othmar."},
    [97292] = {act = "dripped Faranell's serum into the workings above Othmar",
        "Faranell handed {us} his Hissing Serum and warned {us} not to drop it. He could not afford a new assistant. {We} fed it into the workings dripping above Othmar, and the apothecary left the flesh to simmer.",
        "{We} put the serum in place above the Grand Marshal, under an oozing specimen. Faranell thought it the least Othmar deserved for his crimes against the Dark Lady. He spoke of many plans for Othmar's future."},
    [92415] = {act = "took a letter about a Heartweaver child to Matron Nightingale",
        "In the graveyard of the ruins {we} found a stained bundle of parchment about a missing Heartweaver child. {We} carried it to the orphan matron in Stormwind. Matron Nightingale remembered little Jeremy, who had lost both parents when Lordaeron fell.",
        "{We} brought the letter from the graves all the way to Stormwind's orphanage. Matron Nightingale knew the name at once. Jeremy Heartweaver had come to her after the attack on Lordaeron, and a woman in Duskwood had lately adopted him."},
    [95161] = {act = "carried the Heartweaver letter to Avette Fellwood", giver = "Matron Nightingale",
        "Matron Nightingale sent {us} on to Duskwood with the letter, to Jeremy's new mother Avette Fellwood. Avette thanked {us}, but the boy had not spoken since Lordaeron fell. She meant to keep the letter until he was older.",
        "{We} found Avette Fellwood in Duskwood and gave her the letter meant for Jeremy. She would not hide his past from him, she said, but she would not force it on him yet. She asked {us} to go."},
    [95189] = {act = "brought a crest of Lordaeron to Lady Dena Kennedy's gallery",
        "Among the rubble {we} found a weathered crest of Lordaeron, one of the few relics left of the fallen kingdom. {We} brought it to Lady Dena Kennedy's gallery in Stormwind. She marveled at its condition and set her best people to restoring it.",
        "Lady Kennedy wanted to know how in the world {we} had found the crest. It had survived the fall of Lordaeron in remarkable shape, and she thanked {us} for restoring a piece of Alliance history."},
    [95195] = {act = "gathered the bloodied insignia of Lordaeron's soldiers",
        "The ruins held the old insignia of Lordaeron's soldiers, and {we} gathered ten of them for any kin still living. In Stormwind they were taken to be handed on, though few were left to claim them.",
        "{We} carried the bloodied medals of Lordaeron's dead to Stormwind, where many of that kingdom's people had fled. Stormwind commended the work, and promised to send the insignia to the soldiers' next of kin."},

    -- Zephras Isle: Shen'dar Village, its highlands and Falaath (6-8)
    [92514] = {act = "checked in with the Windshaper elder Illaya Amberwind", solo = true,
        "When {I} came into Shen'dar Village, someone felt a little static on {my} skin and knew {me} for a Windshaper. {I} went first to the elder of {my} tradition, Illaya Amberwind. In the village the High Order and the Windshapers kept things civil.",
        "Shen'dar sent every newcomer to the elder of their own tradition, and for {me} that was Illaya Amberwind. Tension ran high between the two orders. In the village, though, everyone knew there were bigger problems, starting with its bandits."},
    [93461] = {act = "checked in with the High Order elder Rathiril Sunlance", solo = true,
        "Highborne blood showed as a twinkle in the eyes, the villagers said. They sent {me} to the High Order's elder, Rathiril Sunlance, in the main lodge. Inside the village the two traditions kept things civil.",
        "{I} met Rathiril Sunlance, elder of the High Order, as every newcomer of {my} tradition did in Shen'dar. Out in the wilds was another matter, the village warned, since what happened there stayed there."},
    [92595] = {act = "learned the Windshapers' mandate from Illaya Amberwind", solo = true,
        "Illaya Amberwind had sensed the skysight in {me} from the first moment, though {I} had never trained as a shaman. She spoke to {me} of the Windshapers' mandate. Every gifted soul was needed if the shen'dorei were ever to reach the spirits of the winds.",
        "{I} sat with Illaya and heard of the Al'Aketh, of the uncertain safety of Skywall, and of the plight of {my} people. The Windshapers' gifts, she said, were the way to save their home."},
    [92596] = {act = "learned the High Order's mission from Rathiril Sunlance", solo = true,
        "Rathiril Sunlance felt a strong aura of the arcane about {me}, though {I} had never been initiated as a mage. He spoke of his order and of the elemental benefactors the shen'dorei honored. They were gone now, and had left the shen'dorei on their own.",
        "{I} sat with Rathiril and heard of the High Order's mission. Its mages were descendants of the Highborne of Eldre'Thalas, he said. They would see the shen'dorei stand on their own, despite the Al'Aketh and every uncertainty."},
    [92515] = {act = "culled the prideclaws pressing on the village",
        "Prideclaws had grown thick in the hills and crept closer to the village each day. It seemed a mercy to cull them before a child or a pet was taken. {We} brought back a dozen pelts for the villager who meant to make goods of them.",
        "{We} hunted prideclaws through the hills around Shen'dar until {we} had the pelts the village wanted. It was dirty work, as the villager who asked for them freely admitted."},
    [92553] = {act = "brought eggs and strider meat for the village cook",
        "With the danger growing, nobody in Shen'dar had time to hunt or forage. {We} went out for fresh eggs and strider meat. The cook swore the eggs were delicious fried in ursera tallow, and offered to teach {us} a few tricks.",
        "{We} restocked the larders of Shen'dar with eggs and strider meat. The cook held that a full belly was a comfort that could not be beat. In return, the cook offered to teach {us} to cook."},
    [94411] = {act = "drove High Order mages from the standing stones",
        "Mages of the High Order kept meddling at the Windshapers' sacred standing stones, north of the village. {We} drove them off. Fighting their own kin weakened the shen'dorei, the Windshapers held, but one careless spell could destroy the island.",
        "{We} drove the High Order's mages from the standing stones, with blood where it could not be avoided. To the Windshapers, the forces binding the island were too fragile for such meddling."},
    [94413] = {act = "drove the Windshapers from the ley line in the forest",
        "Ley lines had broken through the island's surface, and the High Order valued the new access to their magic. The Windshapers called them scars to be healed. {We} went to the southwestern forest and drove them from the ley line there.",
        "{We} drove off the Windshapers gathered at the ley line in the forest. To the High Order, their stubborn refusal to change was hard to tell from the zealotry of the Al'Aketh."},
    [92516] = {act = "thinned the hippogryphs nesting by the road",
        "Hippogryphs had made their nests southeast of the village and were wreaking havoc on the road. {We} went down and thinned the flock, quickly enough to earn a word of praise from the villager who asked.",
        "Travelers on the road southeast of Shen'dar had been harried by a nesting flock of hippogryphs. {We} thinned their numbers, and the road was safer for it."},
    [93951] = {act = "gathered hippogryph down for a crafter in the village",
        "Hippogryph down made the brightest, softest plumes for skyborne hair. {We} picked up fallen feathers around the nests, minding birds that did not tolerate guests.",
        "{We} brought the crafter in Shen'dar a bundle of fallen hippogryph down. It seemed a vain thing in such times, the crafter admitted, but small joys mattered all the more now."},
    [93319] = {act = "took back windstones from the bandits' cave",
        "Windstones had been going missing from the village's reserve, and stolen ones kept turning up on captured bandits. {We} went into the bandit cave to the north, cracked a few heads and brought some of them back.",
        "Constable Aonda could not spare peacekeepers to clear the bandit cave while the cult grew at Falaath. The job fell to {us}. The windstones {we} reclaimed would help the village get by, as long as the supply routes held."},
    [93036] = {act = "sought out Sania Silverstream, the cult's missionary", solo = true,
        "Sania Silverstream recruited for the Al'Aketh in plain sight, and the village wanted someone unknown to get close to her. {I} went to her as a newcomer. She greeted {me} as a junior priestess of the order. The Windlord's table, she said, had room for the righteous and the repentant.",
        "Being new to Shen'dar, {I} could approach the cult's missionary without drawing suspicion. Sania Silverstream offered to teach {me} of Al'Akir, the Windlord her order served."},
    [92529] = {act = "went to Falaath Village as a marked recruit of the cult", solo = true,
        "Sania preached that the spirits of the wind had left the shen'dorei for their pride. She marked {me} as a recruit and sent {me} to Falaath Village. There Missionary Jasaan welcomed a new acolyte and called the day blessed by the four winds.",
        "With Sania's mark on {me}, {I} walked into Falaath Village among the faithful. Missionary Jasaan took the mark at face value and welcomed {me} into the service of Al'Akir."},
    [92551] = {act = "recovered Shen'dar's stolen supplies from Falaath",
        "For months the Al'Aketh had raided the village's caravans and blamed the bandits. {We} searched Falaath for what was left of the food and windstones. {We} brought back the caches, to be shared out among the townsfolk most in need.",
        "In Falaath {we} found supply caches taken from Shen'dar's caravans. The village had been barely getting by, and the constable would see that the goods went to the hungriest."},
    [92550] = {act = "struck Falaath first and killed the cult's commander",
        "An attack from Falaath was coming, and Shen'dar meant to strike first while it armed itself. {We} went back to Falaath and cut down the cultists and their commander. When {we} brought his head back, Sania Silverstream had slipped out of town.",
        "{We} turned the tables on the zealots at Falaath and killed their commander. Shen'dar owed {us} a debt, its people said. If the cult came back to the highlands it would find no easy target."},

    -- Zephras Isle: Valanaar and the Windfield orchard (9-10)
    [92701] = {act = "carried Constable Aonda's report to Valennia Stormfist", giver = "Constable Aonda",
        "With Shen'dar safe for now, Constable Aonda trusted {us} with her report to Valennia Stormfist, captain of the island's peacekeepers. {We} carried it down to Valanaar, and Valennia's face darkened as she read.",
        "{We} brought Aonda's letter down to Valanaar, and Valennia Stormfist chose to trust {us} because the constable did. She needed to plan with her few remaining peacekeepers. Meanwhile the townsfolk had plenty of work for a strong young adventurer."},
    [92699] = {act = "met Supreme Magister Elaadrin Evengale of the High Order", solo = true,
        "In Valanaar {I} went to the High Order's lodge, warned to give the Windshapers a wide berth on the way. Supreme Magister Elaadrin Evengale had Rathiril's missive about {me} and saw a vibrant arcane aura. Whether {I} had the boldness to match remained to be seen.",
        "Supreme Magister Elaadrin Evengale welcomed {me} on Rathiril's word. Few shen'dorei still had the aptitude and the will to save their home, he said. He meant to find out whether {I} did."},
    [92700] = {act = "met the Grand Skyseer of the Windshapers", solo = true,
        "In Valanaar {I} went to the Windshapers' lodge, warned to give the High Order a wide berth. The Grand Skyseer already had Elder Amberwind's message about {my} deeds in Shen'dar, and welcomed {me} as a friend.",
        "The Grand Skyseer said {I} had a strong aura and a resonance with the spirits. Fewer and fewer shen'dorei had the skysight, she said. The island needed every one of them if it was to survive."},
    [93948] = {act = "brought Talaanis Shadowsong his dead nephew's signet",
        "{We} carried the signet ring from the tower to Talaanis Shadowsong, High Elder of the island. With it went the news that his nephew was dead. He thanked {us}, and sent {us} on to Valennia Stormfist, who needed all the help she could get.",
        "Talaanis Shadowsong was well loved by his people, and {we} had to tell him that his nephew had died. He took back the ring. It was rare, he said, for such capable young adventurers to come down from the highlands."},
    [92679] = {act = "carried Alvarion Windfield's plea to his wife at the orchard", giver = "Alvarion Windfield",
        "In Valanaar a wounded man, Alvarion Windfield, asked {us} for help to save his farm. {We} went west to the orchard and told his wife Aamelia what had become of him. He had likely sent {us} there to die for nothing, she warned.",
        "Aamelia Windfield was glad to hear her husband was safe in Valanaar. She called him an idiot, all the same, for sending strangers to her orchard. This was not {our} fight, she said, and anyone with sense would leave now."},
    [92682] = {act = "gathered stormapples and cleared bandits from the orchard", giver = "Aamelia Windfield",
        "{We} had more courage than sense, by Aamelia's reckoning, so she put {us} to work for {our} meals. {We} gathered the day's stormapples and killed the bandits sneaking among the trees. She watched from her window and called it not bad.",
        "Some of Ferauu's bandits had come early to tamper with the harvest, and {we} cut them down among the stormapple trees. Aamelia had the day's apples, and a better idea of what {we} could do in a fight."},
    [92683] = {act = "swatted flutterflies for their wing dust",
        "Aamelia handed {us} a flutterfly swatter and sent {us} into the outer fields. The giant bugs shook out piles of wing dust when swatted, and some took offense. {We} came back with the dust, and plenty of it in {our} clothes.",
        "{We} spent a while swatting giant flutterflies in the fields by the orchard for their dust. Aamelia had put the chore off for weeks with bandits about, and would not say what she wanted it for."},
    [92684] = {act = "culled the galestriders raiding the orchard",
        "Galestriders had been stealing stormapples in a year when the harvest was already light. {We} went out to the fields after the lowland kind, bigger and angrier than those of the highlands. {We} brought Aamelia back big tenderloins.",
        "{We} culled the galestriders in the fields, wary of a kick that could put a fighter down for good. Aamelia had not had real meat for supper in too long. She meant to make a hot meal of it."},
    [92685] = {act = "broke the bandit camp in the hills and took their masks",
        "Aamelia meant to hit Ferauu's people before they came for her. {We} went up to the small bandit camp in the hills north of the orchard. {We} brought back their masks, bloody enough to please her, and she said she had begun to hope.",
        "{We} cracked skulls at the bandits' hill camp and came back with a pile of bloody masks. Aamelia had spent weeks waiting for the end, she admitted. Now she asked {us} to see it through with her."},
    [92693] = {act = "stood with Aamelia against Ferauu and his thugs",
        "Ferauu and his thugs came at last for their share of the harvest. Aamelia offered {us} one last chance to walk away. {We} went out with her, heads held high, and when it was over she could hardly believe it.",
        "{We} stood {our} ground beside Aamelia Windfield in her orchard when the bandits came. She had been ready to die that day. Afterwards she said there were not stormapples enough in Skywall to repay {us}."},
    [92698] = {act = "asked about the old construct muttering in the fields",
        "In the fields by the orchard an old construct wandered. {I} leaned close to hear the broken words beneath its armor plates, function errors and questions. Aamelia said it had wandered there since the wind elementals left, and that the Windshapers had once kept such things.",
        "{We} listened to a giant construct mutter fragments about its function, over and over. Aamelia Windfield told {us} it had been there for decades. Alvarion thought it had once hauled harvests or tended livestock."},
    [92703] = {act = "brought Alvarion word of the stand at the orchard", giver = "Aamelia Windfield",
        "Aamelia stopped calling {me} a stranger and asked {us} to tell Alvarion what had happened. Alvarion wept as {we} told it, and said he had come looking for hope and found a hero.",
        "{We} carried the news from the orchard back to Alvarion Windfield in Valanaar. He would never forget what had been done for them, he said. {We} would always be welcome at the Windfield home."},
    [93317] = {act = "gathered Windsong crawlers before their season closed",
        "Windsong crawlers lived only in Windsong Lake and could be harvested a few weeks of the year. The cult had kept their gatherer from the shore. {We} caught them along the lake and its rivers before the season closed, and found them meaner than they looked.",
        "{We} brought back a haul of Windsong crawler meat, and the gatherer said it looked fantastic. It had been a delicacy on Anvilas and Siroccas once, back when the skystreams were open."},
    [93318] = {act = "killed Vulgara the Insatiable for the peacekeepers' bounty",
        "A bounty from Constable Aonda named Vulgara the Insatiable, a winged vuldren terrorizing the highlands. {We} killed her on a hilltop southwest of Shen'dar and took her head to Danarii Bellowveil for the reward.",
        "{We} brought down Vulgara the Insatiable, a giant vuldren that had preyed on the highlands. Danarii Bellowveil paid the bounty, glad of one danger less with the cult and the bandits to face."},
    [93736] = {act = "dispersed the hollows of Shadowgale Forest for Endaria",
        "Strange wind sprites called hollows had appeared in Shadowgale Forest after the spirits left, and the Windshapers wanted to know why. {We} went into the forest some called haunted, dispersed the hollows and brought back their remains.",
        "{We} carried the remains of the hollows out of Shadowgale Forest to Endaria of the Windshapers. She shuddered as she handled them, feeling a malevolent, regretful aura, and did not look forward to studying them."},
    [93738] = {act = "traced the broken construct to Belathaan of the High Order",
        "The construct's missing parts pointed to Belathaan Brightwish of the High Order, which was forbidden to meddle with Windshaper knowledge. {We} took what {we} had learned to Ayessa Dawnsinger. She knew Belathaan as Valennia Stormfist's cousin and was disappointed to hear it.",
        "{We} reported to Ayessa Dawnsinger that the High Order had stripped the old construct. Belathaan's mother had been a Windshaper, she said, and she needed a moment to reflect on it."},
    [94003] = {act = "took back the Skybreaker Bulwark from Zaal Stormshield", giver = "Seena",
        "Seena was the last of the Skybreakers, the rest murdered by the Al'Aketh. The family's ancestral shield was in the hands of a cultist. {We} found Zaal Stormshield at the Shrine of Akir and took the Skybreaker Bulwark back from him.",
        "{We} brought the Skybreaker Bulwark back to Seena, and the Skybreaker family's honor was restored. In thanks Seena taught {me} the Skybreaker Defense, a gift few were thought worthy of. Seena also gave {me} a shield that was no longer needed."},

    -- Zephras Isle: the war with the Al'Aketh (11-13)
    [93320] = {act = "went to relieve the besieged east watchtower", giver = "Valennia Stormfist",
        "Word came that the cult was attacking the pylon watchtower east of Valanaar. Valennia Stormfist sent {us} after her last spare peacekeepers. {We} found her lieutenant Yorana Windyreed alive and holding, but outnumbered and tiring.",
        "{We} hurried to the east watchtower, where the cult was pressing its assault. Yorana's fighters were holding them off for now, but the stalemate had to break, and soon."},
    [92642] = {act = "cut down the cult's healers below the watchtower", giver = "Yorana Windyreed",
        "Yorana could hardly believe Valennia had sent so little help against a full assault, but she took what she could get. {We} went down the hill and cut down the cult's healers. She called it a small miracle that {we} came back alive.",
        "The cult's healers kept its attackers coming, so {we} went down the hill to break their logistics. With them dead, Yorana hoped her people could rally and push the cultists back."},
    [92645] = {act = "killed Belguilos the Breaker, the cult's commander",
        "Belguilos the Breaker, a former peacekeeper who had been off even then, commanded the assault from a villa below the hill. Yorana feared she was sending {us} to {our} death. {We} killed Belguilos, and the watchtower might hold after all.",
        "{We} went down to the villa at the hill's base and ended Belguilos the Breaker, who led the cult's attack. Yorana blessed the four winds, and began to think her people might come out of it alive."},
    [92880] = {act = "carried Yorana's report back to Valanaar",
        "Yorana had asked for reinforcements and got a burgeoning hero instead, she said. She sent {us} back to Valanaar with her report. Valennia looked visibly relieved to hear the eastern watchtower was stable.",
        "{We} brought word to Valennia Stormfist that the east watchtower was stable and the last attackers were being mopped up. She thanked the winds, and Yorana's blessing went with {us}."},
    [92881] = {act = "went to High Elder Shadowsong about the anchor pylons",
        "The attacks on both watchtowers were no coincidence. The peacekeepers guessed the cult was after the anchor pylons. {We} went to High Elder Shadowsong, who had a lead and a small matter for an adventurer.",
        "High Elder Shadowsong had a lead on what the cult wanted with the anchor pylons, and {we} went to hear it. He had a small matter that needed just {our} kind of help."},
    [94568] = {act = "weighed the cult's plans with Valanaar's leaders",
        "A turncoat had fled the cult in fear of its plans, and died before he could tell them. He left only a damaged crystal. {We} talked it over with Valanaar's leaders. They judged that peacekeepers would not fare well against the cult in open battle.",
        "The turncoat had risked everything to bring Valanaar his crystal. Talking it through with {us}, the town's leaders saw that open battle would go badly. They needed a different approach."},
    [92834] = {act = "took prayer charms from the cultists for Elaadrin Evengale",
        "Elaadrin Evengale had sent his friend Belathaan Brightwish to the Shrine of Akir to talk peace. A box came back holding his tongue, dipped in silver pigment. {We} killed cultists for their prayer charms, and Elaadrin's eyes crackled with arcane light as he took them.",
        "{We} brought the Supreme Magister the prayer charms of the cultists {we} had killed. He admitted the Windshapers had been right about the Al'Aketh. The cult, he said, had mistaken the High Order's prudence for weakness."},
    [92840] = {act = "guarded a High Order device at the standing stones",
        "The magic that sustained the island lingered at the Windshapers' sacred standing stones. The High Order wanted it studied while the Windshapers looked elsewhere. {We} set the device among the stones and guarded it while it gathered its data. Windshaper blood was spilled when they came.",
        "{We} took the High Order's device to the standing stones in the highlands and protected it until its work was done. The Windshapers would not retaliate in Valanaar, Elaadrin said, but they would not forget."},
    [93740] = {act = "took prayer charms from the Al'Aketh for Ayessa Dawnsinger",
        "Windshaper novices had been found dead in the highlands, and Ayessa Dawnsinger suspected the Al'Aketh. Windshapers traded blood for blood, so {we} went north, killed cultists and brought back their windstone prayer charms.",
        "{We} handed Ayessa the windstone charms of the Al'Aketh {we} had killed. She looked shaken and distant, and would say only that it had been a trying day."},
    [98512] = {act = "killed the Al'Aketh skulking around a house near the border",
        "A scout near the border pulled {us} down low and pointed out Al'Aketh skulking around a house on the hill. {We} went in and killed them while the scout watched {our} backs. What they had been after stayed a question.",
        "{We} cleared the house on the hill of the Al'Aketh assassins, who looked like cold killers to the scout keeping watch. The scout was glad {we} made it back, and meant to mention {us} in the report to Valanaar."},
    [93065] = {act = "met the peacekeepers on the eastern road before the march",
        "Valanaar's peacekeepers were mobilizing against the cult. {We} made {our} preparations and met them on the eastern road north out of town. At the final check they said they were as ready as they would ever be.",
        "{We} joined the peacekeepers gathering on the road north of Valanaar for the march on the cult. Everyone had made what preparations they could, and the march could begin."},
    [92947] = {act = "fought through the cultists to the steps of the shrine", giver = "Valennia Stormfist",
        "Valennia sent her best fighters at the shrine's front as a distraction, and led the two orders in from the flank. {We} went in cracking skulls, and met her second, Hyusaa Quickbreeze, at the steps of the shrine.",
        "{We} cut a way through the cultists of the Shrine of Akir while Valennia's forces pushed for the High Priestess. At the shrine steps Hyusaa Quickbreeze said they had fought hard to get this far. It was not over yet."},
    [93958] = {act = "went into the silent inner sanctum and found Valennia",
        "Valennia's forces had breached the inner sanctum, and after thick fighting it had gone unsettlingly quiet. {We} went in to find her, and found her alive but gravely wounded.",
        "A fighter stayed at the entrance to watch {our} backs while {we} went into the inner sanctum. Inside, among what was left of her forces, {we} found Valennia Stormfist gravely wounded."},

    -- Zephras Isle: Shadowgale Forest and the Nightfang Den (11-13)
    [94896] = {act = "recovered the refugees' belongings from Ban'aethal", giver = "Ealaane",
        "Ealaane and the refugees of Ban'aethal had fled in the night when their village began to fall into the sky. Many had only the clothes on their backs. {We} went into the ruins and recovered what belongings {we} could find, a place for them to start over from.",
        "{We} searched the fallen village of Ban'aethal for things its people had left behind. Ealaane promised to return each one to its owner, and called it a great kindness to the refugees."},
    [94897] = {act = "learned Resaan's fate in the ruins of Ban'aethal", giver = "Ealaane",
        "Resaan had gone back to Ban'aethal for supplies, though Ealaane begged him not to. A week had passed without word. {We} found him dead in the ruins and brought back his heirloom, and her eyes filled with tears.",
        "In the ruins of Ban'aethal {we} learned what had become of Resaan, and {we} carried his heirloom back to Ealaane. The world had taken both her home and her love, she said, but the heirloom gave her some closure."},
    [94484] = {act = "went looking for the silent druids of Shadowgale Forest", giver = "Lotheluum",
        "Lotheluum had waited too long for word from the druid conclave in Shadowgale Forest. With Ban'aethal in ruins he feared the worst. {We} found Elegael Thornpaw at the cave, and she paled to learn that no reinforcements were coming.",
        "{We} went into Shadowgale to find out why the druids had gone silent. Elegael Thornpaw had sent for help that never reached Valanaar. With only {us} there, she resolved that they would handle it on their own, and quickly."},
    [94493] = {act = "answered Elegael Thornpaw's plea in the den",
        "Elegael Thornpaw took {us} for the first of the reinforcements, and paled when {we} explained. Her message had never reached Valanaar. The cultists had struck with little warning, she told {us}, and left many in her den wounded or dying.",
        "{We} reached the druids of Shadowgale after an Al'Aketh ambush and found Elegael ready to act without Valanaar. Many of her fellows lay wounded or dying, and she begged {us} for help before it was too late."},
    [94486] = {act = "gathered young shriekling feathers for Elegael's poultices",
        "Elegael's poultices needed the insulating feathers of young shrieklings. They were normally docile but hostile of late, with talons that could disembowel the careless. {We} hunted them, and she promised to use every feather so their deaths were not wasted.",
        "It saddened Elegael to send {us} after the young shrieklings, but the den could only handle so many emergencies. {We} brought back their feathers to keep the moss of her poultices from drying out."},
    [94487] = {act = "killed cultists and took back the heirlooms they wore",
        "The Al'Aketh had ambushed the druids for reasons Elegael could not fathom. They did not deserve to be called shen'dorei, she said. {We} slew the cultists and took the heirlooms they wore, and she looked at the bloodied relics with distress.",
        "{We} brought Elegael the bloodied heirlooms of the young cultists {we} had killed, relics meant for those coming of age. So many young lives gone, she said, and she would keep the heirlooms for a worthier generation."},
    [94488] = {act = "took the head of Haalien, the druid who joined the cult",
        "Over the bloodshed Elegael caught a familiar scent. It was Haalien, a druid of the circle who had vanished months before and joined the cultists. {We} took his head. She grimaced but nodded, for he was her cousin, and she could not easily have struck him down herself.",
        "{We} hunted down Haalien, the druid who had spilled his own kin's blood for the Al'Aketh. Elegael told {us} not to mourn him, since his malice had killed many innocents that day."},
    [94490] = {act = "found the cult's orders behind Haalien's bracer",
        "Tucked behind Haalien's bracer {we} found a torn, bloodstained note, and brought it to Elegael. The cult had come for the pylon, she read, and her people had died for being in the way. She shook with rage.",
        "{We} carried the bloodstained missive from Haalien's body to Elegael, who swore to tear apart every cultist with her fangs. If the orders came from Valanaar, a traitor was hiding there, and Lotheluum had to know."},
    [94489] = {act = "carried poultices to the wounded druids of the Nightfang Den",
        "Elegael's poultices were ready. {We} took them across the clearing into the Nightfang Den, where the druids lay too hurt to heal themselves. {We} tended seven of them and searched for her mate, Jorel Windsinger. The news {we} brought back made her choke back a sob.",
        "There were so few shen'dorei druids that every life was precious. {We} went from one wounded druid to the next in the Nightfang Den. When Elegael heard what had become of Jorel, she swore that all who allied with the Al'Aketh would feel her wrath."},
    [94491] = {act = "brought Lotheluum the news of the Nightfang Den",
        "Elegael was in no shape to travel, and had cultists still to slay. {We} carried word of the den and its dead to Lotheluum in Valanaar. He looked terrified as {we} told it, and needed a moment before he could speak.",
        "{We} brought the missive and the news of the fallen druids to Lotheluum. If it was genuine, Valanaar held an accomplice or a traitor. He meant to take it straight to the High Elder."},
    [93165] = {act = "brought the Nightclaw the ears of slain cultists",
        "The Al'Aketh had brought tragedy to the Nightclaw enclave, and its druids meant to repay blood with blood. {We} brought back the ears of the cultists {we} had killed, and each one was paid for in coin.",
        "{We} answered the Nightclaw's offer and returned with ten Al'Aketh ears. The druid who paid {us} hoped the cult understood how deep their resentments ran, and asked {us} to bring more."},
    [93459] = {act = "brought Vayn Moonclaw the ears of Al'Aketh cultists",
        "The druids of Shadowgale Forest kept its haunted name alive to be left in peace. The Al'Aketh had come anyway, and many of the druids were afraid. {We} fought the cultists for Vayn Moonclaw and brought back their ears, and Vayn paid as promised.",
        "Vayn Moonclaw offered coin for every Al'Aketh ear, and in time the secrets of the order to a true friend. {We} brought in ten, and took the first of that reward."},
    [92741] = {act = "hunted shrieklings in Shadowgale Forest for their talons",
        "Shrieklings had multiplied in Shadowgale Forest and begun spreading beyond the woods. A scholar of the High Order wanted their talons. {We} went into the forest, usually off limits to ordinary adventurers, and came back with quite a haul.",
        "{We} culled the shrieklings of Shadowgale Forest and brought their talons to the High Order. Its mages did not usually work as trappers, the scholar admitted, but could not wait to dig into these."},
    [93159] = {act = "talked with a strange hermit in Shadowgale Forest",
        "Deep in Shadowgale {we} met a hooded hermit, so long out of company that the words came out in a stammer. Friends and handmade things were all the hermit needed, {we} heard. Still, it was nice to be answered for once.",
        "{We} stopped to talk with the strange hermit of Shadowgale Forest, who asked shyly how {our} day was going. The forest spirits only ever sang back, the hermit said, so a visitor who talked was a welcome change."},
    [93160] = {act = "gathered acorns for the hermit among the raptor-birds",
        "The hermit had gathered the acorns close to home and would rather not become a giant bird's lunch going farther. {We} picked them up from the forest floor among the raptor-birds, and the hermit went off happily to roast them.",
        "{We} gathered acorns across the forest floor in Shadowgale, where raptor-birds roamed. The hermit promised they were delicious roasted, and set about cooking something for {us}."},
    [93172] = {act = "freed the trapped spirits at the old ruins",
        "At the old ruins northeast of the hermit's home gathered ghost-like spirits whose singing, on some nights, was terribly sad. {We} went there and set them free, and the hermit hoped they would find peace.",
        "The woods were haunted, the hermit admitted, and something terrible had once trapped the spirits at the old ruins. {We} released the spirits gathered there, and the hermit thanked {us}."},

    -- Dun Morogh and the Hall of Thanes (6-16)
    [97277] = {act = "fetched Gozwin's mechanic's log from the camp in the hills", giver = "Grund",
        "Grund had fired his shotgun over a snow leopard dragging his friend Gozwin away. In the scramble the gnome's mechanic's log was lost. {We} went up to their camp in the northwestern hills and brought it back. The leopard had been at the boar they were roasting.",
        "Gozwin worried more about his mecha-walker's log than his own deep scratches. {We} climbed to the camp in the hills and fetched it. Grund thanked {us} for making the trek and for protecting the hills."},
    [98321] = {act = "recovered the lost ore shipments from the Grizzled Den",
        "Wendigos had overrun the Grizzled Den, the forge's best source of ore. The miners had dropped everything as they fled. {We} searched the cave for the missing shipments, and Flintfire expected his forge to be running in no time.",
        "{We} went west into the Grizzled Den among the wendigos and came out with the shipments the miners had left behind. Flintfire was glad of the ore, and gladder that the miners had all made it out alive."},
    [98322] = {act = "checked on Mountaineer Gretchen for Senir Whitebeard",
        "Senir Whitebeard left spelunking to adventurers and kept to his reports, but one of his mountaineers had not reported back. {We} went west of town to check on Mountaineer Gretchen, who had his report and called the whole situation a mess.",
        "Whitebeard was late with his reports to Ironforge and asked {us} to look in on Mountaineer Gretchen. {We} found her west of town, with news that the wendigos had made a mess of the hills."},
    [98319] = {act = "searched the Grizzled Den for Mountaineer Cornelius",
        "Wendigos had filled the Grizzled Den, and Gretchen's partner Cornelius had charged in head first. He was brave but stupid, she said. {We} went into the cave after him, killing beasts as {we} went. What {we} found made her call him a fool, and thank {us}.",
        "{We} went into the Grizzled Den to find Cornelius, fighting through the wendigos that had spread through it. What {we} found there gave Gretchen her report, and it had cost her a partner."},
    [98323] = {act = "carried Gretchen's word of the lost den to Whitebeard",
        "Gretchen would send nobody else into that death trap. She gave {us} her word for Whitebeard that the cave was a lost cause. He was not surprised to hear it was completely overrun, and folded her letter into his pile of notes.",
        "{We} came back to Senir Whitebeard looking, he said, as if {we} had seen a ghost, and gave him Gretchen's letter. The Grizzled Den was completely overrun, and that was going in the report too."},
    [99158] = {act = "brought holy candles to Father Gavin's hermitage",
        "Father Gavin, a priest of the Argent Dawn, had fixed up an old building in the mountains as a rest for travelers. A shipment of holy candles was waiting for him. {We} carried it up to his hermitage, and he was glad of it.",
        "{We} climbed into the peaks with candles from Ironforge for Father Gavin, a priest who would rather heal than fight. He lived mostly on his own, he said, but valued a few things from the city and the pious."},
    [99159] = {act = "gathered firewood for Father Gavin's hearth",
        "Father Gavin's hearth was open to any soul, but he had been too busy to gather wood for it. {We} collected fourteen pieces around the hermitage, and he set the wet ones aside to dry.",
        "{We} brought firewood to the hermitage so Father Gavin could keep his hearth warm for travelers. He was pleased, and had more tasks for anyone willing."},
    [99160] = {act = "put down the riled elementals near the hermitage",
        "A shelf of rock and ice had fallen from the peaks and riled the elementals near the hermitage. The road was treacherous enough already. {We} killed them. Father Gavin wished they could have been calmed, but they were too dangerous to leave.",
        "Father Gavin was no longer one for fighting. {We} went out among the angry spirits of ice and stone and put them down. The mountain road was safer for it."},
    [99161] = {act = "killed the elemental Avala and brought its core to Father Gavin",
        "The first elemental after the rockslide had been larger than the rest. Father Gavin called it Avala, and thought it the cause of the sudden weather and the smaller slides. {We} killed it and brought him its core.",
        "{We} hunted down Avala, the great elemental that troubled the peaks, and carried its core back to the hermitage. Father Gavin blessed {us}, hoping it would spare the mountain unnecessary deaths."},
    [99162] = {act = "brought back the rifles of fallen mountaineers",
        "After every slide Father Gavin searched for survivors, praying to find nothing, but the restless elements kept him close to home. {We} went out in his place and brought back the rifles of mountaineers the peaks had claimed.",
        "{We} found the rifles of fallen mountaineers in the peaks, each with its owner's name engraved on the stock. Father Gavin would send them back to Ironforge, to be passed on to their families."},
    [98326] = {act = "killed Frosthowl and took back a fisherman's catch",
        "A wendigo called Frosthowl had stolen a sack of fish that took days to catch on the frozen lake. The fisherman's wife could not bear to tell her husband Paxton. {We} found the brute deep in the Grizzled Den, killed it and brought back the haul.",
        "{We} went into the Grizzled Den after Frosthowl, the loudmouthed wendigo that had robbed Paxton's wife. With the catch back, Paxton would not have to spend another night on the lake. There might be a real feast."},
    [95041] = {act = "found Jemma Quikswitch's lost punch cards in the snow",
        "Jemma Quikswitch had copied her family's archives before fleeing Gnomeregan, from submarine hull designs to Grandma Quikswitch's chili recipe. A hole in her pack had lost her several punch cards. {We} searched the snow outside the gnomes' old city and found them.",
        "It was a long shot, Jemma admitted, but {we} dug her lost punch cards out of the snow outside Gnomeregan. They were a bit damp, and she thought she could work with them."},
    [95212] = {act = "hunted leopards for the saddles of rams bound for Alterac",
        "Amberstill Ranch was sending rams to reinforce the Alliance expedition in Alterac and had run out of saddle leather. {We} hunted the largest, fiercest leopards to the east for their pelts. The ram handler said {we} had done the Alliance proud.",
        "Only the finest pelts would keep the riders warm in Alterac. {We} went east into the biting cold after the biggest leopards. The pelts {we} brought back would make excellent saddles."},
    [95214] = {act = "took back the quarry's blasting powder from the troggs",
        "Troggs had stolen a keg of blasting powder from the Gol'Bolar Quarry. It was enough, said Quarrymaster Thesten, to turn King Magni's throne room into an open-air courtyard. {We} took it back before they worked out how to light it.",
        "{We} recovered every bit of the stolen powder from the troggs for Quarrymaster Thesten. He paid {us}, and asked that {we} not mention the little incident to anyone."},
    [96408] = {act = "went to see who kept a campfire above the Gol'Bolar Quarry", giver = "Beldin Steelgrill",
        "A mountaineer had seen a campfire high on a hillside above the Gol'Bolar Quarry. Beldin Steelgrill sent {us} up to see whose it was. If they were not friendly, {we} knew what to do. The fire's keeper, Earthseer Farsen, greeted {us} cheerfully.",
        "{We} climbed to the camp overlooking the quarry, ready for trouble. Earthseer Farsen kept the fire, and he welcomed {us} as friends."},
    [96392] = {act = "saw the Dark Irons through Earthseer Farsen's farsight", solo = true,
        "Earthseer Farsen had come down from Aerie Peak and noticed a Dark Iron problem on the way. With a bit of his magic he showed {me} the hills from the sky, where the Dark Irons were thick as cockroaches.",
        "Through Farsen's farsight {I} saw what he meant, Dark Iron dwarves spread across the land below like cockroaches. He judged {me} sturdy enough, and asked for a bit of violence."},
    [96390] = {act = "killed the Dark Iron spies at Ironband's Compound", giver = "Earthseer Farsen",
        "Dark Iron spies had slipped into the dwarves' lands for reasons nobody knew. Farsen wanted them nipped in the bud. {We} went east to Ironband's Compound and cut them down. He shed no tears for cousins who were not family.",
        "{We} broke up the Dark Iron band at Ironband's Compound in the east. Farsen hoped it would put them off further incursions. He had no pity for any who strayed so far from their accursed mountain."},
    [96391] = {act = "found a Dark Iron map of tunnels beneath Ironforge",
        "Among the Dark Irons {we} found a map, its runes in their jagged script. Tunnels and highways met at a point beneath Ironforge itself. As {I} read it, a gust of wind carried a faint dwarven voice. {We} took the map to Earthseer Farsen.",
        "{We} brought Farsen the Dark Iron map, and he read it as a plan to break into the vaults beneath Ironforge. The band at the compound had been a scouting force, and if {we} hurried {we} might beat them there."},
    [96394] = {act = "put the restless dead of the vaults back to rest",
        "Something had disturbed the tombs below, and the keepers refused to go into the hall on account of ghosts. {We} went down into the vaults and put the woken dead back to sleep, fifteen of them.",
        "Strange noises came up from the deep vaults, where the dead slept lightly and something had woken them. {We} put them down, and the keeper was glad to have the others back at their duties."},
    [96395] = {act = "laid the grudge-bound thane Faldrim Anvilmar to rest",
        "A ghostly attendant among the tombs begged {us}, a few words at a time, to give its master rest. {We} found the thane, Faldrim Anvilmar, consumed by an ancient grudge, and put his spirit to rest.",
        "In the deep tombs {we} met the spirit of an old thane who could not rest for an ancient grudge. {We} laid Faldrim Anvilmar down at last, as the ghost who served him had asked."},
    [96403] = {act = "recovered the vaults' heirlooms for a gnome named Thom",
        "A gnome named Thom had been patrolling the vaults, or so he said. Then the Dark Irons came out of the depths in mole machines. {We} gathered the priceless loot he feared for, important cultural heirlooms, as he corrected himself.",
        "{We} brought Thom eight heirlooms from the vaults, and he called {us} brave and enterprising. He set about appraising them, or rather cataloguing them, so they could go back to their proper places."},
    [96393] = {act = "killed Durgen Dirgehammer and took his head to King Magni",
        "Farsen made out one name on the map, Durgen Dirgehammer, and sent {us} down through the hall to the lower vaults. {We} took the commander's head to King Magni Bronzebeard, who was relieved and promised to seal the breaches beneath his city.",
        "{We} carried Dirgehammer's head out of the deep vaults and brought it to King Magni Bronzebeard, with Farsen's regards. The king thanked {us} for {our} service, and asked that the old Wildhammer rockhugger come for a proper visit."},
    [98423] = {act = "brought King Magni an old treaty tablet from a vault",
        "In a vault {we} found a tablet. It set out a peace between the Bronzebeard and Wildhammer clans after the War of the Three Hammers. {We} brought it to King Magni. He traced it to the reign of his ancestor Madoran, and showed {us} that the Dark Irons had never signed.",
        "King Magni knew the old treaty at once when {we} brought it up from the depths. It had set down the peace after his ancestor Madoran's clan won the mountain. The Wildhammers had signed it, and the Dark Irons had not."},

    -- Elwynn: Brother Paxton's library, Eastvale and Crystal Lake (2-10)
    [91741] = {act = "returned a nibbled volume to Brother Paxton",
        "One of the kobolds dropped a volume that looked half eaten. {We} carried it to Brother Paxton, who kept a small library in the abbey. He feared the kobolds had been at his collection, and wondered what to do about the rest.",
        "{We} brought Brother Paxton a volume a kobold had tried to eat. It was supposed to be on his shelf, and most of his collection was still missing."},
    [92124] = {act = "had Paxton's assistant Daniel count the empty shelves",
        "Brother Paxton wanted to know how many of his volumes were gone. He sent {us} to his assistant Daniel, who cared more for the trade professions than his duties. Daniel had warned him three times about kobolds tunneling under the abbey, and whole shelves stood empty.",
        "{We} kept Daniel from prattling about tradeskills long enough to hear the count. It was grim, whole shelves emptied by the kobolds. He still offered to point {us} to the local trainers."},
    [91743] = {act = "rescued Paxton's stolen volumes from the kobolds",
        "The kobolds were carrying off Brother Paxton's library, and {we} took eight volumes back from them. Paxton gave {us} a how-to manual he did not need. He wondered aloud why the kobolds wanted his collection if they were not eating it.",
        "{We} took eight of Paxton's volumes back from the kobolds around the abbey. Many more were missing, and whatever the kobolds wanted them for, it was not food."},
    [91745] = {act = "asked the mining apprentice Kelsey Fargo about the kobolds",
        "Kelsey Fargo, a new mining apprentice, worked right outside the kobolds' tunnels, and {we} went to ask what she had seen. Kobolds ran back and forth with Paxton's volumes, she said, yelling at each other as they went.",
        "{We} found Kelsey Fargo, the new mining apprentice, working outside the mine, and she confirmed what Paxton feared. Kobolds were hauling his library out of the abbey."},
    [91752] = {act = "took Narf's sack of stolen volumes to Marshal McBride",
        "Kobolds kept coming out of the mine yelling about pictures for Narf. Kelsey guessed Narf was a leader at the back, with a sack of stolen volumes. {We} went in where the kobolds were meaner and brought the sack to Marshal McBride, who called {us} quite the hero.",
        "{We} fought through the meaner kobolds at the back of the mine and took the sack of stolen volumes from Narf. Marshal McBride promised to get them back to Brother Paxton at once."},
    [91758] = {act = "went to Tordrin Sternblade to track a kobold thief", giver = "Marshal McBride",
        "Kelsey had seen another kobold leave the mine with a large sack, and Marshal McBride wanted it tracked. {We} went to Tordrin Sternblade, the new hunter trainer from Ironforge. He agreed to whip something up for the hunt.",
        "{We} found Tordrin Sternblade by the stable behind the abbey, newly arrived from Ironforge. He was ready to help track the kobold thief down for the marshal."},
    [91772] = {act = "followed kobold tracks down to Marshal Dughan in Goldshire",
        "Tordrin suspected the thieves were up to something beyond the valley. With his tracking kit {we} followed the kobold's trail out of it. {We} brought what {we} found to Marshal Dughan in Goldshire. Of course they were headed for the Fargodeep Mine, he said.",
        "{We} tracked the kobold thief all the way down to Goldshire and reported to Marshal Dughan. He was unimpressed, since Fargodeep Mine was infested with kobolds, but someone would have to deal with it."},
    [91775] = {act = "recovered Paxton's volumes from the depths of Fargodeep",
        "Marshal Dughan gave {us} a bag for Paxton's volumes and warned that the depths of Fargodeep Mine were dangerous. Paxton worried most about one called Fun with Elementals, which even a kobold might use to summon a servant. {We} brought out six of the missing titles.",
        "{We} went down into Fargodeep Mine and found most of Brother Paxton's missing volumes. Dughan applauded {our} diligence, let {us} keep the bag, and guessed the rest had gone to the Jasperlode Mine."},
    [91777] = {act = "recovered Paxton's last two volumes from Jasperlode Mine",
        "Two titles were still missing, one on geomancy and one explaining arcane magic in simple words. They had gone to the Jasperlode Mine. If the apprentice kobold could summon an elemental, there was no telling what its master could do. {We} went in and brought them back.",
        "{We} returned the last two volumes from Jasperlode to Brother Paxton, and his library was saved. In thanks he gave {us} one of the fine weapons meant for the militia."},
    [91753] = {act = "studied the enchantments in kobold wax effigies", solo = true,
        "Kitta Firewind held that an enchanter needed practice as well as theory. She pointed {me} to the kobolds, who bound simple cantrips into wax effigies without any schooling. {I} took some from them and picked their enchantments apart.",
        "{I} unpicked the crude enchantments in the kobolds' wax effigies as Kitta Firewind asked. Theory and practice were two sides of a coin, she told {me}, and {I} should remember it."},
    [99127] = {act = "checked the fish traps Lee had set in the lake", giver = "Jason Mathers",
        "The fisherman Jason Mathers had not seen a single minnow in Crystal Lake, and Lee had set traps overnight. {We} went to check them and found every net damaged. Jason feared he would go broke if nothing was done.",
        "{We} pulled up the traps Lee had set in Crystal Lake and found them all torn. The new neighbors on the lake, Jason saw, were doing more harm than anyone had known."},
    [99128] = {act = "thinned the murlocs across Crystal Lake", giver = "Jason Mathers",
        "The damage could only be the murlocs on the far side of the lake, with their vicious tempers and teeth to match. {We} went over and cleared them out a bit, though Jason expected them to make up their numbers quickly.",
        "{We} fought the murlocs across Crystal Lake for the sake of its fish. Jason could still hear their warbling from his spot, and swore it would be in his nightmares."},
    [99129] = {act = "asked Remy in Goldshire how to keep murlocs away", giver = "Jason Mathers",
        "Jason was sure Remy in Goldshire hated murlocs as much as he did, and sent {us} to ask for ideas. Remy had been warning the guards about the murlocs for a while, and they would not listen.",
        "{We} went to Goldshire to talk murlocs with Remy. He had a few ideas for getting back at them, and needed {our} help to gather what he needed."},
    [99130] = {act = "gathered duskweed for Remy's murloc bait",
        "Remy's plan was bait made from duskweed, a farm weed whose petals were toxic in large amounts. The farmers would get their fields cleared in the bargain. {We} gathered what he needed, and he made a simple, poisoned bait.",
        "{We} picked duskweed on the farms around Goldshire for Remy's murloc bait. It was safe enough as long as nobody's pet got into it, he said, and Jason was not to eat any."},
    [99131] = {act = "told Jason Mathers that Remy's bait was ready",
        "Remy hoped the bait would put Jason Mathers back in business and leave fewer murlocs in the world. {We} carried the word back to Crystal Lake, and Jason meant to visit Remy later to pick it up.",
        "{We} told Jason the bait was poisoned, and he did not mind, as long as the fish would not eat it. He hoped to be selling his catch before long."},
    [99143] = {act = "gathered murloc baubles for an angler's bait",
        "An angler reasoned that murlocs must think like fish, so anything they liked, the fish would like too. {We} rummaged through the murlocs' junk and brought back whatever looked like good bait.",
        "{We} brought the angler an interesting collection of bottles and baubles from the murloc camps. In return {we} got some older fishing supplies, good for anyone finding their footing."},
    [91733] = {act = "fished a carter's lost supplies out of the river",
        "A carter's wagon had tipped over on the way back from the trading post. The supplies washed downstream among the murlocs and wolves. {We} went down the river and fished them out, and came back a bit damp for it.",
        "{We} followed the river down past murlocs and wolves to the supplies that had washed off an overturned wagon. Their owner apologized for {our} soaking and thanked {us} for bringing them back."},
    [91732] = {act = "brought Hagar Lowe old picks from the Jasperlode Mine",
        "Good steel had been scarce since the war, and Hagar Lowe remembered the fine picks the Jasperlode miners once used. {We} went into the depths of the mine and found some, and Hagar admired their shine.",
        "{We} brought Hagar Lowe a bundle of old picks from deep in the Jasperlode Mine, still shining after all that time. They did not make them like that anymore, he said, and he meant to repurpose the steel."},
    [91740] = {act = "brought the watch Croaky's head",
        "{We} killed Croaky, a murloc who had terrorized the roads for some time, and took its head to the nearby watch. The watch had lost two guards to the murlocs the week before. With their leader gone, the guards hoped to push the rest out of the forest.",
        "Croaky's head went with {us} to the watch as proof that the murloc leader was dead. With two of their own lost the week before, the guards hoped to drive the rest away."},
    [91746] = {act = "sold Elmpaw's head as a hunter's trophy",
        "{We} brought down Elmpaw, and its head made an impressive trophy. A local buyer was impressed too, and knew collectors who would pay well to hang it over their mantles.",
        "Elmpaw's head was worth something to the right buyer, and {we} found one who paid {us} for the trophy. Once prepared, it would end up on some collector's mantle."},

    -- Westfall: Alba Fairmoon's search for the poison, and the tinkerer in the stable (12-18)
    [98021] = {act = "went to Sentinel Hill to offer help to Gryan Stoutmantle",
        "Stormwind sent {us} south to Sentinel Hill, where Gryan Stoutmantle's people needed aid. The farmers' troubles might seem small to one who had come from another plane. To the farmers they meant everything, said the one who sent {us}.",
        "Gryan Stoutmantle had begged Stormwind for aid for months, and grumbled about what it had sent him. Beggars could not be choosers, he said, and he set about putting {us} to work."},
    [92742] = {act = "drew water from the farm wells for Alba Fairmoon",
        "Something was poisoning the land, and Alba Fairmoon meant to begin with the groundwater under the farms. {We} drew samples from the wells at the Jansen Stead and the Molsen Farm and brought them to her.",
        "{We} went from the Jansen Stead to the Molsen Farm collecting well water for Alba Fairmoon. It was the first step in finding what was corrupting the soil."},
    [92744] = {act = "brought Alba murloc gills from the shore",
        "Alba feared the corruption had reached the sea, and tainted fish could bring famine to Stormwind. Murloc bodies showed any toxin in the water, so {we} took gills from the murlocs along the shore. For now they looked healthy.",
        "{We} cut gills from the coast's murlocs for Alba Fairmoon to read the seawater in them. The gills were healthy for now, but she would not let that make her complacent."},
    [92745] = {act = "cut down the Defias miners at Jangolode and the Gold Coast Quarry",
        "The well water held toxic metals. If the poisoning went on, it would be decades before crops grew in that soil. The Defias were stripping the mines with creature labor. {We} killed their miners at the Jangolode Mine and the Gold Coast Quarry.",
        "{We} fought the Defias miners in the Jangolode Mine to the north and the Gold Coast Quarry to the west. Alba called it well done, but feared the source of the poison lay somewhere else."},
    [92747] = {act = "searched Moonbrook for signs of mining",
        "The poison came from none of the mines {we} had searched. That left the Deadmines beneath Moonbrook, abandoned since the First War. {We} went into the town and gathered the industrial supplies {we} found there.",
        "{We} searched Moonbrook for any sign that the old Deadmines had come back to life. {We} came back with a haul of industrial supplies. Alba looked them over and asked what it all was."},
    [92748] = {act = "found an engineer in Stormwind's Dwarven District",
        "The supplies from Moonbrook pointed to a massive industrial operation in the Deadmines, the source of the poison. It would be hard to destroy. {We} went to the Dwarven District of Stormwind, where an engineer named Sprite Jumpsprocket asked whether something needed blowing up.",
        "Alba wanted explosives, so {we} went to Stormwind's Dwarven District to find an engineer. Sprite Jumpsprocket was ready to listen the moment there was talk of sabotage."},
    [92749] = {act = "brought Sprite Jumpsprocket coarse dynamite",
        "Industrial sabotage caught Sprite Jumpsprocket's attention, and the plan started with dynamite. {We} brought Sprite ten sticks of coarse dynamite, a great start that needed only tying up and a little extra zing.",
        "{We} gathered the coarse dynamite Sprite Jumpsprocket needed for the bomb meant for the Deadmines. Sprite set to work at once, adding a little extra zing."},
    [92750] = {act = "asked Stormwind Intelligence for a remote detonator",
        "A controlled explosion meant keeping all {our} limbs, Sprite said, and that needed a remote detonator. {We} went to the sneaky folk of Stormwind Intelligence, where Jasper Fel asked what exactly {we} had in mind.",
        "Sprite had no remote detonator, so {we} went down to Stormwind Intelligence to ask for one. Jasper Fel listened, and wanted to know what {we} meant to destroy."},
    [92751] = {act = "got a prototype detonator from Jasper Fel",
        "Jasper Fel already knew of {our} work in Moonbrook, since Stormwind Intelligence kept apprised of everything in its lands. He handed {us} a prototype remote detonator, and warned {us} to be well outside the caves when it went off. He asked that his part be kept from Alba.",
        "{We} carried Jasper Fel's prototype detonator back to Sprite Jumpsprocket, who said it was just what they needed. Fel had asked {us} not to mention his involvement to Alba."},
    [92752] = {act = "brought Sprite's finished bomb to Alba Fairmoon",
        "Sprite's bomb was ready, and {we} carried it back to Alba with the detonator, careful with it as Sprite had warned. Alba Fairmoon was glad to see {us} return.",
        "{We} brought the finished bomb and its detonator to Alba, ready for the Deadmines. She was glad {we} had come back, with the last piece of her plan in hand."},
    [92753] = {act = "found the hidden forge in the Deadmines and planted the bomb",
        "Alba believed the poison came from a great forge hidden in the Deadmines. She waited in the hills behind Moonbrook while {we} went down to find it. {We} found the forge in the depths and planted the bomb. Only the detonation remained.",
        "Deep in the Deadmines {we} found the forge Alba blamed for the poison, and set Sprite's explosives beside it. With the forge gone, Alba hoped, the land could begin to heal."},
    [92819] = {act = "set off the bomb that destroyed the hidden forge",
        "From the hills behind Moonbrook {we} used the detonator, and the hidden forge in the Deadmines was destroyed. Alba could hardly find words. She could not believe that Stormwind would put its military ambitions over the livelihood of its own people.",
        "{We} ended it with the press of a detonator, and the forge that had poisoned the farmland was gone. Alba Fairmoon was left with a bitter thought, that Stormwind had put its ambitions above its people."},
    [92909] = {act = "gathered harvester parts for a tinkerer trapped in a stable",
        "A tinkerer from Ironforge had come to recalibrate the harvest golems, and they chased the poor tinkerer into a stable. {We} took isosprings and gyrostabilizers from the harvesters, the makings of a device to cover an escape.",
        "{We} pulled parts off the rampaging harvesters for the tinkerer hiding in the stable. With them the tinkerer set to work on an escape plan, and gave {us} something for {our} trouble."},
    [92910] = {act = "brought an intact harvester part to the tinkerer",
        "One part {we} salvaged from a harvester was mostly intact. {We} took it to the tinkerer in the stable, who wanted a closer look.",
        "{We} carried a nearly whole assembly from a wrecked harvester to the stable. The tinkerer from Ironforge wanted to know exactly what it was."},
    [92911] = {act = "collected parts for the tinkerer's override device",
        "The salvaged assembly showed the tinkerer how to override the harvesters, at least for a moment. {We} scrounged up the parts for a device. When it was done the tinkerer handed it over to try, and chose to stay behind in the stable.",
        "{We} brought the tinkerer the last parts for a device against the harvesters and got it back finished. The stable was starting to feel like home, the tinkerer said, so the trial fell to {us}."},

    -- Teldrassil, Darnassus and Darkshore (1-21)
    [97979] = {act = "learned the gifts of Mother Moon", solo = true,
        "Born kaldorei among the boughs of the great tree, {I} learned the gifts of Mother Moon. Her grace could make a strike true, or hide {me} as the moon eclipses the sun. {My} teacher promised the goddess would never forsake {me} if {I} used them well.",
        "The Long Vigil had ended and the kaldorei had joined an Alliance {I} had yet to meet. First {I} showed {my} teacher the gifts of Elune, and basked in her blessings."},
    [97977] = {act = "searched the Gnarlpine's abandoned camps for totems", giver = "Tarindrella",
        "Tarindrella would not believe the Gnarlpine had turned on their ancient allies so readily. She sent {us} to their abandoned camps on the western edge of the glen. {We} brought back the totems {we} found there, and their engravings told of nightmares of a great shadow.",
        "{We} searched the empty Gnarlpine homes among the grell for whatever totems had survived. The engravings told Tarindrella that the furbolg's fear had turned to rage against their elven friends. It was worse than she had thought."},
    [97236] = {act = "brought Githyiss's fang to a spider scholar in Aldrassil",
        "{We} killed Githyiss, a spider of great size, and took a fresh fang from it, quite a find. A scholar of spiders in Aldrassil loved surprises, and said it would surely further the work.",
        "The fang of Githyiss went with {us} up to Aldrassil, to a scholar who studied the forest's spiders. It was a rare specimen, and the scholar was delighted."},
    [87288] = {act = "brought nightsaber pelts to a trader in Dolanaar",
        "A cheerful trader in Dolanaar needed nightsaber pelts. The local cats were aggressive enough that {we} need not feel too bad about it. {We} brought back the pelts for blankets and shawls, and the roads were a little safer.",
        "It seemed a shame to the trader to fight such majestic animals, but {we} brought back the pelts all the same. In return {we} got something soft and sturdy to remember them by."},
    [99046] = {act = "found the wounded runner Eralya Leafshadow on the road",
        "The Oracle Tree's latest runner was long overdue in Darnassus. It would have been Eralya Leafshadow's turn, though she was still in training. {We} went west along the road toward the Oracle Glade and found her gravely hurt, calling on Elune's grace.",
        "{We} followed the road to the Oracle Glade looking for the missing runner. Eralya Leafshadow lay there gravely wounded, and swore she would not die alone."},
    [99053] = {act = "freed the sentinel Lynessa Duskblossom from Ban'ethil",
        "Lynessa Duskblossom, a sentinel, had come with a message from the Oracle Tree and been seized by furbolg. {We} fought {our} way down to her, deep in the Ban'ethil Barrow Den. {We} got her out before she became their next meal.",
        "Lynessa Duskblossom loathed being underground, and the Gnarlpine meant to eat her. {We} helped her escape the barrow den. A friend of hers gave {us} thanks and a gift for keeping her safe."},
    [99047] = {act = "carried Eralya's plea to Byancie in Dolanaar",
        "Eralya coughed up blood as she told {us} of harpies everywhere around the Oracle Tree, with no one else coming. {We} ran her word to Byancie in Dolanaar. Byancie blamed the same foulness that had taken the harpies, and feared Eralya had little time.",
        "{We} brought word of Eralya Leafshadow to Byancie in Dolanaar. The rot spreading through the forest had touched the harpies, Byancie said, and the sentinel with them. There was no time to lose."},
    [99050] = {act = "gathered lasher fronds and spring water for Byancie's salve",
        "Byancie needed a salve to hold Eralya's affliction back, and the great tree would provide. {We} gathered dewy lasher fronds by the lakes, and an empty vial and spring water from the town. She began at once.",
        "{We} went to the lakeshore for the fronds of dewy lashers, the heart of Byancie's salve. She paid for {our} vial and water, and set to making it while Eralya still lived."},
    [99073] = {act = "brought Byancie's salve to the dying Eralya",
        "Byancie did not know if the salve would cure Eralya, for the rot festered quickly. It would ease her suffering, and that was worth hurrying for. {We} reached her and helped her take it, and her breath calmed.",
        "By the time {we} returned, Eralya could only breathe in weak gasps. {We} gave her the salve, and she grew calm, at peace whether or not she would live."},
    [98067] = {act = "placed sentinel owls around Darnassus",
        "Something was amiss on the great tree, and a sentinel with her daily duties to keep asked {us} to help. {We} set sentinel owls at four posts around the city, from the tunnels below Cenarion Hold to the gates.",
        "{We} went around the city setting sentinel owls to keep watch, as General Feathermoon's sentinels did each day. The sentinel was glad of a moment to reflect instead of the usual ritual."},
    [98392] = {act = "took the harpy leaders' amulets for Arynia Cloudsbreak",
        "Arynia Cloudsbreak showed {us} the taint running through the leather of the harpies' belts. She wanted proof of where it came from. {We} went back to the nests to the west and killed the harpy leaders. Foul green swirls ran through the gems of the amulets {we} brought her.",
        "{We} wrested the amulets from the harpy leaders in the glade, and Arynia named what clouded them, fel moss corruption. Similar reports had come from Shadowglen, and she went to tell her superiors at once."},
    [98398] = {act = "heard the Oracle Tree speak through its fallen bark", solo = true,
        "The sentinel at the glade was impressed with all {I} had done there in so short a time. Greater tasks lay ahead for {me}, the sentinel sensed. The Oracle Tree had just shed a piece of bark. When {I} looked it over, a calm voice entered {my} mind.",
        "Fallen bark was the Oracle Tree's way of asking for something, and {I} went to see what it wanted. As {I} looked the bark over, a voice spoke in {my} mind, soothing as a breeze through the leaves."},
    [98025] = {act = "killed the maddened owl Jai'vhanel",
        "The village council of Auberdine had a bounty on Jai'vhanel, an owl called Swordfeather. She had gone mad and was attacking travelers. {We} found her north of the ruins and brought one of her jet black feathers to Sentinel Glynda Nal'Shea.",
        "{We} killed Jai'vhanel and made the roads to Auberdine safe. Glynda Nal'Shea was sad there had been no other way, since the owl had long been a guardian of the area."},
    [97894] = {act = "sailed to Auberdine to check on Gorbold Steelhand",
        "Borgus Steelhand had not heard from his brother Gorbold since he joined a merchant stall in Auberdine. A new ship from Stormwind's harbor took {us} straight there. {We} found Gorbold at his stall, where business had all but stopped after a recent tragedy.",
        "{We} took the new ship from the southernmost dock across the sea to Auberdine. Gorbold Steelhand was glad his brother looked out for him. He could use another set of hands to set things right, he said."},
    [97914] = {act = "carried the elder of Auberdine's letter to Baros Alexston",
        "Nobody in Darnassus spoke of Auberdine, only of the cities the Sundering had taken. Its elder wanted the village's work known. {We} sailed back to Stormwind with his letter for Baros Alexston, whose smile faded as he read.",
        "Baros Alexston could smell the sea on {us} when {we} arrived with a letter from Auberdine. He opened it laughing, and his good humor did not last the reading."},
    [97926] = {act = "brought Baros Alexston's reply back to Auberdine",
        "Baros wished he could help, but Stormwind's coffers were not what they had been and what remained was spread thin. {We} carried his reply back across the sea. With neither Stormwind nor Darnassus coming, the elder said, Auberdine's fate was its own to decide.",
        "{We} made the return crossing with Baros Alexston's answer, which was not the one Auberdine had hoped for. The elder thanked {us} for the journey all the same."},
    [98028] = {act = "brought Onu the clouded globe left by Baron Marinous",
        "All that remained of Baron Marinous, guardian of Mathystra's ruins, was a globe of water. Something clouded it and resisted being seen. {We} carried it far south to Onu, the Ancient of Lore. He was as surprised as an ancient could be to hear of stairs descending in Mathystra.",
        "It was no small feat to defeat an elemental guardian, Onu said when {we} brought him the globe from Mathystra. He meant to confer with the other ancients, and was glad {we} had found it before the naga or their cult allies."},

    -- Stormwind, Redridge, Duskwood, the Wetlands and Loch Modan (12-28)
    [95065] = {act = "brought old Gray fresh bait from Catherine Leland's shop",
        "Old Gray was fishing at the harbor with the fish biting and only one bait left. {We} went to Catherine Leland's shop along the canals for fresh supplies. When {we} came back he had caught a big one with his last.",
        "{We} kept old Gray in business with supplies from Catherine Leland, west of the Trade District. He was having a great day, and gave {us} a few fish for the road."},
    [98407] = {act = "took collars from the gnoll thrashers near Lakeshire",
        "Gnolls were camping close to the people of the valley, and they respected strength above all else. {We} went after the worst of them, their thrashers. {We} came back with an armful of collars, and the gnolls would think twice before pushing any further.",
        "{We} put down the gnoll thrashers in the hills and brought their collars back as trophies. It did not solve the problem, but it put a little fear of the Alliance back into the pack."},
    [97234] = {act = "carried a parcel from Roy Lewells's reading club to the library",
        "Roy Lewells's reading club was trading some of its less popular works to the city library for more modern writing. {We} carried the wrapped parcel and its list to the librarian. The librarian recognized Roy's wrapping, and said the club always returned what it borrowed in good condition.",
        "{We} ran an errand for Roy Lewells's reading club, taking its parcel to the library with refreshments promised for {our} trouble. The librarian agreed to the exchange, however provoking the words might be."},
    [97237] = {act = "fetched the reading club's new titles from the library shelves",
        "Every title on Roy's list was in the library, but the librarian would not fetch them. The hunt along the shelves fell to {us}. Roy was delighted with what {we} brought, and some of the new titles even smelled exotic.",
        "{We} carried the new titles back to Roy Lewells, who looked forward to lively talk about them in the cellar after hours. As promised, the refreshments were on the house."},
    [98386] = {act = "cleared the tarantulas from Alther's Mill", giver = "Foreman Oslow",
        "Orcs, gnolls and murlocs had already delayed Foreman Oslow's bridge, and now tarantulas had taken the lumber mill it depended on. {We} went east to Alther's Mill and killed twelve of them, and the place was worse than Oslow had thought.",
        "{We} cleared spiders out of Alther's Mill so Oslow could send his workers for lumber without losing them. He was not squeamish, he said, but his work was hard enough already."},
    [98387] = {act = "robbed the Blackrock camps of their axes", giver = "Marshal Marris",
        "Marshal Marris called it a war of attrition. The Blackrock orcs had pushed into Alliance land and now lived off the mountains. {We} raided their camps south of Stonewatch Keep and brought back ten battleworn axes. Most of their spoils had been stolen from Lakeshire in the first place.",
        "{We} took food and weapons from the Blackrock encampments south of Stonewatch Keep. Cut off from their allies in the Burning Steppes, Marris said, the orcs could not hold their foothold for long."},
    [95999] = {act = "killed Incinerator Gar'im in Render's Valley",
        "A bounty from Magistrate Solomon named Incinerator Gar'im, who led an orc incursion in Render's Valley with his dangerous Shadowcasters. {We} went into the valley and killed him, and Solomon thought Stonewatch Keep might yet be retaken.",
        "{We} brought Magistrate Solomon proof that Incinerator Gar'im was dead. The orc had been preparing to bolster the defenses of Stonewatch Keep, and Lakeshire could hope to reclaim it now."},
    [96139] = {act = "searched Raven Hill and found a tome on the Valor family", giver = "Sirra Von'Indi",
        "Sirra Von'Indi in Darkshire wanted the town's heroes remembered as well as its foes. Her library had almost nothing on Raven Hill. {We} searched the ruined village and brought her a tome about the Valor family, and she made {us} a copy.",
        "Raven Hill's history had died with its people, and {we} went looking among its ruins for anything that remained. The tome {we} found told of the Valor family, good folk by Sirra's account, though she doubted they merited a whole volume."},
    [98447] = {act = "went back to Raven Hill to learn what bound the Valor ghosts", giver = "Sirra Von'Indi",
        "Even with the Valor ghosts put down, the attacks around Raven Hill had not stopped. Sirra suspected their business was still unfinished. {We} went back with the family's weapons to where the tome had been found, to learn what had bound them all at once.",
        "Sirra believed the whole Valor family had vanished at the same time. {We} carried their weapons back to Raven Hill in hope of stirring something. There {we} searched for whatever kept the Valors chained to this world."},
    [96138] = {act = "cut down the Splint Fist ogres troubling Merrick Valor's spirit",
        "Merrick Valor had been a Watcher who kept the roads safe. His spirit still wandered them, and left a bow behind. {We} reckoned the ogres south of Raven Hill troubled him. {We} cut down their warriors and taskmasters, and took word to Sirra Von'Indi.",
        "With Merrick's bow in hand, {we} went after the Splint Fist ogres camped near his old home at Raven Hill. When the warriors and taskmasters lay dead, {we} told Sirra Von'Indi in Darkshire."},
    [98459] = {act = "delivered Half-fish's gift to Bart Tidewater",
        "Old Tom Half-fish called Bart Tidewater a cheapskate, an actor who had won a ship at poker. He sent him a gift by {our} hands. {We} took the boat to Menethil Harbor, where Bart unwrapped it and swore that Half-fish was the cheat.",
        "{We} carried a parcel from Half-fish to Bart Tidewater, captain of the Maiden's Virtue. Bart had a few insults of his own to send back. Then he remembered not to shoot the messenger, and welcomed {us} to the harbor."},
    [98461] = {act = "brought Hollee's note to her old classmate Tarrel",
        "Hollee in Auberdine had studied with Tarrel Rockweaver and wanted to know he was all right. She mentioned his wife Merrin only as an afterthought. {We} found Tarrel near Menethil Harbor and gave him her note, which he read with pity.",
        "{We} delivered Hollee's note to Tarrel in the marshes. He was happily married, he said, and would not reply. His wife Merrin was missing, and he had more pressing worries."},
    [98197] = {act = "raised the Old Horde's sunken timber and iron for Menethil", giver = "Valstag Ironjaw",
        "By Valstag Ironjaw's account the Old Horde had first built the harbor, to launch its fleet at Hillsbrad. It used timber and iron stolen out of Khaz Modan, and much of it still lay underwater. {We} dove for it among the creatures below, and it came up a bit damp.",
        "With the Dragonmaw on the move, {we} raised the Old Horde's sunken spoils to shore up the harbor's defenses. Valstag was glad not to rely only on shipments from Theramore or Auberdine for once."},
    [98190] = {act = "carried King Terenas's statuette from Menethil to Bolvar Fordragon",
        "Menethil Harbor was a calm harbor in a storm of enemies. Its keepers feared the Dragonmaw would loot the statuette of King Terenas they held. {We} carried it to Stormwind and straight to Highlord Bolvar Fordragon, past every rung of the chain of command.",
        "{We} took the statuette of King Terenas out of Menethil, where it was not safe, and brought it to Highlord Fordragon in Stormwind. He would know where it was best kept, {we} had been told at the harbor."},
    [98191] = {act = "gave the statuette into Lord Grayson Shadowbreaker's keeping",
        "Terenas had been a humble king who hated memorials, {we} heard in Stormwind, and few had survived Lordaeron's fall. The Light seemed to have gathered in this one. {We} carried it to the Cathedral of Light and gave it to Lord Grayson Shadowbreaker.",
        "{We} brought the statuette of King Terenas into the Cathedral of Light, where Lord Grayson Shadowbreaker took it into safekeeping. Terenas, the Highlord had said, was truly the reason the Alliance existed at all."},
    [86585] = {act = "avenged the fallen mountaineer Ylva and carried back her banner",
        "In trogg country {we} found a dead mountaineer, struck down with a blow to the head. Her Ironforge standard lay trampled beside her. {We} raised the banner and fought the trogg it drew out. When {we} carried the standard back, {we} learned her name was Ylva.",
        "Ylva had gone looking for a lost patrol, set on showing the troggs that Ironforge would never fall. {We} found what was left of her. Her banner would be cleaned and displayed, and her weapon was given to {us} to use against the troggs."},
    [86614] = {act = "returned a silver hair clip found in fishing debris",
        "Among rusty hooks and broken spools in some fishing debris {we} found an ornate silver hair clip marked K.D. {We} returned it to its owner, who had thought it lost for good.",
        "{We} brought the silver hair clip back to the one who had lost it, busy with chores but glad to see it. A little work would make it shine, the owner said, and made it worth {our} while."},
    [86667] = {act = "carried a jar of snow to Norric for Grenhild",
        "Grenhild's old mentor Norric had sent a minor elemental asking for a jar of snow. She was too busy with the local elementals to go. {We} scooped snow at South Gate Pass and carried it to him before it could melt.",
        "{We} brought old Norric his jar of snow from South Gate Pass, sent by his student Grenhild. He was delighted, though he had hoped she might come and visit herself."},

    -- Durotar, Orgrimmar, Mulgore and Thunder Bluff (6-20)
    [99108] = {act = "sparred in the arena of the young", solo = true,
        "The arena's teacher could not teach {me} the warrior's path. Still, every young one could learn to sharpen their horns in direct combat, the teacher held. {I} stepped into the arena, where it mattered not who {my} mother was, and faced a willing opponent.",
        "{I} fought in the arena as the teacher asked. It was an honor, the teacher said, and the new generation had hope yet. {I} came away with something to tend {my} wounds, for many more battles lay ahead."},
    [96873] = {act = "stripped the binding spells from Zalazane's pendants", solo = true,
        "The witchdoctor Zalazane bound the minds of the trolls east of the village with pendants wrapped in evil spells. {I} took the pendants from his slain thralls, careful never to put one on. Stripping the magic from them was practice in enchanting.",
        "{I} brought back the pendants with their binding spells unpicked, and the teacher called it fine work. It was a shame about the slain trolls, but their spirits could rest now."},
    [99123] = {act = "helped the young hunter Pal'juh out of the crag",
        "Pal'juh had gone scouting in the crag alone, run out of magic at the wrong moment, and been stuck hiding ever since. {We} got her out, and her teacher hoped she would learn her lesson about going alone this time.",
        "{We} found Pal'juh trapped in the crag and helped her escape. She was a promising hunter, her teacher said, who tended to act more like a raptor than a tiger."},
    [96874] = {act = "brought Ug'thok spines from the beasts of Thunder Ridge", solo = true,
        "Ug'thok was sure the spines of the great beasts of Thunder Ridge would make a mighty axe head. Saru had laughed at him. As part of {my} smithing lessons {I} brought him the spines and grinding stones to sharpen them.",
        "{I} hunted the beasts of Thunder Ridge for Ug'thok's spines, and they were tougher than he had expected. His axe might not come easily, but he meant to keep at it."},
    [96875] = {act = "brought Kamari lizard hides for Orgrimmar's new buildings", solo = true,
        "Orgrimmar was always growing, and its peons came to Kamari for hides to line the walls and roofs. {I} brought back thick lizard hides from Thunder Ridge and a few cured light hides, a test of {my} skill with leather.",
        "The lizard hides {I} brought from Thunder Ridge went into Orgrimmar's new buildings. Kamari told {me} to remember, walking the city's paths, that {my} work had helped it grow."},
    [97485] = {act = "scattered incense to the winds off Hunter's Rise", solo = true,
        "A tauren of the bluffs invited {me} to honor an old tradition, scattering incense to the winds. {I} bought herbs, cedar, sinew thread and ceremonial flint from the traders on the rises. {I} made the incense and spread it from the south cliff of Hunter's Rise.",
        "Incense could ask the Earthmother to watch over someone, bless a hunt or seek the ancestors' guidance. {I} sent mine off the cliff of Hunter's Rise. The tauren thanked {me}, and hoped {I} would find many occasions worth giving thanks for."},
    [76156] = {act = "wore a mask into the Venture Co. mine for a teacher's test", solo = true,
        "A teacher sensed a hidden gift in {me} for the subtle arts. The teacher handed {me} a mask to wear into the Venture Company mine, to steal its supplies. It hardly looked convincing, and the teacher had heard {me} coming the moment {I} reached the mesa.",
        "{I} went into the Venture Company mine in a borrowed mask, trusting to a winning smile and a distraction as the teacher advised. The supplies came back with {me}, yet disguises, the teacher judged, were perhaps not {my} strength."},
    [76160] = {act = "brought back a salve that turned out to be pine nut butter", solo = true,
        "Perhaps {my} gift lay in poisons, the teacher thought. {I} went north for the fallen cones beneath the harpies' nesting tree, to crush into a searing salve for blades. What {I} brought back was pine nut butter.",
        "{I} gathered cones under the harpies' tree and crushed them as the teacher instructed, or so {I} thought. The teacher declared the result better on spice bread than a dagger, though formidable against a foe with a nut allergy."},
    [76240] = {act = "filleted a smallfish with a teacher's daggers", solo = true,
        "The teacher had one last idea, less direct than the others. {I} filleted a Raw Brilliant Smallfish with a pair of daggers, without thinking too hard. It showed no rogue's precision, but an impressive ambidexterity.",
        "{I} cleaned a smallfish with a dagger in each hand while the teacher watched. {I} would never train the teacher's people in the subtle arts, it turned out. Still, the teacher had one thing left to teach {me}, and said the Horde would need heroes like {me}."},
    [97281] = {act = "brought a harpy's stormy orb to Rezlak",
        "A harpy {we} killed had been carrying a strange dull orb. A dark mist swirled inside it, and small sparks ran through it. {We} took it to Rezlak the goblin, who loved it. It reminded him of something his old boss Gazlowe used to say.",
        "The orb hummed with a faint current in {my} hand as {we} carried it to Rezlak. He wanted to know where {we} had found such a neat thing."},
    [97282] = {act = "harvested thunder lizard organs to charge Rezlak's orb",
        "Rezlak thought the harpy's orb was only drained, and meant to supercharge it. Gazlowe had taught him to seize opportunities. {We} went to the gorge to the west and took charged organs from the thunder lizards, which shot lightning rather than roared.",
        "{We} brought Rezlak five thunder lizard organs, and he hoped to charge the orb with them. If it worked, he bet the harpies would think twice before attacking his caravan."},
    [96877] = {act = "brought back Halikor's hoof as a trophy",
        "{We} brought down Halikor, the mighty lizard of Thunder Ridge, and carried off its enormous hoof as proof. The one {we} showed it to called it quite a trophy, and reckoned it must have been some fight.",
        "Halikor's hoof was big enough to make a fine trophy, and {we} brought it back from Thunder Ridge to be admired. It must have been some fight, the admirer said."},
    [97242] = {act = "cut cattail and speargrass for Yelmak's medley", giver = "Kor'geld",
        "Yelmak's apprentice Whuut was too proud to ask for help. Kor'geld could not leave the shop without Whuut guessing everyone was humoring him. {We} took cuttings of cattail and speargrass by the water in the Valley of Honor, for one of Yelmak's home brews.",
        "{We} brought Kor'geld cattail and speargrass from the Valley of Honor, fed by mountain springs and the red dust of the city. Yelmak would use them to win back his apprentice's ear with a lesson at the bench."},
    [97275] = {act = "brought Whuut a potion of Yelmak's common herbs", giver = "Yelmak",
        "Whuut was an alchemy prodigy who burned through the rarest reagents without learning the basics. Yelmak sent {us} to him with a potion made by a quick tonic method. Whuut was astonished it used nothing but speargrass and cattail.",
        "{We} handed Whuut the potion Yelmak had brewed from common plants, and it stopped the young alchemist short. Perhaps, he admitted, there was much he had missed by skipping ahead to the rarest flora."},
    [97246] = {act = "told Borstan someone had come for Migi's lunch", giver = "Thatog",
        "Thatog's son Migi played behind Grommash Hold all day, and almost never stopped for the lunch his father had arranged. Thatog's duties kept him at his post. {We} went to Borstan's Firepit, and Borstan admitted the boy skipped his meal several times a week.",
        "{We} stopped at Borstan's Firepit to collect Migi's lunch for his worried father. Borstan knew the arrangement well, and wondered where the boy found the energy to play all day."},
    [97249] = {act = "brought Migi a lunch topped with sweetglaze crumbs", giver = "Borstan",
        "Borstan had a plan, since Migi never missed lunch when sweetglazed hog belly came out of the smoker. {We} carried a bag topped with crispy sweetglaze crumbs to the boy behind Grommash Hold. He decided the game could wait while everyone ate.",
        "{We} found Migi with his friends behind Grommash Hold and handed him Borstan's lunch. It tasted like his favorite, only different. If it was this good every day, he said, they would all stop to eat."},
    [97326] = {act = "carried smooth rocks for the children's game behind Grommash Hold",
        "Thra and the other children played their figure game in a clear patch of dirt behind Grommash Hold, with nothing to sit on. {We} carried back eight smooth rocks, and Thra marveled that anyone could hold so many boulders.",
        "The children behind Grommash Hold had caught {us} smiling at their game, and asked for rocks to use as chairs and tables. {We} brought them, most with a flat side, and they no longer had to sit in the dirt."},
    [98362] = {act = "returned to Turak Runetotem after the trial of the Great Cat Spirit", solo = true,
        "Dendrite Starblaze sent {me} back to Turak Runetotem with the trial of the Great Cat Spirit behind {me}. Turak sensed it at once. Every druid had to pass such a trial, he said, and he began to teach {me} the shape of the cat.",
        "Turak Runetotem was proud that {I} had heeded the wisdom of the Great Cat Spirit, a spirit as deadly as it was playful. From him {I} learned to take the shape of the cat."},

    -- The Barrens (14-23)
    [97253] = {act = "gathered the scattered parts of Wrenix's machine",
        "None of the fighters Wrenix sent against the pirates south of Ratchet had come back. So he sent a machine, and the pirates took it apart with their scimitars. {We} went into the camp and gathered up the pieces, and he offered {us} a box for {our} trouble.",
        "{We} came back from the pirate camp with {our} pockets jingling with machine parts. Wrenix was spared another of Gagsprocket's lectures on the cost of metal, and could start on his next prototype."},
    [95621] = {act = "learned why Kul Tiran soldiers were searching the valley", giver = "Walton",
        "Walton, a hermit tanner, had watched soldiers in the livery of Kul Tiras search the valley below his ridge. {We} went to their camp by the wrecked caravan, fought them, and learned they were hunting a deserter.",
        "{We} brought Walton word from the Kul Tirans' camp that they were looking for a deserter. His past, he said, had finally caught up with him."},
    [95774] = {act = "recovered Olgra's bone adornments for Mankrik",
        "Mankrik's wife Olgra had died in battle, and the jewels of polished bone she wore were gone from her body. {We} killed Razormane raiders near where she fell and brought back her adornments for the memorial he was building.",
        "{We} gave Mankrik the bone jewels the Razormane had taken from Olgra. He would place them with her memorial so he never forgot her, and his blood still ran hot for revenge."},
    [97003] = {act = "killed Chol'aruk the Ravener in its lair on Thorn Hill",
        "The Razormane told of Chol'aruk the Ravener, a quilboar five times the size of any other. The veteran who sent {us} had fought one of its kind. {We} went into the cave on Thorn Hill, killed it and brought back its head as grim proof.",
        "It had taken six fighters to bring down a beast like Chol'aruk once, and four of them had died. {We} found its lair on Thorn Hill and killed it, and the veteran swore to speak loudly of {our} deed in Orgrimmar."},
    [97005] = {act = "killed Chol'aruk the Ravener for an Alliance veteran", giver = "Bainham",
        "An Alliance veteran far from home had fought a beast like Chol'aruk before, and lost all but one of his companions to it. {We} found the Ravener's lair on Thorn Hill, killed it and brought him its head.",
        "On the honor of his fallen brothers, the veteran wanted Chol'aruk dead, though it was said to swallow an orc whole. {We} brought him its head, and he said his dead men would rest easier."},
    [97250] = {act = "drove back the Alliance soldiers at the Dustwallow border",
        "Human soldiers had dug in at the border of Dustwallow Marsh. They toppled the landmarks of tauren pathfinders and blamed the Horde for a burned tavern. {We} went there and struck first, and the rumors of an incursion proved true.",
        "{We} cut down the Alliance soldiers encroaching on Horde land by the marsh, a stern warning to the Alliance. Who had burned the tavern was still in doubt, {our} employer said, for too many Horde travelers needed that road."},
    [98093] = {act = "cleared the hyenas and lizards around a stranded walker's tree",
        "A walker from Camp Taurajo had strolled down the golden road and ended up in a tree. Hyenas circled below, and Stormhide lizards blocked the way home. {We} cleared them out so the walker could make the careful climb down.",
        "{We} thinned the Hecklefang stalkers and Stormhide lizards around the tree where a walker from Camp Taurajo was stranded. The walker promised to tell the camp of the rescue, and offered what little could be spared."},
}
for id, pov in pairs(POV) do
    if P.questIDs[id] then P.questIDs[id].pov = pov end
end

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
