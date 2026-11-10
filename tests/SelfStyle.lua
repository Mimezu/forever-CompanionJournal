-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfStyle.lua [print]
-- The style pass of the planned telling of your own book (JournalSelfStyle.lua, 2026-11-09):
-- where a paragraph ends, how a sentence opens, how long it runs, what a place is called the
-- second time, what is never told twice, and where a feeling may stand. Each rule is checked
-- on lists built by hand, then all of them on the evening of tests/SelfPlan.lua.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end
local S = A.SelfStyle
check(S and S.Apply, "the style pass is loaded")

-- ---------------------------------------------------------------- tools
-- (one line of the planner's list, as JournalSelfPlan.lua's Push makes it)
local function E(text, opts)
    local entry = {text = text, sit = 1, kind = "", it = {m = {}}}
    for key, value in pairs(opts or {}) do entry[key] = value end
    return entry
end
local function Run(seq, seed) return S.Apply(seq, {seed = seed or "test", index = 1, earlier = ""}) end
local function Plain(text) return (text:gsub("{%a:([^}]*)}", "%1")) end
local function Words(text) local n = 0; for _ in Plain(text):gmatch("%S+") do n = n + 1 end; return n end
local function Sentences(para) return S.Sentences(para) end
local function All(paras) return table.concat(paras, "\n\n") end
local function Has(text, piece) return text:find(piece, 1, true) ~= nil end
local function Times(text, piece)
    local n, at = 0, 1
    while true do
        local s, e = text:find(piece, at, true)
        if not s then return n end
        n, at = n + 1, e + 1
    end
