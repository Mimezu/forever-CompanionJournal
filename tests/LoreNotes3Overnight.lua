-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes3Overnight.lua
-- Third overnight notes lane (notes3, 2026-11-05): the spoiler audit and the next
-- names the prose used with no note. A reader who has done no quest must not meet a
-- guarded fact in any public note (body or title); each secret returns once the
-- exact quest that tells it is known. Ordinary given names never link on their own,
-- and neither does a name the user's own characters or listed players carry.
local root = "Interface/AddOns/CompanionJournal/"
local A = {People = {}, db = {sentinel = "unchanged"}}
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end
local function Load(name) assert(loadfile(root .. name))("CompanionJournal", A) end
Load("LoreData.lua"); Load("Lore.lua")
Load("LoreAllianceStories.lua"); Load("LoreHordeStories.lua"); Load("LoreWorldStories.lua"); Load("LoreClassStories.lua")
if io.open(root .. "LoreForeverStories.lua") then Load("LoreForeverStories.lua") end
Load("LoreNotes.lua")
Load("LoreDiscovery.lua"); Load("LoreDiscoveryData.lua")
Load("LorePlaces.lua"); Load("LorePeopleHistory.lua"); Load("LoreWorldConnections.lua")

-- 1. Guarded facts never appear in a public note. Each rule: the body or title
-- contains one of the first terms and (when given) one of the second terms.
local guards = {
    {"Athrikus alive / cult master", {"Athrikus"}, {"still lives", "leads the Cult", "master is", "soulgem"}},
    {"Blightcaller is Nathanos Marris", {"Blightcaller"}, {"Marris", "mortal life", "ranger lord"}},
    {"the Baron's head", {"Othmar"}},
    {"Prestor is Onyxia", {"Prestor", "Katrana"}, {"Onyxia", "disguise"}},
    {"Bolvar controlled", {"Bolvar"}, {"medallion", "under her control", "held his mind"}},
    {"Windsor's fate", {"Windsor"}, {"mortally", "sacrifice", "dies", "died"}},
    {"Dathrohan is Balnazzar", {"Dathrohan", "Grand Crusader"}, {"Balnazzar", "dreadlord"}},
    {"Moira's marriage", {"Moira"}, {"Thaurissan her husband", "her husband Thaurissan", "unborn", "her child", "inherit Ironforge"}},
    {"Teronis dead", {"Teronis"}, {"the fallen Teronis", "His body", "his body", "cut down", "Teronis is dead", "Teronis died"}},
    {"Heglan dead", {"Heglan"}, {"body", "dead", "naga", "killed"}},
    {"Malah dead", {"Malah"}, {"dead", "arrows", "body"}},
    {"Raschal found", {"Raschal"}, {"pod", "wreck", "sealed alive", "freed", "trail"}},
    {"Lescovar's assassin", {"Lescovar"}, {"Marzon", "Maelik", "Defias", "assassin"}},
    {"Lorthuna's flight", {"Lorthuna"}, {"Rohashi", "watchtower", "portal"}},
    {"Neeru leads the Burning Blade", {"Neeru"}, {"Burning Blade's leader", "true loyalty", "traitor"}},
    {"Yeh'kinya's deception", {"Yeh'kinya"}, {"decept", "admits", "led astray", "supposed", "helped bring him back", "concealed"}},
    {"Taelan's death", {"Taelan"}, {"Isillien", "kills him", "puppet", "final stand", "reborn"}},
    {"Tirion as Highlord", {"Tirion"}, {"declares the Silver Hand reborn", "Highlord of the renewed"}},
    {"Agmond dead", {"Agmond"}, {"death", "dead", "remains", "body"}},
    {"Maur dead", {"Maur dies", "Maur's beaten body"}},
    {"Mankrik's wife dead", {"Mankrik"}, {"body", "dead warrior"}},
    {"Sarah Ladimore lives", {"Sarah"}, {"survived", "lives"}},
    {"Abercrombie is the Embalmer", {"Abercrombie"}, {"Embalmer", "Stitches"}},
    {"Renault murdered his father", {"Renault"}, {"murder", "betray", "struck his father", "kills him", "kills his"}},
    {"Finkle inside the Beast", {"Finkle"}, {"alive", "surviv", "skinn", "swallowed"}},
    {"the Morrow Stone", {"Morrow Stone"}},
    {"the king's abduction", {"kidnapping of Stormwind's king", "captive is Stormwind's king", "abduction of Stormwind's king",
        "king's ship", "royal ship", "the missing traveler was the king", "the king himself"}},
    {"Hendel captured", {"Hendel"}, {"subdued", "capture", "questioning", "violence"}},
    {"Redpath's corruption", {"Redpath"}, {"corrupt", "betray", "treachery", "tormented", "saved"}},
    {"Rustlocke dead", {"Rustlocke"}, {"died", "body", "dead", "corpse"}},
    {"Paval Reethe's fate", {"Reethe"}, {"desert", "missing", "arrow", "threw him out", "expelled", "badge"}},
    {"Gerrig's order", {"Gerrig"}, {"Twilight's Hammer", "the Lady", "brothers", "dwellers beneath", "Yagyin"}},
    {"Bel'dugur's order", {"Bel'dugur", "the Keeper"}, {"Yagyin", "order that Theldurin"}},
    {"Myzrael's nature", {"Myzrael"}, {"is free", "endanger", "menace", "Twilight's Hammer", "bound again", "serve her", "struggle against her guardians"}},
    {"Thule and the Rot Hides' ichor", {"Thule"}, {"ichor", "leads the Rot Hides", "leads them"}},
    {"Xandivious", {"Xandivious"}},
    {"the egg's true purpose", {"ancient egg", "Egg of Hakkar"}, {"rebirth", "new birth", "born again"}},
    {"Jitters and the Dark Riders", {"Jitters"}, {"Dark Riders"}},
    {"Velinde's death", {"Velinde's specter", "Velinde's spirit"}},
    {"Velinde's fate", {"Velinde"}, {"specter", "her spirit"}},
    {"Hammertoe dead", {"Hammertoe died"}},
}
-- Whole-word matching ("heir" is not "their"); a term ending in a letter may
-- still take a suffix only when the rule says so ("decept", "surviv", "skinn").
local stems = {decept = true, surviv = true, skinn = true, corrupt = true, betray = true, desert = true, capture = true}
local function Has(text, terms)
    for _, term in ipairs(terms) do
        local pattern = term:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
        if term:match("^%w") then pattern = "%f[%w]" .. pattern end
        if term:match("%w$") and not stems[term] then pattern = pattern .. "%f[%W]" end
        if text:find(pattern) then return term end
    end
