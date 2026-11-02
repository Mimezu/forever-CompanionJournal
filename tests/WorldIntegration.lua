-- Integration/editorial review: run from client root with Lua 5.1.
-- Writes only the explicitly authorized review artifact, never SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A = {defaults = {colors = {}}}
local loaded = {}
for _, f in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua",
    "JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua","JournalSelfWords.lua","JournalSelfTale.lua"}) do
    local file = io.open(root .. f,"rb")
    if file then file:close(); assert(loadfile(root .. f))("CompanionJournal", A); loaded[#loaded+1] = f
    elseif f ~= "LoreClassStories.lua" then error("Missing " .. f) end
end
local checks, failures, report = 0, {}, {"COMPANION JOURNAL WORLD INTEGRATION AND EDITORIAL REVIEW", table.concat(loaded,", "),
    "Scope: actual SelfTale and JournalTale output, full and Highlights, deterministic retells, raw-history immutability, stage-sensitive consequences and retained beginnings.",
    "Source review: corpus_vanilla_quests.txt world entries and selected starter/class records; part1_corpus.txt custom Zephras records. This review does not establish exhaustive quest coverage or simulate the live WoW UI.",
    "Editorial reading: the following complete sample paragraphs were read for unsupported outcomes, local setting, continuity and repetition. Exact-ID early steps were compared with conservative historical title-only output.",
    "Review guardrails: an introduction cannot grant a later totem; collecting materials cannot complete a later demonstration; attunement cannot establish a raid victory; fresh race identity cannot invent first kills."}
local function check(ok, why)
    checks = checks + 1
    if not ok then failures[#failures+1] = why end
end
-- Neeru calls Taragaman the leader, but Thrall names Jergosh and Bazzalan.
-- A felguard kill alone cannot establish that the cult lost its leadership,
-- including alternate wording selected for the companion's version.
local taragaman = A.Lore.Boss("Taragaman the Hungerer")
for _, line in ipairs({taragaman.e, taragaman.after, unpack(taragaman.afterMore or {})}) do
    check(not line:find("master", 1, true) and not line:find("leader", 1, true),
        "Taragaman consequence must not assert the Searing Blade's leadership was eliminated")
end
local function encode(v)
    if type(v) ~= "table" then return type(v) .. ":" .. tostring(v) end
    local keys = {}; for k in pairs(v) do keys[#keys+1]=k end
    table.sort(keys,function(a,b) return tostring(a)<tostring(b) end)
    local parts={};for _,k in ipairs(keys) do parts[#parts+1]=encode(k).."="..encode(v[k]) end
    return "{"..table.concat(parts,";").."}"
end
local BASE = os.time({year=2026,month=10,day=1,hour=18})
local function add(p,day,zone,level,events,companion)
    local t=BASE+day*86400
    p.journal[#p.journal+1]={k=companion and "group" or "play",t=t,e=t+3600,z=zone,pl=level,ol=level}
    for i,e in ipairs(events or {}) do
        local v={t=t+i*120,z=zone,pl=level,ol=level}
        for k,x in pairs(e) do v[k]=x end
        p.journal[#p.journal+1]=v
    end
end
local function render(p, brief, retell, companion, player, voice)
    local days=A.JournalBook(p)
    local st
    if companion then p.retell=retell;st=A.JournalTale.Tell(p,days,voice or "we",player,brief)
    else st=A.SelfTale.Tell(p,days,brief,retell) end
    local chunks={}
    for _,d in ipairs(days) do
        local s=st[d.key]
        if s and s.text~="" then chunks[#chunks+1]=A.JournalPlain(s.text) end
    end
    return table.concat(chunks,"\n\n"), days
end
local starts={
    {"Tauren","SHAMAN","Horde","Mulgore", "The Hunt Begins",747},
    {"Orc","WARRIOR","Horde","Durotar", "Your Place in the World",4641},
    {"Troll","HUNTER","Horde","Durotar", "Your Place in the World",4641},
    {"Scourge","PRIEST","Horde","Tirisfal Glades", "Rude Awakening",363},
    {"Human","PALADIN","Alliance","Elwynn Forest", "A Threat Within",783},
    {"Dwarf","SHAMAN","Alliance","Dun Morogh", "Dwarven Outfitters",179},
    {"Gnome","MAGE","Alliance","Dun Morogh", "Coldridge Valley Mail Delivery",233},
    {"NightElf","DRUID","Alliance","Teldrassil", "The Balance of Nature",456},
    {"SkyElf","SHAMAN","Horde","Zephras Isle", "Coming of Age",92460},
}
local invented={"my first hunt was for plainstriders","my first task was to drive the kobolds","my first task in the valley of trials was to thin out", "grells were my first foes"}
for _,s in ipairs(starts) do
    local p={self=true,name=s[1].."Review",charKey=s[1],race=s[1],class=s[2],faction=s[3],startLevel=1,journal={}}
    add(p,0,s[4],1,{{k="quest",d=s[5],qid=s[6]}})
    local journal=encode(p.journal)
    for _,brief in ipairs({false,true}) do
        for retell=0,7 do
            local out=render(p,brief,retell)
            check(out~="",s[1].." empty first page")
            check(not out:find("{%a+}"),s[1].." unresolved markup")
            check(out==render(p,brief,retell),s[1].." unstable retell")
            if s[2]=="SHAMAN" then
                check(not out:lower():find("granted the earth totem",1,true),s[1].." first errands awarded unrecorded totem")
            end
            if retell==0 then report[#report+1]="\nBEGINNING "..s[1]..(brief and " HIGHLIGHTS" or " FULL").."\n"..out end
        end
    end
    check(encode(p.journal)==journal,s[1].." raw journal changed")
    -- Level/race alone must not generate a completed first hunt or class rite.
    local sparse={self=true,name=s[1].."Sparse",charKey=s[1].."sparse",race=s[1],class=s[2],faction=s[3],startLevel=1,journal={}}
    add(sparse,0,s[4],1,{})
    for retell=0,15 do
        local out=render(sparse,false,retell)
        for _,bad in ipairs(invented) do check(not out:lower():find(bad,1,true),"UNRECORDED ORIGIN "..s[1].." retell "..retell..": "..out) end
        if retell==0 then report[#report+1]="\nSPARSE "..s[1].."\n"..out end
    end
    -- Companion setting: origin is explicit, the one shared errand is recorded.
    local c={name="Companion-Review",race=s[1],class=s[2],pronouns="they",bond="friend",origin="together",journal={}}
    add(c,0,s[4],1,{{k="quest",d=s[5],qid=s[6]}},true)
    local before=encode(c.journal)
    for _,brief in ipairs({false,true}) do for _,voice in ipairs({"we","you"}) do for retell=0,3 do
        local out=render(c,brief,retell,true,p,voice)
        check(out~="",s[1].." companion empty")
        check(out==render(c,brief,retell,true,p,voice),s[1].." companion unstable")
        check(not out:find("{%a+}"),s[1].." companion token leak")
        if retell==0 and voice=="we" and not brief then report[#report+1]="\nCOMPANION "..s[1].."\n"..out end
    end end end
    check(encode(c.journal)==before,s[1].." companion journal changed")
end

-- Real rendering of only the early stage: later consequences may not leak from
-- identical titles, whether the historical record has an ID or only a title.
local stages={
    {"Call of Earth",1519,"Mulgore",4,"SHAMAN",{"granted the earth totem","earned the earth totem"}},
    {"Call of Fire",1522,"The Barrens",10,"SHAMAN",{"granted the fire totem","earned the fire totem"}},
    {"Call of Water",1528,"The Barrens",20,"SHAMAN",{"granted the water totem","earned the water totem"}},
    {"The Sacred Flame",1195,"Ashenvale",25,"WARRIOR",{"cloven hoof reached rau","relic was recovered"}},
    {"Are We There, Yeti?",3783,"Winterspring",56,"WARRIOR",{"three demonstrations were completed"}},
    {"Seal of Ascension",4742,"Blackrock Spire",60,"WARRIOR",{"seal of ascension was finished","seal was complete"}},
    {"Of Love and Family",5846,"Western Plaguelands",58,"WARRIOR",{"portrait was returned to tirion"}},
    {"Crown of the Earth",921,"Teldrassil",5,"DRUID",{"tyrande accepted","reached tyrande"}},
    {"Bashal'Aran",954,"Darkshore",12,"DRUID",{"destruction freed the prisoner","no longer bound"}},
}
for _,s in ipairs(stages) do for _,withID in ipairs({true,false}) do
    local p={self=true,name="StageReview",charKey="stage",race="Tauren",class=s[5],faction="Horde",startLevel=s[4],journal={}}
    add(p,0,s[3],s[4],{{k="quest",d=s[1],qid=withID and s[2] or nil}})
    for _,brief in ipairs({false,true}) do for retell=0,7 do
        local out=render(p,brief,retell)
        for _,bad in ipairs(s[6]) do check(not out:lower():find(bad,1,true),"STAGE LEAK "..s[1].." "..tostring(withID).." "..out) end
        if retell==0 and not brief then report[#report+1]="\nSTAGE "..s[1].." ID "..tostring(withID and s[2] or "historical").."\n"..out end
    end end
    local c={name="StageCompanion",race="Tauren",class=s[5],pronouns="they",bond="friend",journal={}}
    add(c,0,s[3],s[4],{{k="quest",d=s[1],qid=withID and s[2] or nil}},true)
    for _,brief in ipairs({false,true}) do for _,voice in ipairs({"we","you"}) do for retell=0,3 do
        local out=render(c,brief,retell,true,p,voice)
        for _,bad in ipairs(s[6]) do check(not out:lower():find(bad,1,true),"COMPANION STAGE LEAK "..s[1].." "..out) end
    end end end
end end

-- Sustained world journey, beginning retained alongside the late work.
local travel={747,1519,1520,1521,1093,1918,1195,1196,1197,1368,7044,2862,2902,3881,4284,10,8277,8284,8279,3783,977,5163,4421,5155,1424,1446,4296,7487,7761,5142,5149,5721}
local p={self=true,name="JourneyReview",charKey="journey",race="Tauren",class="SHAMAN",faction="Horde",startLevel=1,journal={}}
for day,id in ipairs(travel) do
    local q=assert(A.Lore.questStoryIDs[id],"missing travel ID "..id)
    add(p,day-1,q.zone,q.level,{{k="quest",d=q.title,qid=id}})
end
local before=encode(p.journal)
for _,brief in ipairs({false,true}) do for retell=0,3 do
    local out=render(p,brief,retell)
    check(out:find("Narache",1,true),"late journey erased Narache")
    check(out:find("Darrowshire",1,true),"late journey erased final region")
    check(not out:find("a part in the Twilight's Hammer in Silithus",1,true),"opposing the cult rendered as cult participation")
    check(not out:find("a part in the corruption of Felwood",1,true),"cleansing Felwood rendered as spreading corruption")
    check(out==render(p,brief,retell),"world journey unstable")
    if retell==0 then report[#report+1]="\nWORLD JOURNEY "..(brief and "HIGHLIGHTS" or "FULL").."\n"..out end
end end
check(before==encode(p.journal),"world journey mutated raw events")
for id,v in pairs(A.Lore.questStoryIDs) do
    check(v.threadLabel==A.Lore.storyThreads[v.thread],"inherited thread label "..id)
    -- Only class content should explicitly suppress a separately captured milestone.
    if v.pack=="world_journeys" or v.pack=="horde-and-zephras" or v.pack=="alliance-starters" or v.pack=="class-stories" then
        check(not v.covers,"unreviewed inherited milestone suppression "..id.." "..tostring(v.covers))
    end
end
report[#report+1]="\nCHECKS "..checks.."; FAILURES "..#failures
for _,f in ipairs(failures) do report[#report+1]=f end
local file=assert(io.open("StorageInvestigation/cj-story-ui-checks/world-editorial-review.txt","wb"))
file:write(table.concat(report,"\n"));file:close()
print("WorldIntegration: "..checks.." checks; "..#failures.." failures. Review: StorageInvestigation/cj-story-ui-checks/world-editorial-review.txt")
for i=1,math.min(8,#failures) do print(failures[i]) end
if #failures>0 then os.exit(1) end
