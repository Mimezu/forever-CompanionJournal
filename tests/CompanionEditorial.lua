-- Run from the client root with lua5.1. Editorial regressions through real renders.
local root="Interface/AddOns/CompanionJournal/"
function time() return 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,f in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua",
    "JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua"}) do
    assert(loadfile(root..f))("CompanionJournal",A)
end
local checks=0
local function check(v,m) checks=checks+1;assert(v,m) end
local BASE=os.time({year=2026,month=10,day=1,hour=18})
local function outing(p,day,zone,level,events,seconds)
    local t=BASE+day*86400
    p.journal[#p.journal+1]={k="group",t=t,e=t+(seconds or 2820),z=zone,pl=level,ol=level}
    for i,e in ipairs(events) do
        local ev={t=t+i*60,z=zone,pl=level,ol=level}
        for k,v in pairs(e) do ev[k]=v end
        p.journal[#p.journal+1]=ev
    end
end
local function person() return {name="Dahlia-Review",race="Scourge",class="MAGE",pronouns="they",bond="spouse",journal={}} end
local players={}
for i=1,300 do
    local p={name="Editorial"..i,race="Scourge",class="PRIEST",faction="Horde"}
    local _,key=A.JournalTellers.For(p);players[key]=players[key] or p
end
local function render(p,player,voice,brief,retell)
    p.retell=retell
    local ds=A.JournalBook(p)
    local stories=A.JournalTale.Tell(p,ds,voice,player,brief)
    local parts={}
    for _,d in ipairs(ds) do local s=stories[d.key];if s and s.text~="" then parts[#parts+1]=A.JournalPlain(s.text) end end
    return table.concat(parts,"\n\n")
end
local samples={}
for key,player in pairs(players) do for _,voice in ipairs({"we","you"}) do for _,brief in ipairs({false,true}) do for retell=0,7 do
    -- The collection is rated above this character's level. Its documented local
    -- purpose should still outrank generic difficulty phrasing, and not grant a totem.
    local p=person()
    outing(p,0,"Mulgore",1,{{k="quest",d="Call of Earth",qid=1519}})
    local out=render(p,player,voice,brief,retell)
    -- (2026-11-07, DESIGN §3.0: the companion book tells the pair's side, not the stage's exposition;
    -- the stage is still told, in its own words or by name, and difficulty never replaces it)
    check(A.QuestDeeds.Shows(out,1519),"curated stage lost to difficulty: "..out)
    check(not out:find("granted the earth totem",1,true),"early errand completed rite: "..out)
    check(not out:find("above your level",1,true) and not out:find("above our level",1,true),"metagame difficulty leaked: "..out)
    check(not out:find("husband",1,true) and not out:find("wife",1,true),"neutral spouse changed")
    check(out==render(p,player,voice,brief,retell),"retell unstable")
    if key=="chronicler" and voice=="we" and not brief and retell==0 then samples.purpose=out end

    -- An outing's duration says when the turn-in happened, not how long doing the
    -- quest took. This uncatalogued errand reaches alternate day-subject pools.
    local day=person()
    outing(day,0,"Durotar",5,{{k="quest",d="A Peon's Burden",qid=2161}})
    local plain=render(day,player,voice,brief,retell)
    check(not plain:find("A Peon's Burden took",1,true),"session duration attributed to single quest: "..plain)
    check(not plain:find("went to A Peon's Burden",1,true),"session duration attributed to single quest: "..plain)
    check(not plain:find("{%a+}"),"unresolved token: "..plain)
    if key=="chronicler" and voice=="we" and not brief and retell==0 then samples.duration=plain end
end end end end

-- A level gap is recorded data, not evidence that one person led the other.
for _,level in ipairs({1,30}) do
    local p=person();outing(p,0,"Silverpine Forest",15,{})
    p.journal[1].ol=level
    for _,player in pairs(players) do for retell=0,7 do
        local out=render(p,player,"you",false,retell)
        check(not out:find("led the way",1,true),"level invented leadership: "..out)
    end end
end
-- A measured 75-second exit cannot be narrated as within a minute.
local quick=person()
local t=BASE
quick.journal={{k="group",t=t,e=t+600,z="Silverpine Forest",pl=13,ol=13},
    {k="dungeon",d="Shadowfang Keep",z="Shadowfang Keep",t=t+60,pl=13,ol=13},
    {k="quest",d="Maps and Runes",z="Silverpine Forest",t=t+135,pl=13,ol=13}}
for _,player in pairs(players) do for retell=0,7 do
    local out=render(quick,player,"you",false,retell)
    check(not out:find("within a minute",1,true),"75 seconds called within a minute: "..out)
    check(out:find("a few minutes later",1,true),"short measured exit was not exercised: "..out)
    check(not out:find("{%a+}"),"dungeon token leak: "..out)
end end
print("CompanionEditorial: "..checks.." checks passed")
for _,key in ipairs({"purpose","duration"}) do print("\n"..key.."\n"..(samples[key] or "")) end