end
local publicCount, leaks = 0, {}
for _, entry in ipairs(A.LoreNoteCatalog()) do
    if entry.kind ~= "Quest" then
        local public = A.GetKnownLoreNote(entry.id, {})
        if public then
            publicCount = publicCount + 1
            local text = public.title .. "\n" .. public.body
            for _, rule in ipairs(guards) do
                local first = Has(text, rule[2])
                local second = first and (not rule[3] or Has(text, rule[3]))
                count = count + 1
                if first and second then
                    leaks[#leaks + 1] = entry.id .. " tells a guarded fact: " .. rule[1] .. " (" .. first .. " + " .. tostring(second) .. ")"
                end
            end
        end
    end
end

Check(#leaks == 0, "public notes tell guarded facts:\n  " .. table.concat(leaks, "\n  "))

-- 2. Each audited note: public is safe, the fact returns with the exact quest.
local function Public(id) return A.GetKnownLoreNote(id, {}) end
local function Known(id, facts)
    local k = {}
    for _, f in ipairs(facts) do k[f] = true end
    return A.GetKnownLoreNote(id, k)
end
local reveals = {
    {"npc:nathanos", {"nathanos.champion"}, "Marris Stead"},
    {"npc:nathanos", {"nathanos.revealed"}, "Nathanos Marris"},
    {"npc:nathanos", {"nathanos.registry"}, "registry of his mortal life"},
    {"place:quellithien-lodge", {"nathanos.registry"}, "Nathanos Blightcaller"},
    {"place:satyrnaar", {"althalaxx.master"}, "Athrikus"},
    {"group:satyrs", {"althalaxx.master"}, "soulgems"},
    {"faction:grimtotem", {"maur.dead"}, "beaten body"},
    {"npc:tirion", {"taelan.fate"}, "Isillien"},
    {"npc:taelan", {"taelan.fate"}, "Isillien"},
    {"faction:silver-hand", {"taelan.fate"}, "reborn"},
    {"npc:renfray", {"renfray.painting"}, "Scarlet Bastion"},
    {"npc:yehkinya", {"yehkinya.deceit"}, "deception"},
    {"relic:ancient-egg", {"yehkinya.deceit"}, "new birth"},
    {"faction:stonevault", {"agmond.dead"}, "Murdaloc"},
    {"event:missing-diplomat", {"diplomat.king"}, "Varian Wrynn"},
    {"npc:private-hendel", {"diplomat.capture"}, "questioning"},
    {"event:darrowshire", {"redpath.corrupted"}, "treachery"},
    {"event:darrowshire", {"redpath.saved"}, "promise to come home"},
    {"npc:abercrombie", {"embalmer.revealed"}, "Embalmer"},
    {"npc:morladim", {"morladim.daughter"}, "Sarah"},
    {"npc:morladim", {"morladim.peace"}, "Archeus"},
    {"npc:mankrik", {"mankrik.wife"}, "his wife"},
    {"npc:finkle-einhorn", {"finkle.alive"}, "food dispenser"},
    {"npc:troyas", {"morrow.stone"}, "Morrow Stone"},
    {"npc:xylem", {"morphaz.shard"}, "grown"},
    {"place:thandol-span", {"rustlocke.dead"}, "Kam Deepfury"},
    {"faction:blue-dragonflight", {"drakefire_alliance_method"}, "enchanted scale"},
    {"npc:theldurin-the-lost", {"myzrael.free"}, "Twilight's Hammer"},
    {"npc:gerrig-bonegrip", {"gerrig.cult"}, "Twilight's Hammer"},
    {"npc:gerrig-bonegrip", {"myzrael.free"}, "Myzrael"},
    {"npc:beldugur", {"beldugur.cult"}, "Yagyin's Digest"},
    {"relic:star-xilyeh", {"yagyin.bargain"}, "Yagyin's Digest"},
    {"npc:myzrael", {"myzrael.free"}, "Zaruk"},
    {"npc:myzrael", {"myzrael.bound"}, "open menace"},
    {"npc:reethe", {"reethe.badge"}, "Shady Rest Inn"},
    {"npc:reethe", {"reethe.dead"}, "arrow wound"},
    {"faction:theramore-guard", {"reethe.identity"}, "Kul Tiras marine"},
    {"region:4475737477616c6c6f77204d61727368", {"reethe.badge"}, "Paval Reethe"},
    {"group:rot-hides", {"rothide.thule"}, "Thule Ravenclaw"},
    {"npc:thule", {"rothide.thule"}, "ichor"},
    {"npc:velinde", {"velinde.journal"}, "Scythe of Elune"},
    {"npc:velinde", {"velinde.fate"}, "specter"},
}
for _, r in ipairs(reveals) do
    local id, facts, phrase = r[1], r[2], r[3]
    Check(A.GetLoreNote(id), "note exists: " .. id)
    Check(not Public(id).body:find(phrase, 1, true), "public keeps it unsaid: " .. id .. " / " .. phrase)
    Check(Known(id, facts).body:find(phrase, 1, true), "told once known: " .. id .. " / " .. phrase)
end
-- The Horde's Marris Stead errands never tell the human past; the Reethe badge alone
-- tells nothing of his fate; one stage's fact does not unlock the next.
Check(not Known("npc:nathanos", {"nathanos.champion"}).body:find("Nathanos Marris", 1, true), "Horde errands keep the human past")
Check(not Known("npc:reethe", {"reethe.badge"}).body:find("arrow", 1, true), "the badge alone keeps Reethe's fate")
Check(not Known("npc:reethe", {"reethe.hiding"}).body:find("arrow", 1, true), "hiding is not dying")
Check(not Known("npc:private-hendel", {"diplomat.king"}).body:find("questioning", 1, true), "Slim's confession does not tell Hendel's capture")
Check(not Known("event:darrowshire", {"redpath.corrupted"}).body:find("come home", 1, true), "the annals do not tell the battle's end")
Check(not Known("npc:myzrael", {"myzrael.free"}).body:find("menace", 1, true), "freeing her does not tell her binding")
-- Public links never lead straight to a concealed identity.
for _, related in ipairs(Public("npc:nathanos").related) do Check(related ~= "npc:nathanos-marris" and related ~= "place:marris-stead", "public Nathanos links reveal nothing") end
for _, related in ipairs(Public("place:quellithien-lodge").related) do Check(related ~= "npc:nathanos", "public lodge does not link the Blightcaller") end
for _, related in ipairs(Public("group:satyrs").related) do Check(related ~= "npc:athrikus", "public satyrs do not link Athrikus") end
Check(Public("npc:nathanos").title == "Nathanos Blightcaller", "Nathanos keeps the public name")

-- 3. New notes: sourced, plain, names resolve.
local notes = {
    ["npc:gorzeeki"] = {"Gorzeeki Wildeyes", "Gorzeeki"}, ["npc:morzul"] = {"Mor'zul Bloodbringer", "Mor'zul"},
    ["npc:impsy"] = {"Impsy"}, ["npc:rethiel"] = {"Rethiel the Greenwarden", "Rethiel", "the Greenwarden"},
    ["npc:ormer"] = {"Ormer Ironbraid", "Ormer"}, ["npc:merrin"] = {"Merrin Rockweaver", "Merrin"},
    ["npc:bathrah"] = {"Bath'rah the Windwatcher", "Bath'rah"}, ["npc:mokthardin"] = {"Far Seer Mok'thardin", "Mok'thardin"},
    ["npc:torgan"] = {"Tor'gan"}, ["npc:erlgadin"] = {"Sir S. J. Erlgadin", "Sir Erlgadin", "Erlgadin"},
    ["npc:wizbang"] = {"Wizbang Cranktoggle", "Wizbang"}, ["npc:derrington"] = {"High Executor Derrington", "Derrington"},
    ["npc:vandis"] = {"Shadow Priestess Vandis", "Vandis"}, ["npc:darthalia"] = {"High Executor Darthalia", "Darthalia"},
    ["npc:krog"] = {"Krog"}, ["npc:nazeer"] = {"Nazeer Bloodpike"}, ["npc:remy"] = {"Remy Two Times"},
    ["group:rot-hides"] = {"Rot Hides", "the Rot Hides"}, ["npc:gerrig-bonegrip"] = {"Gerrig Bonegrip", "Gerrig"},
    ["npc:beldugur"] = {"Keeper Bel'dugur", "Bel'dugur"}, ["npc:reethe"] = {"Lieutenant Paval Reethe", "Paval Reethe", "Reethe"},
    ["npc:myzrael"] = {"Myzrael"},
    -- Batch 2.
    ["npc:velinde"] = {"Velinde Starsong", "Velinde"}, ["place:oracle-tree"] = {"Oracle Tree", "the Oracle Tree"},
    ["place:shadowvale"] = {"Shadowvale"}, ["group:tarnished"] = {"The Tarnished", "the Tarnished"}, ["npc:vrang"] = {"Vrang"},
    ["group:longwalkers"] = {"Longwalkers", "the Longwalkers"}, ["place:bleachmane-rock"] = {"Bleachmane Rock"},
    ["npc:thatog"] = {"Thatog"}, ["npc:migi"] = {"Migi"}, ["npc:borstan"] = {"Borstan", "Borstan's Firepit"},
    ["npc:pozzik"] = {"Pozzik"}, ["npc:razzeric"] = {"Razzeric"}, ["npc:lotwil"] = {"Lotwil Veriatus", "Lotwil"},
    ["npc:gwennyth"] = {"Gwennyth Bly'Leggonde", "Gwennyth"}, ["npc:menara"] = {"Menara Voidrender", "Menara"},
    ["npc:ridgewell"] = {"Count Remington Ridgewell", "Count Ridgewell"}, ["npc:wrenix"] = {"Wrenix the Wretched", "Wrenix"},
    ["npc:rynthariel"] = {"Rynthariel the Keymaster", "Rynthariel"}, ["npc:tonga"] = {"Tonga Runetotem", "Tonga"},
    ["npc:cyrus"] = {"Cyrus Therepentous"}, ["npc:fitzsimmons"] = {"Fitzsimmons"},
}
local total, aliases = 0, 0
for id, names in pairs(notes) do
    total = total + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    Check(note.setting == "Classic / Forever" or note.setting == "Forever", "timeline: " .. id)
    Check(table.concat(note.sources, "\n"):find("corpus_vanilla_quests.txt", 1, true), "primary source: " .. id)
    local bodies = {note.body}
    local public = Public(id)
    if public.body ~= note.body then bodies[#bodies + 1] = public.body end
    for _, body in ipairs(bodies) do
        Check(not body:find("{[pqn]:") and not body:find("|H", 1, true), "plain body: " .. id)
        Check(not body:lower():find("%f[%a]you%f[%A]") and not body:lower():find("%f[%a]your%f[%A]"), "no reader address: " .. id)
        Check(not body:find(":", 1, true) and not body:find("?", 1, true), "no colon or question: " .. id)
        for _, word in ipairs({"journal", "chronicle", "tale", "story", "chapter"}) do
            Check(not body:lower():find("%f[%a]" .. word .. "s?%f[%A]"), "no meta words: " .. id .. " / " .. word)
        end
    end
    for _, related in ipairs(note.related or {}) do
        local target = A.GetLoreNote(related)
        Check(target and target.kind ~= "Quest", "related note exists: " .. id .. " -> " .. related)
    end
    Check(A.LoreNoteResolve("p", note.title) == id, "title resolves: " .. id)
    for _, name in ipairs(names) do
        aliases = aliases + 1
        Check(A.LoreNoteResolve("p", name) == id, "name resolves: " .. name .. " -> " .. tostring(A.LoreNoteResolve("p", name)))
    end
end
-- Every related link of every audited or new policy note exists.
for _, entry in ipairs(A.LoreNoteCatalog()) do
    if entry.kind ~= "Quest" then
        local public = Public(entry.id)
        for _, related in ipairs(public and public.related or {}) do
            Check(A.GetLoreNote(related), "public related exists: " .. entry.id .. " -> " .. related)
        end
    end
end

-- 4. Linking. Distinctive new short forms link; ordinary given names stay plain;
-- quest titles that contain a new name stay plain.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Gorzeeki served Mor'zul; Impsy waited.", "{n:Gorzeeki} served {n:Mor'zul}; {n:Impsy} waited.")
Marks("Derrington sent word to Vandis and Darthalia.", "{n:Derrington} sent word to {n:Vandis} and {n:Darthalia}.")
Marks("Krog, Merrin, Remy and Nazeer waited.", "Krog, Merrin, Remy and Nazeer waited.")
Marks("Velinde, Pozzik and Razzeric met at Shadowvale.", "{n:Velinde}, {n:Pozzik} and {n:Razzeric} met at {p:Shadowvale}.")
Marks("Menara, Cyrus, Tonga, Thatog and Migi waited.", "Menara, Cyrus, Tonga, Thatog and Migi waited.")
for _, id in ipairs({"place:shadowvale", "group:tarnished", "npc:vrang", "group:longwalkers", "place:bleachmane-rock", "npc:thatog", "npc:migi", "npc:borstan"}) do
    Check(A.GetLoreNote(id).setting == "Forever", "Forever content is labelled: " .. id)
end
for _, title in ipairs({"Ormer's Revenge", "Mok'thardin's Enchantment", "Myzrael's Allies", "Questioning Reethe"}) do
    Marks("We completed " .. title .. ".", "We completed " .. title .. ".")
end
for _, name in ipairs({"Laird", "Calor", "Allister", "Windsor", "Herod", "Solomon", "Mikhail", "Gunther", "Alaric", "Jorgen"}) do
    Marks(name .. " waited.", name .. " waited.")
    Check(A.LoreNoteResolve("n", name), "still resolves by markup: " .. name)
end
Marks("Marshal Windsor and Magistrate Solomon waited.", "{n:Marshal Windsor} and {n:Magistrate Solomon} waited.")
-- The user's own characters and listed players never link to a namesake NPC.
A.db.characters = {["thrall-realm"] = {}}
A.db.people = {["tyrande-otherrealm"] = {name = "Tyrande-OtherRealm"}, ["ragnaros-realm"] = {npc = true}}
Marks("Thrall met Tyrande near Ragnaros.", "Thrall met Tyrande near {n:Ragnaros}.")
A.bookLinks = {tyrande = "tyrande-otherrealm"}
Marks("Thrall met Tyrande.", "Thrall met {n:Tyrande}.")
A.bookLinks = nil
Marks("Orgrim Doomhammer and Thrall's Horde.", "{n:Orgrim Doomhammer} and Thrall's {p:Horde}.")
A.db.characters, A.db.people = nil, nil
Marks("Thrall waited.", "{n:Thrall} waited.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes3Overnight: %d checks passed; %d public notes guarded against %d rules; %d new notes, %d names",
    count, publicCount, #guards, total, aliases))