end
-- (every sentence of the chapter, in order)
local function Flat(paras)
    local list = {}
    for _, para in ipairs(paras) do for _, sentence in ipairs(Sentences(para)) do list[#list + 1] = sentence end end
    return list
end
local function Bare(sentence) local word = S.FirstWord(sentence); return word == "We" or word == "I" end
local function BareCount(paras) local n = 0; for _, s in ipairs(Flat(paras)) do if Bare(s) then n = n + 1 end end; return n end
local function NoThreeAlike(paras, tag)
    local list = Flat(paras)
    for i = 3, #list do
        local a, b, c = S.FirstWord(list[i - 2]), S.FirstWord(list[i - 1]), S.FirstWord(list[i])
        check(not (a == b and b == c), "three sentences in a row open on " .. tostring(c) .. tag .. All(paras))
    end
end
-- (the words of a text as a sorted bag: case, punctuation and markup aside)
local function Bag(text)
    local list = {}
    for word in Plain(text):lower():gmatch("[%a']+") do list[#list + 1] = word end
    table.sort(list)
    return table.concat(list, " ")
end
local function SeqText(seq)
    local parts = {}
    for _, entry in ipairs(seq) do parts[#parts + 1] = entry.text end
    return table.concat(parts, " ")
end
-- (the limits every paragraph keeps: four sentences, sixty words)
local function Within(paras, tag)
    for _, para in ipairs(paras) do
        check(#Sentences(para) <= 4, "a paragraph of more than four sentences" .. tag .. para)
        check(Words(para) <= 60, "a paragraph of more than sixty words" .. tag .. para)
        check(para:find("^[%u%d{]"), "a paragraph opens on a capital" .. tag .. para)
        check(para:find("[%.!]$"), "a paragraph ends on a full stop" .. tag .. para)
        check(not para:find("  ", 1, true) and not para:find("\1", 1, true), "a stray space or mark" .. tag .. para)
    end
end
local function Print(tag, paras) if show then io.write("--- ", tag, "\n", All(paras), "\n\n") end end

-- ---------------------------------------------------------------- the sentences of a line
do
    local list = Sentences("I met Dr. Hale. He spoke to A. Smith! Then I left. {n:Grosh} stayed. 3 wolves came.")
    check(#list == 5 and list[1] == "I met Dr. Hale." and list[2] == "He spoke to A. Smith!" and list[4] == "{n:Grosh} stayed.",
        "a title or an initial does not end a sentence")
    check(#Sentences('He said "Go. Now. Run." and left. I ran.') == 1, "a line that quotes speech is one piece")
end

-- ---------------------------------------------------------------- S1 paragraphs by sense
do  -- a new sitting is a new paragraph
    local seq = {
        E("I woke in the crypt under Deathknell. The air was cold and still."),
        E("I took my first orders from the undertaker and went out among the graves."),
        E("I came back to the city in the afternoon. The lift was slow.", {sit = 2}),
        E("I sold what I carried and bought a new knife for the road.", {sit = 2}),
    }
    local paras = Run(seq)
    Print("sittings", paras)
    check(#paras == 2 and paras[2]:find("^I came back to the city"), "a sitting is a paragraph: " .. All(paras))
    check(seq[1].para == 1 and seq[2].para == 1 and seq[3].para == 2 and seq[4].para == 2, "each line knows its paragraph")
    check(seq[2].words == 14, "each line knows its words")
    Within(paras, " (sittings): ")
end

do  -- a peak stands with its own lines; the feeling ends the paragraph
    local death = {m = {}}
    local seq = {
        E("I walked the road north past the mills. The trees were grey and bare."),
        E("I cut down the gnolls at the farm and took their banners back."),
        E("Close to eleven, {p:Riptear} killed me.", {kind = "death", clock = true, it = death, peak = "death"}),
        E("It was a long way back from the graveyard.", {glue = true, it = death}),
        E("I had died before, and knew the cold road back by now.", {felt = "death", it = death}),
        E("I reached level 13.", {level = true, kind = "level"}),
        E("I went down into the Undercity and handed the letter over."),
        E("The clerk read it twice before he looked up at me."),
        E("I slept in the Ruins of Lordaeron.", {it = {m = {close = "sleep"}}}),
    }
    local paras = Run(seq)
    Print("peak", paras)
    check(#paras == 3, "the death has its own paragraph: " .. All(paras))
    check(paras[2] == "Close to eleven, {p:Riptear} killed me. It was a long way back from the graveyard. "
        .. "I had died before, and knew the cold road back by now.", "the death, its own line, its feeling, and no more: " .. paras[2])
    check(not Has(paras[1], "killed me") and paras[3]:find("^I reached level 13%."), "the feeling ends its paragraph: " .. All(paras))
    check(#Sentences(paras[2]) <= 3, "a peak is three sentences at most")
    Within(paras, " (peak): ")
end

do  -- S7: nothing is told after a feeling in its paragraph; a word on the killer goes before it
    local death = {m = {}}
    local function Seq(after)
        return {
            E("We walked the road north past the mills. The trees were grey and bare."),
            E("Close to nine, {p:Bhag'thera} killed me.", {kind = "death", clock = true, it = death, peak = "death"}),
            E("I had died before, and knew the cold road back by now.", {felt = "death", it = death}),
            after,
            E("We went on to the camp and slept there."),
            E("The fire was low and the night was cold."),
        }
    end
    local dying = "Close to nine, {p:Bhag'thera} killed me. I had died before, and knew the cold road back by now."
    local paras = Run(Seq(E("{n:Elisabeth}'s prayers brought me back.", {it = death, glue = true})))
    check(#paras == 3 and paras[2] == dying and paras[3]:find("^{n:Elisabeth}'s prayers brought me back%. We went on"),
        "a line of the same event opens the next paragraph: " .. All(paras))
    paras = Run(Seq(E("She had long eluded Nesingwary's whole party, and I was no luckier.", {kind = "lore"})))
    check(#paras == 3 and paras[2] == "Close to nine, {p:Bhag'thera} killed me. She had long eluded Nesingwary's whole party, "
        .. "and I was no luckier. I had died before, and knew the cold road back by now.",
        "a word on the killer stands before the feeling: " .. All(paras))
    paras = Run(Seq(E("The road south was dry and long.", {})))
    check(paras[2] == dying, "another line does not follow a feeling: " .. All(paras))
    paras = Run(Seq(E("I took the spider's fangs for the apothecary.", {it = death, glue = true, work = true})))
    check(paras[2] == dying, "nor a line of work from the same errand: " .. All(paras))
    -- (the payoff of the re-read: the routine line no longer steps on it, and leads into the next scene)
    local raised, spell = {m = {}}, {m = {}, peak = "spell"}
    paras = Run({
        E("We walked the road north past the mills. The trees were grey and bare."),
        E("I raised the fallen guard in the vale where the spider had killed me.", {peak = "payoff", it = raised, work = true}),
        E("This time I walked out of it.", {felt = "backDeath", glue = true, it = raised}),
        E("I took a copy of the orders for him.", {glue = true, work = true, it = raised}),
        E("When I returned from the vale, the captain judged me ready. She taught me the prayer that brings back the fallen.",
            {peak = "spell", scene = true, turn = true, it = spell}),
        E("I hoped I would never need it.", {felt = "rezLearned", glue = true, it = spell}),
        E("We ended the day there a little after one.", {glue = true, it = {m = {close = "long"}}}),
    })
    Print("payoff", paras)
    check(#paras == 4 and paras[2]:find("^I raised the fallen guard") and paras[2]:find("This time I walked out of it%.$"),
        "the payoff closes its paragraph: " .. All(paras))
    check(paras[3]:find("^I took a copy of the orders for him%. When I returned") and paras[3]:find("never need it%.$"),
        "the line shut in before a peak leads into it: " .. All(paras))
    check(paras[4] == "We ended the day there a little after one.", "the close stands: " .. All(paras))
end

do  -- S8: one's own level line never stands with a peak, a death or a feeling
    local queen, death = {m = {}, peak = "figure"}, {m = {}, peak = "death"}
    local paras = Run({
        E("I brought fresh cloth to the beggar in the Trade Quarter. He thanked me for it."),
        E("The order sent me to the Dark Lady with the commander's head.", {peak = "figure", scene = true, turn = true, it = queen}),
        E("Here was my queen, and I hardly knew where to look.", {felt = "figureNamed", glue = true, it = queen}),
        E("Sylvanas did not doubt the order, and said its paladins would be watched.", {glue = true, it = queen}),
        E("Soon after, I reached level 14.", {glue = true, level = true, it = queen}),
        E("I carried the beggar's thanks back to the keep and the symbol to the guard."),
        E("We ended the day there a little after one.", {glue = true, it = {m = {close = "long"}}}),
    })
    Print("level after a scene", paras)
    check(paras[2]:find("^The order sent me") and paras[2]:find("where to look%.$"), "the feeling closes the meeting: " .. All(paras))
    check(paras[3] == "Sylvanas did not doubt the order, and said its paladins would be watched.",
        "the rest of the scene stands without the level line: " .. All(paras))
    check(paras[4]:find("^Soon after, I reached level 14%. I carried the beggar's thanks"),
        "the level line opens the next plain paragraph: " .. All(paras))
    -- (shut in between two peaks, it ends the after-word of its own scene; with no after-word,
    -- or drawn from something else, it stands alone, never beside the feeling)
    local function Shut(answer, from)
        local seq = {
            E("I brought fresh cloth to the beggar in the Trade Quarter. He thanked me for it."),
            E("The order sent me to the Dark Lady with the commander's head.", {peak = "figure", scene = true, turn = true, it = queen}),
            E("Here was my queen, and I hardly knew where to look.", {felt = "figureNamed", glue = true, it = queen}),
        }
        if answer then seq[#seq + 1] = E("Sylvanas did not doubt the order, and said its paladins would be watched.", {glue = true, it = queen}) end
        seq[#seq + 1] = E("Soon after, I reached level 14.", {glue = true, level = true, it = from})
        seq[#seq + 1] = E("I raised the fallen scout in the vale where the spider had killed me.", {peak = "payoff", work = true})
        seq[#seq + 1] = E("This time I walked out of it.", {felt = "backDeath", glue = true})
        return Run(seq)
    end
    paras = Shut(true, queen)
    check(#paras == 4 and paras[3] == "Sylvanas did not doubt the order, and said its paladins would be watched. Soon after, I reached level 14.",
        "between two peaks the level line ends the after-word of its scene: " .. All(paras))
    paras = Shut(false, queen)
    check(#paras == 4 and paras[3] == "Soon after, I reached level 14." and paras[2]:find("where to look%.$"),
        "it never follows the feeling: " .. All(paras))
    paras = Shut(true, {m = {}})
    check(#paras == 5 and paras[4] == "Soon after, I reached level 14.", "nor joins the after-word of another scene: " .. All(paras))
    -- (after a death: one's own level moves on, also past a word on the killer; the companion's stays)
    local function Dying(level, more)
        local seq = {
            E("We walked the road north past the mills. The trees were grey and bare."),
            E("A little after eleven, {p:Riptear} killed me in {p:Venomweb Vale}.", {kind = "death", clock = true, peak = "death", it = death}),
            E(level, {kind = "death", glue = true, level = true, it = death}),
        }
        seq[#seq + 1] = more
        seq[#seq + 1] = E("We learned how the keep fell when the citadel struck the city.")
        seq[#seq + 1] = E("For the priest we found the crystal a cultist hid beneath the vale.")
        return seq
    end
    paras = Run(Dying("{n:Dahlia} made level 13 a minute later."))
    check(paras[2] == "A little after eleven, {p:Riptear} killed me in {p:Venomweb Vale}. {n:Dahlia} made level 13 a minute later.",
        "the companion's level stays with the death: " .. All(paras))
    paras = Run(Dying("Soon after, I reached level 13."))
    check(paras[2] == "A little after eleven, {p:Riptear} killed me in {p:Venomweb Vale}."
        and paras[3]:find("^Soon after, I reached level 13%. We learned"), "one's own level leaves the death: " .. All(paras))
    paras = Run(Dying("Soon after, I reached level 13.", E("He was only a spider, and an old one.", {kind = "lore"})))
    check(paras[2] == "A little after eleven, {p:Riptear} killed me in {p:Venomweb Vale}. He was only a spider, and an old one."
        and paras[3]:find("^Soon after, I reached level 13%. We learned"), "and waits until the death is told: " .. All(paras))
    paras = Run(Dying("Soon after, I reached level 13.", E("I had died before, and knew the cold road back by now.", {felt = "death", glue = true, it = death})))
    check(paras[2]:find("knew the cold road back by now%.$") and paras[3]:find("^Soon after, I reached level 13%."),
        "a feeling answers the death, not the level: " .. All(paras))
    -- (in a plain paragraph it stays where it was; a feeling that follows sends it on)
    paras = Run({
        E("We destroyed the last of the family and took his bones to the worker.", {work = true}),
        E("By then we were both level 11.", {glue = true, level = true}),
        E("At the mills we broke the dead that gathered there.", {work = true}),
    })
    check(#paras == 1 and Has(paras[1], "to the worker. By then we were both level 11. At the mills"), "a plain paragraph keeps it: " .. All(paras))
    paras = Run({
        E("We walked the road north past the mills. The trees were grey and bare."),
        E("For the first time, I stood in the city of the dead."),
        E("By then we were both level 11.", {glue = true, level = true}),
        E("I had not known there were so many of us.", {felt = "city", glue = true}),
        E("We went on to the camp and slept there. The fire was low and the night was cold."),
    })
    check(Has(All(paras), "the city of the dead. I had not known there were so many of us.\n\nBy then we were both level 11. We went on"),
        "a feeling sends the level line on: " .. All(paras))
    -- (pushed out before the close, it joins the close)
    paras = Run({
        E("We walked the road north past the mills. The trees were grey and bare."),
        E("A little after eleven, {p:Riptear} killed me in {p:Venomweb Vale}.", {kind = "death", clock = true, peak = "death", it = death}),
        E("Soon after, I reached level 13.", {kind = "death", glue = true, level = true, it = death}),
        E("We ended the day there a little after one.", {glue = true, it = {m = {close = "long"}}}),
    })
    check(paras[#paras] == "Soon after, I reached level 13. We ended the day there a little after one.", "the level line joins the close: " .. All(paras))
end

do  -- S9: the steps of one chain stay in one paragraph while the size allows
    local function Chain(key)
        return {
            E("Saturday night I set out again in the glades.", {turn = true}),
            E("We beat back the dead by the old bridge for the guard.", {work = true}),
            E("We went north to the haunt and executed the corpse thief.", {work = true}),
            E("At the mills we put down the family whose pride had kept its workers there to die.", {work = true, chain = key}),
            E("One of those workers hoped they had known fear at the end, and admitted it was a foolish hope.", {chain = key}),
            E("We destroyed the last of the family and took his bones to the worker.", {work = true, turn = true, chain = key}),
            E("We broke the dead that gathered at the well for the guard.", {work = true}),
            E("The executor took the paw, and hoped it would warn others.", {work = true}),
        }
    end
    local scene = "At the mills we put down the family whose pride had kept its workers there to die. One of those workers "
        .. "hoped they had known fear at the end, and admitted it was a foolish hope. We destroyed the last of the family "
        .. "and took his bones to the worker."
    local paras = Run(Chain("coleman"))
    Print("chain", paras)
    check(Has(All(paras), scene), "one chain, one paragraph: " .. All(paras))
    check(not Has(All(Run(Chain(nil))), scene), "(without the mark the turn breaks it)")
    Within(paras, " (chain): ")
    -- (no room in the paragraph the chain met: the break falls before the chain, not inside it)
    paras = Run({
        E("We beat back the dead by the old bridge for the guard. We burned what was left of them in the field.", {work = true}),
        E("We went north to the haunt and executed the corpse thief there.", {work = true}),
        E("At the mills we put down the family whose pride had kept its workers there to die.", {work = true, chain = "c"}),
        E("One of those workers hoped they had known fear at the end, and admitted it was a foolish hope.", {chain = "c"}),
        E("We destroyed the last of the family and took his bones to the worker.", {work = true, chain = "c"}),
        E("We rode home in the rain and said little.", {work = true}),
    })
    check(paras[2]:find("^At the mills we put down") and Has(paras[2], scene), "the break falls between chains: " .. All(paras))
    Within(paras, " (chain, no room): ")
    -- (a chain longer than a paragraph may hold is still broken, and a feeling still closes)
    local long = {}
    for n = 1, 7 do long[n] = E("Step " .. n .. " of the errand took us over the hills and back by the long road.", {chain = "x"}) end
    Within(Run(long), " (long chain): ")
    paras = Run({
        E("We walked the road north past the mills. The trees were grey and bare."),
        E("I raised the fallen guard in the vale.", {chain = "f", work = true}),
        E("This time I walked out of it.", {felt = "backDeath", glue = true}),
        E("I took a copy of the orders for him and read them twice.", {chain = "f", work = true}),
        E("We carried them north to the keep before dawn.", {chain = "f", work = true}),
    })
    check(Has(All(paras), "This time I walked out of it.\n\nI took a copy"), "a feeling closes inside a chain too: " .. All(paras))
end

do  -- S12: one sentence alone only for a death, a peak or the close
    local paras = Run({
        E("A wolf killed me.", {kind = "death", peak = "death", sit = 1}),
        E("A bear killed me.", {kind = "death", peak = "death", sit = 2}),
        E("We walked north along the river.", {sit = 2}),
        E("We came to the farm at dusk and found the door barred from within.", {sit = 2}),
        E("The farmer would not open it, whatever we called through the boards to him.", {sit = 2}),
        E("A boar killed me.", {kind = "death", peak = "death", sit = 2}),
        E("I carried the thanks of the beggar back to the keep.", {sit = 2}),
        E("We came to the mill at dawn and found the wheel still turning.", {sit = 2}),
        E("The miller had been dead a year, and nobody had told the wheel.", {sit = 2}),
        E("We slept in the barn.", {sit = 2, it = {m = {close = "sleep"}}}),
    })
    Print("alone", paras)
    for _, para in ipairs(paras) do
        check(#Sentences(para) > 1 or Has(para, "killed me"), "only a death stands alone here: " .. All(paras))
    end
    check(Has(All(paras), "\n\nI carried the thanks of the beggar back to the keep. We came to the mill"), "the orphan joins its neighbour: " .. All(paras))
    check(#Flat(paras) == 10, "every line is told")
end

do  -- S8, S12: the chapter's own level line (kind "level"), and a line shut in before a death
    local death = {m = {}, peak = "death"}
    local function Day(last)
        local seq = {
            E("On Friday, for the first time, I saw the desert beyond the Needles. Sand and sun covered the land."),
            E("I looked in at the goblin town."),
            E("Just after ten, a bandit killed me.", {kind = "death", clock = true, peak = "death", it = death}),
            E("I spent six minutes as a spirit, walking back to where I fell.", {felt = "deathWalk", glue = true, it = death}),
            E("I reached level 45.", {kind = "level"}),
        }
        seq[#seq + 1] = last
        return seq
    end
    local paras = Run(Day())
    check(paras[#paras] == "I reached level 45." and paras[#paras - 1]:find("where I fell%.$"),
        "with no plain paragraph left, the level line ends the chapter alone: " .. All(paras))
    paras = Run(Day(E("We sold what we had and slept at the inn.")))
    check(paras[#paras] == "I reached level 45. We sold what we had and slept at the inn.", "or opens the plain one after: " .. All(paras))
    -- (the line that opens the day leads into the death when nothing else can take it)
    paras = Run({
        E("Wednesday afternoon, I stopped in the city beneath the ruins.", {turn = true}),
        E("Around half past two, an enforcer killed me.", {kind = "death", clock = true, peak = "death", it = death}),
        E("Somehow, I had thought a corpse would be harder to kill.", {felt = "deathAgain", glue = true, it = death}),
        E("That evening, I rode the lift back up into the grey light. The road ran north through the trees.", {turn = true}),
    })
    check(paras[1] == "Wednesday afternoon, I stopped in the city beneath the ruins. Around half past two, an enforcer killed me. "
        .. "Somehow, I had thought a corpse would be harder to kill.", "the opening leads into the death: " .. All(paras))
    -- (a full paragraph lends its last line to the one sentence after it, but not a line that
    -- leans on what came before, and a pair of short sentences asks for nothing)
    local function Full(third, fourth)
        return {
            E("We came through the hill town, where the militia keeps watch."),
            E("I fell to my death twice, and the second time I should have known better."),
            E(third),
            E(fourth),
            E("I climbed to level 13.", {kind = "level"}),
        }
    end
    paras = Run(Full("Nothing with a sword had anything to do with it.", "I called on the Light, and my friend rose from the stones."))
    check(#paras == 2 and paras[2] == "I called on the Light, and my friend rose from the stones. I climbed to level 13.",
        "the last line is lent, and no more: " .. All(paras))
    paras = Run(Full("We climbed the hill again by the long road.", "There the militia had lit its fires for the night."))
    check(paras[#paras] == "I climbed to level 13." and paras[#paras - 1]:find("for the night%.$"), "a line that leans back is not lent: " .. All(paras))
end

do  -- the close after a peak stands alone
    local queen = {m = {}}
    local paras = Run({
        E("We walked the road north past the mills. The trees were grey and bare."),
        E("We came to the keep and found it empty of all but rats and dust."),
        E("In the throne room I knelt before {n:Lady Sylvanas Windrunner}.", {it = queen, peak = "figure", scene = true}),
        E("I would follow her.", {felt = "awe", it = queen}),
        E("I slept in the Ruins of Lordaeron.", {it = {m = {close = "sleep"}}}),
    })
    Print("close", paras)
    check(#paras == 3 and paras[3] == "I slept in the Ruins of Lordaeron.", "the close stands alone after a peak: " .. All(paras))
    check(paras[2]:find("^In the throne room") and paras[2]:find("follow her%.$"), "the meeting and its feeling: " .. paras[2])
end

do  -- a told hour and a turn of purpose open a paragraph once the one before can stand
    local paras = Run({
        E("I mined copper along the hills. I smelted it at the forge."),
        E("I sold the bars and kept a few for the anvil and the long nights ahead of me there."),
        E("Past ten, I took the road to the Bulwark.", {clock = true}),
        E("The watch there had lost two men to the plague that week alone."),
        E("They were glad of one more blade on the wall that night."),
        E("I turned to the matter of the farms.", {turn = true}),
        E("The Scarlet Crusade held them, and held them well, with torches at every door."),
    })
    Print("hour and turn", paras)
    check(#paras == 3, "three paragraphs: " .. All(paras))
    check(paras[2]:find("^Past ten, I took the road"), "the hour opens a paragraph: " .. All(paras))
    check(paras[3]:find("^I turned to the matter"), "the turn opens a paragraph: " .. All(paras))
    Within(paras, " (hour and turn): ")
end

do  -- size: two to four sentences, never over sixty words, whatever comes in
    local seq = {}
    for n = 1, 13 do
        seq[n] = E(({"The road", "A track", "Our way", "The path"})[n % 4 + 1] .. " ran on past farm number " .. n
            .. " and the grey hills that lay beyond it.")
    end
    local paras = Run(seq)
    Within(paras, " (size): ")
    for _, para in ipairs(paras) do check(#Sentences(para) >= 2, "no paragraph of one plain sentence: " .. All(paras)) end
    check(#Flat(paras) == 13, "every sentence is told")
    seq = {}
    for n = 1, 9 do
        seq[n] = E("The men of camp " .. n .. " kept a poor watch over the road and the river below. "
            .. "Their fires were out before the moon was up over the hills.")
    end
    paras = Run(seq)
    Within(paras, " (size, two-sentence lines): ")
    check(#Flat(paras) == 18, "every sentence is told")
end

do  -- what is known of the one just met stays with the meeting, and the feeling closes it
    local event = {}
    local known = {m = {e = event}}
    local function Seq(felt)
        return {
            E("I mined copper along the hills. The veins were thin and far apart."),
            E("I carried the gem from the lake to the Magic Quarter."),
            E("In the {p:Undercity}, I spoke with {n:Lady Sylvanas Windrunner}.", {kind = "first", it = {m = {e = event}}}),
            E("The Dark Lady ruled the Forsaken, free of the Lich King's will.", {kind = "lore", it = known}),
            felt and E("Here was my queen, and I hardly knew where to look.", {felt = "figureNamed", glue = true, it = known}) or nil,
            E("I stopped just after one.", {it = {m = {close = "late"}}}),
        }
    end
    local paras = Run(Seq(true))
    Print("meeting", paras)
    check(#paras == 3 and paras[2] == "In the {p:Undercity}, I spoke with {n:Lady Sylvanas Windrunner}. "
        .. "The Dark Lady ruled the Forsaken, free of the Lich King's will. Here was my queen, and I hardly knew where to look.",
        "the meeting, what is known of her, the feeling: " .. All(paras))
    check(paras[3] == "I stopped just after one.", "the close after it: " .. All(paras))
    paras = Run(Seq(false))
    check(Has(All(paras), "{n:Lady Sylvanas Windrunner}. The Dark Lady ruled"), "the two stay together without a feeling too: " .. All(paras))
end

-- ---------------------------------------------------------------- S5 nothing twice
do
    local seq = {
        E("Just after nine, a wolf killed me.", {kind = "death", clock = true}),
        E("We saw {q:The Zhevra} through."),
        E("The road ran south from there."),
        E("We saw {q:The Zhevra} through."),
        E("Close to ten, a wolf killed me.", {kind = "death", clock = true}),
        E("Near eleven, I sold my goods in town.", {clock = true}),
        E("Past midnight, I sold my goods in town.", {clock = true}),
    }
    local text = All(Run(seq))
    check(seq[4].dropped and Times(text, "We saw {q:The Zhevra} through.") == 1, "the same sentence twice: the second goes: " .. text)
    check(seq[7].dropped and Times(text, "I sold my goods in town.") == 1, "the same but for the hour: the second goes: " .. text)
    check(not seq[5].dropped and Times(text, "a wolf killed me.") == 2, "a second death is a second death: " .. text)
    check(not seq[1].dropped and not seq[2].dropped and not seq[3].dropped and not seq[6].dropped, "nothing else is dropped")
end

-- ---------------------------------------------------------------- S6 the feeling's place
do
    local seq = {
        E("We walked north. The road was empty."),
        E("I was glad of the company.", {felt = "glad"}),
        E("I feared the night.", {felt = "fear"}),
        E("We came to the mills. We burned them."),
        E("It sat ill with me.", {felt = "ill"}),
    }
    local text = All(Run(seq))
    check(seq[3].dropped and not seq[2].dropped, "a feeling never follows a feeling: " .. text)
    check(seq[5].dropped and text:find("We burned them%.$"), "a feeling never ends the chapter: " .. text)
    -- (the first death's own line is a fact as much as a feeling: it stays, even last)
    seq = {
        E("We walked north. The road was empty."),
        E("I was glad of the company.", {felt = "glad"}),
        E("Just after nine, a boar killed me.", {kind = "death", clock = true, peak = "deathFirst"}),
        E("It was the first time I died.", {felt = "deathFirst"}),
    }
    text = All(Run(seq))
    check(not seq[4].dropped and text:find("the first time I died%.$"), "the first death keeps its line: " .. text)
    seq = {
        E("We walked north. The road was empty."),
        E("I was glad of the company.", {felt = "glad"}),
        E("It was the first time I died.", {felt = "deathFirst"}),
        E("We went on."),
    }
    Run(seq)
    check(seq[2].dropped and not seq[3].dropped, "of two feelings in a row the first death's stays")
end

-- ---------------------------------------------------------------- S2 openers
do  -- the three turns, one sentence at a time
    check(S.Front("We fought the Scarlet warriors at the tower for Zygand.") == "At the tower we fought the Scarlet warriors for Zygand.",
        "the closing place comes to the front")
    check(S.Front("We killed the bats near the Solliden Farmstead.") == "Near the Solliden Farmstead we killed the bats.", "a named place")
    check(S.Front("I gathered {q:Doom Weed} in the hills.") == "In the hills I gathered {q:Doom Weed}.", "markup moves whole")
    check(S.Front("We killed {n:Maggot Eye} in the cellar.") == "In the cellar we killed {n:Maggot Eye}.", "a marked name stays whole")
    check(S.Front("We cleared the camp that night.") == "That night we cleared the camp.", "a closing time comes to the front")
    -- (not certain, so left alone)
    check(S.Front("I carried the letter to the tower.") == nil, "a verb of carrying: the place is where one went")
    check(S.Front("We walked north along the road.") == nil, "a verb of going is left")
    check(S.Front("We killed the rot hide gnolls, and burned the camp at the mill.") == nil, "two acts: whose place is it")
    check(S.Front("We killed the gnolls who camped at the mill.") == nil, "the place belongs to the gnolls")
    check(S.Front("We found the letter in the morning.") == nil, "not a place")
    check(S.Front("The watch killed the bats near the old mill.") == nil, "only a sentence that opens on We or I")
    check(S.ThereOpen("We stole pumpkins in Brill.", "We came to Brill, under its grey trees.") == "There we stole pumpkins.",
        "There, when the sentence before named the place")
    check(S.ThereOpen("We stole pumpkins in Brill.", "We came to the mills.") == nil, "no There without the name before it")
    check(S.ThereOpen("We stole pumpkins near Brill.", "We came to Brill.") == nil, "near a place is not there")
    check(S.Lead("I rode the lift down into the Undercity for the first time, and found a city of crypts.")
        == "For the first time, I rode the lift down into the Undercity, and found a city of crypts.", "for the first time leads")
    check(S.Lead("We rested for a while.") == "For a while we rested.", "for a while leads")
    check(S.Lead("We rested, and for a while nobody spoke.") == nil, "only out of the first clause")
end

do  -- over a chapter: never three alike in a row, "Then" from a join the line already held
    local function Seq()
        return {
            E("We came to Brill, under its grey trees."),
            E("We stole pumpkins in Brill."),
            E("We killed the bats near the old mill."),
            E("The Scarlet warriors held the tower beyond the fields."),
            E("I mined copper in the hills, then smelted it at the forge.", {sit = 2}),
            E("I sold the bars. I bought a knife.", {sit = 2}),
        }
    end
    local seq = Seq()
    local paras = Run(seq)
    Print("openers", paras)
    local text = All(paras)
    check(Has(text, "We came to Brill, under its grey trees. There we stole pumpkins."), "There after the place was named: " .. text)
    check(Has(text, "Then I smelted it at the forge."), "Then from the line's own join: " .. text)
    check(Times(text, "Then ") == 1 and not Has(text, "After that") and not Has(text, "Later"), "no link is invented: " .. text)
    NoThreeAlike(paras, " (openers): ")
    Within(paras, " (openers): ")
    check(BareCount(paras) < BareCount({SeqText(Seq())}), "fewer sentences open on We or I: " .. text)
    -- (the same list, the same chapter: no random draw)
    check(text == All(Run(Seq())), "the same list gives the same chapter")
end

do  -- words are moved, never added or lost
    local function Seq()
        return {
            E("The road ran north past the mills."),
            E("We killed the bats near the old mill."),
            E("The trees were grey and bare."),
            E("The lamps were green in the city.", {sit = 2}),
            E("I found the clerk in the cellar.", {sit = 2}),
            E("The clerk was asleep over his ledgers.", {sit = 2}),
        }
    end
    for _, seed in ipairs({"a", "b", "c", "Alberich", "Tobias"}) do
        local paras = Run(Seq(), seed)
        local text = All(paras)
        -- (two of six open bare: one in three is not under one in three, so one is turned)
        check(BareCount(paras) == 1, "under one in three on We or I (seed " .. seed .. "): " .. text)
        check(Has(text, "Near the old mill we killed the bats.") or Has(text, "In the cellar I found the clerk."), "by its own place: " .. text)
        check(Bag(text) == Bag(SeqText(Seq())), "the same words, moved (seed " .. seed .. "): " .. text)
        check(text == All(Run(Seq(), seed)), "the same seed, the same choice")
    end
end

do  -- lines whose wording is the point are never reshaped
    local function Seq()
        return {
            E("We killed the bats near the old mill.", {scene = true}),
            E("We burned the wagons on the east road.", {scene = true}),
            E("We found the captain in the cellar.", {scene = true}),
            E("I feared the night at the tower.", {felt = "fear"}),
            E('We told the watch "hold the gate" at the tower.'),
            E("I reached level 12 in the hills.", {level = true, kind = "level"}),
            E("We slept in the camp.", {it = {m = {close = "sleep"}}}),
        }
    end
    local seq = Seq()
    local text = All(Run(seq))
    for _, entry in ipairs(Seq()) do check(Has(text, entry.text), "left as written: " .. entry.text .. " / " .. text) end
end

-- ---------------------------------------------------------------- S3 sentence length
do
    local long = {
        "We walked the whole road north from the crossing, past the three burned farms and the empty mill, then turned east at the broken bridge and came down to the lake.",
        "The old gate of the keep was shut and barred against us in the last grey light, and we slept under the broken wall with the rain on the stones.",
        -- (not certain, so left whole)
        "The watchman said that we had come too late, and I told him plainly that the road had been long and the night longer than he knew.",
        'The captain told us "hold the gate until the dawn comes, then ride south with every man you have left, and do not look back at the fires" and left.',
        "We walked the whole road north from the crossing past the three burned farms and the empty mill, then east along the broken shore to the lake.",
        "The road was long and the hills were bare and the wind blew cold from the north over all the farms, and nothing moved there but crows.",
    }
    local seq = {}
    for n, line in ipairs(long) do seq[n] = E(line, {sit = n}) end
    local paras = Run(seq)
    Print("long sentences", paras)
    check(paras[1] == "We walked the whole road north from the crossing, past the three burned farms and the empty mill. "
        .. "Then we turned east at the broken bridge and came down to the lake.", "split at then, the subject told again: " .. paras[1])
    check(paras[2] == "The old gate of the keep was shut and barred against us in the last grey light. "
        .. "We slept under the broken wall with the rain on the stones.", "split at and, where a new subject stands: " .. paras[2])
    check(paras[3] == long[3], "what somebody said is not cut in two: " .. paras[3])
    check(paras[4] == long[4], "a quotation is never split: " .. paras[4])
    check(paras[5] == long[5], "no half without a verb: " .. paras[5])
    check(paras[6] == long[6], "no half without a subject of its own kind: " .. paras[6])
    for i = 1, 2 do
        for _, sentence in ipairs(Sentences(paras[i])) do check(Words(sentence) <= 24, "a split sentence is short: " .. sentence) end
    end
    -- (a sentence of 24 words or fewer is never split for its length)
    local fine = "The men walked the road north from the crossing past the burned farms, and they turned east at the old bridge by the lake."
    check(Words(fine) == 24 and Has(Run({E(fine), E("The water was still and black under the moon.")})[1], fine), "24 words stand")
end

-- ---------------------------------------------------------------- S4 second mention
do
    local paras = Run({
        E("We rode to Bandarion Keep at dusk. The guards of Bandarion Keep were asleep."),
        E("In the Undercity the lamps were green. I liked the Undercity's quiet."),
        E("We drank at the Gallows' End Tavern. The Gallows' End Tavern was full, and so was the Lion's Pride Inn.", {sit = 2}),
        E("He kept the Scarlet Tower. Beyond the Scarlet Tower stood the Broken Tower.", {sit = 2}),
        E("We rode back to Bandarion Keep.", {sit = 3}),
        E("We saw {q:Bandarion Keep} through. {n:Keeper Tavern} thanked us in {p:Bandarion Keep}.", {sit = 3}),
    })
    Print("second mention", paras)
    local text = All(paras)
    check(Has(text, "We rode to Bandarion Keep at dusk. The guards of the keep were asleep."), "the keep: " .. text)
    check(Has(text, "In the Undercity the lamps were green. I liked the city's quiet."), "the city, and its 's: " .. text)
    check(Has(text, "We drank at the Gallows' End Tavern. The tavern was full, and so was the Lion's Pride Inn."), "the tavern: " .. text)
    check(Has(text, "He kept the Scarlet Tower. Beyond the Scarlet Tower stood the Broken Tower."), "two towers keep their names: " .. text)
    check(Has(text, "We rode back to the keep."), "the full name once a chapter, in a later paragraph too: " .. text)
    check(Has(text, "We saw {q:Bandarion Keep} through. {n:Keeper Tavern} thanked us in the keep."), "a quest or a person is not a place: " .. text)
    -- (the bare word already in use for something else: no shortening)
    text = All(Run({E("We rode to Bandarion Keep at dusk. Another keep stood beyond the hills. Bandarion Keep was the older.")}))
    check(Has(text, "Bandarion Keep was the older."), "left when the word is in use: " .. text)
    local marks = S.Mentions({"We", "took", "Bandarion", "Keep's", "gate", "near", "the", "Undercity."})
    check(#marks == 2 and marks[1].key == "bandarion keep" and marks[1].kind == "keep" and marks[1].tail == "'s"
        and marks[2].key == "undercity" and marks[2].kind == "city", "the places in a sentence")
    check(#S.Mentions({"The", "Keep", "of", "the", "inn", "by", "Camp", "Taurajo."}) == 0, "only names that end on the kind")
    -- (S10: the chapter's own "the tavern" after the name is that tavern; "a tower", "the ruined tower" are not)
    text = All(Run({
        E("We stopped at the Gallows' End Tavern to rest, and I set my hearthstone there."),
        E("In the tavern cellar we fed the pumpkin to a captive zealot."),
        E("We went down the road to look into a stranger's camp. She offered us lessons in camping.", {sit = 2}),
        E("That night I slept at the Gallows' End Tavern.", {sit = 2}),
    }))
    check(Has(text, "That night I slept at the tavern."), "the tavern, three paragraphs on: " .. text)
    check(Times(text, "Gallows' End Tavern") == 1, "the full name once: " .. text)
    text = All(Run({
        E("We came to the Scarlet Tower at noon and found it held."),
        E("For the executor we killed a captain at the ruined tower by the lake.", {sit = 2}),
        E("By dusk the Scarlet Tower was ours.", {sit = 2}),
    }))
    check(Has(text, "By dusk the Scarlet Tower was ours."), "left when another tower is told of: " .. text)
    text = All(Run({
        E("We came to the Scarlet Tower at noon and found it held."),
        E("The Broken Tower stood beyond it, empty.", {sit = 2}),
        E("By dusk the Scarlet Tower was ours.", {sit = 2}),
    }))
    check(Has(text, "By dusk the Scarlet Tower was ours."), "left once a second place of the kind is named: " .. text)
    text = All(Run({
        E("We came to the Scarlet Tower at noon and found it held."),
        E("\"The Scarlet Tower will fall,\" said the captain.", {sit = 2}),
        E("By dusk the Scarlet Tower was ours.", {sit = 2}),
    }))
    check(Has(text, "\"The Scarlet Tower will fall,\" said the captain.") and Has(text, "By dusk the tower was ours."),
        "a quoted line is never changed: " .. text)
end

-- ---------------------------------------------------------------- S11 a title once a chapter
do
    local seq = {
        E("{n:Shadow Priest Sarvis} sent us to Apothecary Johaan in Brill. For Zygand we killed Captain Perrine at the bridge."),
        E("Dahlia and I brought Executor Zygand his overdue reports. Apothecary Johaan wanted pumpkins for his reagents."),
        E("Executor Zygand's patience was short, and Shadow Priest Sarvis wanted the papers too.", {sit = 2}),
        E("\"Executor Zygand will hear of it,\" said Magistrate Sevren.", {sit = 2}),
        E("I raised the fallen Deathguard Falgan in the vale. We told {n:Executor Zygand} what Magistrate Sevren had said.", {sit = 2}),
        E("Deathguard Falgan thanked me, and Captain Perrine's men fled before the fallen Deathguard Falgan.", {sit = 3}),
    }
    local before = SeqText(seq)
    local paras = Run(seq)
    local text = All(paras)
    Print("titles", paras)
    check(Has(text, "For Zygand we killed Captain Perrine") and Has(text, "brought Executor Zygand his overdue reports"),
        "the first mention with the title keeps it: " .. text)
    check(Has(text, "reports. Johaan wanted pumpkins"), "the title is dropped the next time: " .. text)
    check(Has(text, "Zygand's patience was short, and Sarvis wanted the papers too."), "with a possessive, and a title of two words: " .. text)
    check(Has(text, "\"Executor Zygand will hear of it,\" said Magistrate Sevren."), "a quoted line is never changed: " .. text)
    check(Has(text, "We told {n:Executor Zygand} what Sevren had said."), "markup is never changed: " .. text)
    check(Has(text, "Falgan thanked me, and Perrine's men fled before the fallen Deathguard Falgan."),
        "a title that describes stays: " .. text)
    -- (only title words are gone)
    check(Words(before) - Words(text) == 7, "seven title words less, and nothing else: " .. (Words(before) - Words(text)))
    -- (twice the same result: safe to run after a planner that did it already)
    local again = {}
    for i, para in ipairs(paras) do again[i] = E(para, {sit = i}) end
    local second = All(Run(again))
    for _, title in ipairs({"Executor", "Apothecary", "Deathguard", "Magistrate", "Captain", "Shadow Priest"}) do
        check(Times(second, title) == Times(text, title), "a second pass changes nothing: " .. title .. ": " .. second)
    end
    -- (two people who may share the name keep their titles)
    text = All(Run({
        E("Deathguard Morris kept the gate with Calvin Morris. Deathguard Morris slept little."),
        E("Lady Sylvanas ruled. The Dark Lady Sylvanas watched, and Lady Sylvanas waited.", {sit = 2}),
        E("Executor Arren wrote to Magistrate Arren. Executor Arren had no answer.", {sit = 3}),
    }))
    check(Has(text, "Deathguard Morris slept little.") and Has(text, "and Lady Sylvanas waited.") and Has(text, "Executor Arren had no answer."),
        "a shared name keeps its title: " .. text)
    -- (not a person)
    text = All(Run({
        E("We passed the Deathguard Tower and the Royal Apothecary Society. The Deathguard Tower was dark."),
        E("The Royal Apothecary Society kept its doors shut, and the Dark Lady kept her counsel."),
    }))
    check(Has(text, "the Royal Apothecary Society kept") or Has(text, "The Royal Apothecary Society kept"), "a society is not a person: " .. text)
    check(not Has(text, "Royal Society"), "no title cut out of a name: " .. text)
    local marks = S.Titled("We met Shadow Priest Sarvis and Executor Zygand's clerk.")
    check(#marks == 2 and marks[1].title == "Shadow Priest" and marks[1].key == "Sarvis" and marks[2].key == "Zygand", "the titled names of a sentence")
end

-- ---------------------------------------------------------------- markup stays whole
do
    local seq = {
        E("We came to {p:Brill}, under its grey trees."),
        E("We killed {n:Maggot Eye} in {p:Brill}."),
        E("We gathered {q:A Putrid Task} near the old mill."),
        E("For {n:Deathguard Dillinger} we cleared the {p:Agamand Mills} of the dead, then carried the {q:Family Remains} back to the old chapel in {p:Brill}."),
    }
    local before = SeqText(seq)
    local text = All(Run(seq))
    for mark in before:gmatch("{%a:[^}]*}") do
        check(Times(text, mark) >= 1, "a mark is kept whole: " .. mark .. " / " .. text)
    end
    check(not text:find("\1", 1, true) and not text:find("{%a:[^}]*{"), "no broken mark: " .. text)
end

-- ---------------------------------------------------------------- the evening of tests/SelfPlan.lua
local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local Z, U = "Tirisfal Glades", "Undercity"
local function Person(retell)
    local j, level = {}, 11
    local function Add(e) e.pl, e.ol = e.pl or level, e.ol or level; j[#j + 1] = e end
    Add({k = "play", t = At(0, 20), e = At(0, 22), z = Z})
    Add({k = "quest", d = "Rude Awakening", t = At(0, 20, 20), z = Z, ql = 1})
    Add({k = "quest", d = "The Mindless Ones", t = At(0, 20, 50), z = Z, ql = 2})
    Add({k = "death", d = "Vampiric Duskbat", w = "you", t = At(0, 21, 10), z = Z})
    Add({k = "quest", d = "Rattling the Rattlecages", t = At(0, 21, 40), z = Z, ql = 3})
    Add({k = "play", t = At(1, 14, 20), e = At(1, 14, 50), z = U})
    Add({k = "town", d = U, t = At(1, 14, 21), z = U})
    Add({k = "death", d = "Dark Enforcer", w = "you", t = At(1, 14, 33), z = Z})
    Add({k = "rest", d = "Ruins of Lordaeron", t = At(1, 14, 40), z = U})
    Add({k = "play", t = At(1, 21, 30), e = At(1, 25, 5), z = Z})
    Add({k = "gather", d = "mining", c = 16, t = At(1, 21, 32), e = At(1, 21, 50), z = Z})
    Add({k = "first", d = "rarebeast", z = "Sri'skulk", sz = Z, t = At(1, 21, 39)})
    Add({k = "quest", d = "Rear Guard Patrol", qid = 356, t = At(1, 21, 58), z = Z, ql = 11})
    Add({k = "mylevel", d = "12", t = At(1, 22, 4), z = Z}); level = 12
    Add({k = "quest", d = "Bandarion Keep", qid = 96899, t = At(1, 22, 20), z = Z, ql = 12})
    Add({k = "quest", d = "A Righteous Cause", qid = 96896, t = At(1, 23, 39), z = Z, ql = 12})
    Add({k = "death", d = "Riptear", w = "you", t = At(1, 23, 50), z = Z})
    Add({k = "mylevel", d = "13", t = At(1, 23, 55), z = Z}); level = 13
    Add({k = "quest", d = "Leonid's Letter", qid = 98545, t = At(1, 24, 21), z = U, ql = 12})
    Add({k = "first", d = "notable", n = "Lady Sylvanas Windrunner", interaction = true, z = U, t = At(1, 24, 29)})
    Add({k = "quest", d = "The Prodigal Lich Returns", qid = 411, t = At(1, 24, 25), z = U, ql = 12})
    Add({k = "sleep", d = "Ruins of Lordaeron", t = At(1, 25, 4), z = U})
    return {name = "Alberich", charKey = "selfstyle", self = true, race = "Scourge", class = "WARLOCK", faction = "Horde",
        startLevel = 1, retell = retell, journal = j}
end

-- (every call of the style pass is watched: what came in, what went out)
local calls = {}
local Apply = S.Apply
S.Apply = function(seq, env)
    local words, before = 0, SeqText(seq)
    for _, entry in ipairs(seq) do words = words + Words(entry.text) end
    local paras = Apply(seq, env)
    calls[#calls + 1] = {seq = seq, paras = paras, words = words, before = before}
    return paras
end
local evenings = 0
for retell = 0, 7 do
    local tag = " (retell " .. retell .. "): "
    local p = Person(retell)
    A.BookVariant, A.SelfTale.PlanStrict = function(k) if k == "teller" then return "planned" end end, true
    calls = {}
    local days = A.JournalBook(p)
    local tales = A.SelfTale.Tell(p, days, false, retell)
    A.BookVariant, A.SelfTale.PlanStrict = nil, nil
    local last = days[#days]
    local told = last and tales[last.key] and A.JournalPlain(tales[last.key].text) or ""
    check(#calls >= 1, "the planned evening goes through the style pass" .. tag)
    local call = calls[#calls]
    local paras, seq = call.paras, call.seq
    if show and retell < 2 then io.write("--- the evening", tag, "\n", All(paras), "\n\n") end
    evenings = evenings + 1
    check(#paras >= 3, "the evening breathes: three paragraphs or more" .. tag .. All(paras))
    for _, para in ipairs(paras) do check(Has(told, A.JournalPlain(para)), "the paragraph is in the chapter" .. tag .. para) end
    -- (the limits; a single authored line longer than the limit is the planner's, not the style's)
    local kept, inPara = {}, {}
    for _, entry in ipairs(seq) do
        if not entry.dropped then
            kept[#kept + 1] = entry
            check(type(entry.para) == "number" and paras[entry.para], "a told line knows its paragraph" .. tag .. entry.text)
            check(Has(paras[entry.para], entry.text), "and stands in it" .. tag .. entry.text)
            inPara[entry.para] = (inPara[entry.para] or 0) + 1
        else
            check(entry.felt or #kept > 0, "only a feeling or a repeat is dropped" .. tag .. entry.text)
        end
    end
    for n, para in ipairs(paras) do
        check(para:find("^[%u%d{]") and para:find("[%.!]$"), "a paragraph is whole" .. tag .. para)
        check(not para:find("  ", 1, true) and not para:find("\1", 1, true), "no stray space or mark" .. tag .. para)
        if (inPara[n] or 0) > 1 then
            check(#Sentences(para) <= 4, "four sentences at most" .. tag .. para)
            check(Words(para) <= 60, "sixty words at most" .. tag .. para)
        end
        check(Times(para, ". Then ") + (para:find("^Then ") and 1 or 0) <= 1, "Then once a paragraph" .. tag .. para)
    end
    -- (the order told is the order planned, but for a level line that stepped out of a scene and
    -- a line set before the feeling it followed; S7: a feeling is the last line of its paragraph)
    local lastPara = 0
    for i, entry in ipairs(kept) do
        if not entry.level and not entry.felt and entry.kind ~= "lore" then
            check(entry.para >= lastPara, "the order is kept" .. tag .. entry.text)
            lastPara = entry.para
        end
        if i > 1 then check(not (entry.felt and kept[i - 1].felt), "no feeling after a feeling" .. tag .. entry.text) end
        if entry.felt then
            local para = paras[entry.para]
            check(para:sub(-#entry.text) == entry.text, "a feeling closes its paragraph" .. tag .. para)
        end
    end
    -- (S8: one's own level line shares no paragraph with a feeling, a death or a peak)
    for _, entry in ipairs(kept) do
        if entry.level and (" " .. Plain(entry.text) .. " "):find("[^%a]I[^%a]") then
            for _, other in ipairs(kept) do
                if other ~= entry and other.para == entry.para then
                    check(not other.felt and other.kind ~= "death" and not other.peak,
                        "a level line keeps out of a scene" .. tag .. paras[entry.para])
                end
            end
        end
    end
    -- (S12: one sentence alone only for a death, a peak or the close)
    for n, para in ipairs(paras) do
        if #Sentences(para) == 1 then
            local fine = false
            for _, entry in ipairs(kept) do
                if entry.para == n and (entry.kind == "death" or entry.peak or entry.felt or entry.close
                    or (entry.it and (entry.it.peak or (entry.it.m and entry.it.m.close)))) then fine = true end
            end
            check(fine or #paras == 1, "one sentence alone is a death, a peak or the close" .. tag .. All(paras))
        end
    end
    check(not kept[#kept].felt or kept[#kept].felt == "deathFirst", "no feeling ends the chapter" .. tag .. kept[#kept].text)
    -- (not longer: only a "Then we" from a split adds a word)
    local thens = 0
    for _, sentence in ipairs(Flat(paras)) do if S.FirstWord(sentence) == "Then" then thens = thens + 1 end end
    check(Words(All(paras)) <= call.words + thens, "the style pass adds no words" .. tag)
    check(thens <= 4, "Then is rare" .. tag .. All(paras))
    -- (a link in time the planner's own line did not hold is never added)
    for _, sentence in ipairs(Flat(paras)) do
        local link = sentence:match("^After that") or sentence:match("^Later") or sentence:match("^Soon")
        check(not link or Has(call.before, sentence), "no invented link" .. tag .. sentence)
    end
end
S.Apply = Apply

io.write("PASS: " .. assertions .. " style assertions (" .. evenings .. " evenings)\n")
