local _, A = ...
-- A reference note is world context, never a new journal event. No saved state,
-- completion text, or inferred encounter is created by resolving/opening one.
local entries, aliases, loadedPacks = {}, {p = {}, n = {}, q = {}}, {}
-- These quests share most of their titles with a book or relic. Protect the full
-- quest phrase before matching the shorter reference title; explicit markup
-- still resolves either identity through its own channel.
local knownNames, knownNameOrder, knownNameBuckets = {
    ["The Charge of the Dragonflights"] = {plain = true},
    ["The Scepter of Celebras"] = {plain = true},
    ["Blackhand's Command"] = {plain = true},
    -- 2026-11-05: quest titles that contain a newly linked name, and two
    -- places that share a prefix with one. They stay plain text.
    ["A Study of the Light"] = {plain = true}, ["Agamaggan's Agility"] = {plain = true},
    ["Agamaggan's Strength"] = {plain = true}, ["Bartleby the Drunk"] = {plain = true},
    ["Bartleby's Mug"] = {plain = true}, ["Beat Bartleby"] = {plain = true},
    ["Blood Shards of Agamaggan"] = {plain = true}, ["Bring the Light"] = {plain = true},
    ["Cenarius' Legacy"] = {plain = true}, ["Crest of Lordaeron"] = {plain = true},
    ["Denalan's Earth"] = {plain = true}, ["Elune's Blessing"] = {plain = true},
    ["Elune's Candle"] = {plain = true}, ["Elune's Grace"] = {plain = true},
    ["Elune's Tear"] = {plain = true}, ["Exorcising Terrordale"] = {plain = true},
    ["Eyes of the Sentinels"] = {plain = true}, ["Favored of Elune"] = {plain = true},
    ["Galgar's Cactus Apple Surprise"] = {plain = true}, ["Garments of the Light"] = {plain = true},
    ["Gerenzo's Orders"] = {plain = true}, ["Holy Bologna: What the Light Won't Tell You"] = {plain = true},
    ["In Favor of Elune"] = {plain = true}, ["In Favor of the Light"] = {plain = true},
    ["In the Name of the Light"] = {plain = true}, ["Iverron's Antidote"] = {plain = true},
    ["Kurzen's Mystery"] = {plain = true}, ["Lordaeron Throne Room"] = {plain = true},
    ["Naga at the Zoram Strand"] = {plain = true}, ["Prayer to Elune"] = {plain = true},
    ["Raene's Cleansing"] = {plain = true}, ["Rediscovering the Light"] = {plain = true},
    ["Report to Doren"] = {plain = true}, ["Report to Kadrak"] = {plain = true},
    ["Report to Orgnil"] = {plain = true}, ["Retribution of the Light"] = {plain = true},
    ["Return to Denalan"] = {plain = true}, ["Rites of the Earthmother"] = {plain = true},
    ["Stars of Elune"] = {plain = true}, ["Tenaron's Summons"] = {plain = true},
    ["The Branch of Cenarius"] = {plain = true}, ["The Fall of Ameth'Aran"] = {plain = true},
    ["The Fate of the Den"] = {plain = true}, ["The Sisterhood of Elune"] = {plain = true},
    ["Ukor's Lost Pack"] = {plain = true}, ["Veteran Uzzek"] = {plain = true},
    ["WANTED: Gath'Ilzogg"] = {plain = true}, ["Wildkin of Elune"] = {plain = true},
    ["Wisdom of Agamaggan"] = {plain = true}, ["Stonewatch Falls"] = {plain = true},
    ["Gordo's Task"] = {plain = true}, ["Mountaineer Stormpike's Task"] = {plain = true},
    ["Valanaar Vintages"] = {plain = true}, ["Welcome to Shen'dar Village"] = {plain = true},
    ["Return to Valanaar"] = {plain = true}, ["To Valanaar"] = {plain = true},
    -- notes2 2026-11-05: quest titles that contain a newly linked name.
    ["Tharnariun's Hope"] = {plain = true}, ["The Tower of Althalaxx"] = {plain = true},
    ["The Master's Glaive"] = {plain = true},
    ["Solomon's Law"] = {plain = true}, ["Onu is Meditating"] = {plain = true},
    ["Return to Onu"] = {plain = true}, ["Wand to Bethor"] = {plain = true},
    ["Gann's Reclamation"] = {plain = true}, ["Revenge of Gann"] = {plain = true},
    ["Overlord Mok'Morokk's Concern"] = {plain = true}, ["Wait for Sirra to Finish"] = {plain = true},
    ["Speak with Renferrel"] = {plain = true}, ["Leonid's Letter"] = {plain = true},
    ["Cairne's Hoofprint"] = {plain = true}, ["Noggle's Last Hope"] = {plain = true},
    ["Noggle's Lost Satchel"] = {plain = true}, ["Agent of Hydraxis"] = {plain = true},
    ["Return to Rorian"] = {plain = true}, ["Find Myranda"] = {plain = true},
    ["Malin's Request"] = {plain = true}, ["Arugal Must Die"] = {plain = true},
    ["Arugal's Folly"] = {plain = true}, ["Return to Quinn"] = {plain = true},
    ["Milly's Harvest"] = {plain = true}, ["Return to Kristoff"] = {plain = true},
    ["Little Pamela"] = {plain = true}, ["Pamela's Doll"] = {plain = true},
    ["Sister Pamela"] = {plain = true}, ["Delivery to Archmage Xylem"] = {plain = true},
    ["Xylem's Payment to Jediga"] = {plain = true}, ["Brother Carlin"] = {plain = true},
    ["Uncle Carlin"] = {plain = true}, ["Melor Sends Word"] = {plain = true},
    ["Reception from Tyrande"] = {plain = true}, ["Tyrande and Remulos"] = {plain = true},
    ["Vyletongue Corruption"] = {plain = true}, ["Marla's Last Wish"] = {plain = true},
    -- The SI:7 case title would otherwise link "The Blightcaller" before the reader
    -- has learned who he is.
    ["The Blightcaller Cometh"] = {plain = true},
    ["The Green Hills of Stranglethorn"] = {plain = true},
    -- Longer names that would otherwise link a short form to the wrong subject:
    -- a Forever fort, a Zephras region, two places and two leaders with no note yet.
    ["Skybreaker Bulwark"] = {plain = true}, ["Shen'dar Highlands"] = {plain = true},
    ["Stonemaul Ruins"] = {plain = true}, ["Winterfall Village"] = {plain = true},
    ["Gordunni Outpost"] = {plain = true}, ["High Chief Winterfall"] = {plain = true},
    ["Krueg Skullsplitter"] = {plain = true},
    ["Grimand's Armor"] = {plain = true}, ["Grimand's Finest Work"] = {plain = true},
    ["The Work of Grimand Elmore"] = {plain = true}, ["Return to Verner"] = {plain = true},
    ["Return to Milton"] = {plain = true}, ["Sully Balloo's Letter"] = {plain = true},
    ["Confront Lorthuna"] = {plain = true},
    ["Kalimdor Hold 'Em"] = {plain = true}, ["Kalimdor Hold 'em"] = {plain = true},
    ["Jonespyre's Request"] = {plain = true}, ["When Smokey Sings, I Get Violent"] = {plain = true},
    ["The Ruins of Kel'Theril"] = {plain = true}, ["Troubled Spirits of Kel'Theril"] = {plain = true},
    ["Sven's Revenge"] = {plain = true}, ["Sven's Camp"] = {plain = true},
    ["Return to Sven"] = {plain = true}, ["Deliveries to Sven"] = {plain = true},
    ["Trelane's Defenses"] = {plain = true}, ["Vimes's Report"] = {plain = true},
    ["Kim'jael Indeed!"] = {plain = true}, ["The Bait for Lar'korwi"] = {plain = true},
    ["The Fare of Lar'korwi"] = {plain = true}, ["The Scent of Lar'korwi"] = {plain = true},
    ["Senir's Observations"] = {plain = true}, ["Return to Bellowfiz"] = {plain = true},
    ["Rejold's New Brew"] = {plain = true}, ["Tundra MacGrann's Stolen Stash"] = {plain = true},
    ["Return to Brock"] = {plain = true},
    ["Delivery to Magatha"] = {plain = true}, ["Magatha's Payment to Jediga"] = {plain = true},
    ["The Karnitol Shipwreck"] = {plain = true}, ["Helcular's Revenge"] = {plain = true},
    ["Farren's Proof"] = {plain = true}, ["Jarl Needs Eyes"] = {plain = true},
    ["Jarl Needs a Blade"] = {plain = true}, ["The Crown of Will"] = {plain = true},
    ["Dalar's Analysis"] = {plain = true},
}, nil, nil
-- Deliberately reviewed one-word identities. Common nouns and short personal
-- aliases still require explicit markup; "Weaver" must not turn prose into a boss.
local singleNames = {Thrall=true, Onyxia=true, Nefarian=true, Ragnaros=true, Varimathras=true, Doomhammer=true,
    Ashbringer=true, Frostmourne=true, Sulfuras=true, ["Quel'dorei"]=true,
    Mikhail=true, Stalvan=true, Atiesh=true, ["Quel'Serrar"]=true, ["Rhok'delar"]=true,
    Antonidas=true, Khadgar=true, Ironaya=true, Archaedas=true, Ravenholdt=true, Durnholde=true,
    Arthas=true, Sylvanas=true, ["Kel'Thuzad"]=true, ["C'Thun"]=true,
    Horde=true, Alliance=true, Forsaken=true, Scourge=true, Defias=true,
    Gurubashi=true, Zandalar=true, Timbermaw=true,
    -- 2026-11-05: distinctive one-word titles the story prose uses unmarked.
    -- Each note is public (no discovery policy); ordinary words stay out.
    Hakkar=true, ["Atal'ai"]=true, Deathstalkers=true, Lethtendris=true, Naralex=true,
    Alaric=true, Tarindrella=true, Margoz=true, Herod=true, Vectus=true, Zaetar=true,
    Thoradin=true, Pusillin=true, ["Immol'thar"]=true, Hydrospawn=true, ["Gar'Thok"]=true,
    Baelog=true, Zolo=true, Zerillis=true, Viscidus=true, ["Vile'rel"]=true, Verek=true,
    ["Tsu'zee"]=true, Theldren=true, Thaddius=true, Techbot=true, Stonespine=true,
    Stalagg=true, Revanchion=true, Renataki=true, ["Rath'mael"]=true, Ragglesnout=true,
    Pimgib=true, Ouro=true, Ohgan=true, Mushgog=true, Mijan=true, Maexxna=true,
    Loatheb=true, Kormok=true, Ironspine=true, Hukku=true, Ilthalaine=true, Tenaron=true,
    -- Distinctive short forms of reviewed titles, as the quest prose uses them.
    Sevren=true, Zygand=true, Johaan=true, Hadrec=true, Dughan=true, Orgnil=true,
    Zarlman=true, Ravenfeather=true, Graytongue=true, Arren=true, Linnea=true,
    Doren=true, Kurzen=true, Raene=true, Stonewatch=true, Elreth=true, Dirania=true,
    Tallonkai=true, Rellian=true, Gryshka=true, Gerenzo=true, Remtravel=true, Marris=true,
    -- notes2 2026-11-05: short forms the new prose uses, each checked for a
    -- second bearer in the catalogue and the corpus. Athrikus has a discovery policy.
    -- Common given names a player or companion could carry (Sven, Pamela, Quinn, Aurora,
    -- Holt, Brock, Milly, Janice, Kristoff...) stay out: the book owner's own name is never in A.bookLinks, so
    -- it would link to the NPC in that person's own book.
    Balthule=true, Delgren=true, Hollee=true, Greywhisker=true, Tharnariun=true,
    Gilshalan=true, Athridas=true, Gaerolas=true, Athrikus=true,
    -- Short forms of existing notes that the packs use unlinked most often. Left
    -- out on purpose: Maxwell (Marshal Maxwell and Lord Maxwell Tyrosus), Maur (Grimtotem
    -- and Raincaller), Natalia and Mar'alith, Coleman, Brine, Telf, Joseph, Parker, Hemet,
    -- Stormpike, Alterac, Arathi and Grimtotem (several bearers each), species names,
    -- and Baine (tests/LoreNameDepth.lua keeps it plain).
    Volcor=true, Solomon=true, Bolvar=true, Windsor=true, Onu=true, Allister=true, Torwa=true,
    Bethor=true, Gann=true, ["Mok'Morokk"]=true, Gunther=true, Sirra=true, VanCleef=true,
    Magni=true, Ayessa=true, Renferrel=true,
    Cairne=true, Stoutmantle=true, Aetheen=true, Noggle=true, Thredd=true,
    Jorn=true, Wenikee=true, Hydraxis=true, Betina=true, Rorian=true, Danitha=true, Rilli=true,
    McBride=true, Faranell=true, Sarvis=true, Myranda=true, Beetix=true, Eridan=true,
    Malah=true, Malin=true, Morin=true, Arugal=true, Heglan=true,
    Helendis=true, Farley=true, Tirion=true,
    Shandris=true, Renfray=true, Donova=true, Xylem=true, Neeru=true, Carlin=true,
    Taelan=true, Celebras=true, Melor=true, Zamah=true, Berard=true, Dizzywig=true,
    Spraggle=true, Thule=true, Thundris=true, Senani=true, Doan=true, Hendel=true,
    Larksbane=true, Tyrande=true, Bazzalan=true, Grimson=true, ["Jammal'an"]=true,
    Jergosh=true, Mordo=true, Noxxion=true, Theradras=true, Vyletongue=true, Dargol=true,
    Zureetha=true, Halaan=true, Mahren=true,
    Keeshan=true, Brann=true, Witherfang=true, Melenas=true, Ataeric=true, 
    Razorflank=true,
    ["Shen'dar"]=true, Tirisfal=true, Sepulcher=true, Razormane=true, Barrens=true,
    ["Un'Goro"]=true, Elwynn=true, Bulwark=true, Crossroads=true, Zephras=true, Deadmines=true,
    Narache=true, ["Al'Aketh"]=true, Windshapers=true, Silverpine=true, Stonemaul=true,
    Feathermoon=true, Redridge=true, Thendal=true, Bristleback=true, ["Sen'jin"]=true,
    Shadowhide=true, Galak=true, Agamands=true, Darkspear=true, Hillsbrad=true, Woodpaw=true,
    Highborne=true, Apothecarium=true, ["Ban'ethil"]=true, Firegut=true, Gordunni=true,
    Stockade=true, Hyjal=true, Frostmane=true, Deadwood=true, Bloodscalp=true, Pyrewood=true,
    Stranglethorn=true, Winterfall=true, Syndicate=true, Stonesplinter=true, Gelkis=true,
    Magram=true, ["Grom'gol"]=true, Skullsplitter=true, Smolderthorn=true, Waterlords=true,
    Stonetalon=true, Blackwing=true, ["Eldre'Thalas"]=true, Stormwind=true,
    -- notes2 batch 2. Lescovar and Maelik notes carry a discovery policy.
    Lescovar=true, Maelik=true, Grimand=true, Glorin=true, Verner=true,
    -- notes2 batch 3 (Lorthuna has a discovery policy; "Sprite" stays out, see Sprite Darter).
    Lorthuna=true, Valennia=true, Aonda=true, Illaya=true, Hanaa=true, Elegael=true,
    Aamelia=true, Aramis=true, Drohn=true,
    -- notes2 batch 4 (Raschal has a discovery policy).
    Pestlezugg=true, Fizzledowser=true, Zilzibin=true, Gracina=true, Ginro=true,
    Jonespyre=true, ["Kel'Theril"]=true, Trelane=true, Loramus=true, Paxton=true,
    Vimes=true,
    -- notes2 batch 5: Dun Morogh and Ironforge.
    Grelin=true, Senir=true, Redstone=true, Maxan=true, Bellowfiz=true,
    Rejold=true, Beldin=true, MacGrann=true, Golnir=true,
    -- notes2 batch 6: Thunder Bluff and Bloodhoof ("Ruul" stays out: two Ruuls).
    Magatha=true, Turak=true, Harken=true,
    -- notes2 batch 7.
    Maurin=true, Lydon=true,
    -- Short forms added to existing notes in the last pass.
    Dalar=true, Sergra=true, Fandral=true, Trias=true}
-- notes3 2026-11-05: ordinary given names and surnames a player or companion could
-- carry. They never link on their own, whether listed above or the one-word title
-- of an auto-linked note (Laird, Calor...); explicit markup and the longer names
-- ("Marshal Windsor", "Magistrate Solomon") still open the note.
local commonNames = {}
for name in ([[Alaric Allister Aramis Arren Bartleby Berard Betina Bjork Calor Carlin Darcy Doan Doren
    Eridan Farley Glorin Gordo Gunther Harken Hendel Herod Jorgen Jorn Kibler Laird Larion Linken Linnea
    Lydon Malin Maurin Melor Mikhail Morin Myranda Paxton Ringo Sneed Solomon Tabetha Thule Trelane
    Verner Vimes Windsor]]):gmatch("%S+") do
    commonNames[name] = true
    singleNames[name] = nil
end
-- notes3 batch 1: distinctive short forms of new notes (Myzrael, Reethe and
-- Bel'dugur carry discovery policies; Krog, Merrin, Remy, Nazeer and Gerrig stay plain).
for name in ([[Gorzeeki Mor'zul Impsy Rethiel Ormer Bath'rah Mok'thardin Tor'gan Erlgadin Wizbang
    Derrington Vandis Darthalia Myzrael Bel'dugur Reethe Velinde Pozzik Razzeric Lotwil Gwennyth Wrenix
    Rynthariel Ridgewell Fitzsimmons Shadowvale Windshaper]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 2026-11-06: distinctive short forms of new notes (Ordanus is also a quest title
-- naming the same keeper; Braelyn and Tammra stay out as ordinary-sounding given names).
for name in ([[Makaba Maggran Jin'Zil Ordanus Malaka'Jin Raynewood]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 batch 2 (Lakota, Burnside and Ironhill stay out: Lakota'mani, an English surname, a plausible player name).
for name in ([[Motega Pao'ka Wizlo Verringtan]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 batch 3 (Velene stays out: it could be a given name).
for name in ([[Pelturas Kayneth Sarilus Melyria]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 batch 4 (Kaela, Tara, Duriel, Mauren and Torek stay out: given names, a surname,
-- and a word that would open the raider inside the quest title "Torek's Assault").
for name in ([[Gaxim Vorsha Ertog Murgut Karang Lomac]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 batch 5 (Thorsen stays out: an ordinary surname).
for name in ([[Revilgaz Zanzil Ajeck Oglethorpe Talonaxe Kravel]]):gmatch("%S+") do singleNames[name] = true end
-- notes4 batch 6.
for name in ([[Islen Longbraid Hadoken Belgrom Nazz Fizzlebub Mukla Hinderweir]]):gmatch("%S+") do singleNames[name] = true end
-- notes5 2026-11-06: distinctive short forms of new notes (Greta, Aurel, Bijou, Katar,
-- Viktori and Rall stay out as words or given names; "Fizzle" and "Brassbolts" each name
-- two people).
for name in ([[Bilgewhizzle Marvon Lexlort Kalaran Maltrake Goldleaf Dithers Arbington Araj Valorfist
    Maleb Latronicus Strahad Kum'isha Razelikh]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"Marvon's Workshop", "Goldleaf's Discovery", "Araj's Scarab", "Seeking Strahad",
    "Kum'isha's Endeavors", "To Serve Kum'isha", "The Brassbolts Brothers"}) do
    knownNames[title] = {plain = true}
end
-- "Windshaper Boro" is a shaman trainer's title, not the Skyborne faction.
for _, title in ipairs({"Ormer's Revenge", "Mok'thardin's Enchantment", "Myzrael's Allies", "Questioning Reethe",
    "Windshaper Boro", "Velinde's Effects", "Wrenix of Ratchet", "Razzeric's Tweaking", "Delivery to Ridgewell",
    "In Search of Menara Voidrender", "Vrang's Game", "That Shadowvale Green Elixir"}) do
    knownNames[title] = {plain = true}
end
-- notes4: quest titles that hold a new note's name stay plain too (tests/LoreNotes4.lua).
for _, title in ipairs({"Jin'Zil's Forest Magic", "Letter to Jin'Zil", "Special Delivery for Gaxim", "The Howling Vale",
    "The Ruins of Stardust", "Trial at the Field of Giants", "Waters of Xavian", "Favor for Krazek", "Krazek's Cookery",
    "Parts for Kravel", "Rumors for Kravel", "Saving Sharpbeak", "Supplies to Private Thorsen", "The Touch of Zanzil",
    "Zanzil's Mixture and a Fool's Stout", "Zanzil's Secret", "Report Back to Fizzlebub"}) do
    knownNames[title] = {plain = true}
end
-- notes5 batch 2 (Marin, Goodsteel, MacKinley, O'Breen, Martek and Thornhoof stay out as
-- given names or surnames; "Torntusk" names both the Primal and the Elder).
for name in ([[Noggenfogger Krinkle Smotts Barnil Nimetz Yohwa Kryten Zardeth Furen Klockmort Fel'zerul
    Ryedol Karnik Goretooth Jarkal Lydros]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"Noggenfogger Elixir", "Delivery for Marin", "Sprinkle's Secret Ingredient", "Stoley's Debt",
    "Stoley's Shipment", "Deliver to MacKinley", "Return to MacKinley", "Klockmort's Essentials", "Return to Fel'Zerul",
    "Kidnapped Elder Torntusk!", "Return to Primal Torntusk"}) do
    knownNames[title] = {plain = true}
end
-- notes5 batch 3 (Arko, Kariel and Lightforge stay out: a short form a player could carry,
-- a given name, and the name of Trey's sword and of an iron).
for name in ([[Marduke Zverenhoff Huum Ortell Kirith Jessir Mayara Kromcrush Winthalus Hinott Failbane]]):gmatch("%S+") do
    singleNames[name] = true
end
for _, title in ipairs({"Ramaladni's Icy Grasp", "The Fate of Ramaladni", "Hinott's Assistance", "The Remains of Trey Lightforge",
    "Vivian Lagrave and the Darkstone Tablet", "Shards of the Felvine", "Cache of Mau'ari"}) do
    knownNames[title] = {plain = true}
end
-- notes5 batch 4.
for name in ([[Alzzin]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"The Human, Ras Frostwhisper", "The Dying, Ras Frostwhisper", "The Lich, Ras Frostwhisper"}) do
    knownNames[title] = {plain = true}
end
-- notes5 batch 5 (Phillipe and Agnar stay out as given names). The engineers' skeleton keys
-- are other objects than the key to Scholomance and stay plain.
for name in ([[Scorpidsting Cuergo Proudhorn Gilveradin Falfindel Wastewander Hatecrest Zukk'ash Shadowforge
    Reclaimers]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"WANTED: Caliph Scorpidsting", "Cuergo's Gold", "Scaring Shaky", "Facing Negolash",
    "Against the Hatecrest", "Zukk'ash Infestation", "Zukk'ash Report", "Reagents for Reclaimers Inc.",
    "Reclaimers' Business in Desolace", "Wastewander Justice", "More Wastewander Justice", "WANTED: Andre Firebeard",
    "Silver Skeleton Key", "Golden Skeleton Key", "Truesilver Skeleton Key", "Arcanite Skeleton Key"}) do
    knownNames[title] = {plain = true}
end
-- notes6 2026-11-06: distinctive short forms of new notes (Mai'Zoth and Vaelan carry
-- discovery policies; Jaron, Daltry, Biggs and Raleigh stay out as given names, surnames
-- or a name two men share). Kindal is the one Moonweaver of that name.
for name in ([[Mebok Smitts Niby Daio Vaelan Mai'Zoth Rau Nezzliok Gan'zulah Lethlor Emberstrife
    Kindal]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"What Niby Commands", "Speaking with Nezzliok", "Speaking with Gan'zulah",
    "Raleigh and the Undercity"}) do
    knownNames[title] = {plain = true}
end
-- notes6 batch 2 (Garithos, Walton and Blazerunner carry discovery policies; Othmar, Ott,
-- Walton, Jemma, Ozzie and Quentin stay out as given names or surnames).
for name in ([[Norric Byancie Yorana Elaadrin Yelmak Thra Thesten Belgrum Stoutfist Roetten Salfa Erelas
    Gnoarn Blazerunner Garithos]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"Yelmak's Medley", "Report to Captain Stoutfist", "Speak to Salfa", "Ott's Masterwork"}) do
    knownNames[title] = {plain = true}
end
-- notes6 batch 3 (Mulgris carries a discovery policy; Fiora, Veren, Laris, Ozzie, Mary and
-- Flint stay out as given names or words).
for name in ([[Ruzzgot Castpipe Kernobee Shoni Tsunaman Willix Feegly Tatternack Bellygrub Geardawdle
    Heralath Treshala Sparklematic Mulgris]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"Castpipe's Task", "Speak with Shoni", "The Sparklematic 5200!"}) do
    knownNames[title] = {plain = true}
end
-- notes6 batch 4 (Sigrun, Shay, Korin, Roon, Fin, Slim and Nials stay out: given names,
-- a word, and a name Lore Forever gives a second bearer).
for name in ([[Unbagwa Mokk Poobah Bloads Groy Or'Kalar Phizzlethorpe Draxlegauge Tosselwrench Tho'grun
    Rockbiter Luglunket]]):gmatch("%S+") do singleNames[name] = true end
for _, title in ipairs({"Whiskey Slim's Lost Grog"}) do knownNames[title] = {plain = true} end
-- notes6 batch 5 (Galen, Goodward, Andi, Gurda, Tooga and Torta stay out as given names,
-- a surname and short words; "Gurda" also names Gurda Ragescar).
for name in ([[Curgle Gor'marok Malcin Rimtori Ag'tor Zamael Aldamort Magtoor Lungertz Gizzmick Slagtree
    Fraggar Burninate]]):gmatch("%S+") do singleNames[name] = true end
-- notes6 batch 6 ("Security Chief Bilgewhizzle" now opens his own note; the short
-- "Bilgewhizzle" stays with the chief engineer of Gadgetzan, the only one the scenes call so).
for name in ([[Garek Gorn Blacklash Hematus Nafien Krakle Tinkee Albagorm Do'gol]]):gmatch("%S+") do
    singleNames[name] = true
end
for _, title in ipairs({"Speak to Nafien", "Return to Tinkee"}) do knownNames[title] = {plain = true} end
local V ="StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"
local Q = "StorageInvestigation/journal-voice/quests_corpus.txt"
local N = "StorageInvestigation/journal-voice/npc_corpus.txt"
local function Plain(value)
    if type(value) ~= "string" then return "" end
    return (value:gsub("{[pqn]:([^}]*)}", "%1"):gsub("|", ""):gsub("[%z\1-\8\11-\31]", ""))
end
local function Normalize(value)
    if type(value) ~= "string" then return nil end
    value = Plain(value):gsub("’", "'"):gsub("‘", "'"):gsub("%s+", " "):match("^%s*(.-)%s*$")
    if value == "" then return nil end
    return value:lower()
end
local function Encode(value)
    return (value:gsub(".", function(c) return string.format("%02x", c:byte()) end))
end
local function Alias(kind, value, id)
    local key = Normalize(value)
    if not key then return end
    local previous = aliases[kind][key]
    -- Ambiguous names remain unlinked. Never choose according to pairs() order.
    if previous ~= nil and previous ~= id then aliases[kind][key] = false
    else aliases[kind][key] = id end
end
local function Sources(value, fallback)
    local out = {}
    if type(value) == "string" then value = {value} end
    for _, source in ipairs(type(value) == "table" and value or fallback or {}) do
        if type(source) == "string" and source ~= "" then out[#out + 1] = source end
    end
    return out
end
local function Add(entry, names)
    if entries[entry.id] then return end
    entry.body = Plain(entry.body)
    if entry.body == "" or #entry.sources == 0 then return end
    entry.title = Plain(entry.title)
    entry.setting = entry.setting or "Classic / Forever"
    -- Keep the declared aliases in the catalogue as well as the resolver, so
    -- external audits can preserve them when replacing a regional summary.
    entry.names = names
    entries[entry.id] = entry
    local kind = entry.kind == "Quest" and "q" or "p"
    Alias(kind, entry.title, entry.id)
    if entry.kind == "Person" then Alias("n", entry.title, entry.id) end
    for _, name in ipairs(names or {}) do
        Alias(kind, name, entry.id)
        if entry.kind == "Person" then Alias("n", name, entry.id) end
    end
    if (entry.coverage == "curated" or entry.coverage == "regional") and entry.kind ~= "Quest" then
        local function Remember(name)
            -- A generic alias can remain available to an explicit lookup
            -- without turning ordinary prose into a link to this one object.
            for _, explicitName in ipairs(entry.explicitAliases or {}) do
                if name == explicitName then return end
            end
            local canonicalPlace = name == entry.title and
                (entry.kind == "Place" or entry.kind == "City" or entry.kind == "Region"
                    or entry.kind == "Dungeon" or entry.kind == "Raid")
            -- An explicitly registered spelling variant of an opted-in full title
            -- is safe too; arbitrary shortened aliases still do not inherit opt-in.
            if type(name) == "string" and not commonNames[name] and (name:match("%S+%s+%S+") or singleNames[name]
                or canonicalPlace or (entry.autoLink == true and Normalize(name) == Normalize(entry.title))) then
                knownNames[name] = {id = entry.id, kind = entry.kind == "Person" and "n" or "p"}
                knownNameOrder, knownNameBuckets = nil, nil
            end
        end
        Remember(entry.title)
        for _, name in ipairs(names or {}) do Remember(name) end
    end
end
local function Curated(id, title, kind, body, sources, names, related, setting, autoLink, explicitAliases)
    Add({id = id, title = title, kind = kind, body = body, sources = sources,
        related = related, setting = setting, autoLink = autoLink,
        explicitAliases = explicitAliases, coverage = "curated"}, names)
end

-- Reviewed short notes. Sources describe the setting; no completion passage is
-- presented as something this character did. Related entries are equally safe.
Curated("place:deathknell", "Deathknell", "Place",
    "Deathknell is a Forsaken village in western Tirisfal Glades, where undead newly freed from the Lich King's control enter the service of Sylvanas Windrunner. Freedom has not made the village safe. Its northern reaches are overrun by the Mindless Ones, undead who remain bound to the Scourge, and a Scarlet Crusade camp threatens from the southeast. Supplies must be scavenged from the abandoned buildings to equip further recruits.\n\nMordo, the crypt's caretaker, greets those who awaken there and sends them down the hill to the chapel. Shadow Priest Sarvis receives them and explains their new allegiance: the Forsaken are at war with the Scourge and with the humans who seek their destruction.",
    {V .. " #363 Rude Awakening; #3902 Scavenging Deathknell", "https://warcraft.wiki.gg/wiki/Deathknell (village identity and western Tirisfal location only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #363; #364; #381; #3902"}, nil,
    {"npc:mordo", "npc:sarvis", "place:tirisfal"})
Curated("place:tirisfal",
    "Tirisfal Glades",
    "Region",
    "Tirisfal Glades surrounded the ruins of Lordaeron's capital, with the Undercity beneath them serving as the seat of Sylvanas and the Forsaken. Farms and settlements survived as reminders of the human kingdom, but the land now held undead with very different allegiances.\n\nAt Deathknell, those who woke free of the Lich King's control were received by Mordo and Shadow Priest Sarvis. The road led onward to Brill, where Executor Zygand organized attacks on the Scarlet Crusade. The zealots were not the only danger: the Scourge still held ground in the glades, and freedom from its master did not mean safety from its servants.\n\nThe work at Brill also revealed the darker aims of the Forsaken. Apothecary Johaan gathered materials for a new plague intended to destroy Arthas's army. Between these experiments, the struggle against the Crusade, and service to the Undercity, the glades introduced a people building a second existence among the remains of their first.",
    {"https://warcraft.wiki.gg/wiki/Tirisfal_Glades_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #363 Rude Awakening; #367 A New Plague; #383 Vital Intelligence; #405 The Prodigal Lich"},
    {"Tirisfal"},
    {"place:deathknell", "place:brill", "place:undercity"},
    "Classic / Forever")
Curated("place:brill", "Brill", "Place",
    "Brill is a Forsaken town in central Tirisfal Glades, north of Lordaeron's ruined capital. Once a settlement of the human kingdom, it now serves undead who have broken free of the Lich King and follow Sylvanas Windrunner. The surrounding countryside remains contested: the Scourge holds nearby ground, while the Scarlet Crusade hunts the Forsaken as well as the undead still serving their former master.\n\nBrill is a center for the Forsaken response. Executor Zygand receives intelligence on the Crusade and directs attacks against it. Apothecary Johaan belongs to the Royal Apothecary Society, whose research pursues Sylvanas's demand for a new plague capable of destroying Arthas's army.",
    {V .. " #383 Vital Intelligence; #367 A New Plague", "https://warcraft.wiki.gg/wiki/Brill (opening geography and original-era identity only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #363; #367; #370; #381; #383; #426; #445"}, nil,
    {"place:tirisfal", "npc:zygand", "npc:johaan"})
Curated("place:undercity", "Undercity", "City",
    "The Undercity is the capital of the Forsaken, hidden beneath the ruins of Lordaeron's former human capital in Tirisfal Glades. Its inhabitants are undead who escaped the Lich King's control and follow Sylvanas Windrunner. After the Scourge devastated the city above, the undead began building a stronghold in the catacombs below. Sylvanas and her followers claimed that underground city and continued its construction, making a seat of their own power beneath the remains of the kingdom they had lost.\n\nThe capital sustains more than armies. Traders and craftsmen work alongside trainers of magic and arms, while bat routes carry people and supplies between the city and outposts such as the Sepulcher in Silverpine. Its Trade, Magic, War and Rogues' Quarters support the daily needs of the Forsaken and their visitors.\n\nSylvanas holds court here, and the city's apothecaries pursue her demand for a new plague. Master Apothecary Faranell receives poisonous specimens for this research, while the mage Bethor Iceshard seeks to recruit other undead who remain free of the Scourge. These separate efforts serve a people still fighting their former masters.",
    {Q .. " #95803 A Token of Good Faith; #357 The Lich's Identity; #94427 A Lesson in Divinity", "https://warcraft.wiki.gg/wiki/Undercity (opening, Legacy of the Damned and original World of Warcraft sections only)", "https://worldofwarcraft.blizzard.com/en-us/news/23149528 (WoW Classic City Tour: Undercity, 2019)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #363; #366; #367; #405; #447; #6321; #6322; #6323"}, {"The Undercity"},
    {"npc:sylvanas", "npc:tanis", "faction:undercity", "npc:faranell", "place:tirisfal", "place:sepulcher"})
Curated("npc:sylvanas",
    "Lady Sylvanas Windrunner",
    "Person",
    "Sylvanas Windrunner, the Banshee Queen, leads the Forsaken from the Undercity beneath Lordaeron's ruined capital. In life she was the ranger-general of Silvermoon and defended Quel'Thalas against Arthas's Scourge. Her resistance earned a cruel punishment: Arthas killed her and raised her as a banshee, forcing her to serve the army that had destroyed her people.\n\nWhen the Lich King's hold weakened, Sylvanas recovered her free will and gathered other undead who had escaped his control. Their struggle for Lordaeron gave the Forsaken a homeland and a ruler of their own. Their alliance with Thrall's Horde offers support in a world where the living often see little difference between them and the Scourge.\n\nHer vengeance remains directed at Arthas. Under her orders, the Royal Apothecary Society seeks a new plague powerful enough to ruin his army. For the Forsaken, freedom from one master's will has become a struggle to survive under the Dark Lady's command, against both the Scourge and the humans who hunt them.",
    {"https://warcraft.wiki.gg/wiki/Lady_Sylvanas_Windrunner", "https://warcraft.wiki.gg/wiki/Undercity_%28original%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 363, 1049: Rude Awakening; Compendium of the Fallen)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 367, 363: A New Plague; Rude Awakening)"},
    {"Sylvanas", "Sylvanas Windrunner", "Lady Sylvanas", "The Dark Lady", "The Banshee Queen", "the Dark Lady", "the Banshee Queen"},
    {"place:undercity", "faction:forsaken", "npc:arthas"},
    "Classic / Forever")
Curated("npc:sarvis", "Shadow Priest Sarvis", "Person",
    "Sarvis received the newly risen at Deathknell's chapel. His account explained the Forsaken's freedom from the Lich King and their allegiance to Sylvanas.",
    {V .. " #363 Rude Awakening"}, {"Sarvis"}, {"place:deathknell", "npc:sylvanas"})
Curated("npc:mordo", "Undertaker Mordo", "Person",
    "Mordo was the caretaker of Deathknell's crypt. He directed those who woke there to Shadow Priest Sarvis in the chapel below the hill.",
    {V .. " #363 Rude Awakening"}, {"Mordo"}, {"place:deathknell", "npc:sarvis"})
Curated("place:silverpine",
    "Silverpine Forest",
    "Region",
    "Silverpine Forest lies southwest of the Undercity, with the Sepulcher serving as a Forsaken base in a land they have not yet secured. Apothecaries exchange research there in pursuit of Sylvanas's new plague, while Dalar Dawnweaver studies Arugal's enchantments. The wizard remains in Shadowfang Keep, and his magic is one obstacle to the Forsaken claim on the forest.\n\nOther enemies hold ground of their own. The Scourge's Rot Hide gnolls carry stolen bodies into Silverpine, and Thule Ravenclaw commands a stronghold on Fenris Isle. At Ambermill, human resistance receives supplies and magical support from Dalaran. The Forsaken investigate those shipments and try to disrupt the spellwork. Silverpine's roads therefore connect several struggles: a campaign against the Scourge, the effort to break Arugal's power, and a contest with the humans who still resist the Dark Lady.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #445 Delivery to Silverpine Forest; #422 Arugal’s Folly; #1014 Arugal Must Die; #440 The Engraved Ring; #442 Assault on Fenris Isle; #477 Border Crossings; #479 Ambermill Investigations"},
    {"Silverpine"},
    {"place:sepulcher", "dungeon:shadowfang", "npc:dalar"},
    "Classic / Forever")
Curated("place:sepulcher", "The Sepulcher", "Place",
    "The Sepulcher is a graveyard and crypt in western Silverpine Forest that the Forsaken use as their base in the region. It supports their effort to secure a forest still troubled by the Scourge and by the worgen associated with Arugal, the wizard occupying Shadowfang Keep. Supplies arrive from the Undercity to replace weapons lost by the outpost's Deathguards.\n\nHigh Executor Hadrec directs operations from the Sepulcher, receiving scouts' reports and organizing action against enemies such as the Scourge commander Thule Ravenclaw on Fenris Isle. Dalar Dawnweaver, a Forsaken mage stationed there, investigates Arugal's enchantments in the hope of breaking his power over Silverpine.",
    {V .. " #421 Prove Your Worth; #442 Assault on Fenris Isle", "https://warcraft.wiki.gg/wiki/Sepulcher (opening and World of Warcraft history section only)", "https://classicdb.ch/?npc=1938 (Dalar's original NPC identity)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #442; #446; #449; #6321; #6322", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)"}, {"Sepulcher"},
    {"place:silverpine", "npc:dalar", "npc:hadrec", "dungeon:shadowfang"})
Curated("dungeon:shadowfang", "Shadowfang Keep", "Dungeon",
    "Shadowfang Keep is Arugal's fortress in southern Silverpine Forest, overlooking Pyrewood Village. The wizard's influence reaches beyond its walls: Pyrewood's people become worgen at night, and Moonrage creatures trouble the surrounding forest. The Forsaken regard his stronghold as an obstacle to making Silverpine their own.\n\nAt the Sepulcher, the Forsaken base farther north, Dalar Dawnweaver connects these troubles with Arugal's magic and investigates his spells and enchanted shackles. High Executor Hadrec prepares an assault on the keep, sending the Deathstalker scouts Adamant and Vincent ahead to gather intelligence. Their delayed report leaves the Forsaken uncertain of what awaits inside. Dalar ultimately calls for Arugal's death to end the wizard's hold on the forest.",
    {V .. " #421 Prove Your Worth; #1014 Arugal Must Die", "https://warcraft.wiki.gg/wiki/Shadowfang_Keep_%28Classic%29 (independent opening geography and original quest-giver table only; do not rederive the exhausted World Dungeons passage)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #423; #99; #1014; #1098"}, nil,
    {"place:silverpine", "place:pyrewood", "npc:arugal", "place:sepulcher"})
Curated("npc:arugal",
    "Archmage Arugal",
    "Person",
    "Arugal was a mage of Dalaran who tried to turn otherworldly worgen against the Scourge during the Third War. The creatures killed the undead, then turned on the wizards themselves. The disaster overtook the keep of Baron Silverlaine; overwhelmed by guilt, Arugal adopted the worgen as his children and withdrew into the fortress that became known as Shadowfang Keep.\n\nHis magic continued to trouble Silverpine Forest. At the Sepulcher, Dalar Dawnweaver blamed the archmage for the Moonrage worgen and sought to unravel his enchantments. The Forsaken eventually demanded Arugal's death, seeing his creatures and stronghold as obstacles to their hold over Silverpine. His attempt to save human lives had left the region facing another enemy.",
    {"https://warcraft.wiki.gg/wiki/Innkeeper", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 421, 422, 1014)"},
    {"Arugal"},
    {"dungeon:shadowfang", "place:silverpine", "npc:dalar"},
    "Classic / Forever")
Curated("npc:dalar", "Dalar Dawnweaver", "Person",
    "Dalar Dawnweaver worked at the Sepulcher. He sought to understand Arugal's enchantments and called for help against the Moonrage worgen.",
    {V .. " #421 Prove Your Worth; #422 Arugal's Folly"}, {"Dalar"}, {"place:sepulcher"})
Curated("place:bandarion", "Bandarion Keep", "Place",
    "A new order of risen paladins gathered at Bandarion Keep in Tirisfal. Their shared faith and service to the Forsaken shaped a community still seeking its place among its own people.",
    {Q .. " #91282 A Second Home", N .. " Danitha Morr and Leonid Barthalomew dialogue"}, nil,
    {"npc:danitha", "place:tirisfal"}, "Forever")
Curated("npc:danitha", "Danitha Morr", "Person",
    "Danitha helped build the paladin community at Bandarion Keep. In her discussion with Leonid Barthalomew, she defended remaining among the Forsaken and serving the people they had sworn to protect.",
    {N .. " Danitha Morr and Leonid Barthalomew dialogue", Q .. " #94441 A Lesson in Divinity"}, {"Danitha"},
    {"place:bandarion"}, "Forever")
Curated("place:tyrs-watch", "Tyr's Watch", "Place",
    "The paladins of Tyr's Watch offered aid to the Forsaken. Deathguard Billmuth sought help there against a threatened Scarlet Crusade attack.",
    {Q .. " A Lesson in Divinity, Deathguard Billmuth's request; #94441"}, nil,
    {"place:bandarion"}, "Forever")
Curated("npc:tanis", "Tanis Alderwood", "Person",
    "Tanis Alderwood was a beggar in the Undercity. The paladins' lesson in divinity placed helping someone in need alongside their other duties.",
    {Q .. " #94427 and #94434 A Lesson in Divinity"}, {"Tanis"}, {"place:undercity"}, "Forever")

-- Named places and people from captured quest dialogue. These are reference
-- facts, not proof of a visit, an encounter, or a completed quest chain.
Curated("place:fenris-isle", "Fenris Isle", "Place",
    "Fenris Isle lay across Lordamere Lake from the Decrepit Ferry. Rot Hide gnolls occupied the island, making it a Scourge stronghold within Silverpine.",
    {V .. " #438 The Decrepit Ferry; #442 Assault on Fenris Isle; #443 Rot Hide Ichor"}, nil,
    {"place:fenris-keep", "place:lordamere", "place:silverpine"})
Curated("place:fenris-keep", "Fenris Keep", "Place",
    "Fenris Keep was Thule Ravenclaw's stronghold. Its grounds held stables, while a dusty shelf concealed an alcove in the southwestern tower.",
    {V .. " #460 Resting in Pieces; #461 The Hidden Niche; #491 Wand to Bethor"}, nil,
    {"place:fenris-isle"})
Curated("place:lordamere", "Lordamere Lake", "Place",
    "Lordamere Lake separated the Decrepit Ferry from Fenris Isle. Apothecary Berard's studies concerned an ancient plague that had devastated the lake's aquatic life.",
    {V .. " #438 The Decrepit Ferry; #450 A Recipe For Death"}, {"Lake Lordamere"},
    {"place:fenris-isle", "place:decrepit-ferry"})
Curated("place:decrepit-ferry", "The Decrepit Ferry", "Place",
    "The ferry lay east of the Sepulcher, facing Fenris Isle across Lordamere Lake. Rot Hides and other undead patrolled the landing.",
    {V .. " #438 The Decrepit Ferry"}, {"Decrepit Ferry"}, {"place:lordamere", "place:sepulcher"})
Curated("place:pyrewood", "Pyrewood Village", "Place",
    "Pyrewood's inhabitants appeared human by day and became Moonrage worgen after sundown. Arugal's enchanted shackles bound the village to his magic.",
    {V .. " #99 Arugal's Folly"}, {"Pyrewood"}, {"place:silverpine", "dungeon:shadowfang"})
Curated("place:ambermill", "Ambermill", "Place",
    "Ambermill remained a center of human resistance in Silverpine, supported by Dalaran's wizards. Wagons brought supplies from Hillsbrad, drawing the attention of the Forsaken at the Sepulcher.",
    {V .. " #477 Border Crossings; #478 Maps and Runes"}, nil, {"place:silverpine", "place:sepulcher"})
Curated("place:deep-elem", "Deep Elem Mine", "Place",
    "Deep Elem Mine lay in the southeastern hills of Silverpine. Dalar Dawnweaver reported that Arugal's magic had reached its foreman, while the Forsaken coveted the mine's resources.",
    {V .. " #424 Arugal's Folly"}, {"the Deep Elem Mine"}, {"place:silverpine"})
Curated("place:dead-fields", "The Dead Fields", "Place",
    "The Dead Fields were an old farm in northern Silverpine occupied by Rot Hide gnolls. The banshee Nightlash reinforced them when Forsaken forces attacked.",
    {V .. " #437 The Dead Fields"}, {"Dead Fields"}, {"place:silverpine"})
Curated("place:skittering-dark", "The Skittering Dark", "Place",
    "Spiders in the Skittering Dark supplied venomous blood sought by Silverpine's apothecaries. Their research paired it with toxins derived from the forest's bears.",
    {V .. " #447 A Recipe For Death"}, {"Skittering Dark"}, {"place:silverpine"})
Curated("npc:hadrec", "High Executor Hadrec", "Person",
    "Hadrec directed Forsaken operations in Silverpine. Reports from the Deathstalkers and the apothecaries shaped his response to Scourge activity around Fenris Isle.",
    {V .. " #428 Lost Deathstalkers; #448 Report to Hadrec; #449 The Deathstalkers' Report"},
    {"Hadrec", "Executor Hadrec"}, {"place:sepulcher", "place:silverpine"})
Curated("npc:renferrel", "Apothecary Renferrel", "Person",
    "Renferrel worked outside the Sepulcher. His alchemy served both the injured Deathstalkers and the investigation into the unnatural ichor sustaining the Rot Hide gnolls.",
    {V .. " #429 Wild Hearts; #443 Rot Hide Ichor; #444 Rot Hide Origins"}, {"Renferrel"}, {"place:sepulcher"})
Curated("npc:thule", "Thule Ravenclaw", "Person",
    "Thule had studied magic alongside Bethor Iceshard before joining the Scourge. His stronghold was on Fenris Isle, and Bethor recognized his spellcraft in the Rot Hides' ichor.",
    {V .. " #446 Thule Ravenclaw"}, {"Thule"}, {"place:fenris-isle", "place:fenris-keep"})
Curated("npc:bethor", "Bethor Iceshard", "Person",
    "Bethor studied magic in the Undercity's Magic Quarter. He had known Gunther Arcanus and Thule Ravenclaw as fellow students of the Kirin Tor before the Plague.",
    {V .. " #366 Return the Book; #411 The Prodigal Lich Returns; #444 Rot Hide Origins"}, {"Bethor"}, {"place:undercity"})
Curated("npc:alaric", "Alaric", "Person",
    "Alaric had been Thule Ravenclaw's head servant and bodyguard. A spell meant to protect him from the Plague instead left him trapped in an unnatural unlife at Fenris Keep.",
    {V .. " #460 Resting in Pieces"}, nil, {"place:fenris-keep"})
Curated("npc:rane", "Rane Yorick", "Person",
    "Rane and Quinn Yorick were Deathstalkers sent to scout northern Silverpine for High Executor Hadrec. Their reconnaissance met resistance from the Scourge around the farms.",
    {V .. " #425 Ivar the Foul; #428 Lost Deathstalkers"}, {"Rane"}, {"place:silverpine", "npc:quinn"})
Curated("npc:quinn", "Quinn Yorick", "Person",
    "Quinn was Rane Yorick's brother and fellow Deathstalker. Wounded during their Silverpine reconnaissance, he needed alchemical aid from the Sepulcher.",
    {V .. " #425 Ivar the Foul; #428 Lost Deathstalkers; #429 Wild Hearts; #430 Return to Quinn"},
    {"Quinn"}, {"place:silverpine", "npc:rane"})
Curated("npc:ivar", "Ivar the Foul", "Person",
    "Ivar was a ghoul haunting a farm in northern Silverpine. His attack wounded Quinn Yorick and interrupted the Deathstalkers' reconnaissance.",
    {V .. " #425 Ivar the Foul; #428 Lost Deathstalkers"}, nil, {"place:silverpine"})
Curated("npc:grimson", "Grimson the Pale", "Person",
    "Grimson was the foreman of Deep Elem Mine. Dalar Dawnweaver connected his corruption with the spread of Arugal's magic through Silverpine.",
    {V .. " #424 Arugal's Folly"}, {"Grimson"}, {"place:deep-elem"})
Curated("npc:berard", "Apothecary Berard", "Person",
    "Berard had researched an ancient plague affecting Lordamere Lake. His study was in the Pyrewood Village inn, and the Royal Apothecary Society considered his work valuable despite Arugal's curse upon him.",
    {V .. " #450 A Recipe For Death"}, {"Berard"}, {"place:pyrewood", "place:lordamere"})
Curated("npc:faranell", "Master Apothecary Faranell", "Person",
    "Faranell received research and reagents for the Royal Apothecary Society in the Undercity. Silverpine's spiders, bears and lake creatures all figured in the Society's search for a new plague.",
    {V .. " #447 and #451 A Recipe For Death"}, {"Apothecary Faranell", "Faranell"}, {"place:undercity"})
Curated("place:agamand-mills", "Agamand Mills", "Place",
    "The prosperous Agamand family's mills became a Scourge foothold after the Plague. Windmills marked the approach, and the family crypt held the strongest concentration of their forces.",
    {V .. " #354 Deaths in the Family; #408 The Family Crypt; #426 The Mills Overrun"},
    {"the Agamand Mills"}, {"place:agamand-crypt", "place:tirisfal"})
Curated("place:agamand-crypt", "Agamand Family Crypt", "Place",
    "The Agamand family crypt lay at the northern end of the mills. Captain Dargol used it as a Scourge headquarters, raising the family's ancestors for war against the Forsaken.",
    {V .. " #408 The Family Crypt; #1821 Agamand Heirlooms"}, {"the Agamand Family Crypt", "Agamand Crypt"},
    {"place:agamand-mills"})
Curated("place:balnir", "Balnir Farmstead", "Place",
    "Balnir Farmstead had become a haven for Scourge slipping past the Bulwark. Their presence threatened the defenders' rear and the supply line into eastern Tirisfal.",
    {V .. " #356 Rear Guard Patrol"}, nil, {"place:bulwark", "place:tirisfal"})
Curated("place:bulwark",
    "The Bulwark",
    "Place",
    "The Bulwark is the Forsaken defensive position at Tirisfal's eastern frontier, on the edge of the Western Plaguelands. Its guards face the Scourge beyond the border and protect the approaches to the Undercity. Scourge slipping behind the defenses also endanger their supplies, so patrols watch the surrounding farms and rear approaches. Argent Dawn personnel also maintain a presence at the border camp.\n\nHigh Executor Derrington uses the Bulwark as his base for the Horde's campaign in the Plaguelands. He receives volunteers answering the call to arms and directs them against a threat entrenched across the ruined lands to the east.\n\nThe camp also supports an effort to turn the Scourge's plague cauldrons against their makers. Derrington's second, Shadow Priestess Vandis, coordinates the work. Poison samples return to her for Apothecary Dithers to study, with the aim of producing a counteragent that can weaken the undead. The plan depends on continued interference with the cauldrons, rather than a single decisive shutdown.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #356 Rear Guard Patrol, L2971", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5093 A Call to Arms: The Plaguelands!, L22110", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5228 The Scourge Cauldrons, L22728", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5230 Return to the Bulwark, L22747", "https://classicdb.ch/?quest=5093", "https://classicdb.ch/?quest=5228", "https://warcraft.wiki.gg/wiki/Bulwark (opening geography; Forsaken and Argent Dawn presence)", "https://warcraft.wiki.gg/wiki/Tirisfal_Glades_(Classic) (Places to stay: Bulwark)"},
    {"Bulwark"},
    {"place:tirisfal", "region:5765737465726e20506c616775656c616e6473", "faction:forsaken"},
    "Classic / Forever",
    true)
Curated("place:garrens-haunt", "Garren's Haunt", "Place",
    "Garren's Haunt lay near Tirisfal's mass graves. Rot Hide gnolls gathered in the area, stealing plague victims' bodies to strengthen the Scourge.",
    {V .. " #358 Graverobbers"}, nil, {"place:tirisfal", "place:mass-graves"})
Curated("place:mass-graves", "The Mass Graves", "Place",
    "The mass graves southwest of Garren's Haunt held many victims of Tirisfal's Plague. The Scourge sent Rot Hide gnolls to rob them of corpses.",
    {V .. " #358 Graverobbers"}, {"Mass Graves"}, {"place:garrens-haunt", "place:tirisfal"})
Curated("place:brightwater", "Brightwater Lake", "Place",
    "An island in Brightwater Lake sheltered a reclusive, free-willed lich. His guarded camp drew the Forsaken's interest in the magical knowledge he might possess.",
    {V .. " #357 The Lich's Identity"}, nil, {"place:tirisfal"})
Curated("place:solliden", "Solliden Farmstead", "Place",
    "Solliden Farmstead was a landmark on the western approach to a Scarlet Crusade tower. Executor Zygand's orders placed Scarlet warriors beyond the farm among the threats to Tirisfal.",
    {V .. " #427 At War With The Scarlet Crusade"}, nil, {"place:tirisfal"})
Curated("npc:sevren", "Magistrate Sevren", "Person",
    "Sevren served in Brill and kept records of its people. Both the Scourge at Agamand Mills and the fate of bodies stolen from Tirisfal's graves came before him.",
    {V .. " #355 Speak with Sevren; #440 The Engraved Ring"}, {"Sevren"}, {"place:brill"})
Curated("npc:zygand", "Executor Zygand", "Person",
    "Zygand received intelligence in Brill and directed action against the Scarlet Crusade. He also stood above the Deathguards patrolling the approaches to the Bulwark.",
    {V .. " #356 Rear Guard Patrol; #383 Vital Intelligence; #427 At War With The Scarlet Crusade"},
    {"Zygand"}, {"place:brill"})
Curated("npc:johaan", "Apothecary Johaan", "Person",
    "Johaan pursued a new plague in Brill as a member of the Royal Apothecary Society. He shared his findings with Apothecary Renferrel in Silverpine.",
    {V .. " #367 A New Plague; #445 Delivery to Silverpine Forest"}, {"Johaan"}, {"place:brill"})
Curated("npc:dargol", "Captain Dargol", "Person",
    "Dargol was a skeletal Scourge commander headquartered in the Agamand Family Crypt. His necromancy raised the family's ancestors against the Forsaken.",
    {V .. " #408 The Family Crypt"}, {"Dargol"}, {"place:agamand-crypt"})

-- Everyday settlements keep early journeys legible across both factions.
Curated("place:northshire", "Northshire", "Place",
    "Northshire's abbey stood amid countryside troubled by wolves, kobolds and the Defias Brotherhood. Marshal McBride's reports connected its defense with the wider work of the Stormwind marshals in Elwynn.",
    {V .. " #7 Kobold Camp Cleanup; #18 Brotherhood of Thieves; #54 Report to Goldshire; #5261 Eagan Peltskinner"},
    {"Northshire Valley"}, {"place:goldshire"})
Curated("place:goldshire", "Goldshire", "Place",
    "Goldshire lay south of Northshire's gates. Marshal Dughan received reports there while trying to protect Elwynn with much of Stormwind's army occupied elsewhere.",
    {V .. " #54 Report to Goldshire"}, nil, {"place:northshire"})
Curated("npc:dughan",
    "Marshal Dughan",
    "Person",
    "Marshal Dughan is a Stormwind marshal stationed in Goldshire, responsible for protecting the surrounding Elwynn Forest. He receives recruits referred by Marshal McBride in Northshire and puts their help to work beyond the abbey's comparatively sheltered grounds. Goldshire is the center from which he follows reports of trouble at the mines, farms and approaches to the town.\n\nDughan has too few soldiers for the dangers facing Elwynn. Gnolls and thieves trouble the western garrison, while kobolds are reported in Fargodeep Mine to the south. He sends helpers to investigate and directs support toward Deputy Rainer at Westbrook Garrison when he cannot spare more troops.\n\nRemy Two Times also warns him about murlocs in eastern Elwynn. Dughan takes the report seriously enough to hear it, but will not move scarce soldiers on a merchant's account alone; he asks for confirmation from Guard Thomas at the eastern bridge.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #54 Report to Goldshire, L415", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #62 The Fargodeep Mine, L487", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #239 Westbrook Garrison Needs Help!, L1972", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #40 A Fishy Peril, L306", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #35 Further Concerns, L264"},
    {"Dughan"},
    {"place:goldshire", "place:fargodeep", "region:456c77796e6e20466f72657374"},
    "Classic / Forever",
    true)
Curated("place:fargodeep", "Fargodeep Mine", "Place",
    "Fargodeep Mine lay south of Goldshire between the Stonefield and Maclure homesteads. Reports of kobolds taking shelter there worried Elwynn's marshals.",
    {V .. " #62 The Fargodeep Mine"}, {"the Fargodeep Mine"}, {"place:goldshire"})
Curated("place:sentinel-hill", "Sentinel Hill", "Place",
    "The stone tower on Sentinel Hill was a meeting point for the People's Militia in central Westfall. Gryan Stoutmantle directed the militia's efforts to protect the farmlands.",
    {V .. " #109 Report to Gryan Stoutmantle"}, nil, {"npc:stoutmantle"})
Curated("npc:stoutmantle", "Gryan Stoutmantle", "Person",
    "Stoutmantle led the People's Militia from Sentinel Hill. He described the farmers of Westfall as abandoned by the monarchy and looked to local defenders to protect the land.",
    {V .. " #109 Report to Gryan Stoutmantle"}, {"Stoutmantle"}, {"place:sentinel-hill"})
Curated("place:coldridge", "Coldridge Valley", "Place",
    "Coldridge Valley's snowy hills and frozen lake had become a battleground with troggs. An overrun camp and shortages of defenders made even the valley's roads uncertain.",
    {V .. " #170 A New Threat; #282 Senir's Observations"}, nil, {"place:anvilmar"})
Curated("place:anvilmar", "Anvilmar", "Place",
    "The road from Anvilmar led east to the tunnel toward Kharanos. Troggs infested that passage, leaving Mountaineer Thalos warning travelers against the journey.",
    {V .. " #282 Senir's Observations"}, nil, {"place:coldridge"})
Curated("place:thelsamar", "Thelsamar", "Place",
    "Thelsamar supported travelers and excavation workers in Loch Modan. Vidra's blood sausages fed its busy households, while supplies passed through the town to Ironband's dig.",
    {V .. " #418 Thelsamar Blood Sausages; #436 Ironband's Excavation; #298 Excavation Progress Report"}, nil,
    {"place:ironbands-excavation"})
Curated("place:ironbands-excavation", "Ironband's Excavation", "Place",
    "Prospector Ironband led an excavation of ancient ruins east of Loch Modan's lake. Magmar Fellhew handled the site's practical work, which had been slowed by troggs.",
    {V .. " #436 Ironband's Excavation"}, nil, {"place:thelsamar"})
Curated("place:shadowglen", "Shadowglen", "Place",
    "Shadowglen was a woodland community in Teldrassil. Tarindrella's return and reports of corrupted grells troubled those watching over the grove.",
    {V .. " #458 and #459 The Woodland Protector"}, nil, {"npc:tarindrella", "place:dolanaar"})
Curated("npc:tarindrella", "Tarindrella", "Person",
    "Tarindrella was a dryad known as a woodland protector. In Shadowglen, she investigated the Fel Moss associated with the grells' corruption and feared for the nearby furbolgs.",
    {V .. " #458 and #459 The Woodland Protector"}, nil, {"place:shadowglen"})
Curated("place:dolanaar", "Dolanaar", "Place",
    "Dolanaar stood on the road carrying news and commerce to Darnassus. Gnarlpine ambushes threatened that route, while Athridas Bearmantle watched the health of Teldrassil's forest.",
    {V .. " #459 The Woodland Protector; #487 The Road to Darnassus"}, nil, {"place:banethil"})
Curated("place:banethil", "Ban'ethil Barrow Den", "Place",
    "Ban'ethil sheltered sleeping druids and the sacred chests containing the Relics of Wakening. Gnarlpine invaders endangered the hibernation ritual that allowed the druids to return from the Emerald Dream.",
    {V .. " #483 The Relics of Wakening"}, {"Ban'ethil"}, {"place:dolanaar"})
Curated("place:grove-ancients", "Grove of the Ancients", "Place",
    "The Grove of the Ancients lay south of Auberdine in Darkshore. Onu, an Ancient of Lore, received messages there from the Arch Druid in Darnassus.",
    {V .. " #952 Grove of the Ancients"}, {"the Grove of the Ancients"}, {"npc:onu"})
Curated("npc:onu", "Onu", "Person",
    "Onu was an Ancient of Lore in Darkshore's Grove of the Ancients. His patience followed the forest's rhythms, contrasting with the urgency of messages from Darnassus.",
    {V .. " #952 Grove of the Ancients"}, nil, {"place:grove-ancients"})
Curated("place:narache", "Camp Narache", "Place",
    "Camp Narache's tauren valued service to the tribe, from fetching water to providing meat, feathers and hides. Chief Hawkwind's rites prepared young hunters for responsibilities beyond the camp.",
    {V .. " #747 The Hunt Begins; #750 The Hunt Continues; #752 and #753 A Humble Task; #763 Rites of the Earthmother"},
    {"Narache"}, {"place:red-cloud", "place:bloodhoof"})
Curated("place:red-cloud",
    "Red Cloud Mesa",
    "Place",
    "Red Cloud Mesa is the tauren starting ground in Mulgore, with Camp Narache at the heart of its early lessons. Hunting here supplies the village with meat and feathers; a young hunter's skill is measured through service to the tribe. Chief Hawkwind also looks for humility and a willingness to learn before sending newcomers to Seer Graytongue to begin the Rites of the Earthmother.\n\nThe Rite of Strength answers a danger close to home. Bristlebacks in Brambleblade Ravine ambush hunting parties and steal from the village, and the test calls for courage against these enemies. Beyond the mesa, Hawkwind directs the journey onward to Baine Bloodhoof, carrying a carved totem that introduces its bearer. The first steps toward acceptance in Thunder Bluff begin with the needs of this small community.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #747 The Hunt Begins; #757 Rite of Strength", "https://classicdb.ch/?quest=755", "https://classicdb.ch/?quest=763", "https://warcraft.wiki.gg/wiki/Mulgore_quests"},
    {},
    {"place:narache", "place:bloodhoof"},
    "Classic / Forever")
Curated("place:bloodhoof", "Bloodhoof Village", "Place",
    "Baine Bloodhoof led this Mulgore village. The Rites of the Earthmother brought young tauren here from Camp Narache to continue earning the elders' acceptance.",
    {V .. " #763 Rites of the Earthmother"}, nil, {"npc:baine", "place:narache"})
Curated("npc:baine", "Baine Bloodhoof", "Person",
    "Baine was Cairne Bloodhoof's son and the chief of Bloodhoof Village. He received those continuing the Rites of the Earthmother after Chief Hawkwind's guidance.",
    {V .. " #763 Rites of the Earthmother"}, {"Baine"}, {"place:bloodhoof"})
Curated("place:valley-trials", "Valley of Trials", "Place",
    "The Valley of Trials offered early tests to the Horde's recruits. A Burning Blade coven had taken shelter in a cave there, spilling demonic familiars into the valley.",
    {V .. " #792 Vile Familiars; #794 Burning Blade Medallion"}, {"the Valley of Trials"}, {"place:senjin"})
Curated("place:senjin", "Sen'jin Village", "Place",
    "Sen'jin was a Darkspear village protected under the trolls' pact with the orcs. Master Gadrin received reports there as threats gathered on the mainland and the Echo Isles.",
    {V .. " #785 A Strategic Alliance; #805 Report to Sen'jin Village"}, {"Sen'jin"}, {"place:echo-isles", "npc:gadrin"})
Curated("npc:gadrin", "Master Gadrin", "Person",
    "Gadrin advised the Darkspear in Sen'jin Village. He received warnings of the Burning Blade and spoke of the threats facing the trolls on the Echo Isles.",
    {V .. " #805 Report to Sen'jin Village"}, {"Gadrin"}, {"place:senjin"})
Curated("place:echo-isles", "Echo Isles", "Place",
    "The Darkspear had once called the Echo Isles home. Zalazane held sway there through hexes, sending enthralled trolls toward the mainland.",
    {V .. " #826 Zalazane"}, {"the Echo Isles"}, {"place:senjin"})
Curated("place:razor-hill", "Razor Hill", "Place",
    "Razor Hill was commanded by Gar'Thok. Reports of the human forces at Tiragarde Keep passed through him to the Horde's leadership in Orgrimmar.",
    {V .. " #830 and #831 The Admiral's Orders"}, nil, {"npc:garthok"})
Curated("npc:garthok", "Gar'Thok", "Person",
    "Gar'Thok commanded Razor Hill. The surviving orders of Admiral Proudmoore's forces concerned him enough to seek counsel from Nazgrel in Orgrimmar.",
    {V .. " #830 and #831 The Admiral's Orders"}, nil, {"place:razor-hill"})
Curated("place:skull-rock", "Skull Rock", "Place",
    "Skull Rock was a cave east of Orgrimmar occupied by the Burning Blade. Its cultists used searing collars in rituals that drew the attention of Margoz's investigation.",
    {V .. " #827 Skull Rock; #828 Margoz"}, nil, {"npc:margoz"})
Curated("npc:margoz", "Margoz", "Person",
    "Margoz was a shaman studying the Burning Blade's corruption in Durotar. He camped between the coast and Drygulch Ravine and sought to understand the cultists' searing collars.",
    {V .. " #827 Skull Rock; #828 Margoz; #829 Neeru Fireblade"}, nil, {"place:skull-rock"})
Curated("place:ratchet",
    "Ratchet",
    "Place",
    "Ratchet is the Steamwheedle Cartel's neutral port on the eastern coast of the Barrens, welcoming trade across the boundary between Horde and Alliance. Its sea route to Booty Bay links Kalimdor with the Eastern Kingdoms. Gazlowe conducts business here, arranging machinery and other shipments for customers far beyond the town; the wharfmasters' cargo records connect his dealings with the merchants across the sea.\n\nThat trade has enemies close to home. Southsea pirates camp south of Ratchet and prey on its shipping, intercepting goods ranging from telescope lenses to leather boots. Gazlowe's complaints show how quickly a distant order can become a local crisis: a merchant can promise a delivery, yet lose it on the last stretch of coast. Ratchet's busy docks depend on keeping those approaches open.",
    {"Original Ratchet faction description: Steamwheedle Cartel neutral trade port; preserved at https://warcraft.wiki.gg/wiki/Ratchet", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #887 Southsea Freebooters; #888 Stolen Booty; #1111 Wharfmaster Dizzywig; #1178/#1180 Goblin Sponsorship", "https://warcraft.wiki.gg/wiki/Barrens_(Classic) (original east-coast location and Booty Bay boat route)"},
    {},
    {"faction:steamwheedle", "place:booty-bay", "npc:dizzywig"},
    "Classic / Forever")
Curated("npc:dizzywig", "Wharfmaster Dizzywig", "Person",
    "Dizzywig worked at Ratchet's docks, overseeing cargo awaiting collection. His concerns were practical ones: the correct order, a waiting customer and machinery left too long in the weather.",
    {V .. " #1111 Wharfmaster Dizzywig"}, {"Dizzywig"}, {"place:ratchet"})
Curated("place:pools-vision", "Pools of Vision", "Place",
    "The Pools of Vision were in a cave beneath Thunder Bluff's shamans, reached by a hidden path from Spirit Rise. Apothecary Zamah received alchemical preparations there from the Barrens.",
    {V .. " #853 Apothecary Zamah"}, {"the Pools of Vision"}, {"npc:zamah"})
Curated("npc:zamah", "Apothecary Zamah", "Person",
    "Zamah worked in Thunder Bluff's Pools of Vision. She processed perishable alchemical samples sent by Apothecary Helbrim from the Barrens.",
    {V .. " #853 Apothecary Zamah"}, {"Zamah"}, {"place:pools-vision"})

Curated("place:kharanos", "Kharanos", "Place",
    "Kharanos lay beyond the tunnel leading out from Anvilmar. Reports from Coldridge passed through that dangerous route as troggs threatened travel between the dwarven settlements.",
    {V .. " #282 Senir's Observations"}, nil, {"place:anvilmar", "place:coldridge"})
Curated("place:crossroads", "The Crossroads", "Place",
    "The Crossroads received recruits for Horde duty in the Barrens. Sergra Darkthorn directed their work, backed by Thrall's confidence in her leadership.",
    {V .. " #840 Conscript of the Horde; #842 Crossroads Conscription"}, {"Crossroads"}, {"place:ratchet"})
Curated("npc:cairne",
    "Cairne Bloodhoof",
    "Person",
    "Cairne Bloodhoof is the High Chieftain of the tauren, whose scattered people he helped unite at Thunder Bluff. His alliance with Thrall grew from a struggle for survival. Centaur repeatedly attacked his people in the Barrens, and Thrall's orcs defended the tauren caravan on its journey toward Mulgore. Cairne in turn guided the young warchief toward the Oracle at Stonetalon Peak and supplied kodos for his journey. Their cooperation laid the foundation for the tauren's place in the Horde.\n\nFrom Thunder Bluff's highest mesa, Cairne now leads a people with a settled home in Mulgore after years of danger and displacement. His son Baine leads Bloodhoof Village below. Young tauren who complete the Rites of the Earthmother are sent to meet Cairne, connecting their personal coming of age with the elder who brought their tribes together.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 763, 775, 1102)", "https://warcraft.wiki.gg/wiki/The_Long_March_%28WC3_Orc%29", "https://warcraft.wiki.gg/wiki/Cairne_Bloodhoof"},
    {"Cairne"},
    {"npc:thrall", "place:bloodhoof"},
    "Classic / Forever")
Curated("place:southshore",
    "Southshore",
    "Place",
    "Southshore is a human harbor town on the coast of Hillsbrad Foothills, an Alliance foothold near Horde-held Tarren Mill. Its guards must contend with threats from both the shore and the inland roads. Lieutenant Farren, transferred from Stormwind, complains about his posting while Redpath presses him to deal with the murlocs along the Western Strand. Keeping the town safe depends on work that some of its own defenders would rather avoid.\n\nThe danger is not confined to raiders on the beach. Southshore's previous magistrate was assassinated, and his successor's investigation points toward the Syndicate, the criminal followers of Alterac's fallen nobles. The murderers themselves have not been identified with certainty. The town therefore faces an enemy whose nearby camps are known, but whose part in the killing still rests on suspicion.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #536 Down the Coast; #560 Farren's Proof; #563 Reassignment; #505 Syndicate Assassins", "https://warcraft.wiki.gg/wiki/Hillsbrad_Foothills_(Classic)", "https://www.wowhead.com/classic/zone=267/hillsbrad-foothills"},
    {},
    {"place:tarren-mill", "region:48696c6c736272616420466f6f7468696c6c73"},
    "Classic / Forever")
Curated("place:tarren-mill", "Tarren Mill", "Place",
    "Tarren Mill was a Horde foothold in Hillsbrad. Forsaken research there sought new killing agents from local wildlife, while Syndicate camps lay to the north.",
    {V .. " #496 Elixir of Suffering; #505 Syndicate Assassins"}, nil, {"place:southshore"})
Curated("place:lights-hope",
    "Light's Hope Chapel",
    "Place",
    "Light's Hope Chapel is an Argent Dawn refuge in the Eastern Plaguelands. As the Scourge gathers strength, the order calls for volunteers to defend the land and directs them to the Keeper of the Rolls. The chapel is also a meeting place for those still trying to understand what the plague has taken from them: Carlin Redpath examines the history of ruined Darrowshire here, searching for the truth about his family.\n\nThe work reaches beyond the chapel grounds. Leonid Barthalomew diverts dragon eggs away from the Scourge, while Commander Eligor Dawnbringer calls for attacks on the forces inside Naxxramas. In that campaign, he offers the combined support of the Dawn and the Crusade. Amid hostile territory, the chapel gathers recruits, information and aid for the struggle against Kel'Thuzad's army.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9154 Light's Hope Chapel; #5210 Brother Carlin; #5522 Leonid Barthalomew; #5531 Betina Bigglezink; #9033 Echoes of War", "https://classicdb.ch/?quest=9154", "https://classicdb.ch/?quest=9033"},
    {"the Light's Hope Chapel", "Light's Hope"},
    {"faction:argent-dawn", "dungeon:naxxramas", "region:4561737465726e20506c616775656c616e6473"},
    "Classic / Forever")

-- Dungeon notes describe the place, not its encounter order or its ending.
-- These summaries were checked against the cited captured Classic quest text.
-- The existing project catalogue supplies only explicit geography/name identity
-- where a quest uses a shorter name; it is not a source of invented encounters.
local C = "Interface/AddOns/CompanionJournal/Lore.lua"
local BW = "https://worldofwarcraft.blizzard.com/en-us/news/23302788 (Blizzard, original Classic Blackwing Lair preview, 2020)"
local AQ = "https://worldofwarcraft.blizzard.com/en-us/news/23482836 (Blizzard, original Classic Ahn'Qiraj preview, 2020)"
local function Dungeon(id, title, body, sources, names, related, raid)
    Curated("dungeon:" .. id, title, raid and "Raid" or "Dungeon", body, sources, names, related)
end
Dungeon("ragefire", "Ragefire Chasm",
    "The caverns beneath Orgrimmar sheltered troggs and the Searing Blade, a sect of the Shadow Council. Their spell books drew the Dark Lady's interest, while Thunder Bluff sought word of a missing Grimtotem servant.",
    {V .. " #5722 Searching for the Lost Satchel; #5725 The Power to Destroy..."}, {"RFC"}, {"region:" .. Encode("Orgrimmar")})
Curated("npc:oggleflint", "Oggleflint", "Person",
    "Oggleflint was the trogg chieftain in Ragefire Chasm. The troggs were among the inhabitants of those caverns beneath Orgrimmar, alongside the Searing Blade's separate presence.",
    {C .. " Ragefire Chasm boss catalogue: Oggleflint", V .. " #5722 Searching for the Lost Satchel; #5725 The Power to Destroy..."}, nil,
    {"dungeon:ragefire"})
Curated("npc:taragaman", "Taragaman the Hungerer", "Person",
    "Taragaman was a felguard in Ragefire Chasm. Neeru described him as the leader of the Searing Blade and called for his heart as proof of the demon's destruction.",
    {V .. " #5761 Slaying the Beast, Neeru's quest and progress dialogue"}, {"Taragaman"}, {"dungeon:ragefire"})
Curated("npc:jergosh", "Jergosh the Invoker", "Person",
    "Jergosh was a warlock among the Searing Blade's leaders in Ragefire Chasm. Thrall's investigation linked the cult's leadership with Neeru in Orgrimmar's Cleft of Shadow.",
    {V .. " #5728 and #5729 Hidden Enemies", C .. " Ragefire Chasm boss catalogue: Jergosh the Invoker"}, {"Jergosh"},
    {"dungeon:ragefire"})
Curated("npc:bazzalan", "Bazzalan", "Person",
    "Bazzalan was a satyr among the leaders of the Searing Blade in Ragefire Chasm. Thrall named him while investigating the cult's ties to Neeru.",
    {V .. " #5728 Hidden Enemies"}, nil, {"dungeon:ragefire"})
Curated("dungeon:wailing-caverns",
    "Wailing Caverns",
    "Dungeon",
    "The Wailing Caverns lie beneath the Barrens, where Naralex and his disciples sought a way to restore the land's lost forests. Naralex entered the Emerald Dream, but his vision became a nightmare. Corrupted creatures now fill the caves, and druids who once meant to heal the Barrens have become the Druids of the Fang, intent on reshaping the land to match their twisted dreams.\n\nA surviving disciple remains determined to wake Naralex. The four Fanglords must first be defeated; only then can the awakening ritual begin. The disciple needs companions to protect him as he reaches into the Dream, while creatures from Naralex's troubled sleep threaten the attempt. The struggle in the caverns is a rescue as well as a fight against corruption: the druid who hoped to heal the Barrens is himself trapped within the nightmare.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1487 Deviate Eradication; #914 Leaders of the Fang; #1489 Hamuul Runetotem", "https://warcraft.wiki.gg/wiki/Muyoh#Quotes"},
    {"The Wailing Caverns", "WC"},
    {"npc:naralex", "npc:mutanus", "place:emerald-dream"},
    "Classic / Forever")
Curated("dungeon:deadmines",
    "The Deadmines",
    "Dungeon",
    "The Deadmines beneath Moonbrook in Westfall conceal Edwin VanCleef's headquarters and the Defias Brotherhood's most ambitious project. Deep beyond the working tunnels, goblin craftsmen build and arm a great ironclad juggernaut in Ironclad Cove. VanCleef commands from the vessel, with pirates, laborers and armed guards occupying the mines around him.\n\nThe operation grows from the grievance of Stormwind's unpaid Stonemasons. After the nobles refused payment for rebuilding the city, VanCleef led a riot and swore revenge. His Brotherhood's violence now burdens Westfall's remaining people, whose militia seeks to end his command. The tunnels also hold an older tragedy: miners and an Explorers' League expedition were lost in a collapse, leaving families seeking proof of their fate. Industrial ambition and unfinished grief share the same underground refuge.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 167, 168, 166, 389, 102)", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf", "https://warcraft.wiki.gg/wiki/Gilnid", "https://warcraft.wiki.gg/wiki/Juggernaught"},
    {"Deadmines", "Deadmines (Classic)", "The Deadmines"},
    {"npc:vancleef", "group:defias"},
    "Classic / Forever")
Dungeon("stockade", "The Stockade",
    "Stormwind's Stockade held prisoners accused of crimes far beyond the city's walls. A riot had placed the prison's guards under pressure and made the inmates a concern for officials across the kingdom.",
    {V .. " #377 Crime and Punishment; #378 The Fury Runs Deep; #391 The Stockade Riots"},
    {"Stockade", "The Stockades", "Stormwind Stockade", "Stormwind Stockades"})
Dungeon("blackfathom", "Blackfathom Deeps",
    "Blackfathom Deeps had been a temple of Elune on the coast of Ashenvale. The Twilight's Hammer and the naga occupied its ruined grounds, where an ancient moonwell had been corrupted.",
    {V .. " #1199 Twilight Falls; #1200 Blackfathom Villainy"}, {"Blackfathom", "BFD"})
Curated("dungeon:gnomeregan",
    "Gnomeregan",
    "Dungeon",
    "Gnomeregan is the gnomes' great technological city beneath Dun Morogh, lost after a trogg invasion and a disastrous attempt to stop it. High Tinker Gelbin Mekkatorque ordered radioactive waste released into the city, but the invaders endured while many gnomes died or fled to Ironforge. Mekgineer Thermaplugg, once Mekkatorque's trusted adviser, remains in control of the contaminated halls.\n\nMekkatorque denounces Thermaplugg's betrayal and seeks his destruction as a step toward reclaiming the city. The exiles' struggle also involves saving what survives: engineers seek a cure for the afflicted gnomes, recover irreplaceable data and try to repair machines driven into frenzy. Techbot, once a helpful storehouse of information, now runs wild with its behavior reversed. Gnomeregan's inventions and former citizens alike have become obstacles to the survivors' return.",
    {"https://warcraft.wiki.gg/wiki/Gnomeregon", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2929, 2926, 2930, 2922)"},
    {},
    {"region:49726f6e666f726765", "faction:gnomeregan-exiles", "event:fall-gnomeregan"},
    "Classic / Forever")
Curated("dungeon:razorfen-kraul",
    "Razorfen Kraul",
    "Dungeon",
    "Razorfen Kraul is a vast thorn stronghold in the southern Barrens, sacred to the quilboar. Its origins are bound to Agamaggan, the colossal boar demigod who died fighting the Burning Legion during the War of the Ancients. Great thorn growths arose where his blood fell, and the quilboar came to revere and inhabit them.\n\nCharlga Razorflank seized the Kraul and musters an army within it, sending her followers against rival tribes and neighboring settlements. Her growing power alarms both those studying Agamaggan's resting place and tauren driven from lands they consider holy. Heralath and Lonebrow's fate brings a call to stop her, while the elder Auld Stonespire seeks vengeance for his displaced people. A sacred refuge has become the base of a dangerous campaign of conquest.",
    {"https://warcraft.wiki.gg/wiki/RFK", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1101, 1102)"},
    {"Razorfen Kraul (Classic)", "RFK"},
    {"npc:cairne"},
    "Classic / Forever")
Dungeon("razorfen-downs", "Razorfen Downs",
    "A tangle of briars in the Barrens enclosed Razorfen Downs. Reports from both factions described the quilboar there as allied with the Scourge and subject to a lich's rule.",
    {V .. " #3341 Bring the End; #3636 Bring the Light"}, {"RFD"})
Curated("dungeon:scarlet-monastery",
    "Scarlet Monastery",
    "Dungeon",
    "The Scarlet Monastery in Tirisfal Glades was once a respected center of Lordaeron's religious life, devoted to the Holy Light, learning and the training of paladins. The plague and the kingdom's collapse transformed it into a fortress of the Scarlet Crusade. The order claims to cleanse the land of undeath, but its fear has become persecution: former Crusader Raleigh describes innocent people tortured because anyone outside the order is presumed infected.\n\nIts Graveyard, Library, Armory and Cathedral preserve the shape of the old institution while serving the zealots who occupy it. Scarlet Commander Mograine leads its warriors, and High Inquisitor Whitemane commands powers that can return fallen fighters to battle. Herod and Houndmaster Loksey are among its other leading defenders. Both the Forsaken and opponents of the Crusade within the Alliance seek to break this leadership; scholars also hope to recover the knowledge still guarded in its library.",
    {"https://warcraft.wiki.gg/wiki/Scarlet_Monastery_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1048 Into The Scarlet Monastery; 1049 Compendium of the Fallen; 1050 Mythology of the Titans; 1053 In the Name of the Light)"},
    {"Scarlet Monastery (Classic)", "The Scarlet Monastery"},
    {"group:scarlet-crusade", "event:third-war"},
    "Classic / Forever")
Dungeon("uldaman", "Uldaman",
    "Uldaman was an excavation site where ancient relics drew the attention of explorers and the Shadowforge clan. The search for its tablets touched questions about the titans and their creations.",
    {V .. " #704 Agmond's Fate; #1139 The Lost Tablets of Will"})
Dungeon("zulfarrak", "Zul'Farrak",
    "Zul'Farrak was a sand troll city in Tanaris. Its pools, tombs and guarded relics drew treasure seekers and scholars into Sandfury territory.",
    {V .. " #2770 Gahz'rilla; #2936 The Spider God; #2768 Divino-matic Rod; #3042 Troll Temper"}, {"ZF"})
Dungeon("maraudon", "Maraudon",
    "Maraudon's crystal caverns were the dwelling of the earth elemental Princess Theradras and the resting place of Zaetar, a son of Cenarius. Their union gave rise to the centaur, who turned on their father and killed him. Zaetar's remains stayed in the depths with Theradras, binding the centaur's origins to a place where earth, life and corruption had become entangled.\n\nYet the life within Maraudon also sprang from Zaetar. His remains nourished its growth, and his spirit refused to abandon the children who had killed him. He saw hope in that living sanctuary and wished to remain their father even after death. The caverns therefore held both the violence of the centaur's beginnings and the life their father continued to give them.\n\nAnother corruption spread through the outer caves. Lord Vyletongue poisoned their plants and inhabitants, creating Noxxion as a living embodiment of his taint. Celebras, who had come hoping to bring peace to his uncle's spirit, was himself overcome; the satyr and his creation took the pieces of his scepter. Recovering Maraudon meant confronting this blight as well as the ancient power in its depths.",
    {V .. " #7064 and #7065 Corruption of Earth and Seed; #7066 Seed of Life (Zaetar's account)",
        V .. " #7029 Vyletongue Corruption; #7044 Legends of Maraudon; #7046 The Scepter of Celebras"}, nil,
    {"npc:zaetar", "npc:theradras", "npc:celebras"})
Curated("dungeon:atalhakkar",
    "The Temple of Atal'Hakkar",
    "Dungeon",
    "The Temple of Atal'Hakkar is the Atal'ai trolls' drowned shrine to Hakkar the Soulflayer beneath the Pool of Tears in the Swamp of Sorrows. Exiled after their attempt to restore the blood god brought war to the Gurubashi, the priests built this northern sanctuary to prepare his return. Ysera learned of their purpose, sank the temple, and left green dragons to contain the danger.\n\nThe cult survived. Jammal'an the Prophet teaches that Hakkar's return will grant the Atal'ai immortality, and his followers preserve the fetishes and rites needed for their summoning. Their guardians have also fallen into peril: the Shade of Eranikus haunts the temple, and the dragon's trapped essence describes his failed watch and a mind twisting into nightmare. The Sunken Temple therefore holds both an enduring blood cult and the corruption of the powers appointed to restrain it.",
    {"https://warcraft.wiki.gg/wiki/Temple_of_Atal%27Hakkar_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1424 Pool of Tears; 1445 The Temple of Atal'Hakkar; 3373 The Essence of Eranikus)"},
    {"Temple of Atal'Hakkar", "Temple of Atal'Hakkar (Classic)", "Sunken Temple", "The Sunken Temple"},
    {"npc:ysera"},
    "Classic / Forever")
Curated("dungeon:blackrock-depths",
    "Blackrock Depths",
    "Dungeon",
    "Blackrock Depths contains Shadowforge City, the Dark Iron capital within Blackrock Mountain. Emperor Dagran Thaurissan rules its people under the shadow of Ragnaros, whose elemental stronghold lies deeper below. The city combines a working realm with a fortress: prisons, foundries, guarded streets and the Grim Guzzler tavern stand along the route toward the Imperial Seat.\n\nThe ghost of Franclorn Forgewright, its architect, offers a way through the city's defenses. Recovering his hammer Ironfel and returning it to his shrine yields the Shadowforge Key. Elsewhere, Golem Lord Argelmach's work gives the Dark Irons a growing force of war machines.\n\nA royal rescue brings another conflict into these halls. Magni sends adventurers to kill Thaurissan and free his daughter Moira, believing her enchanted. After the emperor dies, she calls him her husband and announces that she carries his child, a future Dark Iron heir to Ironforge. Her reply turns the supposed rescue into a crisis for both dwarven kingdoms.",
    {"https://warcraft.wiki.gg/wiki/Blackrock_depths", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 3801, 3802, 4004, 4063, 4362, 4363, 6822)", "https://warcraft.wiki.gg/wiki/Dark_Iron_Legacy"},
    {"BRD"},
    {"faction:dark-iron", "npc:dagran", "npc:moira"},
    "Classic / Forever")
Curated("dungeon:blackrock-spire",
    "Blackrock Spire",
    "Dungeon",
    "Blackrock Spire is the great fortress in the upper reaches of Blackrock Mountain, originally a monument to Dark Iron power designed by Franclorn Forgewright. The Horde later used the mountain stronghold during its wars against humanity. In the present day, Nefarian and his black dragons dominate the upper Spire while fighting Ragnaros and the Dark Iron forces entrenched in the depths below.\n\nRend Blackhand rules his rival Horde from this fortress under the black dragonflight's protection, provoking Thrall's demand that the pretender be removed. Orcs, trolls and ogres occupy the lower citadel, whose master is Overlord Wyrmthalak. Above lie the Halls of Ascension and General Drakkisath's dragonspawn forces. At the summit, Blackwing Lair shelters Nefarian's experiments: the soldiers guarding the Spire also protect an attempt to breed a more powerful dragon army.",
    {"https://warcraft.wiki.gg/wiki/Game_Guide/World_Dungeons", "https://warcraft.wiki.gg/wiki/The_Alliance_of_Lordaeron", "https://warcraft.wiki.gg/wiki/Blackrock_Spire", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4742 Seal of Ascension; 4974 For The Horde!; 6502 Drakefire Amulet)", "https://news.blizzard.com/en-us/article/23302788/wow-classic-descend-into-the-depths-of-blackwing-lair"},
    {},
    {"dungeon:blackwing", "npc:nefarian", "npc:thrall"},
    "Classic / Forever")
Dungeon("lower-blackrock-spire", "Lower Blackrock Spire",
    "The lower citadel formed one part of Blackrock Spire's defended interior. Warlord Goretooth's orders targeted its commanders and sought important documents held in the stronghold.",
    {V .. " #4742 Seal of Ascension; #4903 Warlord's Command; #8966 The Left Piece of Lord Valthalak's Amulet"}, {"LBRS"},
    {"dungeon:blackrock-spire"})
Dungeon("upper-blackrock-spire", "Upper Blackrock Spire",
    "Blackrock Spire's upper halls belonged to the same stronghold as the lower citadel. Accounts of the Halls of Ascension described Blackrock rulers protected by the black dragonflight.",
    {V .. " #4974 For The Horde!; #8966 The Left Piece of Lord Valthalak's Amulet", C .. " Blackrock Spire geographical context"}, {"UBRS"},
    {"dungeon:blackrock-spire"})
Dungeon("dire-maul", "Dire Maul",
    "Dire Maul was once Eldre'Thalas, a city of night elf sorcerers built to shelter Queen Azshara's arcane secrets. Much of it survived the Great Sundering, leaving ancient halls in Feralas where the Shen'dralar preserved their learning. The ruined city still held extraordinary magical power, but the Shen'dralar had paid a terrible price to keep it.\n\nAfter the Well of Eternity's destruction, Prince Tortheldrin imprisoned the demon Immol'thar behind a force field sustained by pylons. The Highborne drew on their captive's energies to sustain their own magic. When maintaining the prison consumed too much power, the prince slaughtered his people so that he and his remaining followers could keep the dwindling supply. The ghosts wandering his halls were victims of their own ruler.\n\nOther powers claimed the city's broken districts. Alzzin the Wildshaper spread corruption through the east, where the once fertile plant known as the Fruit of Fertility became the Felvine. The Gordok ogres held the north. Within the western halls, the captive demon and the prince remained bound together: destroying Immol'thar would strip away the source of Tortheldrin's strength.",
    {"https://warcraft.wiki.gg/wiki/Dire_Maul (quoted original Blizzard World Dungeons introduction only)",
        "https://www.wowhead.com/npc=14358/shendralar-ancient (original Shen'dralar Ancient gossip transcript)",
        "https://news.blizzard.com/en-gb/article/23185723/wow-classic-dire-maul-now-available (Blizzard Classic preview; original setting corroboration)",
        V .. " #5526 Shards of the Felvine; #7461 The Madness Within; #1318 and #7703 Unfinished Gordok Business"}, {"Eldre'Thalas"},
    {"npc:tortheldrin", "npc:immolthar", "npc:king-gordok"})
Curated("dungeon:stratholme",
    "Stratholme",
    "Dungeon",
    "Stratholme is the ruined northern city where Arthas ordered the slaughter of inhabitants he believed infected with the plague, breaking with Uther and taking a decisive step toward his own fall. Its streets now hold Scourge forces and a Scarlet Crusade bastion, two enemies locked in a violent struggle amid the remains of Lordaeron.\n\nBaron Rivendare commands the undead stronghold, with the ziggurats guarding its approach; the Argent Dawn says the Scourge draws great power from these structures. The Scarlet Bastion answers to the apparent Grand Crusader Dathrohan, but the dreadlord Balnazzar hides behind that identity. Adventurers entering must contend with both sides. The Argent Dawn investigates the plague's unnatural potency, while Anthion Harmon's spirit begs for the rescue of his wife Ysida from Rivendare. The city's gates protect the forces perpetuating its ruin.",
    {"https://warcraft.wiki.gg/wiki/Stratholme_%28Classic%29", "https://warcraft.wiki.gg/wiki/Balnazzar_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 5212, 5213, 8945)"},
    {},
    {"npc:arthas", "npc:rivendare", "npc:balnazzar"},
    "Classic / Forever")
Curated("dungeon:scholomance",
    "Scholomance",
    "Dungeon",
    "Scholomance is the Scourge's school of necromancy beneath the ruined Barov estate on Caer Darrow. The family's wealth and stronghold became the foundations of a place where the living study the arts that create and command the undead. Darkmaster Gandling serves as headmaster, while the lich Ras Frostwhisper guards the school.\n\nThe ghost of Eva Sarkhoff remembers its transformation from a household into a nightmare. She believes the Barovs' bargain with Kel'Thuzad grew from their desire to preserve their fortune and prolong their lives. As cultists and monsters took over the estate, Eva and her husband Lucien hid within it. They were eventually caught and subjected to Doctor Krastinov's experiments, then kept alive to be devoured by ghouls. Their spirits remain, asking for their remains to be laid to rest.\n\nAlliance and Horde agents seek access through the locked entrance because the research within strengthens the Scourge. Breaking into the school brings them among its students, instructors and the undead remnants of the family that once owned it.",
    {"https://warcraft.wiki.gg/wiki/Scholo", "https://warcraft.wiki.gg/wiki/Eva_Sarkhoff", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 838, 5533)"},
    {"The Scholomance"},
    {"place:caer-darrow", "npc:gandling", "npc:ras"},
    "Classic / Forever")
Dungeon("molten-core", "Molten Core",
    "The Molten Core was the domain of Ragnaros beneath Blackrock Mountain, born from the catastrophe that ended the War of the Three Hammers. With his enemies closing in, the Dark Iron ruler Thaurissan sought a power that could save his kingdom. His summoning unleashed the Firelord instead. Ragnaros's arrival created Blackrock Mountain, killed Thaurissan, and left the surviving Dark Irons enslaved to the power they had called into the world.\n\nDeep below Blackrock Depths, Ragnaros rested in a burning lake that opened a passage to the plane of fire. Elemental servants could cross into Azeroth there even though their master could not range far from the Core. Majordomo Executus stood foremost among his agents, able to call the Firelord from his slumber. The dwarven city above existed in the shadow of this elemental dominion.\n\nThe Hydraxian Waterlords regarded the Core as a stronghold of their enemies and recruited mortal allies to strike at it. Duke Hydraxis warned that only an army could survive its defenders. His campaign against its fire captains brought the struggles of Azeroth's people into the war among the elements.",
    {"https://warcraft.wiki.gg/wiki/War_of_the_Three_Hammers_(History_of_Warcraft) (original in-game history book)",
        "https://worldofwarcraft.blizzard.com/en-us/news/24165121/20th-anniversary-realms-molten-core-and-onyxia-s-lair-now-live (original Blizzard Raid Areas introduction reproduced in Classic preview)",
        V .. " #6822 The Molten Core; #6823 Agent of Hydraxis; #6824 Hands of the Enemy"}, {"The Molten Core"},
    {"dungeon:blackrock-depths", "npc:ragnaros", "npc:executus"}, true)
Curated("dungeon:onyxia",
    "Onyxia's Lair",
    "Raid",
    "Onyxia's Lair is the black dragon brood mother's nesting place in the Wyrmbog of Dustwallow Marsh. Deathwing's daughter and Nefarian's younger sister, Onyxia guards a clutch of eggs here amid the surviving strength of the black dragonflight. The cavern is both her refuge and a nursery for the flight's future, and she fiercely defends it against intruders.\n\nHer reach extends far beyond the marsh. Disguised as Lady Katrana Prestor, she holds influence in Stormwind's royal court; Marshal Reginald Windsor's investigation exposes the dragon behind that identity. The struggle against her political deception thus leads back to the protected lair and its brood. The Drakefire Amulet, made from an enchanted scale and the blood of General Drakkisath, can defeat the wards barring entry.",
    {"https://worldofwarcraft.blizzard.com/en-us/news/24165121/20th-anniversary-realms-molten-core-and-onyxia-s-lair-now-live", "https://warcraft.wiki.gg/wiki/The_Great_Masquerade", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6501 The Dragon's Eye; 6502 Drakefire Amulet)"},
    {"Onyxia's Lair (Classic)"},
    {"npc:onyxia", "npc:nefarian"},
    "Classic / Forever")
Curated("dungeon:blackwing",
    "Blackwing Lair",
    "Raid",
    "Blackwing Lair is Nefarian's fortress and laboratory at the summit of Blackrock Spire. Deathwing's eldest son seeks to strengthen his dragonflight and crush Ragnaros, his rival for control of Blackrock Mountain. Behind the armies guarding the Spire, he experiments with the blood and eggs of different dragonflights, trying to unite their powers in a formidable chromatic brood.\n\nThe horrors within show what that ambition produces. Chromaggus can wield the powers of several flights, while the red dragon Vaelastrasz, defeated and corrupted by Nefarian, is forced to fight his captor's enemies. Black dragons and drakonid defend the laboratories and their master. Rend Blackhand's orders restrict the entrance orb to bearers of the Mark of Drakkisath, tying the lair's security to the military stronghold below. Nefarian's project threatens to turn that protected sanctuary into the source of an expanding dragon army.",
    {"https://news.blizzard.com/en-us/article/23302788/wow-classic-descend-into-the-depths-of-blackwing-lair", "https://warcraft.wiki.gg/wiki/Blackwing_Lair", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7761 Blackhand's Command; 5161 Wrath of the Blue Flight)"},
    {"BWL", "Blackwing"},
    {"dungeon:blackrock-spire", "npc:nefarian", "npc:ragnaros"},
    "Classic / Forever")
Curated("dungeon:zulgurub",
    "Zul'Gurub",
    "Raid",
    "Zul'Gurub is the ancient Gurubashi capital in Stranglethorn Vale, now the seat of Hakkar the Soulflayer's renewed power. The blood god has manifested within the city, and enthralled high priests channel the strength of their own sacred gods into him. His return threatens to restore the terror that once consumed the troll world and spread it beyond the jungle.\n\nThe Zandalar trolls gather on Yojamba Isle under Molthor to oppose him. They seek allies willing to break the priests' channeling and confront Hakkar himself. The danger is also a lesson in deception: Yeh'kinya's supposed plan to imprison the Soulflayer in an ancient egg instead helped bring him back. Even Hakkar's heart retains a kernel of his power after defeat, making the struggle more than the seizure of a ruined city.",
    {"https://warcraft.wiki.gg/wiki/Zul%27Gurub_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 8201, 8181, 8182, 8183)"},
    {},
    {"npc:hakkar", "dungeon:atalhakkar"},
    "Classic / Forever")
Curated("place:ahnqiraj", "Ahn'Qiraj", "Place",
    "Ahn'Qiraj was a desert fortress of the insectoid qiraji behind the Scarab Wall. Both the Alliance and the Horde gathered supplies for war against its forces.",
    {AQ, V .. " #8492 The Alliance Needs Copper Bars!; #8532 The Horde Needs Copper Bars!"})
Curated("dungeon:ahnqiraj-ruins",
    "Ruins of Ahn'Qiraj",
    "Raid",
    "The Ruins of Ahn'Qiraj are an open-air part of the Qiraji stronghold in Silithus. When the war effort opens Ahn'Qiraj's gates, the ruins become one front of the assault on its forces, alongside the separate expedition into the Temple. General Rajaxx, commander of the Qiraji armies, confronts the attackers here; Ossirian the Unscarred stands at the end of their path on the Watchers' Terrace.\n\nCommander Mar'alith of Cenarion Hold regards Ossirian's defeat as a service to all Kalimdor. The ruins also attract less public interests: Ravenholdt seeks Kurinnaxx's venom for a powerful poison compound.",
    {"https://worldofwarcraft.blizzard.com/en-gb/news/23493335/explore-the-temple-of-ahnqiraj-and-ruins-of-ahnqiraj", "https://classicdb.ch/?quest=8791", "https://classicdb.ch/?quest=9023"},
    {"The Ruins of Ahn'Qiraj", "AQ20"},
    {"place:ahnqiraj", "npc:rajaxx", "npc:ossirian"},
    "Classic / Forever",
    true)
Dungeon("ahnqiraj-temple", "Temple of Ahn'Qiraj",
    "The temple was one of the vast strongholds enclosed by the gates of Ahn'Qiraj. The campaign against its forces drew supplies from both factions, bringing distant settlements into the same war effort.",
    {AQ, V .. " #8492 The Alliance Needs Copper Bars!; #8532 The Horde Needs Copper Bars!"},
    {"Ahn'Qiraj Temple", "The Temple of Ahn'Qiraj", "AQ40"}, {"place:ahnqiraj"}, true)
Curated("dungeon:naxxramas",
    "Naxxramas",
    "Raid",
    "Naxxramas is Kel'Thuzad's floating necropolis above the Eastern Plaguelands, where the lich gathers the Scourge for another assault. The Argent Dawn prepares a way inside: an arcane protection allows adventurers to pass the warded rune portal in Plaguewood. The assault on the citadel calls for forty adventurers.\n\nIts quarters turn the Scourge's different horrors into an organized army. Undead spiders fill the Arachnid Quarter; the Plague Quarter develops the contagion into weapons; the Construct Quarter houses stitched monstrosities. In the Military Quarter, death knights train beneath instructors and commanders, with Highlord Mograine among the Four Horsemen who guard the citadel.\n\nBeyond those quarters lies the Frostwyrm Lair. Sapphiron, a slain blue dragon raised into undeath, protects the approach to Kel'Thuzad. Defeating the lich's body is only part of the danger: his phylactery must also be dealt with if his return is to be prevented.",
    {"https://worldofwarcraft.blizzard.com/news/23572632/wow-classic-naxxramas-is-now-live", "https://news.blizzard.com/en-gb/article/23826539/season-of-mastery-naxxramas-is-now-live", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 9121, 9033, 9120)"},
    {"The Naxxramas"},
    {"npc:kelthuzad", "faction:scourge", "faction:argent-dawn"},
    "Classic / Forever")
Curated("npc:onyxia", "Onyxia", "Person",
    "Onyxia was a daughter of Deathwing and sister to Nefarian, a black dragon whose reach extended from the swamps of Kalimdor to the heart of Stormwind. As Lady Katrana Prestor, she wore the identity of a human noblewoman and gained a place beside the kingdom's rulers. Her disguise let a member of the black dragonflight influence the very court to which threatened settlements turned for protection.\n\nHer hold on Stormwind went beyond persuasion. Highlord Bolvar Fordragon was bound by an enchanted medallion, leaving his mind and body subject to her magic. Marshal Windsor uncovered Prestor's true identity and prepared to expose her before the court. The danger he challenged was a dragon already inside the kingdom's defenses, concealing her power behind a trusted human face.\n\nAcross the sea, Onyxia kept her lair in Dustwallow Marsh. Her brood spread through the Dragonmurk and Wyrmbog and invaded Stonemaul Village. Magical wards protected the lair; an enchanted scale of the brood mother, renewed with the blood of a black dragon champion, could serve as a key. The intrigues of Lady Prestor and the growing brood belonged to the same threat.",
    {V .. " #4184-4186 The True Masters; #6402 Stormwind Rendezvous; #6403 The Great Masquerade (identity and Bolvar's medallion)",
        V .. " #1170 and #1172 The Brood of Onyxia; #6501 The Dragon's Eye; #6502 Drakefire Amulet"},
    nil, {"dungeon:onyxia", "npc:nefarian", "npc:bolvar"})
-- A public identity must not resolve straight to the concealed identity. The
-- discovery projection adds their relationship only after supporting evidence.
Curated("npc:katrana-prestor", "Lady Katrana Prestor", "Person",
    "Lady Katrana Prestor advises Stormwind's royal court. Highlord Bolvar Fordragon regards her as learned in dragons and dragonkin, and seeks her counsel when Lakeshire reports a black dragon threat. Her position places her among the people consulted over the kingdom's defenses.",
    {V .. " #4185 The True Masters"}, {"Lady Prestor", "Katrana Prestor"},
    {"npc:bolvar", "region:53746f726d77696e642043697479"})
Curated("npc:varimathras", "Varimathras", "Person",
    "Varimathras was a dreadlord who became Sylvanas Windrunner's lieutenant through defeat and a bargain for his life. In the struggle for Lordaeron after Arthas's departure, he and his brothers Detheroc and Balnazzar sought to make the ruined kingdom their own. Sylvanas refused his offer to join them: freedom from the Lich King meant little if she merely exchanged one master for another.\n\nWhen her forces overcame his, Varimathras offered knowledge of his brothers' plans and strongholds in return for mercy. Sylvanas accepted his service while warning that she would watch him closely. His place beside the Dark Lady thus began with useful secrets and compelled obedience, not a shared past among the Forsaken.\n\nFrom the Undercity, he directed military campaigns and secret investigations. The Deathstalkers were his elite guard, investigating suspected betrayal and gathering information. Sylvanas charged him with conquering the human and dwarven lands to the south, while his commanders in Hillsbrad attacked settlements and food supplies as the apothecaries developed their new plague. The demon spared in Lordaeron had become an instrument of the Forsaken's expansion.",
    {"https://warcraft.wiki.gg/wiki/The_Dark_Lady_%28WC3_Undead%29 (Warcraft III: The Frozen Throne, original chapter 3 dialogue)",
        V .. " #421 Prove Your Worth; #527 Battle of Hillsbrad; #1886 and #1898 The Deathstalkers; #5262 The Truth Comes Crashing Down"},
    {"Lord Varimathras"}, {"npc:sylvanas", "place:undercity", "npc:balnazzar"})
Curated("npc:nefarian",
    "Nefarian",
    "Person",
    "Nefarian, son of Deathwing, rules from Blackwing Lair and also appears in human form as Lord Victor Nefarius. He experiments with the blood of other dragonflights to create chromatic dragons, while gathering the Dark Horde into an army. His struggle with Ragnaros and the Dark Iron dwarves for Blackrock Mountain serves a larger ambition to conquer Azeroth.\n\nHis forces make that ambition difficult to confront: General Drakkisath commands his dragonspawn. Vaelan prepares a magically warded Seal of Ascension to aid those opposing the dragon. Nefarian also threatens the effort to reopen Ahn'Qiraj by taking the Red Scepter Shard. He treats the race to recover it as a cruel game, boasting that he can grind the world-saving relic to powder before his enemies defeat him.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7781, 7783)", "https://worldofwarcraft.blizzard.com/en-us/story/timeline/chapter-7", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4743, 6502)", "https://warcraft.wiki.gg/wiki/Nefarian", "https://warcraft.wiki.gg/wiki/From_the_Desk_of_Lord_Victor_Nefarius"},
    {"Lord Victor Nefarius", "Victor Nefarius", "Nefarius"},
    {"dungeon:blackwing", "npc:deathwing", "event:shifting-sands"},
    "Classic / Forever")

-- Early dungeon roster review, ordered by the leveling route. A short note
-- supported by a roster or observed ability stays short: neither a personality
-- nor an untold history can be inferred from a boss name. Quest-backed notes
-- use captured dialogue, and every boss links back to its dungeon context.
local WC = "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/wailing/wailinglr.pdf (original BradyGames Wailing Caverns guide)"
local DM = "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames Deadmines guide)"
local SF = "https://www.wowhead.com/classic/guide/shadowfang-keep-dungeon-strategy-wow-classic (Classic boss roster and abilities)"
local BF = "https://www.wowhead.com/classic/guide/blackfathom-deeps-dungeon-strategy-wow-classic (Classic boss roster)"
local ST = "https://www.wowhead.com/classic/guide/the-stockade-dungeon-strategy-wow-classic (Classic boss roster)"
local GN = "https://www.wowhead.com/classic/guide/gnomeregan-dungeon-strategy-wow-classic (Classic boss locations)"
local RK = "https://www.wowhead.com/classic/guide/razorfen-kraul-dungeon-strategy-wow-classic (Classic boss roster and abilities)"
Curated("group:searing-blade",
    "Searing Blade",
    "Group",
    "The Searing Blade is a sect of the Shadow Council hidden in Ragefire Chasm beneath Orgrimmar. Its leaders include the satyr Bazzalan and the warlock Jergosh the Invoker. Neeru Fireblade's interest in these cultists exposes a threat within the city of Thrall's new Horde.\n\nThrall directs an infiltrator to kill the two leaders while preserving Neeru's belief that the agent is an ally. He hopes to disrupt the cult and learn more of the Council's schemes through Neeru's reaction. The Searing Blade also possesses two powerful spell books coveted by the Dark Lady, whose servants seek to take them from the cult for her own purposes.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5725 The Power to Destroy...; #5728, #5729 and #5730 Hidden Enemies", "https://classicdb.ch/?quest=5728 (original named kill objectives)"},
    {"the Searing Blade", "Searing Blade cult"},
    {"dungeon:ragefire", "npc:taragaman", "faction:shadow-council"},
    "Classic / Forever",
    true)
Curated("npc:maur-grimtotem", "Maur Grimtotem", "Person",
    "Maur was a servant of Magatha sent into Ragefire Chasm to speak with its troggs. He found something unusual there but never returned with his discovery.",
    {V .. " #5722 Searching for the Lost Satchel"}, {"Maur"}, {"dungeon:ragefire"})
Curated("group:druids-fang", "Druids of the Fang", "Group",
    "The Druids of the Fang had belonged to an order that hoped to heal the Barrens. Their purpose became corrupted: they sought to reshape the land according to their twisted dreams, with four leaders each carrying a dream gem.",
    {V .. " #914 Leaders of the Fang"}, {"the Druids of the Fang"}, {"dungeon:wailing-caverns", "npc:naralex"})
Curated("npc:naralex", "Naralex", "Person",
    "Naralex hoped to enter the Emerald Dream and restore the Barrens to forest. His dream became a nightmare, and corrupted creatures filled the Wailing Caverns while his disciples struggled to awaken him.",
    {V .. " #1486 Deviate Hides; #1487 Deviate Eradication"}, nil, {"dungeon:wailing-caverns", "group:druids-fang"})
Curated("npc:anacondra", "Lady Anacondra", "Person",
    "Anacondra was one of the four leaders of the Druids of the Fang within the Wailing Caverns.",
    {WC .. " pp. 1, 3, 5; dream-gem leaders", V .. " #914 Leaders of the Fang"}, {"Anacondra"}, {"dungeon:wailing-caverns", "group:druids-fang"})
Curated("npc:cobrahn", "Lord Cobrahn", "Person",
    "Cobrahn was one of the dream-gem-bearing leaders of the Druids of the Fang in the Wailing Caverns.",
    {WC .. " pp. 1, 3, 6", V .. " #914 Leaders of the Fang"}, {"Cobrahn"}, {"dungeon:wailing-caverns", "group:druids-fang"})
Curated("npc:pythas", "Lord Pythas", "Person",
    "Pythas belonged to the four leaders of the Druids of the Fang, whose dream gems drew Thunder Bluff's concern.",
    {WC .. " pp. 1, 3, 7", V .. " #914 Leaders of the Fang"}, {"Pythas"}, {"dungeon:wailing-caverns", "group:druids-fang"})
Curated("npc:serpentis", "Lord Serpentis", "Person",
    "Serpentis was a leader of the Druids of the Fang, deep within the Wailing Caverns near Verdan the Everliving.",
    {WC .. " pp. 1, 3, 8", V .. " #914 Leaders of the Fang"}, {"Serpentis"}, {"dungeon:wailing-caverns", "group:druids-fang"})
Curated("npc:kresh", "Kresh", "Person",
    "Kresh was a large turtle in the waters of the Wailing Caverns.",
    {WC .. " pp. 1, 6"}, nil, {"dungeon:wailing-caverns"})
Curated("npc:skum", "Skum", "Person",
    "Skum inhabited the winding interior of the Wailing Caverns, beyond its first druid strongholds.",
    {WC .. " pp. 1, 5, 7"}, nil, {"dungeon:wailing-caverns"})
Curated("npc:verdan", "Verdan the Everliving", "Person",
    "Verdan the Everliving stood near Lord Serpentis in the depths of the Wailing Caverns.",
    {WC .. " pp. 5, 8"}, {"Verdan"}, {"dungeon:wailing-caverns", "npc:serpentis"})
Curated("npc:mutanus", "Mutanus the Devourer", "Person",
    "Mutanus threatened the ritual to awaken Naralex at Dreamer's Rock, emerging among the nightmare creatures in the caverns.",
    {WC .. " p. 9, awakening ritual"}, {"Mutanus"}, {"dungeon:wailing-caverns", "npc:naralex"})
Curated("npc:mad-magglish", "Mad Magglish", "Person",
    "Mad Magglish fled into the Wailing Caverns with a bottle of ninety-nine-year-old port stolen during a cargo accident. The wine was a gift intended for Gazlowe from Baron Revilgaz.",
    {V .. " #959 Trouble at the Docks"}, {"Magglish"}, {"dungeon:wailing-caverns", "place:ratchet"})
Curated("place:dreamers-rock", "Dreamer's Rock", "Place",
    "Naralex slept at Dreamer's Rock in the Wailing Caverns. His disciple sought to awaken him there.",
    {WC .. " pp. 2, 9"}, nil, {"dungeon:wailing-caverns", "npc:naralex"})
Curated("group:defias",
    "Defias Brotherhood",
    "Group",
    "The Defias Brotherhood is an insurgent band whose grievance began with the rebuilding of Stormwind. Edwin VanCleef led the Stonemasons' Guild that restored the city after the First War. When the nobles refused to pay, he rejected a government post offered to senior workers, led a riot and departed swearing revenge. The craftsmen's dispute became a campaign against the kingdom they had helped rebuild.\n\nVanCleef's followers now prey on Westfall, driving farmers from their land. Beneath Moonbrook, the Deadmines shelter their leadership, workshops and a great warship being constructed with goblin help. The People's Militia investigates their messengers and hidden routes in an effort to find and break their stronghold.\n\nThe threat also reaches inside Stormwind. VanCleef's lieutenant Bazil Thredd is imprisoned in the Stockade, where a violent uprising exposes the Brotherhood's reach within the capital. Unpaid labor explains the movement's origin, but the people bearing the cost of its revenge include the same farmers, guards and tradespeople it might once have claimed to represent.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 141, 389: The Defias Brotherhood; Bazil Thredd)", "https://warcraft.wiki.gg/wiki/Bazil_Thredd_%28quest%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 65, 142: The Defias Brotherhood)", "https://warcraft.wiki.gg/wiki/Record_of_Defias_Activity", "https://warcraft.wiki.gg/wiki/Gilnid", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 389, 391, 388, 65: Bazil Thredd; The Stockade Riots; The Color of Blood; The Defias Brotherhood)"},
    {"the Defias Brotherhood", "The Defias Brotherhood", "Defias", "Defias Gang", "Defias Thieves"},
    {"npc:vancleef", "dungeon:deadmines", "npc:stoutmantle"},
    "Classic / Forever")
Curated("group:stonemasons", "Stonemasons' Guild", "Group",
    "Edwin VanCleef led the Stonemasons' Guild in rebuilding Stormwind after the First War. Mathias Shaw described the guild's dissatisfaction with its treatment after the work, a lead in his investigation of the Defias.",
    {V .. " #135 and #141 The Defias Brotherhood"}, {"Stonemason's Guild", "the Stonemasons' Guild"}, {"npc:vancleef", "npc:mathias-shaw", "group:defias"})
Curated("group:peoples-militia", "The People's Militia", "Group",
    "The People's Militia organized Westfall's defense against the Defias. Its patrols targeted the thieves around the farms and mines while Gryan Stoutmantle sought the Brotherhood's hideout.",
    {V .. " #12 The People's Militia; #65 The Defias Brotherhood"}, {"People's Militia"}, {"npc:stoutmantle", "place:sentinel-hill", "group:defias"})
Curated("npc:mathias-shaw", "Mathias Shaw", "Person",
    "Shaw headed SI:7 from Stormwind's Old Town. His knowledge of the Stonemasons' Guild helped Stoutmantle investigate the origins of the Defias Brotherhood.",
    {V .. " #135 and #141 The Defias Brotherhood"}, {"Master Shaw", "Shaw"}, {"group:stonemasons", "group:defias"})
Curated("npc:vancleef", "Edwin VanCleef", "Person",
    "VanCleef led the Stonemasons' Guild when it rebuilt Stormwind after the First War. Later, evidence gathered by Westfall's militia identified him as the leader of the Defias Brotherhood.",
    {V .. " #141 and #142 The Defias Brotherhood"}, {"VanCleef"}, {"dungeon:deadmines", "group:defias", "group:stonemasons"})
Curated("npc:rhahkzor",
    "Rhahk'Zor",
    "Person",
    "Rhahk'Zor is the ogre foreman of Edwin VanCleef's construction work in the Deadmines. He occupies an early chamber of the Defias stronghold, with two Defias Watchmen nearby. His loyalty is plain when intruders approach: he threatens them with the promise that VanCleef will pay well for their heads.",
    {"https://classicdb.ch/?npc=644", "https://warcraft.wiki.gg/wiki/Rhahk%27Zor", "https://warcraft.wiki.gg/wiki/Deadmines_%28Classic%29"},
    {"Rhahk'zor"},
    {"dungeon:deadmines", "npc:vancleef", "group:defias"},
    "Classic / Forever",
    true)
Curated("npc:sneed",
    "Sneed",
    "Person",
    "Sneed operated a shredder in the Deadmines' timber workshop, amid goblin woodcarvers.",
    {"https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames Deadmines guide) pp. 3, 6"},
    {},
    {"dungeon:deadmines", "npc:sneeds-shredder"},
    "Classic / Forever",
    true)
Curated("npc:sneeds-shredder", "Sneed's Shredder", "Person",
    "Sneed's machine worked inside the Deadmines. Its power supply interested gnomish engineers seeking a working goblin design.",
    {DM .. " pp. 3, 6", V .. " #2040 Underground Assault"}, nil, {"dungeon:deadmines", "npc:sneed"})
Curated("npc:gilnid",
    "Gilnid",
    "Person",
    "Gilnid was the goblin smelter in the Deadmines, beyond the timber workshop.",
    {"https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames Deadmines guide) p. 7"},
    {"Gilnid the Smelter"},
    {"dungeon:deadmines"},
    "Classic / Forever",
    true)
Curated("npc:mr-smite",
    "Mr. Smite",
    "Person",
    "Mr. Smite is the tauren first mate serving Captain Greenskin aboard the Defias vessel in the Deadmines. He guards the approach to the ship in Ironclad Cove, with two concealed Blackguards at the foot of the ramp. His shouted orders raise the alarm and call the crew to repel intruders.\n\nSmite changes weapons as the fight turns against him. Stomps leave his opponents stunned while he arms himself again, eventually bringing out a two-handed hammer. His angry declarations and decision to improvise give the encounter the character of a ship's officer determined to hold his position.",
    {"https://classicdb.ch/?npc=646", "https://www.wowhead.com/classic/npc=646/mr-smite (original NPC title, first-mate identification and Quotes)", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames guide, pp7-8)"},
    {"Mister Smite"},
    {"dungeon:deadmines", "group:defias", "npc:greenskin"},
    "Classic / Forever",
    true)
Curated("npc:greenskin", "Captain Greenskin", "Person",
    "Captain Greenskin patrolled the Defias ship in the Deadmines with pirates at his side.",
    {DM .. " pp. 3, 8"}, {"Greenskin"}, {"dungeon:deadmines", "group:defias"})
Curated("npc:cookie",
    "Cookie",
    "Person",
    "Cookie is the murloc cook aboard the Defias ship hidden in the Deadmines. He serves Captain Greenskin and Edwin VanCleef, whose stronghold occupies the vessel. Found along the ship's lower side, the cook can defend himself with acid and restore his strength through his own cooking.",
    {"https://warcraft.wiki.gg/wiki/Cookie", "https://warcraft.wiki.gg/wiki/Deadmines_%28Classic%29", "https://classicdb.ch/?npc=645"},
    {},
    {"dungeon:deadmines", "npc:greenskin", "npc:vancleef"},
    "Classic / Forever")
Curated("npc:miner-johnson", "Miner Johnson", "Person",
    "Miner Johnson could be found in a side passage of the Deadmines' working tunnels.",
    {DM .. " pp. 3, 5"}, nil, {"dungeon:deadmines"})
Curated("npc:foreman-thistlenettle", "Foreman Thistlenettle", "Person",
    "Thistlenettle's undead remains haunted the outer Deadmines. His brother Wilder sought the foreman's badge as evidence of his fate.",
    {DM .. " p. 3, Oh Brother..."}, nil, {"dungeon:deadmines"})
Curated("npc:rethilgore", "Rethilgore", "Person",
    "Rethilgore was among Shadowfang Keep's inhabitants, wielding magic that drained the soul.",
    {SF .. ": Rethilgore, Soul Drain"}, nil, {"dungeon:shadowfang"})
Curated("npc:razorclaw", "Razorclaw the Butcher", "Person",
    "Razorclaw inhabited Shadowfang Keep, where the butcher's weapons and bloodstained apron marked his trade.",
    {SF .. ": Razorclaw, named equipment"}, {"Razorclaw"}, {"dungeon:shadowfang"})
Curated("npc:silverlaine",
    "Baron Silverlaine",
    "Person",
    "Baron Silverlaine lost his keep and his life to Arugal's worgen. His ghost now haunts Shadowfang Keep's dining room alongside spectral servants. The baron's scepter and the Silverlaine family seal remain among his possessions, reminders of the household that preceded Arugal's rule.",
    {"https://warcraft.wiki.gg/wiki/Innkeeper", "https://warcraft.wiki.gg/wiki/Baron_Silverlaine_%28Classic%29"},
    {"Silverlaine"},
    {"dungeon:shadowfang", "npc:arugal"},
    "Classic / Forever")
Curated("npc:springvale", "Commander Springvale", "Person",
    "Springvale stood among Shadowfang Keep's haunted servants and guardsmen, still wielding healing magic and the Hammer of Justice.",
    {SF .. ": Commander Springvale, Holy Light and Hammer of Justice"}, {"Springvale"}, {"dungeon:shadowfang"})
Curated("npc:odo", "Odo the Blindwatcher", "Person",
    "Odo was found with vile bats in Shadowfang Keep. His howling rage made him one of its dangers.",
    {SF .. ": Odo the Blindwatcher"}, {"Odo"}, {"dungeon:shadowfang"})
Curated("npc:deathsworn-captain", "Deathsworn Captain", "Person",
    "The Deathsworn Captain was an uncommon presence among Shadowfang Keep's inhabitants, armed for close combat.",
    {SF .. ": rare encounter, Cleave and Hamstring"}, nil, {"dungeon:shadowfang"})
Curated("npc:fenrus",
    "Fenrus the Devourer",
    "Person",
    "Fenrus the Devourer is Arugal's enormous pet worg, prowling the main study of Shadowfang Keep. His toxic saliva makes the beast dangerous beyond the force of his bite.\n\nThe encounter also draws out his master's magic. Arugal appears and summons four voidwalkers against the intruders, turning the study into another obstacle on the way through the archmage's stronghold.",
    {"https://classicdb.ch/?npc=4274", "https://warcraft.wiki.gg/wiki/Fenrus (original World of Warcraft section and Toxic Saliva ability)", "https://www.wowhead.com/classic/guide/shadowfang-keep-dungeon-strategy-wow-classic (Fenrus and Toxic Saliva)"},
    {"Fenrus"},
    {"dungeon:shadowfang", "npc:arugal"},
    "Classic / Forever",
    true)
Curated("npc:nandos", "Wolf Master Nandos", "Person",
    "Worgs surrounded Nandos in Shadowfang Keep, and he could call more of them to his aid.",
    {SF .. ": Wolf Master Nandos"}, {"Nandos"}, {"dungeon:shadowfang"})
Curated("npc:adamant", "Deathstalker Adamant", "Person",
    "Adamant and Vincent were sent into Shadowfang Keep to gather intelligence before a Forsaken assault. Their delayed report left the expedition's planners uncertain of what awaited inside.",
    {V .. " #1098 Deathstalkers in Shadowfang"}, {"Adamant"}, {"dungeon:shadowfang", "npc:hadrec", "npc:vincent"})
Curated("npc:vincent", "Deathstalker Vincent", "Person",
    "Vincent scouted Shadowfang Keep alongside Adamant. High Executor Hadrec's operation depended on intelligence from the two Deathstalkers.",
    {V .. " #1098 Deathstalkers in Shadowfang"}, {"Vincent"}, {"dungeon:shadowfang", "npc:adamant", "npc:hadrec"})
Curated("npc:ghamoo-ra",
    "Ghamoo-ra",
    "Person",
    "Ghamoo-ra is a great turtle living in the Pool of Ask'ar within Blackfathom Deeps. He roams a small island in the dungeon's second cavern, surrounded by other turtles.\n\nHis heavy armor makes him difficult to wound, and his trampling attacks threaten those close to him.",
    {"https://www.wowhead.com/classic/guide/blackfathom-deeps-dungeon-strategy-wow-classic (retained Classic roster and armor source)", "https://warcraft.wiki.gg/wiki/Ghamoo-ra_%28Classic%29 (identity and Combat Info only)"},
    {},
    {"dungeon:blackfathom"},
    "Classic / Forever",
    true)
Curated("npc:sarevess", "Lady Sarevess", "Person",
    "Sarevess patrolled Blackfathom Deeps with naga guards, wielding frost and lightning magic.",
    {BF .. ": Lady Sarevess"}, {"Sarevess"}, {"dungeon:blackfathom"})
Curated("npc:gelihast", "Gelihast", "Person",
    "Gelihast occupied a chamber filled with murlocs in Blackfathom Deeps, with an altar behind him.",
    {BF .. ": Gelihast"}, nil, {"dungeon:blackfathom"})
Curated("npc:lorgus-jett", "Lorgus Jett", "Person",
    "Lorgus was a Twilight's Hammer follower whose plans involved crystals containing water elemental spirits. The Earthen Ring feared that his work would help the cult return the Old Gods to power.",
    {V .. " #6564 and #6565 Allegiance to the Old Gods"}, {"Lorgus"}, {"dungeon:blackfathom", "group:twilights-hammer", "npc:jeneu"})
Curated("npc:aquanis", "Baron Aquanis", "Person",
    "Aquanis was a corrupted water elemental in Blackfathom Deeps. Je'neu Sancrea believed the strange globe associated with him could reveal the source and method of his corruption.",
    {V .. " #6922 Baron Aquanis, quest and completion dialogue"}, {"Aquanis"}, {"dungeon:blackfathom", "npc:jeneu"})
Curated("npc:kelris", "Twilight Lord Kelris", "Person",
    "Kelris led the Twilight's Hammer cultists in Blackfathom Deeps. Allied with the naga, his followers sacrificed innocents to Aku'Mai in exchange for power.",
    {V .. " #1200 and #6561 Blackfathom Villainy"}, {"Kelris", "Lord Kelris"}, {"dungeon:blackfathom", "npc:akumai", "group:twilights-hammer"})
Curated("npc:serrakis", "Old Serra'kis", "Person",
    "Old Serra'kis inhabited the submerged reaches of Blackfathom Deeps.",
    {BF .. ": Old Serra'kis"}, {"Serra'kis"}, {"dungeon:blackfathom"})
Curated("npc:akumai", "Aku'mai", "Person",
    "Aku'Mai was a servant of an Old God that rose from Blackfathom's corrupted moonwell. Kelris's cult offered innocent lives to the creature in its pursuit of power.",
    {V .. " #1200 and #6561 Blackfathom Villainy"}, nil, {"dungeon:blackfathom", "npc:kelris"})
Curated("group:twilights-hammer",
    "Twilight's Hammer",
    "Group",
    "The Twilight's Hammer is a cult devoted to the Old Gods and the destruction their return would bring. Its name belonged to an orcish clan led by the ogre-mage Cho'gall during the Horde's early wars. Even then, the clan regarded conquest as a sacred path toward the world's end, placing that belief above loyalty to the Horde.\n\nIts followers now pursue their masters' return across distant parts of Azeroth. In Blackfathom Deeps, Kelris leads cultists allied with naga, sacrificing captives to Aku'Mai. Lorgus Jett seeks power from elemental crystals to restore the Old Gods' rule. Around Blackrock Mountain, worshippers carry symbols of Ragnaros, while Twilight emissaries and torturers work among the Dark Iron dwarves in Blackrock Depths.\n\nIn Silithus, their camps and secret communications draw the attention of the Cenarion Circle. The Circle's forces seek to drive them out while confronting the growing silithid danger. These scattered enclaves give the cult a reach far beyond any one dungeon: each is another foothold for powers that threaten the living world.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6565: Allegiance to the Old Gods)", "https://warcraft.wiki.gg/wiki/Warcraft_II%3A_Tides_of_Darkness_manual", "https://warcraft.wiki.gg/wiki/Twilight_cults", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1200, 6564, 3452: Blackfathom Villainy; Allegiance to the Old Gods; The Flame's Casing)", "https://warcraft.wiki.gg/wiki/The_Blackrock_Depths", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 8287, 8318, 8275: A Terrible Purpose; Secret Communication; Taking Back Silithus)"},
    {"the Twilight's Hammer", "Twilight's Hammer clan", "Twilight's Hammer cult"},
    {"dungeon:blackfathom", "dungeon:blackrock-depths", "faction:cenarion-circle"},
    "Classic / Forever")
Curated("npc:jeneu", "Je'neu Sancrea", "Person",
    "Je'neu represented the Earthen Ring at Zoram'gar Outpost. He studied the corruption of Blackfathom's water elementals and opposed the Twilight's Hammer's use of elemental spirits.",
    {V .. " #6922 Baron Aquanis; #6564 and #6565 Allegiance to the Old Gods"}, {"Je'neu"}, {"dungeon:blackfathom", "npc:aquanis", "npc:lorgus-jett"})
Curated("npc:thaelrid", "Argent Guard Thaelrid", "Person",
    "Thaelrid was an Argent Dawn scout sent to investigate reports of naga and Twilight's Hammer activity in Blackfathom Deeps. His failure to report prompted a search for him.",
    {V .. " #1198 In Search of Thaelrid"}, {"Thaelrid"}, {"dungeon:blackfathom"})
Curated("npc:targorr", "Targorr the Dread", "Person",
    "Targorr served Gath'Ilzogg as an executioner, notorious for torturing captured defenders of the kingdom. His imprisonment in the Stockade and delayed execution angered those seeking justice for his victims.",
    {V .. " #386 What Comes Around..."}, {"Targorr"}, {"dungeon:stockade"})
Curated("npc:kam-deepfury", "Kam Deepfury", "Person",
    "Deepfury was a Dark Iron prisoner in the Stockade. Dwarven intelligence implicated him in the attack on the Thandol Span, leading Longbraid's allies to demand his death.",
    {V .. " #378 The Fury Runs Deep"}, {"Deepfury"}, {"dungeon:stockade"})
Curated("npc:hamhock", "Hamhock", "Person",
    "Hamhock was held in the Stockade, where he fought beside Defias inmates and wielded chain lightning.",
    {ST .. ": Hamhock"}, nil, {"dungeon:stockade"})
Curated("npc:dextren-ward", "Dextren Ward", "Person",
    "Ward was caught selling bodies from Duskwood's cemetery to Morbent Fel. Stormwind imprisoned him in the Stockade despite the death sentence passed in Darkshire, provoking anger at the House of Nobles.",
    {V .. " #377 Crime and Punishment"}, {"Ward"}, {"dungeon:stockade"})
Curated("npc:bazil-thredd",
    "Bazil Thredd",
    "Person",
    "Bazil Thredd is Edwin VanCleef's lieutenant, imprisoned in the Stockade beneath Stormwind. Baros Alexston points investigators toward him in the hope that he knows more about VanCleef's plans. By then, Thredd is leading a prison riot, and Warden Thelwater makes any interview conditional on bringing back the prisoner's head.\n\nThredd's importance extends beyond the uprising. After years without visitors, he has recently received regular calls from a quiet man whose papers give the name Maelik. Thelwater's account of those visits provides another lead into the Defias affair, suggesting that imprisonment has not severed Thredd's useful connections outside the Stockade.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 389)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 391)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 392)"},
    {"Thredd"},
    {"dungeon:stockade", "group:defias", "npc:vancleef"},
    "Classic / Forever")
Curated("npc:bruegal", "Bruegal Ironknuckle", "Person",
    "Bruegal was an uncommon inmate of the Stockade, carrying a prison shank and iron knuckles.",
    {ST .. ": Bruegal Ironknuckle, named equipment"}, {"Bruegal"}, {"dungeon:stockade"})
Curated("npc:grubbis", "Grubbis", "Person",
    "Grubbis emerged from Gnomeregan's caves during Blastmaster Emi Shortfuse's attempt to seal them with explosives.",
    {GN .. ": Grubbis"}, nil, {"dungeon:gnomeregan"})
Curated("npc:viscous-fallout", "Viscous Fallout", "Person",
    "Viscous Fallout roamed the contaminated lower floor of Gnomeregan's Hall of Gears.",
    {GN .. ": Viscous Fallout"}, nil, {"dungeon:gnomeregan"})
Curated("npc:electrocutioner", "Electrocutioner 6000", "Person",
    "Electrocutioner 6000 occupied Gnomeregan's elevated Launch Bay platform. It carried the Workshop Key.",
    {GN .. ": Electrocutioner 6000"}, nil, {"dungeon:gnomeregan"})
Curated("npc:crowd-pummeler", "Crowd Pummeler 9-60", "Person",
    "Crowd Pummeler 9-60 stood on an upper ledge in Gnomeregan's Engineering Labs.",
    {GN .. ": Crowd Pummeler 9-60"}, nil, {"dungeon:gnomeregan"})
Curated("npc:dark-iron-ambassador", "Dark Iron Ambassador", "Person",
    "The Dark Iron Ambassador was an occasional presence in the tunnel leading toward Gnomeregan's Tinkers' Court.",
    {GN .. ": rare encounter, Dark Iron Ambassador"}, nil, {"dungeon:gnomeregan"})
Curated("npc:thermaplugg",
    "Mekgineer Thermaplugg",
    "Person",
    "Mekgineer Thermaplugg is the gnomish engineer who holds power in fallen Gnomeregan. The city remains irradiated, its people scattered from their home. High Tinker Gelbin Mekkatorque once trusted Thermaplugg and now condemns him for betraying both that trust and the gnomish people.\n\nMekkatorque cannot understand why Thermaplugg sacrificed so much for power or wealth he might have gained in time. He calls for the mekgineer's destruction as a step toward reclaiming Gnomeregan. Thermaplugg's rule remains an obstacle to the exiles' return, rather than a restoration of their city.",
    {"https://warcraft.wiki.gg/wiki/Thermaplugg", "https://classicdb.ch/?quest=2929", "https://classicdb.ch/?npc=7800", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2929 The Grand Betrayal; #3361 A Refugee's Quandary"},
    {"Thermaplugg"},
    {"dungeon:gnomeregan", "npc:gelbin", "faction:gnomeregan-exiles"},
    "Classic / Forever",
    true)
Curated("npc:techbot", "Techbot", "Person",
    "Techbot once assisted Gnomeregan's engineers with tools and information. After the city's fall, its behavior reversed, and its creator sought the memory core in the hope of repairing it.",
    {V .. " #2922 Save Techbot's Brain!"}, nil, {"dungeon:gnomeregan"})
Curated("npc:roogug", "Roogug", "Person",
    "Roogug inhabited Razorfen Kraul and commanded an earth elemental. Warrior armor projects required a visit to his stronghold.",
    {RK .. ": Roogug, Brutal Armor and Fire Hardened Mail"}, nil, {"dungeon:razorfen-kraul"})
Curated("npc:aggem", "Aggem Thorncurse", "Person",
    "Aggem fought within Razorfen Kraul, calling a boar spirit to his defense.",
    {RK .. ": Aggem Thorncurse, Summon Boar Spirit"}, {"Aggem"}, {"dungeon:razorfen-kraul"})
Curated("npc:jargba", "Death Speaker Jargba", "Person",
    "Jargba wielded shadow magic in Razorfen Kraul, with the power to turn an opponent's mind against its allies.",
    {RK .. ": Death Speaker Jargba, Dominate Mind"}, {"Jargba"}, {"dungeon:razorfen-kraul"})
Curated("npc:ramtusk", "Overlord Ramtusk", "Person",
    "Ramtusk stood within Razorfen Kraul, flanked by spear-bearing quilboar guards.",
    {RK .. ": Overlord Ramtusk, Razorfen Spearhide guards"}, {"Ramtusk"}, {"dungeon:razorfen-kraul"})
Curated("npc:agathelos", "Agathelos the Raging", "Person",
    "Agathelos was one of Razorfen Kraul's dangers, capable of charging and flying into a rage.",
    {RK .. ": Agathelos the Raging, Rushing Charge and Enrage"}, {"Agathelos"}, {"dungeon:razorfen-kraul"})
Curated("npc:charlga", "Charlga Razorflank", "Person",
    "Charlga gathered an army in Razorfen Kraul. Her forces alarmed researchers near the quilboar stronghold and tauren who remembered being driven from their holy lands in the southern Barrens.",
    {V .. " #1101 The Crone of the Kraul; #1102 A Vengeful Fate"}, {"Charlga", "Razorflank"}, {"dungeon:razorfen-kraul"})
Curated("npc:blind-hunter", "Blind Hunter", "Person",
    "The Blind Hunter was an uncommon inhabitant of Razorfen Kraul's bat cave, its piercing cry capable of silencing spellcasters.",
    {RK .. ": Blind Hunter, Sonic Burst"}, nil, {"dungeon:razorfen-kraul"})
Curated("npc:halmgar", "Earthcaller Halmgar", "Person",
    "Halmgar commanded an earth elemental in Razorfen Kraul and used totems to hinder intruders.",
    {RK .. ": Earthcaller Halmgar, Earthbind Totem"}, {"Halmgar"}, {"dungeon:razorfen-kraul"})

-- The middle leveling route: the Monastery's wings and the second Razorfen.
local SM = "https://www.wowhead.com/classic/guide/scarlet-monastery-dungeon-strategy-wow-classic (Classic wings, roster and abilities)"
local RD = "https://www.wowhead.com/classic/guide/razorfen-downs-dungeon-strategy-wow-classic (Classic roster and events)"
Curated("group:scarlet-crusade",
    "Scarlet Crusade",
    "Group",
    "The Scarlet Crusade is a human religious army formed amid the destruction of Lordaeron by the Scourge. Its members claim the Holy Light's authority in a war to purge the undead from their homeland. The old Scarlet Monastery in Tirisfal, once a place of learning for priests and paladins, has become a fortress of that crusade.\n\nThe purpose has curdled into suspicion of almost everyone outside the order. Raleigh the Devout, a former member, describes innocent people tortured because the Crusaders believe outsiders carry the plague. The Forsaken are hunted along with the Scourge, while living travelers can be condemned regardless of their allegiance. Opposition to undeath offers no protection from the Crusade's zeal.\n\nIts forces extend through Hearthglen and Tyr's Hand, with command in the Scarlet Bastion of Stratholme as well as the Monastery. High Inquisitor Whitemane and Scarlet Commander Mograine dominate the latter stronghold. A deeper corruption hides in Stratholme: the dreadlord Balnazzar wears Grand Crusader Dathrohan's form. A movement proclaiming purity has a demon concealed within its command.",
    {"https://warcraft.wiki.gg/wiki/Scarlet_Monastery_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1050: Mythology of the Titans)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1053, 381: In the Name of the Light; The Scarlet Crusade)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1052, 1053, 6144, 6145: Down the Scarlet Path; In the Name of the Light; The Call to Command; The Crimson Courier)", "https://warcraft.wiki.gg/wiki/Balnazzar_%28Classic%29"},
    {"the Scarlet Crusade"},
    {"dungeon:scarlet-monastery", "npc:whitemane", "npc:balnazzar"},
    "Classic / Forever")
Curated("place:scarlet-graveyard", "Scarlet Monastery Graveyard", "Place",
    "The Monastery's graveyard held undead as well as the living interrogator Vishas.",
    {SM .. ": Graveyard"}, {"Scarlet Graveyard"}, {"dungeon:scarlet-monastery", "npc:vishas", "npc:thalnos"})
Curated("place:scarlet-library", "Scarlet Monastery Library", "Place",
    "The old Monastery's library held works on the titans and the undead. The Scarlet Crusade guarded these stores of knowledge after taking possession of the former paladin seminary.",
    {V .. " #1049 Compendium of the Fallen; #1050 Mythology of the Titans"}, {"Scarlet Library"}, {"dungeon:scarlet-monastery", "npc:doan"})
Curated("place:scarlet-armory", "Scarlet Monastery Armory", "Place",
    "Herod held the Monastery's armory, behind doors opened by the Scarlet Key.",
    {SM .. ": Armory"}, {"Scarlet Armory"}, {"dungeon:scarlet-monastery", "npc:herod"})
Curated("place:scarlet-cathedral", "Scarlet Monastery Cathedral", "Place",
    "Mograine and Whitemane stood at the heart of the Monastery's cathedral wing.",
    {SM .. ": Cathedral"}, {"Scarlet Cathedral"}, {"dungeon:scarlet-monastery", "npc:scarlet-mograine", "npc:whitemane"})
Curated("npc:vishas", "Interrogator Vishas", "Person",
    "Vishas worked in the Monastery's graveyard wing, equipped with a torturing poker and brass knuckles.",
    {SM .. ": Interrogator Vishas, named equipment"}, {"Vishas"}, {"dungeon:scarlet-monastery", "place:scarlet-graveyard"})
Curated("npc:thalnos", "Bloodmage Thalnos", "Person",
    "Thalnos haunted the Monastery's graveyard wing, wielding spells of fire and shadow.",
    {SM .. ": Bloodmage Thalnos", C .. " Scarlet Monastery catalogue: undead identity"}, {"Thalnos"}, {"dungeon:scarlet-monastery", "place:scarlet-graveyard"})
Curated("npc:azshir", "Azshir the Sleepless", "Person",
    "Azshir was an uncommon presence in the Monastery's graveyard, draining souls and spreading terror.",
    {SM .. ": Azshir the Sleepless, Soul Siphon and Terrify"}, {"Azshir"}, {"dungeon:scarlet-monastery", "place:scarlet-graveyard"})
Curated("npc:fallen-champion", "Fallen Champion", "Person",
    "The Fallen Champion was an uncommon warrior among the Monastery graveyard's dead.",
    {SM .. ": Graveyard rares, Fallen Champion"}, nil, {"dungeon:scarlet-monastery", "place:scarlet-graveyard"})
Curated("npc:ironspine", "Ironspine", "Person",
    "Ironspine was an uncommon inhabitant of the Monastery's graveyard, surrounded by poisonous fumes.",
    {SM .. ": Ironspine, Poison Cloud"}, nil, {"dungeon:scarlet-monastery", "place:scarlet-graveyard"})
Curated("npc:loksey",
    "Houndmaster Loksey",
    "Person",
    "Houndmaster Loksey trains and commands the Scarlet Crusade's tracking hounds in the Library wing of Scarlet Monastery. Three hounds accompany him in the Huntsman's Cloister, and his command to release them turns his work as a trainer into the defense of the monastery.\n\nLoksey is also counted among the Crusade's senior officers. Varimathras orders his death along with Whitemane, Mograine and Herod to weaken a dangerous enemy of the Forsaken. In Southshore, the former Crusader Raleigh the Devout seeks the same leaders' destruction for a different reason: the Crusade has begun treating outsiders as plague victims and torturing innocents. Both campaigns place Loksey among the officials whose removal could break the monastery's regime.",
    {"https://www.wowhead.com/classic/npc=3974/houndmaster-loksey", "https://warcraft.wiki.gg/wiki/Houndmaster_Loksey_%28tactics%29 (original Library encounter and aggro dialogue)", "https://classicdb.ch/?quest=1048", "https://classicdb.ch/?quest=1053", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1048 Into The Scarlet Monastery; #1053 In the Name of the Light"},
    {"Loksey"},
    {"dungeon:scarlet-monastery", "group:scarlet-crusade"},
    "Classic / Forever",
    true)
Curated("npc:doan",
    "Arcanist Doan",
    "Person",
    "Arcanist Doan is the Scarlet Crusade's human mage guarding the Scarlet Monastery Library. He occupies the Athenaeum at its far end, where his strongbox holds the Scarlet Key. His position places an arcane defender among the Crusade's religious zealots.\n\nDoan answers intruders with polymorphs, silence and bursts of arcane power. His most dangerous defense combines a protective Arcane Bubble with a fiery Detonation, shielding him while the blast threatens those nearby. The Library's keeper is therefore a formidable spellcaster as well as the guardian of its key.",
    {"https://warcraft.wiki.gg/wiki/Arcanist_Doan (original Library identity and encounter abilities only)", "https://warcraft.wiki.gg/wiki/Doan%27s_Strongbox", "https://classicdb.ch/?npc=6487", "https://www.wowhead.com/classic/guide/scarlet-monastery-dungeon-strategy-wow-classic (preserved original source: Arcanist Doan)"},
    {"Doan"},
    {"dungeon:scarlet-monastery", "place:scarlet-library"},
    "Classic / Forever",
    true)
Curated("npc:herod", "Herod", "Person",
    "Herod bore the title of Scarlet Champion. His standing within the Crusade made him a target for both the Forsaken and those who opposed the order in the name of the Light.",
    {V .. " #1048 Into The Scarlet Monastery; #1053 In the Name of the Light"}, {"Herod the Scarlet Champion", "Herod, the Scarlet Champion"}, {"dungeon:scarlet-monastery", "place:scarlet-armory", "group:scarlet-crusade"})
Curated("npc:scarlet-mograine",
    "Scarlet Commander Mograine",
    "Person",
    "Renault Mograine, the Scarlet Commander, is one of the highest-ranking officers in the Scarlet Monastery. Both the Forsaken and Raleigh the Devout seek his death. Raleigh, a former Crusader, accuses the order's leaders of allowing their fear of the plague to become persecution: people outside the Crusade's ranks are treated as enemies, and innocent captives suffer for it.\n\nMograine guards the monastery's cathedral with High Inquisitor Whitemane. When he falls in battle, she puts the attackers to sleep and resurrects him; the two then fight together. He murdered his father, Alexandros; Corrupted Ashbringer's return summons the father's spirit to kill him.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1048, 1053)", "https://warcraft.wiki.gg/wiki/High_Inquisitor_Whitemane_%28Classic%29", "https://warcraft.wiki.gg/wiki/Corrupted_Ashbringer/Scarlet_Monastery_Event"},
    {"Commander Mograine", "Renault Mograine"},
    {"dungeon:scarlet-monastery", "npc:whitemane", "npc:highlord-mograine"},
    "Classic / Forever")
Curated("npc:whitemane", "High Inquisitor Whitemane", "Person",
    "Whitemane was a leader of the Scarlet Monastery. Forsaken orders singled her out with her top lieutenants, while a former Crusader blamed the order's highest officers for its persecution of innocents.",
    {V .. " #1048 Into The Scarlet Monastery; #1053 In the Name of the Light"}, {"Whitemane"}, {"dungeon:scarlet-monastery", "place:scarlet-cathedral", "group:scarlet-crusade"})
Curated("npc:fairbanks", "High Inquisitor Fairbanks", "Person",
    "Fairbanks lay within the Monastery's cathedral wing, wielding curses, sleep magic and healing spells.",
    {SM .. ": High Inquisitor Fairbanks"}, {"Fairbanks"}, {"dungeon:scarlet-monastery", "place:scarlet-cathedral"})
Curated("npc:tutenkash", "Tuten'kash", "Person",
    "The sounding of a gong in Razorfen Downs drew waves of spiders, followed by Tuten'kash.",
    {RD .. ": Tuten'kash, gong event"}, nil, {"dungeon:razorfen-downs"})
Curated("npc:mordresh", "Mordresh Fire Eye", "Person",
    "Mordresh stood by a mound of bones in Razorfen Downs, surrounded by dancing skeletons and wielding fire magic.",
    {RD .. ": Mordresh Fire Eye"}, {"Mordresh"}, {"dungeon:razorfen-downs"})
Curated("npc:glutton", "Glutton", "Person",
    "Glutton inhabited Razorfen Downs, spreading clouds of disease around him.",
    {RD .. ": Glutton, Disease Cloud"}, nil, {"dungeon:razorfen-downs"})
Curated("npc:ragglesnout", "Ragglesnout", "Person",
    "Ragglesnout was an uncommon presence in Razorfen Downs, using shadow magic, healing and domination of the mind.",
    {RD .. ": Ragglesnout"}, nil, {"dungeon:razorfen-downs"})
Curated("npc:amnennar", "Amnennar the Coldbringer", "Person",
    "The lich Amnennar ruled the quilboar of Razorfen Downs after their alliance with the Scourge. Forsaken reports described his mental control over them and a direct telepathic link to Ner'zhul.",
    {V .. " #3341 Bring the End; #3636 Bring the Light"}, {"Amnennar", "the Coldbringer"}, {"dungeon:razorfen-downs"})
Curated("npc:plaguemaw", "Plaguemaw the Rotting", "Person",
    "Plaguemaw threatened Belnistrasz's ritual in Razorfen Downs, following the creatures drawn to disrupt his work.",
    {RD .. ": Plaguemaw the Rotting event"}, {"Plaguemaw"}, {"dungeon:razorfen-downs"})

-- Later leveling: ancient vaults, Sandfury territory and the corrupted caverns.
local UL = "https://www.wowhead.com/classic/guide/uldaman-dungeon-strategy-wow-classic (Classic roster and locations)"
local ZF = "https://www.wowhead.com/classic/guide/zulfarrak-dungeon-strategy-wow-classic (Classic roster and events)"
local MA = "https://www.wowhead.com/classic/guide/maraudon-dungeon-strategy-wow-classic (Classic roster and locations)"
local AT = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery)"
Curated("npc:revelosh", "Revelosh", "Person",
    "Revelosh was a trogg in Uldaman who carried the Shaft of Tsol, part of the Staff of Prehistoria.",
    {UL .. ": Revelosh"}, nil, {"dungeon:uldaman", "npc:ironaya"})
Curated("npc:baelog", "Baelog", "Person",
    "Baelog was one of Uldaman's three lost dwarves, friendly to Alliance visitors and hostile to the Horde.",
    {UL .. ": The Lost Dwarves"}, nil, {"dungeon:uldaman", "npc:olaf", "npc:eric-swift"})
Curated("npc:eric-swift", "Eric the Swift", "Person",
    "Eric accompanied Baelog and Olaf in Uldaman, carrying the distinctive equipment of the lost dwarves.",
    {UL .. ": The Lost Dwarves"}, {"Eric \"The Swift\""}, {"dungeon:uldaman", "npc:baelog", "npc:olaf"})
Curated("npc:olaf", "Olaf", "Person",
    "Olaf was one of Uldaman's lost dwarves, bearing a shield with unusual protective properties.",
    {UL .. ": The Lost Dwarves, Olaf's All Purpose Shield"}, nil, {"dungeon:uldaman", "npc:baelog", "npc:eric-swift"})
Curated("npc:ironaya",
    "Ironaya",
    "Person",
    "Ironaya is the ancient female giant guarding the Chamber of Khaz'mul within Uldaman. Her sealed room lies beside the Map Chamber, where a miniature city conceals a mechanism for opening the way. The Staff of Prehistoria, assembled from the Shaft of Tsol and Gni'kiv Medallion, activates the model and directs a beam toward the chamber. When the door opens, Ironaya emerges to confront the intruders. Her encounter is one of the first signs that the buried complex's ancient guardians still answer its machinery.",
    {"https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/uldaman/uldaman_lr.pdf", "https://warcraft.wiki.gg/wiki/Map_Chamber", "https://warcraft.wiki.gg/wiki/Chamber_of_Khaz%27mul"},
    {},
    {"dungeon:uldaman", "npc:revelosh"},
    "Classic / Forever")
Curated("npc:obsidian-sentinel", "Obsidian Sentinel", "Person",
    "The Obsidian Sentinel was a golem near Uldaman's rear entrance, shedding animated shards when threatened.",
    {UL .. ": Obsidian Sentinel"}, nil, {"dungeon:uldaman"})
Curated("npc:ancient-stone-keeper", "Ancient Stone Keeper", "Person",
    "The Ancient Stone Keeper was a golem in Uldaman whose sandstorms hindered movement and spellcasting.",
    {UL .. ": Ancient Stone Keeper"}, nil, {"dungeon:uldaman"})
Curated("npc:galgann", "Galgann Firehammer", "Person",
    "Galgann was a Dark Iron dwarf in Uldaman, wielding fire magic alongside Shadowforge geologists.",
    {UL .. ": Galgann Firehammer"}, {"Galgann"}, {"dungeon:uldaman"})
Curated("npc:grimlok",
    "Grimlok",
    "Person",
    "Grimlok is the Stonevault trogg chieftain in Uldaman, accompanied by his followers and a basilisk. Among the treasures he has claimed is the sapphire from a shattered magical necklace.\n\nA dead paladin's journal traces the necklace's scattered gems through Uldaman: the Shadowforge dwarves hid its ruby, other troggs stashed its topaz, and Grimlok took the sapphire for himself. His possession of the gem makes him an obstacle to those seeking to restore the necklace's magic.",
    {"https://classicdb.ch/?npc=4854", "https://warcraft.wiki.gg/wiki/Grimlok", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2200 Back to Uldaman; #2339 Find the Gems and Power Source"},
    {},
    {"dungeon:uldaman", "npc:talvash-del-kissel"},
    "Classic / Forever",
    true)
Curated("npc:archaedas",
    "Archaedas",
    "Person",
    "Archaedas, the Ancient Stone Watcher, stands in Uldaman's depths as a guardian of the Discs of Norgannon. His challenge invokes the Makers, and he commands his awakened servants to defend the discs. Earthen guardians and vault warders rise at his call, turning the surrounding stone figures into an army against intruders.\n\nBeyond this defense lies the knowledge he protects: platinum records of the Creators' work and the histories of earthen, troggs and dwarves, explained by a separate stone watcher. Archaedas guards that legacy; he is not the figure who interprets it for explorers.",
    {"https://warcraft.wiki.gg/wiki/Archaedas_%28tactics%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2278)"},
    {"Archaedas the Ancient Stone Watcher"},
    {"dungeon:uldaman", "relic:discs-norgannon"},
    "Classic / Forever")
Curated("npc:shovelphlange", "Digmaster Shovelphlange", "Person",
    "Shovelphlange was a goblin sometimes found patrolling Uldaman's outer caverns, before the inner vaults.",
    {UL .. ": Digmaster Shovelphlange"}, {"Shovelphlange"}, {"dungeon:uldaman"})
Curated("relic:discs-norgannon", "Discs of Norgannon", "Relic",
    "The platinum discs stored accounts of the Creators' work and the history of the earthen, troggs and dwarves. A stone watcher explained the records and could provide a portable copy for further study.",
    {V .. " #2278, #2279 and #2280 The Platinum Discs"}, {"the Discs of Norgannon", "The Platinum Discs"}, {"dungeon:uldaman"})
Curated("npc:antusul",
    "Antu'sul",
    "Person",
    "Antu'sul was a Sandfury overseer in Zul'Farrak, calling Sul'lithuz creatures and totems to his aid.",
    {"https://www.wowhead.com/classic/guide/zulfarrak-dungeon-strategy-wow-classic (Classic roster and events): Antu'sul, Overseer of Sul"},
    {},
    {"dungeon:zulfarrak"},
    "Classic / Forever",
    true)
Curated("npc:theka", "Theka the Martyr", "Person",
    "Theka occupied Zul'Farrak's scarab chamber, where a tablet preserved knowledge sought by Master Gadrin.",
    {ZF .. ": Theka the Martyr; The Spider God"}, {"Theka"}, {"dungeon:zulfarrak", "npc:gadrin"})
Curated("npc:zumrah", "Witch Doctor Zum'rah", "Person",
    "Zum'rah used shadow magic and raised zombies from graves within Zul'Farrak.",
    {ZF .. ": Witch Doctor Zum'rah"}, {"Zum'rah"}, {"dungeon:zulfarrak"})
Curated("npc:nekrum", "Nekrum Gutchewer", "Person",
    "Nekrum possessed a medallion rumored to grant unnatural longevity at a terrible cost. The seer investigating Sharpbeak's disappearance sought it for study before agreeing to locate the missing gryphon.",
    {V .. " #2991 Nekrum's Medallion"}, {"Nekrum"}, {"dungeon:zulfarrak"})
Curated("npc:sezzziz", "Shadowpriest Sezz'ziz", "Person",
    "Sezz'ziz fought beside Nekrum at Zul'Farrak's great stairway, wielding shadow and healing magic.",
    {ZF .. ": Nekrum Gutchewer and Shadowpriest Sezz'ziz"}, {"Sezz'ziz"}, {"dungeon:zulfarrak", "npc:nekrum"})
Curated("npc:sergeant-bly", "Sergeant Bly", "Person",
    "Bly led a band of treasure hunters into Zul'Farrak. The owner of a divino-matic rod accused him of taking the instrument after promising only to borrow it.",
    {V .. " #2768 Divino-matic Rod"}, {"Bly"}, {"dungeon:zulfarrak"})
Curated("npc:velratha", "Hydromancer Velratha", "Person",
    "Velratha coveted the Tiara of the Deep for its magical power. Its owner accused her of sending thieves to steal it, then sought help recovering the jewel from Zul'Farrak.",
    {V .. " #2846 Tiara of the Deep"}, {"Velratha"}, {"dungeon:zulfarrak"})
Curated("npc:ukorz", "Chief Ukorz Sandscalp", "Person",
    "Ukorz was a Sandfury chief in Zul'Farrak, with Ruuzlu fighting at his side.",
    {ZF .. ": Chief Ukorz Sandscalp"}, {"Ukorz", "Ukorz Sandscalp"}, {"dungeon:zulfarrak", "npc:ruuzlu"})
Curated("npc:ruuzlu", "Ruuzlu", "Person",
    "Ruuzlu accompanied Chief Ukorz Sandscalp in Zul'Farrak, defending the chieftain's position.",
    {ZF .. ": Chief Ukorz Sandscalp, paired encounter"}, nil, {"dungeon:zulfarrak", "npc:ukorz"})
Curated("npc:zerillis", "Zerillis", "Person",
    "Zerillis was a Sandfury marksman sometimes found patrolling Zul'Farrak, equipped with a net and frost shot.",
    {ZF .. ": Zerillis"}, nil, {"dungeon:zulfarrak"})
Curated("npc:gahzrilla",
    "Gahz'rilla",
    "Person",
    "Gahz'rilla is the great hydra summoned by the sand trolls from a sacred pool in Zul'Farrak. The trolls worshipped it as a deity and carved ornaments in its likeness. Those scattered carvings still draw the interest of researchers in Tanaris.\n\nThe hydra's scales hold another attraction: they crackle with energy that a mechanic hopes to harness for a car. Reaching the creature requires discovering the trolls' guarded summoning secret, bringing an outsider's engineering ambitions into contact with their sacred beast.",
    {"https://classicdb.ch/?quest=2770", "https://classicdb.ch/?quest=3161"},
    {},
    {"dungeon:zulfarrak"},
    "Classic / Forever",
    true)
Curated("npc:noxxion", "Noxxion", "Person",
    "Lord Vyletongue created Noxxion as a living embodiment of his corruption. Noxxion dwelled beyond Maraudon's orange crystals and held one of the stolen pieces of Celebras's scepter.",
    {V .. " #7044 Legends of Maraudon"}, nil, {"dungeon:maraudon", "npc:vyletongue", "npc:celebras"})
Curated("npc:razorlash",
    "Razorlash",
    "Person",
    "Razorlash is a hostile lasher, a plant creature inhabiting Maraudon's Foulspore Cavern. It occupies a cave on the orange-crystal route before the passage into Poison Falls.\n\nIts attacks are physical: a sweeping cleave threatens nearby opponents, while puncturing blows leave wounds that continue to hurt after the strike.",
    {"https://classicdb.ch/?npc=12258", "https://warcraft.wiki.gg/wiki/Razorlash (lasher identity and location only)", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/maraudon/maraudon_lr.pdf (original BradyGames guide, pp4 and10)", "https://www.wowhead.com/classic/guide/maraudon-dungeon-strategy-wow-classic (original route)"},
    {},
    {"dungeon:maraudon"},
    "Classic / Forever",
    true)
Curated("npc:vyletongue", "Lord Vyletongue", "Person",
    "Vyletongue was a satyr whose corruption spread through Maraudon. He dwelled beyond the purple crystals and, with his creation Noxxion, held the two stolen pieces of Celebras's scepter.",
    {V .. " #7044 Legends of Maraudon"}, {"Vyletongue"}, {"dungeon:maraudon", "npc:noxxion", "npc:celebras"})
Curated("npc:celebras", "Celebras the Cursed", "Person",
    "Celebras wandered Maraudon under a curse while the pieces of his scepter lay in Vyletongue's and Noxxion's hands. The scepter had once let him travel quickly through the caverns in his effort to bring peace to his uncle's spirit.",
    {V .. " #7044 Legends of Maraudon; #7046 The Scepter of Celebras"}, {"Celebras", "Celebras the Redeemed"}, {"dungeon:maraudon", "npc:vyletongue", "npc:zaetar"})
Curated("npc:meshlok", "Meshlok the Harvester", "Person",
    "Meshlok was an uncommon presence in the waters of Maraudon's Poison Falls, resembling the cavern's other shambling creatures.",
    {MA .. ": Meshlok the Harvester"}, {"Meshlok"}, {"dungeon:maraudon"})
Curated("npc:landslide", "Landslide", "Person",
    "Landslide inhabited Maraudon's deeper passages and called Theradrim shardlings to his defense.",
    {MA .. ": Landslide"}, nil, {"dungeon:maraudon"})
Curated("npc:gizlock", "Tinkerer Gizlock", "Person",
    "Gizlock was a goblin in Maraudon, defending himself with bombs and a dragon gun.",
    {MA .. ": Tinkerer Gizlock"}, {"Gizlock"}, {"dungeon:maraudon"})
Curated("npc:rotgrip", "Rotgrip", "Person",
    "Rotgrip was a great white crocolisk that patrolled the waters of Zaetar's Cave in Maraudon.",
    {MA .. ": Rotgrip"}, nil, {"dungeon:maraudon", "npc:zaetar"})
Curated("npc:theradras", "Princess Theradras", "Person",
    "Theradras was an elemental power of earth dwelling deep in Maraudon. Her union with Zaetar, a son of Cenarius, gave rise to the centaur, who later killed their father.",
    {V .. " #7064 and #7065 Corruption of Earth and Seed"}, {"Theradras"}, {"dungeon:maraudon", "npc:zaetar"})
Curated("npc:zaetar", "Zaetar", "Person",
    "Zaetar was the first son of Cenarius. The centaur descended from his union with Theradras and killed him; his remains became the object of an expedition into Maraudon.",
    {V .. " #7064 and #7065 Corruption of Earth and Seed"}, nil, {"dungeon:maraudon", "npc:theradras", "npc:celebras"})
Curated("group:atalai", "Atal'ai", "Group",
    "The Atal'ai followed Jammal'an's prophecy that summoning Hakkar would grant them immortality. A dissenter exiled from the tribe feared the promise was manipulation and sought the prophet's removal.",
    {V .. " #1446 Jammal'an the Prophet"}, {"the Atal'ai"}, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:atalalarion",
    "Atal'alarion",
    "Person",
    "Atal'alarion guarded the temple's idol, summoned through the statues overlooking the Pit of Refuse.",
    {"https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Guardian of the Idol, statue ritual"},
    {},
    {"dungeon:atalhakkar"},
    "Classic / Forever",
    true)
Curated("npc:loro", "Loro", "Person",
    "Loro was one of six Atal'ai defenders whose balconies protected the way to Jammal'an.",
    {AT .. ": Atal'ai Defenders"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:gasher", "Gasher", "Person",
    "Gasher was an Atal'ai defender on the temple's ring of balconies.",
    {AT .. ": Gasher, Dual Wield"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:mijan", "Mijan", "Person",
    "Mijan protected an Atal'ai balcony in the temple, using a healing ward.",
    {AT .. ": Mijan, Greater Healing Ward"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:zolo", "Zolo", "Person",
    "Zolo defended the Atal'ai temple with lightning and a totem that summoned skeletons.",
    {AT .. ": Zolo"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:zullor", "Zul'Lor", "Person",
    "Zul'Lor was an Atal'ai defender on the temple's balconies, weakening intruders with magic.",
    {AT .. ": Zul'lor, Frailty"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:hukku", "Hukku", "Person",
    "Hukku guarded an Atal'ai balcony with shadow magic and summoned demons.",
    {AT .. ": Hukku"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:jammalan",
    "Jammal'an the Prophet",
    "Person",
    "Jammal'an the Prophet is the jungle troll spiritual leader of the Atal'ai in the Temple of Atal'Hakkar, deep in the Swamp of Sorrows. He preaches that summoning Hakkar will grant his people immortality.\n\nAn Atal'ai dissenter who urged caution was exiled. Now living among the Witherbark in the Hinterlands, the exile questions the prophecy and seeks Jammal'an's death.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1446 Jammal'an the Prophet", "https://warcraft.wiki.gg/wiki/Jammal%27an_the_Prophet (identity/location only; no Adventure Guide or RPG section)"},
    {"Jammal'an"},
    {"dungeon:atalhakkar", "group:atalai", "npc:avatar-hakkar"},
    "Classic / Forever",
    true)
Curated("npc:ogom", "Ogom the Wretched", "Person",
    "Ogom assisted Jammal'an in the temple's Lair of the Chosen, wielding shadow spells.",
    {AT .. ": Jammal'an and Ogom"}, {"Ogom"}, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:dreamscythe", "Dreamscythe", "Person",
    "Dreamscythe and Weaver were drakes in the sunken temple's Pit of Sacrifice.",
    {AT .. ": Weaver and Dreamscythe"}, nil, {"dungeon:atalhakkar", "npc:weaver"})
Curated("npc:weaver", "Weaver", "Person",
    "Weaver shared the temple's Pit of Sacrifice with the drake Dreamscythe.",
    {AT .. ": Weaver and Dreamscythe"}, nil, {"dungeon:atalhakkar", "npc:dreamscythe"})
Curated("npc:morphaz",
    "Morphaz",
    "Person",
    "Morphaz is a green drake in the Temple of Atal'Hakkar, encountered with Hazzas near the Chamber of the Dreamer. Several teachers send their pupils after him for different reasons. Ogtinc asks hunters for his tooth as a lesson in the strength of companions, while rogues seek the Azure Key he is said to possess for Lord Ravenholdt.\n\nArchmage Xylem has a more personal grievance. He says Morphaz ambushed him years earlier and swallowed his apprentice, along with a valuable arcane shard. Xylem wants the shard recovered; the quest's conclusion reveals that years within the drake have increased its power.\n\nMorphaz also matters to the effort to heal Felwood. Ogtinc reports that druids died discovering his resistance to poison and disease, and sends priests to obtain his blood for Greta Mosshoof. Combined with other ingredients, it offers the Cenarion Circle a means to begin restoring the region's afflicted trees and creatures.",
    {"https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Hazzas and Morphaz", "https://classicdb.ch/?quest=8232", "https://classicdb.ch/?quest=8253", "https://classicdb.ch/?quest=8257", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8232 The Green Drake; #8236 The Azure Key; #8253 Destroy Morphaz; #8257 Blood of Morphaz"},
    {},
    {"dungeon:atalhakkar", "npc:hazzas", "npc:xylem"},
    "Classic / Forever",
    true)
Curated("npc:hazzas", "Hazzas", "Person",
    "Hazzas stood with Morphaz in the passage outside the Chamber of the Dreamer.",
    {AT .. ": Hazzas and Morphaz"}, nil, {"dungeon:atalhakkar", "npc:morphaz"})
Curated("npc:avatar-hakkar", "Avatar of Hakkar", "Person",
    "The avatar was a manifestation of Hakkar called into the world through a ritual in the sunken temple. The rite required Hakkari blood to extinguish the flames holding the god's spirit.",
    {V .. " #3528 The God Hakkar"}, nil, {"dungeon:atalhakkar", "npc:jammalan"})
Curated("npc:shade-eranikus", "Shade of Eranikus", "Person",
    "Eranikus of the Green Dragonflight guarded the temple against the return of the trolls' god. His charge ended in corruption, and a gem bearing part of his essence carried his plea for release.",
    {V .. " #3373 and #3374 The Essence of Eranikus"}, {"Eranikus"}, {"dungeon:atalhakkar"})

-- Level 50-60 encounter index. These concise entries retain the limits of the
-- evidence: a roster establishes a location, not an invented personal history.
local BD = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic"
local BC = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic"
local LB = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic"
local UB = "https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic"
local DE = "https://www.wowhead.com/classic/guide/dire-maul-east-dungeon-strategy-wow-classic"
local DW = "https://www.wowhead.com/classic/guide/dire-maul-west-dungeon-strategy-wow-classic"
local DN = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic"
local DO = "https://www.wowhead.com/classic/guide/dire-maul-dungeon-strategy-wow-classic"
local SL = "https://www.wowhead.com/classic/guide/stratholme-live-dungeon-strategy-wow-classic"
local SU = "https://www.wowhead.com/classic/guide/stratholme-undead-dungeon-strategy-wow-classic"
local SC = "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic"
local function Encounter(id, title, body, source, dungeon, names)
    Curated("npc:" .. id, title, "Person", body, {source .. " (" .. title .. ")"}, names, {"dungeon:" .. dungeon})
end
Encounter("roccor", "Lord Roccor", "An elemental roaming the Detention Block of Blackrock Depths.", BD, "blackrock-depths")
Encounter("gerstahn", "High Interrogator Gerstahn", "Gerstahn carried the key to Blackrock Depths' prison cells.", BD, "blackrock-depths")
Encounter("grebmar", "Houndmaster Grebmar", "Grebmar patrolled among the hounds in Blackrock Depths.", BD, "blackrock-depths")
Curated("npc:gorosh",
    "Gorosh the Dervish",
    "Person",
    "Gorosh the Dervish is an orc warrior and one of the champions who fight in the Ring of Law, the arena of Blackrock Depths. High Justice Grimstone presides over the spectacle, sentencing intruders to death.\n\nGorosh carries out the arena's violent judgment with whirling weapon strikes and blows that impede healing.",
    {"https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (retained encounter source)", "https://warcraft.wiki.gg/wiki/Gorosh_the_Dervish (identity, lead and original abilities)", "https://warcraft.wiki.gg/wiki/Ring_of_Law (lead and Final Verdict roster)", "https://warcraft.wiki.gg/wiki/High_Justice_Grimstone (original Ring of Law Quotes only)"},
    {},
    {"dungeon:blackrock-depths"},
    "Classic / Forever",
    true)
Encounter("grizzle", "Grizzle", "A champion of Blackrock Depths' Ring of the Law.", BD, "blackrock-depths")
Encounter("eviscerator", "Eviscerator", "A Ring of the Law champion wielding shadow magic.", BD, "blackrock-depths")
Encounter("okthor", "Ok'thor the Breaker", "A spellcasting champion in the Ring of the Law.", BD, "blackrock-depths")
Encounter("anubshiah", "Anub'shiah", "A Ring of the Law champion using curses and webs.", BD, "blackrock-depths")
Encounter("hedrum", "Hedrum the Creeper", "A venomous champion in the Ring of the Law.", BD, "blackrock-depths")
Encounter("theldren", "Theldren", "The Banner of Provocation summoned Theldren to the arena.", BD, "blackrock-depths")
Encounter("loregrain", "Pyromancer Loregrain", "A fire-wielding opponent near the Shrine of Thaurissan.", BD, "blackrock-depths")
Curated("npc:baelgar",
    "Bael'Gar",
    "Person",
    "Bael'Gar is a molten giant on the Dark Iron Highway in Blackrock Depths. In battle, he calls fiery spawn to his aid, making his own elemental power a source of further attackers.\n\nCyrus Therepentous describes him as a creature born from Ragnaros's fires and covets the heat within him. He offers a reward for a piece of Bael'Gar's inner flame, providing a molt with which to extract it safely from the giant's remains. The commission draws hunters to Bael'Gar for the fiery essence he contains.",
    {"https://warcraft.wiki.gg/wiki/Bael%27Gar (introductory original identity and Summon Spawn ability; exclude Adventure Guide)", "https://classicdb.ch/?quest=4024", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4024 A Taste of Flame"},
    {"Bael'gar"},
    {"dungeon:blackrock-depths", "npc:ragnaros"},
    "Classic / Forever",
    true)
Encounter("stilgiss", "Warder Stilgiss", "A frost-wielding guardian of the Vault, accompanied by Verek.", BD, "blackrock-depths")
Encounter("verek", "Verek", "Verek accompanied Warder Stilgiss in Blackrock Depths' Vault.", BD, "blackrock-depths")
Encounter("doomgrip", "Watchman Doomgrip", "Opening the Vault's coffers roused Doomgrip and its stone guardians.", BD, "blackrock-depths")
Encounter("angerforge", "General Angerforge", "Angerforge commanded reinforcements in Blackrock Depths' West Garrison.", BC, "blackrock-depths")
Encounter("hurley", "Hurley Blackbreath", "Hurley answered disturbances among the Grim Guzzler's stored kegs.", BC, "blackrock-depths")
Encounter("ribbly", "Ribbly Screwspigot", "Ribbly could be found in the Grim Guzzler tavern.", BC, "blackrock-depths")
Encounter("plugger", "Plugger Spazzring", "Plugger sold ale in the Grim Guzzler.", BC, "blackrock-depths")
Curated("npc:phalanx",
    "Phalanx",
    "Person",
    "Phalanx is a golem guarding the Grim Guzzler, the tavern within Blackrock Depths. He is friendly while the bar remains peaceful, but acts as its guard when violence or property damage disturbs the room. His refusal of idle conversation suits a creature whose role is to keep order rather than entertain the patrons.",
    {"https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (retained encounter source)", "https://warcraft.wiki.gg/wiki/Phalanx_%28golem%29 (lead, behavior and original gossip/quotes; no Adventure Guide)"},
    {"Phalanx (Grim Guzzler)"},
    {"dungeon:blackrock-depths"},
    "Classic / Forever",
    true)
Curated("npc:flamelash",
    "Ambassador Flamelash",
    "Person",
    "Ambassador Flamelash is a flamewaker in the Chamber of Enchantment within Blackrock Depths. The fiery, serpentine being inhabits the Dark Iron city's inner chambers, where burning spirits gather around him.",
    {"https://classicdb.ch/?npc=9156", "https://warcraft.wiki.gg/wiki/Ambassador_Flamelash", "https://warcraft.wiki.gg/wiki/Chamber_of_Enchantment"},
    {},
    {},
    "Classic / Forever",
    true)
Encounter("panzor", "Panzor the Invincible", "A rare guardian of the Mold Foundry.", BC, "blackrock-depths")
Encounter("haterel", "Hate'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("angerrel", "Anger'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("vilerel", "Vile'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("gloomrel", "Gloom'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("seethrel", "Seeth'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("doomrel", "Doom'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("doperel", "Dope'rel", "One of seven dwarven spirits in the Summoners' Tomb.", BC, "blackrock-depths")
Encounter("magmus", "Magmus", "Magmus stood before the Imperial Seat amid fire-belching statues.", BC, "blackrock-depths")
Curated("npc:dagran",
    "Emperor Dagran Thaurissan",
    "Person",
    "Emperor Dagran Thaurissan rules the Dark Iron dwarves from the Imperial Seat in Blackrock Depths. His feud with King Magni Bronzebeard becomes a crisis for Ironforge when Magni's daughter Moira remains with the emperor. Convinced that Dagran controls her through a spell, Magni calls for his death and insists that Moira be spared, even if she resists the attempted rescue.\n\nMoira's response challenges her father's account. In the rescue quest, she mourns Dagran, calls him honorable and reveals that she is carrying his child. She demands that Magni be told Ironforge's heir will be a Dark Iron dwarf, regardless of his approval. Dagran's death thus fails to settle the conflict as Magni intended: the emperor's place in Moira's life and their unborn heir turn a mission to recover the princess into a dynastic crisis.",
    {"https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Emperor Dagran Thaurissan)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4362 The Fate of the Kingdom; #4363 The Princess's Surprise"},
    {"Dagran Thaurissan"},
    {"dungeon:blackrock-depths", "npc:magni", "npc:moira"},
    "Classic / Forever",
    true)
Encounter("fineous", "Fineous Darkvire", "Fineous carried Ironfel through the Hall of Crafting. Franclorn Forgewright sought the hammer's return to his statue in the Shrine of Thaurissan, where it could unlock the Shadowforge Key.", V .. " #3802 Dark Iron Legacy", "blackrock-depths")
Encounter("incendius", "Lord Incendius", "Jalinda Sprig described Incendius as a supposed servant of Ragnaros, able to raise Overmaster Pyron from his ashes. She feared the pair were obstructing expeditions into Blackrock Depths.", V .. " #4263 Incendius!", "blackrock-depths")
Encounter("argelmach", "Golem Lord Argelmach", "Argelmach's creations guarded his workshop. When a returned head proved mechanical, Lotwil suspected that another constructed likeness would replace it: the machines concealed a threat beyond a single body.", V .. " #4063 The Rise of the Machines", "blackrock-depths")
Encounter("moira", "Princess Moira Bronzebeard", "Moira called Emperor Thaurissan her husband and spoke of their unborn child as an heir to Ironforge. Her account complicated the rescue orders issued against the emperor.", V .. " #4003 The Royal Rescue; #4004 The Princess Saved?", "blackrock-depths", {"Moira Bronzebeard", "Princess Moira"})
Encounter("spirestone-butcher", "Spirestone Butcher", "A rare ogre patrolling the approach to Mok'Doom.", LB, "lower-blackrock-spire")
Encounter("spirestone-battle-lord", "Spirestone Battle Lord", "A rare ogre near Highlord Omokk's chamber.", LB, "lower-blackrock-spire")
Curated("npc:omokk",
    "Highlord Omokk",
    "Person",
    "Highlord Omokk rules the Spirestone ogres in Lower Blackrock Spire. He occupies Mok'Doom, the ogres' chamber in the lower citadel, and is counted among the generals commanding the fortress's forces. His title belongs to a local ogre ruler within the occupied mountain, where the Spirestone clan holds territory alongside other warbands.",
    {"https://classicdb.ch/?npc=9196", "https://classicdb.ch/?quest=4742", "https://warcraft.wiki.gg/wiki/Spirestone_clan", "https://warcraft.wiki.gg/wiki/Warosh%27s_Scroll"},
    {},
    {"dungeon:lower-blackrock-spire"},
    "Classic / Forever",
    true)
Curated("npc:voshgajin",
    "Shadow Hunter Vosh'gajin",
    "Person",
    "Shadow Hunter Vosh'gajin is a troll huntress in Lower Blackrock Spire. The smith Kilram has a personal grievance against her: she scarred his face and mocked the wound as a token of affection. He now seeks vengeance and offers to teach axesmithing to someone who kills her and returns with her snakestone.\n\nThe stone gives that demand more than the value of a trophy. According to the legend Kilram relates, a single use can keep an axe sharp for a thousand years.",
    {"https://classicdb.ch/?npc=9236", "https://classicdb.ch/?quest=5306", "https://wowpedia.fandom.com/wiki/Shadow_Hunter_Vosh%27gajin"},
    {"Vosh'gajin"},
    {"dungeon:lower-blackrock-spire"},
    "Classic / Forever",
    true)
Curated("npc:voone",
    "War Master Voone",
    "Person",
    "War Master Voone leads the Smolderthorn forest trolls within the Dark Horde's Lower Blackrock Spire. His chamber lies in Tazz'Alaor, among the troll holdings of the lower citadel. Warlord Goretooth orders his death alongside Highlord Omokk and Overlord Wyrmthalak, striking at the stronghold's commanders while separately demanding the recovery of important documents.\n\nVoone also appears in Bodley's account of Mor Grayhoof's fate. The druid survived a fall into the lower spire, only to be captured and tortured by Voone; spectral assassins then killed Mor before his captor. Bodley prepares a brazier using druidical remains as a spiritual focus and directs it to Voone's chamber, where Mor's corrupted spirit can be summoned and the stolen amulet piece recovered.",
    {"https://classicdb.ch/?quest=4742", "https://classicdb.ch/?quest=4903", "https://classicdb.ch/?quest=8962", "https://classicdb.ch/?quest=8966", "https://warcraft.wiki.gg/wiki/Smolderthorn_tribe (identity introduction and original-WoW section only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4903; #8962; #8966"},
    {},
    {"dungeon:lower-blackrock-spire", "faction:smolderthorn", "npc:mor-grayhoof"},
    "Classic / Forever",
    true)
Encounter("mor-grayhoof", "Mor Grayhoof", "A brazier ritual called Mor Grayhoof into Voone's chamber.", LB, "lower-blackrock-spire")
Encounter("bannok", "Bannok Grimaxe", "A rare Firebrand champion near the lower citadel's orc encampments.", LB, "lower-blackrock-spire")
Encounter("smolderweb", "Mother Smolderweb", "A spider lurking above the webs of Lower Blackrock Spire.", LB, "lower-blackrock-spire")
Encounter("crystal-fang", "Crystal Fang", "A rare spider within Lower Blackrock Spire.", LB, "lower-blackrock-spire")
Encounter("urok", "Urok Doomhowl", "Omokk's head on a Roughshod Pike provoked Urok at his tribute pile.", LB, "lower-blackrock-spire")
Encounter("zigris", "Quartermaster Zigris", "Zigris patrolled a chamber in Lower Blackrock Spire.", LB, "lower-blackrock-spire")
Curated("npc:halycon",
    "Halycon",
    "Person",
    "Halycon is the enormous worg den mother in Lower Blackrock Spire. Her lair holds pups, and she and her mate are the source of the attack worgs used by the Blackrock orcs. Their breeding stock gives the den a military importance beyond the danger posed by one great beast.\n\nThough tales give these worgs a demonic origin, their breeding stock lies in this den. The call for Halycon's death aims to cut off that supply.",
    {"https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (retained encounter source)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4724 The Pack Mistress", "https://warcraft.wiki.gg/wiki/Halycon (original identity/lair; excludes Adventure Guide lineage)"},
    {},
    {"dungeon:lower-blackrock-spire"},
    "Classic / Forever",
    true)
Encounter("gizrul", "Gizrul the Slavener", "A worg encountered after Halycon in Lower Blackrock Spire.", LB, "lower-blackrock-spire")
Curated("npc:wyrmthalak",
    "Overlord Wyrmthalak",
    "Person",
    "Overlord Wyrmthalak is the dragonspawn taskmaster of the lower city in Blackrock Spire. His importance lies in the fortress's command structure: Marshal Maxwell identifies him as the link through which its central command operates.\n\nBoth Maxwell and Warlord Goretooth call for his destruction alongside Highlord Omokk and War Master Voone. Their plans target the leadership holding the citadel's forces together, making Wyrmthalak more than another guardian of its halls.",
    {"https://classicdb.ch/?quest=4903", "https://classicdb.ch/?quest=5081", "https://warcraft.wiki.gg/wiki/Overlord_Wyrmthalak"},
    {"Wyrmthalak"},
    {"dungeon:lower-blackrock-spire", "npc:maxwell"},
    "Classic / Forever",
    true)
Curated("npc:emberseer",
    "Pyroguard Emberseer",
    "Person",
    "Pyroguard Emberseer is a fire elemental imprisoned in the Hall of Binding in Upper Blackrock Spire. Blackhand Incarcerators maintain his captivity through their magic. Breaking their hold releases a dangerous enemy: Emberseer regains his power and attacks those who freed him. His defeat opens the way farther into the spire.\n\nDuke Hydraxis also seeks Emberseer's destruction. As a test for would-be allies of the Hydraxian Waterlords, he demands the elemental's eye after the deaths of both prisoner and captors. The captive is therefore an enemy of the Waterlords even while he is held by the orcs.",
    {"https://warcraft.wiki.gg/wiki/Pyroguard_Emberseer (original introductory encounter, location and release dialogue)", "https://classicdb.ch/?quest=6821", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6821 Eye of the Emberseer"},
    {"Emberseer"},
    {"dungeon:upper-blackrock-spire", "faction:hydraxian-waterlords"},
    "Classic / Forever",
    true)
Curated("npc:solakar",
    "Solakar Flamewreath",
    "Person",
    "Solakar Flamewreath is a dragonspawn associated with the Rookery in Upper Blackrock Spire. The chamber is crowded with dragon eggs and watched by dragonspawn, a breeding ground within the fortress rather than an ordinary barracks. Solakar's furious challenge to intruders places him among the defenders of this vulnerable brood.",
    {"https://classicdb.ch/?npc=10264", "https://warcraft.wiki.gg/wiki/Solakar_Flamewreath", "https://warcraft.wiki.gg/wiki/Rookery_%28Blackrock_Spire%29"},
    {},
    {"dungeon:upper-blackrock-spire"},
    "Classic / Forever",
    true)
Curated("npc:goraluk",
    "Goraluk Anvilcrack",
    "Person",
    "Goraluk Anvilcrack is a Blackrock orc and the Blackhand Legion's armorsmith in Upper Blackrock Spire. In battle he invokes the might of the Blackrock clan, threatening to crush the skulls of those who confront him.",
    {"https://classicdb.ch/?npc=10899", "https://warcraft.wiki.gg/wiki/Goraluk_Anvilcrack"},
    {},
    {"dungeon:upper-blackrock-spire", "faction:blackrock-clan"},
    "Classic / Forever",
    true)
Encounter("jed", "Jed Runewatcher", "A rare opponent within Upper Blackrock Spire.", UB, "upper-blackrock-spire")
Curated("npc:gyth",
    "Gyth",
    "Person",
    "Gyth is the great chromatic drake that serves as Rend Blackhand's mount in Upper Blackrock Spire. Rend rides him in the fortress's stadium, bringing a dragon into the same arena as the warbands of the Dark Horde.",
    {"https://classicdb.ch/?npc=10339", "https://warcraft.wiki.gg/wiki/Gyth"},
    {},
    {"dungeon:upper-blackrock-spire", "npc:rend"},
    "Classic / Forever",
    true)
Curated("npc:the-beast",
    "The Beast",
    "Person",
    "The Beast is the core hound occupying the Furnace in Upper Blackrock Spire. Its most unlikely captive is Finkle Einhorn, a gnome swallowed while testing a lava suit in the Molten Span. Protected by the suit and sustained by its food dispenser, Finkle survives inside the creature and can be released when it is skinned.\n\nFinkle brings out a glowing piece of flesh from its innards and sends it to Malyfous Darkhammer in Everlook for appraisal. The specimen raises the prospect of useful materials hidden within the monster's dangerous body.",
    {"https://warcraft.wiki.gg/wiki/The_Beast", "https://wowwiki-archive.fandom.com/wiki/Finkle_Einhorn", "https://classicdb.ch/?quest=5047"},
    {},
    {"dungeon:upper-blackrock-spire", "npc:finkle-einhorn"},
    "Classic / Forever",
    true)
Curated("npc:valthalak",
    "Lord Valthalak",
    "Person",
    "Lord Valthalak is the lingering spirit of a draconid noble and powerful warlock. He once held command of Blackrock Spire, before General Drakkisath. Death has not ended his influence over the upper citadel.",
    {"https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic (retained original encounter source)", "https://classicdb.ch/?item=22344 (original readable Brazier of Invocation: User's Manual, LORD VALTHALAK sections)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8961 Three Kings of Flame; #8994 Final Preparations; #8995 Mea Culpa, Lord Valthalak; #8996 Return to Bodley"},
    {},
    {"dungeon:upper-blackrock-spire", "npc:drakkisath"},
    "Classic / Forever",
    true)
Curated("npc:rend",
    "Warchief Rend Blackhand",
    "Person",
    "Rend Blackhand is an orc chieftain who claims the title of Warchief from Blackrock Spire. He is Blackhand's son. After the Second War, Rend and his brother Maim sought refuge in the fortress, where Rend proclaimed himself leader of the weakened Blackrock clan.\n\nEitrigg remembers the brothers' long conflict with the Dark Iron dwarves. The orcs displaced them from the upper city only after Maim's death and the arrival of dragons. Nefarian now commands Rend, whose claim to lead the Horde rests under the black dragonflight's protection. Thrall rejects that rival claim and orders an attack through the Halls of Ascension against Blackrock's leader.",
    {"https://warcraft.wiki.gg/wiki/Eitrigg%27s_Wisdom", "https://classicdb.ch/?quest=4974"},
    {"Rend Blackhand"},
    {"dungeon:upper-blackrock-spire", "npc:eitrigg", "npc:thrall"},
    "Classic / Forever",
    true)
Encounter("drakkisath", "General Drakkisath", "Drakkisath commanded Nefarian's dragonspawn armies. His blood could enchant a black dragon's scale into an amulet able to pass the wards surrounding Onyxia's lair.", V .. " #6502 Drakefire Amulet", "upper-blackrock-spire")
Encounter("pusillin", "Pusillin", "An imp in Dire Maul East carrying the Crescent Key.", DO, "dire-maul")
Encounter("zevrim", "Zevrim Thornhoof", "A satyr whose defeat opened the way toward the Lower Conservatory.", DE, "dire-maul")
Encounter("hydrospawn", "Hydrospawn", "A water elemental inhabiting a pool in Dire Maul East.", DE, "dire-maul")
Encounter("pimgib", "Pimgib", "The imp accompanying Lethtendris in Dire Maul East.", DE, "dire-maul")
Curated("npc:alzzin", "Alzzin the Wildshaper", "Person",
    "Alzzin the Wildshaper is a demon able to change his shape who holds corrupt dominion over the eastern part of Dire Maul, the Lower Conservatory of Eldre'Thalas. The Fruit of Fertility grows near him, corrupted now as the Felvine.",
    {DE .. " (Alzzin the Wildshaper)", V .. " #5526 Shards of the Felvine"}, {"Alzzin"}, {"dungeon:dire-maul", "item:felvine"})
Encounter("lethtendris", "Lethtendris", "A blood elf mage hiding near Dire Maul's satyrs, Lethtendris built a web to trap the ruined city's magical energies. Her pursuers feared the damage such concentrated power might cause.", V .. " #7488 and #7489 Lethtendris's Web", "dire-maul")
Encounter("tendris", "Tendris Warpwood", "Tendris guarded Dire Maul's western wing.", DW, "dire-maul")
Encounter("kalendris", "Magister Kalendris", "A wielder of shadow magic within Dire Maul West.", DW, "dire-maul")
Encounter("tsuzee", "Tsu'zee", "A rare lurking opponent in the Court of the Highborne.", DW, "dire-maul")
Encounter("illyanna", "Illyanna Ravenoak", "Illyanna fought beside her bear, Ferra, in Dire Maul West.", DW, "dire-maul")
Encounter("ferra", "Ferra", "Illyanna Ravenoak's bear companion in Dire Maul West.", DW, "dire-maul")
Encounter("helnurath", "Lord Hel'nurath", "A special summoning encounter within Dire Maul West.", DW, "dire-maul")
Encounter("immolthar", "Immol'thar", "Guarded pylons sustained the force field around Immol'thar. The Shen'dralar sought his destruction to diminish Prince Tortheldrin's power and end the suffering of the city's spirits.", V .. " #7461 The Madness Within", "dire-maul")
Encounter("tortheldrin", "Prince Tortheldrin", "Tortheldrin's power depended on Immol'thar. Dire Maul's spirits sought an end to his rule, while the Gordok accused him of stealing their former king's gauntlet.", V .. " #7461 The Madness Within; #1318 and #7703 Unfinished Gordok Business", "dire-maul")
Encounter("moldar", "Guard Mol'dar", "An ogre guarding Dire Maul North.", DN, "dire-maul")
Encounter("kreeg", "Stomper Kreeg", "An ogre within Dire Maul's northern wing.", DN, "dire-maul")
Encounter("fengus", "Guard Fengus", "An ogre patrolling the Gordok courtyard.", DN, "dire-maul")
Encounter("slipkik", "Guard Slip'kik", "An ogre patrolling the Halls of Destruction.", DN, "dire-maul")
-- notes5 2026-11-06: the encounter entry, with what the Gordok quests say of him.
Curated("npc:kromcrush", "Captain Kromcrush", "Person",
    "Captain Kromcrush is an ogre captain of the Gordok in Dire Maul North who guards the way to their king. When the king falls and the title passes, he calls the new king boss, and he hopes the new king can win back the Gauntlet of Gordok Might, which Prince Tortheldrin stole from a Gordok king long ago.",
    {DN .. " (Captain Kromcrush)", V .. " #5518 The Gordok Ogre Suit; #7703 Unfinished Gordok Business; #1318 Unfinished Gordok Business"},
    {"Kromcrush"}, {"dungeon:dire-maul", "npc:king-gordok", "item:gauntlet-gordok-might"})
Encounter("chorush", "Cho'Rush the Observer", "Cho'Rush accompanied King Gordok in Dire Maul North.", DN, "dire-maul")
Curated("npc:king-gordok", "King Gordok", "Person",
    "King Gordok is the ogre king of the Gordok, who rules from the heart of Dire Maul North with Cho'Rush the Observer at his side. Among the Gordok the title passes to whoever kills the king, and every king since an old Gordok king lost the Gauntlet of Gordok Might to Prince Tortheldrin has failed to win it back.",
    {DN .. " (King Gordok)", V .. " #5518 The Gordok Ogre Suit; #7703 Unfinished Gordok Business; #1318 Unfinished Gordok Business"}, nil, {"dungeon:dire-maul", "npc:kromcrush", "item:gauntlet-gordok-might"})
Encounter("razza", "The Razza", "One of the rare opponents in Dire Maul's outdoor arena.", DO, "dire-maul")
Encounter("skarr", "Skarr the Unbreakable", "One of the rare opponents in Dire Maul's outdoor arena.", DO, "dire-maul")
Encounter("mushgog", "Mushgog", "One of the rare opponents in Dire Maul's outdoor arena.", DO, "dire-maul")
Encounter("unforgiven", "The Unforgiven", "An undead opponent in Stratholme's streets.", SL, "stratholme")
Encounter("malown", "Postmaster Malown", "Malown answered disturbances involving Stratholme's mailboxes.", SL, "stratholme")
Curated("npc:timmy",
    "Timmy the Cruel",
    "Person",
    "Timmy the Cruel is a ghoul in Stratholme, haunting the approach to the Scarlet Crusade's stronghold. He appears near Crusaders' Square on the city's Main Gate side, amid the undead that infest the streets outside the Scarlet Bastion. His charge is accompanied by a bellow of his own name: \"TIMMY!\"",
    {"https://classicdb.ch/?npc=10808", "https://warcraft.wiki.gg/wiki/Timmy_the_Cruel"},
    {},
    {"faction:scourge"},
    "Classic / Forever",
    true)
Encounter("malor", "Malor the Zealous", "Malor's strongbox held the Medallion of Faith.", SL, "stratholme")
Encounter("crimson-hammersmith", "Crimson Hammersmith", "Disturbing blacksmithing plans summoned this opponent in Stratholme.", SL, "stratholme")
Encounter("willey", "Cannon Master Willey", "Willey's position in Stratholme was defended by riflemen and cannons.", SL, "stratholme")
Encounter("galford", "Archivist Galford", "Galford's archive held the painting Of Love and Family.", SL, "stratholme")
Encounter("balnazzar", "Balnazzar", "The demon concealed behind Grand Crusader Dathrohan's form in Stratholme.", SL, "stratholme", {"Grand Crusader Dathrohan"})
Encounter("anastari", "Baroness Anastari", "Anastari defended a ziggurat in Stratholme's Scourge-held quarter.", SU, "stratholme")
Encounter("nerubenkan", "Nerub'enkan", "A guardian of Stratholme's ziggurats.", SU, "stratholme")
Curated("npc:maleki",
    "Maleki the Pallid",
    "Person",
    "Maleki the Pallid is a living human mage of the Cult of the Damned, serving among the undead in Stratholme's Scourge-held quarter. He defends one of its ziggurats with frost and shadow magic. His spells chill and immobilize intruders, while draining their life allows him to mend his own wounds.",
    {"https://warcraft.wiki.gg/wiki/Maleki_the_Pallid", "https://classicdb.ch/?npc=10438"},
    {},
    {"dungeon:stratholme", "faction:cult-damned"},
    "Classic / Forever",
    true)
Encounter("barthilas", "Magistrate Barthilas", "An opponent within Stratholme's Scourge-held streets.", SU, "stratholme")
Encounter("ramstein", "Ramstein the Gorger", "Ramstein emerged after the abominations outside Stratholme's Slaughterhouse were defeated.", SU, "stratholme")
Curated("npc:rivendare", "Baron Rivendare", "Person",
    "Baron Rivendare was the death knight who ruled Stratholme for the Scourge, serving Kel'Thuzad amid the city's plague-stricken ruins. Mounted on his skeletal steed, he stood at the heart of the undead stronghold. Duke Nicholas Zverenhoff of the Argent Dawn singled him out as a servant whose destruction would strike at the power governing the city, and warned of the countless lives the Baron had already taken.\n\nHis rule rested on organized servants as well as his own strength. The Black Guard, elite skeletal soldiers under his command, held stolen plans for the great blade Corruption; their undead swordsmith guarded the knowledge.\n\nThe Baron's prisoners gave that rule a more immediate face. Ysida, who had joined the Argent Dawn, was held by his undead forces. Her husband's desperate plea for her rescue made Stratholme's struggle painfully personal: behind the ranks of undead and the ambitions of their masters, a living captive remained in the Baron's hands.",
    {"https://www.wowhead.com/classic/npc=10440/baron-rivendare (original Stratholme identity and mounted model)",
        V .. " #5263 Above and Beyond; #5307 Corruption; #8945 Dead Man's Plea"}, nil,
    {"dungeon:stratholme", "npc:kelthuzad", "npc:black-guard-swordsmith"})
Encounter("black-guard-swordsmith", "Black Guard Swordsmith", "This undead swordsmith guarded stolen plans for the blade Corruption, serving among Baron Rivendare's elite Black Guard.", V .. " #5307 Corruption", "stratholme")
Encounter("blood-steward", "Blood Steward of Kirtonos", "A servant in Scholomance's Reliquary carrying the Blood of Innocents.", SC, "scholomance")
Curated("npc:jandice",
    "Jandice Barov",
    "Person",
    "Jandice Barov is a ghost of the family whose estate became Scholomance. She haunts the school beneath Caer Darrow, an undead spellcaster among its horrors. When attacked, she surrounds herself with illusory copies, hiding her true form among the apparitions. Finding the real Jandice is the defining difficulty of the encounter.",
    {"https://warcraft.wiki.gg/wiki/Jandice_Barov_%28Classic%29"},
    {},
    {"dungeon:scholomance", "place:caer-darrow"},
    "Classic / Forever")
Curated("npc:rattlegore",
    "Rattlegore",
    "Person",
    "Rattlegore is an undead bone golem guarding the depths beneath Scholomance's Great Ossuary, below the chamber occupied by plagued hatchlings. His defense is brutally physical: heavy strikes, knockbacks and a stunning stomp punish intruders who come within reach.\n\nHe carries the Viewing Room Key. Defeating him and recovering it opens the locked Viewing Room door, allowing passage farther through the school. His place in Scholomance's defenses is thus tied to a concrete barrier between its outer chambers and the rooms beyond.",
    {"https://warcraft.wiki.gg/wiki/Rattlegore_%28Classic%29 (original identity, abilities and Viewing Room Key note)", "https://classicdb.ch/?npc=11622", "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (preserved original source: Rattlegore)"},
    {},
    {"dungeon:scholomance"},
    "Classic / Forever",
    true)
Encounter("marduk", "Marduk Blackpool", "Marduk occupied Scholomance's Viewing Room.", SC, "scholomance")
Encounter("vectus", "Vectus", "A fire-wielding opponent in Scholomance's Viewing Room.", SC, "scholomance")
Encounter("kormok", "Kormok", "A brazier ritual summoned Kormok in Ras Frostwhisper's chamber.", SC, "scholomance")
Curated("npc:malicia",
    "Instructor Malicia",
    "Person",
    "Instructor Malicia is a high elf necromancer serving the Scourge as an instructor in Scholomance. She occupies the Coven, a southern chamber on the school's upper floor, where intruders encounter one of the teachers who sustains its study of death magic.\n\nHer spells combine destructive curses with the means to prolong her own resistance. Corruption and Call of the Grave afflict nearby enemies, while healing and renewal restore health during the fight. Slowing magic further hampers her opponents. Her encounter gives the school a teacher whose danger lies in persistent magic rather than physical force.",
    {"https://warcraft.wiki.gg/wiki/Instructor_Malicia_%28Classic%29 (original identity and abilities)", "https://classicdb.ch/?npc=10505", "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (preserved source: original upper-floor room)"},
    {},
    {"dungeon:scholomance"},
    "Classic / Forever",
    true)
Encounter("polkelt", "Lorekeeper Polkelt", "Polkelt occupied a northern chamber on Scholomance's upper floor.", SC, "scholomance")
Encounter("ravenian", "The Ravenian", "The Ravenian inhabited the southern portion of the Barov Family Vault.", SC, "scholomance")
Encounter("alexei", "Lord Alexei Barov", "Alexei occupied the eastern portion of Scholomance's Barov Family Vault.", SC, "scholomance")
Encounter("illucia", "Lady Illucia Barov", "Illucia occupied the northern portion of Scholomance's Barov Family Vault.", SC, "scholomance")
Curated("npc:gandling",
    "Darkmaster Gandling",
    "Person",
    "Darkmaster Gandling is the human necromancer who serves as headmaster of Scholomance, the school of necromancy at Caer Darrow. He confronts intruders after the six guardians surrounding his study have fallen, announcing the start of his lesson. His shadow portals separate an enemy from their companions and imprison them in a side chamber with hostile creatures; the isolated victim must fight free to rejoin the struggle.",
    {"https://warcraft.wiki.gg/wiki/Darkmaster_Gandling_%28Classic%29", "https://www.wowhead.com/classic/it/npc%3D1853/darkmaster-gandling"},
    {"Gandling"},
    {"dungeon:scholomance"},
    "Classic / Forever",
    true)
Curated("npc:krastinov",
    "Doctor Theolen Krastinov",
    "Person",
    "Doctor Theolen Krastinov, called the Butcher, is a human torturer in Scholomance's Hall of the Damned. Eva Sarkhoff names him as the tormentor of herself and her husband Lucien. She recounts prolonged experiments in which he used magic to keep his victims alive through suffering that should have killed them.\n\nEva holds Krastinov responsible for thousands of deaths. She seeks justice for his victims and the burning of her and her husband's remains, hoping to ease their spirits' suffering. Her demand joins punishment of the Butcher with the effort to release those still bound to Scholomance by his cruelty.",
    {"https://warcraft.wiki.gg/wiki/Doctor_Theolen_Krastinov_(Classic) (original identity/location; Lore quotes Eva's gossip)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5382 Doctor Theolen Krastinov, the Butcher"},
    {"Theolen Krastinov", "Doctor Theolen Krastinov, the Butcher"},
    {"dungeon:scholomance", "group:barov-family", "npc:kirtonos"},
    "Classic / Forever",
    true)
Encounter("kirtonos", "Kirtonos the Herald", "Krastinov's master could be summoned to Scholomance's porch with the Blood of Innocents. Eva Sarkhoff saw that lure as a chance to avenge the victims whose blood sustained him.", V .. " #5384 Kirtonos the Herald", "scholomance")
Curated("npc:ras", "Ras Frostwhisper", "Person",
    "Ras Frostwhisper is a lich of Scholomance, once a human mage of Stromgarde. He gave his life freely to the Lich King on the ground in Stratholme that the Scourge calls Menethil's Gift, cutting his own throat inside a pentagram, and the Lich King raised him there as a lich. Leonid Barthalomew of the Argent Dawn watched it happen. Magistrate Marduke, a ghost of Caer Darrow, seeks to make him mortal again with a keepsake of his living years and then see him killed.",
    {V .. " #5461 The Human, Ras Frostwhisper; #5463 Menethil's Gift; #5466 The Lich, Ras Frostwhisper (Ras Frostwhisper)"}, nil, {"dungeon:scholomance", "place:menethils-gift", "npc:marduke", "npc:leonid-barthalomew"})

-- Remaining rare and quest-summoned dungeon encounters.
local CR = "https://www.wowhead.com/classic/guide/classic-dungeons-overview"
Encounter("spirestone-magus", "Spirestone Lord Magus", "A named opponent within Blackrock Spire.", "https://www.wowhead.com/classic/npc=9217/spirestone-lord-magus", "lower-blackrock-spire")
Encounter("ghok", "Ghok Bashguud", "A Bloodaxe champion within Blackrock Spire.", "https://www.wowhead.com/classic/npc=9718/ghok-bashguud", "lower-blackrock-spire")
Encounter("hearthsinger", "Hearthsinger Forresten", "A rare inhabitant of Stratholme's streets.", CR, "stratholme")
Encounter("skul", "Skul", "A rare opponent in Stratholme's streets.", CR, "stratholme")
Encounter("stonespine", "Stonespine", "A rare opponent in Stratholme's Scourge-held quarter.", CR, "stratholme")
Encounter("jarien", "Jarien", "A brazier ritual summoned Jarien and Sothos together in Balnazzar's chamber.", "https://www.wowhead.com/classic/npc=16101/jarien", "stratholme")
Encounter("sothos", "Sothos", "A brazier ritual summoned Sothos and Jarien together in Balnazzar's chamber.", "https://www.wowhead.com/classic/npc=16102/sothos", "stratholme")
Encounter("darkreaver", "Death Knight Darkreaver", "Darkreaver rode a once-noble charger whose hollowed soul remained bound to his service. The paladins' divination ritual in Scholomance sought to confront the death knight and redeem his mount.", V .. " #7646 The Divination Scryer, completion dialogue", "scholomance")

-- Maximum-level Vanilla raids. Optional encounters and named members of paired
-- encounters receive their own references; the index never records a victory.
local MC = "https://www.wowhead.com/classic/guide/molten-core-raid-overview-wow-classic"
local BL = "https://www.wowhead.com/classic/guide/blackwing-lair-raid-overview-classic-wow"
local ZG = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview"
local AR = "https://www.wowhead.com/classic/guide/ruins-ahnqiraj-aq20-overview-classic-wow"
local AP = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow"
local NX = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings)"
local FH = "https://www.wowhead.com/classic/guide/four-horsemen-naxxramas-raid-strategy"
local WB = "https://www.wowhead.com/classic/guide/classic-world-boss"
Curated("npc:lucifron",
    "Lucifron",
    "Person",
    "Lucifron is a flamewaker captain in Molten Core, accompanied by two Flamewaker Protectors near Magmadar. His curse doubles the effort required to use spells and abilities, while his guards can seize control of an enemy's mind. The threat is more than his own blows: his magic weakens a company's ability to fight together.\n\nDuke Hydraxis names Lucifron among the fire captains whose destruction would advance the Hydraxian Waterlords' war. He demands their hands as proof, making this guardian of the Core a specific target in the struggle against the Firelords.",
    {"https://worldofwarcraft.blizzard.com/en-us/news/13936505/re-visiting-heroisms-past-molten-core", "https://classicdb.ch/?spell=19703", "https://warcraft.wiki.gg/wiki/Lucifron", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6824)"},
    {},
    {"dungeon:molten-core", "npc:magmadar", "faction:hydraxian-waterlords"},
    "Classic / Forever",
    true)
Curated("npc:magmadar",
    "Magmadar",
    "Person",
    "Magmadar is the enormous core hound found beyond Lucifron in the hound-filled cavern of Molten Core. His presence makes that approach to Ragnaros a trial of fire and terror: his Panic scatters nearby enemies, while his frenzy drives his attacks to greater speed.\n\nHunters can suppress that frenzy with Tranquilizing Shot, learned from the tome carried by Lucifron. The two encounters are linked by that countermeasure, giving the hunters a particular role in overcoming the hound.",
    {"https://worldofwarcraft.blizzard.com/en-us/news/13936505/re-visiting-heroisms-past-molten-core", "https://warcraft.wiki.gg/wiki/Magmadar", "https://www.wowhead.com/classic/npc=11982/magmadar"},
    {},
    {"dungeon:molten-core", "npc:ragnaros"},
    "Classic / Forever",
    true)
Encounter("gehennas", "Gehennas", "A fire captain in the Molten Core, among the Waterlords' principal targets.", V .. " #6824 Hands of the Enemy", "molten-core")
Curated("npc:garr",
    "Garr",
    "Person",
    "Garr is a lava elemental serving Ragnaros in Molten Core, surrounded by eight Firesworn. His Antimagic Pulse strips protective enchantments from nearby enemies. The smaller elementals are dangerous even in defeat: their deaths unleash fiery explosions that can throw combatants back into danger.\n\nHighlord Demitrian names Garr as Geddon's accomplice in Thunderaan's betrayal. Garr carries one of the two Bindings of the Windseeker.",
    {"https://warcraft.wiki.gg/wiki/Garr", "https://warcraft.wiki.gg/wiki/Firesworn", "https://warcraft.wiki.gg/wiki/Highlord_Demitrian"},
    {},
    {"dungeon:molten-core", "npc:baron-geddon", "relic:bindings-windseeker"},
    "Classic / Forever",
    true)
Curated("npc:baron-geddon",
    "Baron Geddon",
    "Person",
    "Baron Geddon is a fire elemental lieutenant of Ragnaros within Molten Core. His Living Bomb turns an enemy into a delayed explosion that threatens nearby companions, making the space between combatants as dangerous as the baron's own attacks.\n\nHighlord Demitrian accuses Geddon and Garr of helping Ragnaros betray Thunderaan. He says the lieutenants received the divided talisman imprisoning the Windseeker's remaining essence.",
    {"https://warcraft.wiki.gg/wiki/Baron_Geddon", "https://classicdb.ch/?spell=20475", "https://warcraft.wiki.gg/wiki/Highlord_Demitrian"},
    {},
    {"dungeon:molten-core", "npc:garr", "relic:bindings-windseeker"},
    "Classic / Forever")
Curated("npc:shazzrah",
    "Shazzrah",
    "Person",
    "A fire captain in the Molten Core, hunted by agents of the Hydraxian Waterlords.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6824 Hands of the Enemy (Shazzrah)", "https://classicdb.ch/?quest=6824"},
    {},
    {"dungeon:molten-core"},
    "Classic / Forever",
    true)
Curated("npc:sulfuron",
    "Sulfuron Harbinger",
    "Person",
    "Sulfuron Harbinger is Ragnaros's flamewaker herald in Molten Core, flanked by four Flamewaker Priests. He inspires his allies to strike harder and faster, while the priests use dark magic to heal their companions. Their combined strength makes his retinue an essential part of the encounter.\n\nThe Hydraxian Waterlords count Sulfuron among the fire captains they want destroyed. Duke Hydraxis asks for his hand along with those of Lucifron, Gehennas and Shazzrah, treating their defeat as a serious blow against the Firelords.",
    {"https://worldofwarcraft.blizzard.com/en-us/news/13936505/re-visiting-heroisms-past-molten-core", "https://warcraft.wiki.gg/wiki/Sulfuron_Harbinger", "https://classicdb.ch/?spell=19775", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6824)"},
    {"Sulfuron"},
    {"dungeon:molten-core", "npc:ragnaros", "faction:hydraxian-waterlords"},
    "Classic / Forever")
Curated("npc:golemagg",
    "Golemagg the Incinerator",
    "Person",
    "Golemagg the Incinerator is a massive molten giant within Molten Core, accompanied by two Core Ragers. Their bond makes the giant the heart of the encounter: while he lives, the wounded hounds recover rather than die, forcing challengers to bring down their master.\n\nAmong the treasures taken from Golemagg is the Sulfuron Ingot. Lokhtos Darkbargainer trades the plans for a Sulfuron Hammer for one of these ingots, making the giant's defeat part of the search for the legendary Sulfuras.",
    {"https://worldofwarcraft.blizzard.com/en-us/news/13936505/re-visiting-heroisms-past-molten-core", "https://warcraft.wiki.gg/wiki/Golemagg_the_Incinerator", "https://www.wowhead.com/item=17203/sulfuron-ingot", "https://warcraft.wiki.gg/wiki/A_Binding_Contract"},
    {},
    {"dungeon:molten-core", "relic:sulfuras"},
    "Classic / Forever")
Encounter("executus", "Majordomo Executus", "Executus served Ragnaros in the Molten Core. Overcoming his guards forced his surrender; he then offered to summon the Firelord, warning that an audience would be fatal.", "https://www.wowhead.com/classic/npc=12018/majordomo-executus (encounter and captured surrender/summoning dialogue)", "molten-core", {"Executus"})
Curated("npc:ragnaros",
    "Ragnaros",
    "Person",
    "Ragnaros the Firelord is the elemental master of Molten Core beneath Blackrock Mountain. His power reaches beyond the fiery cavern: Franclorn Forgewright describes King Dagran Thaurissan and the Dark Iron nation falling under his control, while the Tablet of Kurniya reveals him as the power behind Lord Incendius. Thunderheart recognizes the name as that of a general of the Old Gods.\n\nWithin the Core, Majordomo Executus serves as his chief intermediary. Defeated by intruders, Executus agrees to summon the Firelord, warning that Ragnaros is weakened away from his own fiery realm. Ragnaros erupts in fury at being awakened prematurely. He kills Executus for allowing the intruders into his sanctum, then turns his power against them; when he withdraws beneath the lava, his Sons of Flame rise to defend him.",
    {"https://warcraft.wiki.gg/wiki/Dark_Iron_Legacy", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 3907)", "https://wowpedia.fandom.com/wiki/Ragnaros_%28tactics%29", "https://warcraft.wiki.gg/wiki/Ragnaros_%28tactics%29"},
    {"the Firelord", "Ragnaros the Firelord"},
    {"dungeon:molten-core", "npc:executus", "faction:dark-iron"},
    "Classic / Forever")
Curated("npc:razorgore",
    "Razorgore the Untamed",
    "Person",
    "Razorgore the Untamed is the dragonspawn guarding the precious dragon eggs in the first chamber of Nefarian's Blackwing Lair. The Orb of Domination can force him to destroy the very eggs he protects.\n\nHis furious protests make clear that this destruction is against his will: he threatens vengeance on those compelling him and insists that the eggs' value exceeds their understanding. When released from the device, he vows never to endure its torment again.",
    {"https://warcraft.wiki.gg/wiki/Razorgore_the_Untamed"},
    {"Razorgore"},
    {"dungeon:blackwing", "npc:nefarian"},
    "Classic / Forever",
    true)
Curated("npc:vaelastrasz",
    "Vaelastrasz the Corrupt",
    "Person",
    "Vaelastrasz is a red dragon overcome by Nefarian in Blackwing Lair. The black dragon intends to turn his captive against the mortals who might have been his allies. Still struggling for control, Vaelastrasz begs them to kill him, then warns them to flee as the corruption takes hold. His final gift, the Essence of the Red, lends them strength even as he is forced to attack. His pleas to Alexstrasza and apologies for those he kills expose the ally trapped beneath the violence.\n\nHe also bears a failed guardianship: a shard of the Scepter of the Shifting Sands entrusted to him a thousand years earlier has fallen into Nefarius's hands. In his weakness, Vaelastrasz warns a prospective champion to hurry before the shard is destroyed.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8730 Nefarius's Corruption", "https://warcraft.wiki.gg/wiki/Vaelastrasz_the_Corrupt"},
    {"Vaelastrasz"},
    {"dungeon:blackwing", "npc:nefarian"},
    "Classic / Forever",
    true)
Curated("npc:lashlayer",
    "Broodlord Lashlayer",
    "Person",
    "Broodlord Lashlayer is the black drakonid guarding the Halls of Strife in Blackwing Lair, barring passage into Nefarian's inner sanctum. His strength also makes him a test for those seeking the favor of the bronze dragons. The Brood of Nozdormu demands his head before a prospective champion can proceed: an army is needed to bring him down, but only one among its ranks may undertake the responsibility offered by the Brood.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8288 Only One May Rise", "https://warcraft.wiki.gg/wiki/Broodlord_Lashlayer"},
    {},
    {"dungeon:blackwing", "npc:nefarian", "faction:brood-nozdormu"},
    "Classic / Forever",
    true)
Curated("npc:firemaw",
    "Firemaw",
    "Person",
    "Firemaw is a black drake patrolling the first chamber of Blackwing Lair's Crimson Laboratories. Beyond Broodlord Lashlayer's halls, his route runs among the lair's technicians and spellcasters. He attacks with shadowflame and repeated bursts of fire that leave his enemies increasingly vulnerable to heat.",
    {"https://warcraft.wiki.gg/wiki/Crimson_Laboratories", "https://warcraft.wiki.gg/wiki/Firemaw", "https://classicdb.ch/?npc=11983"},
    {},
    {"dungeon:blackwing"},
    "Classic / Forever",
    true)
Curated("npc:ebonroc",
    "Ebonroc",
    "Person",
    "Ebonroc is a black drake guarding the way to Nefarian within Blackwing Lair's Crimson Laboratories. Alongside his shadow flame and battering wings, he carries a more insidious threat: the Shadow of Ebonroc placed upon an enemy lets melee wounds to that victim restore the drake's health. The very opponent holding him at bay can become the means of his recovery.",
    {"https://warcraft.wiki.gg/wiki/Ebonroc", "https://www.wowhead.com/classic/spell=23340/shadow-of-ebonroc"},
    {},
    {"dungeon:blackwing", "npc:nefarian"},
    "Classic / Forever",
    true)
Encounter("flamegor", "Flamegor", "A dragon of Blackwing Lair wielding shadow flame and fire nova.", BL, "blackwing")
Curated("npc:chromaggus",
    "Chromaggus",
    "Person",
    "Nefarian's two-headed beast combined breath attacks associated with different dragonflights.",
    {"https://www.wowhead.com/classic/guide/blackwing-lair-raid-overview-classic-wow (Chromaggus)"},
    {},
    {"dungeon:blackwing"},
    "Classic / Forever",
    true)
Curated("npc:jeklik",
    "High Priestess Jeklik",
    "Person",
    "High Priestess Jeklik is the champion of Hir'eek, the bat loa, in Zul'Gurub. She belongs to the company of high priests sent into the ancient city to stop Hakkar the Soulflayer. Their mission ended in enslavement: the blood god bent the champions to his will and drew strength from the very primal powers that had been brought against him.\n\nJeklik still calls on Hir'eek in battle and assumes a bat's form. Her wings, piercing cries and followers make her a guardian of the city she came to free. Yet her final words curse Hakkar and welcome death as release. The priestess's service to the Soulflayer conceals a captive enemy, and the power he steals from her remains part of his defense.",
    {"Original Blizzard development feature Zul'Gurub, high-priest expedition paragraph: https://warcraft.wiki.gg/wiki/Underdev/Zul%27Gurub (preserved original article formerly worldofwarcraft.com/info/underdev/zulgurub.html)", "Original NPC 14517 encounter abilities and spoken Hir'eek invocation/death line: https://warcraft.wiki.gg/wiki/High_Priestess_Jeklik_(tactics)"},
    {},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever")
Curated("npc:venoxis",
    "High Priest Venoxis",
    "Person",
    "High Priest Venoxis is a Zandalari priest of Hethiss, the snake god. Sent to Zul'Gurub to oppose Hakkar, he instead fell under the Blood God's control. The priest's power now strengthens the very enemy he came to stop.\n\nVenoxis can take the form of a giant serpent, turning his religious bond into a deadly weapon against intruders. His dying words welcome serenity, suggesting release from the hatred that dominates him in battle.",
    {"https://warcraft.wiki.gg/wiki/Venoxis", "https://warcraft.wiki.gg/wiki/High_Priest_Venoxis_%28Classic%29"},
    {},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever",
    true)
Curated("npc:marli",
    "High Priestess Mar'li",
    "Person",
    "High Priestess Mar'li is the troll priestess of Shadra, the spider loa, in Zul'Gurub. She calls upon her patron to become a great spider and summons a brood to fight beside her, ensnaring enemies in webs and venom. Yet her power serves Hakkar under compulsion. Her dying thanks to the mortals who defeat her reveal that death has released her from the blood god's control.",
    {"https://warcraft.wiki.gg/wiki/High_Priestess_Mar%27li_%28original%29"},
    {"Mar'li"},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever",
    true)
Curated("npc:thekal",
    "High Priest Thekal",
    "Person",
    "High Priest Thekal serves Shirvallah, the tiger loa, in Zul'Gurub, but Hakkar holds him in bondage. He fights beside Zealot Lor'Khan and Zealot Zath; fallen members of this council rise again unless all three are brought down together. Even then, Thekal returns in a tiger's form, invoking Shirvallah's rage. His final words welcome peace and freedom from Hakkar, exposing the captive beneath the blood god's defender.",
    {"https://warcraft.wiki.gg/wiki/Thekal"},
    {"Thekal"},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever",
    true)
Encounter("lorkhan", "Zealot Lor'Khan", "One of the zealots fighting beside High Priest Thekal.", ZG, "zulgurub")
Encounter("zath", "Zealot Zath", "One of the zealots fighting beside High Priest Thekal.", ZG, "zulgurub")
Curated("npc:arlokk",
    "High Priestess Arlokk",
    "Person",
    "High Priestess Arlokk is Bethekk's troll priestess in Zul'Gurub. The sound of her temple's gong draws her into battle, where she invokes the panther loa, marks prey for her prowlers and vanishes before returning in panther form. Her service to Hakkar is a captivity: at death she declares herself free of the Soulflayer.",
    {"https://warcraft.wiki.gg/wiki/Arlokk"},
    {"Arlokk"},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever",
    true)
Curated("npc:mandokir",
    "Bloodlord Mandokir",
    "Person",
    "Bloodlord Mandokir is a jungle troll serving Hakkar in Zul'Gurub. He rides the raptor Ohgan and dismounts to fight beside it, promising his enemies' souls to the Blood God. Killing the raptor throws its master into a fury.\n\nMandokir becomes more dangerous as his victims fall, gaining strength from the deaths around him. His watchful threats and sudden charges make his service to Hakkar a hunt for fresh sacrifices.",
    {"https://warcraft.wiki.gg/wiki/Bloodlord_Mandokir_%28Classic%29", "https://www.wowhead.com/wotlk/npc=11382/bloodlord-mandokir"},
    {},
    {"dungeon:zulgurub", "npc:hakkar"},
    "Classic / Forever",
    true)
Encounter("ohgan", "Ohgan", "Bloodlord Mandokir's mount and companion in battle.", ZG, "zulgurub")
Curated("npc:jindo",
    "Jin'do the Hexxer",
    "Person",
    "Jin'do the Hexxer is a jungle troll witch doctor in Zul'Gurub and leader of the Hakkari priesthood devoted to Hakkar. His sorcery turns his enemies' senses and wills against them. Totems seize control of victims or restore his strength, while his hex transforms an opponent into a frog. Shadowy servants harass his foes, yet only those afflicted by his delusional curse can perceive and strike the shades.",
    {"https://warcraft.wiki.gg/wiki/Jin%27do_the_Hexxer", "https://warcraft.wiki.gg/wiki/Troll_Compendium/Jungle_Troll_Tribes"},
    {},
    {"dungeon:zulgurub", "faction:hakkari"},
    "Classic / Forever",
    true)
Encounter("gahzranka", "Gahz'ranka", "Fishing with a special lure could draw Gahz'ranka from Zul'Gurub's waters.", ZG, "zulgurub")
Curated("npc:grilek",
    "Gri'lek",
    "Person",
    "Gri'lek is a troll berserker spirit summoned at Zul'Gurub's Edge of Madness. His name also survives in an older legend preserved on a stone tablet in Stranglethorn. Though its opening has worn away, the remaining tale describes a furious wanderer whose right arm was gone. Hunting with only his left had made that arm powerful, but could not replace what he had lost.\n\nThe legend says Gri'lek had turned away from the spirits. They would no longer listen to his curses, and he was condemned to wander with his injury. At the Edge of Madness, Gri'lek is one of the four spirits that can answer an offering of Gurubashi Mojo Madness. The damaged tablet gives that summoned opponent a history of anger, estrangement and loss.",
    {"Original readable item #2006 The Second Troll Legend, taken from Gri'lek the Wanderer's tablet: https://warcraft.wiki.gg/wiki/The_Second_Troll_Legend", "Original Edge of Madness spirit/ritual: https://warcraft.wiki.gg/wiki/Gri%27lek_(Classic)"},
    {},
    {"dungeon:zulgurub", "npc:wushoolay"},
    "Classic / Forever",
    true)
Curated("npc:hazzarah",
    "Hazza'rah",
    "Person",
    "Hazza'rah is a troll ghost summoned at the Edge of Madness in Zul'Gurub. He is one of several opponents summoned through the ritual there, and his power lies in disabling his opponents while conjured attackers threaten them.\n\nHe drains mana, sends those around him into sleep, and summons dangerous illusions. Those apparitions make the sleeping victims vulnerable even when Hazza'rah himself is not striking them.",
    {"https://classicdb.ch/?npc=15083", "https://warcraft.wiki.gg/wiki/Hazza%27rah_%28Classic%29 (lead; Abilities; original patch history)"},
    {},
    {"dungeon:zulgurub"},
    "Classic / Forever",
    true)
Encounter("renataki", "Renataki", "One of the summoned opponents at the Edge of Madness.", ZG, "zulgurub")
Curated("npc:wushoolay",
    "Wushoolay",
    "Person",
    "Wushoolay is a troll spirit called forth at the Edge of Madness in Zul'Gurub. Lightning defines his power: he sends it arcing between opponents and fills the ground around him with a dangerous storm cloud.\n\nHe is one of four spirits associated with this secluded ritual site. An offering of Gurubashi Mojo Madness can summon the spirit whose turn has come, so Wushoolay shares the place with Gri'lek, Hazza'rah and Renataki. His appearance belongs to that cycle of summoning within the ruined troll capital.",
    {"Original encounter NPC 15085, Chain Lightning/Forked Lightning/Lightning Cloud and Gurubashi Mojo Madness ritual, preserved at https://warcraft.wiki.gg/wiki/Wushoolay_(Classic)", "Blizzard's Classic Zul'Gurub announcement, Edge of Madness rotating encounters: https://worldofwarcraft.blizzard.com/en-us/news/23391283/wow-classic-%C2%A1zulgurub-y-muchas-m%C3%A1s-novedades"},
    {},
    {"dungeon:zulgurub", "npc:grilek"},
    "Classic / Forever",
    true)
Encounter("hakkar", "Hakkar", "The Soulflayer's followers sought his rebirth through an ancient egg. Yeh'kinya's deception aided that plan, while the Zandalarian trolls on Yojamba Isle sought a way to stop the blood god in Zul'Gurub.", V .. " #8181 Confront Yeh'kinya; #8182 The Hand of Rastakhan", "zulgurub", {"Hakkar the Soulflayer", "the Soulflayer"})
Curated("npc:kurinnaxx",
    "Kurinnaxx",
    "Person",
    "A venomous inhabitant of Ahn'Qiraj's ruins. Ravenholdt's poison specialists sought venom from Kurinnaxx and Venoxis to make a powerful new compound.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9023 The Perfect Poison (Kurinnaxx)"},
    {},
    {"dungeon:ahnqiraj-ruins"},
    "Classic / Forever",
    true)
Curated("npc:rajaxx",
    "General Rajaxx",
    "Person",
    "General Rajaxx commands the qiraji soldiers of Ahn'Qiraj and bears a terrible place in the history of the War of the Shifting Sands. Geologist Larksbane's translation of an ancient qiraji account names him as the commander of the invasion of Silithus. When the Twin Emperors devised a trap at Southwind Village, Valstann Staghelm was captured. Rajaxx brought the prisoner before the night elf lines and executed him in his father's sight, breaking Fandral Staghelm's resolve at a crucial moment in the war.\n\nWithin the ruins, Rajaxx still directs an organized army. His captains and other officers send warriors and swarmguards forward in successive assaults before the general enters the fighting himself. Lieutenant General Andorov and his soldiers oppose him there, while Rajaxx cries for revenge against Fandral and the dragons. The general who once shattered the defenders of Silithus again leads the qiraji advance.",
    {"Original #8315 The Calling, Geologist Larksbane's post-quest Prophecy dialogue: https://warcraft.wiki.gg/wiki/The_Calling_(quest)", "Original Rajaxx encounter dialogue and wave composition: https://warcraft.wiki.gg/wiki/General_Rajaxx (original encounter/tactics sections)"},
    {},
    {"dungeon:ahnqiraj-ruins", "npc:valstann", "npc:fandral"},
    "Classic / Forever")
Curated("npc:moam",
    "Moam",
    "Person",
    "Moam is an obsidian destroyer fashioned by the Twin Emperors as a weapon for Ahn'Qiraj's eventual return to war. After the Scarab Wall sealed the qiraji away, their dark master ordered Vek'lor to create a stronger construct. Vek'nilash shaped its body from volcanic stone, while Vek'lor strengthened the shell with spells and named it Moam. Their master then brought it to life.\n\nIts powers exceeded even the emperors' expectations. Moam could summon burning beings of pure mana, drawing on a source the twins had not understood: Arygos, Merithra and Caelestrasz, the three dragons they believed had died during the sealing of Ahn'Qiraj. The dragons were still alive, bound and tormented within the city. Their captor drained and corrupted their magic to strengthen Moam and his other creations, turning the defenders' sacrifice into power for their enemy.",
    {"Original Blizzard Game Guide: Monsters of Ahn'Qiraj, Moam section, preserved at https://wowpedia.fandom.com/wiki/Game_Guide/Monsters_of_Ahn%27Qiraj", "https://warcraft.wiki.gg/wiki/Moam (original history and encounter corroboration; later origin theories excluded)"},
    {},
    {"dungeon:ahnqiraj-ruins", "npc:veklor", "npc:veknilash"},
    "Classic / Forever",
    true)
Curated("npc:buru",
    "Buru the Gorger",
    "Person",
    "Buru the Gorger is a silithid colossus in the Ruins of Ahn'Qiraj. The enormous creature pursues intruders among clusters of eggs, gaining speed as the chase continues. The eggs also create a weakness: breaking one near Buru injures him and slows his pursuit, though a hatchling emerges from the shell.\n\nWhen badly wounded, Buru spreads a creeping plague whose damage grows with time. The encounter changes from a chase around the eggs into a struggle to survive that mounting sickness.",
    {"https://classicdb.ch/?npc=15370", "https://warcraft.wiki.gg/wiki/Buru_the_Gorger (lead; Abilities; original patch history)"},
    {},
    {"dungeon:ahnqiraj-ruins"},
    "Classic / Forever",
    true)
Curated("npc:ayamiss",
    "Ayamiss the Hunter",
    "Person",
    "Ayamiss the Hunter is a silithid wasp in the Ruins of Ahn'Qiraj. The creature begins its attack in the air, striking with poison and calling swarms of smaller wasps, before descending to fight on the ground.\n\nThe altar beneath Ayamiss gives the encounter a more immediate danger. A victim can be transported there and paralyzed while a Hive'Zara larva crawls toward the helpless captive. If it reaches its prey, the victim dies and a powerful wasp emerges. Fighting Ayamiss therefore also means preventing the larvae from reaching those trapped on the altar.",
    {"https://warcraft.wiki.gg/wiki/Ayamiss_the_Hunter (original encounter identity; Fly, Hive'Zara Swarmer, Poison Stinger and Paralyze; Strategy phase descriptions)"},
    {"Ayamiss"},
    {"dungeon:ahnqiraj-ruins"},
    "Classic / Forever",
    true)
Curated("npc:ossirian",
    "Ossirian the Unscarred",
    "Person",
    "Ossirian is the anubisath champion of the Ruins of Ahn'Qiraj. Ancient accounts tell how he grounded Grakkarond and survived the dragon's mauling. Restored with a hawk's head and near invulnerability, he became the revered Unscarred. Crystals sustain his life and bind him to the ruins.\n\nIn battle, activating nearby crystals suppresses his overwhelming strength and exposes him to particular schools of magic. Commander Mar'alith at Cenarion Hold honors proof of his defeat as a service to the people of Kalimdor.",
    {"https://warcraft.wiki.gg/wiki/Game_Guide/Monsters_of_Ahn%27Qiraj", "https://warcraft.wiki.gg/wiki/Ossirian", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8791 The Fall of Ossirian"},
    {"Ossirian"},
    {"dungeon:ahnqiraj-ruins"},
    "Classic / Forever",
    true)
Curated("npc:skeram",
    "The Prophet Skeram",
    "Person",
    "The Prophet Skeram is a qiraji prophet guarding the entrance to the Temple of Ahn'Qiraj. He creates images of himself to confound attackers, and his True Fulfillment can seize an intruder's will and turn that enemy against nearby companions.\n\nGeologist Larksbane names him as the author of the Prophecy of C'Thun. Her reading describes the qiraji building their armies for their god's return. The temple's guardian is also a voice of the faith behind its war.",
    {"https://warcraft.wiki.gg/wiki/The_Prophecy_of_C%27Thun", "https://warcraft.wiki.gg/wiki/Prophet_Skeram"},
    {"Prophet Skeram"},
    {"dungeon:ahnqiraj-temple", "npc:cthun", "npc:larksbane"},
    "Classic / Forever")
Curated("npc:kri",
    "Lord Kri",
    "Person",
    "Lord Kri is one of the three silithid colossi known as the Silithid Royalty in the Temple of Ahn'Qiraj. He confronts intruders together with Princess Yauj and Vem, making the trio a single dangerous obstacle within the temple.\n\nKri's particular threat is poison. His Toxic Volley reaches across the chamber, and even his death leaves a lethal cloud around his body. Bringing him down does not immediately make the ground around him safe.",
    {"https://classicdb.ch/?npc=15511", "https://warcraft.wiki.gg/wiki/Silithid_Royalty (lead; Lord Kri strategy and Death Special)"},
    {},
    {"dungeon:ahnqiraj-temple", "npc:yauj", "npc:vem"},
    "Classic / Forever",
    true)
Encounter("yauj", "Princess Yauj", "Silithid royalty with healing powers, encountered with Lord Kri and Vem.", AP, "ahnqiraj-temple")
Curated("npc:vem",
    "Vem",
    "Person",
    "Vem is a silithid colossus encountered in the Temple of Ahn'Qiraj alongside Lord Kri and Princess Yauj. Together they are known as the Silithid Royalty, and all three fight at once. Vem charges opponents and knocks them back, disrupting the battle around his companions.\n\nHis death has a further consequence: Kri and Yauj become enraged if they are still alive. The danger he poses therefore includes the fury his fall unleashes in the surviving members of the trio.",
    {"https://classicdb.ch/?npc=15544", "https://warcraft.wiki.gg/wiki/Silithid_Royalty (lead; Vem strategy and Death Special)"},
    {},
    {"dungeon:ahnqiraj-temple", "npc:kri", "npc:yauj"},
    "Classic / Forever",
    true)
Encounter("sartura", "Battleguard Sartura", "Sartura fought alongside three royal guards within Ahn'Qiraj.", AP, "ahnqiraj-temple")
Encounter("fankriss", "Fankriss the Unyielding", "Fankriss summoned dangerous spawn among Ahn'Qiraj's tunnels.", AP, "ahnqiraj-temple")
Encounter("viscidus", "Viscidus", "Freezing and shattering Viscidus scattered globs that could rejoin and reform.", AP, "ahnqiraj-temple")
Encounter("huhuran", "Princess Huhuran", "A poisonous guardian within the Temple of Ahn'Qiraj.", AP, "ahnqiraj-temple")
Curated("npc:veklor",
    "Emperor Vek'lor",
    "Person",
    "Emperor Vek'lor is one of the qiraji Twin Emperors in the Temple of Ahn'Qiraj. He fights beside his brother Vek'nilash, forming the magical half of their shared defense. Vek'lor relies on spells and is immune to physical harm, while his brother is the warrior.\n\nThe emperors can exchange positions and heal one another when close together. Their partnership makes separating the brothers as important as confronting either ruler's individual power.",
    {"https://classicdb.ch/?npc=15276", "https://warcraft.wiki.gg/wiki/Twin_Emperors (lead; original Abilities)", "https://warcraft.wiki.gg/wiki/Classic_raid_instance_bosses (Emperor Vek'lor and Emperor Vek'nilash)"},
    {},
    {"dungeon:ahnqiraj-temple", "npc:veknilash"},
    "Classic / Forever",
    true)
Encounter("veknilash", "Emperor Vek'nilash", "The weapon-wielding Twin Emperor, brother to Vek'lor.", AP, "ahnqiraj-temple")
Encounter("ouro", "Ouro", "An ancient sandworm with extraordinarily tough yet flexible skin. Rumor named Ouro a creation of the Old God, fashioned as a mockery of life.", V .. " #8560 Conqueror's Legguards", "ahnqiraj-temple")
Curated("npc:cthun",
    "C'Thun",
    "Person",
    "C'Thun is the Old God beneath the Temple of Ahn'Qiraj, the final enemy within its depths. Those opposing him fear an assault upon all living things, with a reckoning whose timing cannot be measured by mortal lives.\n\nThe qiraji's relationship to him is recorded in the Prophecy of C'Thun, written by the Prophet Skeram and recounted by Geologist Larksbane. Her reading describes C'Thun fashioning the qiraji from silithid and the qiraji building armies to avenge their god. It is their account of the power behind Ahn'Qiraj's war.\n\nThe original campaign culminates in confronting C'Thun. His defeat releases the dragons held in his grasp, though Caelastrasz insists they will remain until they are certain the evil within Ahn'Qiraj has been destroyed. An eye taken from the fallen Old God becomes the evidence carried onward to Anachronos.",
    {"https://warcraft.wiki.gg/wiki/C%27Thun (original Temple encounter identity only)", "https://warcraft.wiki.gg/wiki/The_Prophecy_of_C%27Thun (Geologist Larksbane's original in-world reading)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8562; #8801; #8802"},
    {},
    {"dungeon:ahnqiraj-temple", "faction:qiraji", "npc:skeram"},
    "Classic / Forever",
    true)
Curated("group:twin-emperors", "The Twin Emperors", "Group",
    "Vek'lor and Vek'nilash ruled together within Ahn'Qiraj. The brothers shared their strength and could heal one another when close.", {AP}, {"Twin Emperors", "the Twin Emperors"}, {"dungeon:ahnqiraj-temple", "npc:veklor", "npc:veknilash"})
Curated("group:bug-trio", "Silithid Royalty", "Group",
    "Lord Kri, Princess Yauj, and Vem formed a joint encounter within Ahn'Qiraj's temple.", {AP}, {"Bug Trio", "The Bug Trio"}, {"dungeon:ahnqiraj-temple", "npc:kri", "npc:yauj", "npc:vem"})
Curated("npc:anubrekhan",
    "Anub'Rekhan",
    "Person",
    "Anub'Rekhan is the undead crypt lord guarding the first chamber of Naxxramas's Arachnid Quarter. His welcome is that of a predator studying its food: he listens to his visitors' quickening hearts, considers which to eat and invites them closer. His taunts make their fear part of his pleasure.\n\nCrypt Guards attend him, while his own attacks impale enemies and envelop those nearby in a crippling swarm of locusts. Corpses provide another weapon: scarabs emerge from the fallen to attack the survivors. Within his chamber, death feeds the next assault.",
    {"https://warcraft.wiki.gg/wiki/Anub%27Rekhan_%28Classic%29"},
    {},
    {"dungeon:naxxramas", "npc:kelthuzad"},
    "Classic / Forever",
    true)
Encounter("faerlina", "Grand Widow Faerlina", "An opponent within Naxxramas' Spider Wing.", NX, "naxxramas")
Encounter("maexxna", "Maexxna", "Maexxna's brood inhabited Naxxramas' Spider Wing. Her webs imprisoned intruders, leaving them exposed to the great spider's venom.", NX, "naxxramas")
Curated("npc:noth",
    "Noth the Plaguebringer",
    "Person",
    "Noth the Plaguebringer is an undead human necromancer defending the Plague Wing of Naxxramas for the Scourge. He curses intruders and calls fallen soldiers to rise and fight again. His devotion survives even defeat: his dying words promise continued service to his master.\n\nThe chamber makes his command of the dead tangible. Noth withdraws to a balcony while waves of plagued champions and guardians attack below. His curse threatens both its victim and nearby companions if it is left unbroken, turning a single affliction into a danger for the whole company confronting him.",
    {"https://www.wowhead.com/classic/npc=15954/noth-the-plaguebringer (original NPC Quotes, Plague Wing and spell listings)", "https://warcraft.wiki.gg/wiki/Noth_the_Plaguebringer_%28Classic%29 (original40-player encounter, abilities and dialogue; Background excluded)"},
    {},
    {"dungeon:naxxramas", "faction:scourge"},
    "Classic / Forever",
    true)
Encounter("heigan", "Heigan the Unclean", "An opponent within Naxxramas' Plague Wing.", NX, "naxxramas")
Encounter("loatheb", "Loatheb", "The final guardian of Naxxramas' Plague Wing.", NX, "naxxramas")
Encounter("razuvious", "Instructor Razuvious", "An opponent within Naxxramas' Deathknight Wing.", NX, "naxxramas")
Encounter("gothik", "Gothik the Harvester", "An opponent within Naxxramas' Deathknight Wing.", NX, "naxxramas")
Encounter("korthazz", "Thane Korth'azz", "One of Naxxramas' Four Horsemen, wielding fiery meteors.", FH, "naxxramas")
Encounter("blaumeux", "Lady Blaumeux", "One of Naxxramas' Four Horsemen, wielding shadowy void zones.", FH, "naxxramas")
Encounter("zeliek", "Sir Zeliek", "One of Naxxramas' Four Horsemen, striking foes with holy wrath.", FH, "naxxramas")
Curated("npc:highlord-mograine",
    "Highlord Mograine",
    "Person",
    "Highlord Alexandros Mograine was the paladin whose devastating sword earned him the name Ashbringer. Fairbanks remembers him destroying ranks of undead before his own son Renault betrayed him: after an exhausting battle, Renault struck his father from behind with the blade. Mograine became a death knight serving Kel'Thuzad and now rides among Naxxramas's Four Horsemen, bearing the corrupted weapon.\n\nBringing Corrupted Ashbringer to the Scarlet Monastery provokes a reckoning. Mograine's spirit confronts Renault in the cathedral and kills him as the son begs forgiveness. The freed Fairbanks then recounts the betrayal, exposing the history behind the revered sword and the fallen paladin.",
    {"https://warcraft.wiki.gg/wiki/Corrupted_Ashbringer/Scarlet_Monastery_Event", "https://warcraft.wiki.gg/wiki/Ashbringer"},
    {"Alexandros Mograine", "Highlord Alexandros Mograine"},
    {"dungeon:naxxramas", "npc:kelthuzad"},
    "Classic / Forever")
Encounter("patchwerk", "Patchwerk", "A guardian of Naxxramas' Abomination Wing.", NX, "naxxramas")
Encounter("grobbulus", "Grobbulus", "An opponent within Naxxramas' Abomination Wing.", NX, "naxxramas")
Encounter("gluth", "Gluth", "An opponent within Naxxramas' Abomination Wing.", NX, "naxxramas")
Encounter("thaddius", "Thaddius", "The final guardian of Naxxramas' Abomination Wing.", NX, "naxxramas")
Encounter("sapphiron", "Sapphiron", "A guardian within Naxxramas' Frostwyrm Lair.", NX, "naxxramas")
Curated("npc:kelthuzad",
    "Kel'Thuzad",
    "Person",
    "Kel'Thuzad is the lich who commands Naxxramas and serves the Lich King in the Plaguelands. Once a senior archmage of Dalaran's Kirin Tor, he pursued forbidden necromancy and answered the Lich King's summons to Northrend. He surrendered his former standing for the promise of power and immortality. Returning to Lordaeron, he founded the Cult of the Damned and helped spread the plague that turned its people into the Scourge.\n\nPrince Arthas killed him near Andorhal while investigating the plague. After becoming a death knight, Arthas recovered the necromancer's remains and used the Sunwell to raise him as a lich. Kel'Thuzad then helped bring the Burning Legion into Azeroth, using Medivh's spellbook to summon Archimonde.\n\nFrom the floating necropolis above the Plaguelands, he prepares another Scourge assault. His destruction is not assured by the defeat of his undead body: his phylactery can allow him to reform. The object therefore carries a danger far greater than its value as a trophy.",
    {"https://warcraft.wiki.gg/wiki/Kel%27Thuzad_and_the_Forming_of_the_Scourge", "https://news.blizzard.com/en-gb/article/23572632/wow-classic-naxxramas-is-now-live", "https://warcraft.wiki.gg/wiki/Kel%27thuzad", "https://warcraft.wiki.gg/wiki/Digging_up_the_Dead", "https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_%28WC3_Undead%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 9120: The Fall of Kel'Thuzad)"},
    {},
    {"dungeon:naxxramas", "npc:arthas", "faction:scourge"},
    "Classic / Forever")
Curated("group:four-horsemen", "The Four Horsemen", "Group",
    "Thane Korth'azz, Lady Blaumeux, Sir Zeliek, and Highlord Mograine guarded Naxxramas' Deathknight Wing. Each marked nearby enemies with a growing burden, and their spirits continued that assault after their bodies fell.", {FH}, {"Four Horsemen", "the Four Horsemen"}, {"dungeon:naxxramas", "npc:korthazz", "npc:blaumeux", "npc:zeliek", "npc:highlord-mograine"})
Curated("npc:azuregos", "Azuregos", "Person",
    "Azuregos roamed southeastern Azshara, turning frost and disruptive magic against intruders.", {WB}, nil, {"region:" .. Encode("Azshara")})
Curated("npc:kazzak",
    "Lord Kazzak",
    "Person",
    "Lord Kazzak is a demon lurking in the Tainted Scar of the Blasted Lands. He openly fights for the Burning Legion and Kil'jaeden, challenging those who venture among the demons of that ruined valley. His shadow bolts strike across the battlefield, and his Twisted Reflection makes an afflicted enemy's suffering replenish his own strength. Wounding such a victim sustains the creature they are trying to destroy.",
    {"https://warcraft.wiki.gg/wiki/Lord_Kazzak_%28tactics%29", "https://www.wowhead.com/forever/npc=12397/lord-kazzak"},
    {},
    {"region:426c6173746564204c616e6473", "faction:burning-legion"},
    "Classic / Forever",
    true)
Curated("group:nightmare-dragons", "Dragons of Nightmare", "Group",
    "Emeriss, Lethon, Taerar, and Ysondre were green dragons in Ysera's service corrupted by the Emerald Nightmare. They appeared at the great dream portals across Azeroth.", {WB}, {"the Dragons of Nightmare"}, {"npc:emeriss", "npc:lethon", "npc:taerar", "npc:ysondre"})
Curated("npc:emeriss",
    "Emeriss",
    "Person",
    "Emeriss is one of Ysera's green dragons corrupted by the nightmare within the Emerald Dream. She appears at the Great Trees as a bearer of disease and decay, threatening to make the land wither. Her infection harms those standing near its victim, while the bodies of the fallen sprout poisonous mushrooms. Around Emeriss, even a companion's death becomes a danger to the living.",
    {"https://warcraft.wiki.gg/wiki/Emeriss_%28Classic%29", "https://warcraft.wiki.gg/wiki/Game_Guide/Dragons_of_Nightmare"},
    {},
    {"group:nightmare-dragons"},
    "Classic / Forever",
    true)
Curated("npc:lethon",
    "Lethon",
    "Person",
    "Lethon is a green dragon and one of Ysera's trusted lieutenants corrupted within the Emerald Dream. He has crossed through the Great Trees into Azeroth with the other Dragons of Nightmare, turning a guardian's presence into a threat to the lands around the dream portals.\n\nThe corruption has darkened his scales and given him power to draw malevolent shades from his enemies. Lethon accuses those who approach of harboring darkness and declares that their souls will feed his own strength.",
    {"https://warcraft.wiki.gg/wiki/Game_Guide/Dragons_of_Nightmare", "https://www.wowhead.com/forever/npc=14888/lethon"},
    {},
    {"group:nightmare-dragons"},
    "Classic / Forever",
    true)
Curated("npc:taerar",
    "Taerar",
    "Person",
    "Taerar is a green dragon and one of Ysera's lieutenants warped by the darkness within the Emerald Dream. The corruption shattered both his sanity and his physical form, leaving a spectral dragon able to divide into multiple destructive entities.\n\nWith the other Dragons of Nightmare, he emerges through the Great Trees into Azeroth. The places once watched by the green dragonflight become dangerous meeting points with the corrupted Dream, and Taerar brings his fractured existence into battle through the shades that split from him.",
    {"https://warcraft.wiki.gg/wiki/Game_Guide/Dragons_of_Nightmare"},
    {},
    {"group:nightmare-dragons", "place:emerald-dream"},
    "Classic / Forever",
    true)
Curated("npc:ysondre", "Ysondre", "Person", "One of Ysera's lieutenants corrupted by the Emerald Nightmare.", {WB}, nil, {"group:nightmare-dragons"})

-- Rare/event encounters kept explicit so they are not mistaken for permanent
-- residents or for encounters this character has already witnessed.
Encounter("dustwraith", "Dustwraith", "A rare opponent within Zul'Farrak.", "https://www.wowhead.com/classic/npc=10081/dustwraith (Classic Zul'Farrak roster)", "zulfarrak")
Encounter("sandarr", "Sandarr Dunereaver", "A rare opponent within Zul'Farrak.", "https://www.wowhead.com/classic/npc=10080/sandarr-dunereaver", "zulfarrak")
local TI = "https://www.wowhead.com/classic/guide/thaddius-naxxramas-raid-strategy"
Encounter("feugen", "Feugen", "A wight tethered to a Tesla coil beside Thaddius, paired with Stalagg.", TI, "naxxramas")
Encounter("stalagg", "Stalagg", "A wight tethered to a Tesla coil beside Thaddius, paired with Feugen.", TI, "naxxramas")
local SI = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727"
Encounter("balzaphon", "Balzaphon", "A Scourge invasion opponent appearing in Stratholme.", SI, "stratholme")
Encounter("faltheress", "Lady Falther'ess", "A Scourge invasion opponent appearing in Razorfen Downs.", SI, "razorfen-downs")
Encounter("lord-blackwood", "Lord Blackwood", "A Scourge invasion opponent appearing in Scholomance.", SI, "scholomance")
Encounter("revanchion", "Revanchion", "A Scourge invasion opponent appearing in Dire Maul.", SI, "dire-maul")
Encounter("scorn", "Scorn", "A Scourge invasion opponent appearing in Scarlet Monastery's graveyard.", SI, "scarlet-monastery")
Encounter("sever", "Sever", "A Scourge invasion opponent appearing in Shadowfang Keep.", SI, "shadowfang")
Curated("npc:teremus", "Teremus the Devourer", "Person",
    "A powerful roaming opponent in the Blasted Lands.", {WB}, nil, {"region:" .. Encode("Blasted Lands")})

-- Forever-specific dungeons are identified separately from the Vanilla roster.
local FQ = "StorageInvestigation/journal-voice/part1_corpus.txt"
Curated("dungeon:lordaeron-ruins", "Ruins of Lordaeron", "Dungeon",
    "The streets and graveyard above the Undercity were overrun by Scourge. Reports from Lordamere Overlook described an unholy fog that concealed them, while families still searched the ruins for their missing dead.\n\nThe ruins hold more than the necromancer Rath'mael. The spider Witherfang, an abomination called the Baron, the ghoul Viktor the Vile, a wraith known as the Abandoned and the wight Bjork all haunt the fallen capital, and the ghost of a Lordaeron captain is sometimes seen among its old guards.", {Q .. " #92401 A Frightened Request; #92422 The Wrath of Rath'mael", "https://warcraft.wiki.gg/wiki/Ruins_of_Lordaeron_(instance) (boss list, added in patch 1.60.1)"}, {"the Ruins of Lordaeron"}, {"place:undercity", "npc:rathmael", "npc:witherfang", "npc:the-baron", "npc:viktor-vile", "npc:bjork"}, "Forever")
Curated("npc:rathmael", "Rath'mael", "Person",
    "Forsaken scouts identified Rath'mael as the necromancer conjuring fog over Lordaeron's streets and graveyard. Deathguard Kristof feared the cover it gave the Scourge and called for action.", {Q .. " #92422 The Wrath of Rath'mael"}, nil, {"dungeon:lordaeron-ruins"}, "Forever")
Curated("npc:witherfang", "Witherfang", "Person",
    "An arthropod stalking the Ruins of Lordaeron, Witherfang was said to possess venom that ate through undead flesh. Theodore Griffs sought a sample to test those claims.", {Q .. " #95216 The New Plague, objective and description"}, nil, {"dungeon:lordaeron-ruins"}, "Forever")
Curated("dungeon:hall-thanes", "The Hall of Thanes", "Dungeon",
    "The hall lay beneath Old Ironforge, with tombs and lower vaults disturbed by a Dark Iron incursion. The dead stirred while the invaders emerged from deeper caverns in mole machines.\n\nThe ghost of the old thane Faldrim Anvilmar cannot rest for an ancient grudge. Deeper in, the fiery brute Magmatus and the enchanted golem Plunder guard the vaults, and Durgen Dirgehammer commands the Dark Irons in the innermost halls.", {FQ .. " #96393 Old Ironforge Incursion; #96394 The Restless Dead; #96403 Important Heirlooms", "https://warcraft.wiki.gg/wiki/Hall_of_Thanes_(instance) (boss order, added in patch 1.60.1)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #96395 An Ancient Grudge"}, {"Hall of Thanes", "the Hall of Thanes"}, {"npc:durgen", "npc:faldrim-anvilmar", "npc:magmatus", "npc:plunder"}, "Forever")
Curated("npc:durgen", "Durgen Dirgehammer", "Person",
    "Durgen led the Dark Iron incursion into the vaults beneath Old Ironforge. Earthseer Farsen identified him from the invaders' speech and directed a warning to King Magni.", {FQ .. " #96393 Old Ironforge Incursion, description and completion"}, nil, {"dungeon:hall-thanes"}, "Forever")

-- Only these reviewed packs' sight pools are certified neutral world context.
-- A future pack opts in with noteSummary on individual zones; do not import its
-- stakes, consequences or arbitrary narrative lines as geographical knowledge.
local reviewedZones = {['alliance-starters'] = true, ['horde-and-zephras'] = true, world_journeys = true}
local cities = {['Stormwind City'] = true, Ironforge = true, Darnassus = true, Orgrimmar = true, ['Thunder Bluff'] = true, Undercity = true}
-- Place names retain geography; related reading exposes a same-named faction.
local regionalRelated = {Darnassus = {"faction:darnassus"}}
local zoneAliases = {
    ["Elwynn Forest"] = {"Elwynn"}, ["Stormwind City"] = {"Stormwind"},
    ["Redridge Mountains"] = {"Redridge"}, ["Stonetalon Mountains"] = {"Stonetalon"},
    ["Hillsbrad Foothills"] = {"Hillsbrad"}, ["Alterac Mountains"] = {"Alterac"},
    ["Arathi Highlands"] = {"Arathi"}, ["Stranglethorn Vale"] = {"Stranglethorn"},
    ["Dustwallow Marsh"] = {"Dustwallow"}, ["Un'Goro Crater"] = {"Un'Goro"},
    ["Deadwind Pass"] = {"Deadwind"}, ["Zephras Isle"] = {"Zephras"},
    ["The Barrens"] = {"Barrens"}, ["The Hinterlands"] = {"Hinterlands"},
    ["Wetlands"] = {"the Wetlands"}, ["Badlands"] = {"the Badlands"},
    ["Swamp of Sorrows"] = {"the Swamp of Sorrows"}, ["Searing Gorge"] = {"the Searing Gorge"},
    ["Burning Steppes"] = {"the Burning Steppes"}, ["Western Plaguelands"] = {"the Western Plaguelands"},
    ["Eastern Plaguelands"] = {"the Eastern Plaguelands"},
    ["Blasted Lands"] = {"the Blasted Lands"},
}
local function Keys(tbl)
    local keys = {}; for key in pairs(tbl or {}) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    return keys
end
local function Setup(entry)
    if type(entry) ~= "table" then return nil end
    local value = entry.noteSummary or (type(entry.why) == "table" and entry.why[1])
    if type(value) ~= "string" or value == "" then return nil end
    return value
end
-- Mixed packs contain both original and Forever material. Prefer explicit
-- entry metadata, then the named region, then a pack-wide setting. Never infer
-- the era from quest-ID ranges or the filename of a captured corpus.
local function Setting(data, pack)
    local region = data.zone and pack.zones and pack.zones[data.zone]
    return data.setting or (region and region.setting) or pack.setting or "Classic / Forever"
end
local function Import()
    local packs = A.Lore and A.Lore.storyPacks or {}
    for _, packID in ipairs(Keys(packs)) do
        if not loadedPacks[packID] then
            loadedPacks[packID] = true
            local pack = packs[packID]
            for _, zone in ipairs(Keys(pack.zones)) do
                local data = pack.zones[zone]
                local summary = data.noteSummary
                if not summary and reviewedZones[packID] and type(data.sight) == "table" then
                    local lines = {}
                    for i = 1, math.min(2, #data.sight) do lines[#lines + 1] = data.sight[i] end
                    summary = table.concat(lines, " ")
                end
                if type(summary) == "string" and not aliases.p[Normalize(zone)] then
                    local sources = Sources(data.source, pack.sources)
                    sources[#sources + 1] = "Story pack " .. packID .. ": " .. zone .. " (regional context)"
                    Add({id = "region:" .. Encode(zone), title = zone, kind = cities[zone] and "City" or "Region", body = summary,
                        sources = sources, coverage = "regional", pack = packID, related = regionalRelated[zone],
                        setting = Setting(data, pack)}, zoneAliases[zone])
                end
            end
            for _, title in ipairs(Keys(pack.quests)) do
                local data = pack.quests[title]
                local summary = Setup(data)
                if summary then
                    Add({id = "quest-title:" .. Encode(packID .. ":" .. title), title = title, kind = "Quest",
                        body = summary, sources = Sources(data.noteSources or data.source, pack.sources), coverage = "questTitle",
                        pack = packID, zone = data.zone, setting = Setting(data, pack),
                        contextLabel = "Background to the recorded quest"})
                end
            end
            for _, qid in ipairs(Keys(pack.questIDs)) do
                local data = pack.questIDs[qid]
                local summary = Setup(data)
                if type(qid) == "number" and qid > 0 and qid == math.floor(qid) and type(data.title) == "string" and summary then
                    local id = "quest:" .. string.format("%.0f", qid)
                    -- Exact stages never become aliases: old title-only history
                    -- must use an explicitly authored conservative title entry.
                    entries[id] = {id = id, title = Plain(data.title), kind = "Quest", body = Plain(summary),
                        sources = Sources(data.noteSources or data.source, pack.sources), coverage = "questID", qid = qid,
                        setting = Setting(data, pack), pack = packID, zone = data.zone,
                        contextLabel = "Background to this quest stage"}
                    if #entries[id].sources == 0 then entries[id] = nil end
                end
            end
        end
    end
end

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:49726f6e666f726765",
    "Ironforge",
    "City",
    "Carved inside the mountains of Dun Morogh, Ironforge was the dwarven capital that the Horde never breached during the Second War. King Magni Bronzebeard ruled its stone halls, while the Great Forge formed the working heart of a city built around craftsmanship, mining, and arms.\n\nThe city also sheltered gnomes who had fled the disaster at Gnomeregan. Their presence in Tinker Town placed ingenious machinery beside dwarven stonework, and the Deeprun Tram connected Ironforge with Stormwind beneath the lands between them.\n\nIronforge's interests reached much farther than its mountain gates. Magni encouraged the search for the dwarves' origins, and the Explorers' League sent prospectors to distant ruins. Reports and relics returned to the Hall of Explorers, giving the capital a second purpose: finding the history its people had lost.",
    {"https://assets.blz-contentstack.com/v3/assets/blt3452e3b114fab0cd/blt2e9295db02a222fc/6025bcbb6968b53d529edb2a/media_manual_classic_enUS.pdf (original manual: Ironforge, dwarves, gnomes)", "https://worldofwarcraft.blizzard.com/en-us/news/23149294/wow-classic-city-tour-ironforge", "https://warcraft.wiki.gg/wiki/Ironforge"},
    {},
    {"npc:magni", "faction:explorers-league", "faction:ironforge"},
    "Classic / Forever")

Curated("region:4561737465726e20506c616775656c616e6473",
    "Eastern Plaguelands",
    "Region",
    "The Eastern Plaguelands were the ruined eastern reaches of Lordaeron, where farms, villages, and roads had become territory of the Scourge. Stratholme stood on the northern edge, and the necropolis Naxxramas brought Kel'Thuzad's command close to the heart of the devastation.\n\nAt Light's Hope Chapel, the Argent Dawn welcomed help against the undead from both Horde and Alliance. The Scarlet Crusade held its own stronghold at Tyr's Hand, but its hostility toward outsiders made it a very different refuge. These scattered positions stood amid country still dominated by the Scourge.\n\nThe loss was more personal in places such as Darrowshire. Pamela Redpath's ghost waited for a father who had never come home, while the village's dead remained bound to their last battle. Farther north, Hameya's plea told another story of the plague: an infected troll trying to stop himself from carrying the sickness to his own people.",
    {"https://warcraft.wiki.gg/wiki/Eastern_Plaguelands_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5149 Pamela's Doll; #5721 The Battle of Darrowshire; #6024 Hameya's Plea"},
    {"the Eastern Plaguelands"},
    {"place:lights-hope", "dungeon:naxxramas", "dungeon:stratholme"},
    "Classic / Forever")

Curated("region:537472616e676c6574686f726e2056616c65",
    "Stranglethorn Vale",
    "Region",
    "South of Duskwood, Stranglethorn Vale opened into a vast jungle of troll ruins, dangerous wildlife, and rival outposts. Zul'Gurub, the old Gurubashi capital, lay in its northeastern valleys. The renewed rites of Hakkar gave those ancient stones a danger that reached beyond the jungle's competing tribes.\n\nBooty Bay occupied the southern coast, a goblin port whose trade drew travelers through the region. The Horde maintained Grom'gol Base Camp, while rebels in the north struggled against Colonel Kurzen and the soldiers still loyal to him. The road passed between powers that neither trusted nor answered to one another.\n\nHemet Nesingwary's expedition made the jungle a hunting ground and the subject of his writing. On the coast, the Blackwater Raiders defended Booty Bay against a planned Bloodsail attack. Pirates, hunters, soldiers, and troll tribes pursued different ends in the same country, leaving few stretches of the Vale untouched by rivalry.",
    {"https://warcraft.wiki.gg/wiki/Stranglethorn_Vale_%28Classic%29", "https://news.blizzard.com/en-gb/article/23391283/wow-classic-zulgurub-and-more-now-available", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #189 Bloodscalp Ears; #198 Supplies to Private Thorsen; #203 The Second Rebellion; #338 The Green Hills of Stranglethorn", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #595, #597, #599 The Bloodsail Buccaneers"},
    {"Stranglethorn"},
    {"place:booty-bay", "dungeon:zulgurub", "region:4475736b776f6f64"},
    "Classic / Forever")

Curated("region:53746f726d77696e642043697479",
    "Stormwind City",
    "City",
    "Stormwind rose again after the Horde destroyed it in the First War. Its rebuilt walls and districts made it the great human capital of the southern kingdoms, with the Cathedral of Light and Stormwind Keep at the center of its spiritual and royal authority.\n\nWith King Varian Wrynn missing, his young son Anduin occupied the throne while Highlord Bolvar Fordragon acted as regent. Lady Katrana Prestor's influence reached into decisions about the kingdom's defenses. Reports of black dragons and Blackrock orcs threatening Lakeshire met a court already reluctant to commit its thinly spread troops.\n\nThe grandeur of the rebuilt city concealed another wound. Edwin VanCleef and the Stonemasons' Guild had restored Stormwind, only for its nobles to refuse their wages. VanCleef led a riot and left vowing revenge, turning the builders' grievance into the Defias Brotherhood's cause. The unrest in Westfall therefore had roots inside the capital itself. Stormwind's stonework proclaimed recovery from one war while its court and neglected frontiers exposed dangers that the walls could not settle.",
    {"https://assets.blz-contentstack.com/v3/assets/blt3452e3b114fab0cd/blt2e9295db02a222fc/6025bcbb6968b53d529edb2a/media_manual_classic_enUS.pdf (original manual: Stormwind and notable humans)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #135 and #141 The Defias Brotherhood; #4184-4186 The True Masters", "https://warcraft.wiki.gg/wiki/Anduin_Wrynn", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #389 Bazil Thredd", "https://warcraft.wiki.gg/wiki/Bolvar_Fordragon"},
    {"Stormwind"},
    {"npc:bolvar", "npc:vancleef", "faction:stormwind"},
    "Classic / Forever")

Curated("region:5765737465726e20506c616775656c616e6473",
    "Western Plaguelands",
    "Region",
    "The Western Plaguelands lay across the former farmlands of Lordaeron, where the ruins of Andorhal marked one of the great disasters of the plague. Grain from the town had carried the sickness outward. In the countryside, Scourge cauldrons continued to poison the air above farms that had once sustained the kingdom.\n\nThe Alliance worked from Chillwind Camp and the Horde from the Bulwark, each seeking ways to turn the cauldrons against their makers. Araj the Summoner held Andorhal for the Scourge. Across the water, Scholomance occupied Caer Darrow, an enclosed school of necromancy whose locked entrance concealed another source of the undead threat.\n\nThe Scarlet Crusade's presence at Hearthglen added a human conflict to the blighted landscape. The region's struggle was not simply to win back roads and ruined buildings: it was to stop the forces that kept spreading death through the land.",
    {"https://warcraft.wiki.gg/wiki/Western_Plaguelands_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5215 and #5228 The Scourge Cauldrons; #5533 Scholomance; #105 Alas, Andorhal; #5944 In Dreams"},
    {"the Western Plaguelands"},
    {"place:andorhal", "place:caer-darrow", "dungeon:scholomance"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("book:seven-kingdoms",
    "The Seven Kingdoms",
    "Book",
    "The Seven Kingdoms is a historical book from the History of Warcraft, recounting the dissolution of the human empire of Arathor. Its story begins with Strom still the acknowledged center of a growing network of cities. Dalaran develops its magical learning, Gilneas and Alterac their armies, and Kul Tiras its maritime trade; prosperity gradually loosens the unity that once bound them.\n\nThe lords of Strom migrate north and establish Lordaeron, while Thoradin's descendants eventually journey south to found Stormwind. Warriors who remain in the old capital preserve it as Stromgarde. The resulting seven realms—Alterac, Dalaran, Gilneas, Kul Tiras, Lordaeron, Stormwind and Stromgarde—share an origin but develop separate customs and loyalties. The book explains how the human nations inherited Arathor's civilization while losing its common political purpose.",
    {"https://warcraft.wiki.gg/wiki/The_Seven_Kingdoms"},
    {},
    {"book:alliance-lordaeron"},
    "Classic / Forever")

Curated("book:alliance-lordaeron",
    "The Alliance of Lordaeron",
    "Book",
    "The Alliance of Lordaeron is a History of Warcraft book about the coalition that fought the Second War. After Stormwind's fall, Anduin Lothar brings its survivors north. Facing the prospect of further conquest, the seven human nations unite under his military command, with dwarven and high elven support. King Terenas's gathering of the rulers turns the refugees' warning into a common defense.\n\nThe account follows the Horde's advance under Orgrim Doomhammer and the fracture caused when Gul'dan abandons the campaign to seek the Tomb of Sargeras. That betrayal allows the Alliance to recover. Lothar falls at Blackrock Spire, but Turalyon rallies the army and drives the Horde back to the Dark Portal, which the victors destroy. The closing settlement places captured orcs in internment camps and establishes Nethergarde to watch the ruined gateway.",
    {"https://warcraft.wiki.gg/wiki/The_Alliance_of_Lordaeron", "https://news.blizzard.com/en-us/article/23229617/warcraft-iii-the-story-so-far"},
    {},
    {"book:seven-kingdoms", "event:second-war", "faction:alliance"},
    "Classic / Forever")

Curated("relic:doomhammer",
    "Doomhammer",
    "Relic",
    "The Doomhammer is the warhammer associated with the Doomhammer family and carried by Warchief Orgrim Doomhammer during the Horde's wars against humanity. Its name belongs to the weapon as well as to the warrior who made it feared across Azeroth. In Thrall's hands, it has become an emblem of the orcs' liberation and the inheritance of Orgrim's leadership.\n\nOrgrim fought beside Thrall to free the internment camps, but a mounted attacker mortally wounded him from behind at the camp remembered as Hammerfall. Gor'mul, a former prisoner, still recalls the Warchief's raised hammer and the despair of seeing him fall. The weapon and Orgrim's armor passed to Thrall, whose possession of them is invoked to give Gor'mul hope. The Doomhammer thus connects the Horde's violent past with the struggle to recover its freedom and spiritual traditions.",
    {"https://warcraft.wiki.gg/wiki/Doomhammer", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 655 Hammerfall; 672 Raising Spirits)"},
    {"the Doomhammer", "Doomhammer (weapon)"},
    {"npc:orgrim", "npc:thrall", "event:doomhammer-fall"},
    "Classic / Forever")

Curated("book:dark-portal-fall-stormwind",
    "The Dark Portal and the Fall of Stormwind",
    "Book",
    "The Dark Portal and the Fall of Stormwind is a History of Warcraft book recounting the First War. Sargeras uses the possessed Medivh and the warlock Gul'dan to bring the orcish Horde from Draenor into Azeroth.\n\nLothar and Khadgar kill Medivh at Karazhan, but the invasion continues. Orgrim replaces Blackhand as Warchief; Garona murders King Llane, and Stormwind falls. The book closes with Lothar finding his homeland ruined and vowing to reclaim it. The next history, The Alliance of Lordaeron, follows his survivors north, where their warning helps bring the human nations together against the Horde.",
    {"https://warcraft.wiki.gg/wiki/The_Dark_Portal_and_the_Fall_of_Stormwind", "https://warcraft.wiki.gg/wiki/The_Alliance_of_Lordaeron"},
    {},
    {"event:first-war", "npc:medivh", "book:alliance-lordaeron"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:gelbin",
    "Gelbin Mekkatorque",
    "Person",
    "Gelbin Mekkatorque is the gnomes' elected High Tinker and a celebrated inventor. When troggs invaded Gnomeregan, he followed Thermaplugg's advice and released toxic radiation. The defense killed more gnomes than invaders, leaving him burdened by the lives lost.\n\nNow found in Ironforge's Tinker Town, Mekkatorque leads a displaced people determined to recover their home. He speaks bitterly of having trusted Thermaplugg, whose betrayal left the gnomes in exile and the mad mekgineer in control of their city. His appeal for help makes the immediate objective plain: destroy the betrayer and bring the reclamation of Gnomeregan closer. Even success against Thermaplugg is only a step toward that larger task; the lost capital remains the center of his hopes.",
    {"https://assets.blz-contentstack.com/v3/assets/blt3452e3b114fab0cd/blt2e9295db02a222fc/6025bcbb6968b53d529edb2a/media_manual_classic_enUS.pdf", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2929)", "https://warcraft.wiki.gg/wiki/Gelbin_Mekkatorque"},
    {"High Tinker Mekkatorque", "Mekkatorque", "Gelbin"},
    {"dungeon:gnomeregan"},
    "Classic / Forever")

Curated("npc:vanndar",
    "Vanndar Stormpike",
    "Person",
    "Vanndar Stormpike is the dwarf general who leads the Stormpike expedition from Dun Baldar in northern Alterac Valley. The expedition seeks the valley's resources and ancient relics, but its advance has brought it into war with Drek'Thar's Frostwolves. Alliance officers describe the orcs as an obstacle to exploration; the Frostwolves regard the expedition as an invasion of their home.\n\nVanndar answers that dispute with a determined claim that the valley will belong to the Stormpikes. From his fortified position he rallies his soldiers against attackers and refuses to abandon the mission. Defeating him is the Frostwolf army's central objective, just as the Stormpikes aim to break Drek'Thar's command.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7141, 7142)", "https://warcraft.wiki.gg/wiki/Vanndar_Stormpike", "https://worldofwarcraft.blizzard.com/en-us/news/23237900/wow-classic-warsong-gulch-and-alterac-valley-now-live"},
    {"General Vanndar Stormpike", "Vanndar"},
    {"npc:drekthar", "faction:stormpike", "battleground:alterac-valley"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:4475736b776f6f64",
    "Duskwood",
    "Region",
    "Duskwood is the darkened woodland south of Elwynn Forest, where Darkshire's people depend on the Night Watch to defend their homes. Commander Althea Ebonlocke has too few watchers to contain the undead gathering at Raven Hill Cemetery. Beyond the road, worgen overrun the Rotting Orchard and haunt the surrounding woods.\n\nThe region's horrors have personal histories. Darkshire's account of the Embalmer tells of an alchemist who placed his own heart inside his dead wife Eliza, restoring her to a life sustained by human flesh. Above Raven Hill, Morbent Fel shelters behind protective magic while Sven Yorgen seeks the means to destroy him. The Night Watch's patrols hold together a community surrounded by abandoned farms, restless graves and grief turned into violence.",
    {"https://warcraft.wiki.gg/wiki/Duskwood_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 58, 221, 253, 55)"},
    {},
    {"region:456c77796e6e20466f72657374"},
    "Classic / Forever")

Curated("region:466572616c6173",
    "Feralas",
    "Region",
    "Feralas is a deep forest in southern Kalimdor, its giant trees and overgrown night-elf ruins sheltering the remains of an older world. Dire Maul rises amid those ruins. The Horde maintains Camp Mojache inland, while General Shandris Feathermoon commands the night elves' stronghold on Sardor Isle off the western coast.\n\nThe forest is contested well beyond those settlements. Gordunni ogres occupy ruined night-elf structures in the High Wilderness, leaving withered trees and damaged ground around their camps. At Camp Mojache, their expansion is treated as a threat to the land itself. Elsewhere, the Grimtotem capture faerie dragons, provoking night elves to free the creatures and strike back. Feralas's living abundance therefore shares its ground with ruined settlements and inhabitants willing to despoil it.",
    {"https://warcraft.wiki.gg/wiki/Feralas_%28Classic%29", "https://warcraft.wiki.gg/wiki/Feathermoon_stronghold", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2975, 2980, 2969)"},
    {},
    {"dungeon:dire-maul", "npc:shandris"},
    "Classic / Forever")

Curated("region:456c77796e6e20466f72657374",
    "Elwynn Forest",
    "Region",
    "Elwynn Forest surrounds Stormwind's approaches with farms, woodland, mines and logging camps. Northshire Abbey stands in a sheltered valley, while Goldshire serves travelers near the roads leading out through the kingdom. Its familiar inns and cultivated fields make the forest seem secure, but the city's soldiers are repeatedly called to protect the people living beyond its walls.\n\nKobolds have entrenched themselves in Echo Ridge Mine near Northshire. Defias gangs maintain scattered camps and prey on the surrounding countryside, while aggressive murlocs have settled along eastern Elwynn's streams. Even near the abbey, Garrick Padfoot's band threatens farmers and merchants. These troubles make Elwynn the kingdom's vulnerable home country: close to the capital, yet dependent on local guards and outside help.",
    {"https://warcraft.wiki.gg/wiki/Elwynn_Forest_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 21, 83, 35, 6)"},
    {"Elwynn"},
    {"region:53746f726d77696e642043697479", "group:defias"},
    "Classic / Forever")

Curated("region:5468652048696e7465726c616e6473",
    "The Hinterlands",
    "Region",
    "The Hinterlands are a forested region of northeastern Lordaeron where the Wildhammer dwarves and several forest-troll tribes contest the hills and ruins. Aerie Peak anchors the Wildhammers in the west; its renowned aviary and gryphon riders give the clan a reach far beyond its mountain home. Falstad's complaints of trolls and the clan's plans to expand around Skulk Rock show that its position remains contested.\n\nThe trolls are divided among the Vilebranch, Witherbark and Revantusk. The Vilebranch hold the great terraces of Jintha'Alor; Revantusk describes them as depraved, feeding on trolls and humanoids. On the eastern coast, Revantusk Village offers a Horde-friendly foothold and seeks help against its neighbors. The region's conflicts follow these distinct loyalties, rather than a single common troll cause.",
    {"https://warcraft.wiki.gg/wiki/Hinterlands_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1449, 2877, 7844)"},
    {"Hinterlands"},
    {"faction:wildhammer", "npc:falstad"},
    "Classic / Forever")

Curated("region:53656172696e6720476f726765",
    "Searing Gorge",
    "Region",
    "North of Blackrock Mountain, the Searing Gorge is a scorched landscape of lava, excavation works and Dark Iron strongholds. The Cauldron and the tunnels of the Slag Pit form the center of its brutal industry. Slavers and taskmasters oversee workers among mining works, while golems and fire elementals make the surrounding ground dangerous.\n\nAt Thorium Point, the independent Thorium Brotherhood opposes its Dark Iron neighbors. Its craftsmen seek stolen smithing tools and offer rewards for attacks on the slavers and taskmasters below. The struggle reaches the sentry towers as well: Kalaran Windblade directs the making of a magical torch capable of keeping those watch posts ablaze. In the Gorge, workshops, mines and fortifications are all part of the contest for the mountain's approaches.",
    {"https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_lr.pdf", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 3442, 3443, 3463, 7728, 7729)"},
    {"the Searing Gorge"},
    {"place:blackrock-mountain", "place:thorium-point", "faction:thorium-brotherhood"},
    "Classic / Forever")

Curated("region:4275726e696e672053746570706573",
    "Burning Steppes",
    "Region",
    "The Burning Steppes lie south of Blackrock Mountain, among the scars left when Sorcerer-Thane Thaurissan summoned Ragnaros during the War of the Three Hammers. The Firelord's emergence shattered the surrounding mountains, killed Thaurissan and enslaved the surviving Dark Irons. The ruins of their old capital remain in the blackened landscape.\n\nThe mountain's powers still endanger the country around it. Blackrock orcs hold fortified positions, while black dragons and their kin range across the Steppes. From Morgan's Vigil, Helendis Riverhorn seeks help against the dragonkin and warns Redridge that the black dragonflight controls the Blackrock orcs. Farther within the mountain, the Dark Irons' summoning of Overmaster Pyron has disturbed the elements. The region is both a record of an ancient catastrophe and a route through which new threats reach Stormwind's borders.",
    {"https://warcraft.wiki.gg/wiki/War_of_the_Three_Hammers_%28History_of_Warcraft%29", "https://warcraft.wiki.gg/wiki/Burning_Steppes_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4182, 4183, 3906)"},
    {"the Burning Steppes"},
    {"place:blackrock-mountain", "npc:ragnaros", "faction:blackrock-clan"},
    "Classic / Forever")

Curated("event:war-of-the-spider",
    "War of the Spider",
    "Event",
    "The War of the Spider was Ner'zhul's struggle to conquer the nerubian kingdom of Azjol-Nerub beneath Northrend. As the Lich King built his undead power around Icecrown, the spider-lords resisted with armies and an extensive network of underground passages. Living nerubians were immune to both his plague and his mental domination, frustrating the methods by which he subdued other peoples.\n\nTheir mobile attacks could not withstand endless attrition. With dreadlord aid and vast undead forces, Ner'zhul invaded their kingdom and destroyed its subterranean temples. Resistance to the plague did not protect the fallen: he raised nerubian corpses to serve the power they had fought. He also adopted their architecture for his own strongholds, turning the forms of a defeated civilization into monuments of his expanding rule.",
    {"https://warcraft.wiki.gg/wiki/War_of_the_Spider_%28History_of_Warcraft%29"},
    {"The War of the Spider"},
    {},
    "Classic / Forever")

Curated("event:internment-liberation",
    "Liberation of the Orc internment camps",
    "Event",
    "The liberation of the internment camps transformed the defeated orcs into Thrall's renewed Horde. Raised as a slave by Aedelas Blackmoore at Durnholde, Thrall escaped and found his captive people sunk in despair. Grom Hellscream's Warsong resistance and the Frostwolves' ancestral traditions helped him recover a purpose beyond the demonic wars of the old Horde.\n\nOrgrim Doomhammer joined the campaign to free the prisoners. At the camp later called Hammerfall, a mounted attacker mortally wounded him from behind; survivors remembered the shock of seeing their liberator fall. Thrall inherited his hammer, armor and leadership. The renewed Horde assaulted Blackmoore's Durnholde and broke open the camps, giving the captives freedom and a revived spiritual identity. In Classic, Gor'mul's lingering grief shows that liberation did not erase every wound left by captivity and loss.",
    {"https://warcraft.wiki.gg/wiki/The_New_Horde", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 655, 672)"},
    {"Liberation of the internment camps", "Liberation of the Orc Internment Camps"},
    {"npc:thrall", "npc:orgrim", "npc:grom"},
    "Classic / Forever")

Curated("relic:ashbringer",
    "Ashbringer",
    "Relic",
    "Ashbringer is the legendary sword associated with Highlord Alexandros Mograine and his destruction of the undead. Its reputation outlives him: at Light's Hope Chapel, Scarlet envoys hope that recovering it could turn the war, while Eligor Dawnbringer insists that its strength was inseparable from the man who wielded it. Mograine himself now serves among Naxxramas's Four Horsemen, bearing the corrupted blade.\n\nRenault's murder of his father stained the weapon. When it is carried into Scarlet Monastery, the crusaders kneel and Alexandros's spirit confronts and kills his betrayer. Fairbanks describes the lost sword's history and speaks of another son who might forge a replacement. These revelations leave Ashbringer a symbol of broken faith and unresolved hope; they do not restore the original blade.",
    {"https://warcraft.wiki.gg/wiki/Crusade_Commander_Eligor_Dawnbringer", "https://warcraft.wiki.gg/wiki/Corrupted_Ashbringer", "https://warcraft.wiki.gg/wiki/Corrupted_Ashbringer/Scarlet_Monastery_Event"},
    {"The Ashbringer", "Corrupted Ashbringer"},
    {"npc:highlord-mograine", "dungeon:naxxramas", "dungeon:scarlet-monastery"},
    "Classic / Forever")

Curated("relic:frostmourne",
    "Frostmourne",
    "Relic",
    "Frostmourne is the cursed runeblade Arthas claimed in Northrend while pursuing Mal'Ganis during the Third War. Muradin Bronzebeard read its warning and urged him to abandon it, but Arthas accepted any price for the power to take revenge. When the blade's icy prison shattered, Muradin was struck down and Arthas believed him dead. The prince discarded his paladin's hammer and took the sword.\n\nIts apparent victory concealed another master's claim: Frostmourne consumed souls, and Arthas's own was its first victim. The voice speaking through Frostmourne was the Lich King's, and Arthas obeyed it when he struck down Mal'Ganis. Rather than returning as his people's savior, he wandered the frozen wastes under the weapon's influence, losing himself to its dark will. The sword marks the surrender of a prince who sought power to save his homeland and became the instrument of its destruction.",
    {"https://warcraft.wiki.gg/wiki/Frostmourne_%28WC3_Human%29", "https://warcraft.wiki.gg/wiki/Trudging_through_the_Ashes_%28WC3_Undead%29"},
    {},
    {"npc:arthas", "event:third-war", "npc:lich-king"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:556e27476f726f20437261746572",
    "Un'Goro Crater",
    "Region",
    "Un'Goro Crater is a deep bowl of jungle in southern Kalimdor, where dinosaurs roam beneath steep enclosing cliffs. Fire Plume Ridge rises at its center, its hot slopes prowled by fire elementals. The lush crater is a dangerous place to study: Williden Marshal's expedition lost its camps to the wildlife and withdrew to higher ground at Marshal's Refuge.\n\nAmong the expedition's puzzles are the colored crystals scattered across the crater. J.D. Collie experiments with them and asks explorers to locate the mysterious crystal pylons. Her work begins with questions, samples and rumors, rather than a settled explanation of the land. The refuge gives those investigations a foothold in a wilderness that has already driven the researchers from their first camps.",
    {"https://warcraft.wiki.gg/wiki/Un%27Goro_Crater_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 3884, 4284, 4285)"},
    {"Un'Goro"},
    {"region:54616e61726973"},
    "Classic / Forever")

Curated("region:48696c6c736272616420466f6f7468696c6c73",
    "Hillsbrad Foothills",
    "Region",
    "Hillsbrad Foothills spreads through southern Lordaeron, where cultivated fields and coastal roads lie between opposing settlements. Southshore remains an Alliance town, while the Forsaken hold Tarren Mill. Their conflict reaches directly into the farms: High Executor Darthalia orders attacks on Hillsbrad's landowners and food supply, then on the miners supplying iron to Alliance armories.\n\nIn Tarren Mill, Apothecary Lydon pursues another form of warfare. Working with Faranell in the Undercity, he prepares a plague mixture and plans to test it on captive farmers through a tainted keg. These are the immediate stakes beneath Hillsbrad's pastoral appearance: fields, mines and prisoners have become targets in the struggle for the living countryside.",
    {"https://warcraft.wiki.gg/wiki/Hillsbrad_Foothills_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 527, 539, 509, 513, 524)"},
    {"Hillsbrad"},
    {"place:tarren-mill", "place:southshore", "npc:varimathras"},
    "Classic / Forever")

Curated("region:417a7368617261",
    "Azshara",
    "Region",
    "Azshara is a broken coast of northeastern Kalimdor, where autumn-colored woodland overlooks cliffs, beaches and the remains of night elven settlements. Naga haunt the shore, while ghosts and satyrs make the inland ruins dangerous. The Alliance outpost at Talrendis Point and the Horde camp at Valormok offer small footholds in a country dominated by older remains.\n\nThe Ruins of Eldarath preserve more than fallen buildings. Ancient elven mages once displayed tablets and runes in public, setting out their findings and the rules of arcane magic. Tymor seeks rubbings of these inscriptions for study, but the Explorers' League is not alone in its interest. Those who search the ruins are seeking knowledge that survived its makers' vanished world, with naga in the waters below.",
    {"https://warcraft.wiki.gg/wiki/Azshara_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 3449)"},
    {},
    {"place:eldarath"},
    "Classic / Forever")

Curated("region:54686f7573616e64204e6565646c6573",
    "Thousand Needles",
    "Region",
    "Thousand Needles is a dry canyon of towering stone pillars in southern Kalimdor. The tauren settlement of Freewind Post stands above its floor, but height offers little safety for its supply routes. Centaur raids have destroyed a caravan, and the Grimtotem at Darkcloud Pinnacle are another danger. Arnak Grimtotem is wanted for murder and kidnapping, while guarded messages point to secret dealings within the clan.\n\nFarther east, the canyon opens onto the Shimmering Flats and Mirage Raceway. Gnomes and goblins compete in rocket cars across the salt flats, leaving wreckage for scavengers to collect and sell back to the racers. The region holds both precarious settlements among the cliffs and this noisy contest of engineering, where another crash can mean another business opportunity.",
    {"https://warcraft.wiki.gg/wiki/Thousand_Needles_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4542, 5064, 5147, 1110)"},
    {},
    {"place:freewind"},
    "Classic / Forever")

Curated("region:5765746c616e6473",
    "Wetlands",
    "Region",
    "The Wetlands form the marshy northern approaches to Khaz Modan. At Menethil Harbor, Alliance ships connect the Eastern Kingdoms with Auberdine and Theramore across the sea. Inland, the roads lead toward Loch Modan and the Thandol Span, making this difficult country an important link between the dwarven lands and the north.\n\nThat link is under attack. Dark Iron dwarves have taken Dun Modr after an ambush at the Span, leaving Longbraid's regiment badly depleted. The surviving defenders lack the men even to search for a missing scout. Orders recovered from his body reveal a cache of explosives intended for the remaining bridge; if it is destroyed, their northern supply line will be cut. The marsh's crossings matter as much as its harbor.",
    {"https://warcraft.wiki.gg/wiki/Wetlands_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 472, 631, 632, 633)"},
    {"the Wetlands"},
    {"place:menethil", "faction:dark-iron"},
    "Classic / Forever")

Curated("region:4465736f6c616365",
    "Desolace",
    "Region",
    "Desolace is harsh country on Kalimdor's western coast, occupied by rival centaur clans and scattered newcomers. The Horde holds Shadowprey Village on the coast and Ghost Walker Post inland; the Alliance has a foothold at Nijel's Point. Among the centaur, the Gelkis and Magram fight a bitter war. Outsiders seek advantage by supporting one clan against the other, earning an audience through attacks on its enemies.\n\nThe region also shelters the Burning Blade at Thunder Axe Fortress and other camps. At Ghost Walker Post, Maurin Bonesplitter investigates a demonic contract bearing Lord Azrethoc's signature, while Takata Steelblade seeks help against the demon and his warlock servant. Rival clans and hostile summoners make the settlers' hopes for a lasting home uncertain.",
    {"https://warcraft.wiki.gg/wiki/Desolace_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1368, 1382, 1435, 1480, 1488)"},
    {},
    {"dungeon:maraudon", "faction:gelkis"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:antonidas",
    "Archmage Antonidas",
    "Person",
    "Antonidas was the elder archmage who led Dalaran's Kirin Tor and trained Jaina Proudmoore. When a mysterious prophet warned that Lordaeron faced destruction and urged flight to Kalimdor, Antonidas dismissed him. Reports of a magical plague seemed a more immediate concern, and he sent Jaina to investigate with a special envoy.\n\nThe disaster eventually reached Dalaran in the form of Arthas, now a death knight commanding the Scourge. Antonidas and his fellow archmages raised magical fields that harmed undead entering the city, refusing Arthas's demand for surrender. The attackers killed the wizards sustaining those defenses and Arthas slew Antonidas himself. With the archmage fallen, Kel'Thuzad claimed the Book of Medivh and prepared to use it to summon Archimonde. Antonidas's last stand could not keep the city's dangerous knowledge from the invaders.",
    {"https://static.wikia.nocookie.net/wowpedia/images/a/ab/Warcraft_III_RoC_manual.pdf/revision/latest?format=original", "https://warcraft.wiki.gg/wiki/Jaina%27s_Meeting_%28WC3_Human%29", "https://warcraft.wiki.gg/wiki/The_Siege_of_Dalaran_%28WC3_Undead%29"},
    {"Antonidas", "Lord Antonidas"},
    {"npc:jaina", "npc:arthas", "event:third-war"},
    "Classic / Forever")

Curated("event:formation-horde",
    "Formation of the Horde",
    "Event",
    "The original Horde arose on Draenor as Gul'dan and the Shadow Council drove the orc clans toward conquest. The clans sharpened their violence in deadly arena contests, while Durotan's warnings against their growing hatred went unheard. Kil'jaeden sought something more binding than ambition: through the council, he brought Mannoroth before the chieftains. Grom Hellscream led them in drinking the demon's blood, while Durotan refused. The bargain placed the orcs in bondage to the Burning Legion.\n\nGul'dan then united the rival clans and installed Blackhand as a warchief he could manipulate. Under Blackhand, the Horde devastated the draenei, leaving few survivors. Its victory created a dangerous problem: an army consumed by bloodlust needed further enemies or would turn upon itself. The new union had become the Legion's weapon, with its public warlord concealing the council's control.",
    {"https://warcraft.wiki.gg/wiki/Rise_of_the_Horde_%28History_of_Warcraft%29"},
    {"The Formation of the Horde"},
    {"npc:guldan", "faction:shadow-council", "event:first-war"},
    "Classic / Forever")

Curated("event:creation-lich-king",
    "Creation of the Lich King",
    "Event",
    "When Ner'zhul escaped the breaking world of Draenor into the Twisting Nether, Kil'jaeden captured him. The demon destroyed the shaman's body while preserving his conscious spirit, then offered continued service as the only escape from endless torment. Ner'zhul accepted and was imprisoned within a block of enchanted ice. His mind expanded into a powerful, bodiless presence: the Lich King.\n\nNer'zhul's loyal death knights and Shadowmoon followers were also transformed into skeletal liches, bound to serve him. Kil'jaeden intended this new force to succeed where the fractious Horde had failed. Ner'zhul would spread a plague that killed the living and raised them under his command, preparing Azeroth for the Legion. A new body was promised as his reward, but the demon distrusted him. The dreadlords policed the prisoner; Tichondrius, their most powerful and cunning, was fascinated by the plague's potential.",
    {"https://warcraft.wiki.gg/wiki/The_Birth_of_the_Lich_King"},
    {"Birth of the Lich King", "The Creation of the Lich King"},
    {"npc:lich-king", "faction:burning-legion"},
    "Classic / Forever")

Curated("relic:bindings-windseeker",
    "Bindings of the Windseeker",
    "Relic",
    "The Bindings of the Windseeker are two halves of a talisman holding the surviving essence of Thunderaan. Highlord Demitrian tells how Ragnaros, aided by Garr and Baron Geddon, struck the Windseeker by surprise. The Firelord could not consume all of his captive's essence, so he divided what remained between the two bindings and entrusted them to his lieutenants.\n\nDemitrian seeks to free his master. The bindings, elementium and the essence taken from Ragnaros are used to prepare Thunderaan's release, drawing adventurers from Molten Core to Silithus. The release brings a confrontation with the Windseeker himself. After his defeat, the dormant blade he leaves behind is returned to the cowering Demitrian, who is forced to awaken Thunderfury. The relics thus link an ancient elemental betrayal to the making of the legendary sword.",
    {"https://warcraft.wiki.gg/wiki/Highlord_Demitrian", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7786, 7787)"},
    {"Bindings of the Wind Seeker"},
    {"dungeon:molten-core"},
    "Classic / Forever")

Curated("place:sunwell",
    "Sunwell",
    "Place",
    "The Sunwell was Quel'Thalas's great magical fount, the power on which the high elves had come to depend. During the Third War, Arthas carried Kel'Thuzad's remains into their kingdom, seeking the well's magic to raise the slain necromancer. The Scourge overcame the elven defense, and Arthas used its waters to restore Kel'Thuzad as a lich. That act fouled the sacred source at the heart of the elves' life.\n\nThe loss reached beyond the battlefield. Prince Kael'thas later described his surviving people as cut off from their magical birthright and feared they could not live without another source. Their hunger for magic made new offers of power perilously attractive. The Sunwell's ruin was therefore both a victory for the Scourge and a lasting crisis for the elves who survived it.",
    {"https://warcraft.wiki.gg/wiki/Sunwell_-_The_Fall_of_Quel%27Thalas", "https://wowwiki-archive.fandom.com/wiki/A_Dark_Covenant"},
    {"The Sunwell"},
    {"npc:arthas", "event:third-war"},
    "Classic / Forever")

Curated("relic:skull-guldan",
    "Skull of Gul'dan",
    "Relic",
    "The Skull of Gul'dan retained the dead warlock's magical power and became an artifact sought by both mortals and demons. During the Alliance expedition to Draenor, Khadgar recovered it as one of the tools needed to seal the Dark Portal, alongside the Book of Medivh.\n\nBy the Third War, Tichondrius controlled the skull and used its power to corrupt Kalimdor's forests. Arthas directed Illidan toward it, explaining that his own master would benefit from the dreadlord's defeat. Illidan destroyed the skull and claimed its power, transforming himself into a demonic being strong enough to kill Tichondrius. He presented the victory as a chance for the forests to heal, but Malfurion recoiled from the price and banished him. The artifact's destruction ended one source of corruption while changing its conqueror.",
    {"https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal_missions", "https://warcraft.wiki.gg/wiki/Skull_of_Gul%27dan_%28Warcraft_III%29", "https://warcraft.wiki.gg/wiki/A_Destiny_of_Flame_and_Sorrow"},
    {"The Skull of Gul'dan"},
    {"npc:guldan", "npc:khadgar", "npc:illidan"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:revantusk",
    "Revantusk Tribe",
    "Faction",
    "The Revantusk are forest trolls living on the eastern coast of the Hinterlands. After learning of Thrall's new Horde, they entered a pact of friendship and mutual assistance with it. Primal Torntusk leads the tribe from Revantusk Village, where the help of Horde adventurers strengthens a small community threatened by its neighbors.\n\nThe Vilebranch make that danger immediate. A midnight raid carries off Primal's mate, Elder Torntusk, to Jintha'alor. Primal's spies report that Torntusk is alive there and that Vile Priestess Hexx is said to be preparing him for sacrifice to Hakkar. Primal appeals for his rescue, warning that the village cannot bear such a loss. His liberation and return make the Horde's assistance a personal debt as well as a political alliance.",
    {"https://warcraft.wiki.gg/wiki/Primal_Torntusk", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7845, 7846, 7847)"},
    {"Revantusk", "Revantusk trolls", "Revantusk tribe"},
    {"place:revantusk", "faction:horde"},
    "Classic / Forever")

Curated("faction:stormwind",
    "Stormwind (faction)",
    "Faction",
    "Stormwind represents the human kingdom within the Alliance, with its royal court in Stormwind City. In King Varian's absence, the child king Anduin is protected by Highlord Bolvar Fordragon, who serves as regent. The faction's reach extends through the surrounding human settlements, whose defense depends on the kingdom's strained soldiers and on adventurers acting in its service.\n\nWhen Lakeshire reports that black dragons command the Blackrock threat, Bolvar refuses to commit scarce troops without proof. He instead empowers an acting deputy to continue the investigation, leaving the frontier to rely on that mission. Service also takes quieter forms: Clavicus Knavingham accepts cloth donations, and continued contributions earn Stormwind's recognition. The faction binds these local duties to the wider human cause within the Alliance.",
    {"https://classicdb.ch/?faction=72", "https://warcraft.wiki.gg/wiki/Bolvar_Fordragon", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4184, 4185, 4186)", "https://classicdb.ch/?quest=7796"},
    {"Stormwind (reputation faction)", "Stormwind faction", "Stormwind reputation"},
    {"region:53746f726d77696e642043697479", "npc:bolvar", "faction:alliance"},
    "Classic / Forever")

Curated("faction:gnomeregan-exiles",
    "Gnomeregan Exiles",
    "Faction",
    "The Gnomeregan Exiles are the displaced gnomes of the Alliance, sheltering in Ironforge after the loss of their underground home. Troggs and radiation left Gnomeregan a disaster that its survivors are still trying to understand and reverse. High Tinker Gelbin Mekkatorque leads their effort to recover the city, bitterly condemning Mekgineer Thermaplugg's betrayal and rule over its ruins.\n\nTheir work joins vengeance to reconstruction. Mekkatorque asks allies to destroy Thermaplugg, treating his defeat as one step toward reclaiming Gnomeregan. Other gnomes investigate the radiation and try to salvage damaged inventions, including Techbot's memory core. The exiles remain a people with a home to recover, lending their ingenuity to the Alliance while keeping that unfinished task close.",
    {"https://classicdb.ch/?faction=54", "https://classicdb.ch/?quest=2929", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2927, 2922)"},
    {"Gnomeregan Exiles (faction)", "Gnomeregan Exiles (reputation faction)"},
    {"dungeon:gnomeregan", "npc:gelbin", "faction:alliance"},
    "Classic / Forever")

Curated("faction:darnassus",
    "Darnassus (faction)",
    "Faction",
    "Darnassus represents the night elves within the Alliance, taking its name from their capital in Teldrassil. High Priestess Tyrande Whisperwind leads them from the Temple of the Moon, while Fandral Staghelm directs the druids from the Cenarion Enclave. Their concerns reach beyond the tree to night elf forces and allies across Kalimdor.\n\nTyrande's recognition follows such service. Reports from Stonetalon bring adventurers before Tyrande, while Kindal and Jer'kai thank those who free captive faerie dragons in Feralas and give a signet to carry the story to her. Supporting this people also means supplying its reserves: Raedon Duskstriker's cloth drive rewards contributions with Darnassus's recognition. The faction's reputation reflects a relationship with the night elves and their cause, extending beyond a visit to their city.",
    {"https://classicdb.ch/?faction=69", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1081, 2969, 2972)", "https://classicdb.ch/?quest=7800"},
    {"Darnassus (reputation faction)", "Darnassus faction", "Darnassus reputation"},
    {"region:4461726e6173737573", "npc:tyrande", "npc:fandral"},
    "Classic / Forever")

Curated("book:sargeras-betrayal",
    "Sargeras and the Betrayal",
    "Book",
    "Sargeras and the Betrayal is a History of Warcraft book about the Pantheon's champion becoming the enemy of its work. Its account presents the eredar and dreadlords as demonic peoples whose cruelty drives Sargeras toward despair. He abandons faith in the Titans' ordered universe and decides to destroy what they have built.\n\nThe story then follows his liberation of the demons he had imprisoned and the assembly of the Burning Legion. Kil'jaeden recruits new servants, while Archimonde commands the armies. The book explains the Legion's origin through the fall of its intended adversary: the warrior charged with resisting demons instead gives them a common purpose.",
    {"https://wowpedia.fandom.com/wiki/Sargeras_and_the_Betrayal", "https://warcraft.wiki.gg/wiki/Sargeras_and_the_Betrayal"},
    {},
    {"npc:sargeras", "faction:burning-legion"},
    "Classic / Forever")

Curated("book:guardians-tirisfal",
    "The Guardians of Tirisfal",
    "Book",
    "The Guardians of Tirisfal is a History of Warcraft book explaining a secret defense against the Burning Legion. Dalaran's reckless magic draws demons into the city, prompting its rulers to seek elven help. Humans and elves agree to empower one champion with their combined magic while concealing the danger from the public. The Council of Tirisfal oversees the choice of Guardians and the transfer of power between successors. The book connects magical ambition with the duty to contain its consequences.",
    {"https://warcraft.wiki.gg/wiki/The_Guardians_of_Tirisfal"},
    {"Guardians of Tirisfal (book)"},
    {"npc:medivh", "faction:burning-legion"},
    "Classic / Forever")

Curated("book:lethargy-orcs",
    "Lethargy of the Orcs",
    "Book",
    "Lethargy of the Orcs is a History of Warcraft book about the defeated orcs in Alliance internment camps. The growing expense of confinement leads Terenas to levy taxes, adding to the disputes weakening the human alliance. Meanwhile, the prisoners lose their will to escape or fight, leaving their wardens puzzled by a people once known for relentless aggression.\n\nAntonidas proposes that the lethargy is withdrawal from generations of demonic influence, rather than an ordinary disease. He finds no cure, and other leaders question whether helping the orcs is desirable. His conclusion is that recovery must be spiritual. The account presents an investigation and its hypothesis, linking the prisoners' condition to both their former corruption and their captors' political burdens.",
    {"https://wowpedia.fandom.com/wiki/Lethargy_of_the_Orcs"},
    {},
    {"faction:horde", "event:second-war"},
    "Classic / Forever")

Curated("book:charge-dragonflights",
    "Charge of the Dragonflights",
    "Book",
    "Charge of the Dragonflights is a History of Warcraft book describing the trust the departing Titans placed in Azeroth's dragons. Five flight leaders receive portions of the Pantheon's power and become the Dragon Aspects, charged with protecting the world.\n\nThe account gives each a distinct responsibility: Nozdormu guards time, Alexstrasza safeguards life, Ysera watches the wilds through the Emerald Dream, Malygos protects magic, and Neltharion tends the earth and its depths. The book records the shared charge the Titans entrusted to the five flights.",
    {"https://warcraft.wiki.gg/wiki/Charge_of_the_Dragonflights"},
    {"Charge of the Dragonflights (book)"},
    {"faction:dragonflights", "npc:nozdormu", "npc:alexstrasza"},
    "Classic / Forever")

Curated("relic:benediction",
    "Benediction",
    "Relic",
    "Benediction is a priest's staff that can become Anathema, exchanging its healing and holy strength for a form devoted to shadow magic. Its making joins the Eye of Divinity and Eye of Shadow with a Splinter of Nordrassil, a fragment of the World Tree.\n\nThe splinter is earned through Eris Havenfire's ordeal in the Eastern Plaguelands. Unable to save peasants fleeing Stratholme, she is trapped in the repetition of that tragedy. A priest must protect and heal the fugitives as they struggle toward safety from the Scourge. Success earns the right to the splinter; the two Eyes are then needed to form the staff. Benediction's power is therefore tied to the preservation of lives that Eris could not save.",
    {"https://classicdb.ch/?item=18608", "https://classicdb.ch/?item=18609", "https://warcraft.wiki.gg/wiki/Splinter_of_Nordrassil", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7622)", "https://www.wowhead.com/classic/npc%3D14494/eris-havenfire", "https://warcraft.wiki.gg/wiki/A_Warning"},
    {"Anathema", "Benediction and Anathema", "Benediction/Anathema"},
    {"dungeon:stratholme"},
    "Classic / Forever")

Curated("relic:sulfuras",
    "Sulfuras, Hand of Ragnaros",
    "Relic",
    "Sulfuras, Hand of Ragnaros, is the Firelord's legendary two-handed hammer, a weapon that casts fire at its targets and burns those who strike its bearer. Its creation for a mortal wielder requires two distinct pieces: a blacksmith's Sulfuron Hammer and the Eye of Sulfuras taken from Ragnaros in Molten Core. The Eye's power transforms the crafted weapon into the legendary mace.\n\nThe Thorium Brotherhood supplies the hammer's plans through a contract involving a Sulfuron ingot. The smith must gather rare metals and fiery materials, including dark iron, arcanite and fiery cores. The Brotherhood carefully disclaims responsibility for the dangers of the undertaking. Craftsmanship prepares the vessel; the Eye completes Sulfuras.",
    {"https://classicdb.ch/?item=17182", "https://classicdb.ch/?item=17204", "https://www.classicdb.ch/?item=18592", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7604)", "https://warcraft.wiki.gg/wiki/Eye_of_Sulfuras"},
    {"Sulfuras", "Hand of Ragnaros"},
    {"npc:ragnaros", "dungeon:molten-core", "faction:thorium-brotherhood"},
    "Classic / Forever")

Curated("region:54656c6472617373696c",
    "Teldrassil",
    "Region",
    "Teldrassil is the immense new World Tree off northern Kalimdor, bearing Darnassus and a forest of night elf settlements in its branches. After Nordrassil's sacrifice at Mount Hyjal cost the night elves their immortality, Fandral Staghelm persuaded the Circle of Ancients to grow another tree. He hoped to restore what had been lost, but Nozdormu refused his blessing and Alexstrasza agreed. The new home did not restore immortality, and its growth remained flawed.\n\nPaths wind from Shadowglen through Dolanaar toward Darnassus, passing moonwells sacred to the night elves. Those waters also help the druids examine the tree's condition. Crazed Gnarlpine furbolgs hamper Sentinel patrols, while strange creatures trouble the forest. Beneath the shelter of its enormous canopy, Teldrassil's inhabitants must protect a homeland whose apparent abundance conceals an unresolved corruption.",
    {"https://warcraft.wiki.gg/wiki/Teldrassil_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 921, 929, 933, 935, 7383)"},
    {},
    {"npc:fandral", "region:4461726e6173737573"},
    "Classic / Forever")

Curated("region:53746f6e6574616c6f6e204d6f756e7461696e73",
    "Stonetalon Mountains",
    "Region",
    "The Stonetalon Mountains form a rugged passage between Ashenvale, the Barrens and Desolace. Forested heights and narrow valleys shelter tauren at Sun Rock Retreat and night elves at Stonetalon Peak, the local Horde and Alliance footholds. Mirkfallon Lake and the wooded slopes contrast with Windshear Crag, where the Venture Company's logging operation strips the mountainside.\n\nThe company's cutting and burning do more than destroy timber: they throw the forest spirits into pain and rage. Tauren seek to halt the devastation and calm those spirits, while an Alliance gnome pursues devices to drive the goblins back. Farther southwest, the ruined Charred Vale presents another struggle for the region's protectors. Bloodfury harpies threaten neighboring life, and calls to break their strength turn the recovery of the land into a continuing battle.",
    {"https://warcraft.wiki.gg/wiki/Stonetalon_Mountains_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1062, 1071, 6282, 6283)"},
    {"Stonetalon"},
    {"faction:venture-company", "region:417368656e76616c65"},
    "Classic / Forever")

Curated("region:5765737466616c6c",
    "Westfall",
    "Region",
    "Westfall is Stormwind's troubled farming country, a landscape of neglected fields, scattered homesteads and coastal mines. The Defias Brotherhood has driven people from their land and established a network reaching through farms, the Gold Coast Quarry and Moonbrook. Gnolls and rogue harvest golems add to the dangers faced by families still trying to make a living there.\n\nAt Sentinel Hill, Gryan Stoutmantle leads the People's Militia in an effort to restore peace. Direct help from Stormwind is scarce; even the militia's armor supply depends on an arrangement with a city merchant. Patrols against raiders uncover a larger conspiracy, drawing the militia's attention toward Edwin VanCleef and the Defias stronghold beneath Moonbrook. The struggle for Westfall therefore reaches from individual farmsteads into the Deadmines, where the Brotherhood's leadership directs its campaign against the kingdom.",
    {"https://warcraft.wiki.gg/wiki/Westfall_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 12, 13, 14, 65, 132, 166, 6181)"},
    {},
    {"group:defias", "npc:vancleef", "dungeon:deadmines"},
    "Classic / Forever")

Curated("region:57696e746572737072696e67",
    "Winterspring",
    "Region",
    "Winterspring is a snowy valley in northeastern Kalimdor, reached from Felwood through the furbolg tunnels of Timbermaw Hold. The Steamwheedle goblins' neutral trading post of Everlook connects its roads, while night elf settlements and the ruins around Lake Kel'Theril preserve an older presence. Blue dragons inhabit Mazthoril, and wildkin guard secrets amid the remote hills and groves.\n\nThe landscape's apparent stillness hides several conflicts. Winterfall furbolgs crowd the Frostfire Hot Springs and obstruct Donova Snowden's investigation of their unusual waters. A vial recovered from a Winterfall furbolg contains a green residue that reminds her of Felwood's corruption. Seeing Winterfall runners traveling through Timbermaw Hold, she suspects a connection with the corrupted Deadwood tribe and asks that it be investigated. Her suspicions make the neighboring regions relevant to Winterspring's troubles, without establishing the springs themselves as the corruption's source.",
    {"https://warcraft.wiki.gg/wiki/Winterspring_%28Classic%29", "https://warcraft.wiki.gg/wiki/Winterspring", "https://warcraft.wiki.gg/wiki/Everlook", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4521, 5082, 5083, 5084)"},
    {},
    {"place:everlook", "place:timbermaw-hold", "faction:winterfall"},
    "Classic / Forever")

Curated("region:4c6f6368204d6f64616e",
    "Loch Modan",
    "Region",
    "Loch Modan is the dwarven country east of Dun Morogh, centered on the great lake held by the intact Stonewrought Dam. Thelsamar provides a settlement and travel hub beside the loch, while mountain passages connect the region to the Wetlands and the Badlands. Explorers work among ancient ruins at Ironband's Excavation, part of the dwarves' continuing search beneath their own homeland.\n\nIronforge's authority does not make the countryside secure. Stonesplinter troggs threaten the king's lands, and trogg activity also delays the work at Ironband's dig. At the dam, Chief Engineer Hinderweir fears a Dark Iron attack while too few guards remain to protect it. Suspicious powder found by its eastern ramp turns that fear into an investigation of sabotage.",
    {"https://warcraft.wiki.gg/wiki/Loch_Modan_%28original%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 224, 250, 161, 436)"},
    {},
    {"region:49726f6e666f726765", "faction:explorers-league", "dungeon:uldaman"},
    "Classic / Forever")

Curated("region:41726174686920486967686c616e6473",
    "Arathi Highlands",
    "Region",
    "The Arathi Highlands lie in southeastern Lordaeron, between Thoradin's Wall and the crossing into the Wetlands at the Thandol Span. Their human heritage reaches back to Arathor, whose capital was Strom, the city later known as Stromgarde. In the present, Stromgarde's defenders struggle amid ruins occupied by the Syndicate and Boulderfist ogres. The Syndicate even pays bounties for fallen militia members' badges, making the recovery of those trophies a duty to their families.\n\nThe Alliance maintains Refuge Pointe, while the Horde holds Hammerfall. These footholds anchor competing efforts to retain a place in the highlands. Nearby Arathi Basin turns that rivalry into a struggle for supplies: the League of Arathor and the Defilers fight over farms, mines, timber and workshops. The region's old human legacy thus remains tied to immediate questions of survival and control.",
    {"https://warcraft.wiki.gg/wiki/Arathi_Highlands_%28Classic%29", "https://warcraft.blizzplanet.com/arathor_and_the_troll_wars/", "https://worldofwarcraft.blizzard.com/en-us/news/23320961/wow-classic-arathi-basin-now-available", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 682, 8105, 8120)"},
    {"Arathi"},
    {"place:stromgarde", "faction:syndicate", "battleground:arathi-basin"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:brann",
    "Brann Bronzebeard",
    "Person",
    "Brann Bronzebeard is a dwarven explorer and the youngest brother of Magni and Muradin. His travels carry him far beyond Ironforge: accounts of his journeys follow him through Elwynn Forest, Westfall and Stranglethorn Vale, recording the lands and inhabitants he encounters.\n\nIn Silithus, exploration draws him toward Ahn'Qiraj. A lost letter reports that most of his companions are dead, but that he has found important clues to the ancient conflict between the titans and the Old Gods. He intends to follow an old tunnel into the sealed city. Even amid that danger, he asks that his monkey be fed, watered and given affection at the expedition's camp.\n\nBrann's trail does not end with that letter. Anachronos later confirms that the dwarf entered Ahn'Qiraj carrying the base of Atiesh and subsequently left the city. The staff's base remained behind, making his expedition part of the search to restore the shattered greatstaff.",
    {"https://warcraft.wiki.gg/wiki/Quotes_of_Warcraft_III/Human_Alliance", "https://warcraft.wiki.gg/wiki/Journey_of_Brann", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 8308, 9251)", "https://classicdb.ch/?quest=9251"},
    {"Brann"},
    {"npc:magni", "faction:explorers-league", "place:ahnqiraj"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("book:war-ancients",
    "The War of the Ancients (book)",
    "Book",
    "The War of the Ancients is a History of Warcraft book about the Legion's first invasion. Highborne magic attracts Sargeras to Azeroth. Malfurion, Illidan and Tyrande seek Cenarius's aid, gathering resistance against the demons.\n\nDeathwing's betrayal drives the surviving dragons from the struggle. With their allies overwhelmed, Malfurion argues that the Well of Eternity sustains the invasion. Tyrande persuades their companions to attack Azshara's temple and shut it down, despite the Well's importance to their own people.",
    {"https://warcraft.wiki.gg/wiki/The_War_of_the_Ancients"},
    {"War of the Ancients (book)"},
    {"event:war-ancients", "npc:malfurion", "npc:azshara"},
    "Classic / Forever")

Curated("book:kiljaeden-shadow-pact",
    "Kil'jaeden and the Shadow Pact",
    "Book",
    "Kil'jaeden and the Shadow Pact is a History of Warcraft book tracing the corruption of Draenor's orcs. Planning another Legion invasion of Azeroth, Kil'jaeden seeks a mortal army that can exhaust its defenders before the demons arrive. He works through the elder shaman Ner'zhul, spreading aggression among the clans, but Ner'zhul resists surrendering his people completely to violence.\n\nThe demon then turns to Ner'zhul's ambitious apprentice, Gul'dan, offering power for obedience. Gul'dan embraces warlock magic and teaches it to others while undermining the old shamanic traditions. With Kil'jaeden's help, he establishes the Shadow Council to manipulate the clans in secret. The chapter ends with the cost to Draenor itself: the spreading demonic magic blights its waters and leaves once-fertile land barren.",
    {"https://wowpedia.fandom.com/wiki/Kil%27jaeden_and_the_Shadow_Pact"},
    {"Shadow Pact", "Kil'jaeden and the Shadow Pact (book)"},
    {"npc:kiljaeden", "npc:nerzhul", "faction:shadow-council"},
    "Classic / Forever")

Curated("book:betrayer-ascendant",
    "The Betrayer Ascendant",
    "Book",
    "The Betrayer Ascendant is a History of Warcraft book following Illidan's return from imprisonment. After consuming the Skull of Gul'dan, he gains demonic power and memories that point toward the Tomb of Sargeras. Kil'jaeden offers him a place among the Legion's rulers if he destroys the increasingly independent Lich King.\n\nIllidan recruits Lady Vashj's naga and reaches the tomb despite Maiev's pursuit. With the Eye of Sargeras, he channels Dalaran's magical power into an attack on distant Icecrown. The chapter describes the damage to the Lich King's defenses, then credits Malfurion and Tyrande's arrival with stopping the spell. Illidan flees to Outland to escape Kil'jaeden's anger, while Maiev follows to recapture him. The account closes with that pursuit still unresolved.",
    {"https://warcraft.wiki.gg/wiki/The_Betrayer_Ascendant"},
    {"The Betrayer Ascendant (book)"},
    {"npc:illidan", "npc:kiljaeden", "relic:skull-guldan"},
    "Classic / Forever")

Curated("event:grim-batol",
    "Battle of Grim Batol",
    "Event",
    "The Battle of Grim Batol ends the Dragonmaw's captivity of Alexstrasza after the Second War. The clan has used her offspring as weapons, holding the Dragonqueen through the Demon Soul. Rhonin's rescue mission draws in Vereesa Windrunner, Falstad and the dragon Korialstrasz, known among Dalaran's mages as Krasus. Deathwing pursues his own scheme to seize Alexstrasza's eggs.\n\nAs the other Aspects fight Deathwing, Rhonin discovers that a piece of the black dragon's own scale can cut the Demon Soul when their other attempts fail. He breaks the artifact and directs its released power back to the dragons. Restored to their full strength, the Aspects overwhelm Deathwing and force him to flee. On the ground, the rescuers help the dwarves defeat the remaining orcs, who surrender and are ordered sent to the Alliance's camps.",
    {"https://www.zanotowane.pl/1119/3568/"},
    {"The Battle of Grim Batol"},
    {"npc:alexstrasza", "npc:deathwing", "faction:dragonflights"},
    "Classic / Forever")

Curated("book:twin-empires",
    "The Twin Empires",
    "Book",
    "The Twin Empires is a history book about ancient Kalimdor's trolls: the Gurubashi of the southeastern jungles and the Amani of the central forests. Though rivals, both fought the expansionist insectoid aqir. Their long struggle split the enemy into northern and southern realms, associated with Azjol-Nerub and Ahn'Qiraj.\n\nThe book also reports a legend that an offshoot of the Amani settled near the Well of Eternity and became the first night elves. It explicitly leaves that ancestry unproven.",
    {"https://warcraft.wiki.gg/wiki/The_Twin_Empires"},
    {"The Twin Empires (book)"},
    {"place:ahnqiraj", "book:war-ancients"},
    "Classic / Forever")

Curated("relic:book-medivh",
    "Book of Medivh",
    "Relic",
    "The Book of Medivh is the Last Guardian's surviving spellbook, containing formidable knowledge of demons and the magic needed to bring them into Azeroth. Archimonde considers its lost incantations essential to his arrival and orders Kel'Thuzad to retrieve it from Dalaran.\n\nArthas breaks through the city's defenses and kills Antonidas, allowing the lich to claim the tome. Studying its demon lore, Kel'Thuzad prepares the summoning while Arthas holds off the city's counterattack. The ritual succeeds: Archimonde enters Azeroth, making the stolen book a crucial instrument of the Legion's return. Its value lies in dangerous knowledge that survives the death of its author.",
    {"https://warcraft.wiki.gg/wiki/Blackrock_%26_Roll%2C_Too%21_%28WC3_Undead%29", "https://warcraft.wiki.gg/wiki/The_Siege_of_Dalaran_%28WC3_Undead%29", "https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_%28WC3_Undead%29"},
    {},
    {"npc:medivh", "npc:khadgar", "npc:kelthuzad"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:4475726f746172",
    "Durotar",
    "Region",
    "Durotar is the dry coastal homeland shared by the orcs and Darkspear trolls in eastern Kalimdor. Orgrimmar stands at its northern end; farther south, Razor Hill and Sen'jin Village connect the new Horde's settlements with the Valley of Trials. There, recruits begin with modest tests of strength before taking on the dangers beyond the valley.\n\nThe homeland is far from secure. The Kul Tiran force was repelled and Tiragarde Keep fell, but Admiral Proudmoore's reserves, led by Lieutenant Benedict, have retaken it. Inland, the Burning Blade cultivates another threat: Fizzle Darkstorm works in Thunder Ridge, while cultists gather in Skull Rock near Orgrimmar itself. The route from a recruit's training ground to the Horde's capital passes through struggles over whether this hard-won home can endure.",
    {"https://warcraft.wiki.gg/wiki/Durotar_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4641, 788, 784, 806, 828)", "https://classic.warcraftdb.com/data/faction/530"},
    {},
    {},
    "Classic / Forever")

Curated("region:4261646c616e6473",
    "Badlands",
    "Region",
    "The Badlands are an arid region of Khaz Modan, cut by rocky ridges and canyons south of Loch Modan. The Horde holds an outpost at Kargath, while Dark Iron dwarves occupy Angor Fortress and black dragons haunt Lethlor Ravine. In the north, the excavation at Uldaman draws prospectors toward ancient ruins, but Stonevault troggs make the search dangerous.\n\nAgmond's death leaves his fellow prospectors trying to understand the troggs and the ancient urns uncovered at the Uldaman dig. Elsewhere, Lotwil Veriatus studies rock elementals in the hope of binding one to his service. The region also preserves an unsettled legacy of the Second War: Horde agents seek the deaths of the imprisoned black dragons Blacklash and Hematus, former allies whose continued presence has become a matter of honor. Research, buried history and old allegiances all bring travelers into this seemingly barren country.",
    {"https://warcraft.wiki.gg/wiki/Badlands_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 704, 710, 782)"},
    {"the Badlands"},
    {},
    "Classic / Forever")

Curated("region:5377616d70206f6620536f72726f7773",
    "Swamp of Sorrows",
    "Region",
    "The Swamp of Sorrows is a tangled wetland in the southern Eastern Kingdoms. Stonard serves as the Horde's principal foothold, while the Harborage shelters draenei threatened by the Lost Ones at Fallow Sanctuary. These former brethren have become enemies: the Harborage's people describe their madness, stolen sacred crystals and attacks by Noboru and his followers.\n\nFarther east, the Pool of Tears surrounds the sunken Temple of Atal'Hakkar. Horde investigators sent by the Warchief seek to understand the Atal'ai trolls and their forbidden magic. Green dragons guard the temple, claiming to protect Azeroth, but the investigators still need artifacts from the pool to piece together its history. The swamp's isolated settlements live beside dangers whose origins are only gradually uncovered through the people, relics and ruins that remain.",
    {"https://warcraft.wiki.gg/wiki/Swamp_of_Sorrows_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1389, 1392, 1424)"},
    {"the Swamp of Sorrows"},
    {},
    "Classic / Forever")

Curated("region:417368656e76616c65",
    "Ashenvale",
    "Region",
    "Ashenvale is an ancient forest of northern Kalimdor and a homeland of the night elves. Astranaar lies along its woodland roads, while the Horde maintains footholds at Splintertree Post and Zoram'gar on the western coast. The forest's resources are also a cause of war: Warsong lumber operations cut into lands the Silverwing Sentinels fight to reclaim, with the struggle extending to Warsong Gulch.\n\nThe conflict is sustained by practical needs as well as rival claims. Horde lumber camps require tools, rope and oil, and their missing supplies lead into territory held by furbolgs and satyrs. Those satyrs occupy places such as Xavian, Night Run and Satyrnaar. On the Zoram Strand, naga gather around the drowned ruins of Zoram. Beneath the forest canopy and along its shore, ancient dangers persist alongside the newer struggle between the Alliance and Horde.",
    {"https://warcraft.wiki.gg/wiki/Ashenvale_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6571, 6441, 6442)", "https://warcraft.wiki.gg/wiki/Silverwing_Sentinels"},
    {},
    {},
    "Classic / Forever")

Curated("region:44756e204d6f726f6768",
    "Dun Morogh",
    "Region",
    "Dun Morogh is the snowy mountain country of Khaz Modan surrounding Ironforge. Dwarven settlements and guarded passes connect Coldridge Valley with Kharanos and the great city, while Gnomeregan lies to the west. The landscape is a homeland of workshops, mines and mountaineer posts, but even the roads near these settlements are troubled.\n\nTrogg attacks stretch the defenders thin. In Coldridge, Grelin Whitebeard investigates the Frostmane trolls while the Senate's attention is occupied by the trogg threat; his stolen journal must be recovered before he can finish his report for Senir in Kharanos. Gnomeregan's disaster adds another struggle. Gnomes working in Kharanos search for a remedy to radiation, while High Tinker Mekkatorque seeks help reclaiming the city from Thermaplugg. The snowbound settlements shelter people trying both to defend their present homes and to recover what they have lost.",
    {"https://warcraft.wiki.gg/wiki/Dun_Morogh_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 170, 182, 218, 2927, 2929)"},
    {},
    {},
    "Classic / Forever")

Curated("region:4475737477616c6c6f77204d61727368",
    "Dustwallow Marsh",
    "Region",
    "Dustwallow Marsh stretches across a swampy part of central Kalimdor. Jaina Proudmoore's Theramore stands on its eastern coast, while Brackenwall Village is a Horde foothold inland. The peace between their peoples is uneasy: Theramore infiltrators report on Horde movements near Brackenwall, and Horde defenders are sent to hunt them down despite the truce.\n\nIn the south, black dragons have driven the Stonemaul ogres from their home. Onyxia's brood in the Wyrmbog and Dragonmurk threatens any attempt to return, while the crisis exposes resentment of the ogres' leader, Mok'Morokk. Another mystery waits at the burned Shady Rest Inn. A strange shield and a badge bearing Lieutenant Paval Reethe's name provide clues, but do not yet explain the fire. The marsh holds both open dangers and questions its inhabitants have not resolved.",
    {"https://warcraft.wiki.gg/wiki/Dustwallow_Marsh_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1201, 1169, 1172, 1251, 1252, 1319)"},
    {"Dustwallow"},
    {},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:thoradin",
    "Thoradin",
    "Person",
    "Thoradin was king of Arathor, the human nation whose capital was Strom. The Arathi had united rival human tribes through conquest followed by offers of peace and equality, creating a common defense against the trolls.\n\nThoradin initially refused to endanger his people for the distant high elves. Their envoys persuaded him that Arathor would be next if Quel'Thalas fell. Though he distrusted magic, he accepted elven instruction for one hundred human magi in exchange for military aid. The combined armies and their sorcerers defeated the trolls near the Alterac Mountains. The elves then pledged friendship to Arathor and Thoradin's royal bloodline.",
    {"https://warcraft.wiki.gg/wiki/Arathor_and_the_Troll_Wars"},
    {"King Thoradin"},
    {"place:stromgarde", "region:41726174686920486967686c616e6473", "npc:lothar"},
    "Classic / Forever")

Curated("faction:shattered-hand",
    "Shattered Hand Clan",
    "Faction",
    "The Shattered Hand was one of the orc clans of Draenor, led by Kargath Bladefist. Its warriors demonstrated loyalty by mutilating or severing their left hands and fitting weapons in their place, a brutal custom reflected in their chieftain's own blade.\n\nIn Orgrimmar, the Shattered Hand name also identifies an organization that recruits and tests rogues. Therzok criticizes Thrall's caution and argues that the Horde should recover its old strength through secret attacks. A prospective recruit is sent to kill Tazan, a trader dealing with pirates near Ratchet, and recover his information. Obtaining the key to the stolen satchel through Gamon completes the test. These assignments reveal a present-day network of covert operatives alongside the older clan's martial identity.",
    {"https://warcraft.wiki.gg/wiki/Warcraft_II%3A_Beyond_the_Dark_Portal_manual", "https://warcraft.wiki.gg/wiki/Shattered_Hand_clan", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1963)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1858)", "https://warcraft.wiki.gg/wiki/The_Shattered_Hand_%28Classic%29"},
    {"Shattered Hand", "The Shattered Hand", "Shattered Hand clan"},
    {"faction:horde", "npc:thrall"},
    "Classic / Forever")

Curated("faction:gurubashi-empire",
    "Gurubashi Empire",
    "Faction",
    "The Gurubashi ruled the jungles of southeastern Kalimdor before the Sundering, one of the two great troll empires alongside the forest-dwelling Amani. After the world's destruction, famine drove the Gurubashi to seek divine help. Hakkar granted power that expanded their dominion, but demanded ever more souls and sought a physical foothold from which to devour mortal life.\n\nThe tribes eventually rebelled. Hakkar's loyal Atal'ai priests fought them in a war that shattered the empire. The rebels banished the god's avatar and expelled the Atal'ai from Zul'Gurub; the victors then divided into competing tribes. In the present, the Zandalar invoke that disaster when urging adventurers against Hakkar's followers in Zul'Gurub. The old empire's ruin makes his renewed rise a threat with a remembered cost.",
    {"https://warcraft.wiki.gg/wiki/The_Twin_Empires", "https://warcraft.wiki.gg/wiki/Wrath_of_Soulflayer", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 8078)"},
    {"Ancient Gurubashi Empire"},
    {"npc:hakkar", "dungeon:zulgurub", "faction:zandalar"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:tervosh",
    "Archmage Tervosh",
    "Person",
    "Archmage Tervosh is a mage serving Lady Jaina Proudmoore in Theramore. When the search for Stormwind's missing king reaches Dustwallow Marsh, he brings Jaina's offer of assistance and directs the investigation toward Private Hendel. The soldier is guarding infiltrators who have been observing the Horde at Brackenwall. Tervosh's concern is to bring him back alive for questioning, preserving a lead that could otherwise be lost.\n\nHis work also extends beyond the marsh. With Jaina's permission, Tervosh asks travelers to collect fragments from the stone elementals of Maraudon. He calls these crystals shadowshards and studies their arcane properties, fashioning pendants from the samples. The same mage who aids a delicate political investigation is also pursuing practical magical research through Theramore's travelers.",
    {"https://classicdb.ch/?quest=1265", "https://classicdb.ch/?quest=1266", "https://classicdb.ch/?quest=1324", "https://classicdb.ch/?quest=7070"},
    {"Tervosh"},
    {"npc:jaina", "npc:private-hendel", "place:theramore"},
    "Classic / Forever")

Curated("npc:bishop-delavey",
    "Bishop DeLavey",
    "Person",
    "Bishop DeLavey is a cleric in Stormwind Keep who quietly seeks help with a missing diplomat. Thomas recruits suitable adventurers on his behalf, asking them to be discreet. DeLavey suspects Defias involvement, but has no complete explanation for the disappearance and fears that it cannot remain secret for long.\n\nHe turns to personal contacts alongside the king's official investigation. A note to Jorgen in the Valley of Heroes opens the way to Elling Trias and a wider network of informants. DeLavey's small request begins a trail that reaches well beyond the keep, drawing the investigator into affairs too sensitive for ordinary tavern conversation.",
    {"https://classicdb.ch/?quest=1274", "https://classicdb.ch/?quest=1241", "https://classicdb.ch/?quest=1242", "https://classicdb.ch/?quest=1245"},
    {"DeLavey"},
    {"region:53746f726d77696e642043697479", "group:defias", "npc:mikhail"},
    "Classic / Forever")

Curated("npc:mikhail",
    "Mikhail",
    "Person",
    "Mikhail is a retired contact of Elling Trias who now tends bar in Menethil Harbor. His welcome changes when Elling's name is mentioned: he is ready to help, but insists that their business remain quiet. During the missing-diplomat investigation, he notices a man listening too closely and urges that the stranger be stopped before he can flee. The listener proves to be Tapoke \"Slim\" Jahn.\n\nSlim's information reveals that the captive is Stormwind's king and names Hendel as an accomplice. Mikhail promises to notify Elling, then points the search toward Commander Samaul in Theramore. He believes Hendel is among the marines who visit the tavern after payday. His years behind the bar have left him with useful contacts, and he admits that he sometimes misses his former, less respectable work.",
    {"https://classicdb.ch/?quest=1248", "https://classicdb.ch/?quest=1249", "https://classicdb.ch/?quest=1250", "https://classicdb.ch/?quest=1264"},
    {},
    {"place:menethil", "npc:private-hendel", "place:theramore"},
    "Classic / Forever")

Curated("npc:private-hendel",
    "Private Hendel",
    "Person",
    "Private Hendel is a Theramore soldier implicated in the abduction of Stormwind's king. Tapoke \"Slim\" Jahn identifies him as the man he helped place aboard the royal ship. Following that lead brings the investigation from Menethil Harbor to Theramore, where Archmage Tervosh locates Hendel on guard duty west of the city.\n\nHendel is protecting resting infiltrators who have been watching Brackenwall. When accused of working with the Defias, he responds with violence. The confrontation must end in his capture: Tervosh intervenes to prevent either his escape or his death, then asks to take him back to Theramore for questioning. Hendel provides a living lead in the search; the original investigation does not conclude with the king's rescue.",
    {"https://classicdb.ch/?quest=1250", "https://classicdb.ch/?quest=1265", "https://classicdb.ch/?quest=1266", "https://classicdb.ch/?quest=1324"},
    {"Hendel"},
    {"npc:tervosh", "npc:mikhail", "place:theramore"},
    "Classic / Forever")

Curated("faction:vilebranch",
    "Vilebranch Tribe",
    "Faction",
    "The Vilebranch are forest trolls of the Hinterlands, with a stronghold at Jintha'Alor. Their Revantusk neighbors describe them as cannibals who prey on other trolls and humanoids, and their raids threaten the smaller coastal tribe.\n\nOne midnight attack carries off Elder Torntusk, Primal Torntusk's mate. Her spies report him alive atop Jintha'Alor, where Vile Priestess Hexx is said to be preparing a sacrifice to Hakkar. The captive's shackles can only be opened with a key held by Hitah'ya the Keeper. His rescue challenges both the Vilebranch's hold over their prisoner and their power over the Revantusk.",
    {"https://warcraft.wiki.gg/wiki/Vilebranch_Berserker", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7844)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7845, 7846, 7847)"},
    {"Vilebranch tribe", "Vilebranch trolls"},
    {"faction:revantusk", "region:5468652048696e7465726c616e6473", "npc:hakkar"},
    "Classic / Forever")

Curated("faction:bleeding-hollow",
    "Bleeding Hollow Clan",
    "Faction",
    "Kilrogg Deadeye's Bleeding Hollow orc clan fought in the First and Second Wars, then evaded Alliance capture in the Black Morass.\n\nNer'zhul helped them return to Draenor, where they joined his forces and supported further conquest.",
    {"https://warcraft.wiki.gg/wiki/Warcraft_II%3A_Beyond_the_Dark_Portal_manual"},
    {"Bleeding Hollow clan", "Bleeding Hollow"},
    {"event:first-war", "event:second-war", "npc:nerzhul"},
    "Classic / Forever")

Curated("faction:kolkar",
    "Kolkar Clan",
    "Faction",
    "The Kolkar are a centaur clan rooted in Desolace whose forces have spread into the Barrens. Their scattered warbands become a greater danger when new leaders rally them. Hezrul Bloodmark leads the Barrens Kolkar from the Lushwater Oasis, while Barak Kodobane holds a camp near the Forgotten Pools. The Horde targets these commanders to break the pressure on its holdings.\n\nThe threat also reaches Durotar, where plans found at Kolkar Crag reveal a coordinated attack against orcs and trolls. In Desolace, Khan Dez'hepah leads the clan. Horde scouts see the rivalries among the centaur clans as a protection against a united enemy, and seek to disrupt the Kolkar before that balance changes.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1362)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 850, 852)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 786)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1365)"},
    {"Kolkar clan", "Kolkar centaurs", "Kolkar centaur"},
    {"region:4465736f6c616365", "region:5468652042617272656e73", "faction:horde"},
    "Classic / Forever")

Curated("faction:dark-horde",
    "Dark Horde",
    "Faction",
    "The Dark Horde is the army gathered under Nefarian in Blackrock Mountain: orcs, trolls and other peoples who continue the Old Horde's bloodthirsty struggle for conquest. They fight Ragnaros and the Dark Iron dwarves for control of the mountain, serving the black dragon's ambition to build a force capable of ruling Azeroth.\n\nRend Blackhand claims the title of Warchief from Blackrock Spire, but answers to Nefarian. His authority depends on the black dragonflight's protection. Thrall refuses to recognize this rival and orders an attack through the Halls of Ascension to kill him. The conflict sets two claimants to the Horde's leadership against one another, with the black dragons sustaining Rend's position.",
    {"https://worldofwarcraft.blizzard.com/en-us/story/timeline/chapter-7", "https://warcraft.wiki.gg/wiki/Eitrigg%27s_Wisdom", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 4974)"},
    {},
    {"faction:blackrock-clan", "npc:nefarian", "npc:rend"},
    "Classic / Forever")

Curated("faction:dragonmaw",
    "Dragonmaw Clan",
    "Faction",
    "The Dragonmaw are an orc clan whose former strength rested on captive red dragons. Captain Stoutfist's account recalls Nekros using magic to control them; when that power failed, the freed dragons killed him and hunted his followers. Survivors fled Grim Batol into the Wetlands, where the clan rebuilt its strength.\n\nNek'rosh, Nekros's son, now leads the Dragonmaw and vows revenge for his father's death. His encampment northeast of Menethil threatens the harbor with catapults, while fighting in Dun Algaz obstructs reinforcements. Stoutfist seeks to destroy the siege engines and kill the chieftain before the clan can turn its renewed strength against Menethil.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 464)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 465, 474)", "https://www.wowhead.com/classic/quest=464/war-banners"},
    {"Dragonmaw clan", "Dragonmaw orcs"},
    {"region:5765746c616e6473", "event:grim-batol", "faction:dragonflights"},
    "Classic / Forever")

Curated("relic:quel-serrar",
    "Quel'Serrar",
    "Relic",
    "Quel'Serrar is an ancient elven blade whose power must be awakened through a dragon's fire and blood. Lorekeeper Lydros of Dire Maul describes a tradition older than the War of the Ancients: such weapons were made with dragons, and each took on qualities of its creator. Returning Foror's Compendium of Dragon Slaying to the library earns the chance to complete one of these unfinished blades.\n\nLydros proposes Onyxia as an unwilling partner in the forging. Her breath must heat the planted blade; after she falls, the heated metal is plunged into her body to temper it. Only then can Lydros bind the finished Quel'Serrar to its new wielder. The blade joins preserved elven knowledge to a dangerous act of dragon slaying.",
    {"https://warcraft.wiki.gg/wiki/Nostro%27s_Compendium", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7507)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7508, 7509)", "https://warcraft.wiki.gg/wiki/Lorekeeper_Lydros"},
    {},
    {"dungeon:dire-maul", "npc:onyxia"},
    "Classic / Forever")

Curated("book:sentinels-long-vigil",
    "The Sentinels and the Long Vigil (book)",
    "Book",
    "The Sentinels and the Long Vigil is a readable chapter of the History of Warcraft. It describes the night elves' guardianship of Kalimdor after the Highborne's departure, as the druids prepare for long sleep in the Emerald Dream. Malfurion honors that obligation despite Tyrande's plea that he remain with her.\n\nTyrande organizes the Sentinels, women trained to defend their homeland. Cenarius, the Keepers of the Grove and the dryads aid their watch over the forests. The chapter closes on the personal cost of the vigil: Tyrande protects Ashenvale without her beloved beside her, fearing that the Burning Legion will return.",
    {"https://warcraft.wiki.gg/wiki/The_Sentinels_and_the_Long_Vigil"},
    {"The Sentinels and the Long Vigil"},
    {"npc:tyrande", "npc:malfurion", "book:exile-high-elves"},
    "Classic / Forever")

Curated("relic:head-onyxia",
    "Head of Onyxia",
    "Relic",
    "The Head of Onyxia is a trophy taken from the defeated black dragon brood mother and brought before the leaders of either faction. Thrall receives it as a great victory for the Horde; in Stormwind, Highlord Bolvar Fordragon sees her death as justice after years under her influence.\n\nThe trophy becomes a public declaration of victory. Overlord Runthak arranges the Horde's celebration in the Valley of Strength, while Major Mattingly honors the Alliance's dragonslayers in the Valley of Heroes. Onyxia's head is displayed at the capital's entrance, and the Rallying Cry of the Dragonslayer shares the triumph with those gathered nearby.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7490, 7495)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7491, 7496)", "https://warcraft.wiki.gg/wiki/Celebrating_Good_Times", "https://warcraft.wiki.gg/wiki/Signs_of_victories"},
    {"Onyxia's head"},
    {"npc:onyxia", "npc:bolvar", "npc:thrall"},
    "Classic / Forever")

Curated("book:world-tree-emerald-dream",
    "The World Tree and the Emerald Dream (book)",
    "Book",
    "The World Tree and the Emerald Dream is a readable History of Warcraft chapter about the pact protecting the second Well of Eternity. Fearing another Legion invasion, Malfurion and three Dragon Aspects agree to guard it. Alexstrasza plants an enchanted acorn in its waters, creating Nordrassil, whose life-giving power will help heal the world.\n\nThe chapter gives the other Aspects distinct roles. Nozdormu protects the night elves from age and disease while the tree stands. Ysera connects Nordrassil to the Emerald Dream; through that bond, the druids promise centuries of sleep while their spirits travel her realm. Their protection therefore carries an obligation that separates them from waking life.",
    {"https://warcraft.wiki.gg/wiki/The_World_Tree_and_the_Emerald_Dream"},
    {"The World Tree and the Emerald Dream"},
    {"place:emerald-dream", "npc:malfurion", "faction:dragonflights"},
    "Classic / Forever")

Curated("book:exile-high-elves",
    "Exile of the High Elves (book)",
    "Book",
    "Exile of the High Elves is a readable History of Warcraft chapter explaining the break between the night elves and the surviving Highborne. Dath'Remar challenges the druids' prohibition on magic while his followers struggle with its loss. Their attempt to force a reversal unleashes a magical storm over Ashenvale.\n\nRather than execute so many of their kin, the druids choose exile. Dath'Remar's followers sail east, seeking a homeland where they can practice magic freely. The chapter follows their departure toward Lordaeron and their intended kingdom of Quel'Thalas, ending with their embrace of the sun and a new identity as high elves.",
    {"https://warcraft.wiki.gg/wiki/Exile_of_the_High_Elves"},
    {"Exile of the High Elves"},
    {"faction:highborne", "npc:malfurion", "book:sentinels-long-vigil"},
    "Classic / Forever")

Curated("relic:rhokdelar",
    "Rhok'delar, Longbow of the Ancient Keepers",
    "Relic",
    "Rhok'delar is the longbow granted to a hunter who answers the ancient spirits' call against the Burning Legion. Returning an Ancient Petrified Leaf to Vartrus begins that relationship. He sends the hunter after disguised demons whose presence corrupts nature, insisting that each be confronted alone. Their severed heads prove that the challenge has been met.\n\nVartrus supplies the stave, but Stoma must make its bowstring from the sinew of a mature black dragon. He cleanses and enchants the material before it is joined to the stave to create Rhok'delar. The bow is distinct from its companion staff, Lok'delar; the blue-dragon sinew sought by Hastat belongs to a separate quiver, not the bow's string.",
    {"https://warcraft.wiki.gg/wiki/Rhok%27delar%2C_Longbow_of_the_Ancient_Keepers", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7632, 7636)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7635, 7636)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7634)"},
    {"Rhok'delar"},
    {"faction:burning-legion", "npc:onyxia", "region:46656c776f6f64"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:53696c6974687573",
    "Silithus",
    "Region",
    "Silithus is the desert at Kalimdor's southwestern edge, where the silithid hives surround the approaches to Ahn'Qiraj. The ancient insect city contains both a ruined outer district and the temple beyond it. From Cenarion Hold, the Cenarion Circle watches a threat that is spreading again: movements within the hives and tremors beneath the sand suggest preparations for a much larger advance. The Circle calls for help from both Horde and Alliance.\n\nThe desert also shelters the Twilight's Hammer. Its cultists keep their writings in a code that the Cenarion investigators struggle to decipher, while the deserter Hermit Ortell hides from his former brethren. A ruined camp overrun by elementals provides another troubling clue to their activities. Even maintaining the watch is difficult: burrowing worms attack the caravans supplying Cenarion Hold, threatening the outpost from which resistance to the desert's dangers is organized.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8275/#8276 Taking Back Silithus; #8280 Securing the Supply Lines; #8279 The Twilight Lexicon; #8284 The Twilight Mystery; #8285 The Deserter", "https://warcraft.wiki.gg/wiki/Silithus_(Classic) (original geography and raid locations only)"},
    {},
    {"place:cenarion-hold", "place:ahnqiraj", "group:twilights-hammer"},
    "Classic / Forever")

Curated("region:5468652042617272656e73",
    "The Barrens",
    "Region",
    "The Barrens is the broad, dry country at the heart of Kalimdor, crossed by roads linking the Horde's settlements. The Crossroads and Camp Taurajo anchor its inland routes, while Ratchet opens the eastern coast to overseas trade. Water gathers in scattered oases, but the routes between settlements are contested. Kolkar centaur leaders rally their clans, and Razormane quilboar raid the caravans carrying supplies from Durotar to the Crossroads.\n\nBeneath this harsh landscape, the druid Naralex sought a way to restore the Barrens to the lush forest it had once been. He entered the Emerald Dream from the Wailing Caverns, hoping to draw its life into the waking world. Instead he became trapped in a nightmare, and the creatures around him changed into dangerous aberrations. His disciples' struggle to wake him ties the hope of renewing the land to a corruption growing beneath its oases.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #850 Kolkar Leaders; #871 Disrupt the Attacks; #872 The Disruption Ends; #1487 Deviate Eradication", "https://warcraft.wiki.gg/wiki/Barrens_(Classic) (original geography, settlements and routes)"},
    {"Barrens"},
    {"place:crossroads", "place:ratchet", "dungeon:wailing-caverns"},
    "Classic / Forever")

Curated("region:426c6173746564204c616e6473",
    "Blasted Lands",
    "Region",
    "The Blasted Lands are the scorched country around the Dark Portal, south of the Swamp of Sorrows. Once part of the Black Morass, this ground was devastated by the portal's corrupting magic. Nethergarde Keep maintains the Alliance's watch over a place whose ruined gateway still marks the route by which the orcs first invaded Azeroth. Demons and Dreadmaul ogres inhabit the wasteland beyond the fortress.\n\nThe demonic overlord Razelikh holds his lair on the region's highest mountain. Below him, the Fallen Hero of the Horde seeks release for soldiers condemned to torment through magical binding stones. Ambassador Ardalan urges the Alliance to set aside its quarrel with the orcs and aid that ghost: while the factions fight over scorched ground, the Burning Legion's strength continues to grow. The land's danger has outlasted the wars that first made it a battlefield.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2783 Petty Squabbles; #2681 The Stones That Bind Us; #3628 You Are Rakh'likh, Demon", "https://warcraft.wiki.gg/wiki/Blasted_Lands_(Classic) (original geography, portal damage, Nethergarde and inhabitants; RPG material excluded)"},
    {"the Blasted Lands"},
    {"place:dark-portal", "place:nethergarde", "npc:khadgar"},
    "Classic / Forever")

Curated("region:4461726b73686f7265",
    "Darkshore",
    "Region",
    "Darkshore is the wooded coast of northwestern Kalimdor, running south toward Ashenvale. The night elf port of Auberdine connects this shore with Teldrassil and, across the sea, Menethil Harbor. Beyond its docks stand the remains of a much older night elf world. In Ameth'Aran, spirits still haunt a city destroyed in the catastrophe surrounding the Well of Eternity; at Bashal'Aran, grell and satyrs feed on magic lingering among the ruins.\n\nThe living forest has its own troubles. Corruption is spreading through the wildlife, and the inhabitants of Auberdine investigate the waters and caverns that might reveal its source. Reports from the Grove of the Ancients lead to the cave behind Cliffspring Falls, where the Ancients fear a new evil has found shelter. Darkshore's ruins and present dangers meet along the same narrow strip of forest and sea.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6342 Flight to Auberdine; #963 For Love Eternal; #954 Bashal'Aran; #947 Cave Mushrooms; #2118 Plagued Lands; #6122 The Principal Source", "https://warcraft.wiki.gg/wiki/Darkshore_(Classic) (original coastline and boat connections only; RPG demographics and history excluded)"},
    {},
    {"place:auberdine", "region:54656c6472617373696c", "region:417368656e76616c65"},
    "Classic / Forever")



-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:maraudine",
    "Maraudine Clan",
    "Faction",
    "The Maraudine are a centaur clan of western Desolace, holding the Valley of Spears at the entrance to Maraudon. They guard a sacred place in centaur life: the caverns contain the remains of Zaetar, whose union with the earth elemental Theradras gave rise to their people. The centaur protect these halls as holy ground, admitting only their most devout.\n\nUnder Khan Hratha, the Maraudine also face the ambitions of rival clans. Both Gelkis and Magram leaders seek his death as a step toward their own supremacy. A war horn on a high bluff in the Valley of Spears can bring the Maraudine warriors and their khan to battle, but the mouthpieces needed to sound it are entrusted only to selected members of the clan.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1380/#1381 Khan Hratha; #7064/#7065 Corruption of Earth and Seed; #7067 The Pariah's Instructions; #7068 Shadowshard Fragments", "https://warcraft.wiki.gg/wiki/Maraudine_clan (original Valley of Spears settlement and Maraudon guardianship only)"},
    {"Maraudine", "Maraudines"},
    {"dungeon:maraudon", "faction:gelkis", "faction:magram"},
    "Classic / Forever",
    true)

Curated("faction:shendralar",
    "Shen'dralar",
    "Faction",
    "The Shen'dralar are Highborne arcanists of Eldre'Thalas who once served Queen Azshara. Prince Tortheldrin sustained them with power siphoned from the imprisoned demon Immol'thar. When the prison's demands overtook its supply, he killed many of his people to preserve power for himself and his zealots.\n\nIn Dire Maul's Athenaeum, the surviving scholars still catalogue their books and seek missing tomes. Lorekeeper Lydros can turn recovered librams into enchantments, treating these useful spells with the disdain of someone who values knowledge far above an outsider's rewards. Elsewhere in the ruined city, a Shen'dralar ghost calls for an end to the prince's rule: destroying Immol'thar would weaken Tortheldrin and offer release to the spirits of his victims.",
    {"Original Shen'dralar Ancient conversation: https://warcraft.wiki.gg/wiki/Shen%27dralar_Ancient", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7461 The Madness Within; #7483 Libram of Rapidity; #7484 Libram of Focus; #7485 Libram of Protection; #7498/#7499/#7500 missing Athenaeum tomes"},
    {},
    {"dungeon:dire-maul", "npc:tortheldrin", "npc:immolthar"},
    "Classic / Forever",
    true)

Curated("relic:heart-hakkar",
    "Heart of Hakkar",
    "Relic",
    "The Heart of Hakkar is the cursed organ of the Soulflayer, still burning with his power even after the blood god's defeat. Taking it from Zul'Gurub does not by itself remove the remaining danger: the heart retains a concentrated remnant of the being the Zandalari came to oppose.\n\nOn Yojamba Isle, Molthor directs his servants to banish the heart into the void. Their ritual provides the final disposal of this dangerous remnant and bestows the Spirit of Zandalar upon those nearby, reaching even Booty Bay. The heart is therefore both evidence of Hakkar's fall and a threat that still requires ritual action.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8183 The Heart of Hakkar", "Original Molthor ritual dialogue: https://warcraft.wiki.gg/wiki/Molthor (Yojamba Isle section); original event effect corroboration: https://warcraft.wiki.gg/wiki/The_Heart_of_Hakkar"},
    {"The Heart of Hakkar"},
    {"npc:hakkar", "faction:zandalar", "dungeon:zulgurub"},
    "Classic / Forever",
    true)

Curated("relic:drakefire-amulet",
    "Drakefire Amulet",
    "Relic",
    "The Drakefire Amulet is an enchanted key to Onyxia's lair in Dustwallow Marsh. Its magic allows the bearer to pass the black dragon's wards, and blood from General Drakkisath provides the power needed to make the key effective. The amulet turns knowledge of the black dragonflight's own enchantments into a means of reaching its brood mother.\n\nThe Alliance's path begins with the broken Dragon's Eye, a fragment of the medallion through which Onyxia controlled Bolvar Fordragon. Haleh identifies it as an enchanted dragon scale and offers to remake it using Drakkisath's blood. The Horde's path instead involves a dormant medallion intended for a guardian of the brood mother. Rexxar explains its blood requirement and offers to activate it. Both routes produce access to the same guarded lair.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6403 The Great Masquerade; #6501 The Dragon's Eye; #6502 Drakefire Amulet; #6601 Ascension...; #6602 Blood of the Black Dragon Champion"},
    {},
    {"dungeon:onyxia", "npc:haleh", "npc:rexxar"},
    "Classic / Forever",
    true)

Curated("relic:atiesh",
    "Atiesh, Greatstaff of the Guardian",
    "Relic",
    "Atiesh is the greatstaff associated with the Guardians of Tirisfal and wielded by Medivh, whose power and corruption were both focused through it. According to its former watcher, Archmage Angela Dosantos, the Kirin Tor recovered it from Karazhan, only to lose the mages who touched it. They sealed the sentient staff behind magical barriers. After Archimonde destroyed Dalaran, it was lost and believed shattered by those protections.\n\nIts scattered pieces remain dangerous. Forty splinters can form the frame, but the head lies with Kel'Thuzad and the base remains in Ahn'Qiraj. Anachronos can guide the reconstruction, yet restoring its physical form does not remove the evil within. The staff must be brought to consecrated ground in Stratholme, where a powerful demon can be forced out and confronted. Reassembling Atiesh and freeing it from Sargeras's influence are separate parts of the same undertaking.",
    {"Original Angela Dosantos Atiesh conversation: https://warcraft.wiki.gg/wiki/Archmage_Angela_Dosantos (World of Warcraft dialogue only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9250 Frame of Atiesh; #9251 Atiesh, the Befouled Greatstaff; #9257/#9269/#9270/#9271 Atiesh, Greatstaff of the Guardian", "Original Splinter of Atiesh use text: https://warcraft.wiki.gg/wiki/Splinter_of_Atiesh ; original staff context corroborated at https://warcraft.wiki.gg/wiki/Atiesh"},
    {"Atiesh", "Greatstaff of the Guardian"},
    {"npc:medivh", "npc:anachronos", "dungeon:naxxramas"},
    "Classic / Forever",
    true)

Curated("book:ancient-tablet-zulfarrak",
    "Ancient Tablet of Zul'Farrak",
    "Book",
    "The Ancient Tablet found among Zul'Farrak's sand trolls preserves instructions for creating the Mallet of Zul'Farrak. Its short inscription sends the reader beyond Tanaris to obtain a sacred mallet from a keeper at the Altar of Zul.\n\nThe final step takes place at the altar atop Jintha'Alor. There, the sacred mallet can be infused with power and transformed. The tablet preserves the method; it is not itself an ingredient consumed in making the mallet.",
    {"Original readable item #9242 Ancient Tablet: https://www.wowhead.com/classic/item=9242/ancient-tablet ; transcript and item provenance: https://warcraft.wiki.gg/wiki/Ancient_Tablet"},
    {"Ancient Tablet", "Zul'Farrak Ancient Tablet"},
    {"relic:mallet-zulfarrak", "dungeon:zulfarrak", "place:jinthaalor"},
    "Classic / Forever",
    nil,
    {"Ancient Tablet"})

Curated("book:beginnings-undead-threat",
    "Beginnings of the Undead Threat",
    "Book",
    "Beginnings of the Undead Threat is a history kept in the Scarlet Monastery's library. Its account looks beyond Arthas's fall to trace the Scourge's origins through the Burning Legion's dealings with the orcs. It describes Ner'zhul's pact with Kil'jaeden, his punishment and transformation into the Lich King, then Kel'Thuzad's recruitment and the Cult of the Damned's part in spreading the plague.\n\nParqual Fintallas seeks the book for his Test of Lore in Undercity. He says the monastery's paladins used it to learn how to fight the undead, but rejects the Scarlet Crusade's refusal to distinguish the Forsaken from the Scourge. In his hands, a text used by those who would destroy him becomes a lesson in why knowledge matters as much as strength.",
    {"Original readable item #5861: https://www.wowhead.com/wotlk/item=5861/beginnings-of-the-undead-threat (Content transcript; original quest item)", "Original Test of Lore #1160 description/progress: https://warcraft.wiki.gg/wiki/Test_of_Lore_(5) ; corroborating preserved progress: https://wowwiki-archive.fandom.com/wiki/Quest:Test_of_Lore_(5)"},
    {},
    {"place:scarlet-library", "npc:nerzhul", "npc:kelthuzad"},
    "Classic / Forever",
    true)

Curated("relic:mallet-zulfarrak",
    "Mallet of Zul'Farrak",
    "Relic",
    "The Mallet of Zul'Farrak is the empowered hammer used to sound the gong that calls Gahz'rilla from the sacred pool in the Sandfury city. It gives access to a summoning secret the trolls guard closely.\n\nThe hammer begins as a sacred mallet held by a keeper at the Altar of Zul in the Hinterlands. Power from the altar atop Jintha'Alor transforms it into the finished instrument. An Ancient Tablet carried by Zul'Farrak's inhabitants records that preparation, linking the pool's ritual to distant troll sanctuaries.",
    {"Original readable item #9242 Ancient Tablet: https://warcraft.wiki.gg/wiki/Ancient_Tablet", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2770 Gahz'rilla", "Original item #9240 and pre-3.0.8 gong use corroboration: https://warcraft.wiki.gg/wiki/Mallet_of_Zul%27Farrak ; https://warcraft.wiki.gg/wiki/Gahz%27rilla (original summoning procedure only)"},
    {},
    {"npc:gahzrilla", "book:ancient-tablet-zulfarrak", "place:jinthaalor"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:abercrombie",
    "Abercrombie",
    "Person",
    "Abercrombie lives in a shack overlooking Raven Hill cemetery in Duskwood, presenting himself as an old man too frail to make the journey to Darkshire. His errands seem to answer ordinary fears: Ghost Hair Thread to ward his door, Zombie Juice against the cold, and ghoul ribs for an effigy. In fact, those acts of kindness supply the Embalmer's work. His letter to Mayor Ello Ebonlocke boasts that its bearer has helped him construct a murderous creature of flesh, bone and metal. The abomination Stitches then threatens Darkshire.\n\nEllo recalls a children's tale about the Embalmer: a kindly alchemist, maddened by his wife Eliza's death, placed his own heart inside her to revive her. The tale says she returned with a hunger for human flesh. Ello sends adventurers to her grave to recover that still-beating heart, believing that taking the source of the Embalmer's power will protect the town.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 133, 134, 148, 157, 159, 160, 165, 252, 253)", "https://wowwiki-archive.fandom.com/wiki/Translated_Letter_from_The_Embalmer", "https://wowwiki-archive.fandom.com/wiki/Bride_of_the_Embalmer_quest_chain_%28Old%29"},
    {"The Embalmer"},
    {"place:darkshire", "region:4475736b776f6f64"},
    "Classic / Forever",
    true)

Curated("npc:stalvan",
    "Stalvan Mistmantle",
    "Person",
    "Stalvan Mistmantle is the former Moonbrook schoolmaster whose surviving papers reveal a murderous obsession. After leaving Westfall, he sought work as a private tutor and taught the children Giles and Tilloa. His journal turns Tilloa's small kindnesses into imagined declarations of love. When she introduces her suitor and calls Stalvan an old man, he treats it as betrayal; a bloodstained page records his growing rage and intention to spill blood.\n\nMadame Eva's fearful vision starts an investigation through Moonbrook, Goldshire, Stormwind and Elwynn. The scattered letters and journal pages connect Stalvan to a massacre that Tavernkeep Smitts and Marshal Haggard had never solved. Clerk Daltry verifies the handwriting against the town registry, and Commander Ebonlocke orders Stalvan's execution at his cottage north of Darkshire. His family ring is to be brought back to Eva as proof that the threat has ended.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 66, 67, 68, 69, 70, 72, 74, 75, 78, 79, 80, 97, 98)", "https://warcraft.wiki.gg/wiki/An_Undelivered_Letter", "https://warcraft.wiki.gg/wiki/A_Torn_Journal_Page", "https://warcraft.wiki.gg/wiki/A_Faded_Journal_Page", "https://www.wowhead.com/item=938/muddy-journal-pages", "https://classicdb.ch/?item=939"},
    {"Stalvan"},
    {"place:darkshire", "region:4475736b776f6f64"},
    "Classic / Forever",
    true)

Curated("npc:seahorn",
    "Fleet Master Seahorn",
    "Person",
    "Fleet Master Seahorn is the tauren who commands the Blackwater Raiders' fleet at Booty Bay. First Mate Crazz brings him into the investigation when a scout uncovers Bloodsail Buccaneer orders for an attack on the port. Seahorn answers the threat by sending adventurers into the Bloodsail command post on the Wild Shore to seize their charts and written orders.\n\nWith the enemy's plans in hand, he chooses a preemptive strike against its leaders. Rather than commit the whole fleet, he sends a skilled party to Firallon's landing place to assassinate the Bloodsail leadership. His confidence and contempt for the rival fleet are backed by a practical aim: break its command before the attack on Booty Bay can begin.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 595, 597, 599, 604, 608)", "https://classicdb.ch/?npc=2487", "https://warcraft.wiki.gg/wiki/Fleetmaster_Seahorn"},
    {"Fleetmaster Seahorn"},
    {"place:booty-bay", "faction:bloodsail"},
    "Classic / Forever")

Curated("npc:regthar",
    "Regthar Deathgate",
    "Person",
    "Regthar Deathgate is an orc warrior directing the Horde's struggle against the centaur from bunkers west of the Crossroads. He sees the rising Kolkar leaders as a danger to the Horde's foothold in the Barrens, and sends adventurers against Barak Kodobane and Hezrul Bloodmark to disrupt their forces.\n\nThe campaign provokes a counterattack: centaur reinforcements come from Desolace under Warlord Krom'zar to avenge their losses. Regthar calls for the bunkers' defense and demands a piece of the warlord's banner as proof of victory. He also recruits agents for Desolace itself, sending them to Felgur Twocuts at Ghost Walker Post. To Regthar, defeating raiders in the Barrens cannot settle the danger while the Kolkar remain strong in their homeland.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 850, 852, 1361, 1362, 4021)", "https://classicdb.ch/?quest=1361", "https://warcraft.wiki.gg/wiki/Regthar_Deathgate"},
    {},
    {"place:crossroads", "faction:kolkar", "region:4465736f6c616365"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:ruins-ravenwind",
    "Ruins of Ravenwind",
    "Place",
    "The Ruins of Ravenwind lie in northern Feralas, where Northspring harpies occupy the remains of an ancient night elf settlement. Among the ruins stands the Equinex Monolith, a shrine whose sealed chamber draws the interest of Troyas Moonbreeze at Feathermoon Stronghold. Four magical flames still burn nearby, holding the essences needed to awaken the shrine's key.\n\nTroyas believes that his stave may be the Stave of Equinex. Charged with the four essences beside the monolith, it can open the chamber and reveal the Morrow Stone. Even after identifying the stone in his books, Troyas does not yet understand its purpose. Ravenwind preserves a mystery that the original expedition only begins to uncover.",
    {"https://warcraft.wiki.gg/wiki/Ruins_of_Ravenwind", "https://warcraft.wiki.gg/wiki/Equinex_Monolith", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2879 The Stave of Equinex; #2942 The Morrow Stone"},
    {},
    {"region:466572616c6173", "place:feathermoon"},
    "Classic / Forever")

Curated("place:sentry-point",
    "Sentry Point",
    "Place",
    "Sentry Point is Theramore's watchtower on the mainland road through Dustwallow Marsh. Its guards watch the approach to the city, and the tower becomes a meeting place during the search for Stormwind's missing diplomat. Commander Samaul believes that Private Hendel was stationed at the first tower outside Theramore and sends the inquiry in that direction.\n\nArchmage Tervosh brings different news: Hendel is no longer there. Acting with Lady Jaina Proudmoore's knowledge, the mage offers help and points farther west, where the soldier guards resting infiltrators who have been watching Brackenwall. The tower is a link between Theramore's garrison and the investigation moving through the marsh.",
    {"https://warcraft.wiki.gg/wiki/Sentry_Point", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1265 The Missing Diplomat; #1266 The Missing Diplomat", "https://wowpedia.fandom.com/wiki/The_Missing_Diplomat_quest_chain"},
    {},
    {"place:theramore", "npc:tervosh", "npc:private-hendel"},
    "Classic / Forever")

Curated("region:5265647269646765204d6f756e7461696e73",
    "Redridge Mountains",
    "Region",
    "In the Redridge Mountains, Lakeshire struggles to keep its roads and settlements within reach. Blackrock orcs have come from the Burning Steppes and occupied Stonewatch Keep, using it as a base for raids that confine the townspeople. Gnoll camps are growing near the approaches to Elwynn as well, leaving Lakeshire's guards worried that the danger will spread beyond their own borders.\n\nRebuilding the Everstill Bridge has stalled for lack of supplies. Iron was consumed making weapons and armor during the last orc invasion; a replacement shipment from Stormwind then fell to gnoll raiders. Magistrate Solomon appeals to Westfall, but its militia declines, occupied with a war of its own. Redridge's work is the work of an exposed community: recovering supplies, watching the roads and trying to hold its ground without the reinforcements it seeks.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #20 Blackrock Menace; #244 Encroaching Gnolls; #89 The Everstill Bridge; #144 Messenger to Westfall"},
    {"Redridge"},
    {"place:lakeshire", "place:stonewatch"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:slim",
    "Tapoke \"Slim\" Jahn",
    "Person",
    "Tapoke \"Slim\" Jahn is the Menethil Harbor rogue hired to put a Defias agent aboard the king of Stormwind's ship. His name surfaces when Dashel Stonefist admits that the Brotherhood had a second kidnapping plan after its first attempt failed. Elling Trias follows that lead through Mikhail, a retired contact working as a bartender in Menethil.\n\nSlim listens too closely to their conversation and must be subdued before he will talk. His confession changes the investigation: the missing traveler was the king himself, bound for a secret meeting with Jaina Proudmoore in Theramore. Slim names the infiltrator as Hendel and says the Defias were working with another party. He gives no name for that partner, leaving the larger plot unresolved.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1247, 1248, 1249, 1250)", "https://warcraft.wiki.gg/wiki/Tapoke_%22Slim%22_Jahn"},
    {"Tapoke Slim Jahn", "Tapoke Jahn", "Slim"},
    {"place:menethil", "group:defias", "npc:elling"},
    "Classic / Forever",
    nil,
    {"Slim"})

Curated("npc:jorgen",
    "Jorgen",
    "Person",
    "Jorgen is a fisherman in Stormwind's Valley of Heroes and an old friend of Bishop DeLavey. When a diplomat disappears on the way to Theramore, DeLavey turns to him while the king's agents pursue their own search. Jorgen agrees to help from a sense of obligation, insisting that the matter remain secret.\n\nHis part is to open the next door. He sends a note to Elling Trias at the cheese shop in the Trade District, telling its bearer to wait quietly for a response. Beneath an ordinary day's fishing lies a trusted connection between the bishop and the cheesemonger's network.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1241, 1242)", "https://warcraft.wiki.gg/wiki/Bishop_DeLavey"},
    {},
    {"region:53746f726d77696e642043697479", "npc:elling"},
    "Classic / Forever",
    true)

Curated("npc:troyas",
    "Troyas Moonbreeze",
    "Person",
    "Troyas Moonbreeze is a night elf researcher at Feathermoon Stronghold who searches Feralas's ruins for clues to their past. A stave found among the rubble catches his attention, though he and Angelas find no explanation in their books. He seeks help from a colleague in Darnassus, whose skepticism about his discoveries does little to diminish his interest.\n\nThe investigation identifies a possible key to the Equinex Monolith in the Ruins of Ravenwind. Troyas explains how essences from the ruins' four enduring flames can charge the stave and open the monument. The artifact within proves to be the Morrow Stone. He recognizes its name and believes its concealment signals importance, but admits that he still does not know its purpose.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 2939, 2879, 2942)", "https://warcraft.wiki.gg/wiki/Troyas_Moonbreeze"},
    {},
    {"place:feathermoon", "region:466572616c6173"},
    "Classic / Forever")

Curated("npc:jorah",
    "Jorah Annison",
    "Person",
    "Jorah Annison works as a cartographer in the Undercity, but would rather read ancient books than make maps. Strahad Farsan values his knowledge of old texts and directs aspiring warlocks to him in search of the Tome of the Cabal, a lost work needed for summoning a felhunter.\n\nJorah traces its scattered parts: pages rumored to be among the centaur of Thousand Needles, and the remainder lost on the coast west of Southshore while being sent to Ironforge. When the complete text reaches him, he eagerly studies it and hopes Strahad will send him a copy. He also identifies a source of channeling rods among the Dragonmaw orcs, helping turn the recovered book into the means for Strahad's summoning ritual.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1801, 1803, 1805, 1795)", "https://warcraft.wiki.gg/wiki/Tome_of_the_Cabal_%283%29"},
    {},
    {"place:undercity", "place:ratchet"},
    "Classic / Forever")

Curated("npc:elling",
    "Elling Trias",
    "Person",
    "Elling Trias sells cheese in Stormwind's Trade District, but his contacts make him a valuable investigator when a diplomat vanishes on the way to Theramore. A note from Jorgen draws him into Bishop DeLavey's inquiry. Beneath his shopkeeper's welcome, Elling knows people who can trace the Defias Brotherhood's movements beyond the city.\n\nHe sends an investigator to Watcher Backus in Darkshire, studies the recovered plans and recognizes the name of Dashel Stonefist. The trail then leads to a man called Slim in Menethil Harbor. Elling directs the search to Mikhail, a former associate who retired there to become a bartender. At this stage even Elling does not know the captive's identity or destination: his task is to make those scattered contacts yield an answer.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1242, 1243, 1245, 1246, 1247, 1248)", "https://warcraft.wiki.gg/wiki/Trias%27_Cheese"},
    {"Trias"},
    {"region:53746f726d77696e642043697479", "npc:jorgen", "group:defias"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:wintersaber-trainers",
    "Wintersaber Trainers",
    "Faction",
    "The Wintersaber Trainers are represented at Frostsaber Rock in Winterspring by the night elf Rivern Frostwind. He trains the fierce local frostsabers as mounts, but insists that a would-be rider earn the acceptance of both trainer and cat. Alliance adventurers can gain that trust through repeated service; only those held in the highest esteem may purchase a Winterspring Frostsaber.\n\nThe work begins with bringing meat from nearby bears and chimaeras to feed the cats. It also means protecting their territory from the violent Winterfall furbolgs and the frostmaul giants. Rivern connects this last duty to an older bond: he recounts how Tyrande Whisperwind saved the frostsaber queen from giants thousands of years ago, beginning the cats' alliance with the night elves. His tests ask a new rider to uphold that relationship through patience and protection.",
    {"Original Rivern Frostwind gossip and original repeatable quests preserved at https://warcraft.wiki.gg/wiki/Rivern_Frostwind ; NPC identity corroborated at https://classicdb.ch/?npc=10618", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4970 Frostsaber Provisions; #5201 Winterfall Intrusion; #5981 Rampaging Giants"},
    {},
    {"place:frostsaber-rock", "region:57696e746572737072696e67"},
    "Classic / Forever",
    true)

Curated("faction:hakkari",
    "Hakkari",
    "Faction",
    "The Hakkari are troll priests of Hakkar the Soulflayer, active in the Sunken Temple and Zul'Gurub. The Atal'ai began as extremists within their priesthood. When Hakkar demanded a physical summoning so he could feed directly upon his victims, most Hakkari recoiled and joined the revolt against him; the Atal'ai remained loyal.\n\nThat rebellion did not erase the Hakkari's earlier crimes. Other trolls killed or exiled them, and embittered survivors eventually sought refuge with the Atal'ai in the Swamp of Sorrows. They renewed their service to Hakkar, helping the cult pursue the summoning even after Ysera sank its temple. Priests from both groups later succeeded in bringing the blood god into Zul'Gurub.\n\nThe Zandalari oppose this restored power. At their Altar of Zanza, Hakkari bijous taken from Zul'Gurub can be destroyed, turning relics of the blood god's followers into an offering against his cause.",
    {"Blizzard's period Troll Compendium, The Hakkari section: https://warcraft.wiki.gg/wiki/Troll_Compendium/Jungle_Troll_Tribes ; June 2006 release corroboration: https://www.mmorpg.com/news/new-realms-trolls-and-more-2000060428", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8240 A Bijou for Zanza"},
    {"The Hakkari"},
    {"group:atalai", "npc:hakkar", "dungeon:zulgurub"},
    "Classic / Forever",
    true)

Curated("relic:tablet-will",
    "Tablet of Will",
    "Relic",
    "The Tablet of Will is a stone shard sought in Uldaman by Hammertoe. Advisor Belgrum recounts a legend that the titans inscribed it with magic for giving their creations life and wills of their own. Hammertoe died before fulfilling his search, leaving Belgrum determined to recover the tablet in his memory.\n\nThe search also carries a practical fear: Belgrum worries that the Shadowforge clan could use the shard to strengthen its army of golems. He wants it brought to the king's mages for study before the Dark Irons secure it. Until that examination, its power to awaken life remains a matter of legend.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1139 The Lost Tablets of Will"},
    {},
    {"dungeon:uldaman", "faction:dark-iron"},
    "Classic / Forever",
    true)

Curated("relic:shattered-sword-marduk",
    "Shattered Sword of Marduk",
    "Relic",
    "The Shattered Sword of Marduk is a relic of the battle that destroyed Darrowshire. Carlin Redpath's reading of the Annals distinguishes the broken weapon from a defeated wielder: Marduk the Black was not defeated, while his sword was shattered and lost in the gorge west of Corin's Crossing. Carlin seeks its recovery alongside the remains of Darrowshire's other great enemy, Horgus.\n\nChromie identifies the gathered relics as ingredients for a spell that can summon the village's spirits. The sword thus has a purpose beyond recalling the enemy's attack: joined with relics of the defenders and other remains, it helps reopen the battle so that Joseph Redpath's tormented spirit may be saved.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5181 Villains of Darrowshire; #5206 Marauders of Darrowshire; #5941 Return to Chromie; #5721 The Battle of Darrowshire"},
    {},
    {"npc:marduk", "event:darrowshire", "npc:chromie"},
    "Classic / Forever",
    true)

Curated("book:bloodsail-orders",
    "Bloodsail Orders",
    "Book",
    "The Bloodsail Orders are Fleet-Master Firallon's written plan for an assault on Booty Bay. Kept at the pirates' Wild Shore encampment, they reveal how the ships and landing parties are meant to cooperate: the Damsel's Luck handles supplies and plunder, the Riptide puts attackers ashore, and Firallon's Crimson Veil provides gunfire and reserves.\n\nThe plan targets Revilgaz and Seahorn for death and calls for artillery to prevent Blackwater ships from using the port. Firallon also orders his crews to salvage material for a project with VanCleef in the Deadmines, exposing a connection beyond the local pirate feud. Seahorn seeks the orders and accompanying charts to uncover the threat before the attack can unfold.",
    {"Original readable item3921 transcription: https://warcraft.wiki.gg/wiki/Bloodsail_Orders_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #604 The Bloodsail Buccaneers"},
    {"Firallon's Bloodsail Orders"},
    {"faction:bloodsail", "place:booty-bay", "dungeon:deadmines"},
    "Classic / Forever",
    true)

Curated("book:rituals-power",
    "Rituals of Power (Book)",
    "Book",
    "Rituals of Power is a book by Magus Tirth containing passages Tabetha needs for a ritual to create a mage's wand. She sends a prospective pupil to its author because she has no copy and believes none of the great libraries hold one.\n\nTirth's fortunes explain the difficulty. Once a respected mage and scholar, he now drinks and gambles at the Shimmering Flats racetrack. He admits selling his last copy to a Scarlet cleric to cover his debts, sending the search to the Scarlet Monastery's library. Recovering that volume gives Tabetha the knowledge she needs to prepare the wand-making ritual.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1949 Hidden Secrets; #1951 Rituals of Power; #1952 Mage's Wand"},
    {"Rituals of Power", "Tirth's Rituals of Power"},
    {"place:scarlet-library", "dungeon:scarlet-monastery"},
    "Classic / Forever",
    true,
    {"Rituals of Power"})

Curated("relic:davils-libram",
    "Davil's Libram",
    "Relic",
    "Davil's Libram belonged to Davil Lightfire, a paladin remembered among the heroes of Darrowshire. According to the Annals as read by Carlin Redpath, the Crusade carried the book to Hearthglen's town hall. Carlin asks that it be recovered with Captain Redpath's shield, bringing together possessions tied to the village's defenders.\n\nChromie needs these relics for the spell that raises Darrowshire's spirits. In the renewed battle, Davil must live long enough for Horgus to fall, one of the conditions needed to save Joseph Redpath's spirit. His libram joins the other remnants of that night in an attempt to release a fellow defender from torment.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5168 Heroes of Darrowshire; #5206 Marauders of Darrowshire; #5941 Return to Chromie; #5721 The Battle of Darrowshire"},
    {},
    {"event:darrowshire", "place:hearthglen", "npc:chromie"},
    "Classic / Forever",
    true)

Curated("relic:redpaths-shield",
    "Redpath's Shield",
    "Relic",
    "Redpath's Shield is the damaged shield of Captain Joseph Redpath, one of Darrowshire's defenders. Carlin Redpath learns from the Annals that, after his brother's betrayal, the shield was cracked and discarded near the barn at Gahrron's Withering. He seeks its return alongside Davil Lightfire's libram, gathering the scattered remnants of their village's tragedy.\n\nThose possessions become ingredients for Chromie's spell to call up the spirits of Darrowshire. Her plan requires Joseph to survive until his corruption and then be defeated in that corrupted state, allowing his spirit to be saved. The abandoned shield therefore becomes part of an attempt to free the man who once carried it.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5168 Heroes of Darrowshire; #5206 Marauders of Darrowshire; #5941 Return to Chromie; #5721 The Battle of Darrowshire"},
    {},
    {"npc:joseph-redpath", "event:darrowshire", "npc:chromie"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:wizzle-brassbolts",
    "Wizzle Brassbolts",
    "Person",
    "Wizzle Brassbolts is a gnome engineer at Mirage Raceway in the Shimmering Flats, where the Brassbolts brothers race rocket cars against their goblin rivals. Speed brings practical problems: he fears his brother's experimental fuel will eat through their car, and asks for tough tortoise shells from the flats to build stronger fuel tanks.\n\nHis own experiments reach far beyond the racetrack. Wizzle wants an electrified scale from Gahz'rilla, the great beast summoned by the sand trolls of Zul'Farrak. He hopes to harness its energy for the car, sending a would-be helper after a component that first requires discovering the trolls' guarded summoning secret.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1105, 1179, 2769, 2770)", "https://warcraft.wiki.gg/wiki/Wizzle_Brassbolts"},
    {},
    {"place:mirage-raceway", "npc:rizzle-brassbolts", "npc:gahzrilla"},
    "Classic / Forever",
    true)

Curated("npc:sage-truthseeker",
    "Sage Truthseeker",
    "Person",
    "Sage Truthseeker is a tauren historian in Thunder Bluff whose research serves both ancient mysteries and present concerns. Though loyal to Cairne Bloodhoof, he fears the Horde's pact with the Forsaken was made too hastily. He seeks the Compendium of the Fallen from the Scarlet Monastery, judging that even the zealots' research may help him offer better counsel.\n\nThe miniature Discs of Norgannon recovered from Uldaman turn his attention toward a deeper past. Studying them with the druid Nara Wildmane leads to an expedition to Uldum's sealed gates in Tanaris. The discs awaken a guardian there, but cannot secure entry without the missing Plates of Uldum. Truthseeker and Nara reach an impasse: they know what is needed, yet must continue researching where those plates might be found.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1049, 2280, 2440, 2965, 2966, 2968)", "https://warcraft.wiki.gg/wiki/Sage_Truthseeker"},
    {},
    {"region:5468756e64657220426c756666", "dungeon:uldaman", "place:uldum-gates"},
    "Classic / Forever",
    true)

Curated("npc:rizzle-brassbolts",
    "Rizzle Brassbolts",
    "Person",
    "Rizzle Brassbolts is a gnome engineer working with his brothers at Mirage Raceway in the Shimmering Flats. Their rocket cars' improved performance attracts rival scrutiny: the outward designs appear unchanged, so their competitors suspect a new material. Rizzle's close attention to his plans makes him the target of an espionage scheme, with Zamek arranging a distraction so the drawings can be stolen.\n\nThe schematics reveal a method of refining indurium ore from the Uldaman excavations. Their emphasis on heat resistance explains the rivals' interest in both the plans and the raw sample Rizzle uses as a paperweight. His contribution to the race is an advantage in materials worth stealing.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 1190, 1194)", "https://warcraft.wiki.gg/wiki/Rizzle_Brassbolts"},
    {},
    {"place:mirage-raceway", "npc:wizzle-brassbolts", "dungeon:uldaman"},
    "Classic / Forever",
    true)

Curated("npc:zorbin-fandazzle",
    "Zorbin Fandazzle",
    "Person",
    "Zorbin Fandazzle is a goblin engineer trying to run a shop beside the Forgotten Coast docks in Feralas. Nearby giants are bad for business, so he develops the Ultra-Shrinker, his supposedly superior goblin variation on a gnomish shrinking ray. He recruits travelers to test it and collect miniaturization residue, preferring that someone else discover whether the device is likely to explode.\n\nThe coast's water elementals offer another opportunity. Zorbin wants their cores as a source of power for refining the Ultra-Shrinker; fewer hostile elementals also make his precarious business easier to sustain. His assurances of safety sit uneasily beside his relief when a tester returns intact.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 7003, 7721)", "https://warcraft.wiki.gg/wiki/Zorbin_Fandazzle"},
    {},
    {"region:466572616c6173"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:blackwood",
    "Blackwood Tribe",
    "Faction",
    "The Blackwood are furbolgs of Darkshore whose corruption troubles the night elves of Auberdine. Thundris Windweaver concludes that a satyr is controlling them through talismans. He devises a cleansing meal from food gathered in their camps and water from the moonwell.\n\nThe meal briefly frees the furbolgs from that influence and draws out their corruptor. The plan ends with the satyr's death and the recovery of his talisman for disposal, but Thundris still hopes to find a lasting cure for the tribe. This rescue is a first victory, with the Blackwood's recovery still unfinished.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4762 The Cliffspring River; #4763 The Blackwood Corrupted", "https://warcraft.wiki.gg/wiki/The_Blackwood_Corrupted (original quest transcript and giver)"},
    {"Blackwood furbolgs", "Blackwood tribe"},
    {"region:4461726b73686f7265", "place:auberdine"},
    "Classic / Forever",
    true)

Curated("faction:boulderfist",
    "Boulderfist Clan",
    "Faction",
    "The Boulderfist are ogres established across the Arathi Highlands, with leaders occupying part of ruined Stromgarde. Their camps include the mound northeast of the city and a lair southwest of Hammerfall, toward the dwarven bridge.\n\nAt Hammerfall, Drum Fel reports that the Boulderfist have joined forces with the Witherbark trolls to drive the Horde from the region. His campaign moves from the ogres' outlying fighters to the lords and shaman within Stromgarde. The clan is therefore both an occupying force in the old human city and an immediate enemy of Hammerfall.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #676 The Hammer May Fall; #677 Call to Arms; #678 Call to Arms; #679 Call to Arms"},
    {"Boulderfist", "Boulderfist clan", "Boulderfist ogres"},
    {"region:41726174686920486967686c616e6473", "place:stromgarde", "place:hammerfall"},
    "Classic / Forever",
    true)

Curated("faction:skullsplitter",
    "Skullsplitter Tribe",
    "Faction",
    "The Skullsplitters are trolls of Stranglethorn Vale led by Ana'thek the Cruel. Their feuds reach beyond their own jungle settlements. The Darkspear continue seeking Skullsplitter trophies even after leaving Stranglethorn, treating the old war as an obligation that distance has not ended.\n\nThe Bloodscalp also bear them bitter hatred. When the severed head of Bloodscalp chief Gan'zulah is forced to speak, he demands attacks on the Skullsplitters and the defeat of Ana'thek. His satisfaction at the chief's fall reveals how deeply revenge divides the Vale's tribes.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #598 Split Bone Necklace", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #584 Bloodscalp Clan Heads; #586 Speaking with Gan'zulah"},
    {"Skullsplitter", "Skullsplitter tribe", "Skullsplitter trolls"},
    {"region:537472616e676c6574686f726e2056616c65", "faction:darkspear"},
    "Classic / Forever",
    true)

Curated("faction:bristleback",
    "Bristleback Tribe",
    "Faction",
    "The Bristlebacks are quilboar who fight the tauren of Mulgore and occupy ground in the Barrens. At Brambleblade Ravine, east of Camp Narache, Chief Sharptusk Thornmantle leads raiders blamed for attacks on tauren hunters and villages. The tribe also raises aggressive battleboars.\n\nTheir enemies include other quilboar. Mangletooth, a captive Razormane at Camp Taurajo, urges attacks on Bristleback leaders to the north. He sees both tribes as drawing spiritual strength from the earth, but hopes the Bristlebacks' defeat will leave the Barrens to the Razormane.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #757 Rite of Strength; #780 The Battleboars; #3376 Break Sharptusk!", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #878 Tribes at War"},
    {"Bristleback", "Bristleback tribe", "Bristleback quilboar"},
    {"region:4d756c676f7265", "place:camp-taurajo"},
    "Classic / Forever",
    true)

Curated("relic:blood-of-heroes",
    "Blood of Heroes",
    "Relic",
    "Blood of Heroes can be gathered from small pools in the Eastern and Western Plaguelands. Disturbing them brings forth hostile Fallen Heroes, making the blood dangerous to collect.\n\nIts uses extend beyond the place where it lies. Blood of Heroes is required for armor made from chromatic dragon remains, including the Breastplate of the Chromatic Flight and Legplates of the Chromatic Defier. Lorekeeper Lydros also calls for it when using the Libram of Rapidity to prepare a haste enchantment. These commissions establish its potency without identifying whose blood the pools contain.",
    {"https://warcraft.wiki.gg/wiki/Blood_of_Heroes (original object and collection sections); https://www.wowhead.com/classic/item=12938/blood-of-heroes (original-era collection reports)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5166 Breastplate of the Chromatic Flight; #5167 Legplates of the Chromatic Defier", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7483 Libram of Rapidity"},
    {},
    {"region:4561737465726e20506c616775656c616e6473", "region:5765737465726e20506c616775656c616e6473", "dungeon:dire-maul"},
    "Classic / Forever",
    true)

Curated("relic:scepter-celebras",
    "Scepter of Celebras",
    "Relic",
    "The Scepter of Celebras once let its bearer travel swiftly through Maraudon as he sought peace for his uncle's spirit. When corruption overcame Celebras, Lord Vyletongue and Noxxion took its two pieces into their separate parts of the caverns.\n\nAfter the pieces are recovered, the awakened Celebras performs a ritual to reunite the rod and diamond. He then entrusts the restored scepter to those continuing his journey, asking that its power be used for good. Its purpose remains bound to passage through Maraudon and the hope that first brought him there.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7044 Legends of Maraudon", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7046 The Scepter of Celebras"},
    {"The Scepter of Celebras"},
    {"npc:celebras", "dungeon:maraudon"},
    "Classic / Forever",
    true,
    {"The Scepter of Celebras"})

Curated("book:green-hills-stranglethorn",
    "The Green Hills of Stranglethorn (Book)",
    "Book",
    "The Green Hills of Stranglethorn is Hemet Nesingwary's hunting narrative, told in his own voice. Its opening follows Hemet, Ajeck Rouack, Sir S. J. Erlgadin and Barnil Stonepot into the jungle; Ajeck saves Barnil from a river crocolisk. In the last chapter, Hemet leads the party into a cliffside trap while fleeing raptors. A great white tiger scatters their pursuers, letting the hunters escape.\n\nBarnil is proofreading the four-chapter manuscript when a gust scatters its pages around the jungle. He seeks help rebuilding the chapters before Hemet discovers the loss, hoping the completed book will soon reach libraries.",
    {"https://www.wowhead.com/classic/item=2756/green-hills-of-stranglethorn-chapter-i (readable text transcribed in archived Allakhazam comment)", "https://www.wowhead.com/classic/item=2759/green-hills-of-stranglethorn-chapter-iv (readable text transcribed in archived Allakhazam comment)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #338 The Green Hills of Stranglethorn"},
    {"The Green Hills of Stranglethorn", "Green Hills of Stranglethorn (Book)"},
    {"npc:hemet-nesingwary", "region:537472616e676c6574686f726e2056616c65"},
    "Classic / Forever",
    true,
    {"The Green Hills of Stranglethorn"})

Curated("book:ur",
    "The Book of Ur (Book)",
    "Book",
    "The Book of Ur is a work by a Dalaran mage who studied other worlds before the Scourge came. A copy lies in Shadowfang Keep. Keeper Bel'dugur seeks it for his collection and for parties among the Forsaken, praising Ur's knowledge while dismissing the conscience that restrained him.\n\nUr's own text warns Dalaran's wizards about the worgen. He describes malevolent wolf-men from a nightmarish world and says powerful magic can draw them into Azeroth. He urges his readers to leave those beings undisturbed, believing neither bargains nor their secrets can yield good.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1013 The Book of Ur; https://classicdb.ch/?quest=1013 (original quest and Keeper Bel'dugur attribution)", "https://warcraft.wiki.gg/wiki/Book_of_Ur (original readable Contents transcript; indexed text read)"},
    {"The Book of Ur", "Book of Ur (Book)"},
    {"dungeon:shadowfang"},
    "Classic / Forever",
    true,
    {"The Book of Ur"})

Curated("book:blackhands-command",
    "Blackhand's Command (Letter)",
    "Book",
    "Blackhand's Command is Warchief Rend Blackhand's contemptuous letter to a quartermaster charged with keeping outsiders from the master's lair. Rend explains that the orb leading directly into Blackwing has its own safeguard: only a hand bearing the Mark of Drakkisath can use it, and Drakkisath himself guards the brand.\n\nThe letter ends by ordering its destruction. In hostile hands, however, its warning exposes the means of gaining access. Those who obtain the brand can use the very safeguard Rend trusted to exclude them.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7761 Blackhand's Command (letter and completion)"},
    {"Blackhand's Command", "Rend Blackhand's Command (Letter)"},
    {"npc:rend", "dungeon:blackwing", "dungeon:upper-blackrock-spire"},
    "Classic / Forever",
    true,
    {"Blackhand's Command"})

Curated("book:ancients",
    "Book of the Ancients (Book)",
    "Book",
    "The Book of the Ancients is a guarded naga volume sought by Azore Aldamort in Desolace. Azore says it holds secrets the naga have kept for centuries, knowledge he hopes will help others understand their scaled enemies.\n\nHe provides the Gem of the Serpent to be placed in the hand of a statue on Ranazjar Isle. This summons the book's protector, allowing the volume to be recovered. When it is brought to him, Azore promises to pass it to the high council. The book's value is described by its seeker; its specific teachings remain unreported.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6027 Book of the Ancients; https://classicdb.ch/?quest=6027 (original quest and Azore Aldamort attribution)"},
    {"Book of the Ancients"},
    {"region:4465736f6c616365"},
    "Classic / Forever",
    true,
    {"Book of the Ancients"})

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:46656c776f6f64",
    "Felwood",
    "Region",
    "Felwood is the corrupted forest north of Ashenvale. During the Third War, the Skull of Gul'dan spread demonic corruption through its woods; destroying Tichondrius did not immediately heal the land. The surviving forest remains a place of diseased growth, hostile creatures and damaged sacred ground.\n\nCenarion efforts to restore it begin with practical work: studying blood amber from corrupted elementals and preparing salves for afflicted plants. Beneath Jaedenar, the Shadow Council uses the barrow dens while pursuing its dealings with the Burning Legion. The furbolgs face a different danger. The Timbermaw regard themselves as uncorrupted survivors, but outsiders who attack furbolgs indiscriminately have taught them to distrust strangers. Their hostility cannot safely be read as proof that they share the corruption of the Deadwood tribe. Felwood asks its visitors to distinguish what can be healed from what continues to spread the damage.",
    {"https://warcraft.wiki.gg/wiki/Felwood_(Classic)", "https://gamefaqs.gamespot.com/pc/256222-warcraft-iii-reign-of-chaos/faqs/38456", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4101 Cleansing Felwood; #5155 Forces of Jaedenar; #8460 Timbermaw Ally"},
    {},
    {"place:jaedenar", "faction:timbermaw"},
    "Classic / Forever")

Curated("region:4d756c676f7265",
    "Mulgore",
    "Region",
    "Mulgore is a country of open grassland beneath the mesas of Thunder Bluff. The tauren journey from Camp Narache through Bloodhoof Village begins with hunting, service to the community and the rites that prepare newcomers for a place among their people. Seers guide those lessons through visions, while the wells and grazing grounds give the rituals a practical setting.\n\nThe land also needs defending. Poisoned wells require cleansing totems to restore their sacred waters. The Venture Company runs a mining operation; papers from a raided caravan offer a way to learn more about its operations. At a dwarven dig site, the tauren object to excavation they believe is wounding the earth. Mulgore's early trials connect personal growth with the responsibility to protect the places that sustain the tribe.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #747 The Hunt Begins; #755 Rites of the Earthmother; #763 Rites of the Earthmother; #772 Rite of Vision; #748 Poison Water; #758 Thunderhorn Cleansing; #751 The Ravaged Caravan; #746 Dwarven Digging"},
    {},
    {"place:narache", "place:bloodhoof", "region:5468756e64657220426c756666"},
    "Classic / Forever")

Curated("region:4d6f6f6e676c616465",
    "Moonglade",
    "Region",
    "Moonglade is a sacred refuge where both tauren and night elf druids are welcome. Keeper Remulos watches over the resting druids, and Nighthaven receives learners sent to understand their calling. Dendrite Starblaze directs a young druid toward the Great Bear Spirit northwest of the village, where strength must be accompanied by the wisdom to use it.\n\nThe Lunar Festival brings another kind of gathering. Visitors honor their elders and celebrate an ancient victory with stories, food and fireworks. Yet the season also wakes Omen beneath Lake Elune'ara. Once a defender against evil, the creature was twisted by demonic magic and now returns in rage. The festival's call to face him seeks another year's peace, rather than pretending that his recurring affliction has been ended forever. Celebration and an old duty share the same sacred ground.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5921 Moonglade; #5922 Moonglade; #5929 Great Bear Spirit; #8867 Lunar Fireworks; #8868 Elune’s Blessing", "https://warcraft.wiki.gg/wiki/Moonglade_(Horde)"},
    {},
    {"npc:remulos", "faction:cenarion-circle"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:4f726772696d6d6172",
    "Orgrimmar",
    "City",
    "Orgrimmar is the Horde capital in Durotar, founded by Thrall and named for his predecessor and mentor, Orgrim Doomhammer. It is the center of the orcs' new homeland in Kalimdor. Its districts gather the skills needed to sustain that home: weapon masters and smiths work in the Valley of Honor, shamans teach in the Valley of Wisdom, and the Drag houses craftsmen and their shops. Reports from beyond the gates reach Thrall and his advisers here.\n\nDanger also lies within the city. In the Cleft of Shadow, Neeru Fireblade believes he has concealed his allegiance to the Burning Blade. Thrall knows otherwise and seeks to expose the wider conspiracy without warning its leaders. Beneath them, Ragefire Chasm shelters the Searing Blade. The capital's struggle for security reaches from distant shores to the caverns under its own streets.",
    {"https://news.blizzard.com/en-gb/article/23156369/wow-classic-city-tour-orgrimmar", "https://warcraft.wiki.gg/wiki/Orgrim", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #831 The Admiral's Orders; #5726–5730 Hidden Enemies"},
    {},
    {"npc:thrall", "npc:orgrim", "dungeon:ragefire"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("group:silithid",
    "Silithid",
    "Group",
    "The silithid are hive-dwelling insects whose spread threatens southern Kalimdor. Reports from Tanaris alarm the Gadgetzan researchers enough that they release valuable findings freely to both factions. Scholars Gracina Spiritmight and Zilzibin Drumlore recognize the creatures as instruments of a greater threat, rather than an ordinary desert infestation.\n\nAlchemist Pestlezugg studies their queens and devises a lure for the hive in Un'Goro Crater, hoping that a queen's death will disrupt her insects. Even a successful hunt leaves him doubtful that the danger has ended. Further research in Silithus identifies crystal messages used by the qiraji and other unknown beings to communicate with the silithid. The hives belong to a conflict extending beyond the instincts of any single swarm.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #113 Insect Part Analysis; #162 Rise of the Silithid; #32 Rise of the Silithid", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4496 Bungle in the Jungle; #4507 Pawn Captures Queen", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8314 Unraveling the Mystery"},
    {"the silithid", "Silithid hives"},
    {"region:53696c6974687573", "place:ahnqiraj"},
    "Classic / Forever",
    true)

Curated("faction:sandfury",
    "Sandfury Tribe",
    "Faction",
    "The Sandfury are the sand trolls of Zul'Farrak, a city in Tanaris northwest of Gadgetzan. Their craftsmen make a prized tempering agent from sandstone, a material sought by artisans outside the tribe.\n\nWithin the city lies a sacred pool from which the trolls summon Gahz'rilla, a great beast whose scales carry powerful energy. The summoning is a closely guarded secret. Outsiders seeking to exploit that power must first uncover the ritual, bringing the tribe's sacred practices into conflict with the ambitions of treasure seekers and inventors.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2770 Gahz'rilla; #3042 Troll Temper"},
    {"Sandfury", "Sandfury tribe", "Sandfury trolls"},
    {"dungeon:zulfarrak", "relic:mallet-zulfarrak"},
    "Classic / Forever",
    true)

Curated("faction:blackwater-raiders",
    "Blackwater Raiders",
    "Faction",
    "The Blackwater Raiders are the pirate fleet that holds Booty Bay. Fleet Master Seahorn commands their response to the Bloodsail Buccaneers, rival pirates gathering along the coast of southern Stranglethorn. First Mate Crazz recruits a scout when reports of Bloodsail activity reach the newly docked Raiders.\n\nOrders found near the port reveal preparations for an attack. Seahorn sends agents into the Bloodsail camp on the Wild Shore to recover charts and correspondence, then calls for a strike against the enemy captains before their fleet can move. For the Raiders, defending Booty Bay means uncovering their rivals' intentions and breaking their leadership before open battle.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #595, #597, #599, #604 and #608 The Bloodsail Buccaneers", "https://classicdb.ch/?quest=595 (original quest and First Mate Crazz attribution)"},
    {"the Blackwater Raiders"},
    {"place:booty-bay", "npc:seahorn", "faction:bloodsail"},
    "Classic / Forever",
    true)

Curated("faction:arathi-tribe",
    "Arathi Tribe",
    "Faction",
    "The Arathi were an ancient human tribe that sought to unite its divided neighbors against the growing troll threat. Over six years, they defeated rival tribes and won their loyalty by offering peace and equal standing afterward.\n\nThe enlarged people built Strom as the capital of Arathor. Under King Thoradin, that nation eventually joined the high elves against the trolls, linking the tribe's campaign of unification to a wider alliance.",
    {"https://warcraft.wiki.gg/wiki/Arathor_and_the_Troll_Wars (original in-game book)"},
    {"Arathi tribe", "the Arathi tribe"},
    {"npc:thoradin", "place:stromgarde", "region:41726174686920486967686c616e6473"},
    "Classic / Forever",
    true)

Curated("relic:trolkalar",
    "Trol'kalar",
    "Relic",
    "Trol'kalar is the legendary sword guarded in Thoras Trollbane's tomb at Stromgarde. The Darkspear remember it as the great weapon of the human forces that ravaged trolls for generations. With Thoras dead and the city in ruins, Vol'jin orders its recovery for use against the trolls of Zul'Gurub.\n\nZengu oversees the effort from Hammerfall. Four recovered sigils combine into the Sigil of Ignaeus, which breaks the tomb's wards and releases the blade from the stone hands holding it. Once the sword is brought to him, Zengu promises to send it to Nimboya at Grom'gol. The recovery would turn a feared weapon of the Darkspear's old enemies toward a new troll war.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #638 Trollbane; #644 Sigil of Trollbane; #645 and #646 Trol'kalar"},
    {"Trolkalar"},
    {"place:stromgarde", "npc:voljin", "faction:darkspear"},
    "Classic / Forever",
    true)

Curated("book:invasion-draenor",
    "The Invasion of Draenor (Book)",
    "Book",
    "The Invasion of Draenor recounts the war beyond the Dark Portal after the Alliance's victory in the Second War. Ner'zhul sends orcs into Azeroth to obtain artifacts for new portals. King Terenas answers by dispatching Turalyon and Khadgar to Draenor, aided by Alleria Windrunner, Kurdran Wildhammer and Danath Trollbane.\n\nThe expedition cannot stop Ner'zhul's ritual. His gateways tear Draenor apart, and Turalyon and Khadgar choose to destroy the Dark Portal from their side to protect Azeroth. The chapter contrasts that sacrifice with the escapes of other forces: Grom Hellscream and Kilrogg Deadeye return to Azeroth, while Ner'zhul and his Shadowmoon followers flee through another portal. Its account ends with the destruction of the world the expedition had entered.",
    {"https://warcraft.wiki.gg/wiki/The_Invasion_of_Draenor (original book identification and indexed passage)", "https://www.wowhead.com/item=145299/the-invasion-of-draenor (Content reproducing the original ten-page book; modern item metadata excluded)", "https://classicdb.ch/?object=175747 (original book object in Scholomance)"},
    {"The Invasion of Draenor", "Invasion of Draenor (Book)"},
    {"place:dark-portal", "place:nethergarde"},
    "Classic / Forever",
    true,
    {"The Invasion of Draenor"})

Curated("book:old-gods-ordering",
    "The Old Gods and the Ordering of Azeroth",
    "Book",
    "The Old Gods and the Ordering of Azeroth is a history chapter describing the titans' struggle to reshape primordial Azeroth. In its account, elemental armies serve the Old Gods and resist the newcomers. The Pantheon defeats them, imprisons their masters beneath the world and banishes the elementals.\n\nThe story then turns from conquest to creation. Earthen and sea giants help shape the land and seas, while the Well of Eternity nourishes life upon the single continent of Kalimdor. The chapter presents the world's ordered landscape as the result of both a defeated ancient tyranny and the titans' subsequent work.",
    {"https://warcraft.wiki.gg/wiki/The_Old_Gods_and_the_Ordering_of_Azeroth (original Content; annotated version excluded)"},
    {"The Old Gods and the Ordering of Azeroth (Book)"},
    {"faction:old-gods", "faction:titans"},
    "Classic / Forever",
    true)

Curated("book:kaldorei-well-eternity",
    "The Kaldorei and the Well of Eternity",
    "Book",
    "The Kaldorei and the Well of Eternity tells how the early night elves settled beside the enchanted lake at the heart of ancient Kalimdor. It describes a wandering nocturnal people transformed by the Well's power, becoming stronger, wiser and nearly immortal. They take the name Kaldorei and build temples around its shores.\n\nThe account joins the growth of their society to worship and inquiry. The Kaldorei revere Elune and believe she sleeps within the Well by day, while priests and seers investigate its magic. The history also appears under the title The Waking World and the Well of Eternity.",
    {"https://warcraft.wiki.gg/wiki/The_Waking_World_and_the_Well_of_Eternity (The Kaldorei and the Well of Eternity, in-game text section)"},
    {"The Kaldorei and the Well of Eternity (Book)", "The Waking World and the Well of Eternity", "The Waking World and the Well of Eternity (Book)"},
    {"faction:highborne"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:zuljin",
    "Zul'jin",
    "Person",
    "Zul'jin is the revered forest troll leader who united tribes against the high elves of Quel'Thalas and allied them with the Horde during the Second War. Formerly imprisoned by humans, he supplied axethrowers and warships to the Horde at Southshore.\n\nThe alliance served the trolls' determination to reclaim the lands the elves had taken. After the Horde's defeat, most forest trolls abandoned the orcs in anger at their failed promises. Zul'jin disappeared, but his standing among the forest trolls survived the collapse of their wartime alliance.",
    {"https://warcraft.wiki.gg/wiki/Troll_Compendium/Forest_Trolls", "https://worldofwarcraft.fandom.com/et/wiki/Southshore_%28WC2_Horde%29"},
    {"Zuljin"},
    {"event:second-war", "faction:revantusk"},
    "Classic / Forever",
    true)

Curated("npc:alleria-windrunner",
    "Alleria Windrunner",
    "Person",
    "Alleria Windrunner is a high elf ranger captain of Quel'Thalas, renowned for hunting trolls. She served the Alliance's expedition into Draenor as its chief scout and intelligence agent. Stormwind's Valley of Heroes commemorates her as presumed dead. The tribute from her sister Sylvanas remembers both a distinguished ranger and a beloved member of their family.",
    {"https://warcraft.wiki.gg/wiki/Alleria_Windrunner", "https://warcraft.wiki.gg/wiki/Valley_of_Heroes"},
    {"Alleria"},
    {"npc:turalyon", "npc:kurdran-wildhammer", "npc:danath-trollbane"},
    "Classic / Forever",
    true)

Curated("npc:kurdran-wildhammer",
    "Kurdran Wildhammer",
    "Person",
    "Kurdran Wildhammer is the dwarven gryphon master of Aerie Peak, celebrated for fighting dragons. He commanded the gryphon riders accompanying the Alliance Expedition into Draenor. His Stormwind monument records him as presumed dead; Falstad's farewell remembers the calls of his gryphon Sky'ree and the thunder of his hammer, honoring a warrior whose fate remains unknown to those at home.",
    {"https://warcraft.wiki.gg/wiki/Kurdran_wildhammer", "https://warcraft.wiki.gg/wiki/Valley_of_Heroes"},
    {"Kurdran"},
    {"faction:wildhammer", "place:aerie-peak", "npc:falstad"},
    "Classic / Forever",
    true)

Curated("npc:danath-trollbane",
    "Danath Trollbane",
    "Person",
    "Danath Trollbane is a human commander of Stromgarde's militia who served as General Turalyon's tactical adviser and a force commander of the Alliance Expedition into Draenor. In Stormwind's Valley of Heroes he is commemorated as presumed dead. His uncle Thoras Trollbane's inscription honors his sacrifice, placing Danath among the heroes whose blood secured their people's legacy.",
    {"https://warcraft.wiki.gg/wiki/Danath", "https://warcraft.wiki.gg/wiki/Valley_of_Heroes"},
    {"Danath"},
    {"place:stromgarde", "npc:turalyon", "npc:alleria-windrunner"},
    "Classic / Forever",
    true)

Curated("npc:nat-pagle",
    "Nat Pagle",
    "Person",
    "Nat Pagle is a human fishing master on an island south of Theramore in Dustwallow Marsh. Both Lumak and Grimnur Stonebrand send accomplished pupils to him when they have nothing more to teach. Nat claims little enthusiasm for fishing despite decades spent at it; what he values is the unhurried chance to think, reflect and drink.\n\nHis lesson begins with a test of patience and determination. He asks for four unusual catches from the Swamp of Sorrows, Desolace, Feralas and Stranglethorn Vale, then offers to teach the angler more about setting lines. For Nat, mastery depends less on having caught everything in the sea than on being willing to sit and wait.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quests 6607, 6608, 6609)", "https://classicdb.ch/?quest=6607", "https://warcraft.wiki.gg/wiki/Nat_Pagle"},
    {},
    {"region:4475737477616c6c6f77204d61727368"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:grim-batol",
    "Grim Batol",
    "Place",
    "Grim Batol is an old dwarven fortress in the mountains of southeastern Wetlands. Founded by the Wildhammer clan, it was abandoned after the War of the Three Hammers left it cursed. The Dragonmaw later made it a prison for Alexstrasza, using their control of the red dragons to sustain the clan's power. When that captivity ended, the freed dragons hunted their former masters, and surviving orcs fled into the surrounding hills.\n\nThe stronghold's doors remain closed. Red dragonkin guard the approach, among them the drake Axtroz, while the wreckage of an orc caravan lies outside the gates. Travelers can reach the mountain road, but the fortress beyond it is sealed. Its silence follows two histories of dispossession: the dwarves who left their tainted home, and the orcs driven from the dragons' prison.",
    {"https://warcraft.wiki.gg/wiki/Grim_Batol (introduction and original World of Warcraft geography/NPC sections)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #464 War Banners"},
    {},
    {"event:grim-batol", "faction:wildhammer", "faction:dragonmaw"},
    "Classic / Forever",
    true)

Curated("npc:finkle-einhorn",
    "Finkle Einhorn",
    "Person",
    "Finkle Einhorn is a gnome explorer whose lava-suit experiment ended inside the Beast, a core hound in Upper Blackrock Spire. The creature swallowed him while he was testing the suit in the Molten Span. Its protection and a built-in food dispenser kept him alive in the creature's belly until he could be freed by skinning it.\n\nEven that ordeal yielded something useful. Finkle sends a glowing piece of the Beast's flesh to Malyfous Darkhammer in Everlook, along with word that he survived and that the suit worked. Malyfous is to assess what a craftsman might make from such a monster's remains.",
    {"https://wowwiki-archive.fandom.com/wiki/Finkle_Einhorn", "https://classicdb.ch/?quest=5047", "https://warcraft.wiki.gg/wiki/The_Beast"},
    {"Finkle"},
    {"npc:the-beast", "dungeon:upper-blackrock-spire", "place:everlook"},
    "Classic / Forever",
    true)

Curated("npc:jes-tereth",
    "Grand Admiral Jes-Tereth",
    "Person",
    "Jes-Tereth is a grand admiral of Stormwind, stationed in the War Room of Stormwind Keep.",
    {"https://classicdb.ch/?npc=1750", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_hr.pdf"},
    {"Jes-Tereth"},
    {"region:53746f726d77696e642043697479", "faction:stormwind"},
    "Classic / Forever",
    true)

Curated("npc:xylem",
    "Archmage Xylem",
    "Person",
    "Archmage Xylem is a mage of Azshara whose tower stands high on the cliffs. His servant Sanath Lim-yo provides the teleportation that gives visitors access. Xylem recruits capable mages to gather unusual materials for his research.\n\nHis quarrel with the green drake Morphaz is both personal and practical. Years earlier, the drake ambushed him and swallowed an apprentice carrying an exceptional arcane shard. Xylem wants the drake destroyed in the Temple of Atal'Hakkar and the shard recovered. Its power has grown inside Morphaz, and recovering it would restore Xylem's full ability to forge the arcane.",
    {"https://classicdb.ch/?npc=8379", "https://classicdb.ch/?quest=8250", "https://classicdb.ch/?quest=8251", "https://classicdb.ch/?quest=8252", "https://classicdb.ch/?quest=8253"},
    {"Xylem"},
    {"region:417a7368617261", "npc:morphaz"},
    "Classic / Forever",
    true)

Curated("npc:marshal-mcbride",
    "Marshal McBride",
    "Person",
    "Marshal McBride is a Stormwind officer receiving volunteers inside Northshire Abbey. With many of the kingdom's forces serving abroad, the guards need local help against threats growing close to home. McBride sees the unrest as part of a struggle on several fronts.\n\nAmong his immediate concerns are the kobolds spreading through the woods north of the abbey and around Echo Ridge Mine. He sends recruits to reduce their numbers and report on the extent of the infestation before it becomes an even greater danger to Northshire.",
    {"https://classicdb.ch/?quest=783", "https://classicdb.ch/?quest=7", "https://classicdb.ch/?quest=15"},
    {"McBride"},
    {"place:northshire-abbey", "place:northshire", "faction:stormwind"},
    "Classic / Forever",
    true)

Curated("npc:melor-stonehoof",
    "Melor Stonehoof",
    "Person",
    "Melor Stonehoof is a tauren hunting mentor on the Hunter Rise in Thunder Bluff. He teaches that a hunter must understand and respect the creature being pursued. Skorn Whitecloud sends promising hunters to him with prowler claws as proof of their resolve and developing skill.\n\nMelor's lessons reach beyond taking trophies. He condemns Steelsnap, a hyena of Thousand Needles, for drawing other hyenas into a reign of fear over gentler beasts. He calls for its death as the removal of a creature outside the Earthmother's blessing.",
    {"https://warcraft.wiki.gg/wiki/Melor_Stonehoof", "https://classicdb.ch/?quest=861", "https://classicdb.ch/?quest=1131"},
    {"Melor"},
    {"region:5468756e64657220426c756666"},
    "Classic / Forever",
    true)

Curated("faction:black-tooth-grin",
    "Black Tooth Grin Clan",
    "Faction",
    "The Black Tooth Grin was an orc clan led by Rend and Maim, the sons of Blackhand. It was an offshoot of the Blackrock clan. Its members marked their loyalty by knocking out a tooth.\n\nDuring the Second War, the clan guarded the Dark Portal. The brothers maintained their own following after Orgrim Doomhammer displaced their father, leaving the clan's service to the Horde entangled with the ambitions of Blackhand's heirs.",
    {"https://warcraft.wiki.gg/wiki/Blacktooth_Grin (independent introductory/history identity summary; original Warcraft II account checked for era)"},
    {"Black Tooth Grin", "Blacktooth Grin", "Black Tooth Grin clan"},
    {"npc:rend", "faction:blackrock-clan", "place:dark-portal"},
    "Classic / Forever",
    true)

Curated("faction:frostmane",
    "Frostmane Tribe",
    "Faction",
    "The Frostmane are ice trolls living in Dun Morogh, where their presence brings them into conflict with Ironforge's dwarves. Their camps include the southern cave in Coldridge Valley and Frostmane Hold farther west.\n\nWith the Senate already occupied by the trogg threat, the brothers Grelin and Senir Whitebeard investigate the trolls. Grelin seeks help against the Frostmane in Coldridge rather than calling in an army. Senir, alarmed by the numbers at the Hold, asks for a scout to enter the cave and strike at its defenders before he completes his report. These scattered encounters reveal a tribe established across the snowy region, beyond the first cave a traveler might find.",
    {"https://warcraft.wiki.gg/wiki/Frostmane_Troll (original removed NPC identity)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #182 The Troll Cave; #287 Frostmane Hold"},
    {"Frostmane", "Frostmane tribe", "Frostmane clan", "Frostmane trolls"},
    {"place:frostmane-hold", "region:44756e204d6f726f6768"},
    "Classic / Forever",
    true)

Curated("group:high-elves",
    "High Elves",
    "Group",
    "The high elves, or quel'dorei, are the people who founded Quel'Thalas in the northern Eastern Kingdoms. They descend from the Highborne exiles led east from Kalimdor by Dath'Remar Sunstrider after a dispute over the use of arcane magic. In the Thalassian usage, quel'dorei names these high elves; the older Darnassian use of the word also refers to the Highborne caste from which they came.\n\nTheir kingdom grew around Silvermoon and the Sunwell, whose energies sustained their magical society. The Third War shattered that homeland when Arthas's Scourge invaded and defiled the Sunwell to restore Kel'Thuzad. High elves nevertheless survive beyond its ruins. At Quel'Danil Lodge in the Hinterlands, the Highvale maintain records and send ambassadors to build relations with other peoples, sharing their knowledge of the Witherbark trolls.",
    {"https://warcraft.wiki.gg/wiki/The_Warcraft_Encyclopedia/High_Elves (preserved Blizzard identity and founding account)", "https://warcraft.wiki.gg/wiki/Quel%27dorei (term distinction)", "https://warcraft.wiki.gg/wiki/High_elf (independent summary of original-era identity and Third War)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2995 Lines of Communication"},
    {"Quel'dorei", "High elves", "High Elf", "High elf"},
    {"faction:highborne", "place:sunwell", "place:queldanil"},
    "Classic / Forever",
    true)

Curated("faction:stormreaver",
    "Stormreaver Clan",
    "Faction",
    "The Stormreaver was Gul'dan's orc clan, a personal following that protected the warlock against Orgrim Doomhammer. Its place within the Old Horde concealed an ambition separate from the Horde's war against the Alliance.\n\nDuring the Second War, Gul'dan led the Stormreavers toward the Tomb of Sargeras in pursuit of its power. This abandonment of the Horde brought vengeance upon his followers, while the demons inside the tomb destroyed Gul'dan himself. The clan's search for power ended in ruin, leaving scattered survivors rather than the force its master had hoped to command.",
    {"https://warcraft.wiki.gg/wiki/Stormreaver_clan (independent introductory identity/fate summary)", "https://warcraft.wiki.gg/wiki/Orcs (independent clan list identity)"},
    {"Stormreaver clan", "Stormreavers", "Stormreaver"},
    {"npc:guldan", "npc:orgrim", "relic:skull-guldan"},
    "Classic / Forever",
    true)

Curated("relic:eye-shadow",
    "Eye of Shadow",
    "Relic",
    "The Eye of Shadow is a dark trinket required for the priestly staff Benediction. Joined with the Eye of Divinity and the Splinter of Nordrassil, it completes the staff's creation. It is associated with powerful demons: Lord Kazzak and, more rarely, the demonic creatures of the Blasted Lands and Winterspring can yield it.\n\nThe search follows the trial known as the Balance of Light and Shadow. A priest must protect the fleeing peasants of Stratholme, succeeding where their guardian failed, to earn the Splinter. The final instruction is then to seek the Eye of Shadow across the world. Its importance lies in completing that work of restoration, despite its ominous appearance and demonic source.",
    {"https://classicdb.ch/?item=18659 (Splinter of Nordrassil original Use text)", "https://warcraft.wiki.gg/wiki/The_Eye_of_Shadow (original drop record and patch 1.5 history)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7622 The Balance of Light and Shadow"},
    {"The Eye of Shadow"},
    {"relic:eye-divinity", "relic:benediction", "npc:kazzak"},
    "Classic / Forever",
    true)

Curated("relic:dartols-rod",
    "Dartol's Rod of Transformation",
    "Relic",
    "Dartol's Rod of Transformation is an enchanted rod that gives its bearer the appearance of a furbolg. Raene Wolfrunner's investigation in Ashenvale requires the broken artifact to be reconstructed and recharged at a hidden shrine, continuing the search Teronis began.\n\nThe disguise offers a way to approach Krolg, an uncorrupted furbolg who mistakes the transformed visitor for one of his own people. Krolg condemns the corruption afflicting his kin and the cruelty of Ran Bloodtooth, allowing Raene's search to proceed through conversation with a furbolg rather than attacks alone. The rod is therefore a means of crossing the hostility between the forest's inhabitants as well as a magical transformation.",
    {"https://classicdb.ch/?item=5462 (original transformation effect)", "https://classicdb.ch/?quest=1030 (original objective and Krolg endpoint)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1026, #1027, #1028, #1029, #1030, #1045 and #1046 Raene's Cleansing"},
    {"Dartol's Rod", "Dartol’s Rod of Transformation"},
    {"region:417368656e76616c65"},
    "Classic / Forever",
    true)

Curated("event:fall-quelthalas",
    "Fall of Quel'Thalas",
    "Event",
    "The Fall of Quel'Thalas was the Scourge's destruction of the high elven kingdom during the Third War. Arthas sought the Sunwell's power to restore the dead necromancer Kel'Thuzad. Ranger-General Sylvanas Windrunner resisted his advance, but the elven defenses failed.\n\nArthas turned Sylvanas into a banshee and forced her into his service. At the Sunwell, Kel'Thuzad rose as a lich while the waters were corrupted. The invasion devastated the elves' homeland and transformed their sacred source of magic into the instrument of an enemy's rebirth.",
    {"https://warcraft.wiki.gg/wiki/Third_War (independent Fall of Quel'Thalas narration; only original-campaign facts)", "https://warcraft.wiki.gg/wiki/The_Fall_of_Silvermoon (original objective/transcript verification)"},
    {"The Fall of Quel'Thalas", "Scourge invasion of Quel'Thalas", "Fall of Silvermoon"},
    {"place:sunwell", "npc:sylvanas", "npc:kelthuzad"},
    "Classic / Forever",
    true)

Curated("relic:orb-nohorahil",
    "Orb of Noh'Orahil",
    "Relic",
    "The Orb of Noh'Orahil is a warlock's implement crafted by Menara Voidrender. It is one of the forms she offers after a summoner's orb has been recovered and cleansed; a warlock may choose the orb to accompany a sword or dagger, or take a two-handed staff instead.\n\nMenara's work begins with an Infernal Orb taken from the warlocks of Mannoroc Coven in Desolace. Tabetha, a mage in Dustwallow Marsh, agrees to help because of her history with Menara. She releases the demon within the orb so that it can be defeated before it returns to its prison. Once the cleansed vessel comes back to Menara, she crafts the chosen reward and binds a new demon into it.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1799 Fragments of the Orb of Orahil; #4961 Cleansing of the Orb of Orahil; #4975 The Completed Orb of Noh'Orahil", "https://classicdb.ch/?quest=4975 (Menara attribution and alternative rewards)", "https://classicdb.ch/?item=15107 (original Warlock off-hand item)"},
    {"Orb of Noh’Orahil"},
    {"region:4465736f6c616365", "region:4475737477616c6c6f77204d61727368"},
    "Classic / Forever",
    true)

Curated("relic:eye-divinity",
    "Eye of Divinity",
    "Relic",
    "The Eye of Divinity is a priestly trinket found among the treasures of the Cache of the Firelord, revealed after the defeat of Majordomo Executus's guards in Molten Core. Looking into it shows a battle in Lordaeron: a lone priestess holds back the Scourge with light until the dead peasants around her rise and overwhelm her. The vision does not name her.\n\nThe Eye also belongs to the making of Benediction. It must be combined with the Eye of Shadow and the Splinter of Nordrassil. The trial that awards the Splinter asks a priest to save peasants fleeing Stratholme, linking the staff's restoration with the same struggle to protect the living from the Scourge that the Eye reveals.",
    {"https://warcraft.wiki.gg/wiki/Eye_of_Divinity (original readable Content)", "https://warcraft.wiki.gg/wiki/Cache_of_the_Firelord (original encounter chest and loot)", "https://classicdb.ch/?item=18659 (three-component Use text)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7622 The Balance of Light and Shadow"},
    {"The Eye of Divinity"},
    {"relic:eye-shadow", "relic:benediction", "dungeon:molten-core"},
    "Classic / Forever",
    true)

Curated("event:fall-dalaran",
    "Fall of Dalaran",
    "Event",
    "The Fall of Dalaran followed the Scourge's assault on the city during the Third War. Arthas and Kel'Thuzad sought the Book of Medivh, whose magic would allow the lich to summon Archimonde. The defenders' wards failed as their archmages fell, and Arthas killed Antonidas before the book was taken.\n\nArthas held off the surviving mages while Kel'Thuzad completed the summoning. Archimonde then destroyed Dalaran with magic. The fall joined the loss of a great center of learning to the Burning Legion's return, turning the Scourge's victory into a wider disaster for Azeroth.",
    {"https://warcraft.wiki.gg/wiki/Arthas_Menethil (independent Third War narration of assault and summoning)", "https://warcraft.wiki.gg/wiki/The_Siege_of_Dalaran_%28WC3_Undead%29 (original objective/transcript verification)", "https://warcraft.wiki.gg/wiki/Fall_of_dalaran (original cinematic identity and destruction verification)"},
    {"The Fall of Dalaran", "Destruction of Dalaran", "Siege of Dalaran (Third War)"},
    {"city:dalaran", "npc:kelthuzad", "npc:archimonde"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:54616e61726973",
    "Tanaris",
    "Region",
    "Tanaris is a desert in southern Kalimdor, where the goblins of Gadgetzan and Steamwheedle Port maintain their trading settlements among the dunes. Water is a source of conflict as well as survival: the Wastewander nomads have seized most of the Gadgetzan Water Company's wells, and the company seeks adventurers to help reclaim them.\n\nThe desert also holds Zul'Farrak, a Sandfury stronghold, and the Caverns of Time, the resting place of the bronze dragons. At the caverns, Anachronos becomes central to the effort to reopen the gates of Ahn'Qiraj. Beyond the goblin settlements, the region leads travelers into affairs far older than Gadgetzan's trade.",
    {"https://www.wowhead.com/classic/zone=440/tanaris (original-zone guide introduction)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1690 Wastewander Justice; #8286 What Tomorrow Brings; #8741 The Champion Returns; #8729 The Wrath of Neptulon; #2770 Gahz'rilla", "https://www.wowhead.com/classic/quest=8743/bang-a-gong (original quest progress)"},
    {},
    {"place:gadgetzan", "dungeon:zulfarrak", "event:gates-of-ahnqiraj"},
    "Classic / Forever")

Curated("place:quellithien-lodge",
    "Quel'Lithien Lodge",
    "Place",
    "Quel'Lithien Lodge is a high-elf hunting lodge in the northern Eastern Plaguelands, near the approach to Quel'Thalas. Ranger Lord Hawkspear and the lodge's defenders hold their position in a land devastated by the Scourge. Aurora Skycaller also resides here, pursuing the recovery of knowledge from the past.\n\nThe lodge possesses a registry concerning Nathanos Blightcaller's mortal life. Nathanos orders its recovery but refuses to explain its contents, demanding that the attackers leave suffering behind them. The document gives the lodge a place in a bitterly personal conflict; what Nathanos wants concealed remains his own secret.",
    {"https://warcraft.wiki.gg/wiki/Quel%27Lithien_Lodge (original geography and pre-Cataclysm residents)", "https://warcraft.wiki.gg/wiki/Fragments_of_the_Past_%282%29 (original quest objectives)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6133 The Ranger Lord's Behest; #5247 Fragments of the Past"},
    {},
    {"npc:nathanos", "group:high-elves", "region:4561737465726e20506c616775656c616e6473"},
    "Classic / Forever",
    true)

Curated("place:fallow-sanctuary",
    "Fallow Sanctuary",
    "Place",
    "Fallow Sanctuary is a Lost One village in the Swamp of Sorrows. To Magtoor of the Harborage, its inhabitants are former brethren driven mad by the journey to Azeroth. They prey on wanderers and have stolen the draenethyst crystals his people regard as sacred. The Harborage lacks the strength to recover them unaided.\n\nA raided caravan was also dragged into the village. Its cargo included reagents intended for the wizards of Nethergarde Keep, whose work concerns the Dark Portal. The stolen supplies connect this remote settlement to two different struggles: the Harborage's survival and the Alliance's efforts to watch the danger beyond the swamp.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1389 Draenethyst Crystals; #1392 Noboru the Cudgel; #1421 The Lost Caravan"},
    {},
    {"region:5377616d70206f6620536f72726f7773", "place:nethergarde"},
    "Classic / Forever",
    true)

Curated("region:4465616477696e642050617373",
    "Deadwind Pass",
    "Region",
    "Deadwind Pass lies between Duskwood and the Swamp of Sorrows, a bleak route through rock and dead trees. Karazhan, the tower of Medivh, stands to the south. Its closed doors offer no ordinary refuge along the road.\n\nThe pass also appears in the testimony of Sven Yorgen, a farmer from Duskwood. He says Dark Riders descended from here and slaughtered his family while he was away. His account carries the region's menace beyond the tower: for the people of the neighboring farms, danger from Deadwind has already crossed the boundary.",
    {"https://www.wowhead.com/classic/zone=41/deadwind-pass (original-zone geography)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #95 Sven's Revenge"},
    {"Deadwind"},
    {"npc:medivh", "region:4475736b776f6f64", "region:5377616d70206f6620536f72726f7773"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:sorcerer-thane-thaurissan",
    "Sorcerer-Thane Thaurissan",
    "Person",
    "Sorcerer-Thane Thaurissan led the Dark Iron dwarves during the War of the Three Hammers. Driven from Ironforge, he founded a southern city bearing his name and planned revenge. He attacked Ironforge while his wife, Modgud, marched against Grim Batol; both assaults failed.\n\nFacing the armies of his rivals, Thaurissan summoned Ragnaros in the hope of reversing his defeat. The Firelord's arrival killed the sorcerer-thane and enslaved the surviving Dark Irons. The catastrophe left the surrounding country burned and broken. Centuries later, Royal Historian Archesonus seeks relics from the ruined city to recover its lost history.",
    {"https://warcraft.wiki.gg/wiki/Sorcerer-Thane_Thaurissan", "https://warcraft.wiki.gg/wiki/War_of_the_Three_Hammers_%28History_of_Warcraft%29", "https://warcraft.wiki.gg/wiki/The_Smoldering_Ruins_of_Thaurissan", "https://classicdb.ch/?quest=3701"},
    {"Sorcerer Thane Thaurissan"},
    {"event:three-hammers", "faction:dark-iron", "npc:ragnaros"},
    "Classic / Forever",
    true)

Curated("npc:daelin-proudmoore",
    "Daelin Proudmoore",
    "Person",
    "Daelin Proudmoore was the grand admiral of Kul Tiras and Jaina Proudmoore's father. His war against the Horde brought him into conflict with the peace his daughter had built with Thrall. Daelin remembered the orcs' devastation of Stormwind and Lordaeron and rejected Thrall's claim that his people had changed.\n\nFrom Theramore, Daelin threatened the Horde's new homeland in Durotar. Jaina helped Thrall and Rexxar break his naval blockade, asking them to spare her own people. The admiral died in the fighting that followed. Thrall then withdrew, leaving Jaina's island in peace. The conflict's traces remain in Durotar, where documents bearing the admiral's seal alarm Razor Hill's commander.",
    {"https://wowpedia.fandom.com/wiki/A_Blaze_of_Glory_%28WC3_Orc%29", "https://classicdb.ch/?quest=830"},
    {"Admiral Daelin Proudmoore", "Grand Admiral Daelin Proudmoore"},
    {"npc:jaina", "npc:thrall", "place:theramore"},
    "Classic / Forever",
    true)

Curated("npc:rhonin",
    "Rhonin",
    "Person",
    "Rhonin is a human mage remembered for helping free Alexstrasza from the Dragonmaw orcs at Grim Batol. Nekros Skullcrusher held the Dragonqueen captive through the Demon Soul, using her power to sustain the clan's resistance after the Second War.\n\nRhonin and his companions destroyed the artifact, breaking Nekros's hold. The freed red dragons turned on their captors, bringing the Dragonmaw's stronghold to ruin. His importance to that struggle lay in undoing the means of the dragons' enslavement.",
    {"https://warcraft.wiki.gg/wiki/Rhonin", "https://warcraft.wiki.gg/wiki/Battle_of_Grim_Batol", "https://wowpedia.fandom.com/wiki/The_Battle_of_Grim_Batol_%28History_of_Warcraft%29"},
    {},
    {"event:grim-batol", "npc:alexstrasza", "faction:dragonmaw"},
    "Classic / Forever",
    true)

Curated("npc:aegwynn",
    "Aegwynn",
    "Person",
    "Aegwynn was a human Guardian of Tirisfal, charged with defending Azeroth against the Burning Legion, and the mother of Medivh. She resisted the Council's attempts to direct her and pursued the demons threatening the world.\n\nHer victory over Sargeras's avatar in Northrend concealed a disastrous deception. Though she defeated his physical form, his spirit entered her and later reached her son. Aegwynn chose Medivh to inherit the Guardian's power without knowing that the enemy she believed defeated had already compromised her heir.",
    {"https://warcraft.wiki.gg/wiki/Aegwynn", "https://worldofwarcraft.fandom.com/et/wiki/Guardian_of_Tirisfal", "https://warcraft.wiki.gg/wiki/Aegwynn_and_the_Dragon_Hunt"},
    {"Aegwyn", "Magna Aegwynn"},
    {"npc:medivh", "npc:sargeras", "book:guardians-tirisfal"},
    "Classic / Forever",
    true)

Curated("npc:madoran-bronzebeard",
    "Madoran Bronzebeard",
    "Person",
    "Madoran Bronzebeard led the clan that won Ironforge during the War of the Three Hammers. His army repelled Thaurissan's assault and joined the Wildhammers against the Dark Irons.\n\nHe offered the displaced Wildhammers refuge, but they chose Aerie Peak. Madoran and Khardros maintained ties between their kingdoms. Their sons commissioned statues honoring both rulers, remembered together in the Valley of Kings.",
    {"https://warcraft.wiki.gg/wiki/War_of_the_Three_Hammers_%28History_of_Warcraft%29", "https://warcraft.wiki.gg/wiki/Madoran_Bronzebeard"},
    {"Thane Madoran Bronzebeard", "King Madoran Bronzebeard"},
    {"event:three-hammers", "faction:bronzebeard", "faction:wildhammer"},
    "Classic / Forever",
    true)

Curated("faction:blue-dragonflight",
    "Blue Dragonflight",
    "Faction",
    "The blue dragonflight follows Malygos and watches over the use of magic on Azeroth. Deathwing's betrayal brought the flight close to extinction, leaving its surviving dragons to continue their work in a world filled with dangerous magical relics.\n\nAzuregos guards ancient treasures in Azshara and was entrusted with the blue shard of the Scepter of the Shifting Sands. In Winterspring, Haleh watches over Mazthoril. Her concern for dragonkind brings her into opposition to Nefarian, and she offers aid against his brood. She also knows how to restore the enchanted scale needed to pass Onyxia's wards. These scattered guardians preserve magical knowledge while deciding when the danger posed by other dragons requires mortal help.",
    {"https://warcraft.wiki.gg/wiki/Blue_dragonflight (independent introduction and After the Sundering narration; original-era facts only)", "https://warcraft.wiki.gg/wiki/Azuregos (original World of Warcraft section)", "https://warcraft.wiki.gg/wiki/Haleh (original World of Warcraft section)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5161 Wrath of the Blue Flight; #6502 Drakefire Amulet"},
    {},
    {"npc:malygos", "npc:azuregos", "npc:haleh"},
    "Classic / Forever",
    true)

Curated("faction:red-dragonflight",
    "Red Dragonflight",
    "Faction",
    "The red dragonflight is led by Alexstrasza the Life-Binder and shares her duty to protect life on Azeroth. During the Second War, the Dragonmaw clan held its queen through the Demon Soul and forced red dragons into the Horde's service as weapons against the Alliance. The flight regained its freedom at Grim Batol and turned against its captors.\n\nIts guardianship continues through dragons such as Vaelastrasz, who was entrusted with a shard of the Scepter of the Shifting Sands for a thousand years. Nefarian's corruption leaves him unable to protect it: the shard falls into the black dragon's hands, and Vaelastrasz warns a would-be champion to recover it before it can be destroyed. The flight's work remains threatened by the power of Deathwing's brood.",
    {"https://warcraft.wiki.gg/wiki/Red_dragonflight (independently written introductory history; original-era material only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8730 Nefarius's Corruption"},
    {},
    {"npc:alexstrasza", "event:grim-batol", "npc:vaelastrasz"},
    "Classic / Forever",
    true)

Curated("faction:thunderlord",
    "Thunderlord Clan",
    "Faction",
    "The Thunderlord clan is an orc clan associated with the chieftain Fenris. Its warriors remained on Draenor during the First and Second Wars, placing the clan among the Horde forces still in the orcs' homeland after the campaigns in Azeroth.",
    {"https://warcraft.wiki.gg/wiki/Thunderlord_clan (independent introductory historical paragraph and leader table; manual checked only for original-era identity)"},
    {"Thunderlord clan", "Thunderlords"},
    {"faction:blackrock-clan", "npc:nerzhul", "place:dark-portal"},
    "Classic / Forever",
    true)

Curated("faction:qiraji",
    "Qiraji",
    "Faction",
    "The Qiraji are an insectoid people whose empire occupies Ahn'Qiraj in southern Silithus. The Twin Emperors, Vek'lor and Vek'nilash, rule them from the temple, with leaders such as General Rajaxx, Battleguard Sartura and the Prophet Skeram commanding different castes. Their fortress lies behind the Scarab Wall, while the Old God C'Thun lurks within.\n\nTheir renewed preparations threaten Kalimdor and draw both Horde and Alliance into a common war effort. The silithid hives outside the wall are part of that danger: investigators find crystalline prisms apparently carrying Qiraji messages to the silithid. These discoveries reveal organization behind the spreading swarms, linking the insects of the open desert to the power hidden in Ahn'Qiraj.",
    {"https://warcraft.wiki.gg/wiki/Qiraji (independent introductory castes/leadership summary)", "https://warcraft.wiki.gg/wiki/Twin_Emperors (introductory identity)", "https://worldofwarcraft.blizzard.com/en-gb/news/23482836/wow-classic-ahnqiraj-the-scarab-lords-are-rising", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8314 Unraveling the Mystery; #8315 The Calling"},
    {},
    {"group:twin-emperors", "npc:cthun", "group:silithid"},
    "Classic / Forever",
    true)

Curated("book:titans-shaping",
    "The Titans and the Shaping of the Universe",
    "Book",
    "The Titans and the Shaping of the Universe is a chapter of the History of Warcraft, also preserved as the book Mythology of the Titans. It describes the Titans traveling between worlds to establish conditions in which life can flourish, opposed by demons that seek to destroy their work.\n\nA copy is held in the library of the old Monastery in Tirisfal Glades. Librarian Mae Paledust wants it brought to Ironforge for study, believing that knowledge of the past can help prepare people for the future. The Scarlet Crusade's occupation has made the former place of learning dangerous, and the Explorers' League regards the text as a treasure worth recovering.",
    {"https://warcraft.wiki.gg/wiki/Mythology_of_the_Titans (bibliographic introductory identity and alternate title only)", "https://it.wikipedia.org/wiki/Storia_dell%27universo_di_Warcraft (independent synopsis of the original chapter, first two sentences of I Titani e la Legione Infuocata; bibliography note5)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1050 Mythology of the Titans", "https://warcraft.wiki.gg/wiki/Mythology_of_the_Titans_%28quest%29 (original giver/objective)"},
    {"The Titans and the Shaping of the Universe (book)", "Mythology of the Titans", "Mythology of the Titans (book)"},
    {"faction:titans", "place:scarlet-library", "faction:explorers-league"},
    "Classic / Forever",
    true)

Curated("relic:demon-soul",
    "Demon Soul",
    "Relic",
    "The Demon Soul was a magical disk capable of subjecting dragons to its wielder's power. Nekros Skullcrusher of the Dragonmaw used it to hold Alexstrasza captive. Through that captivity the orcs compelled her red dragonflight to serve them, making the artifact a foundation of the clan's wartime strength.\n\nIts destruction ended that control. During the struggle at Grim Batol, Rhonin broke the disk with a scale from Deathwing. The power trapped within returned to the other Aspects, enabling them to overcome their treacherous brother. The object that had sustained the dragons' imprisonment thus became the means of restoring their freedom and strength when it was broken.",
    {"https://warcraft.wiki.gg/wiki/Demon_Soul (independently written introductory, Second War and Day of the Dragon sections; original-era facts only)", "https://warcraft.wiki.gg/wiki/The_Warcraft_Encyclopedia/Vereesa_Windrunner (preserved Blizzard account, The Demon Soul section)"},
    {"The Demon Soul (artifact)"},
    {"npc:alexstrasza", "event:grim-batol", "faction:dragonmaw"},
    "Classic / Forever",
    true)

Curated("relic:scepter-shifting-sands",
    "The Scepter of the Shifting Sands",
    "Relic",
    "The Scepter of the Shifting Sands is the artifact needed to ring the Scarab Gong and open the gates of Ahn'Qiraj. After Fandral Staghelm shattered it, Anachronos collected the pieces and divided their guardianship among four Dragon Aspects, hoping to keep anyone seeking chaos from restoring it.\n\nReassembling it requires recovering the blue, green and red shards. Their guardianship has become perilous: Vaelastrasz warns that Nefarius has taken his shard and means to destroy it, while another lies in the waters off Azshara. Anachronos can reform the scepter once the fragments return. Its bearer must await the armies of Horde and Alliance before ringing the gong, because opening the barrier also releases the enemy that those forces have gathered to confront.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8519 A Pawn on the Eternal Board; #8729 The Wrath of Neptulon; #8730 Nefarius's Corruption", "https://warcraft.wiki.gg/wiki/The_Might_of_Kalimdor (original completion/gossip and shard forks)", "https://warcraft.wiki.gg/wiki/Bang_a_Gong%21 (original description)"},
    {"Scepter of the Shifting Sands"},
    {"npc:anachronos", "event:shifting-sands", "faction:qiraji"},
    "Classic / Forever",
    true)

Curated("event:great-masquerade",
    "The Great Masquerade",
    "Event",
    "The Great Masquerade is Marshal Windsor's confrontation with Lady Katrana Prestor in Stormwind Keep. Armed with tablets written in ancient draconic, Windsor exposes the noblewoman as Onyxia, the black dragon who has held the court in her influence. Highlord Bolvar Fordragon discovers that the palace guards beside him are dragonspawn.\n\nOnyxia mortally wounds Windsor and escapes, leaving her servants to attack. Bolvar's enchanted medallion shatters, breaking the dragon's control over him, and he survives to mourn Windsor's sacrifice. The revelation frees the kingdom from her disguised rule but leaves Onyxia herself a threat.\n\nThe broken medallion points toward the next step: a dragon's help is needed to remake it into a key to her lair. Thus the exposure at court leads into the search for the Drakefire Amulet.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6403 The Great Masquerade; #6501 The Dragon's Eye; #6502 Drakefire Amulet", "https://warcraft.wiki.gg/wiki/The_Great_Masquerade (original scripted event and after-fight dialogue)"},
    {"Great Masquerade"},
    {"npc:windsor", "npc:onyxia", "relic:drakefire-amulet"},
    "Classic / Forever",
    true)

Curated("event:missing-diplomat",
    "The Missing Diplomat",
    "Event",
    "The Missing Diplomat is the secret investigation into an envoy who vanished while traveling from Stormwind to meet Jaina Proudmoore in Theramore. Bishop DeLavey's contacts draw Elling Trias into the search. Defias papers at Addle's Stead lead to Dashel Stonefist in Stormwind and then to Slim in Menethil Harbor.\n\nUnder questioning, Slim reveals that the captive is Stormwind's king, Varian Wrynn, and that the Defias are working with another, unnamed party. Slim's task was to place a man called Hendel aboard the royal ship. The trail therefore crosses the sea to Theramore's garrison.\n\nWith Jaina's knowledge, Archmage Tervosh helps locate Private Hendel in Dustwallow Marsh. Hendel resists, but is subdued and taken for questioning. The investigation reaches a living accomplice; the king's recovery remains an unresolved task.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1241, #1244-#1250, #1264-#1266, #1274 and #1324 The Missing Diplomat", "https://classicdb.ch/?npc=11699 (original Varian Wrynn, King of Stormwind identity)"},
    {"Missing Diplomat"},
    {"group:defias", "npc:private-hendel", "npc:jaina"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:warsong-lumber-camp",
    "Warsong Lumber Camp",
    "Place",
    "Warsong Lumber Camp is a Horde logging camp in eastern Ashenvale. Its work lies at the heart of the struggle over the forest: the Warsong claim the right to harvest its timber, while the Silverwing Sentinels fight to preserve the trees that shelter their homeland and protect Astranaar.\n\nKeeping the camp working requires more than axes. Shredders come from Ratchet, saw blades through Splintertree Post, and other supplies from as far away as Booty Bay. Furbolgs have stolen rope, while satyrs divert the camp's oil into their rituals. Even a shredder operator's lost manual can bring work to a halt.",
    {"https://warcraft.wiki.gg/wiki/Warsong_Lumber_Camp (original location and logging identity)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6504 The Lost Pages; #6571 Warsong Supplies; #7789 Quell the Silverwing Usurpers; #8372 Fight for Warsong Gulch"},
    {},
    {"region:417368656e76616c65", "faction:warsong-outriders", "faction:silverwing"},
    "Classic / Forever",
    true)

Curated("place:trollbane-hall",
    "Trollbane Hall",
    "Place",
    "Trollbane Hall is the League of Arathor's base in the northwest of Arathi Basin, where Alliance fighters gather before entering the struggle against the Defilers.\n\nBeyond its gates, the battle is fought over the basin's working land: its farm, mine, lumber mill and blacksmith provide resources the armies need. For the League, holding those positions also serves the hope of reclaiming its homeland.",
    {"https://warcraft.wiki.gg/wiki/Trollbane_Hall (original battleground base; excludes patch 8.1.5 rebuilding)", "https://www.wowhead.com/news/the-arathi-basin-battleground-is-now-live-wow-classic-fresh-376225 (Classic starting-base location)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8105 The Battle for Arathi Basin!; #8114 Control Four Bases"},
    {},
    {"battleground:arathi-basin", "faction:arathor", "faction:defilers"},
    "Classic / Forever",
    true)

Curated("place:whelgars-excavation-site",
    "Whelgar's Excavation Site",
    "Place",
    "Whelgar's Excavation Site is a dwarven dig in the Wetlands, east of Menethil Harbor. The team had been uncovering rare artifacts and enormous bones when mottled raptors overran the excavation, killing many of the workers.\n\nOrmer Ironbraid helped Prospector Whelgar and Merrin Rockweaver escape. The three survivors remain stranded on a ridge above their ruined work. Merrin seeks to send word to her husband, Tarrel, so that he will at least know she is alive; the discoveries below now lie among the creatures that drove the expedition into hiding.",
    {"https://classic-wow-archive.fandom.com/wiki/Whelgar%27s_Excavation_Site (original geography, ridge and named survivors)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #305 In Search of The Excavation Team; #306 In Search of The Excavation Team"},
    {"Whelgar's Excavation", "Whelgar Excavation Site", "the Whelgar Excavation Site"},
    {"region:5765746c616e6473", "place:menethil"},
    "Classic / Forever",
    true)

Curated("npc:brother-crowley",
    "Brother Crowley",
    "Person",
    "Brother Crowley is a human emissary of the Scarlet Crusade in Stormwind's Cathedral of Light. He represents the crusaders within the city and seeks help for their campaign against the undead.\n\nHis colleague Brother Anton has sailed to Desolace after hearing of an undead infestation there. Crowley directs willing adventurers to Anton at Nijel's Point, extending the Crusade's search for allies from Stormwind to distant Kalimdor.",
    {"https://warcraft.wiki.gg/wiki/Brother_Crowley", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6141 Brother Anton"},
    {},
    {"group:scarlet-crusade", "region:53746f726d77696e642043697479", "place:nijels-point"},
    "Classic / Forever",
    true)

Curated("npc:nogg",
    "Nogg",
    "Person",
    "Nogg is a goblin engineer with a machine shop in Orgrimmar's Valley of Honor. Gnomeregan's advances trouble his professional pride: a new gnomish rig outperforms the goblins' shredders. He wants its blueprints from Thermaplugg's safe so that its innovations can be adapted to goblin machines.\n\nA ring recovered from the Dark Iron dwarves gives him another lead. Nogg wonders whether stolen golem designs explain the gnomes' sudden success, though this remains his suspicion. In return for the information, he offers to strengthen the ring's enchantment if its bearer supplies silver, moss agate and a fee for his work.",
    {"https://warcraft.wiki.gg/wiki/Nogg", "https://classicdb.ch/?quest=2841", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2949 Return of the Ring; #2950 Nogg's Ring Redo"},
    {},
    {"region:4f726772696d6d6172", "dungeon:gnomeregan", "npc:thermaplugg"},
    "Classic / Forever",
    true)

Curated("npc:tabetha",
    "Tabetha",
    "Person",
    "Tabetha is a human mage living deep in Dustwallow Marsh, in a cottage west of Theramore and north of the Stonemaul ruins. Mages seek her help in making magical implements. For one wand, she needs knowledge preserved in Magus Tirth's Rituals of Power and sends its would-be bearer to find the wayward scholar.\n\nHer own treasures have drawn unwelcome attention. Hydromancer Velratha sent thieves to steal Tabetha's powerful Tiara of the Deep while she was away. Tabetha asks adventurers to retrieve it from the troll city of Zul'Farrak; her anger at the theft is as plain as her gratitude for its return.",
    {"https://warcraft.wiki.gg/wiki/Tabetha", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1949 Hidden Secrets; #2861 Tabetha's Task; #2846 Tiara of the Deep"},
    {},
    {"region:4475737477616c6c6f77204d61727368", "dungeon:zulfarrak", "relic:orb-nohorahil"},
    "Classic / Forever",
    true)

Curated("npc:neeru-fireblade",
    "Neeru Fireblade",
    "Person",
    "Neeru Fireblade is an orc warlock in Orgrimmar's Cleft of Shadow and the secret leader of the Burning Blade. He presents his occult research as harmless work against demons. Margoz doubts that assurance but still seeks his expertise when demonic collars prove beyond a shaman's understanding.\n\nThrall knows where Neeru's loyalties lie. Rather than arrest him immediately, the warchief seeks to turn his confidence into a weakness: an adventurer carrying a Burning Blade lieutenant's insignia can approach him as an ally. Thrall hopes the deception will expose the Shadow Council's network and the enemies working within the Horde's new homeland.",
    {"https://warcraft.wiki.gg/wiki/Neeru_Fireblade", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #829 Neeru Fireblade", "https://classicdb.ch/?quest=5727"},
    {"Neeru"},
    {"faction:burning-blade", "npc:thrall", "region:4f726772696d6d6172"},
    "Classic / Forever",
    true)

Curated("npc:lorekeeper-raintotem",
    "Lorekeeper Raintotem",
    "Person",
    "Lorekeeper Raintotem is an elderly tauren found south of Red Rocks in Mulgore. He speaks for the sanctity of this burial ground, where the tribes honor warriors who helped establish and protect Thunder Bluff and those who died in service to their people.\n\nBristleback interlopers have begun ravaging the graves. Raintotem considers himself too old to drive them away, so he calls on younger defenders to remove them by force. His appeal ties the defense of the site to remembrance of the tauren whose sacrifices made it sacred.",
    {"https://warcraft.wiki.gg/wiki/Lorekeeper_Raintotem", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #833 A Sacred Burial"},
    {},
    {"region:4d756c676f7265", "region:5468756e64657220426c756666", "faction:bristleback"},
    "Classic / Forever",
    true)

Curated("npc:henze-faulk",
    "Henze Faulk",
    "Person",
    "Henze Faulk is a dwarf who fell to Defias spellcasters at Heroes' Vigil, the island in Elwynn Forest's Stone Cairn Lake. He and Gazin Tenorm had gone there to obtain proof of Defias infiltration for the king's advisers. When their attack drew more enemies than they could face, Henze held them back long enough for Gazin to escape.\n\nA paladin bearing the Symbol of Life can revive him. Still too weak to fight, Henze asks his rescuer to finish their original work: recover the Defias papers and take them to Gazin, along with word that Henze is safe.",
    {"https://warcraft.wiki.gg/wiki/Henze_Faulk", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1786 The Tome of Divinity; #1787 The Tome of Divinity"},
    {},
    {"region:456c77796e6e20466f72657374", "group:defias"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:ironforge",
    "Ironforge (faction)",
    "Faction",
    "Ironforge is the Alliance faction of the dwarven capital, home to King Magni Bronzebeard and the dwarves of Dun Morogh. Standing with Ironforge measures an adventurer's reputation with this community.\n\nService to the dwarves can earn their recognition. Mistina Steelshield receives cloth for the city's reserves, accepting further runecloth donations from those who have already contributed. Her work gives travelers a continuing way to support Ironforge and improve their standing with its people.",
    {"https://classicdb.ch/?faction=47", "https://classicdb.ch/?quest=7805", "https://classicdb.ch/?quest=7806"},
    {"Ironforge (reputation faction)", "Ironforge faction"},
    {"region:49726f6e666f726765", "npc:magni", "faction:alliance"},
    "Classic / Forever",
    true)

Curated("faction:witherbark",
    "Witherbark Tribe",
    "Faction",
    "The Witherbark are forest trolls with settlements in the Arathi Highlands and the Hinterlands. They are enemies of Stromgarde, and in Arathi they also cooperate with the Boulderfist ogres against the Horde at Hammerfall. Their witch doctors carry medicine pouches, while accomplished shadow hunters bear knives awarded after their rites of passage.\n\nIn the Hinterlands, the tribe inhabits villages such as Hiri'watha and Zun'watha. Horde emissaries accuse the Witherbark of betraying their former allies and demand bloody reprisals. The tribe also worships Shadra, a spider god whose venom is potent enough to attract the interest of Forsaken apothecaries.",
    {"https://warcraft.wiki.gg/wiki/Witherbark_tribe", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #677, #691, #1429, #2932, #2933, #2935, #2936, #2937, #2938"},
    {"Witherbark", "Witherbark trolls", "Witherbarks", "Witherbark tribe"},
    {"place:hammerfall", "place:stromgarde", "place:shadraalor"},
    "Classic / Forever",
    true)

Curated("faction:undercity",
    "Undercity (faction)",
    "Faction",
    "Undercity is the Horde faction associated with the Forsaken capital beneath the ruins of Lordaeron. Led by Sylvanas Windrunner, the Forsaken maintain an uneasy alliance with the Horde; standing with Undercity records an adventurer's reputation with their capital.\n\nThe city's needs offer opportunities to earn that trust. Ralston Farnsley organizes a cloth drive to replenish its reserves. After the initial donations, he continues to accept runecloth and promises recognition for further support of Undercity.",
    {"https://classicdb.ch/?faction=68", "https://classicdb.ch/?quest=7818", "https://classicdb.ch/?quest=7819"},
    {"Undercity (reputation faction)", "Undercity faction"},
    {"place:undercity", "faction:forsaken", "npc:sylvanas"},
    "Classic / Forever",
    true)

Curated("faction:green-dragonflight",
    "Green Dragonflight",
    "Faction",
    "The green dragonflight follows Ysera and protects the natural world and the Emerald Dream. Its dragons guard portals to the Dream at the Great Trees. The flight's connection with the night elves is reflected in the druids' pact with Ysera, for which guardians keep watch over their sleeping brethren.\n\nCorruption threatens these protectors from within. Emeriss, Lethon, Taerar and Ysondre have become the Dragons of Nightmare, appearing through the Great Trees as dangers to the balance of nature. Elsewhere, Itharius seeks help for Ysera's flight in redeeming Eranikus, whose remaining free will is bound within a gem. The flight's charge therefore includes the struggle to reclaim its own corrupted kin.",
    {"https://warcraft.wiki.gg/wiki/Green_dragonflight", "https://wowpedia.fandom.com/wiki/Green_dragonflight", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #475 A Troubling Breeze; #3374 The Essence of Eranikus"},
    {},
    {"npc:ysera", "place:emerald-dream", "group:nightmare-dragons"},
    "Classic / Forever",
    true)

Curated("race:furbolgs",
    "Furbolgs",
    "People",
    "Furbolgs are bear-men whose tribes live in the forests of Kalimdor. Night elves remember the Gnarlpine of Teldrassil as peaceful neighbors, making their growing rage and attacks on the Sentinels especially disturbing. In Ashenvale, furbolg attacks endanger travelers, while the Thistlefur stand in the path of the Horde's expansion between its outposts.\n\nThese conflicts do not make every furbolg an enemy by nature. Corruption has ravaged tribes such as the Deadwood, and the uncorrupted Timbermaw distrust outsiders who kill furbolgs without distinguishing friend from foe. They nevertheless offer friendship to those willing to help defend them against their corrupted brethren. Their struggle preserves a distinction between the furbolg people and the evil that has overtaken many of their kin.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #933, #459, #216, #1024, #1030, #1025, #8460, #8461, #8462"},
    {"Furbolg"},
    {"faction:timbermaw", "faction:deadwood", "place:gnarlpine-hold"},
    "Classic / Forever",
    true)

Curated("relic:pendant-myzrael",
    "Pendant of Myzrael",
    "Relic",
    "The Pendant of Myzrael is a crystal shard that carries a mysterious plea for help. Holding it brings a vision of a brilliant crystal rising from the northern mountains of Arathi, drawing its bearer toward the Shards of Myzrael.\n\nThrough those crystals, Myzrael identifies herself as a princess of the earth imprisoned beneath the Highlands by giants. She asks for aid in strengthening the crystal network, presenting the shards as her only means of reaching the surface. The pendant begins contact with this pleading prisoner; its vision is an invitation to investigate her story.",
    {"https://classicdb.ch/?quest=635", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #635 Crystal in the Mountains; #642 The Princess Trapped"},
    {},
    {"region:41726174686920486967686c616e6473"},
    "Classic / Forever",
    true)

Curated("relic:hydrocane",
    "Hydrocane",
    "Relic",
    "Hydrocane is a rare two-handed staff found among the spoils of Viscous Fallout in Gnomeregan. Its distinctive enchantment allows its wielder to breathe underwater while the staff is equipped. It also offers protection against frost, making it useful beyond its ordinary role as a weapon.",
    {"https://wowclassicdatabase.com/item/hydrocane"},
    {},
    {"npc:viscous-fallout", "dungeon:gnomeregan"},
    "Classic / Forever",
    true)

Curated("event:battle-mount-hyjal",
    "Battle of Mount Hyjal",
    "Event",
    "The Battle of Mount Hyjal was the climactic defense of the World Tree, Nordrassil, against Archimonde and the Burning Legion during the Third War. Jaina Proudmoore's humans, Thrall's orcs and the night elves under Tyrande Whisperwind and Malfurion Stormrage joined forces to defend the mountain. Their task was to delay Archimonde long enough for Malfurion to prepare a trap at the summit.\n\nAs the defenders' bases fell, Archimonde pressed onward toward the tree. Malfurion sounded the Horn of Cenarius, calling the forest's nature spirits against him. Their attack destroyed the demon lord in a devastating blast. Victory spent Nordrassil's power and cost the night elves their immortality; the surviving world faced recovery after a battle won through cooperation and sacrifice.",
    {"https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods", "https://warcraft.wiki.gg/wiki/Eternity%27s_End_%28WC3_NightElf%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #921 Crown of the Earth"},
    {"Battle for Mount Hyjal", "Battle of Hyjal"},
    {"event:third-war", "npc:archimonde", "npc:malfurion"},
    "Classic / Forever",
    true)

Curated("relic:orb-soranruk",
    "Orb of Soran'ruk",
    "Relic",
    "The Orb of Soran'ruk belongs to a class of Legion relics used to imprison the spirits of demons who have fallen out of favor. Such orbs were entrusted to mages and warlocks, retaining demonic power even when broken.\n\nSoran'ruk's orb was split into two pieces. One was broken further for the Twilight's Hammer acolytes in Blackfathom Deeps; the larger piece came into the possession of a wizard in Shadowfang Keep. Doan Karhan studies and restores these orbs. He seeks the scattered fragments and offers to reconstruct Soran'ruk in a form chosen by whoever brings them to him.",
    {"https://classicdb.ch/?quest=1740", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1740 The Orb of Soran'ruk"},
    {"The Orb of Soran'ruk"},
    {"dungeon:blackfathom", "dungeon:shadowfang", "group:twilights-hammer"},
    "Classic / Forever",
    true)

Curated("event:fall-gnomeregan",
    "Fall of Gnomeregan",
    "Event",
    "Gnomeregan's fall began with the invasion of the gnomish capital by troggs. A desperate attempt to defeat them with toxic radiation instead devastated the city and its people. Surviving gnomes fled to Ironforge, leaving behind an irradiated home still infested with troggs and afflicted leper gnomes.\n\nHigh Tinker Mekkatorque condemns Thermaplugg as the trusted adviser who betrayed his people and now rules their lost city. He calls for the betrayer's destruction as a step toward reclaiming Gnomeregan. Other survivors pursue repairs and remedies: Techbot's creator hopes to recover the machine's damaged mind, while gnomish inventors work on reversing the leper condition. The disaster has left the exiles fighting both for their home and for those changed by its fall.",
    {"https://warcraft.wiki.gg/wiki/Invasion_of_Gnomeregan", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #412, #2040, #2922, #2927, #2929, #3361"},
    {"Gnomeregan's fall", "Invasion of Gnomeregan", "Gnomeregan incident"},
    {"dungeon:gnomeregan", "faction:gnomeregan-exiles", "npc:gelbin"},
    "Classic / Forever",
    true)

Curated("relic:stave-equinex",
    "Stave of Equinex",
    "Relic",
    "The Stave of Equinex is the key to the Equinex Monolith in the Ruins of Ravenwind, west of the Dream Bough in Feralas. Troyas Moonbreeze's research describes how to awaken it: the essences of four flames still burning among the ruins, Samha, Imbel, Byltan and Lahassa, must energize the stave beside the monolith.\n\nThe charged stave opens a small door in the monolith, revealing the Morrow Stone. The stave's energy begins to fade once the stone is removed. Troyas identifies the artifact but remains uncertain of its purpose, regarding its hidden resting place as a sign of its significance and a reason for further study.",
    {"https://classicdb.ch/?quest=2879", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2879 The Stave of Equinex; #2942 The Morrow Stone"},
    {"The Stave of Equinex"},
    {"npc:troyas", "place:ruins-ravenwind"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:demon-fall-ridge",
    "Demon Fall Ridge",
    "Place",
    "Demon Fall Ridge rises above the western side of Demon Fall Canyon in Ashenvale. Demons occupy the heights and an abandoned barrow den, carrying their presence beneath the forest as well as across its surface.\n\nDeep inside the den waits Diathorus the Seeker. The ridge is a distinct part of this demon-haunted country; the canyon below and the passages within the ridge are separate places to explore.",
    {"https://classic-wow-archive.fandom.com/wiki/Demon_Fall_Ridge", "https://warcraft.wiki.gg/wiki/Demon_Fall_Ridge", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_hr.pdf (original 2005 atlas, Diathorus the Seeker at bottom of Demon Fall Ridge dungeon)"},
    {},
    {"region:417368656e76616c65"},
    "Classic / Forever",
    true)

Curated("place:jademir-lake",
    "Jademir Lake",
    "Place",
    "Jademir Lake lies in northern Feralas. At its center is Dream Bough, an island with a portal to the Emerald Dream. Green dragonkin guard this threshold, linking a remote corner of the forest to the realm their flight protects.\n\nDream Bough is also one of the places where the Dragons of Nightmare can emerge. No single dragon belongs permanently to the lake: the four corrupted guardians can appear at different portals.",
    {"https://classic-wow-archive.fandom.com/wiki/Jademir_Lake", "https://warcraft.wiki.gg/wiki/Jademir_Lake", "https://us.forums.blizzard.com/en/wow/t/the-dragons-of-nightmare-have-arrived/498667 (Kaivax, April 2020, Dragons of Nightmare Spawn Locations)"},
    {},
    {"region:466572616c6173", "place:emerald-dream", "faction:green-dragonflight"},
    "Classic / Forever",
    true)

Curated("place:angor-fortress",
    "Angor Fortress",
    "Place",
    "Angor Fortress is the Dark Iron dwarves' base in the Badlands, supporting their search for the buried knowledge of Uldaman. The Shadowforge bring strange stones out of the ruins and have learned to use them as stable sources of power.\n\nTheir ambitions reach beyond excavation. The Dark Irons of Angor fashioned the Sign of the Earth to bind the dragons Blacklash and Hematus. Ambassador Infernus, sent by Ragnaros, oversees the recovery of artifacts. Ironforge's concern is not simply a rival digging expedition, but what its discoveries might put into hostile hands.",
    {"https://classic-wow-archive.fandom.com/wiki/Angor_Fortress", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #726 Passing Word of a Threat; #732 Tremors of the Earth; #762 An Ambassador of Evil; #2418 Power Stones"},
    {"Angor"},
    {"region:4261646c616e6473", "faction:dark-iron", "dungeon:uldaman"},
    "Classic / Forever",
    true)

Curated("place:bathrans-haunt",
    "Bathran's Haunt",
    "Place",
    "Bathran's Haunt is a ruined site in northern Ashenvale, beyond Maestra's Post and just south of Darkshore. Among the ruins grows Bathran's Hair, a plant valued for treating ailments of the spirit.\n\nA sick child gives the place an urgent importance to Orendil Broadleaf. Suspecting more than a bodily illness, he seeks the herb for a remedy. Yet the ruins are also occupied by Forsaken, whose presence troubles him: the search for a cure leads into ground held by enemies.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1010 Bathran's Hair", "https://www.wowhead.com/classic/quest=1010/bathrans-hair"},
    {},
    {"region:417368656e76616c65", "place:maestras-post"},
    "Classic / Forever",
    true)

Curated("place:satyrnaar",
    "Satyrnaar",
    "Place",
    "Satyrnaar is a satyr-held site in northeastern Ashenvale. Its blood-soaked temples are part of the threat Delgren the Purifier investigates from Maestra's Post.\n\nIlkrud's writings reveal that Athrikus Narassin has two soulgems hidden among the satyrs, one at Satyrnaar and the other at Night Run. Delgren believes destroying them will weaken the master of the Tower of Althalaxx. The forest settlement is therefore tied to a danger farther away: a guarded piece of the cult leader's power lies within it.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1140 The Tower of Althalaxx"},
    {},
    {"region:417368656e76616c65", "place:maestras-post"},
    "Classic / Forever",
    true)

Curated("place:hammertoes-digsite",
    "Hammertoe's Digsite",
    "Place",
    "Hammertoe's Digsite is an abandoned excavation in the northern Badlands, occupied by Dark Iron dwarves. Ryedol, one of the workers who escaped their attack, believes nearly everyone was killed. He hopes to recover the supplies left behind, especially his lucky pick.\n\nA crumpled map offers a different fate for his missing boss. Hammertoe's hastily written message says that he is being taken to Uldaman and asks Ryedol to send help. The ruined dig is the beginning of a search for a captive, not merely the aftermath of a massacre.",
    {"https://classic-wow-archive.fandom.com/wiki/Hammertoe%27s_Digsite", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #719 A Dwarf and His Tools; #720 A Sign of Hope; #721 A Sign of Hope"},
    {},
    {"region:4261646c616e6473", "dungeon:uldaman", "faction:dark-iron"},
    "Classic / Forever",
    true)

Curated("npc:shindrell-swiftfire",
    "Shindrell Swiftfire",
    "Person",
    "Shindrell Swiftfire is a night elf Sentinel in Astranaar, welcoming Alliance travelers willing to help troubled Ashenvale. The forest's beauty endures, she says, but its former peace does not.\n\nShe is also concerned by reports from Theramore that orc assassins are using pridewing venom from the Stonetalon Mountains. Although she acknowledges that the report may be unproven, she asks for the beasts' venom sacs to deny the Horde this suspected supply. The task troubles her: the pridewings may have no willing part in the conflict, yet she considers their slaughter a duty to protect her allies.",
    {"https://warcraft.wiki.gg/wiki/Shindrell_Swiftfire", "https://classicdb.ch/?quest=1134", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1133 Journey to Astranaar; #1134 Pridewings of Stonetalon"},
    {"Shindrell"},
    {"place:astranaar", "region:417368656e76616c65", "region:53746f6e6574616c6f6e204d6f756e7461696e73"},
    "Classic / Forever",
    true)

Curated("npc:jonathan-carevin",
    "Jonathan Carevin",
    "Person",
    "Jonathan Carevin heads a human household of monster hunters in Darkshire. His family and their supporters fight the demons, undead and other horrors of Duskwood. He greets strangers with suspicion, but accepts aid from those willing to confront the forest's evils.\n\nAn inquiry into Velinde Starsong and the Scythe of Elune brings his struggle with the worgen into focus. Jonathan directs the investigation to the southern mine where the creatures were first reported, Roland's Doom. His household lacks the influence to end the wider threat, so he makes containment its immediate aim and instructs Calor to give the worgen his highest priority.",
    {"https://warcraft.wiki.gg/wiki/Jonathan_Carevin", "https://warcraft.wiki.gg/wiki/Carevin", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1042 The Carevin Family; #1043 The Scythe of Elune"},
    {"Master Carevin"},
    {"place:darkshire", "region:4475736b776f6f64", "npc:thyntel-bladeweaver"},
    "Classic / Forever",
    true)

Curated("npc:jitters",
    "Jitters",
    "Person",
    "Jitters is a terrified human hiding in the abandoned settlement of Raven Hill in Duskwood. Once a member of the Defias Brotherhood, he found the Scythe of Elune in the rubble of Roland's Doom. His journal describes worgen overrunning the mine after he pulled it free; he escaped the slaughter but lost the weapon during his flight.\n\nHe later hid in Sven Yorgen's barn and witnessed the Dark Riders demand the Scythe before murdering Sven's family. Jitters believes his discovery drew the Riders there. Fear of them keeps him moving and hiding, convinced that he too will eventually be found. At Raven Hill, weeks of living on weeds and grubs have left him desperate for proper food.",
    {"https://warcraft.wiki.gg/wiki/Jitters", "https://warcraft.wiki.gg/wiki/Jitters%27_Completed_Journal", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5 Jitters' Growling Gut"},
    {},
    {"place:raven-hill", "region:4475736b776f6f64", "group:defias"},
    "Classic / Forever",
    true)

Curated("npc:thundris-windweaver",
    "Thundris Windweaver",
    "Person",
    "Thundris Windweaver is the night elf elder who oversees Auberdine's daily affairs. The corruption of Darkshore concerns him as deeply as the growing hostility of its forest dwellers. When the Cliffspring River turns foul, he requests a water sample, fearing that its taint will reach the village. He suspects the Blackwood furbolgs are involved but believes the corruption begins farther afield in Felwood.\n\nHis investigation identifies a satyr's talisman as a means of controlling the furbolgs. Thundris proposes mixing their food with moonwell water to cleanse them briefly and draw out the corruptor. He wants the talisman brought to him for disposal, hoping that the knowledge gained may eventually free the Blackwood permanently.",
    {"https://warcraft.wiki.gg/wiki/Thundris_Windweaver", "https://classicdb.ch/?quest=4763", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4761 Thundris Windweaver; #4762 The Cliffspring River; #4763 The Blackwood Corrupted"},
    {"Thundris"},
    {"place:auberdine", "faction:blackwood", "region:4461726b73686f7265"},
    "Classic / Forever",
    true)

Curated("npc:thyntel-bladeweaver",
    "Thyn'tel Bladeweaver",
    "Person",
    "Thyn'tel Bladeweaver is a night elf Sentinel commander in Darnassus's Warrior's Terrace. She helps investigate the disappearance of the priestess Velinde Starsong, whose past service has earned the Sentinels' trust. At first, they believe Velinde left for reasons of her own and could return at any time.\n\nEvidence from the Tome of Mel'Thandris persuades Thyn'tel to allow a search of Velinde's stored belongings. The priestess's journal makes the disappearance seem more troubling, and Thyn'tel seeks renewed contact with her. She directs the search to Ratchet's dockmaster, reasoning that the port's passenger records may reveal how Velinde crossed the sea.",
    {"https://warcraft.wiki.gg/wiki/Thyn%27tel_Bladeweaver", "https://classicdb.ch/?quest=1037", "https://classicdb.ch/?quest=1038", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1037 Velinde Starsong; #1038 Velinde's Effects; #1039 The Barrens Port"},
    {"Thyn'tel"},
    {"region:4461726e6173737573", "place:ratchet", "npc:jonathan-carevin"},
    "Classic / Forever",
    true)

Curated("npc:talvash-del-kissel",
    "Talvash del Kissel",
    "Person",
    "Talvash del Kissel is a gnome jeweler in Ironforge's Mystic Ward whose livelihood has collapsed under a damaged reputation. He made a magical necklace for a paladin who died while seeking to cleanse Uldaman. Talvash blames a competitor for spreading the rumor that his jewelry cursed its wearer.\n\nThe shattered necklace offers a chance to vindicate his work. After asking for silver to finish a rare new order, he offers to restore it if its missing gems are recovered and its bearer will vouch for him. A Phial of Scrying lets the searchers contact him from afar. The gems alone are insufficient: the necklace also needs a new source of magical power.",
    {"https://warcraft.wiki.gg/wiki/Talvash_del_Kissel", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2198 The Shattered Necklace; #2199 Lore for a Price; #2200 Back to Uldaman; #2201 Find the Gems"},
    {"Talvash"},
    {"region:49726f6e666f726765", "dungeon:uldaman", "npc:grimlok"},
    "Classic / Forever",
    true)

Curated("faction:deaths-head",
    "Death's Head Tribe",
    "Faction",
    "The Death's Head are a quilboar tribe found in Razorfen Downs, where Amnennar the Coldbringer rules in the service of the Scourge. Their ranks include practitioners of necromancy, and the Downs have become a stronghold of undeath within Kalimdor's thorn-covered quilboar lands.\n\nBoth Alliance and Horde observers describe a pact between the quilboar and the Scourge. Amnennar's control makes the settlement more than a local threat: the lich can strengthen the undead army from within it. Calls to destroy him seek to break that alliance before the Scourge can gain further strength.",
    {"https://warcraft.wiki.gg/wiki/Death%27s_Head", "https://warcraft.wiki.gg/wiki/Death%27s_Head_Necromancer", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3341 Bring the End; #3636 Bring the Light"},
    {"Death's Head tribe", "Death's Head"},
    {"dungeon:razorfen-downs", "npc:amnennar", "faction:scourge"},
    "Classic / Forever",
    true)

Curated("faction:stonesplinter",
    "Stonesplinter Tribe",
    "Faction",
    "The Stonesplinter are a trogg tribe threatening Loch Modan and its dwarven defenders. Their growing presence places the countryside under pressure while many of Ironforge's soldiers are away fighting on the Alliance's distant fronts.\n\nThe local mountaineers call for help against Stonesplinter troggs and scouts, then against the skullthumpers and seers in the southern hills. These attacks are intended to buy time for reinforcements. The promised troops fail to arrive, leaving the defenders to continue the struggle with the forces already at hand.",
    {"https://warcraft.wiki.gg/wiki/Stonesplinter", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #224 and #237 In Defense of the King's Lands"},
    {"Stonesplinter tribe", "Stonesplinter"},
    {"region:4c6f6368204d6f64616e", "faction:ironforge"},
    "Classic / Forever",
    true)

Curated("faction:razormane",
    "Razormane Tribe",
    "Faction",
    "The Razormane are quilboar who inhabit Durotar and the Barrens, sheltering their camps among great thorny vines. The orcs found them holding much of Durotar when they arrived and drove many from the land. Fortified Razormane camps remain, making the tribe an enemy of the Horde's efforts to secure its new homeland.\n\nThe conflict also reaches the Crossroads. Razormane raids strike the supply lines coming from Durotar, threatening the settlement's provisions. Horde scouts seek the raiders' leader while defenders call for attacks on their dens northeast of the town.",
    {"https://warcraft.wiki.gg/wiki/Razormane_tribe", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #837 Encroachment; #871 Disrupt the Attacks"},
    {"Razormane tribe", "Razormane"},
    {"region:4475726f746172", "place:crossroads", "faction:bristleback"},
    "Classic / Forever",
    true)

Curated("faction:shadowhide",
    "Shadowhide Clan",
    "Faction",
    "The Shadowhide are a gnoll clan in the eastern Redridge Mountains, serving the mage Morganth. Lieutenant Fangore is a clan leader under his command. Lakeshire treats the gnolls as accomplices of an enemy of Stormwind: its officials demand Shadowhide pendants as proof of punishment, and Magistrate Solomon places a bounty on Fangore.\n\nThose pendants also carry messages between Morganth and his followers. Theocritus of Tower Azora has found a way to send his own voice through them, although the message arrives after a long delay. He hopes further study will let him turn Morganth's communication network against the gnolls.",
    {"https://warcraft.wiki.gg/wiki/Shadowhide_clan", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #91 Solomon's Law; #178 Theocritus' Retrieval; #180 WANTED: Lieutenant Fangore"},
    {"Shadowhide clan", "Shadowhide Gnoll Clan", "Shadowhide"},
    {"place:lakeshire", "region:5265647269646765204d6f756e7461696e73"},
    "Classic / Forever",
    true)

Curated("faction:smolderthorn",
    "Smolderthorn Tribe",
    "Faction",
    "The Smolderthorn are forest trolls of Blackrock Spire, led by War Master Voone and allied with the Dark Horde. Their presence makes the mountain a refuge for troll warriors as well as the orcs and other forces gathered there.\n\nThe tribe also holds the fifth and sixth Tablets of Mosh'aru. Prospector Ironboot seeks these records while studying the earlier tablets, hoping to understand the danger hidden in the prophecy of Hakkar. The Smolderthorn's custody of the final pair draws that investigation into the hostile halls of Blackrock Spire.",
    {"https://warcraft.wiki.gg/wiki/Smolderthorn_tribe", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4788 The Final Tablets"},
    {"Smolderthorn tribe", "Smolderthorn"},
    {"dungeon:blackrock-spire", "npc:voone", "faction:dark-horde"},
    "Classic / Forever",
    true)

Curated("faction:mossflayer",
    "Mossflayer Tribe",
    "Faction",
    "The Mossflayer are forest trolls of the Eastern Plaguelands, with a home at Zul'Mashar and undead members haunting the region. Hameya's desperate plea describes the danger facing his people: after eating tainted meat, he and his companions became infected, and a lich urged him to reach Zul'Mashar and spread the infection. He offered his hidden treasure to anyone who could kill him before he obeyed.\n\nThe tribe also possesses the third and fourth Tablets of Mosh'aru. Prospector Ironboot seeks them because the first pair's account of containing Hakkar is incomplete; the lost tablets may reveal a threat concealed by Yeh'kinya's assurances.",
    {"https://warcraft.wiki.gg/wiki/Mossflayer_tribe", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6024 Hameya's Plea; #5065 The Lost Tablets of Mosh'aru; #8181 Confront Yeh'kinya"},
    {"Mossflayer tribe", "Mossflayer"},
    {"region:4561737465726e20506c616775656c616e6473", "relic:first-mosharu-tablet", "relic:ancient-egg"},
    "Classic / Forever",
    true)

Curated("relic:tablet-ryuneh",
    "Tablet of Ryun'eh",
    "Relic",
    "The Tablet of Ryun'eh is an ancient record hidden in a chest deep within Uldaman. Theldurin the Lost believes it holds knowledge that may avert an approaching doom. He is terrified to name the beings he fears, and describes the chest as older than any dwarven handiwork.\n\nThe tablet is only part of his search. Its information proves insufficient, leading him to seek Yagyin's Digest for further knowledge. Its importance lies in the secrets Theldurin hopes to uncover, while the precise nature of his feared disaster remains unspoken.",
    {"https://classicdb.ch/?quest=709", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #709 Solution to Doom; #727 To Ironforge for Yagyin's Digest"},
    {},
    {"dungeon:uldaman", "relic:tablet-will"},
    "Classic / Forever",
    true)

Curated("relic:ring-zoram",
    "Ring of Zoram",
    "Relic",
    "The Ring of Zoram belonged to the rulers of Zoram before the Sundering drowned their city. It serves as the key to the lock on an ancient statuette sought by Talen. He also reports a wider legend: the ring is said to open any lock in the lost city.\n\nAfter years out of sight, the ring has been found by the naga. Talen directs the search to their leader Ruuzel, who dwells on an island at Zoram's northern edge. Recovering it offers a way to investigate the statuette's hidden secrets and the remains of the drowned settlement.",
    {"https://classicdb.ch/?quest=1009", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1009 Ruuzel"},
    {},
    {"region:417368656e76616c65", "place:zoramgar"},
    "Classic / Forever",
    true)

Curated("relic:first-mosharu-tablet",
    "First Mosh'aru Tablet",
    "Relic",
    "The First Mosh'aru Tablet is held by Theka the Martyr, a long-dead troll in Zul'Farrak. Yeh'kinya seeks it together with the second tablet, held by the hydromancer Velratha. He presents the pair as a prophecy explaining how to contain the essence of Hakkar, and intends to join them for study.\n\nThe first tablet belongs to a larger and more dangerous body of lore than Yeh'kinya admits. Prospector Ironboot's investigation reveals that there are six Tablets of Mosh'aru. Recovering the first pair therefore begins a search whose promise of containment conceals the possibility of Hakkar's return.",
    {"https://classicdb.ch/?quest=3527", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3527 The Prophecy of Mosh'aru; #5065 The Lost Tablets of Mosh'aru; #8181 Confront Yeh'kinya"},
    {},
    {"dungeon:zulfarrak", "relic:ancient-egg", "faction:mossflayer"},
    "Classic / Forever",
    true)

Curated("relic:ancient-egg",
    "Ancient Egg",
    "Relic",
    "The Ancient Egg is a relic hidden in a cave beyond the summit amphitheater of Jintha'Alor in the Hinterlands. Yeh'kinya describes it as a survival of the great troll empires, able to hold Hakkar's essence, and presents its recovery as a way to protect the world.\n\nThe relic then becomes the Egg of Hakkar used in the Sunken Temple. Yeh'kinya's ritual calls forth Hakkar's avatar so that, after its defeat, the egg can receive its essence. The resulting Filled Egg of Hakkar is returned to him for supposed safekeeping.\n\nProspector Ironboot's reading of the lost Mosh'aru tablets exposes the deception: the same egg can give Hakkar a new birth. When confronted, Yeh'kinya admits that his plan has hastened the Soulflayer's return in Zul'Gurub. The egg's power to contain a divine essence is also the means of restoring its owner.",
    {"https://classicdb.ch/?quest=4787", "https://classicdb.ch/?quest=3528", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4787 The Ancient Egg; #3528 The God Hakkar; #8181 Confront Yeh'kinya"},
    {"The Ancient Egg", "Egg of Hakkar", "Filled Egg of Hakkar"},
    {"place:jinthaalor", "dungeon:atalhakkar", "npc:hakkar"},
    "Classic / Forever",
    true)

Curated("relic:heart-mountain",
    "The Heart of the Mountain",
    "Relic",
    "The Heart of the Mountain is a fist-sized gem held in the Dark Iron vaults of Blackrock Depths. Maxwort Uberglint has sought it for years, but the dwarves refuse to sell it. His desire for the stone drives him to seek adventurers willing to take it by force.\n\nThe gem lies in a secret safe protected by the vault's defenses. Opening every relic coffer brings Watchman Doomgrip to confront the intruders; the safe becomes accessible only after his defeat. To Maxwort, the Heart's beauty makes its value immeasurable.",
    {"https://classicdb.ch/?quest=4123", "https://warcraft.wiki.gg/wiki/Secret_Safe", "https://warcraft.wiki.gg/wiki/Watchman_Doomgrip", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4123 The Heart of the Mountain"},
    {"Heart of the Mountain"},
    {"dungeon:blackrock-depths", "faction:dark-iron"},
    "Classic / Forever",
    true)

Curated("relic:star-xilyeh",
    "Star of Xil'yeh",
    "Relic",
    "The Star of Xil'yeh is a gem whose last known owner is the ogre Grel'borg the Miser. Bel'dugur's Note places him among the Ruins of Alterac, searching the debris for more relics. The note reports a whispered power of the Star: its holder may be able to communicate with other worlds.\n\nThe gem is sought alongside the Hand of Dagun and the Legacy Heart. The writer, signing as the Keeper, offers a copy of Yagyin's Digest in exchange for all three. The Star is thus part of a bargain for secret knowledge, with its extraordinary power presented as rumor rather than demonstrated fact.",
    {"https://warcraft.wiki.gg/wiki/Bel%27dugur%27s_Note"},
    {},
    {"region:416c7465726163204d6f756e7461696e73", "relic:tablet-ryuneh"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:theocritus",
    "Theocritus",
    "Person",
    "Theocritus is the human High Mage of Tower Azora in Elwynn Forest. His rival Morganth inhabits the Tower of Ilgalar in Redridge, and Theocritus has devised the Eye of Azora to watch him from afar. Glyphs placed near Ilgalar and Stonewatch Keep extend the investigation into Morganth's thoughts and his unexplained conflict with the local orcs.\n\nTheocritus also studies the enchanted pendants through which Morganth communicates with the Shadowhide gnolls. After months of experimentation, he succeeds in sending his own message through some of them, though it arrives weeks later than he intended. He seeks a pendant for further study, hoping eventually to turn the communication link into a means of immobilizing its wearer. That attack remains an ambition requiring more research.",
    {"https://warcraft.wiki.gg/wiki/Theocritus", "https://classicdb.ch/?quest=94", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #94 A Watchful Eye; #178 Theocritus' Retrieval; #248 Looking Further"},
    {},
    {"region:456c77796e6e20466f72657374", "region:5265647269646765204d6f756e7461696e73", "faction:shadowhide"},
    "Classic / Forever",
    true)

Curated("npc:ansirem-runeweaver",
    "Ansirem Runeweaver",
    "Person",
    "Ansirem Runeweaver is a human archmage of the Kirin Tor found at the ruins of Dalaran in the Alterac Mountains. His learning reaches well beyond the city's reconstruction: he has studied Stranglethorn's relics and written a book about the legends of the Gurubashi Empire. Baron Revilgaz directs an investigation of the Stone of the Tides to him, trusting his knowledge of magical mysteries.\n\nResidue on water elemental bracers gives Ansirem something to analyze. He concludes that the Stone's wielder is strengthening it through an altar and proposes overpowering that focus with an ancient troll dagger. Unfortunately, he gave the relic to his daughter Catelyn, who left for Booty Bay to become a pirate. Recovering the means to break the curse therefore leads from a Dalaran scholar to his wayward daughter's affairs on the coast.",
    {"https://warcraft.wiki.gg/wiki/Ansirem_Runeweaver", "https://classicdb.ch/?quest=602", "https://classicdb.ch/?quest=603", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #602 Magical Analysis; #603 Ansirem's Key"},
    {"Archmage Ansirem Runeweaver", "Ansirem"},
    {"city:dalaran", "faction:kirin-tor", "place:booty-bay"},
    "Classic / Forever",
    true)

Curated("npc:kilrogg-deadeye",
    "Kilrogg Deadeye",
    "Person",
    "Kilrogg Deadeye was the veteran orc chieftain of the Bleeding Hollow clan. He and Cho'gall led an early assault on Stormwind that ended in disaster. Their mutual accusations threatened the Horde's unity and helped create the opening for Gul'dan to establish Blackhand's command.\n\nKilrogg's clan remained a formidable force in the Second War, guarding the Horde's refining operations in occupied Khaz Modan. His history also reaches beyond that defeat: the original account of Draenor's destruction places him beside Grom Hellscream, abandoning Ner'zhul's disastrous scheme and leading survivors back through the Dark Portal. In that account Kilrogg escapes the dying world, but his Bleeding Hollow are eventually taken into Alliance internment camps while Grom's Warsong evade capture.",
    {"https://warcraft.wiki.gg/wiki/Kilrogg_Deadeye (Notes and trivia: original First War account; Retconned and not released content > After the War: original Warcraft III account)", "https://warcraft.wiki.gg/wiki/Bleeding_Hollow_clan (In Warcraft II: Tides of Darkness clan entry, not the Beyond the Dark Portal subsection)"},
    {"Kilrogg"},
    {"faction:bleeding-hollow", "event:second-war", "npc:grom"},
    "Classic / Forever",
    true)

Curated("npc:dathremar-sunstrider",
    "Dath'Remar Sunstrider",
    "Person",
    "Dath'Remar Sunstrider led the Highborne exiles who founded Quel'Thalas and became the ancestors of the high elves. After the War of the Ancients, he challenged the night elves' prohibition of arcane magic, regarding sorcery as his people's birthright. His followers' magical storm over Ashenvale provoked their banishment, which offered them freedom to pursue the arts the druids rejected.\n\nHe led the exiles across the sea in search of a new homeland rich in magical energy. Their eventual kingdom in northern Lordaeron stood on ground sacred to the Amani trolls, making its founding the beginning of a prolonged struggle for possession. Under Dath'Remar, the elves defended their new home with magic. Quel'Thalas established a separate elven civilization, with the Sunstrider dynasty retaining a place alongside the governing Convocation of Silvermoon.",
    {"https://warcraft.wiki.gg/wiki/Dath%27Remar (individual biography: Exile of the Highborne and Founding of Quel'Thalas; only original-history-compatible claims)", "https://warcraft.wiki.gg/wiki/Exile_of_the_High_Elves (narrow era check)", "https://warcraft.wiki.gg/wiki/The_Founding_of_Quel%27Thalas (original in-game text; narrow era check)"},
    {"Dath'Remar", "Dath'remar Sunstrider", "Dath'remar"},
    {"faction:highborne", "group:high-elves", "book:exile-high-elves"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:woodpaw",
    "Woodpaw Clan",
    "Faction",
    "The Woodpaw are gnolls of Feralas whose increasingly savage attacks threaten Camp Mojache. Hadoken Swiftstrider fears that their northward pressure could drive the Horde out of the region. Their raids appear unusually coordinated, prompting him to seek their battle plans as well as call for attacks on their warriors.\n\nThe recovered map suggests that most Woodpaw forces are moving south, with an insect drawing and marks that may record losses. Hadoken reads this as a war on two fronts. Reports of the Zukk'ash in the Writhing Deep, south of the gnoll camps, point to the other enemy and suggest why the Woodpaw have become desperate. The Horde's investigation thus uncovers a threat beyond the gnolls themselves.",
    {"https://warcraft.wiki.gg/wiki/Woodpaw_clan", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2862 War on the Woodpaw; #2902 Woodpaw Investigation; #2903 The Battle Plans; #4135 The Writhing Deep; #7730 Zukk'ash Infestation"},
    {"Woodpaw clan", "Woodpaw"},
    {"place:camp-mojache", "region:466572616c6173", "group:silithid"},
    "Classic / Forever",
    true)

Curated("faction:galak",
    "Galak Tribe",
    "Faction",
    "The Galak are a centaur tribe of Thousand Needles, with settlements at Splithoof Crag and Camp E'thok. Their attacks on caravans and traveling merchants threaten movement through the canyon and bring them into conflict with the nearby Horde settlements.\n\nWithin Splithoof Hold, the tribe guards the Cloven Hoof, a relic said to date from the centaurs' creation. Both numerous defenders and an enduring magical flame protect it. Rau Cliffrunner at Freewind Post seeks the relic for study and prepares a way through its defenses: water from an Ashenvale moonwell can briefly extinguish the flame. The guarded Hoof makes the stronghold a repository of the tribe's past as well as a military refuge.",
    {"https://warcraft.wiki.gg/wiki/Galak", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1195-1197 The Sacred Flame", "https://classicdb.ch/?quest=1197"},
    {"Galak tribe", "Galak"},
    {"region:54686f7573616e64204e6565646c6573", "place:freewind"},
    "Classic / Forever",
    true)

Curated("faction:church-holy-light",
    "Church of the Holy Light",
    "Faction",
    "The Church of the Holy Light is the religious institution serving humanity's faith in the Light. In Stormwind, Archbishop Benedictus leads it from the Cathedral of Light, its spiritual center and a home to priests and paladins. The Order of the Silver Hand links that religious service with armed defense.\n\nIts work extends from teaching to affairs of the kingdom. High Priestess Laurena receives human priests for further instruction at the cathedral, while the Tome of Divinity teaches paladins that compassion and aid to others matter alongside strength in battle. Bishop DeLavey also recruits discreet help through Thomas for a sensitive royal matter. The Church's presence is felt in both the formation of its servants and the needs of the people they are expected to protect.",
    {"https://warcraft.wiki.gg/wiki/Church_of_the_Holy_Light (lead identity and original World of Warcraft section only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5677 Arcane Feedback; #1642 The Tome of Divinity; #1274 The Missing Diplomat", "https://classicdb.ch/?quest=5677", "https://classicdb.ch/?quest=1642", "https://classicdb.ch/?quest=1274"},
    {"Church of Light"},
    {"region:53746f726d77696e642043697479", "faction:silver-hand"},
    "Classic / Forever",
    true)

Curated("event:troll-wars",
    "Troll Wars",
    "Event",
    "The Troll Wars brought the high elves of Quel'Thalas and the humans of Arathor together against the Amani forest trolls. Facing the ruin of their kingdom, the elves sought King Thoradin's military aid and offered to teach selected humans arcane magic. The bargain joined the elves' knowledge to the strength of the united human nation.\n\nThe allied armies defeated the trolls near the Alterac Mountains, with human and elven spellcasters turning the battle through devastating fire. The victory broke the troll offensive and secured Quel'Thalas. It also left a lasting bond: the elves pledged friendship to Arathor and Thoradin's bloodline, while humans carried the newly learned magical arts into their own civilization.",
    {"https://warcraft.wiki.gg/wiki/Troll_Wars (independent event synthesis, original-era core only)", "https://warcraft.wiki.gg/wiki/Arathor_and_the_Troll_Wars (original book checked for era/claim boundaries only; no additional prose budget assigned)"},
    {},
    {"npc:thoradin", "faction:arathi-tribe", "group:high-elves"},
    "Classic / Forever",
    true)

Curated("relic:eye-sargeras",
    "Eye of Sargeras",
    "Artifact",
    "The Eye of Sargeras was an artifact of immense demonic power hidden in the Tomb of Sargeras. Gul'dan sought it but died before reaching his prize. Illidan Stormrage later recovered it with his naga followers, using the memories gained from Gul'dan's skull to find what the warlock had failed to claim. When Maiev confronted him, he turned the Eye's power against the chamber itself, burying her followers beneath the collapsing tomb.\n\nAt ruined Dalaran, Illidan used the Eye to strike at the Lich King's stronghold in distant Northrend. The spell threatened the land itself. Malfurion and Maiev, aided by Kael'thas, interrupted the ritual; the Eye shattered before Illidan could finish. Its destruction ended that attempt to destroy the Frozen Throne.",
    {"https://warcraft.wiki.gg/wiki/The_Tomb_of_Sargeras_%28WC3_NightElf%29 (original transcript)", "https://warcraft.wiki.gg/wiki/The_Ruins_of_Dalaran_%28WC3_Night_Elf%29 (original transcript)", "https://warcraft.wiki.gg/wiki/Eye_of_Sargeras (artifact identity and original campaign synthesis)"},
    {},
    {"npc:illidan", "npc:sargeras", "city:dalaran"},
    "Classic / Forever",
    true)

Curated("relic:phylactery-kelthuzad",
    "The Phylactery of Kel'Thuzad",
    "Artifact",
    "Kel'Thuzad's phylactery is the surviving vessel that makes his defeat in Naxxramas uncertain. While it remains intact, the lich can reform; destroying his body alone does not guarantee his end. The danger makes the object more than a trophy from the necropolis.\n\nThe original quest surrounding the phylactery sets prudence against the promise of a rich reward. It urges its destruction, then directs its bearer to Light's Hope Chapel instead. Father Montoy eagerly offers payment and demands the artifact. That handoff leaves the central question unresolved: the quest shows the phylactery changing hands, but never shows it destroyed.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9120 The Fall of Kel'Thuzad", "https://classicdb.ch/?quest=9120"},
    {"Phylactery of Kel'Thuzad", "Kel'Thuzad's Phylactery"},
    {"npc:kelthuzad", "dungeon:naxxramas", "place:lights-hope"},
    "Classic / Forever",
    true)

Curated("relic:doomsday-candle",
    "Doomsday Candle",
    "Artifact",
    "A Doomsday Candle protects a warlock's Circle of Greater Summoning by turning stored fire upon demons that would interfere with the ritual. It works alongside the Bell of Dethmoora and the Wheel as one of the tools prepared for the summoning of a dreadsteed from Xoroth.\n\nMor'zul Bloodbringer sends the aspiring summoner to gather black dragonscales for Gorzeeki Wildeyes. Their essence is needed to contain the candle's fire safely. Gorzeeki constructs the candle and keeps it until the ritual is ready, making its preparation part of the dangerous work required before the portal can be opened.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7628 Doomsday Candle; #7626 Bell of Dethmoora; #7630 Arcanite; #7631 Dreadsteed of Xoroth", "https://classicdb.ch/?quest=7628"},
    {},
    {"relic:bell-dethmoora"},
    "Classic / Forever",
    true)

Curated("relic:horn-cenarius",
    "Horn of Cenarius",
    "Artifact",
    "The Horn of Cenarius is the demigod's relic whose call awakens the night elf druids. After Cenarius's death in the Third War, Tyrande recovered it from the Primal Guardians on Moonglade Isle. She sounded it to wake Malfurion Stormrage before the advancing undead reached his barrow den.\n\nMalfurion then used the horn to rouse the druids of the talon and restore the druids of the claw, who had lost themselves in their animal forms. Its call brought these defenders back to their people's struggle against the Burning Legion. At Mount Hyjal, he sounded it again as the spirits of the forest gathered for the final attack that destroyed Archimonde.",
    {"https://warcraft.wiki.gg/wiki/The_Awakening_of_Stormrage_%28WC3_NightElf%29 (original transcript)", "https://warcraft.wiki.gg/wiki/The_Druids_Arise_%28WC3_Night_Elf%29 (original mission-complete transcript)", "https://warcraft.wiki.gg/wiki/Brothers_in_Blood (original druid awakening transcript)", "https://warcraft.wiki.gg/wiki/Eternity%27s_End_%28cinematic%29 (final cinematic)", "https://warcraft.wiki.gg/wiki/Horn_of_Cenarius (Third War section, cross-check only)"},
    {},
    {"npc:malfurion", "npc:tyrande", "event:battle-mount-hyjal"},
    "Classic / Forever",
    true)

Curated("relic:bell-dethmoora",
    "Bell of Dethmoora",
    "Artifact",
    "A Bell of Dethmoora is one of three tools used to create a Circle of Greater Summoning. Named for the late warlock Dethmoora Darkeyes, the bell works with the Wheel and the Doomsday Candle to conduct the arcane power required by the ritual. Mor'zul Bloodbringer prepares warlocks to use that circle to open a portal to Xoroth and summon a dreadsteed.\n\nGorzeeki Wildeyes can make the bell, but needs a supply of Elixirs of Shadow Power to do so. Once the materials are delivered, he constructs it and keeps it until the summoner is ready. The name commemorates Dethmoora; the quest reveals no further history of the warlock himself.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7626 Bell of Dethmoora; #7631 Dreadsteed of Xoroth", "https://classicdb.ch/?quest=7626"},
    {},
    {"relic:doomsday-candle"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:tethris-aran",
    "Tethris Aran",
    "Place",
    "Tethris Aran is a cluster of night elf ruins in northern Desolace, just north of Thunder Axe Fortress. The old settlement is abandoned, and wild creatures now roam among its remains.",
    {"https://warcraft.wiki.gg/wiki/Tethris_Aran", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_hr.pdf (2006 Desolace regional index; named location)"},
    {},
    {"region:4465736f6c616365"},
    "Classic / Forever")

Curated("place:sartheris-strand",
    "Sar'theris Strand",
    "Place",
    "Sar'theris Strand runs along Desolace's coast. Sea giants, naga and makrura inhabit its shores and waters, and the wreck of Karnitol's ship lies off its northern reaches. Kreldig Ungor's account tells how sea giants attacked the vessel, forcing the mage to abandon a valuable chest and teleport his servants to safety. The search for that cargo leads toward the Slitherblade naga and the submerged ruins near Ranazjar Isle.\n\nThe coast also draws anglers. Its rare Sar'theris Striker is one of the four fish Nat Pagle requests before sharing his fishing knowledge. The same waters that conceal wreckage and stolen possessions provide a test of patience for his would-be pupils.",
    {"https://warcraft.wiki.gg/wiki/Sar%27theris_Strand", "https://classicdb.ch/?quest=6607", "https://classicdb.ch/?quest=1454", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1454-1456 The Karnitol Shipwreck; #6607 Nat Pagle, Angler Extreme"},
    {},
    {"region:4465736f6c616365", "npc:nat-pagle"},
    "Classic / Forever")

Curated("place:rotting-orchard",
    "The Rotting Orchard",
    "Place",
    "The Rotting Orchard lies southwest of Darkshire in Duskwood, overrun by Nightbane worgen. Shadow Weavers haunt the area, and the larger Dark Runners are numerous enough that Calor fears each loss is quickly replaced.\n\nCalor sends hunters against them as part of Jonathan Carevin's struggle against the evil surrounding Darkshire. Disillusioned with the Night Watch, he has placed his faith in Carevin instead. He does not yet understand why the worgen keep appearing, and his confidence in his master is a hope for an answer, not proof that their cause has been found.",
    {"https://classicdb.ch/?quest=221", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #173; #221-223 Worgen in the Woods"},
    {"Rotting Orchard"},
    {"region:4475736b776f6f64", "place:darkshire", "npc:jonathan-carevin"},
    "Classic / Forever")

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:althea-ebonlocke",
    "Commander Althea Ebonlocke",
    "Person",
    "Commander Althea Ebonlocke leads the Night Watch in Darkshire, defending the people of Duskwood against the undead. Her force is too small to keep the town safe on its own. She asks adventurers to carry the fight to Raven Hill, including the plague spreaders in its eastern mausoleum, because the danger there threatens the people under her protection.\n\nAlthea also handles the attacks of Mor'Ladim, the wandering undead believed to be Morgan Ladimore. He has killed townspeople and some of her strongest Watchers, making him a threat her patrols cannot contain. After his defeat, she reveals the personal cost behind the pursuit: Morgan's daughter Sarah survived and now serves in the Watch. Althea directs the bearer of the news to Sarah, whose father's fate remains a source of grief.",
    {"https://classicdb.ch/?quest=58", "https://classicdb.ch/?quest=227", "https://classicdb.ch/?quest=229", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #58 The Night Watch; #227 Morgan Ladimore; #228 Mor'Ladim; #229 The Daughter Who Lived"},
    {"Althea Ebonlocke", "Commander Ebonlocke"},
    {"place:darkshire", "region:4475736b776f6f64", "npc:morladim"},
    "Classic / Forever",
    true)

Curated("npc:verna-furlbrow",
    "Verna Furlbrow",
    "Person",
    "Verna Furlbrow is a Westfall farmer forced to leave her home as thieves overrun the fields. Her departure has stalled with the family's broken wagon, which Farmer Furlbrow is trying to repair. Even while preparing to leave, she remembers her neighbor Salma Saldean and sends her a copy of her Westfall stew recipe. Salma will miss Verna, though she thinks life in Stormwind will suit her.\n\nVerna's immediate worry is Old Blanchy, the tired horse that has already worked hard for the household. She fed Blanchy before leaving the farm, but the unexpected delay has left the animal in need of food. Verna asks for oats gathered from Westfall's fields, warning that dangerous machines now occupy the farms. Caring for the horse and passing on a familiar recipe give her departure a human scale amid the region's wider troubles.",
    {"https://classicdb.ch/?quest=36", "https://classicdb.ch/?quest=151", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #36 Westfall Stew; #151 Poor Old Blanchy"},
    {},
    {"region:5765737466616c6c", "place:saldeans-farm"},
    "Classic / Forever",
    true)

Curated("npc:sven-yorgen",
    "Sven Yorgen",
    "Person",
    "Sven Yorgen is a Duskwood farmer pursuing the Dark Riders who slaughtered his family while he was away. Returning to his farm, he saw a shadowy figure bury something near the barn, but the stranger fled and Sven continued after the riders. He asks for the hiding place behind an old stump to be searched, hoping it holds an explanation.\n\nThe buried book begins an investigation that leads to Jitters, a witness to the tragedy. Jitters supplies his completed journal rather than face Sven's anger himself. After reading it, Sven connects the account with something he has personally seen: the Dark Riders speaking with Morbent Fel at Forlorn Rowe.\n\nSven's pursuit then turns against the wizard overlooking Raven Hill cemetery. He calls for Morbent's protective magic to be broken with Morbent's Bane before he is slain. The quest's conclusion grants Sven only partial satisfaction. Morbent is defeated, but the Dark Riders remain at large and his revenge is unfinished.",
    {"https://classicdb.ch/?quest=95", "https://classicdb.ch/?quest=268", "https://classicdb.ch/?quest=55", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #95 Sven's Revenge; #230 Sven's Camp; #268 Return to Sven; #55 Morbent Fel"},
    {},
    {"npc:jitters", "region:4475736b776f6f64", "place:raven-hill"},
    "Classic / Forever",
    true)

Curated("npc:khan-dezhepah",
    "Khan Dez'hepah",
    "Person",
    "Khan Dez'hepah leads the Kolkar centaurs in Desolace. His clan is one of several fighting for power across the dry plains, and that division shapes the Horde's response. Felgur Twocuts fears that the centaurs would become a much more dangerous enemy if their clans united.\n\nFelgur therefore orders Dez'hepah's death as the first blow against Kolkar leadership and demands his head as proof. The attack is meant both to disrupt the Kolkar and to make the other clans hesitate. Dez'hepah's importance in this campaign lies in his authority over his own people: striking their khan is intended to weaken one clan before a wider centaur alliance can form.",
    {"https://classicdb.ch/?quest=1365", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1365 Khan Dez'hepah"},
    {"Dez'hepah"},
    {"faction:kolkar", "region:4465736f6c616365"},
    "Classic / Forever",
    true)

Curated("npc:morladim",
    "Mor'Ladim",
    "Person",
    "Mor'Ladim is the restless undead Morgan Ladimore, wandering the cemetery of Duskwood and attacking its people. Commander Althea Ebonlocke has lost even strong Watchers to him and seeks help ending his violence.\n\nThe Story of Morgan Ladimore records the tragedy behind him. Morgan had been a knight devoted to protecting others. He left his wife Lys and their children to fight beside Uther in Lordaeron, surviving the war's horrors by hoping to see them again. He returned to a ruined home and eventually found his wife's grave. Overwhelmed by grief, he killed three cemetery attendants who tried to restrain him. When he understood what he had done, he took his own life. His guilt and anguish denied him rest, and he rose as Mor'Ladim, consumed by hatred.\n\nMorgan's belief that he had lost his entire family was mistaken. His daughter Sarah survived and became a Watcher. After Mor'Ladim's defeat, she asks for her ring to be placed on his grave so that he might know she lives and forgives him. In the quest's final encounter, Morgan's spirit recognizes her token, lays down his burden and gives up his sword Archeus as his soul finds peace.",
    {"https://wowpedia.fandom.com/wiki/Morgan_Ladimore (The Story of Morgan Ladimore: explicitly identified original tome transcription)", "https://classicdb.ch/?quest=227", "https://classicdb.ch/?quest=229", "https://classicdb.ch/?quest=231", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #227 Morgan Ladimore; #228 Mor'Ladim; #229 The Daughter Who Lived; #231 A Daughter's Love"},
    {"Morgan Ladimore", "Mor'ladim"},
    {"npc:althea-ebonlocke", "place:raven-hill", "region:4475736b776f6f64"},
    "Classic / Forever",
    true)

Curated("faction:theramore-guard",
    "Theramore Guard",
    "Faction",
    "The Theramore Guard defends Jaina Proudmoore's settlement and its positions in Dustwallow Marsh. Its ranks include recruits who crossed the sea with her, while Adjutant Tesoran maintains records of the soldiers and their equipment. Captain Garran Vimes relies on those records when an investigation turns up the name of Lieutenant Paval Reethe.\n\nTesoran's books identify Reethe as a former Kul Tiras marine who joined the guard and is now listed as missing. Vimes suspects desertion by a man still loyal to Admiral Daelin. That suspicion leads to deserters occupying an abandoned watchtower at Lost Point. Their leader says they expelled Reethe for repeatedly raiding the Brackenwall ogres' supplies, leaving Vimes to order a further search. The inquiry exposes divisions within Theramore's forces without settling Reethe's fate.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1259 Lieutenant Paval Reethe; #1285 Daelin's Men; #1286 and #1287 The Deserters", "https://classicdb.ch/?quest=1259", "https://classicdb.ch/?quest=1285"},
    {"The Theramore Guard"},
    {"place:theramore", "region:4475737477616c6c6f77204d61727368"},
    "Classic / Forever",
    true)

Curated("group:gorishi-hive",
    "Gorishi Hive",
    "Faction",
    "The Gorishi are the insects whose hive network occupies southern Un'Goro Crater. Their breeding chambers hold hanging larvae, making the hive a place where the creatures' growth can be studied as well as a danger to explorers.\n\nHol'anyee Marshal's expedition had been investigating them before a setback interrupted its work. She considers their presence alien to Un'Goro's ecology and wants to discover why. Her request for a scraping from a hatchery wall turns the hive itself into evidence: the sample is meant to advance research, while the reason for the Gorishi's ecological intrusion remains an open question.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3883 Alien Ecology", "https://classicdb.ch/?quest=3883"},
    {"The Gorishi Hive", "Gorishi"},
    {"place:slithering-scar", "region:556e27476f726f20437261746572"},
    "Classic / Forever",
    true)

Curated("faction:wildmane",
    "Wildmane Clan",
    "Faction",
    "The Wildmane are a tauren clan whose name is borne by a water well north of Thunder Bluff. That well becomes the last focus of Mull Thunderhorn's effort to cleanse Mulgore's poisoned water, after the Winterhoof and Thunderhorn wells.\n\nMull calls for teeth from prairie wolf alphas to prepare the Wildmane Totem. He treats the offering as a sacrifice drawn from the land, then sends the bearer to perform the cleansing ritual at the well. The Wildmane name is thus preserved in a local place bound to the health of Mulgore and Bloodhoof Village.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #759 Wildmane Totem; #760 Wildmane Cleansing", "https://classicdb.ch/?quest=759", "https://classicdb.ch/?quest=760", "https://warcraft.wiki.gg/wiki/Wildmane_clan"},
    {"Wildmane Tribe", "Wildmane clan"},
    {"region:4d756c676f7265"},
    "Classic / Forever",
    true)

Curated("group:freethinkers-zandalar",
    "Freethinkers of Zandalar",
    "Faction",
    "The freethinkers have a place within Zandalar tradition despite beliefs the tribe regards as heathen. Jin'rokh the Breaker describes them as people who resist oppression and would give their lives for their convictions. His recognition rests on that steadfastness, rather than on agreement in faith.\n\nHe traces the tradition to ancient Zandalar who challenged Hakkar's priest during the Gurubashi Empire's strength. Branded heretics, hunted and killed, they continued resisting the blood god. The Zandalari honor the sacrifice of those dissenters.\n\nOn Yojamba Isle, he extends this acknowledgement to paladins aiding the struggle against Hakkar. He sends them into Zul'Gurub for the Paragons of Power and offers the freethinker's armguards as their first battle gear. The exchange gives an outsider a path to honor among the Zandalari through service against the blood god's followers.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8053 Paragons of Power: The Freethinker's Armguards", "https://classicdb.ch/?quest=8053", "https://warcraft.wiki.gg/wiki/Zandalar_Freethinker%27s_Armguards (original item and paladin class restriction)", "https://classicdb.ch/?quest=8054", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8054 Paragons of Power: The Freethinker's Belt"},
    {"Zandalar Freethinkers", "The Freethinkers of Zandalar"},
    {"faction:zandalar", "dungeon:zulgurub"},
    "Classic / Forever",
    true)

Curated("group:barov-family",
    "The Barov Family",
    "Faction",
    "House Barov was a wealthy noble family whose residence on Caer Darrow became Scholomance. Eva Sarkhoff, once its head maid, remembers a splendid household overtaken by the family's greed and fear. Its former home now holds the deeds on which the surviving heirs base their claims to the family fortune.\n\nAlexi Barov and his brother Weldon each seek the deeds to Caer Darrow, Brill, Tarren Mill and Southshore before the other can claim them. Alexi is undead; Weldon remained human after fleeing the war. Each promises riches for recovering the documents and regards the other as an enemy. The family inheritance survives its ruined household as a bitter contest between two brothers on opposite sides of undeath.",
    {"Original Eva Sarkhoff introductory gossip: https://wowwiki-archive.fandom.com/wiki/Quest%3ADoctor_Theolen_Krastinov%2C_the_Butcher (Notes / Conversation)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5341 and #5343 Barov Family Fortune", "https://classicdb.ch/?quest=5341", "https://classicdb.ch/?quest=5343"},
    {"Barov Family", "House Barov"},
    {"dungeon:scholomance", "npc:alexi-barov", "npc:weldon-barov"},
    "Classic / Forever",
    true)

Curated("relic:moss-twined-heart",
    "The Moss-twined Heart",
    "Relic",
    "The Moss-twined Heart is the heart of Blackmoss the Fetid, a timberling. A coating of dark, oily moss almost conceals what it is, yet the organ continues a slow beat after being taken from the creature.\n\nIts strange condition suggests bringing it to Denalan at Lake Al'Ameth. When he receives it, he recognizes a timberling heart and agrees to examine the foul growth in the hope of learning its nature. The discovery begins with the heart itself; Denalan's investigation follows its delivery.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #927 The Moss-twined Heart", "https://classicdb.ch/?quest=927"},
    {"Moss-twined Heart"},
    {"region:54656c6472617373696c"},
    "Classic / Forever",
    true)

Curated("relic:spectral-chalice",
    "The Spectral Chalice",
    "Relic",
    "The Spectral Chalice is a hovering offering vessel associated with Gloom'rel in Blackrock Depths' Summoners' Tomb. The dwarven ghost offers to consider teaching the old craft of dark iron smelting to a miner willing to appease him.\n\nThe chalice receives two star rubies, twenty gold bars and ten truesilver bars. Its slow movement suggests a failing heartbeat, and the gems vanish into its depths without a sound. After this tribute, the petitioner returns to Gloom'rel, who grants the knowledge and warns against letting it become a source of corruption. The vessel accepts the sacrifice; the ghost supplies the teaching.",
    {"Original quest #4083 progress/completion and materials: https://www.wowhead.com/classic/quest%3D4083/the-spectral-chalice", "Original Gloom'rel mining gossip: https://warcraft.wiki.gg/wiki/Gloom%27rel"},
    {"Spectral Chalice"},
    {"npc:gloomrel", "dungeon:blackrock-depths"},
    "Classic / Forever",
    true)

Curated("book:wrath-soulflayer",
    "Wrath of Soulflayer (book)",
    "Book",
    "Wrath of Soulflayer is a History of Warcraft book about the Gurubashi civil war. It traces their bargain with Hakkar from famine and promised power to escalating sacrifices and rebellion.\n\nThe account tells of the destruction of Hakkar's avatar and his banishment. His Atal'ai priests are expelled from Zul'Gurub and build a temple in the northern swamps. The victorious tribes separate, leaving a fractured empire and a prophecy of the blood god's return. The book preserves this warning through the story of a people turning against the power they sought.",
    {"Original readable History of Warcraft book, object #175856: https://warcraft.wiki.gg/wiki/Wrath_of_Soulflayer"},
    {"Wrath of Soulflayer"},
    {"faction:gurubashi-empire", "npc:hakkar", "dungeon:atalhakkar"},
    "Classic / Forever",
    true)

Curated("book:mangled-journal",
    "A Mangled Journal",
    "Book",
    "A Mangled Journal is Williden Marshal's damaged account of an expedition into Un'Goro Crater. Enough remains legible to identify its owner and describe the party's retreat: savage beasts overran their base camps, forcing Williden and his companions to seek higher ground in the north.\n\nThose surviving passages provide a way to find the writer as well as a record of the expedition's danger. Williden recognizes the journal when it is returned and admits he had thought it lost with almost everything else the party brought into Un'Goro. Its significance lies in the small part of that broken expedition it preserves.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3884 Williden's Journal", "https://classicdb.ch/?quest=3884"},
    {"Mangled Journal", "Williden's Journal"},
    {"npc:williden", "region:556e27476f726f20437261746572"},
    "Classic / Forever",
    true)

Curated("relic:awbees-scale",
    "Awbee's Scale",
    "Relic",
    "Awbee's Scale carries a blue whelp's testimony from Blackrock Spire to the blue dragonflight. The injured Awbee describes being abducted with other whelps for experiments intended to create the chromatic flight. Those Nefarian found unsuitable were left to his followers' cruelty.\n\nAwbee gives a scale to be taken to Mazthoril in Winterspring. Holding it while standing on one of the cave's cobalt runes transports the bearer to Haleh, the flight's matron protectorate. She can use the scale to scry what Awbee has seen and felt. It therefore serves both as a means of reaching her and as a witness to the suffering inside the mountain.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5160 The Matron Protectorate", "https://classicdb.ch/?quest=5160", "Original Awbee gossip: https://warcraft.wiki.gg/wiki/Awbee (Quotes / Gossip, before the Added in Cataclysm subsection)"},
    {"Awbee’s Scale"},
    {"npc:haleh", "dungeon:upper-blackrock-spire"},
    "Classic / Forever",
    true)

Curated("relic:scarab-gong",
    "Scarab Gong",
    "Relic",
    "The Scarab Gong stands on the Scarab Dais in southern Silithus, before the sealed gates of Ahn'Qiraj. The restored Scepter of the Shifting Sands is needed to ring it. Anachronos instructs the scepter's bearer to await the arrival of the Horde and Alliance armies before doing so.\n\nIts sounding opens the gates and releases the dangers the gathered forces have come to confront. The opening is accompanied by qiraji crystals breaking through Kalimdor's earth and great obsidian creatures emerging. The gong marks the passage from preparation into battle: a way through the barrier also allows the enemy to come out.",
    {"https://classicdb.ch/?quest=8743 (Bang a Gong! original description and required scepter)", "Original #8742 The Might of Kalimdor gossip: https://wowwiki-archive.fandom.com/wiki/Quest%3AThe_Might_of_Kalimdor", "Original opening-event emotes: https://warcraft.wiki.gg/wiki/Bang_a_Gong%21 (Notes)", "https://warcraft.wiki.gg/wiki/The_Scarab_Gong (original location and patch1.9 object)"},
    {"The Scarab Gong"},
    {"relic:scepter-shifting-sands", "region:53696c6974687573", "faction:qiraji"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:dragonmaw-gates",
    "Dragonmaw Gates",
    "Place",
    "The Dragonmaw Gates stand across the winding approach to Grim Batol in the Wetlands. Red dragonkin guard the road, with the drake Axtroz among its formidable defenders. Beyond the final gate, the approach beneath the mountain lies deserted.\n\nAxtroz's presence draws the attention of the black dragon Emberstrife. His trials demand the skull of this red-flight champion as proof of service to Deathwing, bringing the rival dragonflights' conflict to the guarded road.",
    {"https://classic-wow-archive.fandom.com/wiki/Dragonmaw_Gates", "https://classicdb.ch/?quest=6585"},
    {"Dragonmaw Gate"},
    {"place:grim-batol", "faction:red-dragonflight", "region:5765746c616e6473"},
    "Classic / Forever")

Curated("place:lake-eluneara",
    "Lake Elune'ara",
    "Place",
    "Lake Elune'ara lies at the heart of Moonglade. Young druids enter its depths during the Trial of the Lake, searching for a shrine bauble that must reach the Shrine of Remulos before it decays. The task tests their composure in the water as well as their speed. Tajarri, the shrine's warden, explains that the offering honors Remulos and the Cenarion Circle's care for nature and balance.\n\nBeneath the lake sleeps Omen, an ancient defender corrupted by demonic magic. The Lunar Festival rouses him again. Elune's blessing prevents his death, so those who face him seek to calm his rage for another year. A place of druidic learning is also the resting place of a wound that has never fully healed.",
    {"https://classicdb.ch/?quest=28", "https://classicdb.ch/?quest=29", "https://classicdb.ch/?quest=8868", "https://warcraft.wiki.gg/wiki/Lake_Elune%27ara"},
    {"Lake Elune'Ara"},
    {"region:4d6f6f6e676c616465", "npc:remulos", "faction:cenarion-circle"},
    "Classic / Forever",
    true)

Curated("place:tyrs-hand",
    "Tyr's Hand",
    "Place",
    "Tyr's Hand is a fortified Scarlet Crusade town in the southeastern Eastern Plaguelands. Its human defenders remain part of a wider military command: couriers carry reports from Stratholme to Crusader Lord Valdelmar here. Nathanos Blightcaller seeks to exploit that connection, using intercepted orders and a human disguise to draw the Scarlet Oracle, Demetria, into the open.\n\nThe stronghold's praetorians carry swords associated with the Crusade's zealotry. Bodley seeks one as a focus for summoning his dead companions Jarien and Sothos, siblings who had aspired to Scarlet knighthood. That ritual belongs in Stratholme's Scarlet Bastion, but its preparation leads back to Tyr's Hand and the ideals that once drew the pair to the Crusade.",
    {"https://classicdb.ch/?quest=6145", "https://classicdb.ch/?quest=6146", "https://classicdb.ch/?quest=6148", "https://classicdb.ch/?quest=8964", "https://warcraft.wiki.gg/wiki/Tyr%27s_Hand"},
    {},
    {"group:scarlet-crusade", "npc:nathanos", "region:4561737465726e20506c616775656c616e6473"},
    "Classic / Forever")

Curated("place:bael-modan",
    "Bael Modan",
    "Place",
    "Bael Modan is a dwarven excavation and fortified base in the southern Barrens. Blasting and digging machines have torn into land that Gann Stonespire remembers as his people's home. He says many tauren were killed or driven away, and that attempts at a peaceful settlement failed. His demand for Prospector Khazgorm's journal begins an effort to force the dwarves out.\n\nGann regards the keep as more than a guard post for the dig: its growing military strength threatens the surrounding land. He turns the dwarves' own explosive supplies against their flying machine, which serves the excavation and can also be used for war. To him, destroying it would answer both a practical danger and an insult to his lost tribe.",
    {"https://classicdb.ch/?quest=843", "https://classicdb.ch/?quest=846", "https://classicdb.ch/?quest=849", "https://warcraft.wiki.gg/wiki/Bael_Modan"},
    {},
    {"region:5468652042617272656e73"},
    "Classic / Forever")

Curated("place:stonewrought-dam",
    "Stonewrought Dam",
    "Place",
    "The Stonewrought Dam is a vast dwarven landmark in Loch Modan. Its scale and the roar of its waterfall make it a wonder that Stormwind's orphans dream of seeing during Children's Week.\n\nSuch a conspicuous achievement also attracts enemies. Dark Iron insurgents plant Seaforium at its base, exploiting an explosive that becomes dangerous when wet. Hinderweir calls for a disarming mixture before the charge can destroy the dam. The work ends with the keg defused and the landmark safe, although his relief comes with the warning that its enemies may try again.",
    {"https://classicdb.ch/?quest=1558", "https://classicdb.ch/?quest=274", "https://classicdb.ch/?quest=278", "https://classicdb.ch/?quest=280", "https://classicdb.ch/?quest=283"},
    {"The Stonewrought Dam"},
    {"region:4c6f6368204d6f64616e", "faction:dark-iron"},
    "Classic / Forever")

Curated("npc:malyfous-darkhammer",
    "Malyfous Darkhammer",
    "Person",
    "Malyfous Darkhammer is a Dark Iron craftsman of the Thorium Brotherhood in Everlook, Winterspring. Finkle Einhorn sends him a glowing sample from the Beast's innards to learn what its remains might yield. Malyfous's interest lies in turning rare materials into exceptional armor.\n\nHis catalogue offers three commissions: the Cap of the Scarlet Savant, Leggings of Arcana and Breastplate of Bloodthirst. Each requires a Pristine Hide of the Beast, other difficult ingredients and payment. The catalogue begins these commissions, while Malyfous receives the materials and delivers the finished work. His recipes connect Everlook's workshops with the dangerous creatures of Blackrock Spire, Scholomance and Stratholme.",
    {"https://classicdb.ch/?npc=10637", "https://classicdb.ch/?quest=5047", "https://classicdb.ch/?quest=5063", "https://classicdb.ch/?quest=5067", "https://classicdb.ch/?quest=5068", "https://warcraft.wiki.gg/wiki/Malyfous_Darkhammer", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5047"},
    {},
    {"place:everlook", "faction:thorium-brotherhood", "npc:finkle-einhorn"},
    "Classic / Forever",
    true)

Curated("npc:nixx-sprocketspring",
    "Nixx Sprocketspring",
    "Person",
    "Nixx Sprocketspring teaches goblin engineering in Gadgetzan, Tanaris. His discipline favors powerful explosives, weaponry and profitable practical inventions. He has little patience for gnomish claims of superiority, insisting that his own craft demands both intelligence and a steady hand.\n\nTraining under Nixx begins with a pledge to keep the discipline's schematics secret. He then examines an engineer's workmanship through samples of bombs, dynamite and explosive sheep before issuing a Goblin Engineer Membership Card. The card grants access to further training and must be renewed when its dues expire. Nixx therefore guards the trade's secrets as well as teaching its destructive techniques.",
    {"https://classicdb.ch/?npc=8126", "https://classicdb.ch/?quest=3633", "https://classicdb.ch/?quest=3638", "https://classicdb.ch/?quest=3639", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3633; #3638; #3639"},
    {},
    {"place:gadgetzan"},
    "Classic / Forever",
    true)

Curated("npc:nessa-shadowsong",
    "Nessa Shadowsong",
    "Person",
    "Nessa Shadowsong is a fishing merchant in Rut'theran Village, the port beneath Teldrassil. Mydrannul directs willing couriers to her because she needs a parcel carried to Darkshore. Her delivery serves a question about the island's unusual abundance: the fish caught near Rut'theran are exceptionally large, and she wants to compare them with those of the mainland.\n\nNessa gathers bones and scales for Laird, a fellow fish merchant in Auberdine, and sends the collection through the village's hippogryph master, Vesprystus. Laird finds a striking difference and suspects the World Tree may influence the surrounding wildlife. Nessa receives his response with interest and intends to discuss it with the villagers, though the cause remains uncertain.",
    {"https://classicdb.ch/?quest=6344", "https://classicdb.ch/?quest=6341", "https://classicdb.ch/?quest=6343", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6344; #6341; #6342; #6343"},
    {},
    {"place:ruttheran", "place:auberdine"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:bluegill",
    "Bluegill Murlocs",
    "Faction",
    "The Bluegill are murlocs dwelling along the Wetlands coast north of Menethil Harbor. Their settlements bring them into conflict with the harbor's fishing and merchant traffic.\n\nKarl Boran describes murlocs emerging from the water to build coastal villages. Among the Bluegill, Gobbler raids merchants along the road before withdrawing to the nearby hovels. Boran offers payment through the Merchant Marines for killing Gobbler and reducing the murlocs around him, treating the coastal settlements as a threat to the harbor's trade.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #279 Claws from the Deep", "https://classicdb.ch/?quest=279"},
    {"Bluegill murlocs", "Bluegill tribe"},
    {"region:5765746c616e6473", "place:menethil"},
    "Classic / Forever",
    true)

Curated("faction:firegut",
    "Firegut Ogres",
    "Faction",
    "The Firegut ogres are allies of the Blackrock orcs in the Burning Steppes. They guard mineral-rich Dreadmaul Rock and keep the orcs' supply routes open, making their stronghold part of the Blackrock war effort.\n\nOralius calls for attacks on their ogres, brutes and ogre-mages. He next targets their brute lord, Gor'tesh, who rules from a Blackrock orc building west of the rock. The campaign against the Firegut therefore reaches from their guarded resources to a leader sheltered among their allies.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3823 Extinguish the Firegut; #3824 Gor'tesh the Brute Lord", "https://classicdb.ch/?quest=3823", "https://classicdb.ch/?quest=3824"},
    {"Firegut ogres", "Firegut"},
    {"faction:blackrock-clan", "region:4275726e696e672053746570706573"},
    "Classic / Forever",
    true)

Curated("faction:mosshide",
    "Mosshide Gnolls",
    "Faction",
    "The Mosshide gnolls inhabit the Wetlands, including the country near Algaz Gate. Rethiel the Greenwarden remembers years in which they lived peacefully there, but says their growing numbers have disturbed the balance of the fen. He blames their trampling for damaged vegetation and their woodcutting for consuming too many trees.\n\nRethiel calls for their numbers to be reduced, then asks that their fire-making flints be taken away. He intends to destroy those tools to prevent further burning of living wood. His campaign against the Mosshide grows from his defense of the Wetlands' plant life.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #276 Tramping Paws; #277 Fire Taboo", "https://classicdb.ch/?quest=276", "https://classicdb.ch/?quest=277"},
    {"Mosshide gnolls", "Mosshide tribe"},
    {"region:5765746c616e6473"},
    "Classic / Forever",
    true)

Curated("faction:dreadmaul",
    "Dreadmaul Ogres",
    "Faction",
    "The Dreadmaul ogres occupy Dreadmaul Hold and Dreadmaul Post in the Blasted Lands. Their leader, Grol the Destroyer, serves the demon Razelikh the Defiler, placing the tribe within the demonic power that dominates the ruined country.\n\nThe Fallen Hero of the Horde names Grol alongside Sevine and Allistarj as the three obstacles to reaching Razelikh. Each holds a piece of the Defiler's amulet. Recovering those pieces is meant to break that chain of command and open the way to its master, making the ogre leader part of a larger struggle against the land's overlord.",
    {"https://warcraft.wiki.gg/wiki/Dreadmaul (original World of Warcraft section)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3627 Uniting the Shattered Amulet", "https://classicdb.ch/?quest=3627"},
    {"Dreadmaul ogres", "Dreadmaul tribe"},
    {"region:426c6173746564204c616e6473"},
    "Classic / Forever",
    true)

Curated("faction:tunnel-rat",
    "Tunnel Rat Kobolds",
    "Faction",
    "The Tunnel Rat kobolds make their dens in the foothills west of Thelsamar in Loch Modan. Their settlements extend along the mountainside close enough to the dwarven town to provoke a campaign against them.\n\nMountaineer Kadrell describes their arrival as an infestation and accuses them of fouling the land. He offers a bounty for their ears, turning his demand that the kobolds be driven out into paid work for passing hunters.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #416 Rat Catching", "https://classicdb.ch/?quest=416"},
    {"Tunnel Rat kobolds"},
    {"place:thelsamar"},
    "Classic / Forever",
    true)

Curated("faction:redridge-gnolls",
    "Redridge Gnolls",
    "Faction",
    "The Redridge gnolls trouble the hills behind Lakeshire in the Redridge Mountains. A band of them intercepts the town's replacement building supplies, tying their raids directly to the stalled reconstruction of the Everstill Bridge.\n\nForeman Oslow explains that the last orc invasion forced Lakeshire to turn its iron into weapons and armor. A new shipment from Stormwind should have replenished the stock, but the gnolls seized the caravan and retreated into the hills. Oslow seeks the stolen pikes and rivets so that the bridge work can continue.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #89 The Everstill Bridge", "https://classicdb.ch/?quest=89"},
    {"Redridge gnolls"},
    {"place:lakeshire", "region:5265647269646765204d6f756e7461696e73"},
    "Classic / Forever",
    true)

Curated("relic:ancient-petrified-leaf",
    "The Ancient Leaf",
    "Relic",
    "The Ancient Petrified Leaf is a bright green leaf whose deeply wrinkled, veined surface hints at an ancient and powerful owner. Finding that owner is the mystery carried by the leaf itself.\n\nVartrus the Ancient recognizes it as one of his own leaves and welcomes its return. He offers the prospect of mutual aid, then introduces the surviving spirits of the Ancients and their tasks. The leaf opens a hunter's path toward the weapons of the Ancient Keepers; it is an introduction to those guardians and their trials.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7632 The Ancient Leaf (7633 read online, not in local corpus)", "https://classicdb.ch/?quest=7632", "https://classicdb.ch/?quest=7633", "https://www.wowhead.com/classic/item=18703/ancient-petrified-leaf (original item tooltip; Hunter restriction)"},
    {"Ancient Petrified Leaf"},
    {"relic:rhokdelar"},
    "Classic / Forever",
    true)

Curated("book:scourge-lordaeron",
    "The Scourge of Lordaeron (book)",
    "Book",
    "The Scourge of Lordaeron is a readable book in the fifth chapter of History of Warcraft. It concerns Arthas's struggle against the plague spread by Kel'Thuzad and his Cult of the Damned during the Third War.\n\nCopies can be read in the Scarlet Monastery Library and Scholomance. Within the historical sequence it follows The Alliance Splinters and precedes Sunwell - The Fall of Quel'Thalas, placing Lordaeron's disaster before the account of the elven kingdom's fall.",
    {"https://warcraft.wiki.gg/wiki/The_Scourge_of_Lordaeron_%28History_of_Warcraft%29 (book metadata, Found at and Timeline; narrative not newly summarized)", "https://warcraft.wiki.gg/wiki/The_Cult_of_the_Damned_%28WC3_Human%29 (original mission objective and dialogue)"},
    {"The Scourge of Lordaeron (History of Warcraft book)"},
    {"npc:arthas", "faction:scourge", "dungeon:scholomance"},
    "Classic / Forever",
    true)

Curated("book:founding-quelthalas",
    "The Founding of Quel'Thalas (book)",
    "Book",
    "The Founding of Quel'Thalas is a readable History of Warcraft book concerning the beginnings of the high elven kingdom. It follows Dath'Remar's exiles as they establish an eastern homeland where they can continue practicing arcane magic. The book belongs to the second chapter of the history, long before the wars between orcs and humans.\n\nCopies are found in the Scarlet Raven Tavern in Duskwood and the Viewing Room of Scholomance. The account follows The Sentinels and the Long Vigil and leads into Arathor and the Troll Wars, locating the kingdom's foundation within the older history of elves, humans and trolls.",
    {"https://warcraft.wiki.gg/wiki/The_Founding_of_Quel%27Thalas (book metadata, original locations and Timeline)", "https://warcraft.wiki.gg/wiki/The_Warcraft_Encyclopedia/High_Elves (preserved Blizzard article; pre-First War history only)"},
    {"The Founding of Quel'Thalas (History of Warcraft book)"},
    {"npc:dathremar-sunstrider", "dungeon:scholomance"},
    "Classic / Forever",
    true)

Curated("book:new-horde",
    "The New Horde (book)",
    "Book",
    "The New Horde is a readable History of Warcraft book in the fourth chapter of the series, concerning Thrall and the renewal of the orcish Horde. Its central figure rises from human slavery to seek a Horde guided by shamans and free from demonic influence. Copies can be read in Stormwind's royal library and at Stonard.\n\nIt follows Lethargy of the Orcs and precedes War of the Spider in the historical sequence. The book looks back on the Horde's earlier transformation, before the events of the Third War.",
    {"https://warcraft.wiki.gg/wiki/The_New_Horde (book metadata and Timeline)", "https://classicdb.ch/?object=175752 (original object location metadata)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3090 Tainted Parchment; #787 The New Horde (quest)", "https://classicdb.ch/?quest=3090", "https://classicdb.ch/?quest=787"},
    {"The New Horde (History of Warcraft book)"},
    {"npc:thrall", "event:internment-liberation", "place:stonard"},
    "Classic / Forever",
    true)

Curated("book:sunwell-fall-quelthalas",
    "Sunwell - The Fall of Quel'Thalas (book)",
    "Book",
    "Sunwell - The Fall of Quel'Thalas is a readable History of Warcraft book about the Scourge's invasion of the high elven kingdom during the Third War. Arthas seeks the sacred well to restore Kel'Thuzad, turning the elves' source of magic toward the Scourge's purpose. It forms part of the fifth chapter of the history.\n\nCopies are found in Astranaar and Booty Bay's Salty Sailor Tavern. The book follows The Scourge of Lordaeron and precedes Archimonde's Return and the Flight to Kalimdor, continuing the history from Lordaeron into the disaster that befell Quel'Thalas.",
    {"https://classicdb.ch/?object=175757 (original object location metadata)", "https://warcraft.wiki.gg/wiki/Sunwell_-_The_Fall_of_Quel%27Thalas (book metadata and Timeline)", "https://warcraft.wiki.gg/wiki/The_Fall_of_Silvermoon (original Warcraft III mission The Sunwell objective and opening dialogue)"},
    {"Sunwell - The Fall of Quel'Thalas (History of Warcraft book)", "Sunwell - The Fall of Quel'Thalas"},
    {"event:fall-quelthalas", "place:sunwell"},
    "Classic / Forever",
    true)

Curated("book:civil-war-plaguelands",
    "Civil War in the Plaguelands (book)",
    "Book",
    "Civil War in the Plaguelands is a readable History of Warcraft book about the conflict among Lordaeron's undead. It belongs to the fifth chapter of the history and concerns the period of Sylvanas's rebellion and the emergence of the Forsaken.\n\nCopies can be read in Undercity, Ironforge and the Scarlet Monastery. The book follows Rise of the Blood Elves and precedes The Lich King Triumphant, placing the civil war within the upheavals following the Third War.",
    {"https://classicdb.ch/?object=175761 (original object location metadata)", "https://warcraft.wiki.gg/wiki/Civil_War_in_the_Plaguelands (book identity and Timeline)"},
    {"Civil War in the Plaguelands (History of Warcraft book)"},
    {"npc:sylvanas", "faction:forsaken", "faction:scourge"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:kharan-mighthammer",
    "Kharan Mighthammer",
    "Person",
    "Kharan Mighthammer is a dwarf imprisoned in Blackrock Depths after serving as an escort to Princess Moira Bronzebeard. Her disappearance drives King Magni to seek him out for answers. Kharan describes a coordinated Dark Iron ambush in the Burning Steppes that overwhelmed the escort and separated him from the princess.\n\nThe prisoner suspects someone betrayed their route, but offers no proof of a traitor. He was taken through the Slag Pit before reaching his present cell, where regret weighs heavily on him. Kharan reports that Moira now remains beside Emperor Thaurissan and believes she is under a spell. He asks that his account be carried back to Magni, trusting the king to decide what must be done.",
    {"https://classicdb.ch/?quest=4341", "https://warcraft.wiki.gg/wiki/Kharan%27s_Tale", "https://classicdb.ch/?quest=4361", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4341; #4342; #4361"},
    {},
    {"dungeon:blackrock-depths", "npc:magni", "npc:moira"},
    "Classic / Forever",
    true)

Curated("npc:marcus-jonathan",
    "General Marcus Jonathan",
    "Person",
    "General Marcus Jonathan is the human High Commander of Stormwind Defense, stationed in the Valley of Heroes at the city's entrance. His position makes him a recipient of appeals from the kingdom's threatened settlements.\n\nWhen Magistrate Solomon requests reinforcements for Lakeshire, Marcus promises to present its plight to the king. He assures Solomon of the army's support, but makes the dispatch of troops conditional on royal approval. While awaiting that decision, he sends a letter back to Lakeshire. Solomon finds the reply troubling and fears that deeper conflict is beginning within the kingdom. Marcus's correspondence shows how an urgent military request can remain caught between a besieged town and the crown.",
    {"https://classicdb.ch/?npc=466", "https://warcraft.wiki.gg/wiki/General_Marcus_Jonathan (original NPC identity/location)", "https://classicdb.ch/?quest=120", "https://classicdb.ch/?quest=121", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #120; #121"},
    {"Marcus Jonathan"},
    {"region:53746f726d77696e642043697479", "npc:solomon", "place:lakeshire"},
    "Classic / Forever",
    true)

Curated("npc:umi-rumplesnicker",
    "Umi Rumplesnicker",
    "Person",
    "Umi Rumplesnicker is a goblin inventor in Everlook, Winterspring, determined to impress friends who have made fun of her ideas. Her answer is a mechanical yeti: a machine intended to frighten them first and earn their admiration afterward.\n\nShe seeks thick fur from the local Ice Thistle yeti to cover its moving parts, then horns from their patriarchs and matriarchs to finish it. Once the machine is ready, she sends it on a tour of her friends: Legacki in Everlook, Sprinkle in Gadgetzan and Quixxil at Marshal's Refuge. Umi wants both a report of their reactions and her invention returned, delighted at the prospect of having the last laugh.",
    {"https://classicdb.ch/?npc=10305", "https://warcraft.wiki.gg/wiki/Umi_Rumplesnicker (identity and original quest section)", "https://classicdb.ch/?quest=3783", "https://classicdb.ch/?quest=977", "https://classicdb.ch/?quest=5163", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3783; #977; #5163"},
    {},
    {"place:everlook"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("region:416c7465726163204d6f756e7461696e73",
    "Alterac Mountains",
    "Region",
    "The Alterac Mountains rise north of Hillsbrad, amid the remains of a fallen human kingdom. Crushridge ogres occupy its ruined capital and nearby mountain holdings. Farther down the roads, the Syndicate's thieves and assassins serve nobles who survived the kingdom's collapse. Their camps and the ogres' strongholds make the old realm dangerous to travelers from either faction.\n\nSouthshore's officers fear that the ogres will descend into the foothills. The Forsaken at Tarren Mill pursue Syndicate leaders in the Uplands. Beyond these local struggles lies the entrance to Alterac Valley, where Frostwolf orcs and Stormpike dwarves fight a war of their own. The mountains contain several conflicts, rather than a single ruler's domain.",
    {"https://classicdb.ch/?quest=500", "https://classicdb.ch/?quest=505", "https://classicdb.ch/?quest=566", "https://classicdb.ch/?quest=7241", "https://warcraft.wiki.gg/wiki/Alterac_Mountains_%28Classic%29"},
    {"Alterac"},
    {"place:ruins-alterac", "faction:kingdom-alterac", "battleground:alterac-valley"},
    "Classic / Forever")

Curated("place:ruins-alterac",
    "Ruins of Alterac",
    "Place",
    "The Ruins of Alterac are the abandoned capital of a fallen human kingdom, high in the Alterac Mountains. Crushridge ogres have taken its streets and old palace. Southshore's Marshal Redpath sends hunters against them, fearing their security in the mountains will encourage attacks on the foothills below.\n\nObjects within the ruins draw other seekers. The ogre Mug'thol holds the Crown of Will, which freed him from Sylvanas's control; her agents demand its return. Count Remington Ridgewell wants the Perenolde family's lost tiara, rumored to be in the hands of the ogre mage Grel'borg the Miser. The old capital's treasures have become prizes for people far beyond its broken walls.",
    {"https://classicdb.ch/?quest=500", "https://classicdb.ch/?quest=504", "https://classicdb.ch/?quest=495", "https://classicdb.ch/?quest=518", "https://classicdb.ch/?quest=520", "https://classicdb.ch/?quest=543", "https://warcraft.wiki.gg/wiki/Ruins_of_Alterac"},
    {"Alterac Ruins", "Alterac City"},
    {"region:416c7465726163204d6f756e7461696e73", "faction:crushridge", "faction:syndicate"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("faction:southsea-freebooters",
    "Southsea Freebooters",
    "Faction",
    "The Southsea Freebooters are pirates camped just south of Ratchet, where they raid trading vessels and steal cargo. Their presence threatens the business that sustains the port.\n\nGazlowe complains that the trade princes' spending on fleets has failed to protect his ships. With the pirates operating so close to town, he seeks outside help against their brigands and cannoneers. He hopes pressure will force the Freebooters to move their operation elsewhere, while the goods already stolen remain another problem to settle.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #887 Southsea Freebooters", "https://classicdb.ch/?quest=887"},
    {"Southsea freebooters"},
    {"place:ratchet", "faction:steamwheedle"},
    "Classic / Forever",
    true)

Curated("faction:crushridge",
    "Crushridge Ogres",
    "Faction",
    "The Crushridge ogres occupy the ruined city of Alterac and a nearby ogre mound in the Alterac Mountains. Their foothold alarms Marshal Redpath in Southshore: he fears that, once secure in the heights, they will descend into the foothills and threaten the town.\n\nRedpath offers a bounty for the knucklebones carried by the ogres, then calls for a deeper attack against their warmongers in the city ruins. His campaign is intended to keep the Crushridge away from Alliance territory before their occupation becomes a wider advance.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #500 Crushridge Bounty; #504 Crushridge Warmongers", "https://classicdb.ch/?quest=500", "https://classicdb.ch/?quest=504"},
    {"Crushridge", "Crushridge ogres"},
    {"region:416c7465726163204d6f756e7461696e73", "place:southshore"},
    "Classic / Forever",
    true)

Curated("faction:riverpaw",
    "Riverpaw Gnolls",
    "Faction",
    "The Riverpaw are a gnoll pack troubling Elwynn Forest and Westfall. They raid Elwynn's farms and villages and have forced kobolds into labor, making their threat extend beyond attacks on travelers.\n\nIn Elwynn, Deputy Rainer reports more gnolls than his guards can handle near the western garrison and Stone Cairn Lake. He asks for painted armbands as proof that the pack has been reduced. Across the border in Westfall, the People's Militia patrols the grasslands against gnolls whom Captain Danuvin suspects of cooperating with the thieves of the Deadmines. The pack's scattered presence leaves both soldiers and former farmers struggling to protect the countryside.",
    {"Blizzard's original Bestiary, Gnoll and Kobold sections: https://warcraft.wiki.gg/wiki/The_World_of_Warcraft_Bestiary", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #11 Riverpaw Gnoll Bounty; #102 Patrolling Westfall", "https://classicdb.ch/?quest=11", "https://classicdb.ch/?quest=102"},
    {"Riverpaw", "Riverpaw pack", "Riverpaw Pack", "Riverpaw gnolls"},
    {"region:456c77796e6e20466f72657374", "region:5765737466616c6c", "place:stone-cairn"},
    "Classic / Forever",
    true)

Curated("faction:bloodscalp",
    "Bloodscalp Tribe",
    "Faction",
    "The Bloodscalp are trolls of northern Stranglethorn Vale, with their chief Gan'zulah and witch doctor Nezzliok the Dire deep within Zul'Kunda. They are enemies of the Darkspear, and their knowledge becomes crucial to the search for the missing Yenniku.\n\nThe struggle is bound up with another tribal war. Even when Nezzliok's severed head is compelled to speak, he demands appeasement before sharing what he knows: trophy skulls taken from the rival Skullsplitters. He intends those trophies to provide servants for his spirit in the Nether. The demand shows how the tribe's feud reaches beyond battle into its dealings with the dead.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #581 Hunt for Yenniku; #584 Bloodscalp Clan Heads; #585 Speaking with Nezzliok", "https://classicdb.ch/?quest=584", "https://classicdb.ch/?quest=585"},
    {"Bloodscalp", "Bloodscalp tribe", "Bloodscalp trolls"},
    {"faction:darkspear", "faction:skullsplitter", "region:537472616e676c6574686f726e2056616c65"},
    "Classic / Forever",
    true)

Curated("faction:stonevault",
    "Stonevault Troggs",
    "Faction",
    "The Stonevault troggs inhabit Uldaman and the surrounding Badlands, where their presence makes dwarven exploration dangerous. Prospector Agmond's death brings that conflict into sharp focus: the name Murdaloc is scratched beside his remains, and the hunt for his killer also targets Stonevault Bonesnappers.\n\nProspector Ironband suspects that ancient urns uncovered near Uldaman provoked the troggs, but seeks the objects for study rather than claiming the connection is settled. The troggs also carry flakes of indurium, whose ore lies deep in Uldaman. Their hold over the excavation therefore obstructs both the search for ancient knowledge and efforts to obtain its unusual materials.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #739 Murdaloc; #704 Agmond's Fate; #1108 Indurium", "https://classicdb.ch/?quest=739", "https://classicdb.ch/?quest=704", "https://classicdb.ch/?quest=1108"},
    {"Stonevault", "Stonevault troggs"},
    {"dungeon:uldaman", "npc:grimlok", "region:4261646c616e6473"},
    "Classic / Forever",
    true)

Curated("relic:staff-prehistoria",
    "Staff of Prehistoria",
    "Relic",
    "The Staff of Prehistoria is the key to the sealed Chamber of Khaz'mul in Uldaman. Baelog's journal explains how to assemble it from the Gni'kiv Medallion in his chest and the Shaft of Tsol carried by the trogg Revelosh. Placing the joined staff in the map room opens the chamber's door.\n\nBaelog entrusts the exploration to others because his own band is trapped. Prospector Stormpike hopes news of the chamber will persuade Ironforge's leaders to renew their efforts to reclaim Uldaman and study its secrets.",
    {"Original readable Baelog's Journal, object123463 Content: https://www.wowhead.com/classic/object=123463/baelogs-journal", "https://classicdb.ch/?item=7733", "https://classicdb.ch/?item=7740", "https://classicdb.ch/?item=7741", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2240 The Hidden Chamber", "https://classicdb.ch/?quest=2240"},
    {},
    {"relic:gnikiv-medallion", "dungeon:uldaman", "npc:revelosh"},
    "Classic / Forever",
    true)

Curated("relic:gnikiv-medallion",
    "Gni'kiv Medallion",
    "Relic",
    "The Gni'kiv Medallion is kept in Baelog's chest in Uldaman. His journal identifies it as one half of a device for reaching the hidden Chamber of Khaz'mul.\n\nThe medallion must be joined to the Shaft of Tsol, held by Revelosh, to form the Staff of Prehistoria. It is that assembled staff which operates the map room's mechanism and opens the sealed chamber. The medallion is therefore a component of the key, valuable because it completes the means of entry.",
    {"Original readable Baelog's Journal, object123463 Content: https://www.wowhead.com/classic/object=123463/baelogs-journal", "https://classicdb.ch/?item=7740", "https://classicdb.ch/?item=7741", "https://classicdb.ch/?item=7733", "https://classicdb.ch/?object=123329"},
    {"Gni’kiv Medallion"},
    {"relic:staff-prehistoria", "npc:revelosh", "dungeon:uldaman"},
    "Classic / Forever",
    true)

Curated("relic:shattered-necklace",
    "The Shattered Necklace",
    "Relic",
    "The Shattered Necklace is the investigation begun by a broken magical necklace found in Uldaman. Three gems are missing from its setting, while the Ironforge seal and the initials TdK provide clues to its maker. They lead to Talvash del Kissel, who acknowledges the necklace as his work.\n\nTalvash made it for a paladin who set out to cleanse Uldaman and died there. A competitor's claim that the necklace was cursed has damaged the jeweler's reputation. He offers to restore it if the missing gems are recovered and its bearer will speak for his craftsmanship, turning the search into a chance to recover both the necklace's magic and his livelihood.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2198 The Shattered Necklace; #2199 Lore for a Price; #2200 Back to Uldaman", "https://www.wowhead.com/classic/quest=2198/the-shattered-necklace", "https://classicdb.ch/?quest=2199", "https://classicdb.ch/?item=7666"},
    {"Shattered Necklace"},
    {"npc:talvash-del-kissel", "npc:grimlok", "dungeon:uldaman"},
    "Classic / Forever",
    true)

Curated("relic:scythe-elune",
    "Scythe of Elune",
    "Relic",
    "The Scythe of Elune is the mysterious weapon through which the priestess Velinde Starsong summoned worgen to fight the demons of Felwood. In her journal, she describes an ancient, gnarled wooden implement and believes that Elune granted it in answer to her prayers.\n\nAt first the summoned packs served her campaign, but some disappeared and their numbers kept growing even after she stopped calling more. Fearing that she was losing control, Velinde sought knowledge of the wizard Arugal, who was also said to have summoned worgen.\n\nThe search for the Scythe's fate leads to Duskwood. At Roland's Doom, Velinde's specter laments the worgen running loose and the loss of the weapon. The evidence leaves a dangerous mystery: the power she believed would cleanse the forest has escaped her keeping, and she does not know whose hands now direct it.",
    {"Original readable Velinde's Journal: https://warcraft.wiki.gg/wiki/Velinde%27s_Journal", "Original quest1043 cutscene dialogue: https://warcraft.wiki.gg/wiki/The_Scythe_of_Elune_%28Classic%29", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1043 The Scythe of Elune; #1044 Answered Questions"},
    {"The Scythe of Elune"},
    {"npc:arugal", "npc:jitters", "npc:jonathan-carevin"},
    "Classic / Forever",
    true)

Curated("relic:second-mosharu-tablet",
    "Second Mosh'aru Tablet",
    "Relic",
    "The Second Mosh'aru Tablet is held by Hydromancer Velratha near the sacred pool of Gahz'rilla in Zul'Farrak. It forms a pair with the tablet guarded by Theka the Martyr.\n\nYeh'kinya seeks both tablets, presenting their prophecy as a means of containing Hakkar's essence. He intends to reunite the inscriptions and study their secrets. The second tablet's importance lies in completing that pair: the promised knowledge draws the search beyond Theka's shrine to Velratha's place beside the pool.",
    {"https://classicdb.ch/?item=10661", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3527 The Prophecy of Mosh'aru", "https://classicdb.ch/?quest=3527"},
    {"Second Mosh’aru Tablet"},
    {"relic:first-mosharu-tablet", "npc:velratha", "dungeon:zulfarrak"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("place:shimmering-flats",
    "Shimmering Flats",
    "Place",
    "The Shimmering Flats spread south of the Thousand Needles canyon, a broad salt flat on the way to Tanaris. At Mirage Raceway, gnome and goblin engineers turned the level ground into a proving ground for rocket cars. The Brassbolts brothers needed helmets for pilots whose speed too often ended in a crash.\n\nWreckage scattered across the flats became valuable salvage for Kravel Koalbeard. Even the local scorpids had a part in the competition: Fizzle Brassbolts wanted their unusually salty venom for an experimental fuel. The races drew their supplies, their profits and some of their dangers from the surrounding wasteland.",
    {"https://classicdb.ch/?quest=1179", "https://classicdb.ch/?quest=1110", "https://classicdb.ch/?quest=1104", "https://warcraft.wiki.gg/wiki/Shimmering_Flats"},
    {},
    {"place:mirage-raceway", "region:54686f7573616e64204e6565646c6573", "region:54616e61726973"},
    "Classic / Forever")

Curated("place:rethban-caverns",
    "Rethban Caverns",
    "Place",
    "Rethban Caverns lay in the Redridge foothills north of Lakeshire. Redridge gnolls occupied the caves, and their drudgers gathered the ore named for its discoverer, Bart Rethban. Though weaker than iron when smelted, it yielded a dark dye prized by scribes. With Lakeshire's workers occupied by defenses against orc attacks, Brother Paxton's copying work depended on someone bringing ore out of the gnoll-held caverns.\n\nYorus Barleybrew also used the caves to test warriors. His gauntlet demanded a run to the first fork and back within an hour, after a drink of Barleybrew Scalder. The gnolls made that apparently simple journey a dangerous trial.",
    {"https://classicdb.ch/?quest=347", "https://classicdb.ch/?quest=1699"},
    {},
    {"place:lakeshire", "faction:redridge-gnolls", "region:5265647269646765204d6f756e7461696e73"},
    "Classic / Forever")

Curated("group:elementals",
    "Elementals of Azeroth",
    "Group",
    "Elementals are powerful beings associated with the elements, encountered in forms of earth, air, fire and water. They have wills and allegiances of their own: the Hydraxian Waterlords wage war against other elemental powers and recruit mortal allies into that struggle.\n\nDalaran's wizards summon beings from other dimensions and control them with magical tokens and binding bracers. The earth elementals in the ruined city are therefore servants held by enchantment. This relationship differs from the understanding sought by shamans. An earth spirit teaches a novice to value patience, strength and wisdom, giving a stone that will become the heart of a totem. Azeroth's people encounter the elements as enemies, compelled servants and teachers.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #556 Stone Tokens; #557 Bracers of Binding; #6805 Stormers and Rumblers; #1521 Call of Earth", "https://warcraft.wiki.gg/wiki/Elementals"},
    {"Elementals"},
    {"faction:hydraxian-waterlords", "faction:earthen-ring", "city:dalaran"},
    "Classic / Forever",
    true,
    {"Elementals"})

Curated("faction:kingdom-stromgarde",
    "Kingdom of Stromgarde",
    "Faction",
    "Stromgarde is a human kingdom of the Arathi Highlands, with its royal seat in the former Arathorian capital of Strom. During the Second War, the realm belonged to the Alliance of Lordaeron under King Thoras Trollbane. That standing contrasts sharply with the struggle facing its surviving subjects.\n\nThe kingdom now struggles to retain even its capital. Thoras is dead, and his son Galen remains among the defenders of the ruined stronghold. Its militia fights the Syndicate and ogres while its remaining cavalry rides the Highlands. The Syndicate's hold on the countryside obstructs supplies from Southshore; within the city, its leaders pay bounties for badges taken from dead Stromgarde soldiers. The kingdom's surviving forces are fighting for their homes and the continued existence of their realm.",
    {"https://warcraft.wiki.gg/wiki/Kingdom_of_Stromgarde (independently written introductory kingdom/history overview, only original-era facts)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #638 Trollbane; #643 Sigil of Arathor; #644 Sigil of Trollbane; #681 Northfold Manor; #682 Stromgarde Badges"},
    {"Stromgarde (kingdom)", "Stromgarde kingdom"},
    {"place:stromgarde", "place:refuge-pointe", "relic:trolkalar"},
    "Classic / Forever",
    true)

Curated("group:stormwind-nobles",
    "Stormwind House of Nobles",
    "Group",
    "The House of Nobles is Stormwind's political assembly of aristocrats, whose decisions reach beyond the capital into the lives of the kingdom's people. Its treatment of the Stonemasons helped create a lasting enemy: Baros Alexston says the nobles withheld payment for rebuilding Stormwind, driving VanCleef to riot and revenge.\n\nDisputes over justice expose the House's power as well. When Lord Ebonlocke sentenced Dextren Ward to death for selling corpses to Morbent Fel, the nobles instead claimed Ward as a Stormwind prisoner. Darkshire's anger at that intervention led to a call for his assassination in the Stockade. Another noble delayed Targorr the Dread's execution, provoking suspicion of political interference. These grievances show how the capital's authority can deepen resentment in the communities it governs.",
    {"https://warcraft.wiki.gg/wiki/House_of_Nobles (original political-body identity)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #377 Crime and Punishment; #386 What Comes Around...; #389 Bazil Thredd"},
    {"House of Nobles", "Stormwind's House of Nobles"},
    {"group:stonemasons", "group:defias", "dungeon:stockade"},
    "Classic / Forever",
    true)

Curated("faction:kingdom-kul-tiras",
    "Kingdom of Kul Tiras",
    "Faction",
    "Kul Tiras is a seafaring human kingdom that helped make the Alliance of Lordaeron a power on the water. In the Second War its ruler, Lord Admiral Daelin Proudmoore, held command of the allied navies, giving the island kingdom a role far beyond the defense of its own shores.\n\nThe wrecks off the Wetlands bear witness to the cost of that service. First Mate Fitzsimmons remembers the Kul Tiras Third Fleet burning under attacks by orc-controlled red dragons. He escaped, but a cursed treasure left his shipmates' spirits bound to the rotting vessels. The kingdom's ships thus survive in memory as more than a measure of naval strength: along the coast, the remains of its fleet still hold the dead of the war.",
    {"https://warcraft.wiki.gg/wiki/Kul_Tiras_%28kingdom%29 (independent lead, Second War Alliance and naval-command synthesis; manual quotation excluded)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #288 The Third Fleet; #289 The Cursed Crew"},
    {"Kul Tiras (kingdom)", "Kul Tiran kingdom"},
    {"npc:daelin-proudmoore", "event:second-war", "region:5765746c616e6473"},
    "Classic / Forever",
    true)

Curated("faction:kingdom-alterac",
    "Kingdom of Alterac",
    "Faction",
    "Alterac was a Perenolde-ruled human kingdom in the mountains bearing its name. Once an Alliance member, it became an enemy through Lord Perenolde's collaboration with the Horde. The resulting Alliance assault left a ruined realm where the old dynasty's claim to rule no longer matched its power.\n\nThe fallen kingdom's legacy survives among ruined possessions and ambitious nobles. Count Remington Ridgewell seeks the Perenolde family's lost tiara, rumored to have fallen into an ogre's hands after Alterac's destruction. Elsewhere, Aliden Perenolde leads Syndicate forces and claims lordship over the land, with plans to enslave the orcs opposing him. The kingdom has lost its former authority, but the names and ambitions of its ruling class remain a danger in the mountains.",
    {"https://warcraft.wiki.gg/wiki/Alterac_%28kingdom%29 (independent introductory kingdom/collapse synthesis, original-compatible core only)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #543 The Perenolde Tiara; #506 Blackmoore's Legacy"},
    {"Alterac (kingdom)", "Alterac kingdom"},
    {"region:416c7465726163204d6f756e7461696e73", "place:ruins-alterac", "faction:syndicate"},
    "Classic / Forever",
    true)

Curated("book:diary-weavil",
    "Diary of Weavil",
    "Book",
    "The Diary of Weavil records Doctor Weavil's spiteful destruction of Narain Soothfancy's book, Draconic for Dummies: Volume II. Furious that his enemy evaded a trap, Weavil took to his flying machine and scattered the book's chapters. His private celebration of revenge also left a trail for anyone trying to undo it.\n\nThe diary names places far beyond the feud's beginnings, including Darkwhisper Gorge, the Molten Core, Stormwind and Undercity. These entries turn a comic catalogue of grievances into clues to a much larger search. Narain needs the eight scattered parts recovered and offers a magical binding to restore the volume. The diary matters because its author's boasting preserves the means to reconstruct the knowledge he tried to destroy.",
    {"https://warcraft.wiki.gg/wiki/Diary_of_Weavil (original readable Contents; patch1.9 provenance)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8620 The Only Prescription"},
    {},
    {"relic:scepter-shifting-sands"},
    "Classic / Forever",
    true)

Curated("relic:stone-tides",
    "Stone of the Tides",
    "Relic",
    "The Stone of the Tides is a Gurubashi relic associated with power over water and a curse upon its bearer. Troll legend tells of a warrior who found it on Stranglethorn's coast, became the honored Tidebearer and served the empire with water magic. In time he faded from the physical world, and the Stone returned for others to find. The legend makes its gift inseparable from the loss of those who wield it.\n\nBaron Revilgaz's investigation follows rumors that the goblin wizard Gazban has found the Stone. Water elementals provide traces of its magic, and Ansirem Runeweaver identifies an altar that strengthens its wielder. He proposes disrupting that focus with an ancient troll dagger. Revilgaz wants the Stone for his collection, while breaking through its magic requires understanding both the relic and its curse.",
    {"https://warcraft.wiki.gg/wiki/Legends_of_the_Gurubashi,_Volume_3 (original readable Contents, The Tidebearer)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #601 Water Elementals; #602 Magical Analysis; #603 Ansirem's Key; #611 The Curse of the Tides"},
    {"Stone of Tides"},
    {"npc:ansirem-runeweaver", "place:booty-bay", "region:537472616e676c6574686f726e2056616c65"},
    "Classic / Forever",
    true)

Curated("event:battle-crestfall",
    "Battle of Crestfall",
    "Event",
    "Crestfall was an Alliance naval victory in the Second War that shattered the Horde's sea power during its retreat from Lordaeron. The battle carried the struggle to the enemy's fleet and the coastal defenses protecting it.\n\nSuccess required more than an exchange of cannon fire. Flying machines helped locate submerged giant turtles, while submarines fought for control of the sea. With the enemy fleet overcome, Alliance battleships bombarded the guarded shoreline and its structures. The defeat struck at the Horde's ability to sustain its war from the water.",
    {"https://wowwiki-archive.fandom.com/wiki/The_Battle_at_Crestfall (independently written lead only; Briefing/Objectives excluded)", "Warcraft II: Tides of Darkness The Official Strategy Guide, pp.138-139, separately authored battle account transcribed under Background at https://warcraft.wiki.gg/wiki/The_Battle_at_Crestfall_%28WC2_Human%29"},
    {"The Battle at Crestfall", "Battle at Crestfall"},
    {"event:second-war", "npc:daelin-proudmoore", "npc:lothar"},
    "Classic / Forever",
    true)

Curated("history:plague-undeath",
    "The Plague of Undeath",
    "Event",
    "The plague of undeath is a magical disease that turns its victims into servants of the Scourge. By raising the dead under the Lich King's control, it makes the destruction of a population a source of strength for the army attacking it.\n\nIn Lordaeron, Kel'Thuzad and his cult spread infected grain through the distribution center at Andorhal, carrying the danger into surrounding communities. The food supply became a weapon against the people who depended on it. The Scourge continues to develop that threat: within Scholomance, necromancers breed plagued dragon hatchlings, alarming the Argent Dawn with the prospect of a new dragonflight. Lordaeron's devastation therefore has not ended the plague's use as a weapon.",
    {"https://warcraft.wiki.gg/wiki/Plague_of_undeath (independently written introduction and Third War synthesis; no manual extracts)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5529 Plagued Hatchlings"},
    {"Plague of Undeath"},
    {"faction:scourge", "place:andorhal", "dungeon:scholomance"},
    "Classic / Forever",
    true)

Curated("event:death-terenas",
    "Death of King Terenas",
    "Event",
    "The death of King Terenas was the betrayal that brought Lordaeron's royal household into the Scourge's conquest. His son Arthas returned from Northrend to a capital celebrating its prince as a hero, then killed the king with Frostmourne. The welcome concealed a catastrophe for the kingdom.\n\nTerenas had been a central figure in the Alliance of Lordaeron. His murder removed that leadership when the northern realm most needed it, while the son who should have protected his inheritance became its destroyer. The killing joined a family's ruin to the collapse of the kingdom it had ruled.",
    {"https://warcraft.wiki.gg/wiki/King_Terenas_II (independently written introduction and Murder section; original-compatible facts only)"},
    {"Murder of King Terenas", "King Terenas's death"},
    {"npc:arthas", "event:third-war", "faction:scourge"},
    "Classic / Forever",
    true)

Curated("event:founding-dalaran",
    "Founding of Dalaran",
    "Event",
    "Dalaran was founded north of Strom as Arathor's second city-state. Young wizards left Strom seeking greater freedom to practice their craft, raising enchanted spires where they could pursue their studies. A prosperous community grew under their magical protection.\n\nThat beginning established the city's enduring vocation as a home for magical learning. Its rulers later founded the Kirin Tor to study and catalogue magical knowledge. Dalaran's foundation thus gave human sorcery a city of its own, with public life and prosperity bound to the work of its mages.",
    {"https://warcraft.wiki.gg/wiki/The_Guardians_of_Tirisfal (original History of Warcraft, founding paragraphs)", "https://warcraft.wiki.gg/wiki/The_Seven_Kingdoms (Dalaran/Kirin Tor paragraph)"},
    {"Foundation of Dalaran (historical event)", "Dalaran's foundation", "Founding of Dalaran (historical event)"},
    {"city:dalaran", "book:guardians-tirisfal", "book:seven-kingdoms"},
    "Classic / Forever",
    true)

Curated("npc:high-priestess-macdonnell",
    "High Priestess MacDonnell",
    "Person",
    "High Priestess MacDonnell is a human priest at Chillwind Camp in the Western Plaguelands and Commander Ashlam Valorfist's second. She coordinates the effort to turn the Scourge's plague cauldrons against their makers. Ashlam believes Kel'Thuzad's power prevents the cauldrons from being shut down outright, so her assignment is to change what they release.\n\nMacDonnell directs expeditions to gain access to the four western cauldrons and bring back samples. Alchemist Arbington studies the mixtures and devises counteragents; she oversees the campaign that puts those reagents to use. She warns that a single success will not suffice. The cauldrons must be sabotaged repeatedly if their fumes are to weaken the Scourge across the region.",
    {"https://warcraft.wiki.gg/wiki/High_Priestess_MacDonnell (original identity and quest section)", "https://classicdb.ch/?quest=5215", "https://classicdb.ch/?quest=5216", "https://classicdb.ch/?quest=5217", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5215; #5216; #5217; #5220"},
    {"MacDonnell"},
    {"place:chillwind", "faction:scourge", "region:5765737465726e20506c616775656c616e6473"},
    "Classic / Forever",
    true)

Curated("npc:mankrik",
    "Mankrik",
    "Person",
    "Mankrik is an orc at the Crossroads in the Barrens, searching for news of his missing wife. They were separated while fighting Bristleback quilboar at a small tauren camp. He saw her overwhelmed, then fell himself as he turned on their attackers. A tauren druid found him on the Gold Road and tended his wounds.\n\nMankrik still hopes she survived, but the search leads to a battered female orc's body south of the Crossroads. Inspection identifies the dead warrior as his wife. His grief is accompanied by a hunger for vengeance: he asks others to kill quilboar, admitting that even their deaths have not satisfied his anger.",
    {"https://warcraft.wiki.gg/wiki/Mankrik (original identity only)", "https://warcraft.wiki.gg/wiki/Lost_in_Battle (original objectives and Beaten Corpse inspection)", "https://classicdb.ch/?quest=4921", "https://classicdb.ch/?quest=899", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #4921; #899"},
    {},
    {"place:crossroads", "faction:bristleback", "region:5468652042617272656e73"},
    "Classic / Forever",
    true)

Curated("npc:yehkinya",
    "Yeh'kinya",
    "Person",
    "Yeh'kinya is a jungle troll at Steamwheedle Port in Tanaris, offering help against Hakkar. He begins by seeking the spirits of Feralas's vale screechers, claiming a link between them and the dead god. He then asks for Mosh'aru tablets and an ancient egg, presenting them as a means to contain Hakkar's essence. His ritual in the Sunken Temple calls forth Hakkar's avatar so that its essence can be placed in the egg.\n\nProspector Ironboot searches for further Mosh'aru tablets, fearing what their complete message might reveal. When confronted, Yeh'kinya admits helping Hakkar return to Zul'Gurub. His protection was a deception.",
    {"https://warcraft.wiki.gg/wiki/Yeh%27kinya (original identity)", "https://classicdb.ch/?quest=3520", "https://classicdb.ch/?quest=3527", "https://classicdb.ch/?quest=3528", "https://classicdb.ch/?quest=4787", "https://classicdb.ch/?quest=4788", "https://classicdb.ch/?quest=8181", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3520; #3527; #3528; #4787; #4788; #8181"},
    {},
    {"place:steamwheedle-port", "npc:hakkar", "relic:ancient-egg"},
    "Classic / Forever",
    true)

Curated("npc:theldurin-the-lost",
    "Theldurin the Lost",
    "Person",
    "Theldurin the Lost is a dwarf in the Badlands whose rambling speech surrounds a serious warning about Myzrael. Gerrig Bonegrip and Zaruk of the Twilight's Hammer accuse him of abandoning their order and stealing the scroll needed to summon her. They want it recovered so their Lady can return.\n\nTheldurin fears that summoning Myzrael will endanger the surface world. He says enraged elementals stole and tore apart the scroll, and seeks its fragments so he can repair it. If she is already free and gathering strength, he argues, the same magic will be needed to confront her. He calls for Myzrael to be summoned, defeated and bound again before she can overpower her captors.",
    {"https://warcraft.wiki.gg/wiki/Theldurin_the_Lost (original World of Warcraft section)", "https://classicdb.ch/?quest=687", "https://classicdb.ch/?quest=692", "https://classicdb.ch/?quest=656", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #687; #692; #656"},
    {"Theldurin"},
    {"region:4261646c616e6473", "group:twilights-hammer", "relic:pendant-myzrael"},
    "Classic / Forever",
    true)

Curated("npc:archmage-malin",
    "Archmage Malin",
    "Person",
    "Archmage Malin is a human mage in Stormwind's Mage Quarter and a former pupil of Archmage Trelane. After Trelane fails to defend the Tower of Arathor and flees Stromgarde, he asks Malin to recover possessions left behind. Malin has already sent agents to the Arathi Highlands, but their request for help brings him to recruit further assistance.\n\nSkuerto and Apprentice Kryten carry out this work in the field. Kryten gathers reagents, while Skuerto tracks Trelane's belongings among the Boulderfist ogres and inside Stromgarde. Their efforts lead back to the occupied tower, where Kryten's enchantment can reactivate its defenses. Malin awaits their report in Stormwind, eager to see his master's property recovered and his agents return safely.",
    {"https://warcraft.wiki.gg/wiki/Archmage_Malin (original identity and introductory quest relationships)", "https://classicdb.ch/?quest=690", "https://warcraft.wiki.gg/wiki/Worth_Its_Weight_in_Gold_(Classic)", "https://classicdb.ch/?quest=697", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #690; #691; #693; #694; #695; #696; #697"},
    {"Malin"},
    {"region:53746f726d77696e642043697479", "place:stromgarde", "faction:boulderfist"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:alonsus-faol",
    "Alonsus Faol",
    "Person",
    "Archbishop Alonsus Faol was a human leader of the Church of the Holy Light and Uther's teacher. He led the Northshire clerics during the First War. His work helped establish the Knights of the Silver Hand, the paladins who joined spiritual service to armed defense during the Second War. Faol supplied religious leadership and training; Uther became the order's first paladin and its leader in battle.\n\nFaol's legacy also lay in rebuilding after war. He helped restore the Brotherhood of Northshire and raised money for Stormwind's reconstruction, extending the Church's work beyond the battlefield to the recovery of the Alliance's people and institutions.",
    {"https://warcraft.wiki.gg/wiki/Alonsus_Faol (lead; Retcons, original-era Northshire identity)", "https://warcraft.wiki.gg/wiki/Uther_the_Lightbringer (lead, spiritual advising and Second War leadership)", "https://classicdb.ch/?object=177199 (Content, original Faol memorial)", "https://downloads.war2.ru/war2/Info%20%26%20Media%20content/Documents/War2BNE_Manual_EN.pdf (Sire Uther Lightbringer; verification only)"},
    {"Archbishop Alonsus Faol"},
    {"npc:uther", "faction:silver-hand", "event:second-war"},
    "Classic / Forever",
    true)

Curated("npc:tichondrius",
    "Tichondrius",
    "Person",
    "Tichondrius was a dreadlord of the Burning Legion and one of the demons charged with keeping the Lich King obedient. During the Third War he directed Scourge operations and delivered orders to Arthas as the undead prepared the way for Archimonde. His authority represented the Legion's control over an army whose master was secretly seeking freedom.\n\nIn Felwood, Tichondrius used the Skull of Gul'dan to spread corruption and strengthen his own power. Illidan took the artifact's energies into himself, transformed into a demonic being, and killed the dreadlord. The weapon sustaining Tichondrius's campaign thus supplied the power that defeated him.",
    {"https://warcraft.wiki.gg/wiki/Tichondrius (lead; The Scourge of Lordaeron; invasion of Kalimdor)", "https://warcraft.wiki.gg/wiki/Illidan_Stormrage (lead, Third War transformation)", "https://warcraft.wiki.gg/wiki/A_Destiny_of_Flame_and_Sorrow (original Main Quests, verification only)"},
    {},
    {"npc:nerzhul", "npc:illidan", "relic:skull-guldan"},
    "Classic / Forever",
    true)

Curated("npc:blackhand",
    "Blackhand",
    "Person",
    "Blackhand the Destroyer was chieftain of the Blackrock clan and the first Warchief of the Old Horde. He commanded the orcs in their war against Stormwind, but the power behind his position was Gul'dan and the secretive Shadow Council. Blackhand believed himself a partner in their plans; the warlock used his ambition to control the Horde through him.\n\nWhen Gul'dan was incapacitated, Blackhand lost that protection. Orgrim Doomhammer killed him near the end of the First War and took his place as Warchief, ending Blackhand's rule and breaking the arrangement that had kept the Horde's public commander under Gul'dan's influence.",
    {"https://warcraft.wiki.gg/wiki/Blackhand (lead; rise to Warchief; The First War)", "https://downloads.war2.ru/war2/Info%20%26%20Media%20content/Documents/War2BNE_Manual_EN.pdf (Rise of the Shadow Council and Blackrock Clan; verification only)"},
    {"Blackhand the Destroyer"},
    {"faction:blackrock-clan", "npc:guldan", "npc:orgrim"},
    "Classic / Forever",
    true)

Curated("faction:orgrimmar-reputation",
    "Orgrimmar (reputation faction)",
    "Faction",
    "Orgrimmar is the Horde reputation faction associated with Thrall's orc capital in Durotar. Standing with it records the recognition earned from the city's people through service, including work in Durotar and the Barrens.\n\nThat recognition extends beyond military victories. Rashona Straglash accepts cloth for garments and bandages, promising that donations to Orgrimmar's orcs will be acknowledged. Her cloth drive offers a continuing way to support the city. Exalted standing also allows non-orc members of the Horde to obtain the orcs' wolf mounts, making the faction's trust tangible to its allies.",
    {"https://classicdb.ch/?faction=76 (description and Reputation, not copied History)", "https://warcraft.wiki.gg/wiki/Rashona_Straglash (original Gossip, quests and patch history)"},
    {"Orgrimmar reputation", "Orgrimmar (faction)"},
    {"region:4f726772696d6d6172", "npc:thrall", "faction:horde"},
    "Classic / Forever",
    true)

Curated("group:satyrs",
    "Satyrs",
    "Group",
    "Satyrs are demonic beings descended from corrupted night elves, with horns, claws and hooved lower bodies. Their kind began with Xavius, whom Sargeras remade into the first satyr during the War of the Ancients. Xavius then spread that transformation among other night elves. The satyr sects of Kalimdor remain enemies of their former kin and servants of the Burning Legion.\n\nIn Ashenvale they occupy Night Run, Satyrnaar and Xavian. These are active refuges of demonic power: Delgren the Purifier learns that the sorcerer Athrikus Narassin has hidden soulgems among the satyrs at Night Run and Satyrnaar. Destroying those guarded stores of power is part of his effort to weaken the master of the Tower of Althalaxx.",
    {"https://warcraft.wiki.gg/wiki/Satyr (independent lead and War of the Ancients synthesis before RPG)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #6441 Satyr Horns; #1140 The Tower of Althalaxx"},
    {"Satyr"},
    {"faction:burning-legion", "faction:highborne", "place:satyrnaar"},
    "Classic / Forever",
    nil,
    {"Satyrs", "Satyr"})

Curated("group:worgen",
    "Worgen",
    "Group",
    "Worgen are ferocious wolf-men, walking upright with fangs and claws. The Dalaran mage Ur describes them as inhabitants of a nightmare world who can be drawn into Azeroth by powerful magic. His warning is explicit: summoning them offers neither a safe bargain nor harmless knowledge.\n\nArugal summoned worgen against the Scourge; they escaped his control and ravaged Shadowfang Keep, killing Baron Silverlaine's court. The keep remains their stronghold in Silverpine Forest. Dalar Dawnweaver blames Arugal's reckless magic for the Moonrage beasts that threaten the region, while the imprisoned Kirin Tor investigator Ashcrombe reports that the wizard has lost his sanity. The Forsaken seek to break Arugal's power before claiming Silverpine securely for the Dark Lady.",
    {"https://warcraft.wiki.gg/wiki/Book_of_Ur (original readable Contains)", "https://www.engadget.com/2009-08-23-know-your-lore-world-of-warcraft-cataclysm-worgen.html (independent historical Rise of Arugal paragraph only; 21-word allocation)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421 Prove Your Worth; #1014 Arugal Must Die", "https://warcraft.wiki.gg/wiki/Sorcerer_Ashcrombe (original Gossip)"},
    {},
    {"book:ur", "npc:arugal", "dungeon:shadowfang"},
    "Classic / Forever",
    nil,
    {"Worgen"})

Curated("faction:thunder-bluff-reputation",
    "Thunder Bluff (reputation faction)",
    "Faction",
    "Thunder Bluff is the Horde reputation faction of the tauren capital in Mulgore, led by Cairne Bloodhoof. Its standing reflects recognition from the tauren community, earned through service to the city and its people.\n\nRumstag Proudstrider appeals for cloth because establishing their homeland has left the tauren short of supplies. Donations, including repeat supplies of runecloth, earn their gratitude. The value of that trust is also expressed by Harb Clawhoof in Bloodhoof Village: he will sell kodos to tauren, but other allies must first be regarded as exalted by Thunder Bluff's elders. A mount raised with the care of his people is a privilege he will not extend to strangers.",
    {"https://classicdb.ch/?faction=81 (description and Reputation, excluding copied History)", "https://warcraft.wiki.gg/wiki/Rumstag_Proudstrider (original Gossip, quest list,1.5 addition)", "https://warcraft.wiki.gg/wiki/Harb_Clawhoof (not-exalted Gossip; original kodo vendor)"},
    {"Thunder Bluff reputation", "Thunder Bluff (faction)"},
    {"region:5468756e64657220426c756666", "npc:cairne", "faction:horde"},
    "Classic / Forever",
    true)

Curated("group:harpies",
    "Harpies",
    "Group",
    "Harpies are winged raiders whose tribes trouble settlements and travelers across Kalimdor. They are separate regional peoples: the Windfury nest along Mulgore's mountains, where the tauren regard them as natural enemies, while the Bloodfury occupy Stonetalon's Charred Vale and obstruct efforts to restore its burned forest.\n\nIn Durotar, the Dustwind steal supplies from Gazlowe's workers near Razorwind Canyon. The Barrens face the Witchwing, whose matriarchy includes lieutenants commanding lesser raiders in the Dry Hills. Darsok Swiftdagger traces their attacks on Horde caravans to Serena Bloodfeather's revenge for the death of her sister at Rexxar's hands. His campaign against their ranks is a local war against the Witchwing, separate from the Dustwind raids in Durotar.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #743 Dangers of the Windfury; #1057 Reclaiming the Charred Vale; #834 Winds in the Desert; #867 Harpy Raiders; #875 Harpy Lieutenants; #876 Serena Bloodfeather", "https://warcraft.wiki.gg/wiki/Witchwing (original tribe/location identity)", "https://classicdb.ch/?quest=876 (Darsok Start/End and Description)", "https://warcraft.wiki.gg/wiki/Harpy (physical identity only)"},
    {"Harpy"},
    {"region:4d756c676f7265", "place:charred-vale", "npc:rexxar"},
    "Classic / Forever",
    nil,
    {"Harpies", "Harpy"})

Curated("book:second-troll-legend",
    "The Second Troll Legend",
    "Book",
    "The Second Troll Legend is a transcription of the Gri'lek the Wanderer tablet at the Vile Reef in Stranglethorn. Its damaged text tells of an angry, one-armed wanderer. Having rejected the spirits, Gri'lek cannot gain their help and is condemned to roam without recovering his arm.\n\nBrother Nimetz seeks it among four records in Kurzen's Mystery, hoping to discover whether troll magic explains Colonel Kurzen's corruption. The Darkspear consider Gri'lek's tale sacred: Kin'weelay seeks a shard for a shrine in Orgrimmar. The same tablet thus serves both an outsider's investigation and the preservation of a people's treasured legend.",
    {"https://wotlkdb.com/?item=2006 (original item2006 readable Content)", "https://classicdb.ch/?item=2006 (original item identity)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #207 Kurzen's Mystery; #629 The Vile Reef", "https://classicdb.ch/?quest=207 and https://classicdb.ch/?quest=629 (reviewer checked original Start/End and Description)"},
    {"The Second Troll Legend (book)", "Gri'lek the Wanderer (tablet)"},
    {"npc:grilek", "book:third-troll-legend", "region:537472616e676c6574686f726e2056616c65"},
    "Classic / Forever",
    true)

Curated("book:old-hatreds-colonization",
    "Old Hatreds - The Colonization of Kalimdor (book)",
    "Book",
    "Old Hatreds - The Colonization of Kalimdor is a readable history and a section within Chapter V of the History of Warcraft. Its subject is the fragile peace surrounding the Horde's new homeland in Durotar and Jaina Proudmoore's human settlement at Theramore.\n\nThe conflict centers on Admiral Daelin Proudmoore's refusal to accept peace with the Horde. His attack forces Jaina to choose between her father and the alliance she has made with Thrall. She helps the Horde oppose him; Daelin dies, and Jaina retains Theramore. The history makes the founding of these settlements inseparable from the struggle to keep the old human-orc wars from beginning again.",
    {"https://warcraft.wiki.gg/wiki/Old_Hatreds_-_The_Colonization_of_Kalimdor (independent lead/Notes for artifact identity only)", "https://en.wikipedia.org/wiki/Warcraft_III:_The_Frozen_Throne (independently written Plot, Durotar paragraph)", "https://en.wikipedia.org/wiki/Thrall_(Warcraft) (independent Frozen Throne appearance paragraph)"},
    {"Old Hatreds - The Colonization of Kalimdor", "The Colonization of Kalimdor (book)", "Old Hatreds (book)"},
    {"region:4475726f746172", "place:theramore", "npc:jaina"},
    "Classic / Forever",
    true)

Curated("book:beyond-dark-portal-manual",
    "Beyond the Dark Portal (Warcraft III manual chapter)",
    "Book",
    "Beyond the Dark Portal is a historical section of the Warcraft III manual, also preserved as a readable book in Azeroth. It recounts the renewed struggle with Ner'zhul's Horde after the Second War. This is a separate text from The Invasion of Draenor, although both concern the Alliance's expedition through the portal.\n\nThe account follows the search for magical artifacts, the Alliance's pursuit into Draenor and the catastrophe caused by Ner'zhul's new portals. Khadgar and his companions close the connection to Azeroth to keep the disaster from spreading to their home. Their isolation on the dying world gives the history its cost: Azeroth's safety depends on people left beyond its reach.",
    {"https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal_(History_of_Warcraft) (independent lead and Notes)", "https://en.wikipedia.org/wiki/Warcraft_II:_Beyond_the_Dark_Portal (independent Story synthesis, first two paragraphs)"},
    {"Beyond the Dark Portal (book)", "Beyond the Dark Portal (manual chapter)"},
    {"book:invasion-draenor", "npc:nerzhul", "place:dark-portal"},
    "Classic / Forever",
    true)

Curated("book:forors-compendium",
    "Foror's Compendium of Dragon Slaying",
    "Book",
    "Foror's Compendium of Dragon Slaying is a lost work from the Athenaeum, the library of Dire Maul. Its broken protective seal leaves the writing difficult to read but exposes valuable knowledge of dragon slaying. Lorekeeper Lydros recognizes it as one of the library's great compilations and offers a demanding reward for its return.\n\nThat reward begins the forging of Quel'Serrar. Lydros provides an unfinished elven blade and explains how dragon breath and blood must shape and temper it. The ensuing task names Onyxia as the dragon whose fire and blood can complete the work. Recovering the compendium is only the beginning of a dangerous undertaking to awaken the ancient weapon's power.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7507 Foror's Compendium; #7508 and #7509 The Forging of Quel'Serrar", "https://warcraft.wiki.gg/wiki/Nostro%27s_Compendium (original Lydros gossip and quest identity)", "https://warcraft.wiki.gg/wiki/Nostro%27s_Compendium_of_Dragon_Slaying (same item18401 name history)"},
    {"Foror's Compendium of Dragon Slaying (book)", "Nostro's Compendium of Dragon Slaying", "Nostro's Compendium of Dragon Slaying (book)"},
    {"relic:quel-serrar", "dungeon:dire-maul", "npc:onyxia"},
    "Classic / Forever",
    true)

Curated("book:aegwynn-dragon-hunt",
    "Aegwynn and the Dragon Hunt (book)",
    "Book",
    "Aegwynn and the Dragon Hunt is a readable history from Chapter II of the History of Warcraft. It concerns a Guardian of Tirisfal's battle against demons in Northrend and the hidden consequence of her victory.\n\nThe dragon hunt brings Aegwynn to the aid of dragons threatened by demons feeding on their magic. After those enemies are defeated, Sargeras's avatar confronts her. Aegwynn destroys his physical form, but his spirit enters her without her knowledge. The apparent triumph therefore leaves the Guardian carrying the very enemy she believes she has overcome, a reversal that gives the account its warning about power and confidence.",
    {"https://warcraft.wiki.gg/wiki/Aegwynn_and_the_Dragon_Hunt (independent introductory book identification only)", "https://warcraft.wiki.gg/wiki/Dragonblight (independent Prehistory summary of the dragon-hunt episode)", "https://warcraft.wiki.gg/wiki/Guardian_of_Tirisfal (independent Aegwynn and Medivh overview, original-era core only)"},
    {"Aegwynn and the Dragon Hunt", "Aegwynn and the Dragon Hunt (history)"},
    {"npc:aegwynn", "npc:sargeras", "book:guardians-tirisfal"},
    "Classic / Forever",
    true)

Curated("book:third-troll-legend",
    "The Third Troll Legend",
    "Book",
    "The Third Troll Legend is the transcription of the Fall of Gurubashi tablet at Zul'Kunda. Its story describes the destruction of I'lalai through the power of the sea.\n\nIn the legend, Neptulon sends immense krakken against the city. Min'loth gathers his followers' magic and tries to bind them, but the ancient beings break his spell. Before the waves fall, he has his last words carved in stone and defies the creatures one final time. I'lalai is drowned, the surrounding jungle devastated, and Chief Var'gazul finds his ambitions for conquest ruined. The tablet preserves this as a tale of mortal defiance overwhelmed.\n\nBrother Nimetz seeks this and three other legends in Kurzen's Mystery, hoping to discover whether troll magic explains Colonel Kurzen's corruption.",
    {"https://wotlkdb.com/?item=2007 (original item2007 Content pages1-8)", "https://classicdb.ch/?item=2007 (original item identity and subtitle)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #207 Kurzen's Mystery", "https://classicdb.ch/?quest=207 (reviewer checked original Start/End and Description)"},
    {"The Third Troll Legend (book)", "Fall of Gurubashi (tablet)", "Fall of Gurubashi (legend)"},
    {"book:second-troll-legend", "region:537472616e676c6574686f726e2056616c65", "dungeon:zulgurub"},
    "Classic / Forever",
    true)

Curated("place:windshear-crag",
    "Windshear Crag",
    "Place",
    "Windshear Crag is a valley in the Stonetalon Mountains where the Venture Company is stripping the forest for timber. The Talondeep Path opens into the crag from southern Ashenvale, placing the logging operation on a passage between the two regions. What was forest is becoming a landscape of stumps and machinery as the company's workers cut and burn their way through it.\n\nThe destruction injures more than living trees. Stonetalon's forest spirits suffer with the land, their pain turning to rage. Seereth Stonebreak, a shaman on the border with the Barrens, calls for Horde resistance to the company's exploitation and hopes the wisdom of tauren elders can help calm the spirits. On the Alliance side, the gnome Gaxim Rustfizzle seeks to show the night elves that engineering, alchemy and magic can help save their forests. Both efforts confront the company's work in Windshear Crag.\n\nTwo shredders, XT:4 and XT:9, embody the speed of that devastation. Seereth sees them felling trees in a vision and asks that the machines be destroyed to ease the tree spirits' suffering. Gaxim's immediate need is time to develop his inventions, so he seeks help holding back the goblins while he prepares his own response.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1056 Journey to Stonetalon Peak; #1062 Goblin Invaders; #1068 Shredding Machines; #1071 A Gnome's Respite", "https://warcraft.wiki.gg/wiki/Windshear_Crag (lead valley identity; World of Warcraft landscape paragraph only)", "https://classicdb.ch/?quest=1062 (giver/location metadata)", "https://classicdb.ch/?quest=1068 (giver and original description)"},
    {},
    {"region:53746f6e6574616c6f6e204d6f756e7461696e73", "faction:venture-company", "region:417368656e76616c65"},
    "Classic / Forever",
    true)

Curated("place:morlos-aran",
    "Morlos'Aran",
    "Place",
    "Morlos'Aran is the ruin of a former night elf settlement at the southern edge of Felwood.",
    {"https://warcraft.wiki.gg/wiki/Morlos%27Aran (lead identity and southern location only)", "https://www.wowhead.com/classic/guide/felwood-gold-farming-classic-wow (Felwood Locations, 2. Morlos'Aran)"},
    {},
    {"region:46656c776f6f64"},
    "Classic / Forever",
    true)

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:kreldig-ungor",
    "Kreldig Ungor",
    "Person",
    "Kreldig Ungor is a dwarf agent of Reclaimers Inc. at Nijel's Point, the mountain camp in northern Desolace. His company finds lost possessions for paying clients, from family heirlooms to magical objects. Roetten in Ironforge sends workers to him, while Kreldig arranges the recovery work in Desolace.\n\nOne commission comes from Karnitol, a mage and noble of Stormwind. Sea giants attacked his ship off Desolace's northwestern coast. Karnitol abandoned a valuable chest and teleported himself and his servants to safety; Kreldig is charged with recovering the chest and its contents.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1453 Reclaimers' Business in Desolace; #1454 and #1456 The Karnitol Shipwreck", "https://warcraft.wiki.gg/wiki/Kreldig_Ungor (identity fields and original quest/gossip sections)"},
    {},
    {"place:nijels-point", "region:4465736f6c616365", "region:49726f6e666f726765"},
    "Classic / Forever",
    true)

Curated("npc:rhapsody-shindigger",
    "Rhapsody Shindigger",
    "Person",
    "Rhapsody Shindigger is a Wildhammer dwarf who brews at his camp east of Aerie Peak in the Hinterlands. He was once among the aviary's finest gryphon riders.\n\nHis drinking ended his flying career. Gryphon Master Talonaxe recalls a decline that began after an expedition and worsened until he had to dismiss Rhapsody. The former rider now lives at his brewing camp, apart from the aviary where he once excelled.",
    {"https://warcraft.wiki.gg/wiki/Rhapsody_Shindigger (Wildhammer identity and original camp location)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1450 Gryphon Master Talonaxe; #1451 Rhapsody Shindigger; #1469 Rhapsody's Tale"},
    {},
    {"faction:wildhammer", "place:aerie-peak", "region:5468652048696e7465726c616e6473"},
    "Classic / Forever",
    true)

Curated("npc:jannos-lighthoof",
    "Jannos Lighthoof",
    "Person",
    "Jannos Lighthoof is a tauren druid trainer at Camp Mojache in Feralas. He teaches druids in this tauren settlement of the Horde.\n\nHe also relays a request from Torwa Pathfinder, a hunter in Un'Goro Crater who needs a druid's abilities and respect for nature. Jannos directs prospective helpers toward Torwa near the road descending from Tanaris into the crater.",
    {"https://classicdb.ch/?npc=8142 (Druid Trainer; Feralas; starts9063)", "https://classicdb.ch/?quest=9063 (Start list includes Jannos; Description)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9063 Torwa Pathfinder", "https://warcraft.wiki.gg/wiki/Jannos_Lighthoof (tauren and Camp Mojache identity)"},
    {},
    {"place:camp-mojache", "npc:torwa", "region:466572616c6173"},
    "Classic / Forever",
    true)

Curated("npc:krom-stoutarm",
    "Krom Stoutarm",
    "Person",
    "Krom Stoutarm is a dwarf who collects ancient texts in Ironforge's library. Strahad Farsan describes him as an itinerant warlock; his familiarity with old books makes him a useful contact for inquiries into forgotten magic.\n\nKrom once worked at the Uldaman excavation in the Badlands. He escaped when troggs overran the dig, leaving a treasured possession in his own chest. He wants it recovered from the North Common Hall and offers payment for the risk.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1758 Tome of the Cabal; #1360 Reclaimed Treasures", "https://classicdb.ch/?quest=1758 (Strahad Farsan to Krom Stoutarm)", "https://classicdb.ch/?quest=1360 (Krom Stoutarm's account)"},
    {},
    {"place:hall-explorers", "region:49726f6e666f726765", "dungeon:uldaman"},
    "Classic / Forever",
    true)

Curated("npc:hegnar-rumbleshot",
    "Hegnar Rumbleshot",
    "Person",
    "Hegnar Rumbleshot is a dwarf gunsmith beside the road between Coldridge Pass and Kharanos in Dun Morogh. His shop supplies guns and ammunition, and nearby practice by riflemen and mortar teams keeps ammunition in steady demand.\n\nLoslor Rudge supplies the shop, but his latest courier fled a wendigo attack near the Grizzled Den and left the ammunition crate behind. Hegnar is nearly out of stock, with customers already waiting. Recovering Loslor's shipment is therefore a practical need for the local shooting range and its supplier.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5541 Ammo for Rumbleshot", "https://warcraft.wiki.gg/wiki/Hegnar_Rumbleshot (identity, original wares and quest; excludes post4.0.1 removal of ammunition)"},
    {},
    {"region:44756e204d6f726f6768", "place:anvilmar"},
    "Classic / Forever",
    true)

Curated("npc:brohann-caskbelly",
    "Brohann Caskbelly",
    "Person",
    "Brohann Caskbelly is an elderly dwarf of the Explorers' League in Stormwind's Dwarven District. He spent his younger years exploring distant lands, but age has left him unable to undertake the journeys he once managed alone. He wants to retire with one final assignment completed: finding the Temple of Atal'Hakkar, rumored to lie in the Swamp of Sorrows.\n\nBrohann tried searching from the air with a gryphon rider from Aerie Peak. The rider fell into the swamp, and the expedition failed to locate the temple. Brohann now needs help on the ground and an inquiry at the aviary to discover what became of his missing pilot.",
    {"https://warcraft.wiki.gg/wiki/Brohann_Caskbelly (dwarf, Explorers' League, Dwarven District)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1448, #1449, #1450, #1469, #1475"},
    {},
    {"faction:explorers-league", "region:53746f726d77696e642043697479"},
    "Classic / Forever",
    true)

Curated("place:dead-acre",
    "The Dead Acre",
    "Place",
    "The Dead Acre is a ruined farm in southeastern Westfall, near the bridge leading into Duskwood. The Defias burned its fields, leaving smoking buildings and damaged farmland behind. Harvest watchers still move through the ruined holding.",
    {"https://warcraft.wiki.gg/wiki/Dead_Acre (original location and condition)"},
    {},
    {"region:5765737466616c6c"},
    "Classic / Forever",
    true)

Curated("place:creeping-ruin",
    "The Creeping Ruin",
    "Place",
    "The Creeping Ruin is an old troll ruin in the Hinterlands, inhabited by slimes. Among them is the large slime known as the Reak.",
    {"https://warcraft.wiki.gg/wiki/The_Creeping_Ruin (original slime occupation only)", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_lr.pdf (2006 Atlas, p43)"},
    {},
    {"region:5468652048696e7465726c616e6473"},
    "Classic / Forever",
    true)

Curated("place:east-binding",
    "Circle of East Binding",
    "Place",
    "The Circle of East Binding is one of the stone circles in the Arathi Highlands, near Hammerfall in the east. Water elementals called cresting exiles guard its stone. The circle belongs to a larger arrangement of binding stones spread across the region.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #651, #642", "https://classicdb.ch/?quest=651", "https://warcraft.wiki.gg/wiki/Circle_of_East_Binding (original location and guards)"},
    {},
    {"region:41726174686920486967686c616e6473"},
    "Classic / Forever",
    true)

Curated("place:lordamere-internment",
    "Lordamere Internment Camp",
    "Place",
    "Lordamere Internment Camp stands near Dalaran in the Alterac Mountains. Dalaran theurgists and shield guards hold the camp, and Warden Belamoore works there. In this era Dalaran lies behind a great magical dome; the camp belongs to the guarded country outside it.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #544–545", "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/connected/wowatlas/RegionalIndices_lr.pdf (2006 Atlas, p0)"},
    {},
    {"region:416c7465726163204d6f756e7461696e73", "city:dalaran"},
    "Classic / Forever",
    true)

Curated("group:gadgetzan-water-company",
    "Gadgetzan Water Company",
    "Group",
    "The Gadgetzan Water Company supplies the goblin town in the Tanaris desert. Wells are essential to that work, and Wastewander nomads have seized much of the company's supply. Their occupation turns water collection into a struggle over the town's survival.\n\nThe company's response includes both fighting for the wells and looking for another source. Its surveying work sends a dowsing device to Sandsorrow Watch. Spigot Operator Luglunket also offers care packages in exchange for Wastewander water pouches, treating the collected water as property recovered for the company.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #992, #1690, #1707", "https://warcraft.wiki.gg/wiki/Spigot_Operator_Luglunket (original identity)"},
    {},
    {"region:54616e61726973"},
    "Classic / Forever",
    true)

Curated("group:miners-league",
    "Miners' League",
    "Group",
    "The Miners' League is a dwarven mining organization with stores in Loch Modan. When Silver Stream Mine ran dry, the League converted the eastern mine into a depot for mining gear. Kobolds have since overrun the workings and begun taking the stored tools.\n\nMountaineer Stormpike seeks the recovery of the League's gear before warriors arrive to clear the mine. The distinction matters to him: driving out the kobolds will secure the workings, but may leave the equipment destroyed in the fighting.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #307", "https://classicdb.ch/?quest=307"},
    {},
    {"region:4c6f6368204d6f64616e", "place:thelsamar"},
    "Classic / Forever",
    true)

Curated("group:slitherblade",
    "Slitherblade",
    "Group",
    "The Slitherblade are a naga tribe on the coast of Desolace. They inhabit submerged night elf ruins near Ranazjar Isle. Tidehunters and sea witches are among the powerful members encountered in their waters.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1456"},
    {"Slitherblade Naga"},
    {"region:4465736f6c616365"},
    "Classic / Forever",
    true)

Curated("group:bloodfury",
    "Bloodfury",
    "Group",
    "The Bloodfury are harpies of the Charred Vale in the Stonetalon Mountains. Their queen, the Bloodfury Ripper, lives in the western part of the vale, and a separate hunt targets her to weaken the brood.\n\nIndustrialists burned the vale's forest. The Bloodfury now obstruct access to the damaged land, preventing its protectors from beginning the work of regrowth.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1057, #6283"},
    {"Bloodfury Tribe"},
    {"place:charred-vale", "region:53746f6e6574616c6f6e204d6f756e7461696e73"},
    "Classic / Forever",
    true)

Curated("group:ironforge-guard",
    "Ironforge Guard",
    "Group",
    "The Ironforge Guard are the dwarven guards of King Magni Bronzebeard's capital. They keep watch in Ironforge and its approaches in Dun Morogh. Within the city, guards also guide visitors to its services and institutions, giving them a familiar place in the daily life of the mountain capital.",
    {"https://classicdb.ch/?npc=5595", "https://warcraft.wiki.gg/wiki/Ironforge_Guard_%28NPC%29 (original role and directions)", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2298"},
    {},
    {"region:49726f6e666f726765", "faction:ironforge"},
    "Classic / Forever",
    true)

Curated("group:firebrand-legion",
    "Firebrand Legion",
    "Group",
    "The Firebrand Legion is a division of the Blackrock orcs serving Rend Blackhand in Blackrock Spire. Its spellcasters occupy the lower spire, where darkweavers, dreadweavers, invokers and pyromancers support the orcs' hold on the fortress. Fire magic and curses are characteristic weapons of these casters.\n\nBannok Grimaxe bears the title of Firebrand Legion Champion.",
    {"https://warcraft.wiki.gg/wiki/Firebrand_Legion (original lead and Classic ranks)", "https://classicdb.ch/?npc=9596"},
    {},
    {"dungeon:lower-blackrock-spire", "npc:bannok"},
    "Classic / Forever",
    true)

Curated("book:codex-defense",
    "Codex of Defense (book)",
    "Book",
    "The Codex of Defense is a sealed warrior's book bearing the mark of the Athenaeum, the library within Dire Maul. Copies are recovered among the dungeon's books and the possessions of its inhabitants. Its library mark identifies it as one of the Athenaeum's missing volumes.\n\nLorekeeper Kildrath accepts the recovered codex. Returning it earns the Royal Seal of Eldre'Thalas, the warrior's reward for restoring the book to the collection.",
    {"https://classicdb.ch/?item=18357", "https://classicdb.ch/?quest=7499", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7499"},
    {"Codex of Defense"},
    {},
    "Classic / Forever",
    true,
    {"Codex of Defense"})

Curated("book:libram-protection",
    "Libram of Protection (book)",
    "Book",
    "The Libram of Protection is a magical book found in Dire Maul. Dark runes move across its surface. Its incantations concern a protective arcanum, placing it among the elven magical texts that draw seekers to the ruined city.",
    {"https://classicdb.ch/?item=18334", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7485"},
    {"Libram of Protection"},
    {},
    "Classic / Forever",
    true,
    {"Libram of Protection"})

Curated("relic:left-valthalak-amulet",
    "Left Piece of Lord Valthalak's Amulet (artifact)",
    "Artifact",
    "Lord Valthalak's amulet is a broken relic associated with the draconid warlock of Blackrock Spire. This left fragment joins a right and a top piece; together, the three can be recombined into the complete amulet.",
    {"https://www.wowhead.com/classic/item=21984/left-piece-of-lord-valthalaks-amulet", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8960, #8962, #8966", "https://classicdb.ch/?item=22344 (original subject identity only)"},
    {"Left Piece of Lord Valthalak's Amulet", "The Left Piece of Lord Valthalak's Amulet"},
    {},
    "Classic / Forever",
    true,
    {"Left Piece of Lord Valthalak's Amulet", "The Left Piece of Lord Valthalak's Amulet"})

Curated("book:tome-cabal",
    "Tome of the Cabal (book)",
    "Book",
    "The Tome of the Cabal is a warlock ritual book used to call forth a felhunter within a summoning circle. Its value lies in a usable invocation: possessing the written text makes it possible to attempt the summoning it describes.",
    {"https://classicdb.ch/?item=6999", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1758, #1801–1803, #1795"},
    {"Tome of the Cabal"},
    {},
    "Classic / Forever",
    true,
    {"Tome of the Cabal"})

Curated("book:frost-shock",
    "Frost Shock and You (book)",
    "Book",
    "Frost Shock and You is a shaman's book credited to Drek'Thar. It bears the Athenaeum's mark, identifying it as a missing volume from Dire Maul's library. Copies can be recovered from the dungeon's inhabitants and dusty tomes.\n\nLorekeeper Javon receives the book for the library. Its return earns the shaman's Royal Seal of Eldre'Thalas, linking this work by Drek'Thar to the recovery of the Athenaeum's scattered collection.",
    {"https://classicdb.ch/?item=18363", "https://classicdb.ch/?quest=7505", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7505"},
    {"Frost Shock and You"},
    {},
    "Classic / Forever",
    true,
    {"Frost Shock and You"})

Curated("book:light-swing",
    "The Light and How to Swing It (book)",
    "Book",
    "The Light and How to Swing It is a paladin's book credited to Uther. Its Athenaeum mark identifies it with Dire Maul's library, whose missing books are scattered through the dungeon. Copies appear among dusty tomes and the possessions of the city's inhabitants.\n\nLorekeeper Mykos accepts the recovered volume. Returning it earns the paladin's Royal Seal of Eldre'Thalas, restoring a work associated with Uther to the Athenaeum's collection.",
    {"https://classicdb.ch/?item=18359", "https://classicdb.ch/?quest=7501", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7501"},
    {"The Light and How to Swing It"},
    {},
    "Classic / Forever",
    true,
    {"The Light and How to Swing It"})

-- Independently reviewed world reference notes from blind reader audits.
Curated("npc:sergra-darkthorn",
    "Sergra Darkthorn",
    "Person",
    "Sergra Darkthorn is an orc shaman in charge of the Crossroads, the Horde settlement at the meeting of the Barrens' roads. Recruits sent into the region report to her. She expects them to earn their place through useful work, and insists that women in the Horde receive the same respect as men.\n\nSergra also guides newcomers along the hunter's path. Her lessons move from the common beasts of the plains to more dangerous quarry, testing courage and resourcefulness as well as the ability to kill. The work serves the settlement: plainstriders have been harassing its food supplies, and controlling them helps keep those supplies moving.\n\nAmong her early tasks is a zhevra hunt. She asks for hooves as proof, warning that even these comparatively mild beasts have a powerful kick.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #842 Crossroads Conscription, L7665", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #860 Sergra Darkthorn, L7845", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #844 Plainstrider Menace, L7691", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #845 The Zhevra, L7700", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #903 Prowlers of the Barrens, L8284", "https://warcraft.wiki.gg/wiki/Sergra_Darkthorn (identity only; original Crossroads Conscription reference)", "https://classicdb.ch/?quest=842", "https://classicdb.ch/?quest=845"},
    {"Sergra"},
    {"place:crossroads", "region:5468652042617272656e73"},
    "Classic / Forever",
    true)

Curated("npc:brother-karman",
    "Brother Karman",
    "Person",
    "Brother Karman is a human paladin trainer on Theramore Isle in Dustwallow Marsh. He stands outside Foothold Citadel near the training guards and their practice dummies, offering paladin instruction within the human settlement. His greeting invokes the protection of the Light.",
    {"https://classicdb.ch/?npc=8140", "https://warcraft.wiki.gg/wiki/Brother_Karman (original trainer location and Gossip only)"},
    {},
    {},
    "Classic / Forever",
    true)

Curated("npc:davil-crokford",
    "Davil Crokford",
    "Person",
    "Davil Crokford, also known as Davil Lightfire, was a human paladin of the Silver Hand and a native of Darrowshire. When the Scourge threatened his home, he returned with fellow paladins to reinforce its soldiers and local militia. Their arrival helped the defenders hold against the ghouls pressing down upon the village.\n\nDavil met the ghoul lord Horgus in single combat and defeated him, but suffered a mortal wound and died soon afterward. He is remembered for the courage with which he defended his home. His paladin's libram survives: Scarlet Crusaders took it to Hearthglen, where they read it in hope of drawing strength from his example.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5168 Heroes of Darrowshire, L22521", "https://warcraft.wiki.gg/wiki/Extended_Annals_of_Darrowshire (The Battle of Darrowshire; The Fate of Davil Lightfire)", "https://warcraft.wiki.gg/wiki/Davil_Lightfire (identity and original encounter quotes)"},
    {"Davil Lightfire"},
    {"region:4561737465726e20506c616775656c616e6473"},
    "Classic / Forever",
    true)

Curated("npc:belnistrasz",
    "Belnistrasz",
    "Person",
    "Belnistrasz is a prisoner in Razorfen Downs, held among the quilboar in the Murder Pens. He opposes the danger growing within the thorny stronghold and seeks help from either Horde or Alliance adventurers. He says that protecting all peoples from a shared threat matters more to him than faction politics.\n\nBelnistrasz reports that the quilboar have made an agreement with the Scourge. Even after an opportunity to escape, his stated aim is to stop what is happening in the Downs, rather than simply leave its other captives to their fate.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #3523 Scourge of the Downs, L18409", "https://classicdb.ch/?quest=3523"},
    {},
    {"dungeon:razorfen-downs", "faction:scourge"},
    "Classic / Forever",
    true)

Curated("place:plaguewood",
    "Plaguewood",
    "Place",
    "Plaguewood is the blighted woodland south of Stratholme in the Eastern Plaguelands. The Scourge occupies it heavily, with ziggurats and slaughterhouses among the diseased trees and enormous fungi. It forms part of the undead stronghold around the fallen city, rather than a refuge from the devastation elsewhere in Lordaeron.\n\nA rune portal within the wood provides an entrance to Naxxramas, the Scourge necropolis. Its magical wards are a barrier to those seeking to attack the citadel.\n\nSome life survives even here. Nathaniel Dumah points to a breed of termites that endured both the plague and the Scourge. Unable to dislodge the Scarlet Crusade by force, he wants these insects collected for an attack on the Crusaders' lumber mill.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5903 A Plague Upon Thee, L24291", "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9121 The Dread Citadel - Naxxramas, L33491", "https://warcraft.wiki.gg/wiki/Plaguewood (geography and original World of Warcraft only)", "https://classicdb.ch/?quest=5903", "https://classicdb.ch/?quest=9121"},
    {},
    {"dungeon:naxxramas", "region:4561737465726e20506c616775656c616e6473"},
    "Classic / Forever",
    true)

Curated("place:frostwhisper-gorge",
    "Frostwhisper Gorge",
    "Place",
    "Frostwhisper Gorge is a canyon in southern Winterspring, immediately north of Darkwhisper Gorge. Night elven ruins stand along its floor and upper edges, and a bridge spans the chasm toward the demon-haunted country beyond. The gorge is inhabited by the huge Frostmaul Giants and Frostmaul Preservers.\n\nThe Frostmaul's reach extends beyond the canyon. Bodley describes their occasional raids to the north and seeks a relic taken from a night elven village. The giants are also valued for their E'ko: Witch Doctor Mau'ari can draw on that essence to prepare juju associated with their immense strength.",
    {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8963 Components of Importance, L32290", "https://classicdb.ch/?quest=4806", "https://warcraft.wiki.gg/wiki/Frostwhisper_Gorge (geography and Patch changes)", "https://classicdb.ch/?quest=8963", "https://classicdb.ch/?quest=4806"},
    {},
    {"region:57696e746572737072696e67", "place:darkwhisper"},
    "Classic / Forever",
    true)

Curated("people:troggs",
    "Troggs",
    "People",
    "Troggs are brutish, cave-dwelling humanoids found in the tunnels, mines and rocky country of Khaz Modan. They are a danger both below ground and at the surface: Rockjaw troggs raid the dwarven camps of Coldridge Valley, while a much larger incursion has overrun the excavations at Uldaman. Prospector Stormpike fears that dwarves caught beyond the attack may still be trapped inside.\n\nTheir assault on Gnomeregan helped turn the gnomes' technological capital into a disaster. The city's defenders released radioactive waste against the invaders, but the irradiated troggs endured. Many surviving gnomes fled to Ironforge, leaving their home contested and contaminated. For the peoples of Dun Morogh, the trogg threat reaches from isolated camps to the loss of an entire city.",
    {"https://warcraft.wiki.gg/wiki/Trogg", "https://classicdb.ch/?quest=170", "https://classicdb.ch/?quest=2398", "https://warcraft.wiki.gg/wiki/Game_Guide/World_Dungeons"},
    {"Trogg", "troggs", "trogg"},
    {"dungeon:uldaman", "faction:stonevault"},
    "Classic / Forever",
    nil,
    {"Troggs", "Trogg", "troggs", "trogg"})

Curated("people:naga",
    "Naga",
    "People",
    "Naga are an aquatic, serpentine people whose warriors and sea witches emerge along the coasts of Azeroth. Their history reaches back to Queen Azshara's Highborne, the privileged night elves who were swept beneath the sea when the Well of Eternity collapsed. Transformed in the catastrophe, they survived beneath the waves; Lady Vashj's account in the Third War speaks of ten thousand years spent waiting to reclaim a place in the world.\n\nTheir sea witches wield the fury of storms, and naga settlements occupy shores as well as submerged places. In Feralas, the Hatecrest have moved into the ancient ruins of Solarsal near Feathermoon Stronghold. Shandris treats their numbers as a possible threat, while recognizing that an immediate attack may not explain their presence. Ancient ties to the night elves and present coastal struggles therefore meet in the same ruined places.",
    {"https://warcraft.wiki.gg/wiki/The_Tomb_of_Sargeras_%28WC3%29", "https://classic.battle.net/war3/neutral/nagaseawitch.shtml", "https://classicdb.ch/?quest=2866"},
    {"naga"},
    {},
    "Classic / Forever",
    nil,
    {"Naga", "naga"})

Curated("people:night-elves",
    "Night elves",
    "People",
    "Night elves are an ancient, nocturnal people of Kalimdor. Their early civilization's reckless use of magic drew the Burning Legion into Azeroth; the war that followed shattered their homeland and sent much of it beneath the sea. In the long ages afterward, they withdrew around Mount Hyjal and guarded against the Legion's return. Druidic life joined that vigil to the living world: through Ysera's blessing of Nordrassil, the druids gained a bond with the Emerald Dream, spending long periods tending nature within it.\n\nAt Hyjal, the night elves sacrificed their immortality to help defeat the Legion. Their people now belong to the Alliance, with Darnassus in Teldrassil as their capital. Tyrande Whisperwind, high priestess of Elune, leads the Sentinels. Malfurion Stormrage is lost within the Emerald Dream; Fandral Staghelm leads the druids in his absence. Fandral planted Teldrassil to restore their immortality, but the new tree did not receive nature's blessing.",
    {"https://classic.battle.net/war3/nightelf/", "https://warcraft.wiki.gg/wiki/Warcraft_III%3A_Reign_of_Chaos_Game_Manual", "https://bnetcmsus-a.akamaihd.net/cms/template_resource/263A8NGR8HLZ1556919642368.pdf"},
    {"Night elf", "night elves", "night elf"},
    {"region:4461726e6173737573", "npc:tyrande", "place:emerald-dream"},
    "Classic / Forever",
    nil,
    {"Night elves", "Night elf", "night elves", "night elf"})

Curated("people:tauren",
    "Tauren",
    "People",
    "Tauren are the mighty, horned people of Kalimdor's plains. Their traditions honor the Earth Mother and the Great Hunt, preserving a way of life once shaped by following kodo herds across the Barrens. Centaur pressure drove their tribes toward ruin until Cairne Bloodhoof's friendship with Thrall brought orcish help. The tauren secured Mulgore and established Thunder Bluff, a home for tribes gathered under Cairne. Their allegiance to the Horde grew from that alliance and respect for its courage.\n\nHunting carries obligations as well as pride. In Bloodhoof Village, Baine teaches that the land and its creatures deserve respect and that death belongs within life's cycle. The rites of young tauren test their ability to defend the tribe: the Rite of Strength answers Bristleback raids against Camp Narache. These teachings tie strength to responsibility for a community and its country, alongside the shamanic reverence for the Earth Mother.",
    {"https://classic.battle.net/war3/orc/units/tauren.shtml", "https://bnetcmsus-a.akamaihd.net/cms/template_resource/263A8NGR8HLZ1556919642368.pdf", "https://classicdb.ch/?quest=745", "https://classicdb.ch/?quest=757"},
    {"tauren"},
    {"npc:cairne", "region:4d756c676f7265", "region:5468756e64657220426c756666"},
    "Classic / Forever",
    nil,
    {"Tauren", "tauren"})

Curated("people:gnolls",
    "Gnolls",
    "People",
    "Gnolls are hyena-like humanoids who live in packs and tribes across the Eastern Kingdoms and Kalimdor. Their communities have distinct names and local territories: Riverpaw gnolls trouble Elwynn, Palemane occupy parts of Mulgore, and Woodpaw threaten Camp Mojache in Feralas. These are separate groups encountered by different neighboring peoples.\n\nAround Elwynn's borders, Stormwind soldiers report increasing gnoll activity and offer a bounty for Riverpaw armbands. In Mulgore, Baine's quarrel with the Palemane centers on their hunting and disregard for the tauren's appeals. Farther west, Hadoken Swiftstrider fears that renewed Woodpaw attacks could drive his camp out of Feralas. Their presence is woven into struggles over settlements and hunting country on both continents.",
    {"https://warcraft.wiki.gg/wiki/Gnoll", "https://classicdb.ch/?quest=11", "https://classicdb.ch/?quest=745", "https://classicdb.ch/?quest=2862"},
    {"Gnoll", "gnolls", "gnoll"},
    {"faction:riverpaw", "faction:redridge-gnolls", "faction:mosshide"},
    "Classic / Forever",
    nil,
    {"Gnolls", "Gnoll", "gnolls", "gnoll"})

Curated("people:goblins",
    "Goblins",
    "People",
    "Goblins are a people of merchants, inventors and engineers whose enterprises cross the boundaries of kingdoms and factions. Goblin traders once served as allies of the Horde; by the Third War, independent businesses sold their services more widely. Their laboratories produced zeppelins and mechanical shredders, while merchant shops offered unusual wares to those able to pay.\n\nIn the present world, the Steamwheedle Cartel links the neutral trade towns of Booty Bay, Gadgetzan and Ratchet. Other goblin ventures have different relationships with their neighbors. The Venture Company presses into Mulgore despite being refused mining rights, bringing it into conflict with the tauren. Technical rivalry also shapes goblin work: Nixx Sprocketspring teaches goblin engineering in Gadgetzan, a tradition whose advocates prize powerful devices and explosions. Commerce, machinery and competing enterprises give goblin settlements their place in the wider world.",
    {"https://classic.battle.net/war3/neutral/buildings.shtml", "https://warcraft.wiki.gg/wiki/Patch_0.9", "https://classicdb.ch/?quest=764", "https://classicdb.ch/?quest=3526"},
    {"Goblin", "goblins", "goblin"},
    {"faction:steamwheedle", "faction:venture-company", "place:gadgetzan"},
    "Classic / Forever",
    nil,
    {"Goblins", "Goblin", "goblins", "goblin"})

Curated("artifact:arcanite-buoy",
    "Arcanite Buoy",
    "Artifact",
    "The Arcanite Buoy is a magical device made by Narain Soothfancy during the search for the Blue Scepter Shard. Its construction calls for rare metals and gems, making this an extraordinary commission even for Narain. The buoy belongs to the effort to restore the Scepter of the Shifting Sands, with its work directed toward the waters off Azshara.",
    {"https://classicdb.ch/?quest=8728", "https://classicdb.ch/?quest=8729", "https://classicdb.ch/?item=21136"},
    {},
    {},
    "Classic / Forever",
    true)

Curated("artifact:perenolde-tiara",
    "Perenolde Tiara (artifact)",
    "Artifact",
    "The Perenolde Tiara is an heirloom of the family that ruled Alterac before the kingdom's ruin. Count Remington Ridgewell describes it as the work of Ironforge's master jewelers, set with exceptionally fine emeralds. Its history belongs to the fallen ruling house, while its whereabouts became uncertain after Alterac's collapse.\n\nRidgewell seeks the lost tiara for his collection. To him it is a remarkable piece of craftsmanship and a possession worth recovering from the remains of the old kingdom.",
    {"https://classicdb.ch/?quest=543"},
    {"Perenolde Tiara", "The Perenolde Tiara"},
    {"faction:kingdom-alterac"},
    "Classic / Forever",
    true,
    {"Perenolde Tiara", "The Perenolde Tiara"})

Curated("event:second-war-shifting-sands",
    "Second War of the Shifting Sands",
    "Event",
    "The Second War of the Shifting Sands, also called the Ahn'Qiraj War, is the renewed campaign against the qiraji behind the Scarab Wall in southern Silithus. A thousand years earlier, night elves and dragons sealed the threat within Ahn'Qiraj; the present war effort gathers forces to face it again.\n\nHorde and Alliance alike collect the supplies needed to sustain armies in the desert. Copper and other materials are part of a larger mobilization, while the restoration of the Scepter of the Shifting Sands concerns the ancient barrier itself. The two preparations bring soldiers, suppliers and the search for an old artifact into the same campaign.",
    {"https://warcraft.wiki.gg/wiki/Game_Guide/Raid_Areas", "https://classicdb.ch/?quest=8492", "https://classicdb.ch/?quest=8742"},
    {"Ahn'Qiraj War"},
    {"event:ahnqiraj-war-effort", "place:ahnqiraj"},
    "Classic / Forever",
    true)

Curated("artifact:tablet-seven",
    "Tablet of the Seven (artifact)",
    "Artifact",
    "The Tablet of the Seven is associated with the ancient dwarves known as the Seven and the ruins of Thaurissan in the Burning Steppes. Maxwort Uberglint follows legends of their learning and power, hoping that understanding their knowledge will bring wealth.\n\nHe wants a copy of the tablet's writing brought to him. The Tablet Transcript is that portable copy, distinct from the tablet at the ruins.",
    {"https://classicdb.ch/?quest=4296", "https://warcraft.wiki.gg/wiki/Tablet_of_the_Seven"},
    {"Tablet of the Seven"},
    {},
    "Classic / Forever",
    true,
    {"Tablet of the Seven"})

Curated("artifact:chained-essence-eranikus",
    "Chained Essence of Eranikus (artifact)",
    "Artifact",
    "The Chained Essence of Eranikus is a gem containing part of the green dragon Eranikus's essence. It belongs to the troubled magic surrounding the Sunken Temple in the Swamp of Sorrows. Eranikus's connection to the Green Dragonflight links the relic to guardians whose charge extends into the Emerald Dream.",
    {"https://classicdb.ch/?quest=3373", "https://classicdb.ch/?quest=3374", "https://warcraft.wiki.gg/wiki/Warcraft_III%3A_Reign_of_Chaos_Game_Manual"},
    {"Chained Essence of Eranikus"},
    {"faction:green-dragonflight", "place:emerald-dream"},
    "Classic / Forever",
    true,
    {"Chained Essence of Eranikus"})

Curated("artifact:medallion-dawn",
    "Medallion of the Dawn",
    "Artifact",
    "The Medallion of the Dawn is a combat necklace offered from the Argent Dawn's treasure cache by Quartermaster Miranda Breechlock. It is among the armaments made available through the order's insignia exchange, with the Dawn's regard for a buyer affecting the terms. The medallion strengthens its wearer's physical fighting ability. It is distinct from the Amulet of the Dawn, another piece in the same cache.",
    {"https://classicdb.ch/?item=22659", "https://classicdb.ch/?quest=9222"},
    {},
    {"faction:argent-dawn"},
    "Classic / Forever",
    true)

-- Reviewed supplementary catalogues load after this module. Validate the whole
-- batch before registration so duplicate IDs cannot silently discard new prose.
function A.RegisterLoreNotes(list)
    assert(type(list) == "table", "lore catalogue must be a list")
    local batch = {}
    for _, entry in ipairs(list) do
        assert(type(entry.id) == "string" and entry.id:match("^[%w:%-]+$"), "invalid lore ID")
        assert(not entries[entry.id] and not batch[entry.id], "duplicate lore ID: " .. entry.id)
        assert(type(entry.title) == "string" and Normalize(entry.title), "lore title required")
        assert(type(entry.kind) == "string" and entry.kind ~= "Quest", "world lore kind required")
        assert(type(entry.body) == "string" and Plain(entry.body):match("%S"), "lore body required")
        assert(type(entry.sources) == "table" and #Sources(entry.sources) > 0, "lore source required")
        batch[entry.id] = true
    end
    for _, entry in ipairs(list) do
        entry.coverage = "curated"
        Add(entry, entry.names)
    end
end

-- Deterministic inventory for coverage checks and future compendium navigation.
function A.LoreNoteCatalog()
    Import()
    local catalog = {}
    for _, id in ipairs(Keys(entries)) do catalog[#catalog + 1] = entries[id] end
    return catalog
end

function A.LoreNoteResolve(kind, value, context)
    if not aliases[kind] then return nil end
    local name = Normalize(value)
    if not name then return nil end
    Import()
    if kind == "q" and type(context) == "table" and context.qid ~= nil then
        local qid = tonumber(context.qid)
        if qid and qid > 0 and qid == math.floor(qid) then
            local id = "quest:" .. string.format("%.0f", qid)
            local note = entries[id]
            if note and Normalize(note.title) == name then return id end
        end
        -- An unrecognized/mismatched ID can only use generic title context.
    end
    local id = aliases[kind][name]
    return id and entries[id] and id or nil
end
function A.GetLoreNote(id)
    if type(id) ~= "string" or not id:match("^[%w:%-]+$") then return nil end
    Import()
    return entries[id]
end
function A.LoreNoteLink(text, id)
    if not A.GetLoreNote(id) or type(text) ~= "string" then return text end
    if text:find("|[Hh]") then return text end
    return "|Hcjlore:" .. id .. "|h" .. text .. "|h"
end
function A.LoreNoteCoverage()
    Import()
    local counts = {curated = 0, regional = 0, questTitle = 0, questID = 0, packs = 0, total = 0}
    for _ in pairs(loadedPacks) do counts.packs = counts.packs + 1 end
    for _, entry in pairs(entries) do
        counts.total = counts.total + 1
        counts[entry.coverage] = counts[entry.coverage] + 1
    end
    return counts
end

-- The user's own characters and the players in their list (read-only). A
-- one-word name that one of them carries never becomes a link to a namesake
-- NPC: the book owner is never in A.bookLinks, and a player missing from this
-- book's list would otherwise open the NPC's note. A listed player's name keeps
-- its person markup, which A.bookLinks routes to their journal first.
local ownNames, ownNamesFor
local function OwnNames()
    local token = A.bookLinks
    if ownNames and token and ownNamesFor == token then return ownNames end
    local set, db = {}, A.db
    local function Remember(key)
        local base = type(key) == "string" and key:match("^([^%-]+)")
        if base then set[base:lower()] = true end
    end
    if type(db) == "table" then
        for key in pairs(type(db.characters) == "table" and db.characters or {}) do Remember(key) end
        for key, card in pairs(type(db.people) == "table" and db.people or {}) do
            if type(card) == "table" and not card.npc then Remember(key) end
        end
    end
    ownNames, ownNamesFor = set, token
    return set
end

-- Annotate a rendering copy only: never saved journal records. Exact case and
-- word boundaries keep names out of larger words, while existing markup and
-- native links remain opaque. Curated world names cannot imply quest stages.
function A.MarkKnownLore(text)
    if type(text) ~= "string" or text == "" then return text end
    Import()
    local own = OwnNames()
    if not knownNameOrder then
        knownNameOrder = {}
        for name, candidate in pairs(knownNames) do
            if candidate.plain or aliases.p[Normalize(name)] == candidate.id then
                knownNameOrder[#knownNameOrder + 1] = name
            end
        end
        table.sort(knownNameOrder, function(a, b)
            if #a ~= #b then return #a > #b end
            return a < b
        end)
        -- The catalogue is large; inspect only names with the same first byte.
        -- Insertion preserves longest-first precedence within every bucket.
        knownNameBuckets = {}
        for _, name in ipairs(knownNameOrder) do
            local first = name:sub(1, 1)
            local bucket = knownNameBuckets[first] or {}
            knownNameBuckets[first] = bucket
            bucket[#bucket + 1] = name
        end
    end
    local out, pos, size = {}, 1, #text
    while pos <= size do
        local stop
        if text:sub(pos, pos) == "{" then
            stop = text:find("}", pos + 1, true) or size
        elseif text:sub(pos, pos + 1) == "|H" then
            local label = text:find("|h", pos + 2, true)
            local finish = label and text:find("|h", label + 2, true)
            stop = finish and finish + 1 or size
        end
        if stop then
            out[#out + 1] = text:sub(pos, stop)
            pos = stop + 1
        else
            local matched
            local candidates = knownNameBuckets[text:sub(pos, pos)]
            if candidates and (pos == 1 or not text:sub(pos - 1, pos - 1):match("[%w_]")) then
                for _, name in ipairs(candidates) do
                    local last = pos + #name - 1
                    if text:sub(pos, last) == name and
                        (last == size or not text:sub(last + 1, last + 1):match("[%w_]")) then
                        local candidate = knownNames[name]
                        local key = name:lower()
                        local ownName = not name:find(" ", 1, true) and own[key]
                            and not (candidate.kind == "n" and A.bookLinks and A.bookLinks[key])
                        out[#out + 1] = (candidate.plain or ownName) and name or
                            "{" .. candidate.kind .. ":" .. name .. "}"
                        pos, matched = last + 1, true
                        break
                    end
                end
            end
            if not matched then out[#out + 1] = text:sub(pos, pos); pos = pos + 1 end
        end
    end
    return table.concat(out)
end
