local _, A = ...
-- Curated Alliance beginnings and neighboring regions. This is context, not a
-- quest simulator: exact stage consequences are only selected by recorded ID.
-- Evidence: StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt.
-- That local corpus also includes the Forever additions explicitly cited below.
-- Coverage inventory (2026-11-05 overnight): 423 exact quest IDs here plus 11
-- Stalvan stages below, about 350 title contexts (32 shared titles with
-- conservative fallbacks), 48 continuity threads and 12 regional context sets.
-- The overnight pass (tests/AllianceDepth.lua renders every added stage) filled
-- Eastvale's murlocs, Westfall's lighthouse and Sentinel Hill, Lakeshire's
-- bounties and Morganth, Sven and the shadowy figure through Morbent's Bane,
-- the Embalmer after the hermit's letter, the cursed Third Fleet, Dun Modr and
-- Sully Balloo's memorial, Coldridge to Kharanos, the timberlings and Gnarlpine
-- of Teldrassil, the Twilight's Hammer, Remtravel and Volcor in Darkshore, and
-- the Defias reach inside Stormwind through the audience at the Keep.
-- Earlier inventory: 196 exact quest IDs, 153 title contexts (21 conservative
-- shared-title fallbacks), 27 continuity threads and 12 regional context sets.
-- Curated: Northshire/Elwynn errands, three militia stages, Westfall cooking,
-- Redridge dispatches, Night Watch stages, Coldridge mail and provisions,
-- Kharanos/depot/quarry work, Recombobulator parts, Loch excavation reports,
-- Shadowglen/Dolanaar, moonwells through Forever's Tyrande delivery, Bashal'Aran,
-- Darkshore wildlife research and Buzzboxes. Capital entries are delivery/report
-- contexts, not complete capital coverage. Connected additions include the full
-- seven-stage Defias investigation, the feuding farms' letters and lost necklace,
-- Lakeshire's lunch/flowers and recovered tools, Raven Hill's hermit requests
-- through the unreadable mayoral letter, dwarf brewing errands, Ban'ethil's
-- sleeping druid, and the red crystal investigation. Added Loch patrols, dam
-- sabotage and powder escorts lead into Whelgar, the Greenwarden, Dun Modr and
-- the Dragonmaw siege threat. Stalvan's opening and final stages are now exact;
-- his intermediate stages, Wetlands' cursed fleet, the Embalmer
-- revelation after the letter and most Forever additions remain gaps.
-- Crown of the Earth 934 has no completion text in the source: intentionally
-- falls back to the conservative title, not 7383's documented completion.
-- Ashenvale remedies and coastal ruins, Darkshore's river inquiry and the
-- Stonetalon referrals extend the early routes. Class quests and most later
-- journeys belong to other packs; the regional checklist is in
-- StorageInvestigation/cj-leveling-stage-research-20261012.txt.
-- Starters3 (2026-11-05, tests/Starters3.lua): 32 more stages, the missing
-- diplomat from Stormwind to Menethil, Nefarian's head, Ironforge's gnome
-- craftsmen, Velinde, the Nightmare Shard, the Kor gem and the beached sea
-- creatures of Darkshore.
local P = {sources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt (quest, progress and completion text; IDs on each entry)"},
    quests = {}, questIDs = {}, zones = {}, threads = {
        alliance_northshire = "Northshire's safety and supplies",
        alliance_elwynn = "the farms and mines of Elwynn",
        alliance_westfall = "Westfall's farms and militia",
        alliance_redridge = "Lakeshire's requests for help",
        alliance_duskwood = "the defense of Darkshire",
        alliance_stalvan = "the inquiry into Stalvan",
        alliance_coldridge = "daily life in Coldridge Valley",
        alliance_morogh = "the settlements of Dun Morogh",
        alliance_gnomes = "Gnomeregan's recovery",
        alliance_loch = "the expeditions around Loch Modan",
        alliance_wetlands = "the settlements and marshes of the Wetlands",
        alliance_shadowglen = "the troubles of Shadowglen",
        alliance_teldrassil = "the troubles around Dolanaar",
        alliance_moonwells = "the waters of Teldrassil's moonwells",
        alliance_darkshore = "Darkshore's settlements",
        alliance_bashalaran = "the prisoner of Bashal'Aran",
    }}
local function q(id, title, zone, level, thread, why1, why2, after1, after2, importance)
    P.questIDs[id] = {title = title, zone = zone, level = level, thread = thread,
        threadLabel = P.threads[thread], importance = importance or 3,
        why = {why1, why2}, after = {after1, after2},
        source = {"corpus_vanilla_quests.txt: quest " .. id}}
end
local E, W, R, D = "Elwynn Forest", "Westfall", "Redridge Mountains", "Duskwood"
local C, M, G, L, V = "alliance_coldridge", "alliance_morogh", "alliance_gnomes", "alliance_loch", "alliance_wetlands"
local N, F, H, K = "alliance_northshire", "alliance_elwynn", "alliance_westfall", "alliance_redridge"

q(783, "A Threat Within", E, 1, N,
    "Stormwind's soldiers were fighting far from home, leaving Northshire's guards short of help.",
    "Lawless bands were finding room to grow within the kingdom, and the abbey was calling for volunteers.",
    "Inside Northshire Abbey, Marshal McBride welcomed another volunteer. He hoped there would be enough of them for the long campaign ahead.",
    "McBride's welcome came with a warning. Enemies pressed on the kingdom from outside while trouble grew within its borders.", 4)
q(7, "Kobold Camp Cleanup", E, 2, N,
    "A clan of kobolds had made camp in the woods north of {p:Northshire Abbey}. McBride wanted their numbers cut back.",
    "Northshire's northern woods held a growing kobold camp, too close for the abbey's defenders to ignore.",
    "The hunt thinned the kobolds' ranks. McBride was grateful; even those small thieves could threaten Stormwind in numbers.",
    "Fewer kobolds remained in the northern woods. McBride was grateful for the help against a clan he hoped to drive out of Northshire.")
q(33, "Wolves Across the Border", E, 2, N,
    "Eagan Peltskinner hated the timber wolves of {p:Northshire} but liked a wolf steak, and offered a trade for their tough meat.",
    "Young wolves and timber wolves wandered the Northshire countryside, and their tough meat was what Eagan wanted for his steaks.",
    "Eagan took the wolf meat, eager to cook it, and offered a pick of the things he had to trade.",
    "The tough meat went to Eagan beside the abbey. He could hardly wait to cook it, and paid with a choice of his goods.")
q(18, "Brotherhood of Thieves", E, 4, N,
    "Thieves calling themselves the Defias Brotherhood had appeared across the river from {p:Northshire Abbey}.",
    "The Defias wore bandanas that Northshire's guards would exchange for a weapon; the thieves gathered east of the river.",
    "The recovered bandanas reached the guards, earning the Stormwind Army's thanks and the promised weapon.",
    "The guards honored their bargain for the Defias bandanas. The fight across the river had earned a new weapon.")
q(6, "Bounty on Garrick Padfoot", E, 5, N,
    "{p:Garrick Padfoot} had preyed on Northshire's farmers and merchants for weeks, with a gang to protect him.",
    "A shack near Northshire's vineyards sheltered Garrick Padfoot and his thugs. The guards had put a price on his head.",
    "Garrick's head settled the bounty. The cutthroat who had harried the farms and merchants was dead.",
    "The guards paid for Padfoot's head, glad to be rid of the raider who had troubled Northshire for weeks.", 4)
q(3903, "Milly Osworth", E, 4, N,
    "Deputy Willem's duties kept him at the abbey while Milly Osworth needed help near her wagon.",
    "Milly's problem lay beyond what the busy Northshire deputy could handle himself.",
    "Milly called Willem brave, but his duties kept him at the abbey and her trouble was beyond him. She asked for help instead.",
    "By her wagon near the stable, Milly took up the help Willem had sent, with a problem of her own to explain.")
q(3904, "Milly's Harvest", E, 4, N,
    "Milly's picked grapes lay in the vineyards occupied by the Defias.",
    "The harvest risked theft from the brigands and trampling when the guards drove them out.",
    "Milly's harvest came back from the vineyards intact.",
    "The rescued grapes gave Milly something to keep from a harvest interrupted by brigands.", 4)
q(3905, "Grape Manifest", E, 4, N,
    "Brother Neals kept Northshire's food and drink stores from the abbey's bell tower.",
    "Milly's crop was saved, and her Grape Manifest had to reach Brother Neals, who kept the abbey's stores.",
    "Brother Neals had nearly despaired when brigands overran the vineyards. Milly's manifest meant grapes for more wine, and he gave thanks to the Light.",
    "In the bell tower, Neals read Milly's manifest with delight; the abbey would have its wine after all.")
q(47, "Gold Dust Exchange", E, 7, F,
    "Remy Two Times wanted the gold dust carried by Elwynn's kobolds. He promised the best price in Goldshire.",
    "The kobolds around Fargodeep and Jasperlode carried gold dust, and Remy Two Times was eager to buy it.",
    "Remy paid for the dust and added a small token from his associates, hinting that it might prove useful.",
    "Along with Remy's payment came a token from his associates, something he thought might come in handy.")
q(60, "Kobold Candles", E, 7, F,
    "William Pestle had come to Goldshire from his family's apothecary in Stormwind, looking for large kobold candles for their wax.",
    "The kobolds in Fargodeep and Jasperlode carried large candles, and William Pestle wanted the wax for the apothecary he ran with his brother.",
    "William took the kobolds' candles at the Lion's Pride and paid for them, the wax bound for Stormwind.",
    "The candles from the mines went to William Pestle, who remarked that someone had been busy hunting kobolds.")
q(61, "Shipment to Stormwind", "Stormwind City", 7, F,
    "Morgan was waiting for his brother's candle shipment at {p:Pestle's Apothecary}.",
    "The candles gathered in Elwynn needed carrying to the Trade District's apothecary.",
    "Morgan received the shipment and paid for its delivery.",
    "Elwynn's candles reached the shop in Stormwind's Trade District.")
q(62, "The Fargodeep Mine", E, 7, F,
    "Reports of kobolds had reached Marshal Dughan from {p:Fargodeep Mine}, between the Stonefield and Maclure farms.",
    "The mine south of Goldshire had become a refuge for kobolds, and Dughan needed someone to scout its workings.",
    "The report from Fargodeep brought Dughan more bad news. He called for stronger patrols near the mine.",
    "Fargodeep was indeed full of kobolds. Dughan wondered whether dragons would be next, then spoke of increasing the patrols.")
q(76, "The Jasperlode Mine", E, 10, F,
    "{p:Jasperlode Mine}, beyond the Tower of Azora, needed scouting for kobolds.",
    "The trouble in Elwynn's mines extended beyond the workings near Goldshire.",
    "Kobolds held Jasperlode as well. Dughan cursed the news and said the situation was getting worse by the minute.",
    "The scouting found kobolds at Jasperlode too. Dughan thanked the scout and wished the report had been good news.")
q(85, "Lost Necklace", E, 6, F,
    "A missing necklace had stirred another accusation between the Stonefield and Maclure neighbors.",
    "Billy Maclure was suspected of knowing what had happened to a widow's necklace.",
    "Billy denied stealing the necklace and claimed hunger had spoiled his memory.",
    "Billy had been asked about the necklace, but its owner was still waiting for it.")
q(88, "Princess Must Die!", E, 9, F,
    "The Brackwells' enormous sow had been eating a neighboring farm's vegetables.",
    "{p:Princess} was a prize pig to the Brackwells and a threat to another farmer's crop.",
    "Princess's collar supplied proof that the crop-raiding sow was dead.",
    "One farm's vegetables were safe from Princess's next visit.")
q(123, "The Collector", E, 10, F,
    "A gold shipment schedule named a collector near the Brackwell Pumpkin Patch.",
    "Elwynn's mines were still sending gold somewhere, though the marshal's people no longer worked them.",
    "Dughan had heard of the Collector but did not know whom he worked for. He thanked the finder for the schedule, which would help solve the mystery.",
    "The schedule startled Dughan, whose people had not worked the Elwynn mines in months. Someone was still taking their gold, and its destination remained unknown.", 4)
q(176, 'WANTED: "Hogger"', E, 11, F,
    "{p:Hogger} had defeated earlier attempts to capture him in southwestern Elwynn.",
    "The Army's bounty named a huge gnoll who had become a persistent danger near Westbrook.",
    "Proof of Hogger's death reached Marshal Dughan, and the bounty was paid.",
    "The marshal's men were rid of Hogger, a threat they had struggled to bring down.", 5)
q(9, "The Killing Fields", W, 15, H,
    "Harvest Watchers had taken over the fields that Westfall's farm folk once worked.",
    "Even the machinery in the fields had become a danger to the farmers who stayed.",
    "Farmer Saldean paid for the Harvest Watchers cleared from his fields and his neighbors'. Perhaps, he said, Westfall would prosper again.",
    "Twenty Harvest Watchers lay broken in the fields. Saldean, the farmer the thieves had not driven off, paid for the work.")
q(36, "Westfall Stew", W, 10, H,
    "Verna Furlbrow was preparing to leave a farm made unsafe by thieves.",
    "A broken wagon delayed the Furlbrows' departure, leaving time to pass on a stew recipe.",
    "Salma Saldean took Verna's recipe and said Verna was a city girl at heart, who would do fine in Stormwind. Now Salma could make her stew.",
    "Salma received the recipe; making the stew was work still to come.")
q(38, "Westfall Stew", W, 13, H,
    "Salma's stew called for vulture meat, goretusk snouts, murloc eyes and okra.",
    "Westfall's fields and wildlife supplied the unlikely ingredients of Salma's cooking.",
    "The gathered ingredients became a batch of Westfall Stew.",
    "Salma thickened the broth with okra and shared the finished stew.")
q(12, "The People's Militia", W, 12, H,
    "Defias trappers and smugglers threatened the farms and the area near Jangolode Mine.",
    "Westfall's militia needed help against the Defias operating near its northern farms.",
    "The work against trappers and smugglers earned the militia's approval.",
    "Gryan Stoutmantle's scout had watched the trappers and smugglers fall, and Stoutmantle judged the recruit was proving well so far.")
q(13, "The People's Militia", W, 14, H,
    "Defias pillagers and looters were reported around the quarry, Moonbrook and Alexston Farmstead.",
    "The militia's next effort targeted the Defias plundering Westfall's settlements.",
    "Gryan Stoutmantle counted the pillagers and looters of the Gold Coast Quarry and Moonbrook as proof of a recruit's worth to the People's Militia.",
    "The militia had help against the looters around its farms, though other Defias bands remained.")
q(14, "The People's Militia", W, 17, H,
    "Defias had withdrawn into the Dagger Hills after plundering southern Westfall.",
    "The militia's scouts traced another band of raiders into Westfall's southern hills.",
    "The completed service earned formal induction into the People's Militia.",
    "The militia recognized the work in southern Westfall with membership in its ranks.", 5)
q(20, "Blackrock Menace", R, 21, K,
    "Blackrock orcs held Stonewatch Keep and raided the country north of Lakeshire.",
    "Lakeshire's people were hemmed in by orcs who had come down from the Burning Steppes.",
    "Marshal Marris took ten battleworn axes; that made for a lot fewer orcs to worry about.",
    "Ten Blackrock axes reached Marris. Stonewatch still loomed over the town, but fewer raiders stood outside Lakeshire.")
q(92, "Redridge Goulash", R, 18, K,
    "Chef Breanna had fed a whole brigade of Stormwind troops during the orc uprising, and her cupboard was bare.",
    "Redridge goulash required condor meat, goretusk snouts and spider meat before another meal could be cooked.",
    "Breanna admired the condor, goretusk and spider meat and served a bowl of Redridge Goulash.",
    "An empty cupboard yielded a hot meal once the missing ingredients arrived.")
q(120, "Messenger to Stormwind", R, 14, K,
    "Magistrate Solomon needed Stormwind to hear how badly Lakeshire required reinforcements.",
    "A besieged town's request for soldiers had to reach General Marcus Jonathan.",
    "General Jonathan called Solomon a noble leader and promised to take the matter to the king. Reinforcements would come, he said, as soon as His Majesty gave the word.",
    "Solomon's report reached General Marcus Jonathan, who promised the army's support once the king gave word. No soldiers marched yet.")
q(121, "Messenger to Stormwind", R, 14, K,
    "The general had a letter for Solomon while Stormwind awaited the king's response.",
    "Lakeshire's magistrate was waiting for news from the general.",
    "Solomon paid for the delivery and found the general's letter a mystery. Something was amiss in the kingdom, he said. He feared this was the beginning of a conflict, not its end.",
    "The general's letter reached Lakeshire without any soldiers behind it. Solomon took it as a sign that something was wrong in the kingdom.")
q(56, "The Night Watch", D, 24, "alliance_duskwood",
    "Commander Althea Ebonlocke had sworn to protect the citizens of Darkshire. Stormwind had pulled its guards from their posts and left the Night Watch to its own devices. She wanted the skeletal warriors and mages in {p:Tranquil Gardens}, just south of town, put down.",
    "Stormwind's commissioned guards were gone from Darkshire. Althea Ebonlocke asked anyone who felt worthy to prove it against the skeletons in Tranquil Gardens.",
    "Althea Ebonlocke called the work in Tranquil Gardens splendid and paid for it on behalf of the people of Darkshire.",
    "The skeletons of Tranquil Gardens were fewer, and the Commander of the Night Watch paid a reward in Darkshire's name.")
q(57, "The Night Watch", D, 26, "alliance_duskwood",
    "Althea Ebonlocke was getting reports of an undead infestation in the forest. Skeletal fiends and horrors walked the {p:Raven Hill} graveyard, and more skeletons gathered around Tranquil Gardens. The dead had to be driven from Duskwood.",
    "The graveyards of Raven Hill and Tranquil Gardens were crawling with skeletal fiends and horrors. The Night Watch could not clear them alone, and Althea asked for thirty of them dead.",
    "The people of Darkshire gave their thanks through Althea Ebonlocke, who named the skeleton hunter a great ally of the Night Watch.",
    "Fifteen fiends and fifteen horrors fewer walked the two graveyards. Althea counted it proof of a great ally.")
q(58, "The Night Watch", D, 30, "alliance_duskwood",
    "The situation at Raven Hill was still grim, Althea said, and she did not have enough Watchers to keep Darkshire safe. Plague Spreaders held the eastern mausoleum of the cemetery, and she put the safety of the town in one more pair of hands.",
    "The Night Watch could not guard the town and clear Raven Hill at once. Twenty Plague Spreaders in the eastern mausoleum were the next task Althea Ebonlocke handed out.",
    "Althea gave her thanks on behalf of the people of Darkshire and as leader of the Night Watch. The bravery and dedication shown at Raven Hill had earned them, she said, and she asked the Light to shine on the roads ahead.",
    "The eastern mausoleum had lost its Plague Spreaders. Althea Ebonlocke thanked the one who had cleared it, in Darkshire's name and her own.", 4)

q(179, "Dwarven Outfitters", "Dun Morogh", 1, C,
    "Adlin offered warm gloves in exchange for wolf meat in {p:Coldridge Valley}.",
    "Keeping fingers safe from frostbite began with a practical bargain at Coldridge.",
    "Adlin received the meat and kept his promise of warm gloves.",
    "Wolf meat paid for a little protection against Dun Morogh's cold.")
q(183, "The Boar Hunter", "Dun Morogh", 3, C,
    "Boars had grown so numerous that even the local hunter's daily outing had become dangerous.",
    "Coldridge's angry boars needed thinning before ordinary hunting could resume.",
    "With fewer angry boars about, Talin Keeneye could go back to his leisurely hunting, and said so with thanks.",
    "Talin gave thanks for the thinned herd; his daily hunt would no longer put him in danger.")
q(233, "Coldridge Valley Mail Delivery", "Dun Morogh", 3, C,
    "Letters coming through the pass needed carrying to Talin Keeneye beside the frozen lake.",
    "Coldridge's scattered camps depended on someone finding time to carry the post.",
    "Talin received the letters and found that one belonged farther along the road.",
    "The first delivery reached Talin's camp; another letter still needed forwarding.")
q(234, "Coldridge Valley Mail Delivery", "Dun Morogh", 4, C,
    "One of Talin's letters belonged to Grelin at the camp down the southeastern road.",
    "Grelin's camp was still waiting for its share of the mail from Ironforge.",
    "Grelin received the letter, welcome word from Ironforge after a long wait.",
    "The forwarded post finally reached Grelin's camp.")
q(3364, "Scalding Mornbrew Delivery", "Dun Morogh", 5, C,
    "Durnan's mornbrew needed to reach Anvilmar while it was still hot.",
    "A delayed delivery left only a few minutes to carry hot mornbrew back to Anvilmar.",
    "Durnan received the brew hot enough to enjoy during a short break.",
    "The hurried delivery gave Durnan the scalding cup he had ordered.")
q(282, "Senir's Observations", "Dun Morogh", 5, C,
    "Grelin's report needed passage out of Coldridge, through a tunnel infested with troggs.",
    "Mountaineer Thalos guarded the troubled route between Coldridge and the rest of Dun Morogh.",
    "Thalos allowed the important dispatch through and supplied advice for the dangerous passage.",
    "The report reached the tunnel guard; Senir in Kharanos had yet to receive it.")
q(420, "Senir's Observations", "Dun Morogh", 5, M,
    "Senir waited in Kharanos for his brother's report from Coldridge.",
    "The dispatch from Grelin needed carrying beyond the trogg-infested tunnel.",
    "Senir received his brother's report and considered the report he owed Ironforge.",
    "Coldridge's news reached Kharanos, where Senir was already behind on his own paperwork.")
q(400, "Tools for Steelgrill", "Dun Morogh", 5, M,
    "Steelgrill's siege-engine repairs consumed tools almost as quickly as orders could replace them.",
    "A parcel of tools was waiting for the mechanic at {p:Steelgrill's Depot}.",
    "The tools reached Steelgrill after his last fang-ratchet broke, supplying what the repairs needed.",
    "Steelgrill had replacement tools for work on Pilot Stonegear's siege engine.")
q(317, "Stocking Jetsteam", "Dun Morogh", 6, M,
    "A long Siege Brigade mission required meat for provisions and fur for bedding.",
    "While Steelgrill worked on a tank, its pilot needed supplies gathered from Dun Morogh's snowfields.",
    "By Magni's beard, Bellowfiz said, that was a lot of hunting. Jetsteam had fur for bedding and boar meat for the month-long mission.",
    "Bellowfiz thanked the hunter for the fur and meat; Jetsteam would carry a month's supplies on its Siege Brigade mission.")
q(5541, "Ammo for Rumbleshot", "Dun Morogh", 6, M,
    "A courier fleeing wendigo had abandoned Rumbleshot's ammunition near the Grizzled Den.",
    "Riflemen and mortar crews needed ammunition that had gone missing on the road.",
    "The lost crate reached Rumbleshot, whose customers were already waiting.",
    "Rumbleshot's dwindling stock was replenished with the recovered shipment.")
q(310, "Bitter Rivals", "Dun Morogh", 6, M,
    "Marleth wanted Thunderbrew's customers to taste a rival brew without knowing it.",
    "The rivalry between Barleybrew and Thunderbrew had reached the distillery's cellar.",
    "A barrel of Barleybrew Scalder was slipped among the Thunderbrew barrels.",
    "Marleth's brew took a place in the rival distillery's stock.")
q(384, "Beer Basted Boar Ribs", "Dun Morogh", 7, M,
    "A trapper's enlistment had left the tavern without its usual supply of boar ribs.",
    "Crag boar ribs and Rhapsody Malt were the missing ingredients of a tavern favorite.",
    "The ribs and malt supplied another batch, along with a sample and the family recipe.",
    "The tavern's interrupted supply was filled long enough for more beer-basted ribs.")
q(287, "Frostmane Hold", "Dun Morogh", 9, M,
    "The trolls' cave southwest of Brewnall Village needed closer scouting for an overdue report.",
    "A concentration of Frostmane trolls had kept the first scout from entering their hold.",
    "Senir finished his overdue report at last, praising his own directions, and then had one last favor to ask.",
    "What was found inside the hold went into Senir's report. With it done, he laughed and asked for one more favor.")
q(432, "Those Blasted Troggs!", "Dun Morogh", 9, M,
    "Troggs were wrecking the quarry's equipment and barrels of powder.",
    "A furious quarry worker could no longer shoot well enough to handle the troggs himself.",
    "Losses among the troggs brought the quarry worker some satisfaction, but the damage remained.",
    "The worksite's attackers were cut back without making the quarry secure.")
q(433, "The Public Servant", "Dun Morogh", 11, M,
    "Troggs had driven miners out of Gol'Bolar Quarry and destroyed their equipment.",
    "The Senate and Explorers' League needed an opening to reclaim the quarry for its workers.",
    "The fighting created a possible opening for mountaineers to secure the quarry.",
    "The senator called the work a beginning; rebuilding and the miners' return still lay ahead.")
q(412, "Operation Recombobulation", "Dun Morogh", 10, G,
    "The loss of Gnomeregan had left leper gnomes as well as troggs around the fallen city.",
    "A proposed Recombobulator needed gears and cogs before its makers could try to reverse the leper effect.",
    "The recovered components matched the schematics, but the device still needed work.",
    "The Recombobulator's builders received their parts; a cure had yet to be demonstrated.", 5)
q(267, "The Trogg Threat", "Loch Modan", 12, L,
    "With the Ironforge Reserve called to the Alliance Front, Captain Rugelfuss had too few soldiers to defend Loch Modan. His regiment could not leave the gate, so he sought help against the troggs in the hills.",
    "Captain Rugelfuss's regiment held the gate against invasion while the Ironforge Reserve served at the front. The troggs in the hills still needed facing; he asked for their stone teeth as evidence of the fighting.",
    "Eight trogg teeth were brought back to Rugelfuss. He praised the defense of dwarven lands and declared that King Magni himself would be proud.",
    "Rugelfuss accepted the trogg teeth with thanks for the defense of his people's lands. Such work, he said, would make King Magni proud.")
q(436, "Ironband's Excavation", "Loch Modan", 18, L,
    "Jern Hornhaller in Thelsamar had sent supply after supply to Prospector Ironband's dig at the ancient ruins east of the loch, yet the work had slowed. Ironband was a stout, honest dwarf who valued results, so Jern suspected that something was working against him.",
    "Jern Hornhaller worried that forces were at work against Ironband's excavation. Magmar Fellhew, who managed the details of the site, would know the cause.",
    "Magmar Fellhew said the prospector was writing up a full progress report. For Jern, though, he had the short answer, and it was troggs.",
    "Troggs were behind the slowdown at Ironband's dig, Magmar Fellhew said, and a full report from the prospector was on its way.")
q(298, "Excavation Progress Report", "Loch Modan", 15, L,
    "Ironband's progress report renewed his request for blastpowder.",
    "The excavation needed Thelsamar to understand its troubles with troggs and supplies.",
    "Jern wondered whether Ironband needed the powder for digging or troggs. Either use suited him; what troubled him was the shipment he had sent weeks before.",
    "The report puzzled Jern. He had already sent plenty of blastpowder weeks earlier, and wanted to know where it had gone.")
q(301, "Report to Ironforge", "Ironforge", 15, L,
    "More blastpowder required the Explorers' League's approval in Ironforge.",
    "The excavation's supply problem had to reach Prospector Stormpike in the Assembly of Explorers.",
    "Stormpike received the report and demanded to know where the earlier powder shipment had gone.",
    "Ironforge learned of the shortage, but the missing blastpowder still needed accounting for.")
q(463, "The Greenwarden", "Wetlands", 21, V,
    "Fitzsimmons warned that seeking the Greenwarden in the marsh east of the Dun Modr fork would mean a foolish death.",
    "Fitzsimmons's directions led off the road into the marsh, where the feared Greenwarden was said to dwell.",
    "The Greenwarden offered the name Rethiel. He said the roots and ferns spoke well of his visitor, then asked for help healing the wounded land.",
    "Rethiel welcomed the visitor whom Fitzsimmons had warned away. He spoke of praise from the roots and ferns, then asked for help with the marsh's wounds.")
q(484, "Young Crocolisk Skins", "Wetlands", 22, V,
    "James Halloran the tanner shipped his cured crocolisk skins to ports around the world. He was short of the softer skins that came off the young, and the young crocs swam in the waters just outside {p:Menethil Harbor}.",
    "Halloran paid top coin for a stack of young crocolisk skins. Einar brought him crocolisk skins, but the soft ones he lacked came from the young in the waters outside town.",
    "Halloran called the quality of the skins superb and wanted them in the curing as soon as he could. First, he said, there was other work that might suit.",
    "The young crocolisk skins went to Halloran's curing. He praised them, and had already thought of another job.")

local T, S, B, O, J = "Teldrassil", "alliance_shadowglen", "alliance_teldrassil", "alliance_moonwells", "alliance_darkshore"
q(456, "The Balance of Nature", T, 2, S,
    "Heavy spring rains had left more nightsabers and thistle boars than Shadowglen could feed.",
    "Conservator Ilthalaine sought to keep growing herds from exhausting the forest's food.",
    "The younger beasts were thinned, completing Ilthalaine's first request.",
    "The initial hunt reduced pressure on Shadowglen's food without finishing the conservator's work.")
q(457, "The Balance of Nature", T, 3, S,
    "Ilthalaine still needed the mangy nightsabers and thistle boars thinned after the first hunt.",
    "Shadowglen's limited food required another careful reduction of its growing herds.",
    "Ilthalaine's requested hunt was done, leaving fewer mangy nightsabers and boars to press the forest's food supply.",
    "Ilthalaine accepted the second hunt as service to the forest's balance.")
q(458, "The Woodland Protector", T, 1, S,
    "Tarindrella's unexpected return had drawn the attention of Shadowglen's forest spirits.",
    "Melithar wanted to know what had brought the dryad back near Aldrassil.",
    "Tarindrella was found, with news of the trouble that had brought her back.",
    "Melithar's request led to the woodland protector; the reason for her concern still needed investigating.")
q(459, "The Woodland Protector", T, 3, S,
    "Tarindrella suspected Fel Moss had tainted the grells and the forest's former neighbors.",
    "The abandoned furbolg homes and the grells near Shadowglen pointed to spreading corruption.",
    "The Fel Moss confirmed Tarindrella's fears about the grells' corruption.",
    "Evidence from the grells deepened concern for the Gnarlpine furbolgs.", 4)
q(3521, "Iverron's Antidote", T, 4, S,
    "Dirania needed mushrooms, moonpetal lilies and Webwood ichor to counter Iverron's poison.",
    "The spiders' own ichor was one ingredient in the antidote for their victim.",
    "Dirania received the ingredients and could prepare the antidote.",
    "The remedy's ingredients were ready; the medicine still had to reach Iverron.")
q(3522, "Iverron's Antidote", T, 4, S,
    "Dirania's prepared antidote would remain effective for only a few minutes.",
    "Iverron needed the freshly mixed remedy before it lost its strength.",
    "Iverron drank the antidote and began to feel better, though he still needed rest.",
    "The medicine reached Iverron in time; recovery had begun beside the spider-haunted woods.", 4)
q(2159, "Dolanaar Delivery", T, 5, B,
    "Business in Shadowglen kept Porthannius from carrying his herbs to Dolanaar himself.",
    "Innkeeper Keldamyr was expecting a package of herbs from Shadowglen.",
    "The herbs reached Dolanaar's inn, and Keldamyr offered a welcome to the messenger.",
    "Porthannius's package arrived at the inn while his work kept him in Shadowglen.")
q(488, "Zenn's Bidding", T, 5, B,
    "Zenn Foulhoof offered rewards for fangs, owl feathers and spider silk gathered in the forest.",
    "The satyr kept his purposes private while asking for reagents from Teldrassil's wildlife.",
    "Zenn received the reagents and gloated over having his bidding done.",
    "The bargain supplied the satyr, whose thanks came with mockery.")
q(2438, "The Emerald Dreamcatcher", T, 6, B,
    "An emerald dreamcatcher had been left in a dresser in corrupted Starbreeze Village.",
    "Furbolgs kept the owner from retrieving a treasured gift from the warden of Ban'ethil.",
    "The dreamcatcher was returned to Tallonkai, who treasured it as a gift granted to very few.",
    "The recovered dreamcatcher brought heartfelt thanks, for its owner had been one of the few to receive such a gift.")
q(4161, "Recipe of the Kaldorei", T, 7, B,
    "A lesson in kaldorei cooking called for seven spider legs and no more.",
    "The recipe was taught with a reminder to take only what the forest could spare.",
    "The requested legs were gathered, completing a practical lesson in the kaldorei tradition of balance.",
    "The cooking task was finished with its teacher's reminder about the living forest.")
q(483, "The Relics of Wakening", T, 9, B,
    "Gnarlpine invaders endangered the sleeping druids in {p:Ban'ethil Barrow Den}.",
    "Four sacred relics were needed before the druids' hibernation ritual could be safely broken.",
    "The recovered relics made preparations for the awakening ritual possible.",
    "The four relics were brought out of Ban'ethil before the sleeping druids' situation grew worse.", 5)
q(932, "Twisted Hatred", T, 8, B,
    "Lord Melenas had gathered grell warriors in Fel Rock, uncomfortably close to Dolanaar.",
    "The satyr in Fel Rock was a threat Tallonkai wanted handled quietly.",
    "Tallonkai received proof of Melenas's death with relief; the satyr in nearby Fel Rock had occupied him long enough.",
    "With Melenas dead, Tallonkai could turn his attention from the satyr who had gathered grell so close to home.", 4)
q(98403, "Twisted Hatred", T, 12, B,
    "Tallonkai traced Melenas's work to Xethorr the Wicked and spiders twisted for a further scheme.",
    "Xethorr's brood in the Cleft might hold evidence of the substance corrupting Teldrassil's creatures.",
    "The recovered substance gave Tallonkai an older sample to examine in secrecy.",
    "Evidence from Xethorr's work reached Tallonkai, who chose to keep the investigation quiet.", 5)
q(921, "Crown of the Earth", T, 5, O,
    "Tenaron began with the cost of victory at Mount Hyjal. Nordrassil's power had been spent against Archimonde and the Burning Legion; now he sent for water from the moonwell north of Aldrassil.",
    "The moonwell north of Aldrassil was the first stop in Tenaron's account of his people's recent history. Nordrassil stood diminished after its power had helped defeat Archimonde at Hyjal.",
    "The phial returned to Tenaron, who spoke of the wells as shrines to Elune. Their waters carried ancient magic from the Well of Eternity.",
    "Tenaron received the moonwell water and spoke of the power it carried from the Well of Eternity. Druids drew on that power, but sorcery remained forbidden.")
q(928, "Crown of the Earth", T, 5, O,
    "Tenaron's vessel of moonwell water needed carrying to Corithras in Dolanaar.",
    "The work begun in Shadowglen continued with the druid at Dolanaar's moonwell.",
    "Corithras received Tenaron's water and prepared to continue the task.",
    "The vessel reached Dolanaar; more moonwells still needed attending to.")
q(929, "Crown of the Earth", T, 5, O,
    "The moonwell outside Starbreeze supplied water for the druids' work in Darnassus.",
    "Corithras needed another specially filled phial before continuing his account of Mount Hyjal's aftermath.",
    "The Starbreeze water was gathered, and Corithras spoke of the night elves' lost immortality.",
    "Another phial accompanied an account of Nordrassil's sacrifice and the uncertain years that followed.")
q(933, "Crown of the Earth", T, 9, O,
    "Hostile Gnarlpine made the moonwell beside the Pools of Arlithrien harder to reach safely.",
    "The Sentinels were struggling to patrol the country around another of Teldrassil's moonwells.",
    "The phial returned with occasion for Corithras to recount Staghelm's role in growing Teldrassil.",
    "Arlithrien's waters joined the collection, and the telling reached the creation of the new World Tree.")
q(7383, "Crown of the Earth", T, 11, O,
    "The moonwell under the Oracle Tree was the last and most powerful well in Corithras's task.",
    "Teldrassil's new home had not restored the immortality lost at Mount Hyjal.",
    "The Oracle Glade water returned, and Corithras explained the dragon blessings Teldrassil had been denied.",
    "The final moonwell sample accompanied the explanation of Teldrassil's flawed growth.", 4)
q(935, "Crown of the Earth", "Darnassus", 11, O,
    "The collected moonwell waters were bound for Fandral Staghelm in Darnassus.",
    "Corithras hoped the Arch Druid's work would help with Teldrassil's troubled growth.",
    "Fandral received the waters for his work; Teldrassil's troubles were not resolved.",
    "The vessel reached the druid grove, completing delivery to the Arch Druid.", 4)
q(98046, "Crown of the Earth", "Darnassus", 11, O,
    "Fandral dismissed the phial after finding no answer in its waters.",
    "The Arch Druid wanted the vessel taken to a priestess in the Temple of the Moon.",
    "The priestess found drops still in the phial and questioned whether they explained the failed incantation.",
    "The discarded vessel reached the temple with sacred water still inside.", 4)
q(98065, "Crown of the Earth", "Darnassus", 11, O,
    "The remaining water was placed in a ceremonial vessel for Tyrande.",
    "The temple's priestess wanted the saved drops brought to the High Priestess.",
    "Tyrande accepted the sacred water and distinguished Fandral's druidic office from her leadership of Darnassus.",
    "The saved water reached Tyrande, who gave thanks for preserving it.", 5)
q(954, "Bashal'Aran", "Darkshore", 12, "alliance_bashalaran",
    "Demons infested Bashal'Aran but avoided a shrine surrounded by a strange blue aura.",
    "The unexplained shrine stood apart from the grells and satyrs feeding on the ruins' magic.",
    "The shrine's spectral prisoner had been found amid the ruins.",
    "The shrine's inhabitant was found; the means of his imprisonment remained to be investigated.")
q(955, "Bashal'Aran", "Darkshore", 12, "alliance_bashalaran",
    "The prisoner hoped the grells' earrings would reveal a trace of the seal binding him.",
    "Finding the enchanted seal required evidence from creatures living around the shrine.",
    "The earrings showed that the grells had recently touched the seal, though they did not hold it.",
    "The gathered earpieces narrowed the search for the seal without freeing the prisoner.")
q(956, "Bashal'Aran", "Darkshore", 13, "alliance_bashalaran",
    "The search for the prison's seal pointed to the satyrs leading the grells.",
    "The shrine's captive believed one of the satyrs possessed the object that bound him.",
    "The binding seal was recovered, but still had to be destroyed.",
    "The prisoner held the instrument of his confinement; freedom was another step away.")
q(957, "Bashal'Aran", "Darkshore", 13, "alliance_bashalaran",
    "Only the ancient blue flame at Ameth'Aran could destroy the Highborne seal.",
    "The way to break Bashal'Aran's prison lay in its sister ruins to the south.",
    "The seal's destruction freed the prisoner, whose thoughts turned toward his former master.",
    "The shrine no longer bound its captive after the seal was burned in Ameth'Aran's flame.", 5)
q(958, "Tools of the Highborne", "Darkshore", 12, J,
    "The spirits of Ameth'Aran still wielded ancient magical implements.",
    "The Highborne relics were wanted for destruction, lest their old magic cause more harm.",
    "The recovered implements were handed over to be destroyed.",
    "The dangerous relics were collected from the ruins for disposal.")
q(1001, "Buzzbox 411", "Darkshore", 12, J,
    "Wizbang's beachside Buzzbox required thresher eyes, according to its crackling instructions.",
    "A tiny voice from Buzzbox 411 asked for materials from the threshers offshore.",
    "The eyes went into the machine, which hummed to life with another message from Wizbang.",
    "Buzzbox 411 accepted its requested materials and produced the next instructions.")
q(1002, "Buzzbox 323", "Darkshore", 14, J,
    "The next Buzzbox stood near a bridge north of Auberdine and called for moonstalker fangs.",
    "Wizbang's increasingly unsteady instructions named six fangs for Buzzbox 323.",
    "The machine ground the supplied fangs and relayed Wizbang's next message.",
    "Buzzbox 323 processed the delivery, leaving another job farther along the road.")
q(1003, "Buzzbox 525", "Darkshore", 16, J,
    "A Buzzbox south of Auberdine awaited scalps from grizzled thistle bears.",
    "Wizbang's final request came through a machine that boiled and dripped as it spoke.",
    "Wizbang admitted that the Buzzboxes brewed liquor as well as carrying messages.",
    "The delivery exposed the other purpose of Wizbang's machines. They were brewing and distilling liquor.")
q(2118, "Plagued Lands", "Darkshore", 14, J,
    "A sickness had turned Darkshore's thistle bears rabid, and Tharnariun hoped to find a cure.",
    "A temporary calming trap offered a way to bring a sick bear back for study.",
    "The trapped bear reached Tharnariun, allowing the investigation to begin.",
    "A living afflicted animal was brought back; whether a cure would work remained unknown.", 4)
q(2138, "Cleansing of the Infected", "Darkshore", 16, J,
    "Tharnariun's attempted cure had failed, leaving rabid thistle bears a danger to the forest.",
    "The sick bears had to be culled to slow the damage, though that would not end the plague.",
    "The cull reduced the immediate danger without stopping the sickness.",
    "Auberdine gained a little respite from the rabid bears; the plague remained unresolved.", 4)
q(3524, "Washed Ashore", "Darkshore", 13, J,
    "The Temple of the Moon was investigating the increasing number of creatures stranded on Darkshore's coast.",
    "Greymist murlocs surrounded a beached creature south of Auberdine, obstructing a search for samples.",
    "The recovered bone sample was readied for study in Darnassus.",
    "The temple's investigator received bones from the stranded creature, opening further research.")
q(4681, "Washed Ashore", "Darkshore", 14, J,
    "Another dead creature lay underwater west of Auberdine, near a sunken vessel.",
    "The coastal deaths extended beyond the first beached animal, and the temple needed more evidence.",
    "The new sample strengthened the report, but the cause of the strandings remained uncertain.",
    "The investigation gained more remains to study without yet explaining the deaths.")

-- Connected errands and investigations. Evidence is the complete quest,
-- progress and completion block for each ID, including unfinished promises.
P.threads.alliance_defias = "the search for the Defias leadership"
P.threads.alliance_hermit = "the hermit's requests from Raven Hill"
P.threads.alliance_lovers = "the letters between the feuding farms"
P.threads.alliance_crystal = "the red crystal above Auberdine"
local DF, HM, LV, RC = "alliance_defias", "alliance_hermit", "alliance_lovers", "alliance_crystal"
q(15, "Investigate Echo Ridge", E, 3, N,
    "McBride's scouts had underestimated the kobolds. Workers had gathered near Echo Ridge Mine, and he ordered them driven back.",
    "Kobold workers had camped near Echo Ridge Mine in greater numbers than Northshire's scouts expected.",
    "The workers were struck down, but the report left McBride uneasy about the kobolds still in his mine. He asked for another return to Echo Ridge.",
    "McBride paid for the attack on the workers. The news of more kobolds in Echo Ridge drew another order to return to the mine.")
q(21, "Skirmish at Echo Ridge", E, 5, N,
    "Inside Echo Ridge Mine, the kobolds were digging themselves a deeper foothold in Northshire.",
    "McBride feared that every delay would strengthen the kobolds' hold on Echo Ridge. He ordered another attack inside the mine.",
    "The skirmish earned McBride's respect. He would gather others against the remaining kobolds, with further work waiting beyond the mine.",
    "McBride praised the fighting inside Echo Ridge and promised to send others against the kobolds left there. Northshire had more demands to make.")
q(11, "Riverpaw Gnoll Bounty", E, 10, F,
    "Gnoll packs near Westbrook and Stone Cairn Lake outnumbered the available guards.",
    "Painted armbands served as proof for the Army's bounty on Elwynn's gnolls.",
    "Deputy Rainer took the painted armbands as proof against a pack too large for his guards. The army's thanks followed.",
    "The Riverpaw armbands reached Westbrook, where Rainer paid the army's bounty on gnolls his garrison could not handle alone.")
q(86, "Pie for Billy", E, 6, F,
    "Billy offered information about the missing necklace in exchange for a pork belly pie.",
    "Bernice's search for her necklace had become a kitchen errand, boar meat for the pie the boy demanded.",
    "Bernice received the meat for a pie, though she objected to feeding the suspected thief.",
    "The tough boar meat supplied Bernice's part of the bargain; Billy still had to be coaxed into talking.")
q(84, "Back to Billy", E, 6, F,
    "Bernice's pie was ready for Billy, along with a less generous message from its baker.",
    "A pork belly pie stood between Billy's claimed hunger and news of the lost necklace.",
    "Billy ate the pie and announced that his memory was returning.",
    "The food reached Billy, making him more willing to explain what had happened.")
q(87, "Goldtooth", E, 8, F,
    "Billy's account placed the necklace with a gold-toothed kobold inside Fargodeep Mine.",
    "The missing keepsake had passed from the farms into the occupied mine.",
    "Bernice received her necklace and offered a keepsake of her late husband's in thanks.",
    "The necklace came back to its owner, ending a search that had begun with accusations between neighbors.", 4)
q(106, "Young Lovers", E, 6, LV,
    "The feud between the Maclures and Stonefields kept Maybell and Tommy Joe apart.",
    "Maybell had a letter for Tommy Joe, who waited near the river by his family's farm.",
    "Maybell's letter reached Tommy Joe, who still needed a way to see her.",
    "The message crossed the divide between the farms, although the family feud continued.")
q(111, "Speak with Gramma", E, 6, LV,
    "Tommy Joe hoped his grandmother could find a way around the families' quarrel.",
    "The young lovers' problem needed an ally inside the Stonefield household.",
    "Gramma considered how to bring the pair together for a little while.",
    "The appeal reached Gramma, who began looking for a temporary way past the feud.")
q(107, "Note to William", E, 6, LV,
    "Gramma thought William Pestle might have a potion that could help the lovers.",
    "A note from the Stonefield farm was bound for William at Goldshire's inn.",
    "William received Mildred's note and began considering how to help.",
    "The request reached the alchemist; a suitable remedy still had to be prepared.")
q(112, "Collecting Kelp", E, 7, LV,
    "William needed crystal kelp to make invisibility liquor for Maybell.",
    "The murlocs near Crystal Lake sometimes carried the ocean kelp needed for the potion.",
    "The kelp reached William, who set about mixing the liquor.",
    "The ingredients were gathered for Maybell's disguise; delivery remained ahead.")
q(114, "The Escape", E, 7, LV,
    "William's invisibility liquor was meant to let Maybell slip away from the vineyards.",
    "The potion offered Maybell a brief chance to visit Tommy Joe without her family's knowledge.",
    "Maybell accepted the liquor and planned to drink it when she had the chance.",
    "The potion reached Maybell; her promised visit to Tommy Joe was still to come.", 4)
q(22, "Goretusk Liver Pie", W, 12, H,
    "Salma's crust was baked and her gravy simmering; only the goretusk livers were missing.",
    "At the Saldeans' farm, herbs and onions waited on the last ingredient for a meat pie.",
    "The livers completed Salma's preparations for the household's meal.",
    "Salma accepted the ingredients and made sure the work earned something to eat.")
q(64, "The Forgotten Heirloom", W, 12, H,
    "The Furlbrows had fled their farm so quickly that a wedding pocket watch remained in the wardrobe.",
    "Thieves held the farmhouse where Farmer Furlbrow had left a gift from Verna's father.",
    "The pocket watch returned to Furlbrow, one family possession recovered after the loss of the farm.",
    "Furlbrow received the wedding keepsake that the hurried departure had left behind.", 4)
q(151, "Poor Old Blanchy", W, 14, H,
    "The Furlbrows' broken wagon had left Blanchy waiting longer than her last feed could cover.",
    "Oats still lay around Westfall's farms, beyond the old horse and her stranded owners.",
    "The gathered oats supplied Blanchy's next feed.",
    "Verna received food for Blanchy while the family's journey remained delayed.")
q(65, "The Defias Brotherhood", R, 18, DF,
    "Stoutmantle needed a name and a hiding place behind the raids that had emptied Westfall's farms.",
    "Wiley in Lakeshire owed Stoutmantle a favor and might know something about the Defias.",
    "Wiley, a rogue at the Lakeshire inn, heard that Stoutmantle had sent someone, and admitted he owed him.",
    "Wiley recognized the request from Westfall; the investigation had found its first contact.", 4)
q(132, "The Defias Brotherhood", W, 18, DF,
    "Wiley's note described Defias dealings with gnolls, kobolds and goblins.",
    "The information from Lakeshire needed to reach Stoutmantle before the militia could follow it.",
    "Stoutmantle received Wiley's information and recognized its importance.",
    "The note reached Sentinel Hill, giving the militia more than rumors to pursue.", 4)
q(135, "The Defias Brotherhood", "Stormwind City", 18, DF,
    "Wiley's mention of the Stonemasons raised a question that Mathias Shaw might answer.",
    "The investigation led to SI:7 in Old Town, with Wiley's note as the evidence.",
    "Shaw received the note and judged the matter more complicated than Stoutmantle realized.",
    "The Defias inquiry reached Stormwind's intelligence service, where the old guild connection needed examining.", 4)
q(141, "The Defias Brotherhood", W, 18, DF,
    "Shaw's account named Edwin VanCleef, whose Stonemasons had rebuilt Stormwind after the First War.",
    "The dispute after Stormwind's reconstruction offered a possible explanation for the Defias leadership.",
    "Stoutmantle received Shaw's account but wanted firmer proof of VanCleef's involvement.",
    "VanCleef's name reached the militia, turning the search toward a specific suspect.", 4)
q(142, "The Defias Brotherhood", W, 18, DF,
    "A Defias messenger travelled the roads between Moonbrook and Westfall's mines and quarry.",
    "The messenger's papers might supply the proof Stoutmantle still lacked.",
    "The recovered information confirmed VanCleef's command, while the hideout's location remained to be found.",
    "Stoutmantle had proof of the leader's identity and a captured thief who offered to reveal the hideout.", 4)
q(155, "The Defias Brotherhood", W, 18, DF,
    "A captured thief had traded the Defias hideout's location for protection from his former allies.",
    "The militia's guide needed to survive long enough to show where VanCleef was hiding.",
    "The escort revealed the hideout's location to the militia.",
    "Stoutmantle received the location he needed; confronting VanCleef was still ahead.", 5)
q(166, "The Defias Brotherhood", W, 22, DF,
    "With the hideout found, Stoutmantle ordered VanCleef's death on behalf of Westfall's militia.",
    "The search for the Defias leadership had reached the man the militia held responsible.",
    "VanCleef's death was confirmed, and the militia acknowledged the service to Westfall.",
    "The Defias had lost VanCleef; Stoutmantle hoped this would begin a recovery for the troubled farms.", 6)
q(125, "The Lost Tools", R, 16, K,
    "An orc catapult had sunk a boat carrying tools after the broken bridge stopped the wagon delivery.",
    "A toolbox lay on the bed of Lake Everstill while Lakeshire struggled to obtain supplies.",
    "Foreman Oslow had never thought to see his tools again. The toolbox came up from the bed of Lake Everstill, and he paid well for it.",
    "The toolbox came back from the bottom of the lake, and Oslow praised the recovery.")
q(127, "Selling Fish", R, 21, K,
    "Lake Everstill was famous for its spotted sunfish, and Dockmaster Baren's stock was running low.",
    "The lake's fish supplied another kind of work beside Lakeshire's military requests.",
    "The batch of spotted sunfish restocked Baren's dock, and he bartered well for it.",
    "When the sunfish arrived, Baren called it a pleasure doing business.")
q(129, "A Free Lunch", R, 15, K,
    "Darcy had prepared lunch for Guard Parker, but his patrol road was dangerous for townspeople.",
    "Parker's duty on the road toward Duskwood kept him away from the meal waiting in town.",
    "Darcy's lunch reached Parker on patrol.",
    "The guard received a meal during the work of defending Lakeshire from orcs and gnolls.")
q(130, "Visit the Herbalist", R, 15, K,
    "Parker wanted flowers sent back to Darcy in return for her lunch.",
    "The guard's errand led to Martie's herbalist shop, with a request to keep the bouquet's destination quiet.",
    "The request for flowers reached Martie, who took an interest in the possible courtship.",
    "The herbalist was asked for a bouquet; Darcy had yet to receive it.")
q(131, "Delivering Daffodils", R, 15, K,
    "Martie had chosen daffodils for the bouquet meant for Darcy.",
    "Parker's thanks were travelling back to town in the form of the herbalist's favorite flowers.",
    "Darcy received the flowers and supplied the promised meal, though Martie's choice raised her suspicions.",
    "The bouquet reached Darcy, bringing a little household rivalry into the lunch errand.")
q(3741, "Hilary's Necklace", R, 15, K,
    "A necklace had disappeared while Hilary and her friend were fishing beside the lake.",
    "Hilary's father had given her the missing necklace; the children were forbidden to swim after it.",
    "Hilary received her necklace back from the lake.",
    "The small keepsake returned to Hilary, who thanked the finder on behalf of herself and her cat.", 4)
q(5, "Jitters' Growling Gut", D, 20, "alliance_duskwood",
    "Jitters had been hiding in the ghost town of {p:Raven Hill} for weeks on nothing but grubs and weeds. He would pay handsomely for a feast, and he had heard that Chef Grual at the Scarlet Raven made very good Dusky Crab Cakes.",
    "After weeks of grubs and weeds, Jitters had heard good things of Chef Grual's crab cakes. He offered good pay for anyone who fetched him a decent meal from Darkshire.",
    "Chef Grual heard that someone wanted crab cakes, and allowed that he might be able to cook some up.",
    "Jitters' order reached the Scarlet Raven, where Grual thought he might manage a batch of Dusky Crab Cakes.")
q(93, "Dusky Crab Cakes", D, 20, "alliance_duskwood",
    "Grual let slip his secret. Dusky Crab Cakes were made from spider legs, disgusting but tangy. He wanted gooey legs from the Venom Web Spiders that nested north of town between the foothills and the river.",
    "The crab in Grual's crab cakes was spider. He sent for gooey legs from the Venom Web Spiders to the north and promised to whip up a batch.",
    "Grual admired the clutch of legs, seasoned them with his secret spices where no one could look, and set them skittering on a skillet. The recipe he gave away was for a different dish, almost as good.",
    "The spider legs went into Grual's secret seasoning and onto the skillet. He kept the crab cake recipe to himself and handed over another nearly as good.")
q(165, "The Hermit", D, 25, HM,
    "Elaine Carevin had not seen the old man from the shack above {p:Raven Hill} cemetery in some time. He used to come into town for supplies often. She thought someone ought to see whether anything was amiss.",
    "An old man who once shopped in Darkshire had stopped coming. Elaine Carevin remembered his shack overlooking the Raven Hill cemetery.",
    "Nothing was wrong, the hermit said with a chuckle at the Carevins' name. The roads had grown dangerous and he was not getting younger, and perhaps an old man could be done a few favors.",
    "The old man at Raven Hill was well, only too old for the dangerous roads into town. He asked for a few favors instead.")
q(148, "Supplies from Darkshire", D, 24, HM,
    "The hermit called himself too old and feeble for the walk to Darkshire. He wanted Ghost Hair Thread from Madame Eva, who kept her home on the town square.",
    "The first errand was a spool of Ghost Hair Thread from Madame Eva in Darkshire. The old man said he could never make the trip himself.",
    "Madame Eva had no Ghost Hair Thread in stock. She could make some, she said, if someone brought her the ghost hair.",
    "Eva knew what the hermit wanted and had none of it. The thread would have to be made, and the hair found first.")
q(149, "Ghost Hair Thread", D, 24, HM,
    "A poor, sad spirit called Blind Mary haunted an old farmhouse in the hills south of Darkshire. Eva gave a Spectral Comb to offer her, with a warning that dark things now lurked near the house.",
    "Eva's ghost hair had to come from Blind Mary, the spirit of the farmhouse south of town. The Spectral Comb was for her hair.",
    "Blind Mary begged not to be looked at. Then she took the comb and found it lovely, gliding through hair she called a stiff and stringy horror, and she wished for a mirror.",
    "Mary said she had torn out her own eyes and could still feel the gaze on her. The Spectral Comb glided through her hair, and she wished she had a mirror.")
q(154, "Return the Comb", D, 24, HM,
    "Mary's pleasure in the comb did not last. She cried out to have it taken away, calling herself a monster no one would ever think lovely again.",
    "Blind Mary wanted the Spectral Comb taken away from her. It carried her hair now, and Eva was waiting for it.",
    "Eva could make a spool of Ghost Hair Thread from the comb and had a few strands to spare. She paid some coins for the extra.",
    "The comb came back to Madame Eva full of Blind Mary's hair. There was enough for the hermit's spool and a little over, which Eva paid for.")
q(157, "Deliver the Thread", D, 24, HM,
    "Eva handed over the thread and said it had a thousand uses, from binding evil spirits to sewing life into inanimate objects. The hermit wanted it strung along his door and windows against unwanted spirits.",
    "The spool of Ghost Hair Thread was ready for the shack at Raven Hill. The old man had asked for it to keep spirits out.",
    "The hermit called the thread delightful and said it would do splendidly. He paid for what he called an honorable deed.",
    "Eva's spool reached Raven Hill. The hermit was delighted with it and paid at once.")
q(158, "Zombie Juice", D, 24, HM,
    "The hermit wanted a bottle of Zombie Juice from Tavernkeep Smitts at the Scarlet Raven. The nights got cold, he said, and he needed the drink to put fire back in his veins.",
    "Another errand for the old man at Raven Hill, this time a liquor called Zombie Juice from the Scarlet Raven in Darkshire.",
    "Smitts called Zombie Juice strong stuff. He did not often get requests for it, he said.",
    "Tavernkeep Smitts knew the liquor, though few people ever asked him for it.")
q(156, "Gather Rot Blossoms", D, 24, HM,
    "Smitts could brew a batch of Zombie Juice from rot blossoms, which grew in strange places. Among them were the skulls of the Skeletal Horrors and Fiends at Raven Hill and Tranquil Gardens. Killing a few skeletons on the way, he said, would please Darkshire.",
    "The rot blossoms for Smitts's Zombie Juice grew inside the skulls of Duskwood's skeletons. He had never got close enough to look himself.",
    "Smitts took the rot blossoms and promised to tell Althea Ebonlocke of the Night Watch about the skeletons killed. Any help stemming the tide of fiends was welcome news in Darkshire, he said.",
    "The rot blossoms reached Smitts along with word of fewer skeletons in the graveyards. He meant to pass that on to Althea Ebonlocke.")
q(159, "Juice Delivery", D, 24, HM,
    "Smitts handed over the Zombie Juice with a warning. It was strong enough to raise the dead.",
    "The bottle for the hermit was ready at the Scarlet Raven, and Smitts said to be careful with it.",
    "The hermit gave a thousand thanks and said the kindness warmed an old man's heart, after starting to say something else. He paid a token of his gratitude.",
    "The Zombie Juice reached the shack above the cemetery. The hermit started to call the errand foolish and changed it to kind before he paid.")
q(133, "Ghoulish Effigy", D, 27, HM,
    "The hermit marveled that the ghouls and walking dead had not eaten him so far from town. A pack of Bone Chewers had pounded on his walls the day before. He wanted ghoul ribs for an effigy, a scarecrow against ghouls.",
    "Ghoul ribs from the Flesh Eaters, Bone Chewers, Brain Eaters, Rotted Ones and Plague Spreaders of Duskwood would build the hermit's effigy. He thought he could hear a pack behind the house already.",
    "The hermit thanked the bearer of the ribs and said they would do just the trick.",
    "The ghoul ribs reached the shack for the effigy, and the hermit was satisfied with them.")
q(134, "Ogre Thieves", D, 30, HM,
    "A few weeks earlier, ogres had chased the hermit off while he picked herbs far from home. He had left behind a crate of precious tools and herbs. The ogres had swaggered back to the ogre mound in southern Duskwood, and he was sure the crate lay near it.",
    "The hermit missed his crate sorely. It had gone with the ogres to their mound in southern Duskwood.",
    "The hermit started to thank someone else, caught himself, and thanked the bearer instead. Happy nights lay ahead, he said, and the reward was more than earned.",
    "The crate of tools and herbs came back from the ogre mound. The hermit's thanks slipped once before they landed, and he spoke of happy nights ahead.")
q(160, "Note to the Mayor", D, 30, HM,
    "The hermit sent a note to Mayor Ello Ebonlocke, claiming they were old friends.",
    "After his supply errands, Abercrombie wanted a letter carried into Darkshire.",
    "Ello did not recognize Abercrombie's name and could not read the letter's ancient language.",
    "The mayor received the note, but its unreadable writing left the hermit's purpose unresolved.", 4)
q(218, "The Stolen Journal", "Dun Morogh", 5, C,
    "A marked troll had carried Grelin's notebook into the cave.",
    "Grelin's report for Senir could not be finished until the notebook the trolls had taken came back.",
    "The notebook came back to Grelin, who could now finish the report intended for Senir.",
    "The stolen pages returned, leaving the report's journey out of the valley still ahead.", 4)
q(311, "Return to Marleth", "Dun Morogh", 7, M,
    "A barrel of Thunder Ale served as proof of the switch in the Kharanos distillery cellar.",
    "Marleth's brewing prank still needed its evidence brought back from the rival cellar.",
    "Marleth accepted the barrel as proof that the switch had been made.",
    "The cellar errand earned Marleth's thanks, settling one small turn in the brewers' rivalry.")
q(315, "The Perfect Stout", "Dun Morogh", 9, M,
    "A brewer wanted to try the Frostmane trolls' shimmerweed in a new stout.",
    "The plant grown high in the eastern hills offered an unusual flavor for a brewing experiment.",
    "The shimmerweed arrived in time for experiments with the brewer's recipes.",
    "The new ingredient reached the brewery; the perfect stout was still a possibility to test.")
q(319, "A Favor for Evershine", "Dun Morogh", 8, M,
    "Bears, cats and boars wandered close enough to Brewnall to interrupt its craftspeople.",
    "A cask of Evershine depended on helping the village with the animals around its snowy outskirts.",
    "The hunt gave Brewnall's workers fewer growls and snorts to contend with outside the village.",
    "Rejold handed over the cask of Evershine, glad the village could work its crafts without so many growls outside.")
q(320, "Return to Bellowfiz", "Dun Morogh", 8, M,
    "The cask of Evershine was ready to travel from Brewnall to Bellowfiz.",
    "The brewing errand still needed its final delivery after the work around the village.",
    "Bellowfiz received the Evershine and decided to open a bottle.",
    "The Evershine reached Bellowfiz at the depot, warmth for the cold road and fuel for Jetsteam's furnace.")
q(418, "Thelsamar Blood Sausages", "Loch Modan", 11, L,
    "Vidra fed children and excavation workers with sausages made from the loch's surrounding wildlife.",
    "Bear meat, boar intestines and spider ichor were the ingredients waiting to become a Thelsamar meal.",
    "Vidra received the supplies and shared the sausage recipe along with instructions to eat them fresh.",
    "The ingredients reached Thelsamar's kitchen, where the recipe became part of the payment for gathering them.")
q(455, "The Algaz Gauntlet", "Wetlands", 21, V,
    "The Dragonmaw clan had a haven in the Wetlands and had now pushed into Dun Algaz. If they kept the pass, Rockgar warned, Loch Modan would be cut off from Menethil Harbor. He wanted someone to break through to the Wetlands, kill some orcs on the way and report to Valstag Ironjaw.",
    "Rockgar's scouting mission had become a fight through Dun Algaz. Beyond it the road ran north, then west at the fork to Menethil, where Valstag Ironjaw waited for a report.",
    "Valstag found the report full of bad news. The Dragonmaw usually hid in the hills, he said, and what had driven them into Algaz was still a mystery. He expected to want more help against them.",
    "In Menethil, Valstag Ironjaw heard that the Dragonmaw were moving in strength into Algaz. He could not say why, and he had more work in mind against them.", 4)
q(279, "Claws from the Deep", "Wetlands", 22, V,
    "Gobbler and the Bluegill murlocs raided merchants before withdrawing to their waterside hovels.",
    "The Merchant Marines offered payment against murlocs harassing the port's fishers and traders.",
    "The contract against Gobbler and his kin was fulfilled and paid by the Merchant Marines.",
    "Proof of Gobbler's death settled the contract against one threat to Menethil's commerce.")
q(931, "The Shimmering Frond", T, 10, B,
    "A plant with shimmering fronds offered Denalan a specimen unlike the ordinary forest growth.",
    "The frond's twisting sheen made it an unusual sample for Teldrassil's botanical work.",
    "Denalan recognized a plant he had seen decades earlier in the Swamp of Sorrows and prepared a test.",
    "The specimen reached Denalan, who wondered how such a plant had grown so large in Teldrassil.")
q(937, "The Enchanted Glade", T, 11, B,
    "Harpies nesting near the Oracle Tree had killed its messenger to Darnassus.",
    "The Sentinels at the glade were slowly pushing back the nests around the Oracle Tree.",
    "The returned belts proved help against the harpies, and the Sentinel pointed out new bark shed by the tree.",
    "The glade's defenders received proof of the fighting; the Oracle Tree had a further task waiting.")
q(2541, "The Sleeping Druid", T, 8, B,
    "Gnarlpine magic had trapped a druid's spirit in the Emerald Dream while his body attacked intruders in Ban'ethil.",
    "A charm carried by the Gnarlpine shamans might explain the enchantment on the sleeping druid.",
    "The druid examined the recovered charm and recognized the strength of its enchantment.",
    "The charm supplied a means of studying the spell; the druid was still bound by it.", 4)
q(2561, "Druid of the Claw", T, 10, B,
    "The druid's only answer to the Gnarlpine spell was the death of his animated body, followed by use of the charm.",
    "Deep in Ban'ethil, the stolen body had to be stopped before its spirit could escape the shamans' control.",
    "The druid was freed from the Gnarlpine and could rest in the Emerald Dream.",
    "The spell's hold ended with the body's death and the charm's use, leaving the spirit free.", 5)
q(1141, "The Family and the Fishing Pole", "Darkshore", 14, J,
    "Gubber Blump's family fishing tradition had run into trouble with murlocs keeping boats ashore.",
    "Darkshore grouper were worth a Blump family fishing pole to Gubber.",
    "Gubber accepted the grouper and judged the catch worthy of a family fishing pole.",
    "The fishing supplied Gubber's request and earned his recognition of a good catch.")
q(4811, "The Red Crystal", "Darkshore", 14, RC,
    "Reports of a red crystal drew attention to the growing numbers of hostile moonkin east of Auberdine.",
    "A strange object in the eastern mountains might explain why moonkin were gathering there.",
    "The scouting report confirmed the crystal's existence without explaining its nature.",
    "Glynda had confirmation of the red crystal, and more questions about its connection to the moonkin.", 4)
q(4812, "As Water Cascades", "Darkshore", 14, RC,
    "Auberdine's moonwell water offered a way to examine the strange red crystal.",
    "Glynda suspected a connection to Felwood and urged care while testing the crystal with sacred water.",
    "The moonwell water made the crystal's opaque surface transparent.",
    "Water ran down the crystal's lattice, opening a view through its formerly clouded surface.", 4)
q(4813, "The Fragments Within", "Darkshore", 14, RC,
    "The clear crystal revealed bone fragments and part of a jaw that appeared humanoid.",
    "Breaking the crystal seemed beyond reach, leaving a report of its contents as the next useful step.",
    "Glynda received the findings and planned to take them to Auberdine's council.",
    "The bones were reported, but the crystal's purpose remained unanswered.", 4)

-- Loch Modan and the Wetlands: captured stages, including reports that stop
-- short of the danger they describe. No report or supply delivery clears a zone.
local KD, SD, WX, DI = "alliance_loch_defense", "alliance_dam", "alliance_whelgar", "alliance_dunmodr"
P.threads[KD] = "the defense of Loch Modan"
P.threads[SD] = "the threat to Stonewrought Dam"
P.threads[WX] = "the stranded Whelgar expedition"
P.threads[DI] = "the fighting around Dun Modr"
q(224, "In Defense of the King's Lands", "Loch Modan", 12, KD,
    "Troggs were surfacing around the loch while many of Ironforge's soldiers fought elsewhere.",
    "The mountaineers needed help against Stonesplinter troggs and scouts on the home front.",
    "The fighting against the troggs earned a referral to Mountaineer Gravelgaw.",
    "The mountaineers acknowledged the first work against the incursion and had further patrols to cover.")
q(237, "In Defense of the King's Lands", "Loch Modan", 15, KD,
    "Gravelgaw needed pressure kept on the Stonesplinter skullthumpers and seers in the southern hills.",
    "The defenders hoped attacks on the troggs would buy time for reinforcements.",
    "The patrol's work was done, but the promised reinforcements had not arrived.",
    "Gravelgaw recognized the fighting and sent help toward Wallbang while the defenders remained shorthanded.")
q(263, "In Defense of the King's Lands", "Loch Modan", 15, KD,
    "Mountaineer Wallbang put the growing reputation of a trogg-slayer to the test against Stonesplinter shamans and bonesnappers. The reserves were at the front; the loch's defenders were on their own.",
    "With the reserves away, Wallbang needed help against the Stonesplinter shamans and bonesnappers. The other mountaineers' reports had given him someone to trust.",
    "The fighting earned Wallbang's salute. He suggested speaking with the captain about a greater responsibility in the loch's defense.",
    "Wallbang praised the service to King Magni and saluted. The captain, he thought, might now entrust a harder task to such help.")
q(217, "In Defense of the King's Lands", "Loch Modan", 17, KD,
    "Scouts had identified Grawmug as the chieftain behind the recent Stonesplinter incursion.",
    "Grawmug's guards Gnasher and Brawler stayed close, making the trogg leadership difficult to reach.",
    "Grawmug and his two guards were dead, improving the defenders' chances against the remaining troggs.",
    "The strike removed the incursion's identified leaders without ending the trogg presence around the loch.", 5)
q(250, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "The Thandol Span had been destroyed and Dun Modr pillaged, and Hinderweir had no doubt the {p:Stonewrought Dam} was next. Most of his security detail had gone to the Alliance Front, even his top inspector. A stranger would have to look into the Dark Iron sappers he had seen on the eastern ramp.",
    "Hinderweir thanked the stars that someone cared about the dam. Dark Iron sappers had been milling about its eastern ramp, and he wanted a clue to what they were doing.",
    "A suspicious barrel on the eastern ramp held a powder with a strange smell.",
    "The Dark Iron sappers had left a barrel behind, and the powder in it smelled strange.")
q(199, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "The barrel's powder offered a clue to the Dark Iron activity near the dam.",
    "A sample from the suspicious barrel needed to reach Hinderweir.",
    "Hinderweir received the sample and recognized a reason for alarm.",
    "The powder reached the dam's defender; its exact nature still needed an expert's attention.")
q(161, "A Dark Threat Looms", "Wetlands", 18, SD,
    "Hinderweir took the powder for an explosive and wanted an expert to say which. Ashlan Stonesmirk had been assigned to the regiment at {p:Dun Modr}, through the Algaz Gate and up the Wetlands road. Hinderweir's advice was to stick to the road and stop for nothing.",
    "A sample of the sappers' powder had to reach Ashlan Stonesmirk at Dun Modr. Hinderweir called the journey grave and perilous and said not to leave the road.",
    "Stonesmirk could hear nothing over the ringing in his ears, but he asked about the sample. Old Hinderweir was wise to be worried, he said.",
    "At Dun Modr, the powder reached Ashlan Stonesmirk, who could barely hear for the ringing in his ears. He said Hinderweir was right to worry.")
q(274, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "Stonesmirk knew the tiny silver crystals and the smell at once. It was Seaforium, harmless when dry, but wet it could blow Ironforge out of the mountain. The reaction could be defused with lurker venom, crushed Mo'Grosh crystal, a crocolisk tear and his disarming colloid. Hinderweir had to hear it before it was too late.",
    "The sappers' powder was Seaforium, Stonesmirk said, and the dam stood on water. He sent his disarming colloid back to Hinderweir with the list of what else the mixture needed.",
    "Hinderweir heard what the colloid was for and called on the heavens. He had Stonesmirk's colloid, and three more ingredients to find around the loch.",
    "Stonesmirk's colloid and his warning reached the dam. Hinderweir knew now what the barrel held, and what it would take to stop it.")
q(278, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "Lurker venom, a crocolisk tear and a rare Mo'Grosh crystal were needed for Hinderweir's mixture.",
    "The answer to the Seaforium depended on materials from the loch's wildlife and the ogres' crystals.",
    "The disarming ingredients reached Hinderweir in time to prepare the mixture.",
    "Hinderweir had the collected materials; the explosive at the dam had not yet been treated.")
q(280, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "Dark Iron swimmers had carried a keg toward the dam while no mountaineers were there to stop them.",
    "Hinderweir's finished mixture needed pouring into the planted Seaforium before it could detonate.",
    "The keg fizzled as the disarming mixture settled into its contents.",
    "The mixture reached the planted keg, where a slight fizz marked its reaction.", 4)
q(283, "A Dark Threat Looms", "Loch Modan", 20, SD,
    "The treated keg left news of the attempt on the dam to carry back to Hinderweir.",
    "The Seaforium emergency still needed its final report to the dam's defender.",
    "Hinderweir credited the work with saving Stonewrought Dam from this Dark Iron attack.",
    "The defender pronounced the dam safe for the time being, with the planted explosive disarmed.", 5)
q(255, "Mercenaries", "Loch Modan", 19, KD,
    "Ironforge's soldiers were still months away. Magistrate Bluntnose needed hired arms against the ogres northeast of the loch, with Thelsamar, the dam and the excavation all exposed.",
    "Magistrate Bluntnose had waited two months for Ironforge's answer and faced two more before its soldiers arrived. The ogres near Thelsamar called for help sooner than that.",
    "The news of the ogres' losses pleased Bluntnose. He hoped to turn Thelsamar's attention to the troggs once the ogre threat was settled.",
    "Bluntnose thanked the defenders on Thelsamar's behalf. Beyond the ogre camp, the troggs were already on his mind.")
q(256, "WANTED: Chok'sul", "Loch Modan", 22, KD,
    "Thelsamar's magistrate named Chok'sul as the presumed organizer of attacks on town, dam and excavation.",
    "A bounty called for proof against the ogre leader last seen northeast of the loch.",
    "Chok'sul's head reached the magistrate, who paid the bounty and offered Thelsamar's thanks.",
    "The returned proof settled the bounty on the ogre suspected of coordinating the attacks.", 4)
q(302, "Powder to Ironband", "Loch Modan", 15, L,
    "Stormpike approved fresh blastpowder for Ironband and asked that its delivery be watched closely.",
    "A missing earlier shipment made the excavation's replacement supplies a matter of concern.",
    "Jern explained that Huldar and the porters had already left Thelsamar with the supplies.",
    "The inquiry reached Jern after the shipment's departure; catching the porters was still ahead.")
q(273, "Resupplying the Excavation", "Loch Modan", 15, L,
    "Huldar's laden porters were following the road south from Thelsamar around the loch.",
    "Ironband's blastpowder shipment needed catching before it reached the excavation.",
    "Huldar had survived a Dark Iron ambush. What troubled him was Saean; after nearly a year working together, he had never suspected the man's allegiance.",
    "The porters were found, and Huldar spoke of the ambush with defiance. Saean's loyalty to the Dark Irons had caught him wholly unprepared.")
q(454, "After the Ambush", "Loch Modan", 15, L,
    "Huldar stayed with the remaining barrels while Miran took over hauling the powder.",
    "Saean's betrayal made another unescorted trip to the excavation seem too dangerous.",
    "Miran received the offer of an escort and began his final preparations.",
    "The arrangements reached Miran, who still had the journey to Ironband ahead of him.")
q(309, "Protecting the Shipment", "Loch Modan", 15, L,
    "Miran needed help carrying Ironband's powder through country where the Dark Irons had already struck.",
    "The expedition's supply line depended on getting the surviving shipment to the dig.",
    "Ironband received the powder and the troubling news about Dark Iron sympathizers.",
    "The escorted shipment reached the excavation, providing powder Ironband could finally put to use.", 4)
q(297, "Gathering Idols", "Loch Modan", 18, L,
    "Strange carved idols had been unearthed just before troggs drove the expedition out of the ruins.",
    "The idols seemed to drive the troggs berserk, making their recovery useful to both research and defense.",
    "The recovered idols reached the expedition for study.",
    "The specimens were out of trogg hands, though the reason for their effect still needed investigation.")
q(307, "Filthy Paws", "Loch Modan", 15, L,
    "Kobolds had occupied Silver Stream Mine after the exhausted workings became a Miners' League depot.",
    "The League wanted its tools recovered before a fighting force damaged them while clearing the mine.",
    "The Miners' League gear was recovered while the order to clear the kobolds was still awaited.",
    "The tools were retrieved from the occupied depot; the mine's wider clearance remained ahead.")
q(305, "In Search of the Excavation Team", "Wetlands", 24, WX,
    "Tarrel in Menethil had had a letter from his wife Merrin every week for a month, until two weeks of silence. She was with the Whelgar Excavation team to the east, and Longbraid had promised a scout.",
    "Merrin's letters from the Whelgar Excavation Site had stopped. Her husband Tarrel took the first traveler willing as the scout Longbraid had promised.",
    "Merrin was alive on the bluff above the dig, and thanked the heavens that someone had come.",
    "The search found Merrin at the excavation, alive and thanking the heavens.")
q(306, "In Search of The Excavation Team", "Wetlands", 24, WX,
    "The dig had turned up large bones, Merrin said, and then the Mottled Raptors came. Many died. Ormer had held them off while she and the Prospector ran for shelter, and now the three were trapped above their ruined work. Her note would explain it to Tarrel.",
    "Merrin wrote it all down for her sweet Tarrel, the bones, the raptors, the dead and Ormer's courage. Someone had to carry it back to Menethil.",
    "Tarrel read the horrible news and took what comfort there was in three survivors. He longed for the day, he said, when King Magni's subjects could live without fear.",
    "Merrin's note reached Tarrel in Menethil. She lived, and so did two others, and Tarrel wondered when the killing would end.")
q(294, "Ormer's Revenge", "Wetlands", 24, WX,
    "Bones uncovered at Whelgar's excavation drew raptors that killed Ormer's fellow workers. Stranded above the dig with Merrin and the Prospector, he wanted vengeance.",
    "The raptors had killed workers and trapped the survivors on a bluff above Whelgar's excavation. Ormer sent the first reprisal west of their shelter.",
    "Raptors and screechers fell west of the bluff. Ormer said duty to Merrin and the Prospector was all that kept him from joining the fight.",
    "The first hunt struck at the raptors below the survivors' shelter. Ormer wished he could join the bloodshed, but he was bound to stay with Merrin and the Prospector.")
q(295, "Ormer's Revenge", "Wetlands", 27, WX,
    "Scores of scytheclaws and razormaws crowded the dig below Ormer's shelter. His vengeance turned next to them.",
    "Ormer named the scytheclaws and razormaws below the bluff as the next targets of his revenge for the fallen workers.",
    "The hunt thinned the scytheclaws and razormaws at the excavation. Ormer greeted the work with hearty praise.",
    "More of the raptors below the bluff were slain. Ormer was delighted with the reprisal against the scytheclaws and razormaws.")
q(296, "Ormer's Revenge", "Wetlands", 29, WX,
    "Ormer suspected Sarltooth, a raptor larger and more menacing than the rest, had led the attack. He demanded one of its talons as proof of death.",
    "Sarltooth was Ormer's final target. He thought the great raptor had led the others against the dig, and wanted a talon to prove it dead.",
    "Sarltooth's talon reached Ormer. Remembering the dwarves killed at their work, he hoped the vengeance would make the creatures fear attacking Magni's subjects again.",
    "The talon proved Sarltooth dead. Ormer spoke of the innocent workers lost there and believed the reprisal would warn off future attacks on King Magni's people.", 4)
q(299, "Uncovering the Past", "Wetlands", 27, WX,
    "Just before the raptors came, Prospector Whelgar had uncovered a large tablet, the Goaz Stone. Its text broke off in four places and spoke of a divine plan and a doomed prophecy. Too old to brave the beasts below, he wanted the four fragments, Ados, Modr, Golm and Neru, found among the artifacts and the loose soil.",
    "The Goaz Stone was missing four pieces, and they lay somewhere in the raptor-held dig. Whelgar feared time was running out on whatever the tablet foretold.",
    "The Goaz Stone was whole again, and Whelgar went back to the delicate Titan script. He could make out new words already, about Old Gods chained beneath the land. It was the beginning of something epic, he said.",
    "Ados, Modr, Golm and Neru fitted back into the Goaz Stone. Whelgar read the first new words aloud, Old Gods chained beneath the land, and called it fine work.", 4)
q(303, "The Dark Iron War", "Wetlands", 30, DI,
    "While dwarven soldiers died abroad for the Alliance, Longbraid said, the Dark Irons had laid waste to the Thandol Span and taken {p:Dun Modr}. He wanted the front pushed back, fifteen Dark Irons and their tunnelers, saboteurs and demolitionists dead. Then the reserve might arrive in time to finish the drive.",
    "Longbraid's regiment held on outside Dun Modr waiting for a reserve that Roggo could not raise. Pressure on the Dark Iron encampment was all they could do meanwhile.",
    "Longbraid saluted a valiant soldier and loyal servant of King Magni. With the pressure put on the Dark Iron camp, he thought they stood a chance of driving the enemy off for good. He only wished the damned reserve would show.",
    "The Dark Iron encampment had taken its losses, and Longbraid said Dun Modr might yet be won back. The reserve had still not arrived.", 4)
q(304, "A Grim Task", "Wetlands", 34, DI,
    "Roggo's information named Balgaras the Foul as the elusive leader of the Dark Iron band in the Wetlands.",
    "The losses at Dun Modr and the Thandol Span had brought a bounty on the warlock directing the attackers.",
    "Balgaras was dead, leaving the remaining Dark Irons to be dealt with before another leader arrived.",
    "The warlock's ear settled the bounty without reclaiming all the ground his soldiers held.", 4)
q(473, "Report to Captain Stoutfist", "Wetlands", 28, V,
    "The Dragonmaw were showing their strength beyond Algaz, Valstag said. Captain Stoutfist wanted to speak with anyone willing to help against them, in the war room of Menethil Keep.",
    "Valstag sent the fighter from Dun Algaz on to Captain Stoutfist, inside the keep.",
    "Stoutfist had been briefed by Valstag on the fighting at Dun Algaz and called the newcomer worth something. He had a task ready.",
    "In the war room, Captain Stoutfist had heard about Dun Algaz from Valstag and had work waiting.")
q(464, "War Banners", "Wetlands", 28, V,
    "The Dragonmaw clan had all but died at the end of the Second War, Stoutfist said, when the red dragons they had enslaved turned on them. The survivors had fled Grim Batol into the mountains east of Whelgar's dig. Now they had gathered strength in a camp northeast of Menethil. He wanted it attacked and its war banners brought back.",
    "What was left of the Dragonmaw had built a camp northeast of Menethil. Stoutfist asked for their war banners as proof of an attack on it.",
    "The Dragonmaw were not the threat they had been with dragons, Stoutfist said over the banners, but fierce still. Their leader was Nek'rosh, son of Nekros, whose magic had tamed the red dragons until it failed him. The dragons had killed Nekros, and his son had sworn revenge on them.",
    "Stoutfist took the war banners and told of Nekros, who had tamed the red dragons and died when his magic failed. His son Nek'rosh led the clan now, sworn against the dragons that killed his father.")
q(465, "Nek'rosh's Gambit", "Wetlands", 31, V,
    "More of the Dragonmaw's plans had come to light while the fighting went on. Nek'rosh had built catapults to lay siege to Menethil, and with Dun Algaz contested no reinforcements could come. Stoutfist handed over tinder for the catapults and asked for Nek'rosh's head after.",
    "Catapults stood in the Dragonmaw camp, aimed at Menethil. Stoutfist's tinder was for them, and his orders went on to Nek'rosh himself.",
    "Tinder went onto the first catapult and a struck spark caught. Flame erupted and spread fast.",
    "The first catapult took the tinder and the spark and went up in flames. Nek'rosh himself still remained.", 4)
q(474, "Defeat Nek'rosh", "Wetlands", 32, V,
    "With the catapults burning, one order remained, to find Chieftain Nek'rosh and kill him.",
    "Stoutfist wanted the Dragonmaw beast cut down at its neck. Nek'rosh was in the camp.",
    "Stoutly done, Stoutfist said, for the Dragonmaw clan had taken a telling blow and might never recover. With the catapults gone, he added, Menethil Harbor was safe. The kingdom of Ironforge rewarded those who served it well.",
    "Nek'rosh was dead and his catapults burned. Stoutfist called it a telling blow to the Dragonmaw and Menethil safe, and paid in Ironforge's name.", 5)
q(276, "Tramping Paws", "Wetlands", 21, V,
    "The Mosshides had lived peacefully in the Wetlands for years. Rethiel now saw their growing numbers trampling flowers and cutting too much living wood for their fires.",
    "Rethiel sent the hunt south toward Algaz, where the growing Mosshide camps had upset the balance he remembered.",
    "With fewer Mosshides trampling the fen, Rethiel spoke of the Wetlands' health. His faith in his visitor's people had suffered before; this work gave him reason to hope it might return.",
    "The hunt reduced the Mosshide gnolls and mongrels near Algaz. Rethiel thanked the hunter for tending the Wetlands, and allowed that his strained faith in their people might yet recover.")
q(277, "Fire Taboo", "Wetlands", 23, V,
    "The Mosshides burned the trees they felled for warmth, and Rethiel could bear that pain no longer. He wanted their fire-making flints taken away.",
    "Rethiel called the burning trees living flesh. Taking the Mosshides' crude flints would deny them the tools that kindled those fires.",
    "Rethiel thanked the bearer of the captured flints. He meant to smash them and throw them into the sea, beyond any further use against living wood.",
    "The Mosshides' flints reached Rethiel. He promised to break them and cast them into the sea so that they could never kindle another fire in living wood.")
q(275, "Blisters on the Land", "Wetlands", 26, V,
    "Fevered fen creepers shambled through the waterways. Rethiel did not know what had sickened the land, but believed the creatures must be killed and allowed to settle into the marsh.",
    "Rethiel saw the risen fen creepers as blisters of a fever within the Wetlands. He asked that they be put down to soothe the suffering land.",
    "The fen creepers were put down, and Rethiel judged the land soothed. He granted a boon in thanks for easing its suffering.",
    "After the hunt along the waterways, Rethiel spoke of relief for the land. He rewarded the work that had quieted its fevered creatures.")
q(470, "Digging Through the Ooze", "Wetlands", 24, V,
    "Sida had been set on by dripping oozes on her weekly visit to Ironbeard's Tomb, northeast of Menethil near Dun Modr. In her panic she had thrown her bag at one, and the ooze had sucked it up. The bag's contents mattered, and the oozes all looked alike.",
    "One of the oozes at Ironbeard's Tomb had Sida's bag inside it, and she could not say which. She needed what was in it.",
    "Sida had feared the bag lost for good. She gave in thanks something from it she no longer used, with advice to wash it off first.",
    "The bag came back from the ooze to Sida, who offered one of its contents as thanks, once it was rinsed.")

-- The western routes: remedies remain attempts until their own recorded
-- result, and a request for forest spirits does not restore the Charred Vale.
local AC, AZ, ST = "alliance_relara", "alliance_zoram", "alliance_stonetalon"
P.threads[AC] = "the search for Relara's cure"
P.threads[AZ] = "the ruins along the Zoram Strand"
P.threads[ST] = "the damaged forests of Stonetalon"
q(1010, "Bathran's Hair", "Ashenvale", 20, AC,
    "Orendil Broadleaf at {p:Maestra's Post} feared that a child's sickness in Astranaar went deeper than the body. A plant called Bathran's Hair, once gathered in the ruins to the north, was known to cure ailments of the spirit.",
    "A child in Astranaar was failing by the hour. Orendil Broadleaf wanted the herb that had grown at Bathran's Haunt, just south of the Darkshore border, before he dared to treat her.",
    "Orendil took the strands of Bathran's Hair and set about mixing his cure, praying it would work. The news that Forsaken now camped in the haunt troubled him badly.",
    "The herb from Bathran's Haunt went to Orendil at Maestra's Post. He had a cure to mix, and the Forsaken among the ruins to think about.")
q(1020, "Orendil's Cure", "Ashenvale", 20, AC,
    "Orendil's cure was ready, and the child it was meant for lay in {p:Astranaar}. Her father, Pelturas Whitemoon, was waiting for it.",
    "The road south and then east led to Astranaar, where Pelturas Whitemoon watched over his daughter Relara. He had no time to speak with anyone.",
    "Pelturas knew Orendil's work when he saw it. He trusted the healer's skill with herbs, and the cure gave him hope where he had had little.",
    "The cure reached Relara's father in Astranaar. Pelturas had had little hope before Orendil's remedy arrived, and now he had some.")
q(1033, "Elune's Tear", "Ashenvale", 22, AC,
    "Orendil's cure had only slowed the disease in Relara. Pelturas remembered the healer's next counsel, a stone called Elune's Tear that lay on the isle in Iris Lake and was said to wash away corruption.",
    "Relara's sickness had outlasted Orendil's remedy. Her father sent for Elune's Tear, a stone found in one place only, the island in Iris Lake east of Astranaar.",
    "Pelturas meant to place the Tear in a stew for his daughter, and prayed it would cure her.",
    "Elune's Tear came back from Iris Lake to Pelturas, who meant to put it in Relara's stew and pray.")
q(1034, "The Ruins of Stardust", "Ashenvale", 23, AC,
    "Elune's Tear had eased Relara's nightmares, but her fever burned on. Orendil had spoken of a frosted dust among the Ruins of Stardust, south of Astranaar, that might bring it down.",
    "Relara slept easier after the Tear, yet the fever held. Her father asked for the frosted dust of the Ruins of Stardust, the next remedy on Orendil's list.",
    "Pelturas took the stardust to make a poultice against the fever. Without the help, he said, his child would surely perish.",
    "The frosted dust reached Pelturas in Astranaar. He would make a poultice of it, and he said plainly that Relara would perish without the help.")
q(1035, "Fallen Sky Lake", "Ashenvale", 30, AC,
    "Relara's fever had broken, but her strength had not come back. Pelturas believed only a moonstone could restore it, and the Shadethicket Oracle at Fallen Sky Lake hoarded every one that had fallen there.",
    "The moonstones that Astranaar once gathered at Fallen Sky Lake now lay in the hoard of a Shadethicket Oracle. Pelturas saw no way to one except through the Oracle himself.",
    "The Oracle's moonstone reached Pelturas with Relara down to her last breaths, he said. He gave in return the thing he held dearest after his daughter.",
    "Pelturas took the fallen moonstone and credited it with saving his daughter. He could not repay the help, so he gave what he treasured most after Relara.", 5)
q(1008, "The Zoram Strand", "Ashenvale", 19, AZ,
    "Shindrell Swiftfire of Astranaar spoke of an evil on the northwestern coast. The naga had come back to the {p:Zoram Strand}, where the city of Zoram had lain drowned since the Sundering, and no one knew why.",
    "Zoram had been lost beneath the sea since the Sundering and nearly forgotten. Now naga crawled its strand, and Shindrell wanted them thrown back to the depths.",
    "Shindrell called the work on the Zoram Strand commendable. The night elves knew the strength and guile of the naga from a shared history she did not care to repeat.",
    "The naga on the strand had paid for their return. Shindrell knew what their kind could do, she said, from a history her people shared with them.")
q(1007, "The Ancient Statuette", "Ashenvale", 20, AZ,
    "Talen had been skimming Zoram's drowned ruins in a small boat when naga surged up and tore at him. He fled to the shore with what he could carry and lost the one thing he had come for, an ancient statuette.",
    "At a meager camp on the {p:Zoram Strand}, Talen asked for a search of the beach to the north where the naga had ambushed him. The statuette he had dropped there was the whole reason he had braved the coast.",
    "Talen had his statuette back. The old city held many secrets, he said, and this figure might be the key to them.",
    "The statuette was found at the ambush site north of Talen's camp and went back to him. He believed it could unlock much of what Zoram still hid.")
q(1009, "Ruuzel", "Ashenvale", 25, AZ,
    "The statuette's lock would stay shut without the Ring of Zoram, worn by the city's rulers before the Sundering drowned them. The naga had found it, and their leader Ruuzel kept it on an isle at Zoram's northern edge.",
    "Talen had learned that the Ring of Zoram could open any lock in the old city. It was on Ruuzel's isle now, in naga hands.",
    "Ruuzel was dead, and Talen had the Ring of Zoram. He paid for it, and said the deed would stay in his memory forever.",
    "Talen paid for the ring taken from Ruuzel. With the key to the statuette's lock in hand, he could begin on Zoram's secrets.", 4)
q(1056, "Journey to Stonetalon Peak", "Stonetalon Mountains", 18, ST,
    "The forest spirits had told Faldreas of a traveler brave enough for the mountains. South of Mystral Lake the Talondeep Path ran through to Windshear Crag. Beyond Cragpool Lake a steep slope climbed to {p:Stonetalon Peak}, where Keeper Albagorm waited.",
    "Faldreas sent the traveler through the Talondeep Path to Keeper Albagorm on Stonetalon Peak. The way led past Cragpool Lake and up the mountainside, and he promised it would be perilous.",
    "Keeper Albagorm's first words were that the arrival had taken a while. He could see that Faldreas had listened to the forest spirits.",
    "The climb from Windshear Crag ended on Stonetalon Peak, where Albagorm had been waiting for whoever Faldreas would send.")
q(1057, "Reclaiming the Charred Vale", "Stonetalon Mountains", 27, ST,
    "Albagorm was alarmed for the {p:Charred Vale}, set afire by a mechanized army of industrialists for nothing but greed. The Bloodfury harpies that had moved in refused the druids passage, and nothing could be replanted until they were driven out.",
    "Greed had burned the sacred hills south of Stonetalon Peak. Albagorm wanted the Bloodfuries that nested in the ashes driven back so the regrowth could start.",
    "The Bloodfuries had taken heavy losses in the vale. Albagorm thought the true work of restoring the land might now begin.",
    "With the harpies thinned, Albagorm allowed himself to speak of restoration. The Charred Vale was still ash, and its regrowth was still to come.", 4)
q(1059, "Reclaiming the Charred Vale", "Thousand Needles", 27, ST,
    "The Bloodfuries were subdued, but Albagorm knew they would regroup. Far to the south, where Thousand Needles met the forest edge of Feralas, lived the druid Falfindel Waywarder. He could call forth spirits strong enough to help reclaim the vale.",
    "Albagorm sent for help before the harpies could recover. Falfindel Waywarder, a druid at the western end of Thousand Needles, was said to summon great spirits of the forest.",
    "Falfindel heard Albagorm's plea and praised the keeper's urgency. He would see whether the great forest could send aid to the Charred Vale in time.",
    "The message reached Falfindel Waywarder at the edge of Feralas. He meant to try calling the forest's spirits to the vale before it was too late, and the vale's recovery was still ahead.")
q(1070, "On Guard in Stonetalon", "Stonetalon Mountains", 21, ST,
    "Tara Thenysil in Astranaar had heard nothing from her friend Kaela Shadowspear since Sentinel Wolfrunner sent her into Stonetalon. That the Alliance had sent a gnome mage along with her worried Tara more.",
    "Kaela Shadowspear had gone into the {p:Stonetalon Mountains} to learn what the Venture Company was doing to the land, with a gnome mage for company. Her friend Tara wanted word of her.",
    "Kaela was alive in Stonetalon. She missed Tara and her homeland, she said, and was proud that her friend stood high enough among the Sentinels to send travelers on errands.",
    "The search found Kaela Shadowspear well. News from Tara made her miss Ashenvale and her friends, and proud of Tara's standing with the Sentinels.")
q(1085, "On Guard in Stonetalon", "Stonetalon Mountains", 21, ST,
    "Kaela had spent her time in Stonetalon fighting the Venture Company's destruction. She asked that the gnome working beside her, Gaxim, not be judged before he was heard. She had no good news yet to send to Tara.",
    "For a night elf and a gnome to work together, Kaela said, the situation had to be grave. Help in Stonetalon started with speaking to Gaxim.",
    "Gaxim called the land treacherous and meant to make it safer with engineering and a dash of magic. The night elves needed magic whether they liked it or not, he said, and with alchemy as well the possibilities were endless.",
    "Gaxim Rustfizzle set out his creed at once. Swearing off magic would not help the night elves, he said, and with engineering and alchemy as well nothing could go wrong.")
q(1071, "A Gnome's Respite", "Stonetalon Mountains", 21, ST,
    "Gaxim Rustfizzle of the Enlightened Assembly of Arcanology, Alchemy and Engineering Sciences had not had time to build his newest inventions. The goblins in {p:Windshear Crag} bred like rabbits, he said, and he needed them held back while he planned.",
    "Gaxim wanted a few days to plan and organize. That meant someone else keeping the Venture Company's goblins busy in Windshear Crag, east of his camp.",
    "Gaxim had his plan when the fighting was done. Explosives were part of it. He had been herding the goblins with detonations along the mountains' edges, and his supplies had run low days ago.",
    "The respite gave Gaxim his idea. He had scared the goblins back with high explosives before, less dangerous than people thought, he insisted, and now he had run out of them.")
q(4761, "Thundris Windweaver", "Darkshore", 15, J,
    "Findings from the furbolg camps needed to reach Auberdine's elder, Thundris Windweaver.",
    "Thundris had ideas about the corruption troubling the forest and its people.",
    "Thundris received the scouting news and welcomed help with Auberdine's troubles.",
    "The findings reached the village elder, adding to the inquiry into the forest's corruption.")
q(4762, "The Cliffspring River", "Darkshore", 15, J,
    "The Cliffspring River was growing foul, and Thundris feared its outflow would carry the taint toward Auberdine.",
    "A sample from the pool below the first waterfall could help examine the river's pollution.",
    "Thundris saw how putrid the sample had become and suspected Felwood as the deeper source.",
    "The water sample confirmed the pollution's severity; its connection to Felwood still needed confirmation.")
q(4763, "The Blackwood Corrupted", "Darkshore", 18, J,
    "Satyr talismans channeled corruption into the Blackwood furbolgs.",
    "Moonwell water mixed with the furbolgs' food could briefly cleanse them and draw out their satyr tormentor.",
    "Thundris took the corruptor's talisman for disposal and thanked Auberdine's defenders. What they had learned, he hoped, might someday free the Blackwood permanently.",
    "The corruptor's talisman reached Thundris. He called the victory a beginning and hoped its lessons could bring lasting freedom to the Blackwood.", 4)
q(4740, "WANTED: Murkdeep!", "Darkshore", 18, J,
    "Auberdine's council posted a bounty on a murloc blamed for a Sentinel's death and suspected cargo-ship attacks.",
    "Murkdeep had last been seen defending a camp south of Auberdine.",
    "Glynda paid the bounty for Murkdeep's death. She expected Auberdine's people to sleep more easily that night.",
    "Murkdeep was dead, and Glynda rewarded the deed on Auberdine's behalf. The murloc blamed for a Sentinel's death would trouble the coast no more.", 4)

-- Overnight 2026-11-05, Elwynn: Northshire's referrals, the murlocs of eastern
-- Elwynn (Thomas's lost guards), Eastvale and Westbrook, and the Collector's ring.
-- Each stage stops where its own completion text stops; the guild ring raises
-- the Stonemasons question without answering it.
P.threads.alliance_eastvale = "the murlocs of eastern Elwynn"
local EV = "alliance_eastvale"
q(5261, "Eagan Peltskinner", E, 2, N,
    "Deputy Willem had seen more wolves in Northshire Valley lately, and Eagan Peltskinner was looking for a hunter.",
    "Eagan Peltskinner worked around the side of the abbey. Willem knew he wanted help with the valley's wolves.",
    "Eagan confirmed what the deputy had said. He wanted wolves hunted and had work for anyone willing.",
    "Beside the abbey, Eagan asked whether the newcomer was the one to hunt his wolves.")
q(54, "Report to Goldshire", E, 5, N,
    "McBride judged the valley's newest defender ready for the wider forest and sent papers south to Marshal Dughan in Goldshire.",
    "Past Northshire's border gates, the southern road led to Goldshire, where Marshal Dughan was to receive McBride's papers.",
    "Dughan read McBride's papers and named their bearer an Acting Deputy of the Stormwind Marshals. Keeping Elwynn safe, he warned, was hard with most of the army off on some noble's business.",
    "The papers made their bearer an Acting Deputy under Marshal Dughan. He wished the new deputy luck, since Elwynn was no garden like Northshire.", 4)
q(2158, "Rest and Relaxation", E, 5, F,
    "A friend of Innkeeper Farley's recommended the Lion's Pride Inn in Goldshire, with a promise of discounted rates.",
    "The Lion's Pride Inn stood on the road south of Northshire. Its innkeeper might offer discounted rates on food and drink.",
    "Farley offered a seat by the fire at the Lion's Pride, along with a sampling of the inn's food and drink.",
    "At the Lion's Pride, Farley made the newcomer welcome and pointed to the fire.")
q(40, "A Fishy Peril", E, 10, EV,
    "Remy Two Times had seen murlocs swimming up the streams of eastern Elwynn, scaring off the fish and attacking travelers. Marshal Dughan did not believe him.",
    "Remy wanted Marshal Dughan persuaded to send troops east. By the merchant's account, murlocs were attacking gentle folk along the streams.",
    "Dughan respected Remy as a merchant but called the murloc reports sketchy. Without a military report, he would send no troops east.",
    "The marshal noted the concern and kept his soldiers where they were. Only a soldier's report of a murloc threat would change his mind.")
q(35, "Further Concerns", E, 10, EV,
    "Dughan wanted the murloc rumors tested. Guard Thomas had watched the eastern Elwynn bridge for a week and would know the state of the area.",
    "If murlocs really were in the east, Guard Thomas at the bridge would have seen them. Dughan asked for his report.",
    "Thomas confirmed it. Murlocs had settled along the streams of eastern Elwynn, and no one knew why they had come.",
    "At the bridge, Thomas told it plainly. The murlocs had settled along the eastern streams, and he called them aggressive and at least half intelligent.")
q(37, "Find the Lost Guards", E, 10, EV,
    "Thomas had sent two guards, Rolf and Malakai, up the river days before. Neither had come back.",
    "Thomas could not finish his report until he knew what had become of Rolf and Malakai along the river.",
    "A stripped body lay by the river. Near it was a medallion etched with the name Footman Malakai Stone.",
    "Malakai Stone's medallion lay beside a stripped corpse on the riverbank, the first of Thomas's missing guards.")
q(45, "Discover Rolf's Fate", E, 10, EV,
    "Webbed footprints led east along the shore of Stone Cairn Lake, toward a murloc village in the distance.",
    "Rolf was still missing, and the murloc tracks by Stone Cairn Lake pointed toward their village.",
    "Past the webbed footprints lay a second body, with a medallion around its neck inscribed Footman Rolf Hartford.",
    "A medallion reading Footman Rolf Hartford named the second guard the murlocs had killed.")
q(71, "Report to Thomas", E, 10, EV,
    "Both medallions, Malakai's and Rolf's, belonged with Guard Thomas at the bridge.",
    "Thomas was still waiting at the bridge to learn what had become of his two guards.",
    "The medallions confirmed what Thomas had feared. The murlocs, he said, were a threat Elwynn could no longer ignore.",
    "Thomas took the medallions of Rolf and Malakai and named the murlocs a danger nobody could dismiss now.", 4)
q(39, "Deliver Thomas' Report", E, 10, EV,
    "Thomas's report told of Rolf's and Malakai's deaths and warned that his few guards could not hold back the eastern murlocs.",
    "The deaths by Stone Cairn Lake had to reach Marshal Dughan, together with Thomas's plea for more soldiers.",
    "Dughan found the news troubling. His defenses were already thin, and with Rolf and Malakai lost he feared fighting in Goldshire by the week's end.",
    "The loss of two guards left Dughan worse placed than before. If nothing improved, he expected fighting in Goldshire within the week.", 4)
q(46, "Bounty on Murlocs", E, 10, EV,
    "The Stormwind Army paid for murloc fins. Guard Thomas pointed the hunt toward Stone Cairn Lake and the fork of the southern stream.",
    "Murloc lurkers and foragers had built villages north and south of the eastern bridge. The army had put a bounty on their fins.",
    "Thomas took the torn fins and meant to tell Dughan that the murlocs were coming under control.",
    "The fins earned the army's bounty. Thomas hoped his next word to the anxious marshal could say the murlocs were in hand.")
q(52, "Protect the Frontier", E, 10, EV,
    "Wolves and bears grew bolder the farther the road ran from Goldshire, and the Eastvale Logging Camp suffered near constant attacks.",
    "Guard Thomas wanted the prowlers and young bears around Eastvale thinned before they did the loggers more harm.",
    "Fewer wolves and bears troubled Eastvale. Thomas thought something in the forest was making the animals bold, and hoped it stayed there.",
    "Thomas gave thanks for the hunt. Something in the forest, he said, must be making the beasts so bold.")
q(59, "Cloth and Leather Armor", E, 10, EV,
    "Dughan marked the work in eastern Elwynn with a token good for one piece of armor. The armor would be made by Sara Timberlain at Eastvale.",
    "Sara Timberlain made cloth and leather armor for the Stormwind Army, and Dughan's marker entitled its bearer to a piece.",
    "Sara took the marker and offered a choice of armor, with a wish that it would serve its wearer well.",
    "At the Eastvale camp, Dughan's marker became armor. The marshal had asked that it be worn in Elwynn's defense.")
q(83, "Red Linen Goods", E, 9, F,
    "The Defias in Elwynn wore red linen bandanas, finer than the burlap masks of Northshire's gang, and Sara Timberlain wanted the cloth.",
    "Sara Timberlain at Eastvale was running low on linen. The bandits' camps across Elwynn held plenty of it.",
    "Sara called the bandanas a little rough but good linen, and made something from them in return.",
    "The Defias bandanas went to Sara's workbench at Eastvale, and she paid for them with her own work.")
q(5545, "A Bundle of Trouble", E, 9, F,
    "Wolves and bears had chased Supervisor Raelen's woodcutters away from the timber they had already cut, with a lumber order due.",
    "Eight bundles of chopped wood lay north of the Eastvale camp, left behind when the animals drove the workers off.",
    "The bundles came back, and Raelen expected to finish the lumber order in time. Coin followed for the trouble.",
    "With the abandoned wood recovered, Raelen thought the deadline could still be met.")
q(239, "Westbrook Garrison Needs Help!", E, 10, F,
    "The Westbrook Garrison reported more gnolls and thieves on the western border, and Dughan had no soldiers to send.",
    "Dughan could spare no troops for Westbrook, so help of another kind went down the western road to Deputy Rainer.",
    "Rainer welcomed help that did not come from the army; Dughan's word was good enough for him. His garrison, he admitted, was badly stretched.",
    "Deputy Rainer called Westbrook's situation stressed, to say the least, and put Dughan's help to work.")
q(147, "Manhunt", E, 10, F,
    "The pickup schedule placed the Collector at the Brackwell Pumpkin Patch. Dughan wanted him brought to justice, along with the ring the schedule mentioned.",
    "Gold from Elwynn's mines was going to a thief called the Collector. Dughan called it theft from the kingdom and hoped the man's ring would name his employer.",
    "The Collector would take no more gold from Elwynn's mines. His ring belonged to the old Stonemasons' Guild of Stormwind. Dughan wondered why a thief wore an artisan's ring, and why the Defias were collecting from the mines.",
    "Dughan turned over the Collector's ring and found the mark of Stormwind's Stonemasons' Guild. He had no answer for why the Defias carried it, only the hope of one someday.", 5)
P.questIDs[54].highlight = {"McBride's papers reached Marshal Dughan in Goldshire, and their bearer became an Acting Deputy of the Stormwind Marshals.", "In Goldshire, Dughan read McBride's papers and named a new Acting Deputy. He warned that Elwynn was harder ground than Northshire."}
P.questIDs[71].highlight = {"Malakai's and Rolf's medallions went back to Guard Thomas at the bridge. They confirmed his fear that the murlocs could no longer be ignored.", "Guard Thomas received the medallions of his two dead guards and called the murlocs a threat Elwynn could not ignore."}
P.questIDs[39].highlight = {"Thomas's report of Rolf's and Malakai's deaths reached Dughan. With his defenses thin, the marshal feared fighting in Goldshire by the week's end.", "Dughan heard how the murlocs had killed Rolf and Malakai. He expected fighting in Goldshire within the week if nothing changed."}
P.questIDs[147].highlight = {"The Collector was found at the Brackwell Pumpkin Patch. His ring carried the mark of Stormwind's Stonemasons' Guild, which left Dughan with hard questions about the Defias.", "Dughan received the Collector's ring, a Stonemasons' Guild ring, and wondered why the Defias were collecting gold from Elwynn's mines."}

-- Overnight 2026-11-05, Westfall: Sentinel Hill's people (Danuvin, Galiaan,
-- Lewis's armor by gryphon), the ghost at the lighthouse, the Furlbrows' deed,
-- Captain Sanders's clues, and Solomon's letters to Westfall and Darkshire.
-- The messenger stages keep each reply with its own reader.
P.threads.alliance_lighthouse = "the dark lighthouse on the Westfall coast"
P.threads.alliance_lewis = "armor for Sentinel Hill"
P.threads.alliance_sanders = "Captain Sanders's clues"
local LH, LW, CS = "alliance_lighthouse", "alliance_lewis", "alliance_sanders"
q(109, "Report to Gryan Stoutmantle", W, 10, H,
    "A friend of Gryan Stoutmantle's sent seasoned fighters on to Sentinel Hill. There Stoutmantle led the People's Militia from a stone tower.",
    "The People's Militia guarded Westfall's farmlands from the tower on Sentinel Hill, and its leader needed fighters.",
    "Stoutmantle said the Stormwind monarchy had abandoned Westfall, leaving the People's Militia to keep the land free. He offered to put the newcomer's skills to use.",
    "At Sentinel Hill, Stoutmantle welcomed the fighter his friend had sent. With the crown gone from Westfall's cause, he had work for anyone willing to defend its farms.", 4)
q(102, "Patrolling Westfall", W, 14, H,
    "Captain Danuvin had farmed in Westfall before the thieves came. He wanted gnoll paws from the grasslands, believing the gnolls worked with the Deadmines thieves.",
    "Gnolls roamed Westfall's grasslands, seemingly in league with the Deadmines thieves, and Danuvin would not turn his back on the people who stayed.",
    "Danuvin took the eight paws. With fighters like these beside the militia, he said, Westfall might yet be the breadbasket it once was.",
    "The gnoll paws earned Danuvin's thanks and a reward. He spoke of Westfall's old prosperity coming back if the militia had such help.")
q(153, "Red Leather Bandanas", W, 15, H,
    "Scout Galiaan had followed the shifting Defias front for some time. Many of its members could be tracked by the red leather bandanas they wore.",
    "At Sentinel Hill, Scout Galiaan paid for red leather bandanas, the mark the Defias wore across Westfall.",
    "Fifteen Defias bandanas reached Scout Galiaan at Sentinel Hill, and with them came the payment he had offered.",
    "Galiaan took the red bandanas and paid with a choice of items, as he had promised.")
q(117, "Thunderbrew", W, 15, H,
    "Grimbooze Thunderbrew needed hops, or his lager would taste more like stew than beer. He said so in rhyme.",
    "Hops were all that stood between Grimbooze Thunderbrew's lager and a pot of stew, by the brewer's own rhyme.",
    "Grimbooze got his hops and answered with another rhyme, and with Thunderbrew Lager for the trouble.",
    "The hops reached Grimbooze, who praised hops, barley, yeast and malt and paid in Thunderbrew Lager.")
q(184, "Furlbrow's Deed", W, 9, H,
    "The Defias had leaned on Theodore Furlbrow and taken the deed to his farm, thinking to forge others like it. A note on the back said the Furlbrows were leaving Westfall with a broken wagon.",
    "A stolen deed signed by Theodore and Verna Furlbrow had turned up among the Defias. Its owners were stranded by the road with a broken wagon.",
    "Furlbrow had thought the deed gone for good. Westfall was no place for honest folk now, he said. If things got better, the papers would let them reclaim their land.",
    "The deed went back to the Furlbrows. They were leaving Westfall with no plans to return soon, but they would need the papers if they ever did.", 4)
q(103, "Keeper of the Flame", W, 16, LH,
    "Murlocs led by Old Murk-Eye had killed the lighthouse keeper's family. The ghost of Captain Grayson tended the flame alone. Its oil came from the harvest machines in the fields.",
    "With no living keeper at the Westfall Lighthouse, Captain Grayson's ghost watched the flame for the sake of ships near the rocks. He needed flasks of oil to keep it burning.",
    "The oil kept the lighthouse burning. Grayson, who had died needlessly on that shore, said many sailors would be spared while the torch stayed lit.",
    "The torch above the Westfall coast stayed lit on the gathered oil. Grayson called it his duty in the afterlife that no one else should die as he had.")
q(152, "The Coast Isn't Clear", W, 19, LH,
    "Shipwrecks lined the Westfall coast, and sailors who reached its beaches found murlocs waiting. Captain Grayson wanted the shore cleared.",
    "Grayson asked for the murloc tidehunters, warriors, oracles and coastrunners along the beaches to be thinned, so castaways could land safely.",
    "Grayson praised the fighting along the beaches. Thanks to it, he said, the coast of Westfall was a safer place.",
    "Fewer murlocs held the beaches where shipwrecked sailors came ashore, and Grayson saw to the promised reward.")
q(104, "The Coastal Menace", W, 20, LH,
    "The lighthouse had been dark the night Captain Grayson's ship struck the rocks. Old Murk-Eye had driven its keepers off. When Murk-Eye came back, the family died before the ghost's eyes.",
    "Grayson wanted Old Murk-Eye dead, and one of his scales as proof. The murloc who had led both raids on the lighthouse still roamed the shore.",
    "Murk-Eye was dead, and Grayson accepted the scale. One life had ended, he said, but perhaps many were saved. The Great Sea would be a little safer that night.",
    "Grayson took Old Murk-Eye's scale as proof that the raider of the lighthouse was dead, and rewarded the deed.", 4)
q(6181, "A Swift Message", W, 10, LW,
    "Sentinel Hill's armor was running low. Quartermaster Lewis had a contact in Stormwind, Osric Strang of Limited Immunity in Old Town.",
    "Lewis got little aid from Stormwind directly. His note for the armorer Osric Strang was to go by gryphon, starting with Thor down the hill.",
    "Thor offered a gryphon to Stormwind as soon as he heard where the note was going.",
    "The gryphon master at Sentinel Hill agreed at once; Lewis's note could fly to the capital.")
q(6281, "Continue to Stormwind", "Stormwind City", 10, LW,
    "For a small fee, Thor's gryphons could carry Lewis's note to Osric faster than any road.",
    "Lewis's request for more armor had to reach Osric Strang in Stormwind's Old Town.",
    "Osric was not surprised that Lewis needed more gear. Sentinel Hill was far away, he said, in a land Stormwind had all but forgotten. He covered the travel costs.",
    "The note reached Osric. He paid back the gryphon fare and spoke of Westfall as a place Stormwind had nearly forgotten.")
q(6261, "Dungar Longdrink", "Stormwind City", 10, LW,
    "Osric had packed everything Lewis asked for into a crate. Dungar Longdrink, the gryphon master in the Trade District, could fly it back to Westfall.",
    "The militia's fighters in Westfall were not to go without fresh equipment. Osric wanted his crate on a gryphon.",
    "Dungar had plenty of gryphons trained to fly to Westfall, and the crate could go with one of them.",
    "At the Trade District roost, Dungar agreed to carry Osric's crate to Westfall by gryphon.")
q(6285, "Return to Lewis", W, 10, LW,
    "Osric's crate of armor was bound for Quartermaster Lewis at Sentinel Hill, by way of Dungar's gryphons.",
    "Gryphons flew only to roosts their riders had already reached. Thor's roost at Sentinel Hill was one of them. Osric's crate could go straight to Lewis.",
    "Lewis opened Osric's crate and meant to hand out the armor at once to those who needed it.",
    "The armor reached Sentinel Hill. Lewis hoped its carrier, no stranger to gryphons now, would come to the militia's aid often.")
q(136, "Captain Sander's Hidden Treasure", W, 16, CS,
    "Captain Sanders's map promised his treasure to whoever followed the clues. The first lay in his footlocker, half buried in sand by the one rusty anchor on Westfall's western coast.",
    "Old Captain Sanders was in a watery grave. His map pointed to a footlocker beside a rusty anchor near the shipwrecks.",
    "The footlocker creaked open on sand and water. A small crab scurried out holding the next clue.",
    "Sand and seawater filled the captain's footlocker, but a crab ran out with the next clue in its claws.")
q(138, "Captain Sander's Hidden Treasure", W, 16, CS,
    "The crab's clue pointed due east, up the bluffs to the road and an old barrel by some chimney ruins.",
    "Captain Sanders's next clue lay inland, at the chimney ruins beside the road.",
    "In the barrel by the ruined chimney lay another piece of parchment.",
    "The old barrel held the captain's next clue.")
q(139, "Captain Sander's Hidden Treasure", W, 16, CS,
    "From the barrel, the captain's parchment pointed north to an empty jug beside a lone windmill on the sea bluffs.",
    "The trail of Captain Sanders's clues turned north, toward a windmill standing alone on the bluffs.",
    "The old jug by the windmill smelled of whiskey and held another clue, its ink partly run.",
    "Deep in the jug by the windmill lay the captain's next note, close to the end of his trail.")
q(140, "Captain Sander's Hidden Treasure", W, 16, CS,
    "The whiskey-stained clue pointed west from the jug, down to the shore and across the water to an island.",
    "Captain Sanders's last instruction was to swim straight west from the shore until his island came in sight.",
    "On the island, the old chest opened on rusty hinges, and the captain's booty came out of it.",
    "The captain's chest stood on the island at the end of the trail. Its rusty hinges still worked, and his treasure had a new owner.", 4)
q(143, "Messenger to Westfall", W, 14, K,
    "The Stormwind Army should have reached Lakeshire in force by now, and Magistrate Solomon would not wait. He sent a plea to Gryan Stoutmantle's militia in Westfall.",
    "Solomon had heard of a people's militia forming in Westfall. He hoped its men could hold Redridge until the king sent reserves.",
    "Stoutmantle received Solomon's plea at Sentinel Hill and praised its messenger's service.",
    "The magistrate's letter reached the leader of the People's Militia, far from Lakeshire.")
q(144, "Messenger to Westfall", R, 14, K,
    "Solomon's note pained Stoutmantle. Westfall had been deserted by Stormwind too, and the militia had no help to spare.",
    "Stoutmantle sent his answer back to Lakeshire, with word that his heart was heavy over the loss of good men.",
    "Solomon had not known Stoutmantle's plight was so like his own. He wondered aloud what could call the Stormwind Army away from its people, then stopped himself.",
    "The reply troubled Solomon. Westfall could send no help, and the magistrate paid the messenger and said there might be more errands.")
q(145, "Messenger to Darkshire", D, 18, K,
    "Solomon wrote to Lord Ello Ebonlocke, mayor of Darkshire, asking for the Night Watch to help defend Lakeshire.",
    "Another plea left Lakeshire, this one for Darkshire, carried along the roads through Duskwood.",
    "Ebonlocke thanked the messenger for the long journey and called the letter important.",
    "Solomon's letter reached Darkshire's mayor after a long road through Duskwood.")
q(146, "Messenger to Darkshire", R, 18, K,
    "Ebonlocke would not send the Night Watch. It existed because Stormwind had abandoned Darkshire, and without it the town would fall.",
    "Ebonlocke's answer was a refusal. Had he not known Solomon personally, he wrote, he would have thought the man mad.",
    "Solomon read that the army had left Westfall and the guard no longer protected Darkshire. Suspecting treachery, he resolved to find out what was amiss in Stormwind.",
    "The letter from Darkshire alarmed Solomon. Westfall and Duskwood had been abandoned as well. He meant to get to the bottom of whatever was wrong in Stormwind.", 4)
P.questIDs[109].highlight = {"At Sentinel Hill, Gryan Stoutmantle said the crown had abandoned Westfall. He offered the People's Militia's cause to a newcomer his friend had sent.", "Stoutmantle welcomed a fighter to Sentinel Hill. With Stormwind gone from Westfall, it fell to the People's Militia to keep the land free."}
P.questIDs[184].highlight = {"The Furlbrows' stolen deed came back from the Defias. They were leaving Westfall, but the papers would let them reclaim their farm if things got better.", "Theodore Furlbrow had thought his deed gone for good. Its return kept the family's claim to their land."}
P.questIDs[104].highlight = {"Old Murk-Eye, who had led the murlocs that killed the lighthouse keeper's family, was dead. Grayson's ghost took the scale and judged the Great Sea a little safer.", "Captain Grayson received Old Murk-Eye's scale. The murloc who had twice raided the Westfall Lighthouse would lead no more attacks."}
P.questIDs[140].highlight = {"Captain Sanders's clues ended on an island west of the shore, where his rusty chest still opened.", "The last of Captain Sanders's clues led across the water to his island and his chest of booty."}
P.questIDs[146].highlight = {"Darkshire refused to send the Night Watch. Learning that Westfall and Duskwood had been abandoned too, Solomon suspected treachery in Stormwind.", "Ebonlocke's refusal reached Lakeshire. Solomon, finding that Stormwind had left Westfall and Darkshire on their own as well, resolved to learn what was wrong in the capital."}

-- Overnight 2026-11-05, Redridge: the gnoll warnings from the border, Verner's
-- horseshoes and debt, the inn's dry cellar, the Blackrock bounties and
-- Keeshan's escape, and Theocritus's watch on Morganth. Morganth's defeat is
-- only told from 249; the glyph and pendant stages stay reconnaissance.
P.threads.alliance_morganth = "Theocritus's watch on Morganth"
local MG = "alliance_morganth"
q(244, "Encroaching Gnolls", R, 16, K,
    "Guard Parker patrolled the road into Redridge and had seen gnoll camps to the north and east. Lakeshire needed to hear of them.",
    "The road was safe for now, but Parker had spotted gnoll encampments near the border and wanted Deputy Feldon warned.",
    "Feldon was alarmed to hear of gnolls so close to Elwynn. Lakeshire might not be the only town under siege soon, he said. He paid a scout's wage for the bad news.",
    "The warning reached Deputy Feldon south of the bridge. He paid for it, though Lakeshire was ill equipped to meet the gnolls.")
q(246, "Assessing the Threat", R, 17, K,
    "Feldon had no men to spare, but the gnolls along Redridge's southern road needed counting. He asked for them to be harried and their strength judged.",
    "Deputy Feldon wanted a count of the gnolls camped along the southern road, and some of them killed in the getting.",
    "Feldon heard of a sizable, tough gnoll force and paid for the report. With the town's situation growing desperate, he sent the scout on to Marshal Marris and Magistrate Solomon.",
    "The count confirmed a large gnoll camp on the southern road. Feldon gave thanks and pointed to Marris and Solomon, who would need more help.")
q(116, "Dry Times", R, 15, K,
    "Lakeshire's booze shipment was long overdue, and Barkeep Daniels blamed the orc invasion. He wanted lager from Westfall, Merlot from Stormwind, moonshine from Darkshire and rum from Goldshire.",
    "The bottles at Lakeshire's inn were close to running dry. Barkeep Daniels needed drink fetched from four towns across the kingdom.",
    "Daniels knew well the roads travelled to gather that array of liquor. His patrons would be happy again, and a cloak his wife had made paid for the trip.",
    "Lager, Merlot, moonshine and rum reached the Lakeshire inn. Daniels gave a cloak his wife had sewn in return.")
q(118, "The Price of Shoes", E, 18, K,
    "Verner Osgood had used so much iron outfitting Stormwind's guards that none was left for horseshoes. His note asked Smith Argus in Goldshire for a shipment.",
    "Lakeshire's stable horses needed shoes, and Verner had no iron to spare. Argus in Goldshire could supply them.",
    "Argus told the messenger to speak up, then laughed that old Verner needed shoes.",
    "Verner's note reached Argus in Goldshire, who was amused to hear that old Verner needed shoes.")
q(119, "Return to Verner", R, 18, K,
    "Argus boxed up fifty horseshoes for Verner and sent a note attached to the crate.",
    "The crate of horseshoes went back to Lakeshire with Argus's wish that Verner read the note on top.",
    "Verner was grateful for the shoes until he read the note. Argus wanted to be paid.",
    "The horseshoes reached Verner, along with a bill from Argus that he had not expected.")
q(122, "Underbelly Scales", R, 18, K,
    "Verner meant to pay Argus in black dragon whelp scales. The whelps flew south of Lakeshire, but they liked to wander.",
    "Six underbelly scales would settle Verner's debt for the horseshoes, with some left over to make something.",
    "The scales got Verner out of debt to Argus, with enough left to fashion something for the one who brought them.",
    "Verner took the whelp scales, enough to pay Argus before the smith sent someone to collect.")
q(124, "A Baying of Gnolls", R, 20, K,
    "Gnoll brutes and mystics prowled the ridge north of Verner Osgood's stable, taking his horses when they strayed.",
    "As if the orcs were not enough, gnolls were now taking horses from the ridge above Verner's stable.",
    "Fewer gnolls prowled the ridge above the stable, and Verner gave thanks for himself and his horses.",
    "The brutes and mystics north of the stable were thinned, and Verner was grateful for the help.")
q(126, "Howling in the Hills", R, 25, K,
    "The gnolls still hunted the hills above Lakeshire, and one cry rose above the rest. Verner wanted Yowler, their leader, dead.",
    "Yowler led the gnoll pack in the hills above Lakeshire. Verner warned that he was no mongrel.",
    "Yowler's paw reached Verner. The Stormwind Army, he said, was too busy with the orcs to protect Redridge from local threats like the gnolls.",
    "Yowler was dead. Verner gave thanks again, since the army had no troops to spare against gnolls.", 4)
q(150, "Murloc Poachers", R, 20, K,
    "Larger groups of murlocs were fishing the shores of Lake Everstill. Dockmaster Baren feared they would empty the lake.",
    "Baren wanted the murlocs gone from Lake Everstill before they ate all of Lakeshire's fish.",
    "The fins went to Baren. He found it strange to see murlocs so far from the sea, and wondered whether they were running from something.",
    "The murloc fins earned Baren's reward. He was puzzled that the fishmen had come this far inland, and wondered what had driven them.")
q(19, "Tharil'zun", R, 25, K,
    "Blackrock outrunners and renegades ambushed travelers between Lakeshire and Stonewatch Keep. Marshal Marris wanted the head of their leader, Tharil'zun.",
    "Tharil'zun led the outrunners who set ambushes on the road to Stonewatch, and Marris put a price on his head.",
    "Marris called Tharil'zun a vicious, crafty orc and paid for his head, sure he had not gone down easily.",
    "Tharil'zun's head reached Marris. The leader of the road ambushes was dead, though the Blackrock pressure stayed heavy.", 4)
q(128, "Blackrock Bounty", R, 25, K,
    "The leaders of each Blackrock unit were called Champions, and Magistrate Solomon wanted them dead. They camped north of Lakeshire, west of the road to the Burning Steppes.",
    "Guard Howe carried Solomon's order against the Blackrock Champions encamped in northern Redridge.",
    "Howe praised the fighting against the Blackrock Champions as a great service to the township.",
    "Fifteen Blackrock Champions were dead, and Lakeshire's guard counted it valiant work for the town.")
q(115, "Shadow Magic", R, 23, K,
    "Blackrock shadowcasters carried midnight orbs, demon-tainted devices that had struck hard at Redridge's defenders. Marshal Marris wanted them out of the fight.",
    "Marris asked for the midnight orbs of slain Blackrock shadowcasters, meaning to have them destroyed.",
    "The orbs went to Marris, who sent them off to be destroyed at once.",
    "The shadowcasters lost their midnight orbs, and Marris sent the dark devices to be destroyed.")
q(169, "WANTED: Gath'Ilzogg", R, 26, K,
    "Gath'Ilzogg had led the Blackrock attack on Stonewatch Keep and the raids on Lakeshire. He was said to be holed up in the conquered keep.",
    "Solomon's bounty named Gath'Ilzogg, the orc behind the fall of Stonewatch, and asked for his head.",
    "Solomon took Gath'Ilzogg's head as vindication for the many innocents he had killed. It was a first step, the magistrate said, toward reclaiming the keep for Stormwind.",
    "Gath'Ilzogg was dead. Solomon called it the first step toward taking Stonewatch Keep back for the kingdom.", 5)
q(219, "Missing In Action", R, 25, K,
    "Orcs had overpowered Corporal Keeshan's regiment and killed most of the men. Keeshan woke a captive in a cave, badly hurt, and needed help getting back to town.",
    "Corporal Keeshan was held in a Blackrock cave after his regiment fell, and could not reach Lakeshire alone.",
    "Keeshan escaped the Blackrock orcs and reached Lakeshire, where Marshal Marris rewarded the help.",
    "Marris gave thanks for bringing Corporal Keeshan out of the Blackrock cave alive.", 4)
q(91, "Solomon's Law", R, 23, MG,
    "Morganth, an enemy of Stormwind, had settled in the eastern foothills and bent the Shadowhide gnolls to his will. By Lakeshire's law, aiding him was punishable by death.",
    "Bailiff Conacher enforced the town's sentence on the Shadowhide gnolls who served Morganth, and paid for their pendants.",
    "Conacher took ten Shadowhide pendants. The Court of Lakeshire, he said, recognized the service to the kingdom's justice.",
    "The pendants proved the sentence carried out against Morganth's gnolls, and the court recognized the work.")
q(180, "WANTED: Lieutenant Fangore", R, 26, MG,
    "Lieutenant Fangore led the Shadowhide gnolls in Morganth's service, and Magistrate Solomon wanted the betrayer dead.",
    "A bounty in Lakeshire named Fangore, the Shadowhide leader working for Morganth, and asked for his paw as proof.",
    "Solomon called Fangore a foul creature and was glad to be rid of him. The township of Lakeshire gave thanks.",
    "Fangore's paw settled Solomon's bounty on Morganth's gnoll lieutenant.", 4)
q(178, "Theocritus' Retrieval", E, 23, MG,
    "A Shadowhide pendant spoke with a disembodied voice. Theocritus, High Mage of the Tower of Azora, had found a way to speak through the gnolls' link to Morganth.",
    "The pendants carried Morganth's word to his gnolls, and Theocritus had spent months learning to use them himself. He wanted one brought to his tower.",
    "Theocritus had sent his message weeks before and thought the spell a failure. He hoped one day to send an attack through the pendants, though much research remained.",
    "The pendant reached Theocritus, who meant to study it. Immobilizing the Shadowhide through their own pendants was a hope still far off.")
q(94, "A Watchful Eye", R, 21, MG,
    "Theocritus watched his rival Morganth through the Eye of Azora, but seeing was not enough. His glyph, set on the lion statue by the Tower of Ilgalar, would let him probe Morganth's thoughts.",
    "The Tower of Ilgalar in Redridge held Morganth, a mage of great power. Theocritus sent his Glyph of Azora to the old lion statue nearby.",
    "The glyph settled into the hollow at the statue's base. Theocritus's voice spoke from it with thanks and a promise of future tasks.",
    "Set on the lion statue, the Glyph of Azora gave Theocritus a way to speak and watch from afar.")
q(248, "Looking Further", R, 22, MG,
    "Theocritus had seen that Morganth was in conflict with the orcs of Stonewatch Keep, without knowing why. A second glyph was to be hidden atop the watch tower beside the keep.",
    "To learn why Morganth quarreled with the Blackrock orcs, Theocritus needed a glyph hidden in a jar or chest atop the Stonewatch tower.",
    "An empty liquor jar on a pair of barrels took the glyph. Now Theocritus could reach into the minds within Stonewatch Keep.",
    "The glyph went into a forgotten jar at the top of the watch tower, where it would not be noticed.")
q(249, "Morganth", R, 27, MG,
    "Theocritus had learned Morganth's plan. The warlock sought the Scythe of Elune and might already have found it.",
    "Theocritus would not face Morganth himself, but feared the warlock had to be stopped now. He wanted the Pendant of Shadow from the Tower of Ilgalar.",
    "Morganth was defeated, and Theocritus said Stormwind had been saved from a grave peril. He offered his reward humbly and wished luck in the conflicts ahead.",
    "Morganth's Pendant of Shadow reached Theocritus. The warlock who had sought the Scythe of Elune was defeated, and the high mage spoke of a kingdom spared.", 5)
P.questIDs[169].highlight = {"Gath'Ilzogg, who had led the Blackrock attack on Stonewatch Keep, was dead. Solomon called his head the first step toward reclaiming the keep.", "Solomon received the head of Gath'Ilzogg, the orc whose raids had killed many in Redridge. He spoke of taking Stonewatch back for Stormwind."}
P.questIDs[219].highlight = {"Corporal Keeshan, captured when the orcs overran his regiment, escaped the Blackrock cave and reached Lakeshire.", "Keeshan, one of the few left of a fallen regiment, came back to Lakeshire from a Blackrock cave. Marris rewarded his rescue."}
P.questIDs[249].highlight = {"Morganth, the warlock who sought the Scythe of Elune, was defeated in the Tower of Ilgalar. Theocritus called Stormwind spared a grave peril.", "Theocritus received Morganth's Pendant of Shadow. His long watch on his rival ended with the warlock defeated."}
P.questIDs[126].highlight = {"Yowler, the gnoll leader whose cry carried over the hills above Lakeshire, was dead. Verner noted that the army had no troops to spare for gnolls.", "Verner received Yowler's paw. The gnoll pack's leader would hunt the Lakeshire hills no more."}

-- Overnight 2026-11-05, Duskwood: Jitters at Raven Hill, Sven's camp and the
-- search for the shadowy figure (shares the world pack's world_sven thread
-- with 55 and 95), Calor's worgen hunts for Master Carevin, Viktori's star
-- device, and the Embalmer after the hermit's letter. Jitters is named only
-- from 163/240/453 on; the dark riders and Morbent Fel only where the stage's
-- own text names them (226, 268, 323).
P.threads.world_sven = "Sven Yorgen's search for vengeance"
P.threads.alliance_carevin = "Master Carevin's hunt against the worgen"
P.threads.alliance_stars = "Viktori's star-viewing device"
local DW, SV, CV, VS = "alliance_duskwood", "world_sven", "alliance_carevin", "alliance_stars"
q(163, "Raven Hill", D, 20, DW,
    "Calor swore something haunted the buildings at Raven Hill. Two nights running he had seen shadows move there, and before that a light in a window.",
    "Strange lights and moving shadows at Raven Hill had Calor convinced a monster had moved in.",
    "The haunting at Raven Hill turned out to be a frightened man begging not to be killed. He insisted he was only harmless Jitters.",
    "Raven Hill's monster was Jitters, terrified, who swore there were things everywhere that he could not escape.")
q(240, "Return to Jitters", D, 20, DW,
    "Grual's crab cakes were ready for Jitters at last.",
    "The cakes from the Scarlet Raven's kitchen were bound for Jitters in the deserted settlement where he hid.",
    "Jitters ate the crab cakes, said they hit the spot, and paid for them as he had promised.",
    "After weeks of grubs and weeds, Jitters had a proper meal, and he paid for it.")
q(245, "Eight-Legged Menaces", D, 21, DW,
    "Spiders had taken over Duskwood's western border, too many for the watchers there. The Commander had no one to spare so far from Darkshire.",
    "Watcher Dodds asked for help rooting out the spiders on the western border, with a warning to avoid their venom.",
    "Dodds remarked that the spider hunt had left its hunter not much the worse for wear. He paid the reward he had promised on the Night Watch's behalf.",
    "Fewer spiders held the western border, and the Night Watch was grateful for the work.")
q(226, "Wolves at Our Heels", D, 21, SV,
    "Lars and Sven lived alone at their camp and hunted their own food. Every time Lars came back with meat, starving dire wolves came out of the forest after it.",
    "Dire wolves prowled north and east of Sven's camp, near the river, and Lars wanted them thinned.",
    "The pack was thinned, and Lars said the camp could now turn its mind to Morbent Fel. He paid in flash bundles, many of them donated to Sven's cause.",
    "With fewer wolves at their heels, Lars and Sven had an easier time of it. Lars paid with flash bundles made in town.")
q(164, "Deliveries to Sven", D, 23, SV,
    "Sven and his few followers kept a camp at the northwestern edge of Duskwood. They could not spare a man to fetch supplies. Elaine Carevin sent them some.",
    "Elaine Carevin called Sven a man doing the work of the Light, and had supplies waiting for his camp.",
    "Sven welcomed the supplies and the Carevin family's aid, and paid a little for the trouble.",
    "Supplies from the Carevins reached Sven's camp on the northwestern edge of the forest.")
q(90, "Seasoned Wolf Kabobs", D, 25, DW,
    "Chef Grual's seasoned wolf kabobs were a house favorite at the Scarlet Raven. His Stormwind herbs had arrived; only lean wolf flanks were missing.",
    "Grual needed ten lean wolf flanks before he could cook his kabobs, and Duskwood had no shortage of wolves.",
    "Grual took the flanks and served up his seasoned wolf kabobs.",
    "The wolf flanks met Grual's Stormwind seasoning, and the Scarlet Raven's favorite dish was made.")
q(101, "The Totem of Infliction", D, 25, DW,
    "Madame Eva said the winds spoke of great danger ahead. She offered to enchant a Totem of Infliction from ghoul fangs, skeleton fingers and spider venom.",
    "A totem that harmed attackers could be made, Madame Eva said. It needed the fangs and fingers of Duskwood's dead and the venom of its spiders.",
    "Eva enchanted the totem and said she saw much bloodshed to come. Courage, she warned, would be needed.",
    "Madame Eva handed over the Totem of Infliction, meant as a comfort when danger came close.")
q(230, "Sven's Camp", D, 25, SV,
    "The mound at Sven's farm held a small, dirt-stained book with no title. Its pages held something Sven would want to know.",
    "A book dug out of the mound by Sven's barn was meant for Sven at his camp.",
    "Sven read the pages and slammed the book shut. The shadowy figure he had seen, he said, had witnessed his family's death, and he wanted to know who that was.",
    "The book told Sven that the stranger at his farm had seen his family die. He had questions for that witness, if only he knew who it was.", 4)
q(262, "The Shadowy Figure", D, 25, SV,
    "Sven wanted to find the skulker he had seen the night his family was killed. The book from the farm was the only clue.",
    "Perhaps someone in Darkshire could link the book from Sven's farm with its owner.",
    "Madame Eva read the book's impressions. Someone driven by revenge had handled it lately; its first owner, she said, was not from Darkshire.",
    "Eva could tell little from the faint traces of the book's first owner, except that he was a stranger to Darkshire.")
q(265, "The Shadowy Search Continues", D, 25, SV,
    "The book's author was a stranger to Darkshire, Eva said, but the book itself had been bought in town.",
    "Clerk Daltry sold blank books to scholars and mages, and remembered everyone who had bought one lately.",
    "Daltry remembered selling the book a month before to a nervous, jittery man who kept looking over his shoulder. The buyer had not given his name.",
    "The buyer had been a shady sort, Daltry recalled, always glancing behind him.")
q(266, "Inquire at the Inn", D, 25, SV,
    "If the book's owner had spent time in Darkshire, someone at the Scarlet Raven would have seen him.",
    "The search for the book's owner moved to the inn, where travelers still passed through.",
    "Smitts remembered the book. Its owner had rented a room for a few days and written at the bar each night. Then the writer fled west, muttering that something hunted him.",
    "The tavernkeeper recalled a guest who had hurried west out of town, looking for a new place to hide, perhaps at Raven Hill.")
q(453, "Finding the Shadowy Figure", D, 25, SV,
    "Smitts hoped the man would be found alive. Once he had left Darkshire, he was prey to the beasts of the wilds.",
    "The trail of the book's owner led west of Darkshire, toward Raven Hill.",
    "Jitters sighed and admitted he had written the book. Anyone who had read it, he said, knew only half of what happened.",
    "The shadowy figure was Jitters. The book was his, and he said there was more to tell than it held.", 4)
q(268, "Return to Sven", D, 25, SV,
    "Jitters had left his half-finished account at Sven's farm when he fled. He gave up the completed one rather than face Sven's wrath himself.",
    "Jitters's finished account described more fully what had happened at Sven's farm. Jitters wanted Sven to have it without seeing him.",
    "The account set Sven against the dark riders. He had seen them in Duskwood, speaking with the wizard Morbent Fel at the Forlorn Rowe.",
    "Sven read Jitters's account and named his enemies, the dark riders and the wizard Morbent Fel, whom he had seen speaking with them at the Forlorn Rowe.", 5)
q(323, "Proving Your Worth", D, 28, SV,
    "Sven named Morbent Fel a necromancer and an ally of the dark riders. Before sending anyone against him, he wanted proof of skill against the necromancer's minions.",
    "Bravery had already been shown; Sven now wanted Morbent Fel's minions faced before he would trust anyone against the necromancer himself.",
    "Sven no longer doubted the fighting skill he had tested. Such resolve, he said, might yet bring about Morbent Fel's end.",
    "The minions were beaten, and Sven judged the strength proven for the fight against Morbent Fel.")
q(173, "Worgen in the Woods", D, 28, CV,
    "Calor had left the Night Watch, disillusioned, to join Master Carevin's fight against evil in Duskwood. Anyone who wished to join had to prove it against the Nightbane Shadow Weavers.",
    "Worgen called Shadow Weavers haunted Brightwood Grove and the Rotting Orchard, and Calor wanted anyone who would join Carevin to prove it against them.",
    "Calor was impressed. He found it curious that the worgen seemed to appear out of thin air. They were only one of many strange creatures on Duskwood's borders.",
    "The Shadow Weavers were thinned, and Calor offered a harder challenge. Where the worgen came from still puzzled him.")
q(221, "Worgen in the Woods", D, 29, CV,
    "Larger worgen called Dark Runners made up most of the pack and had overrun the Rotting Orchard southwest of town.",
    "Calor warned that the Dark Runners were tougher than the Shadow Weavers.",
    "The Dark Runners fell, but Calor said more always came to fill their ranks. He put his faith in Master Carevin to find out what drew them.",
    "Every gain against the worgen seemed to bring more of them, Calor said. What evil power drew them to Duskwood, he could not tell.")
q(222, "Worgen in the Woods", D, 31, CV,
    "The Vile Fangs and the Tainted Ones were the most dangerous worgen in Duskwood. They had settled near the caves and the mine to the south, where their bonfires showed from afar.",
    "The time had come, Calor judged, to face the Vile Fangs and the Tainted Ones.",
    "Calor admitted he had not expected the hunt to get this far. He offered a letter of recommendation to Master Carevin.",
    "The Vile Fangs and Tainted Ones were beaten, and Calor offered a written recommendation to Master Carevin.")
q(223, "Worgen in the Woods", D, 31, CV,
    "Calor's faded parchment recommended its bearer to Master Carevin. A few more such recruits, he said, and they would outnumber the Night Watch.",
    "Calor's letter of recommendation was for Jonathan Carevin, the master of his small band.",
    "Carevin apologized for a cold reception; he was a busy man. Calor's recommendation was no small thing, and he welcomed help against demons, the undead and those who aided them.",
    "Master Carevin read Calor's letter and accepted the recommendation, warning to trust none who would not aid the cause.", 4)
q(174, "Look to the Stars", D, 25, VS,
    "Viktori Prism'Antras believed a truth beyond magic could explain the change in the forest. With a blueprint from his gnome friend Cog, he meant to build a device for looking at the stars.",
    "Cog's blueprint called first for a bronze tube made by a skilled engineer.",
    "The bronze tube was perfect, Viktori said. The first step was done.",
    "Viktori had his bronze tube, the first part of Cog's design.")
q(175, "Look to the Stars", D, 25, VS,
    "The device needed something to reflect light. Viktori remembered Mary, once known in southern Duskwood for always carrying a looking glass.",
    "Cog's blueprint called for a reflecting surface, and Viktori thought of a woman named Mary and her looking glass.",
    "Mary admitted she had once owned a looking glass.",
    "Blind Mary remembered the looking glass she used to own.")
q(177, "Look to the Stars", D, 25, VS,
    "Mary had thrown the looking glass behind the barn after what she called the incident. An Insane Ghoul that roamed there might have taken it to the Tranquil Gardens Cemetery.",
    "Rumor placed Mary's discarded looking glass with an Insane Ghoul in the Tranquil Gardens Cemetery.",
    "The looking glass reached Viktori, who said it would work perfectly.",
    "Viktori had his reflector at last, and gave many thanks.")
q(181, "Look to the Stars", D, 30, VS,
    "Viktori knew of only one lens large enough for the device. It was the monocle of Zzarc'Vul, an ogre living in the mound in southern Duskwood.",
    "The last piece of Cog's design was a lens, and Viktori had his eye on the ogre Zzarc'Vul's monocle.",
    "The monocle became the lens, and the stargazing device was complete. Viktori could go on with his research.",
    "Zzarc'Vul's monocle finished Viktori's device, and he meant to continue his research.", 4)
q(251, "Translate Abercrombie's Note", D, 30, HM,
    "Nobody in Darkshire could read Abercrombie's letter, and Sirra Von'Indi was learned in old languages and arts.",
    "Ello sent the hermit's unreadable note to Sirra Von'Indi for translation.",
    "Sirra had never met Abercrombie, though he thought anyone living out by the graveyard had lost his wits. He began translating.",
    "The note reached Sirra Von'Indi, who set to work on its translation.")
q(401, "Wait for Sirra to Finish", D, 30, HM,
    "Sirra was nearly finished with Abercrombie's note and needed only a few more moments.",
    "The translation of the hermit's letter was almost done.",
    "Sirra finished the translation. As he did, the air grew heavy, as if a black curtain had been drawn over the land.",
    "Sirra's work was done, and a heaviness settled over Darkshire.")
q(252, "Translation to Ello", D, 30, HM,
    "Sirra feared Abercrombie had done something unspeakable, and that a doom was already lumbering toward the town. The translation had to reach Ello quickly.",
    "The translated note was bound for Mayor Ello Ebonlocke, with Sirra's warning to hurry.",
    "Ello read the letter and went white. The help given to Abercrombie, kindly meant or not, had doomed Darkshire, he said, and then he fell silent.",
    "The translation left Ello pale. Whatever kindness had been shown the hermit, Ello said, it had brought ruin on the town.", 5)
q(253, "Bride of the Embalmer", D, 30, HM,
    "Darkshire's children were told of the Embalmer, Ello said, once a kindly alchemist. Maddened by his wife Eliza's death, he had put his own heart in her body to bring her back. His power lay in that heart.",
    "Eliza's grave held the Embalmer's still-beating heart. Ello believed taking it would break his power.",
    "The heart reached Ello still beating. Its magic, he said, would guard Darkshire against the Embalmer's evil, and the town would not forget the deed.",
    "Ello received the Embalmer's heart and called it a powerful aegis over Darkshire.", 5)
P.questIDs[230].highlight = {"A book buried at Sven's farm told him that the shadowy figure he had seen had witnessed his family's death.", "Sven read the book from the mound and slammed it shut. The stranger at his farm had seen his family die, and Sven wanted to know who it was."}
P.questIDs[453].highlight = {"The trail of the book west of Darkshire ended with Jitters. He admitted he had written it, and said it held only half of what happened.", "The shadowy figure from Sven's farm was Jitters, hiding west of town. He owned up to the book, and to knowing more than it said."}
P.questIDs[268].highlight = {"Jitters's finished account reached Sven and set him against the dark riders and the wizard Morbent Fel, whom he had seen together at the Forlorn Rowe.", "Sven read what Jitters had written and turned his grief toward the dark riders and Morbent Fel."}
P.questIDs[223].highlight = {"Calor's recommendation reached Jonathan Carevin, who welcomed help against demons, the undead and those who aided them.", "Master Carevin accepted Calor's letter after the worgen hunts and asked for vigilance against all who would not aid his cause."}
P.questIDs[181].highlight = {"Zzarc'Vul's monocle became the lens of Viktori's star-viewing device, finishing the machine built from Cog's blueprint.", "Viktori's device was complete once the ogre's monocle was in place, and he could go on with his research."}
P.questIDs[252].highlight = {"Ello Ebonlocke read the hermit's translated letter and went white. The help given to Abercrombie, he said, had doomed Darkshire.", "The translation of Abercrombie's note reached the mayor. He said the help given the hermit had brought ruin on the town."}
P.questIDs[253].highlight = {"Eliza's grave gave up the Embalmer's still-beating heart. Ello Ebonlocke called it a shield for Darkshire against the Embalmer's evil.", "The Embalmer's heart reached Ello still beating. Its magic would guard Darkshire, he said."}

-- Overnight 2026-11-05, Dun Morogh: Coldridge's first trogg and troll work,
-- a gnome refugee's belongings, the mug and the inn supplies through the pass,
-- the siege pilots' errands, the lost pilot Hildelve, and the Barleybrews'
-- Shimmer Stout. Hildelve's death is found in 419; Mangeclaw dies only in 417.
q(170, "A New Threat", "Dun Morogh", 2, C,
    "Troggs were turning up across the dwarven lands, and Coldridge Valley was no exception. A few nights before, they had overrun a camp to the west. Balir Frosthammer needed strong arms to drive them back.",
    "Balir Frosthammer was shorthanded after the last trogg attack. Troggs had been seen in the hills to the southeast and near the frozen lake.",
    "Balir thought that if Coldridge's troubles were a sign of things elsewhere, there were hard times ahead. He hoped the king and the Senate were taking steps against the troggs.",
    "Fewer troggs roamed Coldridge's hills. By Magni's beard, Balir said, there was trouble ahead if the rest of the land fared the same.")
q(3361, "A Refugee's Quandary", "Dun Morogh", 3, G,
    "Felix Whindlebolt had fled Gnomeregan's radiation without his belongings. Frostmane trolls had carried his chest, his box and his bucket of bolts to their camps southwest of Anvilmar.",
    "The fall of Gnomeregan had scattered its gnomes across Dun Morogh. Felix Whindlebolt was no adventurer, and his tools were in troll hands.",
    "Felix called the finder an absolute savior when his things came back, and paid what little he could.",
    "The chest, the box and the bucket of bolts reached Felix. It was not much, he said, but he paid for the trouble.")
q(182, "The Troll Cave", "Dun Morogh", 4, C,
    "Grelin Whitebeard and his brother Senir had been sent to look into the trolls of Dun Morogh. In Coldridge Valley, Grelin judged a few strong arms would handle the Frostmane in the southern cave.",
    "The Senate had its hands full with the troggs, so Grelin wanted the Frostmane trolls in Coldridge's southern cave dealt with by hired help.",
    "Grelin cursed the trolls when the work was done. A group of them had stolen his notebook in the night, and he started to blame a good-for-nothing apprentice.",
    "The Frostmane in the southern cave were thinned, but Grelin had worse news. Trolls had taken his notebook in the night.")
q(3365, "Bring Back the Mug", "Dun Morogh", 5, C,
    "Durnan Furcutter had drunk his scalding mornbrew, and the empty mug belonged back with Nori Pridedrift.",
    "Mugs did not grow on trees, by Nori's account, and Durnan's empty one still had to go back.",
    "Nori was pleased. Plenty of couriers forgot something as simple as bringing back the mug, and a small reward followed.",
    "The mug went back to Nori, who paid a little for remembering it.")
q(2160, "Supplies to Tannok", "Dun Morogh", 5, M,
    "Hands Springsprocket could not get through the trogg-held pass himself, and a mountaineer escort was days away. He had a package for Tannok Frosthammer at the Kharanos inn.",
    "Hands Springsprocket could not get through the pass himself. His package for the inn at Kharanos was waiting.",
    "Tannok had begun to worry; there had been scarce word from Anvilmar since the troggs took the pass. He offered the courier a seat by the fire.",
    "The supplies from Hands reached Tannok Frosthammer at the inn in Kharanos, after a long wait.")
q(313, "The Grizzled Den", "Dun Morogh", 7, M,
    "Pilot Stonegear wanted wendigo manes from the Grizzled Den to make a rug for the inside deck of his siege engine, Trollplow.",
    "Driving a siege engine took an iron grip and nerves of steel, Stonegear said. He wanted proof of both in wendigo manes.",
    "The manes would make a fine rug for Trollplow. Stonegear praised the grit it took and wagered on great things to come.",
    "Stonegear took the wendigo manes for Trollplow's deck and said the work showed a lot of grit.")
q(318, "Evershine", "Dun Morogh", 7, M,
    "Pilot Bellowfiz wanted Evershine from Rejold Barleybrew in Brewnall Village. It kept him warm on the road and burned hot enough to give his engine Jetsteam a burst of power.",
    "Rejold Barleybrew's Evershine could lay all but the stoutest dwarf flat, and Bellowfiz wanted some for the cold road.",
    "Rejold agreed, after a moment's thought, to spare some Evershine for Bellowfiz.",
    "The request reached Rejold at Brewnall, who allowed that Bellowfiz could have some of his Evershine.")
q(419, "The Lost Pilot", "Dun Morogh", 10, M,
    "Mori Hildelve had gone on foot into the hills to look for a rare ore for high-grade blastpowder. Pilot Hammerfoot stayed behind to guard their engines. Days had passed, and beasts growled in the hills at night.",
    "Hammerfoot's friend and fellow pilot, Mori Hildelve, had been missing in the mountains for days.",
    "Hildelve's body lay mauled and frozen, picked clean by scavengers, his notes still in his hand and a Brigadier's Vest on his frame.",
    "The search ended at a dwarf's frozen corpse. The notes in its hand were Mori Hildelve's; the pilot had died up in the hills.", 4)
q(417, "A Pilot's Revenge", "Dun Morogh", 11, M,
    "Hildelve had written that an ice claw bear named Mangeclaw mauled him. The bear must have come back to finish him, and his last wish was revenge.",
    "Hildelve's notes ended with one wish, revenge on Mangeclaw.",
    "Hammerfoot called it grim news, for Hildelve had been a good friend. He wished he had been there for Mangeclaw, and said the pilots of the Siege Brigade would remember the deed.",
    "Mangeclaw was dead and Hildelve's last wish granted. Hammerfoot promised the Ironforge Siege Brigade would remember it.", 4)
q(413, "Shimmer Stout", "Dun Morogh", 10, M,
    "Rejold Barleybrew wanted his brother Wellart, a mountaineer at the southern guard tower on the border with Loch Modan, to try his new Shimmer Stout.",
    "Wellart was no brewer like the rest of the Barleybrews, but he loved his drink. Rejold had a barrel of Shimmer Stout for him.",
    "Wellart tasted the stout and swore it put a shine in his eyes. He felt he could see in the dark.",
    "The Shimmer Stout reached Wellart's tower. One taste, and he claimed he could see in the dark.")
q(414, "Stout to Kadrell", "Loch Modan", 10, M,
    "Wellart wanted another mountaineer to try his brother's Shimmer Stout, and chose Kadrell, who patrolled the road through Thelsamar.",
    "A cask of Shimmer Stout was bound for Mountaineer Kadrell in Thelsamar.",
    "Kadrell tasted it and swore by Magni's beard that it set his head turning and lightened his limbs. He felt he could fly.",
    "The stout reached Kadrell in Thelsamar, who declared it made him feel he could fly.")
q(415, "Rejold's New Brew", "Dun Morogh", 10, M,
    "Rejold Barleybrew was asking for the one who had brought him shimmerweed. He had a new drink to talk about.",
    "Word came that Rejold wanted help with a new brew at Brewnall Village. There might be free drink in it.",
    "Rejold had used the shimmerweed in a few recipes, and one turned out great. He handed over a sample to try.",
    "The shimmerweed had become a new brew at Brewnall, and Rejold wanted an opinion on it.")
q(312, "Tundra MacGrann's Stolen Stash", "Dun Morogh", 12, M,
    "Old Icebeard had carried off Tundra MacGrann's thorium meat locker, a month of salted meat for the cold season. MacGrann's bad leg kept him from the yeti's cave.",
    "MacGrann would starve without his stash, and Old Icebeard had it in his cave.",
    "MacGrann called the finder a kind soul. With his meats back, he would not starve when the cold season came.",
    "The meat locker came back from Old Icebeard's cave, and MacGrann's winter was provided for.")
q(314, "Protecting the Herd", "Dun Morogh", 12, M,
    "Vagash had taken two rams from the Amberstill herd in the night. With most of Magni's army fighting with the Alliance far away, no one kept the beast at bay.",
    "Vagash preyed on the Amberstill ranch from the hills above, and Rudra Amberstill wanted one of his fangs as proof of his death.",
    "Rudra took Vagash's fang. Veron would be happy at the news, and Rudra pictured the slayer fighting beside Magni's soldiers on the Alliance Front one day.",
    "Vagash was dead, and the Amberstill herd was safe from him. Rudra said Veron would be glad to hear it.", 4)
P.questIDs[419].highlight = {"Mori Hildelve, missing in the hills while searching for rare ore, was found mauled and frozen with his notes in his hand.", "The search for Pilot Hammerfoot's lost friend ended at Hildelve's frozen body high in the hills."}
P.questIDs[417].highlight = {"Mangeclaw, the bear that had killed Mori Hildelve, was dead. Hammerfoot said the Siege Brigade's pilots would remember the deed.", "Hildelve's last wish was revenge on Mangeclaw, and it was granted. Hammerfoot mourned a good friend."}
P.questIDs[314].highlight = {"Vagash, who had been taking rams from the Amberstill herd, was dead, and Rudra had the fang to show Veron.", "The beast preying on Amberstill Ranch fell, and Rudra imagined its slayer someday on the Alliance Front."}

-- Overnight 2026-11-05, Teldrassil: Iverron and Dirania, Gilshalan's spider
-- specimens, Tenaron's summons, Denalan's timberlings (seeds, sprouts, tumors,
-- Oakenscowl, the moss-twined heart), the Gnarlpine corruption through Ursal,
-- Mist, and the Oracle Tree's message. Ursal's death permits the ritual, not
-- a recorded awakening; Oakenscowl's tumor is a specimen, not a cure.
P.threads.alliance_timberlings = "Denalan's study of the timberlings"
local TB = "alliance_timberlings"
q(4495, "A Good Friend", T, 4, S,
    "Iverron visited Dirania Silvershine at the same hour every day, and today he was hours late. He often went near the spider cave to the north.",
    "Dirania was worried about her friend Iverron. He had not come by, and spent much of his time near the Shadowthread Cave.",
    "Iverron was found, very glad of it, and puzzled that anyone had known where to look.",
    "The search for Dirania's friend ended with Iverron, relieved to be found.")
q(3519, "A Friend in Need", T, 4, S,
    "Iverron had been bitten by a spider named Githyiss the Vile in the cave nearby. Poisoned and dizzy, he begged for word to reach Dirania Silvershine.",
    "Githyiss the Vile's bite had left Iverron badly poisoned, and he was sure Dirania could help him.",
    "Dirania had wondered why Iverron had not come by. She had always warned him about those spiders.",
    "Word of Iverron's poisoning reached Dirania, who had long warned him about the spiders.", 4)
q(916, "Webwood Venom", T, 4, S,
    "Gilshalan Windwalker had come to Shadowglen to study the webwood spiders of Shadowthread Cave. He believed the World Tree had changed them from their smaller cousins, and wanted their venom.",
    "Webwood venom sacs, set beside the venom of ordinary spiders, could show Gilshalan how Teldrassil had changed its spiders.",
    "Gilshalan took the venom sacs to compare in Darnassus. He expected them to show properties linked to the new World Tree's growth.",
    "With the venom in hand, Gilshalan could test his idea about the World Tree's spiders once he was back in Darnassus.")
q(917, "Webwood Egg", T, 5, S,
    "Gilshalan wanted live specimens. An unhatched egg from the nest deep in Shadowthread Cave was easier to carry than a giant spider.",
    "A spider egg from the heart of Shadowthread Cave would let Gilshalan study the webwood spiders alive.",
    "Gilshalan would send the egg and the venom to Darnassus and follow when his work in Shadowglen was done. He expected to learn a great deal.",
    "The egg went to Gilshalan, bound for Darnassus along with the venom.")
q(920, "Tenaron's Summons", T, 5, O,
    "Tenaron Stormgrip had sent for help by name, and he waited in the highest room atop Aldrassil.",
    "Night elves lived long lives, but Tenaron was not one to keep waiting. His summons came by way of Gilshalan.",
    "Tenaron was pleased by a prompt answer to his summons. He had an important task in mind.",
    "At the top of Aldrassil, Tenaron greeted the one he had summoned and spoke of an important task.")
q(997, "Denalan's Earth", T, 5, B,
    "Denalan had asked Darnassus for a package of rare earths for his plant studies at Lake Al'Ameth. It had arrived late in Dolanaar.",
    "A package of rare earth sat in Dolanaar, overdue for Denalan's camp at the eastern end of Lake Al'Ameth.",
    "Denalan had waited a long time for the rare earth and hoped it was still fresh.",
    "The package reached Denalan's camp by the lake, and he thanked the courier for the time it took.")
q(918, "Timberling Seeds", T, 7, TB,
    "The timberlings reflected the natural order of the tree, and Denalan was disturbed to see them so angry. He blamed the soil, and wanted their seeds to try his methods on.",
    "Denalan meant to plant timberling seeds in soil he had prepared, hoping they would grow into gentler creatures.",
    "Denalan took the seeds to plant in his special soil, hoping they would sprout into docile timberlings.",
    "The seeds were ready for Denalan's prepared soil; whether they would grow gentler was yet to be seen.")
q(919, "Timberling Sprouts", T, 7, TB,
    "Timberling sprouts were coming up around Lake Al'Ameth, and Denalan feared they were beyond help. He wanted them cleared before they grew.",
    "Every timberling sprout found by the lake had to be taken, Denalan said, before it grew large enough to cause trouble.",
    "Denalan was alarmed at how many sprouts there were; they were spreading fast. He hoped to solve the riddle of what tainted them.",
    "Many sprouts were taken from the lakeshore. Denalan feared how fast they spread and did not yet know their taint.")
q(922, "Rellian Greenspyre", "Darnassus", 7, TB,
    "Denalan sent one of the timberling seeds to his friend Rellian Greenspyre. Rellian was a druid of the Cenarion Enclave with ideas of his own.",
    "Rellian Greenspyre in Darnassus had shown interest in Denalan's timberling work and wanted a seed to work with.",
    "Rellian had bad news. A corruption had grown in many timberlings, and their seeds carried the taint beyond his skill. Denalan might be their only hope.",
    "The seed reached Rellian, who had already found that tainted timberlings passed their corruption to their seeds. He placed his hope in Denalan.")
q(923, "Tumors", "Darnassus", 9, TB,
    "A malevolence was growing in the timberlings, worst at Wellspring Lake. Until its source was found, Rellian wanted the tainted ones cut down and their tumors brought to be burned.",
    "Rellian Greenspyre asked for the mossy tumors of Wellspring Lake's timberlings, the symptom of their disease.",
    "The tumors were to be destroyed. They were filled with a poison, Rellian said, that had to be cleansed from the new land.",
    "The mossy tumors went to Rellian for burning; the source of the poison was still unknown.")
q(2498, "Return to Denalan", T, 9, TB,
    "Word reached Rellian that Denalan might have found the cause of the timberlings' tumors, and needed help.",
    "Rellian sent help back to Denalan at Lake Al'Ameth in haste.",
    "Denalan was glad Rellian had sent help so soon. He had discovered something disturbing.",
    "At the lake, Denalan welcomed the help Rellian had sent, with something disturbing to tell.")
q(2499, "Oakenscowl", T, 9, TB,
    "Oakenscowl, a timberling in a cave on the lake's southern bank, was being poisoned by a gargantuan tumor. From the timberling, the corruption was spreading to the creatures of Lake Al'Ameth.",
    "Denalan wanted Oakenscowl hunted down and its great tumor brought back, to remove a source of corruption from his home.",
    "Denalan said Oakenscowl had once been a grand leader of its kind; corruption did not choose between the lowly and the noble. He meant to study the tumor.",
    "Oakenscowl was dead and its tumor in Denalan's hands, a disturbing specimen for his study of the timberlings' disease.", 4)
q(930, "The Glowing Fruit", T, 10, TB,
    "A glowing plant held a large round fruit beneath its fronds, the kind of thing Denalan would want to study.",
    "The fruit hanging from the glowing plant looked worth bringing to Denalan.",
    "Denalan found the fruit exotic, perhaps grown from seeds carried from far away. He noted that it had reacted strangely with Teldrassil's soil.",
    "Something about the fruit had reacted strangely with Teldrassil's soil, and Denalan set about studying it.")
q(927, "The Moss-twined Heart", T, 12, TB,
    "Blackmoss the Fetid's heart was covered in dark, oily moss, and it was still beating slowly.",
    "A heart taken from Blackmoss the Fetid kept up a slow beat under its moss. Denalan would want to see it.",
    "Under the foul moss was a timberling heart, to Denalan's surprise. He meant to examine it and learn what the moss was.",
    "The heart reached Denalan, who hoped to determine the nature of the moss around it.")
q(941, "Planting the Heart", T, 12, TB,
    "Denalan had cleaned the moss from the heart, but it was still tainted. His planter of nourishing soil might heal it.",
    "Denalan's planter held soil he had prepared, and he hoped it would cleanse the timberling heart.",
    "The heart dug itself into the planter and wriggled back out a few moments later, cleansed and pulsing.",
    "The prepared soil cleansed the heart, and it came back out of the planter pulsing faintly.", 4)
q(475, "A Troubling Breeze", T, 6, B,
    "Gaerolas Talvethren, Great Warden of the sleeping Druids of the Talon at Ban'ethil, had sent no word lately. Athridas Bearmantle wanted a report from Starbreeze Village.",
    "Athridas grew nervous when news from the warden of Ban'ethil was late. He sent someone to Starbreeze to find him.",
    "Gaerolas thanked the forest spirits for the help Athridas had sent; he had trouble to report.",
    "At Starbreeze, Gaerolas said he had known Athridas would sense trouble and send help.")
q(476, "Gnarlpine Corruption", T, 6, B,
    "The Gnarlpine furbolgs had ambushed Gaerolas and pillaged Starbreeze. Their chieftain, Ursal the Mauler, was driving them mad with Fel Moss. The wounded warden could not carry the news himself.",
    "Gaerolas was too hurt to bring Athridas the news that the once peaceful Gnarlpine had turned on the forest's protectors.",
    "Athridas called the news from Starbreeze disturbing indeed. The Gnarlpine had turned, and Ursal the Mauler was behind it.",
    "Word of the Gnarlpine's corruption, and of Ursal the Mauler's Fel Moss, reached Athridas in Dolanaar.", 4)
q(489, "Seek Redemption!", T, 7, B,
    "The Council of the Forest knew Zenn Foulhoof had been helped, and wanted amends. Fel cones, corrupted seeds that billowed green smoke, would pass with the satyr for a harmless snack.",
    "Aiding Zenn Foulhoof had cost the council's trust. Redemption meant feeding the satyr fel cones.",
    "Zenn accepted the fel cones gladly, sure they were a treat.",
    "The satyr took the smoking fel cones for a harmless snack, just as the council intended.")
q(2459, "Ferocitas the Dream Eater", T, 8, B,
    "The emerald was missing from Tallonkai's dreamcatcher. Ferocitas the Dream Eater, leader of the Gnarlpine mystics north of Starbreeze, wore a necklace that glowed green at night.",
    "Tallonkai was sure Ferocitas had stolen his emerald, though its power was useless to the furbolg.",
    "The emerald came back, and Tallonkai could repair his dreamcatcher.",
    "Tallonkai thanked the one who recovered his emerald; the dreamcatcher could be mended.")
q(487, "The Road to Darnassus", T, 8, B,
    "Gnarlpine ambushers were attacking travelers on the road from Dolanaar to Darnassus, which carried news and trade every day.",
    "A Sentinel watching the road wanted the Gnarlpine ambushers in the den below cut down.",
    "The ambushers were fewer, and the Sentinel saluted the service to Dolanaar and Darnassus.",
    "The road to Darnassus was safer, and the Sentinel force of Teldrassil gave its salute.")
q(938, "Mist", T, 12, B,
    "A wounded gray sabercat lay with deep cuts across her back and stomach. She raised her head and seemed to want to follow.",
    "Mist was badly hurt, and her companion, Sentinel Arynia Cloudsbreak, blamed herself for letting the harpy witches take her.",
    "Arynia had feared she would never see Mist again. She gave thanks, and her lasting gratitude, for the sabercat's return.",
    "Mist came back to Arynia Cloudsbreak, who had thought her faithful companion dead.", 4)
q(940, "Teldrassil", "Darnassus", 11, B,
    "With the harpies forced from their nests, the Oracle Tree felt calm return to the forest. After losing one messenger, it trusted this one to carry its word to the Arch Druid.",
    "The Oracle Tree had a message for Fandral Staghelm, the first since harpies killed its last messenger.",
    "Fandral had wondered why the Oracle Tree had been silent. Some problems were lessening while others grew, he said. He feared his work on Teldrassil would never be done nor immortality restored.",
    "The message reached Fandral. He feared the night elves' immortality would never return, but rewarded the Oracle Tree's messenger.", 4)
q(486, "Ursal the Mauler", T, 12, B,
    "Athridas would prepare the Relics of Wakening, but the ritual could only work once Ursal the Mauler was slain. The Gnarlpine chieftain held Gnarlpine Hold in the southwest.",
    "Ursal the Mauler had meddled with the Druids of the Talon. Athridas said Ursal had to pay before they could be freed.",
    "Ursal was dead, and Athridas called the deed worthy and honorable. He asked the forest spirits to protect the one who had done it.",
    "With Ursal the Mauler slain, the ritual Athridas prepared could be completed.", 5)
P.questIDs[3519].highlight = {"Iverron, poisoned by Githyiss the Vile, sent word to Dirania Silvershine, who had always warned him about the spiders.", "Dirania learned that a spider had poisoned Iverron in the cave near Shadowglen."}
P.questIDs[476].highlight = {"The wounded warden Gaerolas sent word that the Gnarlpine had turned. Athridas learned that Ursal the Mauler was driving them mad with Fel Moss.", "News of the Gnarlpine's corruption reached Athridas in Dolanaar, with Ursal the Mauler named as its cause."}
P.questIDs[2499].highlight = {"Oakenscowl, once a grand leader of the timberlings, was poisoned by a gargantuan tumor. Denalan received the tumor to study the disease.", "Denalan took Oakenscowl's great tumor, sad that corruption had reached even the noblest of the timberlings."}
P.questIDs[938].highlight = {"Mist, the wounded sabercat, came home to Sentinel Arynia Cloudsbreak, who had feared her dead.", "Arynia Cloudsbreak had blamed herself for losing Mist to the harpy witches. Her companion returned, and Arynia gave lasting thanks."}
P.questIDs[940].highlight = {"The Oracle Tree's message reached Fandral Staghelm, who feared his work on Teldrassil would never restore the night elves' immortality.", "Fandral read the Oracle Tree's word after its long silence. Some troubles had eased, he said, while others grew."}
P.questIDs[486].highlight = {"Ursal the Mauler, the Gnarlpine chieftain behind the Fel Moss, was slain. Now Athridas could complete the ritual for the Druids of the Talon.", "With Ursal the Mauler dead, Athridas could finish the ritual meant to free the sleeping Druids of the Talon."}

-- Overnight 2026-11-05, Darkshore: Nessa's fish samples from Rut'theran,
-- Terenthis and the Blackwood, the sunken captains, Anaya's spirit, the
-- tablets of Ameth'Aran, Onu and the Twilight's Hammer at the Master's Glaive,
-- Gelkak's first mate, Tharnariun's last hunt and Aynasha's ambush. The cult's
-- aim stays a fear and an inquiry; no stage here defeats it.
P.threads.alliance_nessa = "the fish of Rut'theran and Auberdine"
P.threads.alliance_twilight = "the Twilight's Hammer at the Master's Glaive"
P.threads.alliance_gyromast = "Gelkak Gyromast's first mate"
local NS, TW, GY = "alliance_nessa", "alliance_twilight", "alliance_gyromast"
q(6344, "Nessa Shadowsong", "Darnassus", 10, NS,
    "Mydrannul in Darnassus had a friend in Rut'theran Village, the fishing merchant Nessa Shadowsong. She needed a parcel taken to Darkshore.",
    "The portal west of the Temple Gardens led down to Rut'theran. There Nessa Shadowsong was looking for a courier.",
    "Nessa confirmed she needed a courier for a package bound for Darkshore.",
    "At Rut'theran, Nessa had a package for Darkshore and asked for help carrying it.")
q(6341, "The Bounty of Teldrassil", T, 10, NS,
    "Rut'theran's fish were extremely large and plentiful, and Nessa wanted them compared with the mainland's. Her collection of bones and scales was for Laird, a fish vendor in Auberdine.",
    "Nessa's collection of fish bones and scales was to fly to Auberdine with the hippogryph master Vesprystus.",
    "Vesprystus agreed to send Nessa's collection on to Auberdine.",
    "The hippogryph master heard where the package was going and was ready to carry it.")
q(6342, "Flight to Auberdine", "Darkshore", 10, NS,
    "Vesprystus advised flying to Auberdine rather than taking the ferry. Once a hippogryph master knew a traveler, the route stayed open.",
    "Nessa's collection was bound for Laird in Auberdine, by hippogryph from Rut'theran.",
    "Laird was amazed. A jawbone from Rut'theran was nearly twice the size of the same fish's on the mainland. The fish's scales were as big as a closed fist.",
    "Nessa's samples reached Laird, who found them far larger than anything caught at Auberdine.")
q(6343, "Return to Nessa", T, 10, NS,
    "Laird suspected the World Tree itself was changing the wildlife around it, and sent his answer back to Nessa.",
    "Laird's reply was for Nessa in Rut'theran, by hippogryph or by the ferry from the northwest dock.",
    "Nessa had not thought the difference was so great. She would tell the villagers, and until the cause was found, Rut'theran would reap the benefits.",
    "The reply reached Nessa, who meant to tell the villagers. Whatever made Teldrassil's fish so large, she was content to enjoy it.")
q(2178, "Easy Strider Living", "Darkshore", 12, J,
    "Alanndarian Nightsong's strider stew was a secret recipe. She would teach it to anyone who could bring her strider meat.",
    "Before sharing her strider stew, Alanndarian Nightsong wanted proof that the beasts could be handled.",
    "Alanndarian took the meat and offered a taste of the stew.",
    "The strider meat filled Alanndarian's empty pot, and her recipe was shared.")
q(953, "The Fall of Ameth'Aran", "Darkshore", 12, J,
    "Sentinel Tysha Moonblade had found two tablets in Ameth'Aran telling of the city's fall. The Highborne spirits drove her off while she read them.",
    "Ameth'Aran's tablets told how the Highborne city fell, and Tysha wanted them read for the Circle of Ancients.",
    "Tysha had few records from the time of the War of the Ancients. With the tablets read, she could deliver a full report to the Circle.",
    "The tablets' account of Ameth'Aran's fall went to Tysha, who could finish her report to the Circle of Ancients.")
q(984, "How Big a Threat?", "Darkshore", 14, J,
    "Terenthis had vowed to stop corruption among the furbolgs after some of his brethren were rescued from a corrupt furbolg in Teldrassil. He wanted a Darkshore camp scouted.",
    "Terenthis had seen hints of corruption in Darkshore and wanted to know whether the furbolgs there had fallen to it.",
    "Terenthis heard the signs of corruption and called it terrible news. With the furbolgs this close to Auberdine, the town would have to prepare.",
    "The scouting confirmed corruption in a furbolg camp near Auberdine. Terenthis began to prepare for what would follow.")
q(985, "How Big a Threat?", "Darkshore", 14, J,
    "The Blackwood camp south of Auberdine was the greatest threat to the town, and Terenthis wanted its pathfinders and windtalkers killed.",
    "Terenthis asked for a fight against the Blackwood furbolgs south of Auberdine.",
    "Terenthis said there was no need to mourn what had to be done. The threat to Auberdine was smaller, though fel moss still endangered Darkshore.",
    "Fewer Blackwood furbolgs stood south of Auberdine. Terenthis gave thanks, though Darkshore was still in danger from the fel moss.")
q(5713, "One Shot. One Kill.", "Darkshore", 15, J,
    "Sentinel Aynasha had been poisoned by the furbolg Marosh and his trackers on the road to Auberdine. She needed defending until her antidote was ready.",
    "Aynasha carried an important message to Auberdine but could barely stand after Marosh's attack.",
    "Aynasha survived her poisoning, and Onaeya at Maestra's Post welcomed the news and offered a reward.",
    "Onaeya was glad to hear that Aynasha was alive and well, and asked Elune to watch over her rescuer.")
q(963, "For Love Eternal", "Darkshore", 16, J,
    "Cerellean Whiteclaw had lost his love Anaya when Ameth'Aran fell, thousands of years before. He had seen her haunted spirit in the ruins and could not bring himself to free her.",
    "Anaya's spirit haunted the ruins of Ameth'Aran. Cerellean wanted her freed but lacked the heart to do it.",
    "Cerellean gave thanks, and wondered if he should have done it himself. Even after thousands of years, he could not raise his hand against her. He asked to be left alone with his grief.",
    "Anaya's spirit was released. Cerellean thanked the one who had done what he could not, then asked to be alone.", 4)
q(982, "Deep Ocean, Vast Sea", "Darkshore", 17, J,
    "Murlocs had sunk the Silver Dawning and the Mist Veil off Darkshore's coast. Neither captain survived, and their logs and effects still lay below in lockboxes.",
    "The surviving crews of two sunken ships wanted their captains' effects brought up from the sea floor.",
    "The captains' effects came up from the wrecks, to be properly taken care of in Auberdine.",
    "Auberdine counted the recovery a great service. The two captains' belongings could be tended at last.")
q(1138, "Fruit of the Sea", "Darkshore", 17, J,
    "Gubber Blump loved crab and could list a dozen ways to cook it. Busy fishing, he wanted fine crab chunks from the reef crawlers.",
    "Gubber had a long list of crab dishes in mind and no time to catch the crabs himself.",
    "Gubber took the crab chunks and gave away something he had fished up long ago that made no good crab dishes.",
    "The crab chunks reached Gubber, who paid with an odd find from his fishing. He wondered aloud if he had told all about crabs.")
q(947, "Cave Mushrooms", "Darkshore", 17, TW,
    "Barithras Moonshade needed rare mushrooms from a cave behind Cliffspring Falls. The Grove of the Ancients had warned him away, sensing a new evil hiding there.",
    "Barithras wanted the cave behind Cliffspring Falls scouted while his mushrooms were gathered, to test the Ancients' fears.",
    "Barithras praised the mushrooms. He had hoped the Ancients were wrong this time, but the cave bore out their warning.",
    "The mushrooms were fine specimens. What was seen at Cliffspring Falls confirmed the Ancients' warnings, to Barithras's regret.")
q(948, "Onu", "Darkshore", 17, TW,
    "Onu, an Ancient of Lore at the Grove of the Ancients, had heard about Cliffspring Falls and wished to speak. Barithras feared it was urgent.",
    "The Grove of the Ancients lay south near the mountains. There Onu waited to talk about what was seen at the falls.",
    "Onu had been expecting the visit. There were matters to discuss.",
    "At the grove, the Ancient of Lore said there were matters to discuss.")
q(944, "The Master's Glaive", "Darkshore", 17, TW,
    "Onu found the naga in Darkshore strange, and the Twilight's Hammer stranger. The cult worshiped old lords of the earth. One had fallen at the Master's Glaive to the south.",
    "Onu sent a phial of scrying to the Master's Glaive, to look for Twilight's Hammer cultists and speak through the bowl.",
    "Through the scrying bowl, Onu learned that the Twilight's Hammer was at the Glaive. The old lord impaled there was long dead. Slivers of his power might remain, and the cult must be seeking them.",
    "The scrying bowl confirmed cultists at the Master's Glaive. Onu feared they sought what remained of the dead lord's power.")
q(949, "The Twilight Camp", "Darkshore", 17, TW,
    "The Twilight's Hammer's purpose at the Glaive was unknown, but Onu was sure it was dark. Their camp might hold something that showed their intentions.",
    "Before making a plan, Onu wanted something from the cult's camp that would teach their intentions.",
    "A book lay in the camp, hand printed in an ancient language and illustrated by a master artist.",
    "The search turned up an illuminated book in an ancient tongue among the cultists' things.")
q(950, "Return to Onu", "Darkshore", 17, TW,
    "Peering into the Twilight Tome was maddening; its text swam and its scrollwork twisted. Only a single page of scribbles could be torn out.",
    "One page torn from the Twilight Tome was all that could be carried back to Onu.",
    "Onu sensed a chaotic, primal magic in the page, the work of the old ones. He hoped it would reveal the cult's purpose in Darkshore.",
    "The page reached Onu, who felt the old ones' magic in it.")
q(951, "Mathystra Relics", "Darkshore", 20, TW,
    "The torn page came from an ancient elven text. The Twilight's Hammer seemed to be using old elven magic to bring their masters back. Relics from the ruins of Mathystra might show how.",
    "Onu wanted relics from the ruins of Mathystra in the northeast, to learn how the cult meant to use elven magic.",
    "The relics came from a time when Mathystra shone. Onu hoped to unlock the secrets of the place before the cult did, and urged vigilance.",
    "Mathystra's relics reached Onu. Shards of its magic remained, and he meant to understand them before the Twilight's Hammer could.", 4)
q(2139, "Tharnariun's Hope", "Darkshore", 18, J,
    "Tharnariun Treetender had one last task, and it meant more killing. The Den Mother lived in a cave to the northeast, near Bashal'Aran.",
    "Auberdine owed a debt for the sick animals put down, Tharnariun said, and he hoped the Den Mother would be the last of them.",
    "Tharnariun praised the bravery shown for Auberdine. Many in the war-torn land chose to hide or flee to safer Alliance lands, he said. He hoped someday to fight beside such help against another foe.",
    "The Den Mother was dead, and Tharnariun gave thanks for the fight on Auberdine's behalf.", 4)
q(2098, "Gyromast's Retrieval", "Darkshore", 20, GY,
    "Gelkak Gyromast's ship had sunk off the coast. The key to his mechanical first mate had broken on the rocks. Crawlers, foreststriders and murlocs had carried off the pieces.",
    "The pieces of Gelkak's broken key were scattered among the beasts and murlocs of the Darkshore coast.",
    "Gelkak cheered at the recovered key. His first mate would soon be working again, and the beasts would not know what hit them.",
    "The key's pieces reached Gelkak, who asked next after his first mate.")
q(2078, "Gyromast's Revenge", "Darkshore", 20, GY,
    "Gelkak's first mate needed winding with the key and bringing back to serve the captain. The murlocs and their chief, he promised, would regret it.",
    "The Threshwackonator waited to be wound up and led back to Gelkak for his revenge on the murlocs.",
    "Gelkak judged the work more than a coward's, and joked about a promotion to poop deck swabby.",
    "The first mate came back to Gelkak, who spoke of a promotion for his helper.")
P.questIDs[6342].highlight = {"Nessa's fish samples flew from Rut'theran to Laird in Auberdine. A jawbone nearly twice the mainland size and scales as big as a fist amazed him.", "Laird opened Nessa's collection in Auberdine and found Teldrassil's fish far larger than his own."}
P.questIDs[963].highlight = {"Anaya's haunted spirit in Ameth'Aran was released. Cerellean Whiteclaw, who had loved her thousands of years before, asked to be alone with his grief.", "Cerellean could not raise his hand against his beloved's spirit. Once Anaya was freed, he wondered if he should have done it himself."}
P.questIDs[951].highlight = {"Relics from the ruins of Mathystra reached Onu. He hoped to learn how the Twilight's Hammer meant to use elven magic before the cult could.", "Onu took Mathystra's relics, shards of an old elven magic the Twilight's Hammer seemed to want, and urged vigilance."}
P.questIDs[2139].highlight = {"The Den Mother, the last beast Tharnariun asked to be slain, was dead. He praised the courage shown for Auberdine.", "Tharnariun's last hunt ended with the Den Mother near Bashal'Aran, and he hoped someday to fight beside such help."}

-- Overnight 2026-11-05, Wetlands and the capitals: the road to Morbent's Bane
-- (Farthing, the Flying Osprey's Lightforge Iron, Grimand Elmore), the cursed
-- Third Fleet and the Eye of Paleth, Menethil's tanner, Dun Modr's fall and the
-- Thandol Span, and Sully Balloo's memorial. The Eye's cleansing does not free
-- the crew; the memorial stages never return Sully. Plea To The Alliance (634)
-- and MacKreel's Moonshine (647) complete outside this pack's regions.
P.threads.alliance_thirdfleet = "the cursed Third Fleet"
P.threads.alliance_balloo = "Sully Balloo's memorial"
local TF, BL = "alliance_thirdfleet", "alliance_balloo"
q(269, "Seeking Wisdom", "Stormwind City", 29, SV,
    "Sven sent Jitters's account to {n:Bishop Farthing} in the Cathedral of Light. Stormwind had forsaken Darkshire, but Farthing was kind and wise.",
    "Facing Morbent Fel meant seeking counsel in Stormwind, where {n:Bishop Farthing} might know how it could be done.",
    "Farthing read the account and called Morbent Fel immensely powerful, shielded by dark enchantments against physical harm. A weapon proof against them would be needed.",
    "The bishop warned that Morbent Fel's enchantments turned aside ordinary weapons, and that the trial ahead needed something better.")
q(270, "The Doomed Fleet", "Wetlands", 29, SV,
    "{n:Bishop Farthing} knew of Lightforge Iron, a metal whose weapons struck with holy truth. A load of it had gone down with the Third Fleet of Kul Tiras off the Wetlands coast.",
    "{n:Bishop Farthing} sent the search for Lightforge Iron to his dwarven colleague Glorin Steelbrow in Menethil Harbor.",
    "Glorin called Lightforge Iron precious and the cause a dire one. If the iron could be found, he knew who could make it into a weapon against the necromancer.",
    "In Menethil, Glorin Steelbrow agreed to help the search for the lost iron.")
q(321, "Lightforge Iron", "Wetlands", 29, SV,
    "The Flying Osprey, an elven ship carrying Lightforge Iron, had joined the Third Fleet for protection. It sank to the same red dragons. Its wreck lay south of Menethil.",
    "Glorin pointed the search to the wreck of the Flying Osprey, south of the harbor.",
    "The Osprey's chest was waterlogged and clawed by murlocs. A single Lightforge ingot remained deep inside, far from enough for a weapon.",
    "Only one ingot was left in the Flying Osprey's broken chest; murlocs had taken the rest.")
q(324, "The Lost Ingots", "Wetlands", 29, SV,
    "Murloc raiders near the Flying Osprey's wreck had stolen the rest of the Lightforge Iron.",
    "The missing ingots were with the murlocs who had clawed open the Osprey's chest.",
    "Glorin was pleased to see the ingots and ready to have the iron hammered into something useful.",
    "The lost Lightforge Iron came back from the murlocs to Glorin in Menethil.")
q(322, "Blessed Arm", "Stormwind City", 29, SV,
    "Glorin packed the iron into a crate for Grimand Elmore, a dwarven weaponsmith in Stormwind's Dwarven District who could work it.",
    "Only a smith who knew Lightforge Iron could make the weapon, and Glorin sent the crate to Grimand Elmore.",
    "Grimand had not worked Lightforge Iron in years and called it an honor. He set to making the weapon against Morbent Fel, and asked to hear later how the battle went.",
    "The crate reached Grimand Elmore, who agreed to forge the weapon against the necromancer.")
q(325, "Armed and Ready", D, 29, SV,
    "Grimand's finished weapon was made to break through Morbent Fel's protections, and he wanted to hear how it fared.",
    "Morbent's Bane was finished in Stormwind and bound for Sven Yorgen's camp.",
    "Sven judged the weapon proof against the fiend. Morbent Fel would fall, he declared.",
    "Sven took the weapon made by Stormwind's smith and pronounced the preparations complete.", 4)
q(288, "The Third Fleet", "Wetlands", 27, TF,
    "Fitzsimmons had been first mate of the Wave Mistress, a ship of the Kul Tiras Third Fleet. Orc-ridden red dragons had burned it off this coast. Before telling more, he wanted a drink for his hangover.",
    "The sole survivor of the Third Fleet sat in Menethil with a pounding head, wanting a fresh drink before he went on.",
    "The drink hit the spot and loosened Fitzsimmons's tongue.",
    "Fitzsimmons had his drink, and with it the will to go on with his account.")
q(289, "The Cursed Crew", "Wetlands", 29, TF,
    "Bolstered by his drink, Fitzsimmons went on. He was the only man of the Third Fleet still breathing, but not the only one still walking. A great and terrible treasure hidden on one of the ships held his brothers' souls in the rotting hulls. Freeing some of them might break the curse.",
    "Fitzsimmons heard his drowned brethren moan in his dreams. He asked that some of them be freed from the wrecks north of Menethil.",
    "Fitzsimmons gave his thanks, and with them the gratitude of his cursed brethren.",
    "Some of the Third Fleet's cursed crew were freed. Fitzsimmons spoke for them as well as for himself.")
q(290, "Lifting the Curse", "Wetlands", 30, TF,
    "To free all his brothers, Fitzsimmons said, the thing stowed on his ship had to be retrieved and cleansed. It lay in the strongbox of the Intrepid, and his old captain, Halyndor, still walked the doomed ship with the key.",
    "Captain Halyndor still walked the Intrepid in Fitzsimmons's dreams, with the key to its strongbox. Fitzsimmons wanted the key taken from him.",
    "Halyndor's key was rusted, but it fit the Intrepid's strongbox neatly.",
    "The key taken from Captain Halyndor turned in the strongbox of the Intrepid.")
q(292, "The Eye of Paleth", "Wetlands", 30, TF,
    "The strongbox held a blackened orb pulsing with an eerie light, the treasure Fitzsimmons had spoken of, a Cursed Eye of Paleth. The dwarven priest Glorin Steelbrow in Menethil might know how to lift its curse.",
    "The Cursed Eye of Paleth came up out of the Intrepid's strongbox and went to Glorin Steelbrow in {p:Menethil Harbor}.",
    "Glorin took the Eye of Paleth with amazement. Something was wrong with this one, he saw at once, and a shipwreck explained it. He had not known the Third Fleet carried such an Eye, and he no longer wondered why Fitzsimmons was so spooked.",
    "Glorin Steelbrow had grumbled about the drunk Fitzsimmons and his begging. After seeing the Cursed Eye of Paleth, he said it was no wonder Fitzsimmons was spooked, and no cause for mirth.")
q(293, "Cleansing the Eye", "Stormwind City", 30, TF,
    "Human priests had made the Eyes of Paleth, so Glorin could not lift the curse. Archbishop Benedictus at the Cathedral of Light could.",
    "Glorin sent the cursed Eye to Stormwind and Archbishop Benedictus.",
    "Benedictus saw that the Eye had witnessed a terrible tragedy, and cleansed it. Tainted, he said, the Eyes' powers were dangerous.",
    "The Archbishop cleansed the sorrowful Eye of Paleth so it could shine as it was made to.", 4)
q(469, "Daily Delivery", "Wetlands", 21, V,
    "Einar Stonegrip had a bundle of crocolisk skins for James Halloran, the tanner in Menethil. He was putting off facing his wife.",
    "Einar's skins for the Menethil tanner went with any traveler bound for the harbor.",
    "Halloran recognized Einar's skins. Einar had not delivered them in person for nearly a week, and Halloran guessed it was trouble with the wife.",
    "The skins reached Halloran, who joked about sending his own wife to talk with Sida.")
q(471, "Apprentice's Duties", "Wetlands", 26, V,
    "Halloran's apprentice had gone into the marshes to skin giant crocolisks and come back badly hurt. The midwife thought he might pull through; the skins were still needed.",
    "The crocolisks north up the coast had maimed Halloran's apprentice, and the tanner still needed their skins.",
    "Halloran joked about taking on a new apprentice. Then he said the skins were fine and he would put them to good use.",
    "The giant crocolisk skins reached Halloran, whose apprentice, like a son to him, would have to live with one leg.")
q(472, "Fall of Dun Modr", "Wetlands", 25, DI,
    "Dun Modr had fallen to the Dark Irons. A badly wounded soldier in Menethil, struck by an axe as the regiment retreated, hoped Longbraid was still alive.",
    "Most of Dun Modr's regiment had been killed after the Thandol Span ambush. Its wounded survivor wanted Longbraid found.",
    "Longbraid was alive, and glad to hear young Harlo had survived. Dun Modr had fallen, and the regiment was a shadow of what it had been.",
    "The news from Menethil gave Longbraid hope, though his regiment was much reduced and Dun Modr lost.", 4)
q(631, "The Thandol Span", "Wetlands", 31, DI,
    "A great explosion had torn through the hills at the Thandol Span, and good soldiers had died. Ol' Rustlocke had gone to scout the eastern bridge days ago and not come back.",
    "With Dun Modr under siege, Rhag Garmason had no one to spare to look for Ol' Rustlocke.",
    "A small dwarven body lay by the bridge, its helmet engraved Ebenezer Rustlocke.",
    "Ol' Rustlocke was found dead, his name engraved in his helmet.")
q(632, "The Thandol Span", "Wetlands", 31, DI,
    "Ol' Rustlocke had run into a Dark Iron ambush by the bridge. A parchment lay beside his clenched fist, and Rhag Garmason had to hear the grim news and see it.",
    "The parchment from beside Rustlocke's body went back to Rhag Garmason at Dun Modr with the news of his death.",
    "Rhag Garmason heard how Rustlocke had died and called the news grave. He turned to the parchment.",
    "The news of Rustlocke reached Rhag, who called it grave and took the parchment found beside the dead scout.")
q(633, "The Thandol Span", "Wetlands", 31, DI,
    "Rustlocke's parchment showed that Kam Deepfury had arranged a cache of explosives just across the Thandol Span. If it reached the bridge, the supply line north would be cut.",
    "Rustlocke's death was not to be in vain, Rhag said. The explosives cached in the Arathi Highlands had to be destroyed.",
    "The remaining bridge was saved, a great service to King Magni and Khaz Modan. Rhag hoped they could hold until reinforcements came.",
    "Kam Deepfury's cache was destroyed and the last span stood. Reinforcements were still nowhere in sight.", 4)
q(637, "Sully Balloo's Letter", "Ironforge", 30, BL,
    "A waterlogged, war-torn envelope from the Thandol Span came apart, leaving a few pages addressed to Mrs. Sara Balloo of Ironforge.",
    "Sully Balloo's last letter began with the words My dear Sara, and was meant for his wife in Ironforge.",
    "Sara Balloo could hardly believe her Sully lay pinned beneath the icy waters. She took his letter to read.",
    "Sully's letter reached Sara in Ironforge, and with it the news of where he had died.", 4)
q(683, "Sara Balloo's Plea", "Ironforge", 30, BL,
    "Sara Balloo had a note for King Magni Bronzebeard, but grief kept her from going before him herself.",
    "Sara's plea was meant for King Magni, carried by someone known for service to the Alliance.",
    "Magni had heard of the messenger's service to the Alliance, and took a moment to read Sara's letter.",
    "The King of Ironforge received Sara Balloo's plea.")
q(686, "A King's Tribute", "Ironforge", 30, BL,
    "Magni could not bring Sully Balloo back, but he could honor him. He commissioned a memorial from Ironforge's Grand Mason.",
    "The loss of every dwarf in the Alliance's wars weighed on Magni. He sent word to the Grand Mason to build a memorial to Sully Balloo.",
    "The Grand Mason was impressed that King Magni himself had sent word. It had to be important.",
    "Magni's commission reached the Grand Mason, who took it as a matter of great importance.")
q(689, "A King's Tribute", "Ironforge", 31, BL,
    "For a lasting memorial, the Grand Mason wanted Alterac Granite from Darrow Hill in Hillsbrad.",
    "The Grand Mason grumbled about whether there would ever be peace, then asked for the finest stone, Alterac Granite.",
    "The granite was better than the Grand Mason had imagined, and he had quite an imagination.",
    "Alterac Granite reached the Grand Mason, enough to begin the memorial to Sully Balloo.")
q(700, "A King's Tribute", "Ironforge", 31, BL,
    "The memorial to Sully Balloo was complete, built of granite from troubled Lordaeron, and the King was to be told.",
    "The Grand Mason was pleased with the memorial and sent word of it to King Magni.",
    "Magni said the granite was a small token beside a great dwarf's life. He hoped the memorial would remind those of the future that brave soldiers like Sully Balloo gave their lives for them.",
    "The memorial to Sully Balloo stood finished. Magni hoped it would remind future generations what such soldiers had given.", 5)
P.questIDs[269].highlight = {"{n:Bishop Farthing} read Jitters's account in Stormwind and warned that Morbent Fel's enchantments would turn aside any ordinary weapon.", "In the Cathedral of Light, Farthing heard of the plan to face Morbent Fel. He said a weapon proof against dark enchantments would be needed."}
P.questIDs[325].highlight = {"Morbent's Bane, forged from Lightforge Iron by Grimand Elmore, reached Sven. Morbent Fel would fall, he declared.", "Sven took the finished weapon from Stormwind and judged it proof against the necromancer's protections."}
P.questIDs[293].highlight = {"Archbishop Benedictus cleansed the Cursed Eye of Paleth from the Third Fleet, saying it had witnessed a terrible tragedy.", "The Eye of Paleth from the Intrepid's strongbox was cleansed in Stormwind's Cathedral of Light."}
P.questIDs[633].highlight = {"Kam Deepfury's cache of explosives across the Thandol Span was destroyed. The remaining bridge was saved for Khaz Modan.", "Rustlocke's parchment led to the Dark Iron explosives across the span. With them destroyed, Rhag Garmason's last bridge still stood."}
P.questIDs[472].highlight = {"Longbraid the Grim was found alive near fallen Dun Modr, and glad to hear that young Harlo had survived.", "Word from Menethil reached Longbraid. His regiment was a shadow of itself, but Harlo lived."}
P.questIDs[700].highlight = {"The memorial to Sully Balloo was finished in Alterac Granite. Magni hoped it would remind the future of what brave soldiers gave.", "King Magni heard the memorial to Sully Balloo was complete, a small token, he said, beside a great dwarf's life."}

-- Overnight 2026-11-05, the capitals and Loch Modan: VanCleef's unsent letter
-- through Lescovar and the audience at Stormwind Keep (Prestor is never named;
-- her identity belongs to the discovery policy), Senir's report to the Senate,
-- Daryl the Bold's challenges, the Stormpike errands between Loch Modan and
-- Stormwind, Brock's honorary picks by gryphon, and Bingles of the movement.
-- The Stockade Riots (391) is dungeon work and stays with the dungeon pack.
P.threads.alliance_lescovar = "the Defias reach inside Stormwind"
P.threads.alliance_brock = "Brock's honorary picks"
local LS, BR = "alliance_lescovar", "alliance_brock"
local SW, IF = "Stormwind City", "Ironforge"
q(373, "The Unsent Letter", SW, 22, LS,
    "Edwin VanCleef had carried an unsent letter, recently written and sealed, addressed to Baros Alexston, the City Architect of Stormwind.",
    "Among VanCleef's things was a sealed letter for Baros Alexston at the City Hall in Cathedral Square.",
    "Baros was surprised VanCleef was dead; he had been a peerless fighter in his youth. Reading the letter, he called Edwin an idealist and a romantic still, consumed by revenge. Baros was not sure he could blame him.",
    "The letter reached Baros Alexston, who found VanCleef unchanged by the years and did not wholly blame him for his bitterness.", 4)
q(389, "Bazil Thredd", SW, 22, LS,
    "Baros explained that he and VanCleef had been Stonemasons. The nobles refused to pay them for rebuilding Stormwind, and VanCleef led a riot and left swearing revenge. His lieutenant Bazil Thredd was held in the Stockade.",
    "Bazil Thredd, VanCleef's lieutenant, might know more of his plans, and he was a prisoner in the Stockade.",
    "Warden Thelwater was in the middle of a riot and in no mood for questions about Thredd. He suspected the asker of being one of Thredd's cronies.",
    "The Stockade's warden had a crisis on his hands, every cell open. He wanted to know why anyone would ask after Bazil Thredd.")
q(392, "The Curious Visitor", SW, 29, LS,
    "Thredd had had no visitors for years, then regular ones from a quiet man whose papers named him Maelik. Thelwater had his suspicions and a description.",
    "Thelwater's description of Thredd's visitor, Maelik, went to Baros Alexston.",
    "Baros did not know the name or the description. The man could be a Stonemason or a Defias, but if he was as well connected as Thelwater thought, someone else might know him.",
    "The name Maelik meant nothing to Baros, and he began to think who else might know.")
q(393, "Shadow of the Past", SW, 29, LS,
    "Baros sent the description to Master Mathias Shaw of SI:7 in Old Town. Shaw owed him a favor and knew most of the city's shady dealings.",
    "If anyone in Stormwind could name Thredd's visitor, it was Mathias Shaw.",
    "Shaw knew the man, though not as Maelik. He was an assassin who also used the name Marzon. He worked for Lord Gregor Lescovar, a noble of shady reputation.",
    "Maelik was Marzon, an assassin, Shaw said, and Marzon worked for Lord Gregor Lescovar.", 4)
q(350, "Look to an Old Friend", SW, 31, LS,
    "With VanCleef and Thredd dead, there was no testimony against Lescovar. A well-connected noble stood above the law. Shaw sent the matter to Trias in the Trade District.",
    "Shaw loathed to ask, but he knew someone who would help against Lescovar, and sent word to Trias.",
    "Trias could hardly believe Shaw wanted his help again, and wanted the whole account of the Defias from the beginning.",
    "The news reached Trias in the Trade District, who asked to hear everything, leaving nothing out.")
q(2745, "Infiltrating the Castle", SW, 31, LS,
    "Trias would help, but the justice needed against Lescovar and Marzon was not a legal one. A gnome named Tyrion had been watching Lescovar at the castle for weeks.",
    "Trias sent help to his old friend Tyrion, hidden near Stormwind Keep with his eye on Lescovar.",
    "Tyrion, startled in the bushes, demanded quiet before the guards noticed anyone else hiding there with him.",
    "Tyrion was found in the castle bushes, cross at being startled and anxious about the guards.")
q(2746, "Items of Some Consequence", SW, 31, LS,
    "Tyrion had a disguise in mind to get his Spybot past Lescovar's guards. He needed silk and a couple of apples from Clara's farm outside the city.",
    "Tyrion had been following leads that tied Lescovar to the Twilight's Hammer. Now he wanted silk and apples for his plan.",
    "Tyrion had the rest of his gear in his pack and was ready to set out the plan in detail.",
    "With the silk and apples in hand, Tyrion could disguise Spybot and lay out the plan.")
q(434, "The Attack!", SW, 31, LS,
    "In disguise, Spybot would draw Lescovar into the garden to meet Marzon, and Lescovar would dismiss his guards. Once the Defias were mentioned, both men had to die before the guards returned.",
    "The gnome Tyrion had told Marzon it was time to meet Lescovar again, and slipped him false information besides. Lescovar would wait in the garden without his guards.",
    "Lescovar and Marzon were dead. Trias gave thanks for the discretion, and said he would keep an eye on such a useful ally.",
    "The meeting in the garden ended with Lord Lescovar and his assassin dead. Trias advised keeping a clean nose.", 5)
q(394, "The Head of the Beast", SW, 31, LS,
    "Shaw needed to hear that Lescovar had been dealt with. Trias expected the news to go on to the nobles, who only thought they ruled the city.",
    "The Lescovar threat was ended, and Mathias Shaw in Old Town was owed the account.",
    "Shaw called the justice swift and hoped never to be its quarry. As master of all assassins he meant no criticism, and he gave thanks for the service to Stormwind's people.",
    "Shaw heard that Lescovar was dead and thanked the service done to the people of Stormwind.")
q(395, "Brotherhood's End", SW, 31, LS,
    "Baros Alexston had come looking for news of the Defias. Shaw advised telling everything except whose hand slew Lescovar, and never speaking of Trias.",
    "Baros wanted to report the Brotherhood's affairs to the nobles, and Shaw had advice on what to leave out.",
    "Baros had heard Lescovar was found dead. He was grateful to be saved, with many others, from VanCleef's revenge.",
    "Lord Lescovar's death reached Baros as news, and he gave thanks that VanCleef's revenge would not touch him.")
q(396, "An Audience with the King", SW, 31, LS,
    "Baros had prepared a report for the King. He wanted it delivered at Stormwind Keep, along with the account of what had been found.",
    "The report on the Defias affair was bound for an audience at Stormwind Keep.",
    "Highlord Bolvar Fordragon commended the service to Stormwind; VanCleef's plans could have done the kingdom great harm. He gave a token of the King's appreciation, since the King was away on a diplomatic mission.",
    "At Stormwind Keep, the King's regent received Baros's report and rewarded the service in the King's absence.", 5)
q(291, "The Reports", IF, 10, M,
    "Senir's finished report was for Senator Barin Redstone, a sour sort, in the chamber where King Magni held court. Senir asked that nobody mention who had helped him.",
    "The report from Kharanos had to reach the Senate in Ironforge.",
    "Redstone read the report and was outraged. Whitebeard had acted on the authority of the King, and the Senate would not be pleased. He ordered the messenger out.",
    "Senator Redstone took Senir's report badly, fuming that Whitebeard had taken matters into his own hands.")
q(257, "A Hunter's Boast", "Loch Modan", 16, L,
    "Daryl the Bold did not think anyone could match him. He offered his bow or gun if a flock of Loch Modan buzzards could be taken down in fifteen minutes.",
    "Daryl the Bold set a challenge against the buzzards nesting in Loch Modan, sure it would fail.",
    "Daryl was astonished at the success, called the buzzards small specimens any boy could kill, and kept his word anyway.",
    "The buzzards were down in time, and Daryl the Bold, grumbling, held to his word.")
q(258, "A Hunter's Challenge", "Loch Modan", 17, L,
    "Daryl's second test was a twelve-minute boar hunt, harder than any in Coldridge Valley. He offered the shirt off his back if it succeeded, and started telling how he got his famous scar.",
    "Daryl the Bold still doubted the newcomer, and set a boar hunt against the clock.",
    "Daryl offered to be discreet about the struggle, then realized the boars were dead. He was not surprised, he said, and asked what bet.",
    "The boars were killed in time, and Daryl the Bold claimed not to remember any bet.")
q(1339, "Mountaineer Stormpike's Task", "Loch Modan", 15, L,
    "Mountaineer Stormpike, at the top of the northern guard tower, was looking for a runner.",
    "Stormpike had a task he could not do while on guard, and wanted someone to travel for him.",
    "The task Stormpike could not do on guard would take its runner far from Loch Modan.",
    "At the northern tower, Stormpike confirmed he needed a runner for a task he could not leave his post to do.")
q(1338, "Stormpike's Order", SW, 14, L,
    "Mountaineer Stormpike wanted a shield from Furen Longbeard, the dwarven armorsmith in Stormwind's Dwarven District.",
    "Furen Longbeard's work was the finest, Stormpike thought. He could not see why the smith lived among humans so far from Ironforge.",
    "Furen recognized an order from the Stormpikes, a proud clan and a rich one. He promised to start on the shield by the end of the day.",
    "Stormpike's order reached Furen Longbeard in Stormwind, who agreed to make the shield.")
q(353, "Stormpike's Delivery", "Loch Modan", 15, L,
    "Grimand Elmore in Stormwind had finished a weapon for Mountaineer Gringer Stormpike, far away at the northern guard tower in Loch Modan.",
    "The Stormpikes had fine tastes, and Grimand's finished axe was bound for Loch Modan.",
    "Stormpike was delighted that Grimand had finally finished his axe, eager to try it on troggs and kobolds, and paid for the long delivery.",
    "The axe from Stormwind reached Stormpike, who could not wait to use it.")
q(6387, "Honor Students", "Loch Modan", 10, BR,
    "Brock Stoneseeker had a list of mining students who had earned honorary picks. The list was for Golnir Bouldertoe in Ironforge, by gryphon from Thelsamar.",
    "Brock's best mining students had earned their picks, and the list had to reach Ironforge.",
    "Thorgrum Borrelson offered a gryphon to Ironforge for a small fee.",
    "The gryphon master in Thelsamar was ready to carry Brock's list.")
q(6391, "Ride to Ironforge", IF, 10, BR,
    "Thorgrum's gryphons flew to the Great Forge District, near the Deep Mountain Mining Guild where Golnir Bouldertoe worked.",
    "Brock's list was for Golnir Bouldertoe in Ironforge's mining guild.",
    "Golnir had a batch of honorary picks ready; he only had to chisel in the students' names.",
    "Golnir took the list and set to chiseling the students' names into the picks.")
q(6388, "Gryth Thurden", IF, 10, BR,
    "The honorary picks were ready for Brock's students, and Gryth Thurden's gryphons could carry them back to Thelsamar.",
    "Golnir sent the finished picks with the Ironforge gryphon master, Gryth Thurden.",
    "Gryth agreed to fly the picks to Thelsamar, since its gryphon master already knew the traveler.",
    "Ironforge's gryphon master was ready to carry the picks back to Loch Modan.")
q(6392, "Return to Brock", "Loch Modan", 10, BR,
    "Gryphons flew only to places their riders had already been, and Thelsamar was one. Brock's picks could go straight to him.",
    "The honorary picks were bound for Brock Stoneseeker in Thelsamar.",
    "Brock had the picks for his students, who were eager to use them on Loch Modan's ore. He paid the travel costs.",
    "The picks reached Brock in Thelsamar, ready for his mining students.")
q(2039, "Find Bingles", "Loch Modan", 15, G,
    "Bingles had flown a reconnaissance mission over Gnomeregan and not reported back in over a week. Gnoarn feared he had blown himself up over the loch.",
    "The movement had lost contact with Bingles, last seen flying over Loch Modan.",
    "Bingles was alive, offended that Gnoarn doubted him, and in urgent need of help for the movement.",
    "Bingles was found by the loch, and he said the whole movement needed help.")
q(2038, "Bingles' Missing Supplies", "Loch Modan", 15, G,
    "Bingles had crashed into the loch. Troggs from the nearby island had stolen his tools and his Blastenheimer Blastencapper explosives.",
    "Without his gyrocopter or his explosives, Bingles said, the movement had no chance.",
    "The tools and explosives came back. The troggs and leper gnomes in Gnomeregan, Bingles said, would soon feel a gnomish air assault.",
    "The movement's supplies came back from the trogg island, and Bingles promised an air assault on Gnomeregan.")
q(2041, "Speak with Shoni", SW, 15, G,
    "Shoni the Shilent, commander of the movement's underground assault crew, needed help in Stormwind with her gyrodrillmatic excavationators.",
    "Help for the battle for Gnomeregan was needed in Stormwind, where Shoni the Shilent worked among the dwarves.",
    "Shoni asked whether the messenger brought word from central command.",
    "The movement's message reached Shoni in Stormwind.")
P.questIDs[373].highlight = {"VanCleef's unsent letter reached Baros Alexston, who found him an idealist still, consumed by revenge, and could not wholly blame him.", "Baros Alexston read the letter VanCleef never sent. The years had not changed Edwin, he said."}
P.questIDs[393].highlight = {"Mathias Shaw named Thredd's quiet visitor as Marzon, an assassin in the pay of Lord Gregor Lescovar.", "Thredd's visitor Maelik was the assassin Marzon, Shaw said, and Marzon served Lord Lescovar."}
P.questIDs[434].highlight = {"Lord Lescovar met Marzon in the castle garden without his guards, and both men died there. Trias gave thanks for the discretion.", "The gnome Tyrion's trap in the garden ended Lescovar's dealings with the Defias, and his assassin's with him."}
P.questIDs[396].highlight = {"At Stormwind Keep, Highlord Bolvar Fordragon commended the work against VanCleef's plans and gave a token in the absent King's name.", "Baros's report reached Stormwind Keep. VanCleef's revenge had been stopped, and Bolvar rewarded the service for the King."}
P.questIDs[291].highlight = {"Senir's report reached Senator Barin Redstone, who was outraged that Whitebeard had acted on the King's authority.", "Redstone read Senir's report and swore the Senate would not be pleased."}

-- Overnight 2026-11-05, Darkshore continued: Prospector Remtravel's fossil
-- from Darkshore to Menethil, the Darkshore stages of the Tower of Althalaxx
-- (the Ashenvale stages 967, 970, 973, 1140 and 981 belong to the world lane),
-- Volcor's rescue, Wizbang's lost parts and Fandral's message to Onu.
-- Flagongut's stone is recovered, not shown to work; the cult's defeat is
-- only Athrikus's death in 1143.
P.threads.alliance_remtravel = "Prospector Remtravel's fossil"
P.threads.alliance_althalaxx = "the Cult of the Dark Strand"
P.threads.alliance_volcor = "the search for Volcor"
local RT, AL, VC = "alliance_remtravel", "alliance_althalaxx", "alliance_volcor"
q(730, "Trouble In Darkshore?", "Darkshore", 14, RT,
    "Chief Archaeologist Greywhisker in Darnassus had heard nothing from his crew in Darkshore for weeks. Recent finds in Khaz Modan, he said, showed a power that threatened all of Azeroth.",
    "Greywhisker wanted a clue to where his missing dig crew had gone, starting in Auberdine.",
    "Archaeologist Hollee was relieved that Greywhisker had sent for help.",
    "In Auberdine, Hollee welcomed word from Greywhisker; her crew needed help.")
q(729, "The Absent Minded Prospector", "Darkshore", 20, RT,
    "Hollee had worked under the great Prospector Remtravel until golems sprang from the ground and overran the dig. Remtravel never seemed to notice, and Hollee had run to Auberdine for help.",
    "Prospector Remtravel was famous at Ironforge's academy, and famously oblivious. Hollee feared for him at the overrun dig south of Auberdine.",
    "Remtravel was alive, asking for his stone brush, his missing fossil and Hollee, in no particular order.",
    "The prospector was found at the dig, mistaking the newcomer for Hollee and more worried about his lost fossil than the golems.")
q(731, "The Absent Minded Prospector", "Darkshore", 20, RT,
    "Remtravel would not leave without the mysterious fossil, or his brush. The Explorers' League in Darnassus wanted some sign of his work.",
    "The fossil hunt meant guarding Remtravel through a dig full of golems, while he kept confusing fossil and brush.",
    "Hollee thanked the stars that Remtravel was safe. She had warned that he was absent minded, and could not believe he had stayed among those creatures.",
    "Remtravel was safe among the golems of his dig, to Hollee's great relief.", 4)
q(741, "The Absent Minded Prospector", "Darnassus", 20, RT,
    "Remtravel wanted his mysterious fossil sent to the Explorers' League, but Hollee would not leave Darkshore without him.",
    "The fossil from Remtravel's dig was bound for Chief Archaeologist Greywhisker in Darnassus.",
    "Greywhisker was delighted; it was just like Remtravel to discover such a find.",
    "The fossil reached Greywhisker in Darnassus, who credited Remtravel with the find.")
q(942, "The Absent Minded Prospector", "Wetlands", 20, RT,
    "The fossil resembled one Greywhisker had seen at an Explorers' League conference. An archaeologist named Flagongut had brought it, believing it held a power. Flagongut was waiting in Menethil's Deepwater Tavern.",
    "Flagongut, last heard of in Menethil Harbor, might unlock the secret of Remtravel's fossil. The ship from Auberdine could take it there.",
    "Flagongut was amazed that the fossil came from distant Kalimdor.",
    "In the Deepwater Tavern, Flagongut marveled at a fossil from Kalimdor.")
q(943, "The Absent Minded Prospector", "Wetlands", 24, RT,
    "Flagongut's Stone of Relu was the key to the fossils. Raptors had swallowed it on the road to Whelgar's dig. Prospector Whelgar held the original fossil.",
    "Flagongut needed both the Stone of Relu, lost inside a mottled raptor, and the original fossil held by Prospector Whelgar.",
    "Both fossils and the stone were with Flagongut now, and he meant to see whether the stone would unlock their powers.",
    "With the Stone of Relu recovered and Whelgar's fossil beside Remtravel's, Flagongut set to deciphering them.", 4)
q(965, "The Tower of Althalaxx", "Darkshore", 18, AL,
    "Elissa Starbreeze, charged with protecting Auberdine, had sent Balthule Shadowstrike to watch the Tower of Althalaxx. He was overdue.",
    "Elissa worried that Balthule had met some danger near the Tower of Althalaxx to the northeast.",
    "Balthule was well, with troubling news for Elissa and no way to send it.",
    "Balthule was found watching the tower, glad of a messenger for the news he had.")
q(966, "The Tower of Althalaxx", "Darkshore", 18, AL,
    "Warlocks had settled around and inside the tower. Balthule had scraps of their parchment but needed more, and warned against entering the tower itself.",
    "Balthule wanted more of the warlocks' scrolls to piece together who they were.",
    "The scrolls named the Cult of the Dark Strand, a group Balthule had never heard of. Warning had to go to Delgren at once.",
    "The cult's name was the Dark Strand, Balthule learned, but nothing of its plans. Delgren had to be told immediately.")
q(1167, "The Tower of Althalaxx", "Darkshore", 28, AL,
    "Before facing Athrikus, Delgren advised consulting Balthule, who had kept watch on the tower.",
    "Balthule might know of recent changes at the tower before the final strike.",
    "Balthule had seen a blinding flash in the tower's upper room, then screams, and lightning striking the ground.",
    "Strange things had happened at the tower, Balthule said, a flash of light, screams and lightning.")
q(1143, "The Tower of Althalaxx", "Darkshore", 31, AL,
    "Athrikus Narassin, an ancient and powerful warlock, held the top of the tower among deadlier warlocks than before. Balthule thought it time to strike.",
    "With his soulgems gone, Athrikus was weakened. Balthule wanted him faced at the top of the Tower of Althalaxx.",
    "Athrikus was dead. Balthule hoped the demonic forces would be driven back, though he expected them to regroup and return.",
    "Athrikus Narassin lay dead at the top of the tower. Balthule expected the demons to regroup, and meant to be better prepared.", 5)
q(986, "A Lost Master", "Darkshore", 20, VC,
    "Terenthis wanted to help Grimclaw find his master Volcor. He offered to make a cloak that would let its wearer pass Darkshore's creatures unhindered. It needed five fine moonstalker pelts.",
    "A magical cloak for the search for Volcor needed pelts from the moonstalker sires and matriarchs near Wildbend River.",
    "Terenthis set to work on the cloak. He warned that its illusion would break if its wearer did much more than speak.",
    "The pelts were enough for Terenthis's cloak, and he asked for a few moments to make it.")
q(993, "A Lost Master", "Darkshore", 20, VC,
    "The cloak's magic would last perhaps five minutes. Grimclaw waited by the road to point the way to his master's cave.",
    "Volcor was somewhere in a cave south of Auberdine, and Grimclaw knew where.",
    "Volcor, wounded by the furbolgs, was glad Terenthis had found help, and admired the moonstalker cloak through his coughing.",
    "The search ended in the cave. Volcor, hurt by the furbolgs, needed a moment's rest before he could talk.", 4)
q(994, "Escape Through Force", "Darkshore", 22, VC,
    "Volcor chose to fight his way down to the road, where Grimclaw waited.",
    "Getting Volcor out meant fighting through the furbolgs to the road.",
    "Terenthis was pleased to see the rescue done. Volcor's escape, he said, gave him faith that Darkshore's troubles could be overcome.",
    "Volcor made it out, and Terenthis took heart from the rescue.")
q(995, "Escape Through Stealth", "Darkshore", 20, VC,
    "Volcor chose to sneak out instead, and would make his own way to Auberdine.",
    "The quiet way out of the cave suited Volcor, who expected to reach Auberdine first.",
    "Back in Auberdine, Terenthis welcomed the news of Volcor's escape. He took it as a sign that Darkshore could overcome its troubles.",
    "Volcor slipped away safely, and Terenthis said the rescue gave him faith.")
q(1579, "Gaffer Jacks", "Darkshore", 12, J,
    "Wizbang Cranktoggle had come to Auberdine for quiet to invent in. After too much to drink on the voyage, he had dropped his box of gaffer jacks overboard.",
    "Without his gaffer jacks, Wizbang could not tune his stintle pegs, and they lay somewhere in the sea off Darkshore.",
    "Wizbang could not believe the gaffer jacks had been fished up, and called the finder the luckiest in Kalimdor.",
    "The box of gaffer jacks came up out of the sea, to Wizbang's amazement.")
q(1580, "Electropellers", "Darkshore", 12, J,
    "Testing a self-propelled exploding duck decoy while a little tipsy, Wizbang had woken in Auberdine with singed hair and his bag of electropellers gone.",
    "Wizbang's electropellers were somewhere in a Darkshore lake or stream, and he needed them for his duck decoys.",
    "Wizbang called the finder the best fisherman he had ever seen, and gave fishing gear in thanks.",
    "The electropellers came out of the water, and Wizbang's research on duck decoys could go on.")
q(952, "Grove of the Ancients", "Darkshore", 17, J,
    "Fandral Staghelm had a message for Onu, the Ancient of Lore, in the Grove of the Ancients south of Auberdine. Onu had been waiting for it, as Fandral had waited for news from the Oracle Glade.",
    "The Arch Druid's message for Onu had to cross to Darkshore, likely by hippogryph.",
    "Onu remarked that the Arch Druid always seemed in a hurry. The forest knew all would come in its appointed time, and Shan'do Stormrage had understood that.",
    "Fandral's message reached Onu, who found the Arch Druid's haste strange.")
P.questIDs[731].highlight = {"Prospector Remtravel was safe at his golem-overrun dig with his fossil, to Archaeologist Hollee's relief.", "Hollee thanked the stars that the absent-minded Remtravel was safe, after he had insisted on staying among the golems."}
P.questIDs[943].highlight = {"The Stone of Relu came back out of a raptor, and Flagongut had both fossils to try it on.", "Flagongut received the Stone of Relu and Whelgar's fossil, ready to see what the old relics held."}
P.questIDs[1143].highlight = {"Athrikus Narassin, master of the Cult of the Dark Strand, was dead at the top of the Tower of Althalaxx. Balthule expected the demons to regroup.", "The Tower of Althalaxx lost its master when Athrikus died. Balthule meant to be ready for whatever came back."}
P.questIDs[993].highlight = {"Terenthis's moonstalker cloak eased the search, and Volcor was found alive in a cave south of Auberdine, wounded by furbolgs.", "Grimclaw led the way to his master, and Volcor was found hurt but alive."}
P.questIDs[952].highlight = {"Fandral's message reached Onu in the Grove of the Ancients. The Ancient of Lore found the Arch Druid's haste strange; Shan'do Stormrage had known better.", "Onu took the Arch Druid's message and remarked that all things came in their appointed time."}

-- Overnight 2026-11-05, city errands: the Trade District deliveries, Zardeth's
-- stout for Lord Wishock (what the brew does is never shown), the overdue
-- library book, Brother Kristoff's copy of The Stresses of Iron by way of
-- Northshire and Lakeshire, Baros's compass, Grimand's delivery referral, and
-- the dwarven errands for crocolisk skins and incendicite.
P.threads.alliance_stresses = "the copy of The Stresses of Iron"
local SI = "alliance_stresses"
q(332, "Wine Shop Advert", SW, 2, F,
    "Renato Gallina handed out pamphlets for his family's wine shop by the Trade District canals. Each was good for a free bottle from his sister Suzetta.",
    "The Gallinas claimed to sell the best wine in Stormwind, and Renato's pamphlet promised a complimentary bottle of their pinot noir.",
    "Suzetta Gallina handed over a bottle of the special pinot noir, insisting it had no equal in all of Azeroth.",
    "The pamphlet earned its bottle of pinot noir at the Gallinas' shop.")
q(333, "Harlan Needs a Resupply", SW, 2, F,
    "Harlan Bagley was selling armor and sturdy clothes as if everyone expected a hard season ahead. He was running out of knitted clothing. His request was for Rema Schneider at the Canal Tailor and Fit Shop.",
    "Business was booming for Harlan Bagley, and Rema Schneider supplied the knitted clothing he needed.",
    "Rema was glad Harlan's business was booming, but wondered why so many people needed armor. She had heard nothing of open war, and asked whether the nobles were keeping something back.",
    "Harlan's order reached Rema, who promised the supplies and wondered aloud what the nobles were not telling people.")
q(334, "Package for Thurman", SW, 2, F,
    "Rema's son Thurman, an apprentice at Larson Clothiers in the Mage Quarter, had rushed off without his shears and needles.",
    "Without his sewing kit, Thurman could not do his apprentice work at Larson Clothiers.",
    "Thurman groaned. He had hoped that forgetting his kit would get him out of work, and now he would have to help the Larsons after all.",
    "The sewing kit reached Thurman, who had been counting on its absence to spare him a day's work.")
q(337, "An Old History Book", SW, 25, F,
    "A mud-caked book stamped with the seal of the Stormwind Library, The History of Stormwind, had been checked out and never returned.",
    "The Stormwind Library's seal on the first page of the old book showed where it belonged.",
    "Milton Sheaf said the book had not rested on his shelves since before Stormwind was rebuilt. Once restored, it would join the rare books collection.",
    "The History of Stormwind came home to the Royal Library after many years, to be restored for the rare books.")
q(343, "Speaking of Fortitude", SW, 24, SI,
    "Brother Kristoff wanted to quote a book on metallurgy, The Stresses of Iron, in a speech on the Fortitude of the Spirit. The Royal Library's head librarian, Milton Sheaf, would know where it was.",
    "Kristoff's speech needed passages from The Stresses of Iron, kept in the Royal Library in Stormwind Keep.",
    "Milton Sheaf was happy to help Brother Kristoff with his speech, once he knew which book on metallurgy it was.",
    "The request reached Milton Sheaf, who had many books on metallurgy and asked which one Kristoff needed.")
q(344, "Brother Paxton", E, 24, SI,
    "The Stresses of Iron, written by the dwarven miner Margulf Blaggon, had gone to Northshire Abbey so Brother Paxton could copy it. That had been months ago.",
    "The library's book had gone to Brother Paxton at Northshire Abbey months before. Sheaf wondered what was keeping him.",
    "Paxton admitted, a little embarrassed, that he still had the book and was not ready to give up the original.",
    "The book was at Northshire, and Brother Paxton had not finished his copy.")
q(345, "Ink Supplies", R, 24, SI,
    "Paxton's own ink dried quickly, too quickly, and his last batch had dried up before the copy was done. He needed Rethban Iron Ore from Foreman Oslow in Lakeshire.",
    "Paxton's quick-drying ink called for Rethban Iron Ore, and Lakeshire's foreman usually supplied it.",
    "Oslow was busy fortifying Lakeshire and repairing the damage from orc attacks. If Paxton wanted ore, it would have to be gathered by hand.",
    "The request reached Foreman Oslow, who had no time to spare from Lakeshire's defenses.")
q(347, "Rethban Ore", E, 24, SI,
    "Rethban ore, named for Bart Rethban, gave scribes a dark, flat dye. Gnoll drudgers had taken over the Rethban Caverns north of Lakeshire and were mining it themselves.",
    "With Lakeshire's people too busy to gather it, the Rethban ore for Paxton's ink had to come from the gnoll-held caverns.",
    "Paxton was delighted. The ore would make his dye, and he could finish copying The Stresses of Iron.",
    "The Rethban ore reached Paxton at Northshire, enough to finish his copy.")
q(346, "Return to Kristoff", SW, 24, SI,
    "With his copy finished, Paxton sent the original Stresses of Iron back, with an apology to Milton for the delay.",
    "The original Stresses of Iron was at last free to go to Brother Kristoff.",
    "Kristoff had the book for his speech and asked the Light to shine on body and spirit both.",
    "The Stresses of Iron reached Brother Kristoff, who gave a priest's blessing in thanks.")
q(399, "Humble Beginnings", SW, 15, LS,
    "Baros Alexston had grown up on a farm in Westfall, now burned and held by thieves. His father thought the boy's first compass was still hidden there.",
    "The Alexston Farmstead lay west of Sentinel Hill. Somewhere on it was a compass Baros had treasured as a boy.",
    "The compass was of no practical use to Baros, but he valued it deeply. He thanked the finder for going so far for it.",
    "Baros's first compass came back from the ruined farm in Westfall, a keepsake of the boy he had been.")
q(335, "A Noble Brew", SW, 30, F,
    "Lord Wishock was lobbying the House of Nobles to investigate Zardeth's hidden establishment. Zardeth meant to keep him busy. For that he needed a Tear of Tilloa from the Garden of Stalvan and a Musquash Root from below the Stonewrought Dam.",
    "Zardeth of the Black Claw had a plan for Lord Wishock. It began with a white flower from Duskwood and a root from the Wetlands.",
    "Zardeth was pleased; the flower and the root were fine samples.",
    "The Tear of Tilloa and the Musquash Root reached Zardeth, who called them fine.")
q(336, "A Noble Brew", SW, 30, F,
    "Wishock spent his days trying to close Zardeth's tavern and his nights running up a bill upstairs. Zardeth had brewed him a special Black Claw stout.",
    "Zardeth sent his Black Claw stout to Lord Wishock in the Hall of Petitioners, promising it had quite a kick.",
    "Wishock took the stout and called its bearer a servant. He tipped a copper and ordered them out of sight so he could enjoy his drink.",
    "Lord Wishock accepted the fine-looking stout with a copper and a dismissal.")
q(1097, "Elmore's Task", SW, 15, L,
    "Smith Argus in Goldshire had word that Grimand Elmore, a dwarven weaponsmith in Stormwind, needed a package carried north. Keeping ties strong with the dwarves mattered.",
    "Grimand Elmore wanted help with a delivery to his homeland, and Argus sent someone to the Dwarven District.",
    "Grimand was glad to have help with his delivery.",
    "At the weapon shop in the Dwarven District, Grimand explained the delivery he needed.")
q(385, "Crocolisk Hunting", "Loch Modan", 15, L,
    "Marek Ironheart traded in the skins and meat of Loch Modan's crocolisks. The beasts had dug in on the islands of the loch.",
    "Crocolisk skins brought good money, Marek said, and he was ready to tell how one had nearly taken his hand.",
    "Marek called the skins excellent specimens, good money for high quality materials.",
    "The crocolisk skins reached Marek at the lodge, and he paid well for them.")
q(467, "Stonegear's Search", "Dun Morogh", 23, M,
    "Pilot Stonegear was always looking for ways to improve his tank's firepower. He had heard rumors of a rare ore.",
    "Stonegear at Steelgrill's Depot wanted someone to hunt down a rare ore for him.",
    "Stonegear was glad to see someone eager for adventure, and had a task in mind.",
    "At the depot, Stonegear explained the search he had in mind.")
q(466, "Search for Incendicite", "Dun Morogh", 22, M,
    "Incendicite, a rare and volatile ore, had been found in a cave northwest of Algaz Gate. Stonegear thought it could make cannon shells with a mighty punch.",
    "Stonegear wanted incendicite ore from the Wetlands, though it was hard to use without blowing oneself up.",
    "Stonegear meant to find someone to work the incendicite right away, and hoped they would not blow themselves up.",
    "The incendicite reached Stonegear, ready for someone brave enough to experiment with it.")
P.questIDs[346].highlight = {"After a long detour through Northshire and Lakeshire, The Stresses of Iron reached Brother Kristoff for his speech.", "Paxton's copy was finished at last, and the original book reached Kristoff with an apology for the delay."}
P.questIDs[399].highlight = {"Baros Alexston's first compass came back from his family's burned farm in Westfall.", "A boyhood compass from the Alexston Farmstead reached Baros, worth nothing in practice and a great deal to him."}

-- Overnight 2026-11-05, last small batch: Lady Sathrah's sacrifice at the
-- Temple of the Moon (Elune's acceptance stays a hope), Zardeth's reward, and
-- Rockgar's call for scouts before the Algaz Gauntlet.
q(2519, "The Temple of the Moon", "Darnassus", 10, B,
    "Sister Aquinne in Dolanaar said a once great creature of the forest needed help. It was a hard task, and Priestess A'moora in the Temple of the Moon would explain it.",
    "A difficult task waited at the Temple of the Moon, and Aquinne sent help to Priestess A'moora.",
    "A'moora received the one Aquinne had sent, ready to explain the task.",
    "In the Temple of the Moon, Priestess A'moora took up the matter Aquinne had mentioned.")
q(2518, "Tears of the Moon", T, 12, B,
    "Lady Sathrah, a great spider once beloved of Elune, had spun silver threads whose dew held healing power for the temple. Now she had gone mad, and A'moora wanted her suffering ended near Wellspring Lake.",
    "Lady Sathrah was beyond hope, A'moora said with regret, and her silvery spinnerets were to be brought back.",
    "The forest mourned Lady Sathrah, A'moora said, but it had to be done.",
    "Sathrah's spinnerets reached A'moora, meant as a sacrifice to Elune so the spider might be reborn at peace.", 4)
q(2520, "Sathrah's Sacrifice", "Darnassus", 12, B,
    "Sathrah's spinnerets were to be laid at the temple's central fountain. There the holy water would cleanse the corruption that had driven her mad.",
    "The sacrifice for Lady Sathrah belonged in the fountain at the heart of the Temple of the Moon.",
    "The spinnerets were offered at the fountain. A'moora said only in this way could Sathrah be reborn with a renewed spirit, and hoped Elune would accept the sacrifice.",
    "Sathrah's sacrifice lay in the temple's waters, and A'moora prayed that Elune would accept it.", 4)
q(397, "You Have Served Us Well", SW, 30, F,
    "Zardeth had heard that Lord Wishock enjoyed his drink. The warlocks of Stormwind could practice undisturbed, he said, and his servant Zggi held a gift in reward.",
    "Zardeth sent the one who had served him to claim a gift from his servant Zggi.",
    "Zggi handed over the gift, admitting he wanted to keep it but knew better than to betray his master.",
    "Zggi gave up his master's gift, though not gladly.")
q(468, "Report to Mountaineer Rockgar", "Loch Modan", 21, KD,
    "Mountaineer Rockgar at Dun Algaz was looking for volunteers for a mission through the pass into the Wetlands. Anyone who wanted to get their boots wet in that soggy country could find him north up the road, beyond the guard tower.",
    "Word went round Loch Modan that Rockgar wanted scouts for the Wetlands. He was at Dun Algaz, past the guard tower.",
    "Rockgar was glad of a volunteer and hoped the gear was in good order. The scouting mission, he said, had turned into something messier.",
    "At Dun Algaz, Rockgar welcomed another pair of boots and warned that scouting was no longer the right word for it.")
P.questIDs[2520].highlight = {"Lady Sathrah's spinnerets were laid in the Temple of the Moon's fountain. The holy water there would cleanse the corruption that had maddened her.", "Sathrah's sacrifice went into the temple's waters, and A'moora hoped Elune would accept it."}

-- Starters3 lane, 2026-11-05: Bishop DeLavey's missing diplomat through every
-- stage told in Stormwind, Duskwood and Menethil (1274, 1241-1250). The
-- Theramore stages (1264-1266) are Dustwallow work for the world lane. No
-- stage before 1250 knows the diplomat is the king; 1250 tells only what Slim
-- confesses (the Defias' unnamed partner stays unnamed). Also Count
-- Ridgewell's tiara, Argos's call for his brother, and Nefarian's head in
-- Stormwind. Ridgewell, Thyn'tel, Thundris, Gwennyth and Laris are named from
-- LoreForever Z_stormwind/Z_darnassus/Z_darkshore/Z_ironforge entries.
-- The diplomat stages share the world pack's thread with its Dustwallow stages.
P.threads.world_diplomat = "the missing diplomat"
P.threads.alliance_relics = "relics for Stormwind's collectors"
P.threads.alliance_nefarian = "the fall of Nefarian"
local MD = "world_diplomat"
q(1274, "The Missing Diplomat", SW, 28, MD,
    "Thomas had been asked to find adventurers for Bishop DeLavey, quietly. The bishop had a delicate matter in Stormwind Keep and wanted it kept out of common talk.",
    "A discreet visit to Bishop DeLavey in Stormwind Keep was all Thomas would say about it. The matter was of some importance.",
    "Bishop DeLavey said he had no time to explain much and would be blunt. Above all, he wanted the matter kept from becoming common knowledge.",
    "In Stormwind Keep, Bishop DeLavey took on the help Thomas had found for him, and asked for discretion.")
q(1241, "The Missing Diplomat", SW, 28, MD,
    "A diplomat sent to meet Jaina Proudmoore in Theramore had never arrived. Bishop DeLavey suspected the Defias, and wrote to his old friend Jorgen in the Valley of Heroes.",
    "The king's agents were already searching the city, but DeLavey wanted his own contacts on the diplomat's trail. The first was Jorgen, who fished in the Valley of Heroes.",
    "Jorgen looked up from the note through squinted eyes and agreed to help, out of obligation rather than wish. He wanted every finding kept secret and nothing said in the taverns.",
    "Jorgen grumbled at being taken from his fishing, but DeLavey's note bound him to help.", 4)
q(1242, "The Missing Diplomat", SW, 28, MD,
    "Jorgen sent a note to Elling Trias at his cheese shop in the Trade District. The courier was to say nothing else and wait for the reply.",
    "Jorgen's note was for Elling Trias, who sold cheddar and Darnassian bleu in the Trade District.",
    "Elling Trias was surprised to get a letter that was not a crate or a barrel. He opened it and looked up at the one who had brought it.",
    "Elling Trias read Jorgen's note in his shop in the Trade District.")
q(1243, "The Missing Diplomat", D, 28, MD,
    "Elling Trias would use his own contacts, but others would do the footwork and save him coin. Watcher Backus, who patrolled the north road outside Darkshire, was the place to start.",
    "Trias wanted to know of any Defias activity in Duskwood. Watcher Backus, on the north road out of Darkshire, would help if told who was asking.",
    "Backus was surprised to hear that Trias had sent someone, and asked what his friend needed on so gloomy a day.",
    "On the north road outside Darkshire, Watcher Backus heard that Trias was looking into the Defias.")
q(1244, "The Missing Diplomat", D, 30, MD,
    "A couple of weeks earlier, Defias agents had gathered at Addle's Stead, and Backus guessed something big had happened there. He wanted anything they had left behind.",
    "The Night Watch kept an eye on the Defias even when they kept to themselves. Their recent gathering at Addle's Stead had seemed odd to Backus.",
    "Backus looked over the papers from Addle's Stead. They looked official for Defias documents, though he warned they could be a ruse.",
    "The papers from Addle's Stead reached Backus, who could not yet say whether they were real or a decoy.")
q(1245, "The Missing Diplomat", SW, 30, MD,
    "The Defias papers were too complex to be a ruse, Backus decided, and too big for him. He sent them to Trias and asked that no one learn he had seen them.",
    "Backus feared his superiors would hang him for keeping the Defias papers to himself. Trias, he said, would make sense of them.",
    "Trias found the papers an interesting read. The Defias had worked hard on their plan, and one name caught his eye, Fist.",
    "Elling Trias read the Defias plan and judged Jorgen and DeLavey smart to bring him in. A familiar name stood out among the papers.")
q(1246, "The Missing Diplomat", SW, 31, MD,
    "Fist was Dashel Stonefist, a brawler usually found in the middle of Old Town. Trias expected him to talk only under some persuasion.",
    "If Dashel Stonefist was as deep in the plan as the papers suggested, Trias said, he would give nothing up willingly.",
    "Dashel Stonefist took the questions badly, angry that anyone would come into his alley asking about his business.",
    "In Old Town, Dashel met the questions about his business with open hostility.")
q(1247, "The Missing Diplomat", SW, 31, MD,
    "Dashel admitted to the meeting at Addle's Stead, though he said his part ended when plan A failed. The man on the inside for plan B had come out of Menethil, a man called Slim.",
    "Dashel gave up a name at last. The Defias had a backup plan, and their man for it was Slim, from Menethil.",
    "Trias had read more of the plan. The Defias had failed once to capture the diplomat and then turned to plan B. Slim in Menethil was a place to start.",
    "Trias was glad to see Dashel's questioner alive, and took Slim's name as the next lead.")
q(1248, "The Missing Diplomat", "Wetlands", 33, MD,
    "A retired contact of Trias's tended bar in Menethil Harbor, a man named Mikhail. He would help on Trias's word, and might find Slim.",
    "The Defias docket said nothing of where the diplomat had been taken. Trias sent word to Mikhail in Menethil to find Slim and learn more.",
    "Mikhail welcomed the newcomer with ale and mutton. At the name Trias, he lowered his voice and said this was not for the whole tavern to hear.",
    "In Menethil's tavern, Mikhail heard Trias's name and asked for quiet.")
q(1249, "The Missing Diplomat", "Wetlands", 33, MD,
    "Mikhail did not know the name Slim. He did notice a man by the door listening too closely, and thought him worth stopping before he ran.",
    "A stranger near the tavern's exit was listening a little too intently, Mikhail warned.",
    "The listener by the door was Slim after all. Mikhail admitted he missed the old underground excitement, and asked that Elling not hear of it.",
    "Slim was caught in Mikhail's tavern. Mikhail was surprised, and glad to have been of some service.")
q(1250, "The Missing Diplomat", "Wetlands", 33, MD,
    "Slim said the Defias did not pay him enough to die for them. They had taken the king of Stormwind on his way to meet Jaina Proudmoore. Slim's part was to get their man Hendel aboard the king's ship.",
    "The missing diplomat was the king himself, Slim confessed. The Defias were working with someone else, and their man aboard the royal ship was called Hendel.",
    "Mikhail had not even heard the king was missing. He sent word to Elling at once, and thought he could help find Hendel.",
    "Mikhail could not believe Slim had sold out Stormwind for a few coins. Finding Hendel came next, and Mikhail thought he could help.", 6)
P.questIDs[1250].highlight = {"In Menethil, Slim confessed that the missing diplomat was the king of Stormwind, taken by the Defias. Their man aboard the royal ship was named Hendel.",
    "Bishop DeLavey's quiet inquiry reached a Menethil tavern, where Slim admitted the Defias had taken the king. Mikhail sent word to Elling Trias at once."}
P.questIDs[1241].highlight = {"Bishop DeLavey suspected the Defias when a diplomat bound for Theramore never arrived. His old friend Jorgen agreed to help, out of obligation.",
    "Bishop DeLavey's search for a missing diplomat began with Jorgen, fishing in the Valley of Heroes."}
q(543, "The Perenolde Tiara", SW, 40, "alliance_relics",
    "The Perenolde Tiara had belonged to the ruling family of Alterac before the kingdom fell. Rumor said the ogre mage Grel'borg the Miser had found it in the Ruins of Alterac.",
    "Count Remington Ridgewell wanted the Perenolde Tiara for his collection. Master jewelers of Ironforge had set it with emeralds, and it was lost when Alterac fell.",
    "Count Ridgewell called the tiara splendid. It would need cleaning, and then it would take its place in his collection.",
    "The Perenolde Tiara reached Count Ridgewell, who had it prepared for display and promised gratitude as grand as his collection.")
q(3765, "The Corruption Abroad", "Darkshore", 24, J,
    "A night elf had come all the way to Stormwind looking for help. His brother Gershala, in the seaside town of Auberdine, needed it.",
    "Argos Nightwhisper sought a seasoned adventurer in Stormwind's streets for his brother Gershala in Darkshore. The journey, he warned, was a long one.",
    "Gershala Nightwhisper heard that his brother Argos had sent help. There was much to talk about, he said, after so long a journey.",
    "In Auberdine, Gershala welcomed the one his brother had found in Stormwind.")
q(7781, "The Lord of Blackrock", SW, 60, "alliance_nefarian",
    "The battle-scarred head of Nefarian was to go to Highlord Bolvar Fordragon in Stormwind.",
    "Nefarian's head belonged before the Highlord in Stormwind Keep, who called the news inconceivable.",
    "Bolvar said the day would be remembered in the annals of history. The Alliance had not known such a victory in years, if ever.",
    "Nefarian's head reached Bolvar Fordragon, who called it a victory like no other in the Alliance's memory.", 6)
q(7782, "The Lord of Blackrock", SW, 60, "alliance_nefarian",
    "Bolvar sent the bearers of Nefarian's head to Field Marshal Afrasiabi in the Valley of Heroes.",
    "In the Valley of Heroes, Field Marshal Afrasiabi waited with rewards for the fall of Nefarian.",
    "Afrasiabi bowed, offered a reward and called for the celebration to begin.",
    "The celebration of Nefarian's fall began, with rewards from Field Marshal Afrasiabi.", 5)
P.questIDs[7781].highlight = {"Nefarian's head reached Highlord Bolvar Fordragon, who called it a victory the Alliance had not known in years, if ever.",
    "Bolvar Fordragon received the head of Nefarian, lord of Blackrock, and said the day would be remembered."}
P.questIDs[7782].highlight = {"Field Marshal Afrasiabi bowed and called for the celebration of Nefarian's fall to begin.",
    "In the Valley of Heroes, the celebration of Nefarian's fall began."}

-- Starters3 lane, 2026-11-05: Ironforge's gnome craftsmen and scholars
-- (Talvash's ring, Laris's ooze samples; Laris works in Ironforge per
-- https://warcraft.wiki.gg/wiki/Laris_Geardawdle), the search for Velinde
-- Starsong to Ratchet, the Alliance Nightmare Shard, the Kor gem in Auberdine,
-- and the beached sea creatures of Darkshore. The beached stages each keep
-- their own finding; none solves why the creatures come ashore.
P.threads.alliance_gnomecraft = "the gnome craftsmen of Ironforge"
P.threads.alliance_velinde = "the search for Velinde Starsong"
P.threads.alliance_dream = "the shard from the Emerald Dream"
P.threads.alliance_stilwell = "the Kor gem for Jordan Stilwell"
P.threads.alliance_beached = "the sea creatures beached on Darkshore"
local GC, VL, BC = "alliance_gnomecraft", "alliance_velinde", "alliance_beached"
q(2948, "Gnome Improvement", IF, 35, GC,
    "Talvash del Kissel had made the ring long ago to a simple design, and was sure he could do better now. He was out of stock and asked for a silver bar and a moss agate.",
    "Talvash del Kissel, a gnome jeweler in Ironforge, was down on his luck. He offered to add a silver and agate lattice to a ring he had made long ago, if someone brought the materials.",
    "Talvash set the silver and agate into a new lattice. One day, he said, he would make the finest trinkets in all of Azeroth.",
    "The ring came back with a silver and agate lattice. Talvash said he usually charged ten times as much for such quality.")
q(4512, "A Little Slime Goes a Long Way", IF, 52, GC,
    "Laris Geardawdle studied oozes. He had seen the Royal Apothecary Society collecting them and wanted to know why. There were more in Felwood, he had heard.",
    "Laris suspected oozes were tied to the making of the world itself, a theory few liked. He wanted samples from the oozes of Felwood to test it.",
    "The Felwood samples were perfect, Laris said. If he was right, he could become one of the Explorers' League's greatest scientists. It would show the dwarves that taking in the gnomes had been no mistake.",
    "Laris had his Felwood ooze samples and could not wait to start testing them.")
q(4513, "A Little Slime Goes a Long Way", IF, 54, GC,
    "The Felwood samples were corrupt like the forest. Laris realized that oozes took on the nature of the place they lived. He needed pure samples, and did not know where to find them.",
    "Laris needed ooze samples untouched by pollution to compare with the corrupt ones, and handed out containers in case any turned up.",
    "Laris was overjoyed with the pure samples. He went back to his work and said he would likely need help again.",
    "Pure ooze samples reached Laris Geardawdle, who called the help magnificent.")
q(1038, "Velinde's Effects", "Darnassus", 30, VL,
    "The Tome of Mel'Thandris had pointed to Velinde Starsong, a priestess who had left her post. Thyn'tel Bladeweaver gave a key to the chest of her belongings in the Sentinels' bunkhouse.",
    "The Sentinels believed Velinde had her own reasons for leaving and could return at any time. The notes she kept of her duties, locked in a chest in their bunkhouse, were the place to look.",
    "Velinde's notes made her disappearance look more troubling. Thyn'tel still could not believe she had come to a bad end, and wanted to make contact with her.",
    "Velinde's belongings showed her leaving was no simple matter. Thyn'tel asked for help in reaching her.", 4)
q(1039, "The Barrens Port", "The Barrens", 30, VL,
    "Ratchet was the only port in the Barrens. Velinde had most likely found a trading ship there bound for Blackwater Cove. The goblin master of the dock would know who had sailed.",
    "Thyn'tel sent the search for Velinde south through Ashenvale and Horde lands to Ratchet, where the wharfmaster kept track of passengers.",
    "Wharfmaster Dizzywig did not see many of the seeker's kind, and began searching his ledgers for Velinde.",
    "In Ratchet, Dizzywig agreed to look through his ledgers for the missing priestess.")
q(3370, "In Nightmares", "Darnassus", 25, "alliance_dream",
    "Falla Sagewind saw the pure essence of the Emerald Dream in a shard, and a nightmare in it. She wanted it in the hands of Mathrengyl Bearwalker of the Cenarion Circle in Darnassus.",
    "A shard from the Emerald Dream troubled Falla Sagewind. She would say only that a wise druid had to have it soon.",
    "Mathrengyl peered into the shard and faltered. Things in the Emerald Dream were not as the druids had thought, he said. Such matters were for the Cenarion druids alone.",
    "The shard reached Mathrengyl Bearwalker, who advised leaving such matters to the Cenarion druids.", 4)
P.questIDs[3370].highlight = {"Mathrengyl Bearwalker looked into Falla Sagewind's shard and faltered. Things in the Emerald Dream were not as the druids had thought.",
    "Falla Sagewind's shard reached Mathrengyl Bearwalker of the Cenarion Circle, who kept what he saw in it for the druids alone."}
q(1442, "Seeking the Kor Gem", "Darkshore", 22, "alliance_stilwell",
    "Thundris Windweaver remembered Jordan Stilwell, a blacksmith from long ago, and trusted that his wish for a Kor gem was noble. The naga who still used the gems were deep in Blackfathom Deeps.",
    "Jordan Stilwell needed a Kor gem. Thundris Windweaver in Auberdine sent the seeker to the ruins of Blackfathom Deeps in northwestern Ashenvale, and warned against going alone.",
    "Thundris confirmed the gem was the one Stilwell wanted, then purified it of the naga's corruption. Its power was intact for Stilwell's ritual.",
    "The Kor gem from Blackfathom Deeps was cleansed in Auberdine, ready to carry back to Stilwell.")
q(4722, "Beached Sea Turtle", "Darkshore", 13, BC,
    "A sea turtle had beached itself on the Darkshore coast some time ago, and murlocs had camped around its remains. Enough was left for a sample.",
    "Gwennyth Bly'Leggonde in Auberdine studied the creatures that washed up on Darkshore, and a murloc-scavenged sea turtle still held usable remains.",
    "Gwennyth sent the turtle remains on to Darnassus to be studied properly, and paid a small honorarium.",
    "Another beached turtle went into Gwennyth's research, bound for Darnassus.")
q(4723, "Beached Sea Creature", "Darkshore", 13, BC,
    "A giant thresher lay beached at the Mist's Edge, far larger than any thresher of Darkshore. The murlocs feasting on it were much too weak to have brought it down.",
    "A great thresher had come ashore at the Mist's Edge, and no one knew how. Enough of it remained for a sample for Gwennyth Bly'Leggonde.",
    "Gwennyth took the thresher sample for study in Darnassus. One day, she hoped, they might find a way to keep these creatures from dying on the coast.",
    "The thresher's remains went into the Temple of the Moon's research, and Gwennyth paid for the find.")
q(4725, "Beached Sea Turtle", "Darkshore", 15, BC,
    "This sea turtle had an abandoned carriage strapped to its shell, as if something had driven it ashore. Greymist murlocs fed on it, and in the carriage lay a box with strange markings.",
    "A box with strange markings sat in a carriage on a beached turtle's shell. Gwennyth Bly'Leggonde might make sense of it.",
    "Gwennyth knew such carriages. The naga used them in battle and to bring supplies ashore. The markings were naga too, which explained their presence in far-northern Darkshore.",
    "The marked box was naga work, Gwennyth said, and it went to Darnassus with the other finds.", 4)
P.questIDs[4725].highlight = {"Gwennyth Bly'Leggonde read naga markings on a box from a beached turtle's carriage. It explained the naga in far-northern Darkshore.",
    "Gwennyth Bly'Leggonde of Auberdine sent the naga box from a beached turtle's carriage on to Darnassus."}
q(4727, "Beached Sea Turtle", "Darkshore", 15, BC,
    "The bones of a sea turtle lay on the northern beaches with no murlocs near them, whether unfound or avoided.",
    "A turtle skeleton on the northern beaches still had enough left for the Temple of the Moon to study.",
    "Gwennyth noted that no murlocs had been at this site. She paid on the temple's behalf.",
    "The turtle's bones went to the Temple of the Moon's study, with the odd absence of murlocs noted.")
q(4728, "Beached Sea Creature", "Darkshore", 14, BC,
    "A giant sea mammal lay half gutted on the beach. A wheelbarrow and tools lay beside it, as if someone had begun to study it.",
    "Murlocs had scavenged the beached beast, and someone had abandoned tools beside it, but a sample remained.",
    "Gwennyth recognized the site. The Explorers' League had been studying that creature until the murlocs drove them off.",
    "Where the Explorers' League and Gwennyth had both failed, the sample came back. She paid an honorarium from the Temple of the Moon.")
q(4730, "Beached Sea Creature", "Darkshore", 16, BC,
    "A half-devoured sea mammal lay on the beach, ringed by murlocs stronger than those near Auberdine.",
    "Bones from a beached sea mammal could go to Gwennyth Bly'Leggonde, if the murlocs around it allowed.",
    "The bones came from gentle sea mammals that lived around the base of Teldrassil. They had never been known to beach themselves, and Gwennyth wondered why they did now.",
    "Gwennyth hoped the gentle mammal's bones would show why such creatures were coming ashore.")
q(4731, "Beached Sea Turtle", "Darkshore", 19, BC,
    "Another beached sea turtle had a carriage half buckled to its shell. Powerful Greymist murlocs had made the carcass their home.",
    "A second marked box lay in a carriage on a beached turtle, more evidence for Gwennyth Bly'Leggonde.",
    "The box was naga again. Gwennyth wondered whether the turtle had been killed while heading south, perhaps toward Ashenvale.",
    "Gwennyth took the second naga box for Darnassus and guessed the turtle had been bound south.")
q(4732, "Beached Sea Turtle", "Darkshore", 19, BC,
    "Greymist murlocs had picked another beached sea turtle nearly clean, but samples remained.",
    "One more sea turtle had beached itself on the Darkshore coast, and the murlocs camped around it had left a little behind.",
    "Sea turtles had once played along the base of Nordrassil, Gwennyth said. Since Teldrassil grew, they had become fewer, and some came here to die.",
    "The turtle samples went to Gwennyth, who hoped they might unlock the mystery of the beachings.")
q(4733, "Beached Sea Creature", "Darkshore", 19, BC,
    "A giant thresher had washed ashore on the rocky inlet of the Twilight Shore, several times larger than any thresher seen there.",
    "A great thresher on the Twilight Shore did not seem native to Darkshore. Gwennyth Bly'Leggonde would want a sample.",
    "Even the eldest threshers of the region grew to a fraction of that size. Larger ones had lived near Teldrassil, and Gwennyth wondered if their decline was tied to the beachings.",
    "The thresher's size astonished Gwennyth, who began to suspect a link between the beachings and the dwindling threshers near Teldrassil.", 4)
P.questIDs[4733].highlight = {"Gwennyth Bly'Leggonde heard of a thresher several times larger than any in Darkshore. She wondered if the beachings were tied to the dwindling threshers near Teldrassil.",
    "Gwennyth Bly'Leggonde wondered about the dwindling threshers near Teldrassil once the giant from the Twilight Shore was found."}
-- Tormus Deepforge (named from LoreForever quest:1578) sends smiths' work to
-- his colleague Thorvald on the Loch Modan front.
q(1578, "Supplying the Front", "Loch Modan", 12, KD,
    "The mountaineers of Loch Modan were fighting troggs and wore through their gear. Tormus Deepforge in Ironforge wanted copper axes and chain belts made for them.",
    "Thorvald kept the mountaineers in good gear from Loch Modan's southern guard tower. Tormus Deepforge thought a smith's copper work would oblige him.",
    "Thorvald had no time to chat until he saw the axes and belts. They would be a big help to the troops, and he shared plans for armor.",
    "The copper axes and chain belts went to the mountaineers' front. Thorvald paid with armor plans of his own.")

-- Only unambiguous titles may reuse exact-ID consequences. All chain titles
-- receive explicitly conservative fallback prose below, including Forever steps.
local ambiguous = {
    ["The Defias Brotherhood"] = true, ["The Escape"] = true,
    ["Westfall Stew"] = true, ["The People's Militia"] = true,
    ["Messenger to Stormwind"] = true, ["The Night Watch"] = true,
    ["Coldridge Valley Mail Delivery"] = true, ["Senir's Observations"] = true,
    ["The Balance of Nature"] = true, ["The Woodland Protector"] = true,
    ["Iverron's Antidote"] = true, ["Twisted Hatred"] = true,
    ["Crown of the Earth"] = true, ["Bashal'Aran"] = true, ["Washed Ashore"] = true,
    ["A Dark Threat Looms"] = true, ["In Defense of the King's Lands"] = true,
    ["Ormer's Revenge"] = true,
    ["Reclaiming the Charred Vale"] = true, ["On Guard in Stonetalon"] = true,
    ["Captain Sander's Hidden Treasure"] = true, ["Messenger to Westfall"] = true,
    ["Messenger to Darkshire"] = true, ["Worgen in the Woods"] = true,
    ["Look to the Stars"] = true, ["How Big a Threat?"] = true,
    ["The Thandol Span"] = true, ["A King's Tribute"] = true,
    ["The Absent Minded Prospector"] = true, ["The Tower of Althalaxx"] = true,
    ["A Lost Master"] = true, ["A Noble Brew"] = true,
    ["The Missing Diplomat"] = true, ["The Lord of Blackrock"] = true, ["In Nightmares"] = true,
    ["Beached Sea Turtle"] = true, ["Beached Sea Creature"] = true, ["A Little Slime Goes a Long Way"] = true,
    ["Seeking the Kor Gem"] = true,
}
for _, entry in pairs(P.questIDs) do
    if not ambiguous[entry.title] then P.quests[entry.title] = entry end
end
local function chain(title, id, why1, why2, after1, after2)
    local base = P.questIDs[id]
    P.quests[title] = {zone = base.zone, level = base.level, thread = base.thread,
        threadLabel = base.threadLabel, importance = base.importance,
        why = {why1, why2}, after = {after1, after2}, source = {"corpus_vanilla_quests.txt: all stages titled " .. title}}
end
chain("A Dark Threat Looms", 250,
    "Dark Iron activity had raised fears for Stonewrought Dam.",
    "The dam's safety depended on investigating the sappers and the materials they carried.",
    "The work against the suspected threat to the dam advanced.",
    "Another part of the inquiry into the Dark Iron danger was finished.")
chain("Reclaiming the Charred Vale", 1057,
    "The burned vale needed help before its forest could grow again.",
    "Harpies and the aftermath of industrial destruction stood in the way of Stonetalon's recovery.",
    "The effort to make restoration possible received help.",
    "One part of the work for the Charred Vale was finished.")
chain("On Guard in Stonetalon", 1070,
    "Kaela and Gaxim were investigating the damage to Stonetalon's forests.",
    "The Sentinel and the engineer sought help against the Venture Company's destruction.",
    "The inquiry in Stonetalon reached another of its waiting contacts.",
    "A referral advanced the work around Kaela and Gaxim.")
chain("In Defense of the King's Lands", 224,
    "The mountaineers defended Loch Modan against a growing Stonesplinter incursion.",
    "Troggs pressed the loch's defenders while soldiers were needed on distant fronts.",
    "The mountaineers had help against the troggs around the loch.",
    "One assignment in Loch Modan's defense was finished.")
chain("Ormer's Revenge", 294,
    "Ormer sought vengeance for the expedition workers killed by raptors at Whelgar's dig.",
    "The stranded survivors faced raptors on the ground below their shelter.",
    "Ormer's campaign against the raptors received help.",
    "Another part of the fighting around the excavation was finished.")
chain("The Defias Brotherhood", 65,
    "The Defias raids on Westfall had led the militia to investigate who directed them.",
    "The militia's search for the Brotherhood's leadership depended on witnesses, messages and evidence.",
    "One part of the militia's work concerning the Defias was finished.",
    "The completed assignment belonged to the wider effort against the Brotherhood.")
-- Starters3 shared titles: a title-only record names no stage's finding.
local function neutral(title, zone, thread, ids, w1, w2, a1, a2)
    P.quests[title] = {zone = zone, thread = thread, threadLabel = P.threads[thread], importance = 3,
        why = {w1, w2}, after = {a1, a2}, source = {"corpus_vanilla_quests.txt: quests " .. ids}}
end
neutral("The Missing Diplomat", SW, MD, "1274, 1241-1250, 1264-1266",
    "A diplomat sent to Theramore had never arrived, and Bishop DeLavey wanted the matter looked into quietly.",
    "Bishop DeLavey's contacts were following a quiet trail after a diplomat who never reached Theramore.",
    "The quiet inquiry into the missing diplomat went on.",
    "Another of DeLavey's contacts had been reached on the diplomat's trail.")
neutral("The Lord of Blackrock", nil, "alliance_nefarian", "7781-7784",
    "The battle-scarred head of Nefarian was carried home as proof of his fall.",
    "Nefarian's head, the lord of Blackrock's, was a trophy for a capital's leaders.",
    "Word of Nefarian's death reached those who had waited for it.",
    "The head of Nefarian was brought before a capital's leaders.")
neutral("In Nightmares", nil, "alliance_dream", "3369, 3370",
    "A shard holding a vision from the Emerald Dream was meant for a wise druid.",
    "Falla Sagewind had seen something in a shard that she would not speak of.",
    "The shard reached a druid who advised against speaking of what it held.",
    "Falla's shard was in a druid's hands, and its vision stayed unspoken.")
neutral("Beached Sea Turtle", "Darkshore", BC, "4722, 4725, 4727, 4731, 4732",
    "Sea turtles had been washing up dead on the Darkshore coast.",
    "Gwennyth Bly'Leggonde in Auberdine wanted samples from the turtles beached on Darkshore.",
    "Gwennyth Bly'Leggonde had one more sample from a beached turtle.",
    "Another beached turtle went into the Temple of the Moon's research.")
neutral("Beached Sea Creature", "Darkshore", BC, "4723, 4728, 4730, 4733",
    "Great sea creatures had been coming ashore on Darkshore to die.",
    "Gwennyth Bly'Leggonde in Auberdine wanted samples from the creatures beached on Darkshore.",
    "Gwennyth Bly'Leggonde had one more sample from a beached sea creature.",
    "Another beached creature went into the Temple of the Moon's research.")
-- (no thread: the Forsaken stage 95042 in the Forever pack must keep its own label)
neutral("Seeking the Kor Gem", nil, nil, "1442, 95042",
    "A Kor gem was wanted, and the naga who still used them were deep in Blackfathom Deeps.",
    "Kor gems could empower holy weapons, and the naga of Blackfathom Deeps carried them.",
    "A Kor gem came out of Blackfathom Deeps, corrupted by the naga.",
    "The search for a Kor gem led out of Blackfathom Deeps.")
neutral("A Little Slime Goes a Long Way", IF, GC, "4512, 4513",
    "Laris Geardawdle in Ironforge studied oozes and wanted samples.",
    "The gnome scholar Laris Geardawdle had a theory about oozes and needed samples to test it.",
    "Laris Geardawdle had more ooze samples for his study.",
    "More ooze samples reached Laris Geardawdle.")
-- Also names an unrelated Barrens escort: historical titles cannot choose a plot.
P.quests["The Escape"] = {importance = 3,
    why = {"Getting out of danger required practical help.", "An escape depended on assistance before the immediate difficulty could be left behind."},
    after = {"The requested help with the escape was supplied.", "The immediate errand was done, making a way out possible."},
    source = {"corpus_vanilla_quests.txt: quests 114 and 863"}}
chain("Westfall Stew", 36,
    "Westfall's farm kitchens still depended on recipes and supplies passed between neighbors.",
    "Even as thieves drove families from their land, there was everyday work around the cooking pot.",
    "The errand helped with the Saldeans' cooking arrangements.",
    "One of the small tasks that kept Westfall's households going was finished.")
chain("The People's Militia", 12,
    "The People's Militia fought to protect Westfall's farms from the Defias.",
    "Westfall's scattered settlements depended on local defenders against the raiders.",
    "The militia had help against the Defias that troubled its farms.",
    "Westfall's defenders received help, though the wider struggle continued.")
chain("Messenger to Stormwind", 120,
    "Lakeshire needed reinforcements, and Solomon's correspondence linked the town with Stormwind.",
    "The general and the magistrate exchanged news while Redridge remained under threat.",
    "A dispatch in Lakeshire's appeal for help reached its destination.",
    "The correspondence moved another step while the town's need for soldiers remained.")
chain("The Night Watch", 56,
    "The Night Watch guarded Darkshire with too few people to meet the undead threat alone.",
    "Duskwood's restless dead kept the Watch stretched between town and graveyard.",
    "The Watch had help holding back the dead around Darkshire.",
    "Darkshire's defenders received help without ending the danger in Duskwood.")
chain("Coldridge Valley Mail Delivery", 233,
    "Mail from outside the valley needed carrying between Coldridge's scattered camps.",
    "Letters connected the cold little camps with the world beyond the pass.",
    "The post reached another of Coldridge's waiting recipients.",
    "A small delivery kept news moving through the valley.")
chain("Senir's Observations", 282,
    "A report from Coldridge needed passage toward Senir in Kharanos.",
    "The trogg-infested tunnel complicated the movement of reports through Dun Morogh.",
    "The dispatch advanced along its route out of Coldridge.",
    "Another part of the reporting errand was complete.")
chain("The Balance of Nature", 456,
    "Heavy spring rains had increased Shadowglen's herds beyond the forest's food supply.",
    "Ilthalaine's work concerned the numbers of nightsabers and thistle boars the forest could sustain.",
    "The hunt helped with Ilthalaine's effort to limit pressure on the forest.",
    "One assignment in the conservator's work was complete.")
chain("The Woodland Protector", 458,
    "Tarindrella's return brought attention to the troubles spreading through Shadowglen.",
    "The woodland protector had business in a grove whose peace was under threat.",
    "The work brought help to the troubles surrounding Tarindrella's return.",
    "Another part of the work around Tarindrella's return was finished.")
chain("Iverron's Antidote", 3521,
    "Iverron needed help after being poisoned by the Webwood spiders.",
    "Dirania's antidote offered a possible answer to Iverron's worsening condition.",
    "The work brought Iverron's remedy a step closer.",
    "One part of the urgent work on Iverron's behalf was done.")
chain("Twisted Hatred", 932,
    "Satyr activity near Dolanaar was a matter Tallonkai wanted handled quietly.",
    "The threats in Teldrassil's caves called for investigation as well as fighting.",
    "Tallonkai had help dealing with the satyrs near Dolanaar.",
    "Another part of Dolanaar's quiet investigation was complete.")
chain("Crown of the Earth", 921,
    "Teldrassil's moonwell waters were bound up with the druids' work and the history of their new home.",
    "The new World Tree's troubles gave the work with its sacred waters a particular urgency.",
    "The errand advanced the work with Teldrassil's moonwell waters.",
    "Another part of the task concerning the sacred water was finished.")
chain("Bashal'Aran", 954,
    "A blue-lit shrine stood amid the demon-haunted ruins of Bashal'Aran.",
    "The old ruins held a mystery that the surrounding grells and satyrs could not explain by themselves.",
    "The inquiry at Bashal'Aran moved another step.",
    "One part of the work concerning the old shrine was complete.")
chain("Washed Ashore", 3524,
    "Dead sea creatures along Darkshore's coast had drawn the Temple of the Moon's attention.",
    "The increasing coastal strandings needed samples before their cause could be understood.",
    "The temple's investigation gained another sample to study.",
    "More evidence reached the investigator, while the cause remained uncertain.")

chain("Captain Sander's Hidden Treasure", 136,
    "Captain Sanders had left a trail of clues to his treasure along the Westfall coast.",
    "A drowned captain's map led from one hiding place to the next between the shore and the bluffs.",
    "Another of Captain Sanders's clues was found.",
    "The search for the captain's treasure moved to its next hiding place.")
chain("Messenger to Westfall", 143,
    "Lakeshire and Sentinel Hill exchanged letters while both waited in vain for Stormwind's soldiers.",
    "Magistrate Solomon looked to Westfall's militia for the help Stormwind had not sent.",
    "A letter between Lakeshire and the People's Militia reached its reader.",
    "The correspondence between Solomon and Stoutmantle moved another step.")
chain("Messenger to Darkshire", 145,
    "Magistrate Solomon looked to Darkshire's Night Watch for the help Stormwind had not sent.",
    "Letters passed between Lakeshire and Darkshire while both towns stood without the army.",
    "A letter between Lakeshire and Darkshire reached its reader.",
    "The correspondence between Solomon and Ebonlocke moved another step.")
chain("Worgen in the Woods", 173,
    "Calor tested those who wished to join Master Carevin against the worgen of Duskwood.",
    "Worgen packs had spread through Duskwood's groves, orchard and mines.",
    "Calor's hunt against the worgen had help.",
    "Another of Calor's worgen hunts was finished.")
chain("Look to the Stars", 174,
    "Viktori Prism'Antras was building a device from Cog's blueprint to look at the stars.",
    "Viktori hoped the stars could explain the change in Duskwood's forest, and his device needed parts.",
    "Viktori's star-viewing device gained another part.",
    "The work on Viktori's device moved another step.")
chain("How Big a Threat?", 984,
    "Terenthis wanted to know how far the furbolgs' corruption had spread in Darkshore.",
    "Corruption among the furbolgs worried Auberdine's defenders after what had happened in Teldrassil.",
    "Terenthis had help with the furbolg threat near Auberdine.",
    "Another part of the work against the corrupted furbolgs was finished.")
chain("The Thandol Span", 631,
    "The Dark Irons had struck at the Thandol Span and Dun Modr, and Rhag Garmason's defenders were stretched thin.",
    "The bridge carried Khaz Modan's supply line north, and its defenders waited for reinforcements that did not come.",
    "Rhag Garmason had help at the Thandol Span.",
    "Another part of the work at the Thandol Span was finished.")
chain("A King's Tribute", 686,
    "King Magni had commissioned a memorial to Sully Balloo, a soldier lost at the Thandol Span.",
    "The memorial to Sully Balloo passed between the King and Ironforge's Grand Mason.",
    "The work on Sully Balloo's memorial moved another step.",
    "Another part of King Magni's tribute was done.")
chain("The Absent Minded Prospector", 729,
    "Prospector Remtravel's dig in Darkshore had turned up a mysterious fossil and a great deal of trouble.",
    "Remtravel's fossil passed between archaeologists in Darkshore, Darnassus and Menethil.",
    "The work around Remtravel's fossil moved another step.",
    "Another part of the Explorers' League's business with the fossil was done.")
chain("The Tower of Althalaxx", 965,
    "Warlocks of the Cult of the Dark Strand had gathered at the Tower of Althalaxx in northern Darkshore.",
    "Balthule and Delgren the Purifier were working against the warlocks of the Tower of Althalaxx.",
    "The work against the Dark Strand had help.",
    "Another part of the fight against the tower's warlocks was finished.")
chain("A Lost Master", 986,
    "Terenthis and Grimclaw were searching for Volcor, missing in Darkshore.",
    "Grimclaw's master Volcor had not come back from the furbolg country south of Auberdine.",
    "The search for Volcor moved another step.",
    "Another part of the work to find Volcor was done.")
chain("A Noble Brew", 335,
    "Zardeth of the Black Claw wanted Lord Wishock kept away from his hidden establishment beneath Stormwind.",
    "Lord Wishock's campaign against Zardeth's tavern had given the warlock a reason to scheme.",
    "Zardeth's plan for Lord Wishock moved another step.",
    "Another part of Zardeth's errand was done.")
-- Shared titles cannot turn the first referral (66) into the execution (98).
-- Original quest description/completion: corpus_vanilla_quests.txt #66, #98.
q(66, "The Legend of Stalvan", D, 28, "alliance_stalvan",
    "Madame Eva feared for her granddaughter Alyssa, and her search for an answer had brought her the name Stalvan.",
    "Eva's cards had shown Death; the name Stalvan was her only lead.",
    "Madame Eva's question about Stalvan reached the clerk in Darkshire's town hall, who knew at once who had sent it.",
    "The town hall clerk received Eva's inquiry about Stalvan.", 4)
q(98, "The Legend of Stalvan", D, 35, "alliance_stalvan",
    "The investigation had led Darkshire's defenders to order Stalvan's execution.",
    "Stalvan's cottage stood north of Darkshire, and the guard wanted the threat to the town ended.",
    "Stalvan was dead, and Madame Eva mourned his victims even as she welcomed the end of his killings.",
    "Stalvan's family ring reached Madame Eva, who confirmed that his killing days were over.", 5)
local stalvanContext = "Madame Eva is a fortune-teller in Darkshire. Fearing for her granddaughter Alyssa, she turns to her cards and uncovers the name Stalvan. The town hall's records offer a place to begin investigating the warning."
P.quests["The Legend of Stalvan"] = {zone = D, level = 28, thread = "alliance_stalvan",
    threadLabel = P.threads.alliance_stalvan, importance = 4,
    why = P.questIDs[66].why,
    after = {"The inquiry into Stalvan continued.", "The investigation followed another lead concerning Stalvan."},
    noteSummary = stalvanContext, source = {"corpus_vanilla_quests.txt: quest 66 (inquiry context only; title does not identify a stage)"}}
for _, id in ipairs({66, 98}) do
    P.questIDs[id].noteSummary = stalvanContext
    P.questIDs[id].noteSources = {"corpus_vanilla_quests.txt: quest 66 (public inquiry context)"}
end

P.zones = {
    [E] = {sight = {"The abbey, vineyards and farmsteads stood within reach of the forest's troubled mines.", "Roads connected Goldshire's tradespeople with farms that had problems of their own."}, stakes = {"The guards depended on help with everything from missing supplies to armed raiders.", "Stormwind's countryside still needed ordinary work done while its defenders were stretched thin."}},
    [W] = {sight = {"Farmhouses and old fields lay scattered around the militia's tower.", "The farms stood among mines, quarries and a coast where the Defias could hide."}, stakes = {"Some families were leaving; others still tried to keep their farms working.", "The militia's fight and the farmers' daily needs belonged to the same troubled countryside."}},
    [R] = {sight = {"Lakeshire stood beside the lake with hostile ground beyond its roads.", "Stonewatch's occupation cast a shadow over the country outside Lakeshire."}, stakes = {"Solomon needed help that the kingdom had been slow to provide.", "Keeping a town supplied mattered alongside holding its attackers back."}},
    [D] = {sight = {"Darkshire's watch stood between the town and the restless graveyards.", "The settlements and cemeteries of Duskwood lay under the same dark canopy."}, stakes = {"The Night Watch had too few defenders to meet every threat alone.", "The town still required food and ordinary labor while its dead refused to rest."}},
    ["Dun Morogh"] = {sight = {"Coldridge's camps and Kharanos's workshops were separated by snow and dangerous passages.", "The depot's siege engines and the quarry's broken equipment told different parts of Dun Morogh's working life."}, stakes = {"The dwarven settlements needed reports, provisions and working tools as much as weapons.", "Gnomeregan's surviving engineers sought a way forward while their fallen city remained beyond them."}},
    ["Loch Modan"] = {sight = {"Thelsamar's roads curved around the loch toward digs in the hills.", "Excavation camps depended on supplies sent out from town."}, stakes = {"Trogg attacks could bring the search for ancient history to a halt.", "The gate's defenders and the prospectors both needed help from outside their own ranks."}},
    ["Wetlands"] = {sight = {"Menethil's boats connected a marshbound settlement with distant ports.", "The road toward Dun Modr ran through country claimed by crocolisks and deep marsh."}, stakes = {"The port's trades depended on work in the dangerous country outside town.", "Beyond the road, Rethiel attended to wounds in the living marsh."}},
    [T] = {sight = {"Moonwells and little settlements lay beneath the new World Tree's canopy.", "The path from Shadowglen led toward Dolanaar, with troubled furbolg homes beyond the road."}, stakes = {"The kaldorei's new home had not restored the immortality lost at Mount Hyjal.", "The corruption of the forest threatened homes, sacred places and the creatures that shared them."}},
    ["Darkshore"] = {sight = {"Auberdine stood between the coastal strandings and the inland ruins.", "Old Highborne stones survived amid forest, salt air and restless spirits."}, stakes = {"The temple's researchers and the forest's keepers still sought explanations for the sickness around them.", "The work ranged from keeping strange machines supplied to investigating wounds far older than the town."}},
    ["Stormwind City"] = {sight = {"Candles gathered from Elwynn's kobolds supplied Pestle's Apothecary in the Trade District.", "Reports from outlying towns reached a capital with demands on every side."}, stakes = {"The kingdom's distant settlements needed more than promises of help.", "Small deliveries connected the capital's daily life with its troubled countryside."}},
    ["Ironforge"] = {sight = {"The Assembly of Explorers received reports from digs far outside the city's halls.", "The Great Forge shared the mountain city with workshops and the Explorers' League."}, stakes = {"Questions about missing powder could follow an expedition all the way back to its sponsors.", "The city's reach depended on supplied expeditions and defended roads."}},
    ["Darnassus"] = {sight = {"The druid grove and the Temple of the Moon held different responsibilities within the city.", "Water carried from Teldrassil's moonwells reached the capital's sacred places."}, stakes = {"The new World Tree's flaws remained a concern for the city's leaders.", "Fandral's work as Arch Druid sat alongside Tyrande's responsibility for the kaldorei people."}},
}
P.zones["Stormwind City"].source = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #60 Kobold Candles; #61 Shipment to Stormwind; #783 A Threat Within"}
-- Exact Solarsal stages: discovery, report, and scales stay distinct.
-- Against the Hatecrest also names referral3130; do not promote2869 to title fallback.
P.threads.alliance_solarsal = "the Hatecrest presence at Solarsal"
q(2866, "The Ruins of Solarsal", "Feralas", 43, "alliance_solarsal",
    "Shandris Feathermoon wanted the ancient Solarsal ruins searched after Hatecrest naga occupied them in alarming numbers.",
    "The Hatecrest gathering at Solarsal troubled Shandris, who suspected more than preparations for an attack.",
    "A gazebo stood newer than the surrounding ruins, its stone warm beneath a pattern of unfamiliar glyphs.",
    "The gazebo's repeating glyphs gave no clear meaning, but its warm stone and recent construction set it apart.", 3)
q(2867, "Return to Feathermoon Stronghold", "Feralas", 43, "alliance_solarsal",
    "The unusual gazebo in Solarsal called for a report to General Shandris Feathermoon.",
    "Shandris needed news of the strange gazebo found among the naga-held ruins of Solarsal.",
    "The report disturbed Shandris, who saw the Hatecrest presence as a danger to the advance into Feralas.",
    "Shandris received the findings and sought more help against the naga, whose purpose remained uncertain.", 3)
q(2869, "Against the Hatecrest", "Feralas", 43, "alliance_solarsal",
    "Latronicus Moonspear wanted the Hatecrest weakened before they could claim Sardor Isle.",
    "Latronicus feared the naga would try to take Sardor Isle and wanted their scales as proof of a counterattack.",
    "Latronicus accepted the Hatecrest scales and considered sending them to Pratt to see what could be made from them.",
    "The recovered scales satisfied Latronicus, who valued the help given to Shandris and the stronghold.", 3)

-- Complete short scenes: exact recorded stages only; see editorial-20261016 author packet.
P.questIDs[18].highlight = {"The guards exchanged the Defias thieves' bandanas for a weapon, honoring their bargain for the fighting east of Northshire's river.", "Defias bandanas from across the river earned a weapon and the Stormwind Army's thanks at Northshire."}
P.questIDs[6].highlight = {"Garrick Padfoot's head settled the guards' bounty on the cutthroat who had preyed on Northshire's farms and merchants.", "The guards paid for Garrick Padfoot's head. The raider who had troubled Northshire's farmers and merchants was dead."}
P.questIDs[47].highlight = {"Remy Two Times paid for the kobolds' gold dust and added a token from his associates, hinting it might prove useful.", "The kobolds' gold dust earned Remy's payment, along with a small token from associates he left unnamed."}
P.questIDs[62].highlight = {"Scouting confirmed kobolds in Fargodeep Mine. Marshal Dughan took the bad news and called for stronger patrols.", "Fargodeep was full of kobolds. The report prompted Dughan to call for more patrols near the mine."}
P.questIDs[921].highlight = {"With moonwell water returned, Tenaron spoke of Hyjal's cost to Nordrassil and of Elune's wells, whose ancient waters came from the Well of Eternity.", "The moonwell errand carried Tenaron's lesson. Nordrassil's power had been spent at Hyjal, while Elune's shrines held the ancient magic of the Well of Eternity."}
P.questIDs[932].highlight = {"Tallonkai wanted the matter kept quiet, since the satyr Melenas and his grell were embarrassingly close to home. Melenas's death ended that concern.", "Tallonkai received proof of Melenas's death. The satyr gathering grell in nearby Fel Rock had been dealt with."}
P.questIDs[483].highlight = {"Four Relics of Wakening were recovered from Gnarlpine-held Ban'ethil, ready for the ritual meant to wake its trapped druids.", "The recovered Relics of Wakening made preparations possible for the sleeping druids in Ban'ethil, endangered by Gnarlpine invaders."}
P.questIDs[2438].highlight = {"The emerald dreamcatcher was recovered from Starbreeze. Tallonkai prized it as a rare gift from Ban'ethil's warden.", "The emerald dreamcatcher, a rare gift from Ban'ethil's warden, came back from corrupted Starbreeze to the owner who had hoped it was unharmed."}
P.questIDs[2866].highlight = {"Among naga-held Solarsal's ruins, the search found a newer gazebo with unfamiliar glyphs and warm stone.", "The Solarsal investigation found a gazebo newer than the ruins around it, with warm stone and repeating, unreadable glyphs."}
P.questIDs[2867].highlight = {"The gazebo report disturbed Shandris. Whatever the Hatecrest's purpose, she wanted further help against their presence in Feralas.", "Shandris found the news from Solarsal disturbing and asked for more help against the naga around the strange gazebo."}
P.questIDs[2869].highlight = {"Hatecrest scales proved the counterattack Latronicus wanted on Sardor Isle. He considered sending them to Pratt for crafting.", "Latronicus accepted scales from the Hatecrest as proof of the fighting on Sardor Isle, then wondered what Pratt could make of them."}
P.questIDs[255].highlight = {"With Ironforge's soldiers months away, Bluntnose welcomed help against Thelsamar's ogres. He hoped the town could soon turn its attention to the troggs.", "Thelsamar's ogres suffered losses while Ironforge's reinforcements were still months away. Bluntnose offered thanks, already thinking of the troggs."}
P.questIDs[267].highlight = {"With Ironforge's Reserve away, Rugelfuss needed help against Loch Modan's troggs. The returned teeth earned his thanks and the praise he imagined from King Magni.", "Trogg teeth reached Captain Rugelfuss, whose regiment could not leave the gate. He declared that such defense of dwarven lands would make King Magni proud."}
P.questIDs[263].highlight = {"The fight against Stonesplinter shamans and bonesnappers earned Wallbang's salute and a recommendation to speak with the captain.", "Wallbang praised the fighting against the Stonesplinter shamans and bonesnappers. He thought the captain might now offer a greater responsibility."}
P.questIDs[273].highlight = {"Huldar's powder shipment was found after a Dark Iron ambush. The betrayal of Saean, a colleague of nearly a year, had stunned him.", "The search reached Huldar and the powder shipment. He had weathered the Dark Iron ambush, but never expected Saean to side with the attackers."}
P.questIDs[298].highlight = {"Ironband's report brought another powder request to Jern, who wondered what had become of the shipment he had sent weeks earlier.", "Jern received Ironband's report and request for blastpowder. A generous shipment had already left Thelsamar weeks before, and he wanted to know where it had gone."}
P.questIDs[294].highlight = {"Raptors drawn to Whelgar's excavation had killed Ormer's fellow workers. The first hunt brought vengeance while duty kept him beside Merrin and the Prospector.", "The raptors west of the bluff suffered Ormer's first reprisal for his fallen coworkers. He said he would have joined the fighting if duty to Merrin and the Prospector allowed it."}
P.questIDs[295].highlight = {"The next hunt thinned the scytheclaws and razormaws below the bluff, earning Ormer's hearty praise.", "Ormer welcomed the losses among the scytheclaws and razormaws that crowded the excavation below his shelter."}
P.questIDs[296].highlight = {"Sarltooth's talon proved Ormer's final target dead. He hoped the vengeance for the fallen workers would deter attacks on King Magni's people.", "Ormer received Sarltooth's talon and remembered the dwarves killed at their work. He believed the vengeance would make the creatures fear another attack."}

-- Band 20-30 pass (2026-11-06, tests/Band2030.lua): Astranaar's arrivals and
-- defense, Relara's neighbours, Gaxim's war on the Venture Company, Kayneth
-- Stillwind's watch, the Howling Vale through Velinde's fate, the dryads of the
-- Shrine of Aessina and Gerrig's manuscript. Quest text by ID; NPCs and places
-- checked against Interface/AddOns/LoreForever/Data (facts only).
P.threads.alliance_astranaar = "the defense of Astranaar"
P.threads.alliance_gaxim = "Gaxim's campaign against the Venture Company"
P.threads.alliance_kayneth = "Kayneth Stillwind's watch over Ashenvale"
P.threads.alliance_aessina = "the dryads of the Shrine of Aessina"
P.threads.alliance_gerrig = "Gerrig Bonegrip's collection"
local AA, AG, AK, AD = "alliance_astranaar", "alliance_gaxim", "alliance_kayneth", "alliance_aessina"
q(990, "Trek to Ashenvale", "Ashenvale", 19, AA,
    "Sentinel Selarin's mistress, Raene Wolfrunner, was waiting in {p:Astranaar}. Corruption had taken hold in Ashenvale, and Selarin hoped that help from Darkshore might ease some of it.",
    "The road south from Auberdine led into Ashenvale and on to Astranaar. Raene Wolfrunner wanted every pair of hands Selarin could send her.",
    "Raene Wolfrunner welcomed the arrival from Darkshore and said Selarin had done well to send help so quickly. She wished the visit had come under less dire stress, and pointed to the citizens of Astranaar who needed aid.",
    "In Astranaar, Raene said the trip had been made under dire stress and that Selarin had chosen well. The other citizens of the town could use help, she said, and that was the place to start.")
q(1133, "Journey to Astranaar", "Ashenvale", 20, AA,
    "Fiora Longears in Theramore had advice for anyone fresh off the boat from Menethil. The first thing to do was go to {p:Astranaar} and offer services to Shindrell Swiftfire. It was better not to mention Fiora, since Shindrell did not know her.",
    "Astranaar was where an eager member of the Alliance could do real good, Fiora Longears said. She asked that nobody mention who had sent them.",
    "Shindrell Swiftfire welcomed the offer of service. Ashenvale kept its beauty, she said, but it was no longer the peaceful place it had been.",
    "In Astranaar, Shindrell accepted the help and spoke of a forest that was lovely still and peaceful no more.")
q(1134, "Pridewings of Stonetalon", "Stonetalon Mountains", 21, AA,
    "The Alliance and the Horde were not at open war, Shindrell said, but the peace was fragile. Hidden sources in Theramore claimed that orc assassins used venom from the pridewings near Mirkfallon Lake on their death raids. Shindrell meant to deny them their source.",
    "The claim from Theramore was that orcs milked the pridewings of Stonetalon for an assassin's poison. If it was true, Shindrell said, the orcs had to be stopped.",
    "Shindrell took the venom sacs with no joy. It saddened her to order the slaughter of creatures that might not willingly serve her enemies. It was her duty, she said, and her allies were safer for it.",
    "The pridewing venom reached Astranaar. Shindrell admitted the beasts might not have served the orcs willingly. A heart could weep for them, she said, and still be glad the Alliance was safe from their venom.")
q(945, "Therylune's Escape", "Darkshore", 18, AD,
    "Therylune had wandered into the {p:Master's Glaive} in Darkshore and been surrounded by cultists. She had hidden well, and now wanted a way out and word carried to her sister Therysil at the Shrine of Aessina in Ashenvale.",
    "Cultists ringed the Master's Glaive, and Therylune was hiding among them. Her sister waited far to the south at the Shrine of Aessina, knowing nothing of it.",
    "Therysil could hardly believe where her sister had got to. Therylune never minded getting dirty, she said, but the Master's Glaive was an unwholesome place and a long way to wander.",
    "At the Shrine of Aessina, Therysil learned that her sister was all right, and where she had been hiding. She thanked the bearer of the news.")
q(976, "Supplies to Auberdine", "Ashenvale", 24, "alliance_darkshore",
    "Delgren had given Feero Ironhand messages and supplies for Sentinel Starbreeze in Auberdine, and Feero would not take the road north alone. Dangerous foes worked in the forest, and he feared the goods and the information falling into the wrong hands.",
    "Feero Ironhand was ready to leave {p:Maestra's Post} the moment he had guards. The supplies he carried were meant to reinforce the Sentinels in Darkshore.",
    "Feero got through the forest with his escort. Delgren said the goods would be put to use at once against the dark threats there.",
    "The supplies for Auberdine were on their way with Feero. Delgren called it a good day's work and said the Sentinels would use the goods immediately.")
q(1016, "Elemental Bracers", "Ashenvale", 24, AA,
    "Sentinel Velene Starstrike at Silverwind Refuge wanted to know who had made the elementals fouling the pools. Her divining scroll needed something of theirs to focus on, and a few intact bracers would do.",
    "The corrupted elementals wore bracers, and most broke when the creatures died. Velene needed a few whole ones for a divining scroll that could name their maker.",
    "The divined paper should give Velene what she needed to find the culprit. A wizard was filling the pools with corrupt elementals on purpose, she said, and it sickened her. She wanted him to pay.",
    "Velene read the result of the divining scroll and spoke of a mage who was corrupting Ashenvale's waters deliberately. The next step, she said, was to take him out.")
q(1017, "Mage Summoner", "The Barrens", 25, AA,
    "Only one undead mage in the Barrens could defile so many water elementals, Velene said, and only one was foolish enough to try. Sarilus Foulborne was probably sitting atop Dreadmist Peak laughing at her, and she wanted his head.",
    "Velene had had enough of Sarilus Foulborne. The undead mage on Dreadmist Peak had been fouling the Sentinels' pools from inside Horde territory, where the Horde might be watching.",
    "Sarilus Foulborne's head came back across the border to Silverwind Refuge. Velene said she could see his repugnant smile wiped away forever, and gave the Light of Elune, a draught to drink when death was near.",
    "Velene received the head of the mage who had annoyed the Sentinels once too often. In thanks she gave the Light of Elune, to be drunk when all seemed lost.", 4)
q(1025, "An Aggressive Defense", "Ashenvale", 24, AA,
    "Before the trip to the moonwell, Raene Wolfrunner had another task. Furbolgs had been attacking travelers on the road east of Astranaar, short of the Falfarren River, and their camps lay south of the road.",
    "Raene described the furbolgs east of Astranaar as minds tortured and fed on fear. She asked that they be shown the same mercy they had shown her people.",
    "Raene said the work on the eastern road had been done well, and thanked the one who did it.",
    "The furbolg camps south of the Falfarren road were thinned. Raene's thanks were brief.")
q(1054, "Culling the Threat", "Ashenvale", 25, AA,
    "Directly north of Astranaar the Thistlefur furbolg had grown in number for months. Raene feared they would soon find the courage to attack the town. She wanted their chieftain's skull as proof that their efforts had been stifled.",
    "Raene's scouts counted more Thistlefur every month. Their chieftain, Dal Bloodclaw, had to die before the tribe grew bold enough to march on Astranaar.",
    "Dal Bloodclaw's skull reached Raene in Astranaar. The furbolg threat was constant, she said, and this would keep them at bay a while longer.",
    "Raene took the chieftain's skull and hoped for a little breathing room. Astranaar lived under constant threat from the furbolg.", 4)
q(1011, "Forsaken Diseases", "Ashenvale", 29, AK,
    "Kayneth Stillwind believed the Forsaken who lurked in Ashenvale's ruins and barrows had come to spread disease among the night elves. A bottle from their camp south of Forest Song, near the Dor'Danil Barrow Den, would prove it.",
    "The Forsaken had a camp near the Dor'Danil Barrow Den where they brewed poisons and bottled them. Kayneth wanted one bottle to test.",
    "Kayneth took the bottle of disease from the Forsaken camp. By testing its contents, he said, the Forsaken's goals in Ashenvale would be revealed.",
    "The stolen bottle reached Kayneth at Forest Song. He meant to find out what the Forsaken were brewing, and why.")
q(4581, "Kayneth Stillwind", "Ashenvale", 29, AK,
    "The druid Kayneth Stillwind had asked Shindrell for an account of the coast and the forests around Astranaar. He feared a corruption moving through Ashenvale, and Shindrell thought he might be right.",
    "Shindrell's report went east to the shrine of Forest Song in the Nightsong Woods, where Kayneth Stillwind watched the forest.",
    "Kayneth read Shindrell's report for clues of the wickedness he feared was moving through Ashenvale. He called her a fine sentinel, brave and keen.",
    "Shindrell's report reached Forest Song. Kayneth praised the sentinel who wrote it and turned to it for signs of corruption.")
q(1012, "Insane Druids", "Ashenvale", 32, AK,
    "Struggling with the Forsaken's poisons, Kayneth had seen a vision of the druids of the Dor'Danil Barrow Den. The undead had poisoned and murdered them and left them as maddened ghosts. For their spirits to find peace, their leaders Taneel Darkwood, Uthil Mooncall and Mavoris Cloudsbreak had to be destroyed.",
    "Kayneth's dreams were haunted by the anguish of the Dor'danil druids. The spirits of their three leaders, severed from their bodies and driven mad, had to be put down inside the barrow den.",
    "Kayneth felt the anguish of the Dor'danil barrows lessen and knew the work was done. It was grim work, he said, for the spirits destroyed had been victims of the Forsaken. He hoped the rest might now find peace.",
    "The three druid leaders were destroyed in the barrow den. Kayneth called it grim, and hoped the other maddened spirits would find rest.", 4)
q(1022, "The Howling Vale", "Ashenvale", 30, VL,
    "Sentinel Melyria Frostshadow had kept most of Felwood's demons out of Ashenvale, but something new had come. Wolf-men had overrun the ruined shrine of Mel'Thandris near the Felwood border. Their calls had earned the place the name of the Howling Vale.",
    "The Tome of Mel'Thandris, kept at the shrine in the Howling Vale, was no ordinary tome. Its leaves had been blessed by Mel'Thandris herself and showed events of import, and Melyria hoped it would explain the wolf-men.",
    "What the Tome of Mel'Thandris showed, no one truly understood, Melyria said. But it was clear that the Scythe of Elune, given to Priestess Starsong, needed looking into.",
    "The tome's vision pointed to a priestess named Starsong and a weapon called the Scythe of Elune. Melyria could not say why the tome showed what it did, only that the scythe bore investigation.", 4)
q(1037, "Velinde Starsong", "Darnassus", 30, VL,
    "Velinde Starsong had been Melyria's predecessor in Ashenvale. Her work against Felwood had faltered little by little, and one day she had simply disappeared. Thyn'tel Bladeweaver, a commander of the Sentinels, might know more.",
    "Melyria knew nothing of the priestess whose post she had inherited. She thought Thyn'tel Bladeweaver in {p:Darnassus} might know details of the disappearance that Melyria had never been told.",
    "Thyn'tel Bladeweaver allowed that Velinde's disappearance was common knowledge. Anything further, she said, would take good reason to divulge.",
    "In Darnassus, Thyn'tel confirmed that the priestess had vanished some time ago and said no more. The details would need a reason.")
q(1040, "Passage to Booty Bay", "Stranglethorn Vale", 30, VL,
    "Wharfmaster Dizzywig found the entry at last. Velinde had booked passage to {p:Booty Bay} on the Black Osprey and asked about overland travel on the far side of the world. He had mentioned Ruzzgot, a caravan driver based in that port.",
    "Dizzywig's ledgers put Velinde on the Black Osprey to Booty Bay, with nothing to say the ship had failed to arrive. The next name was Ruzzgot, a goblin caravaneer there.",
    "Caravaneer Ruzzgot sized up his visitor as someone without goods to ship. Either it was a job seeker, and there were no jobs, or the wrong goblin was being asked.",
    "In Booty Bay, Ruzzgot saw no cargo to ship. He offered two choices, a job he did not have or the wrong goblin, and asked which it was.")
q(1041, "The Caravan Road", "Duskwood", 30, VL,
    "Ruzzgot admitted he had been wrong about his visitor, and that did not happen every day. He remembered Velinde, a night elf priestess who had traveled with his caravan. They had parted on the way north, he said, when she turned for {p:Darkshire}.",
    "A night elf priestess on a dirty old caravan was not a passenger Ruzzgot forgot. She had left him on the road north, bound for Darkshire, where the clerk kept notes on everything.",
    "Clerk Daltry kept note of every stranger who passed through Darkshire, he said, with all the strange happenings of recent years. It was seldom pleasant business when those notes were needed, though he suggested nothing about Velinde by it.",
    "In Darkshire, Clerk Daltry said he wrote down what he could about strangers these days. He had not meant to imply anything about the priestess.")
q(1042, "The Carevin Family", "Duskwood", 30, VL,
    "Daltry had nothing on a Velinde Starsong taking a room in Darkshire, and could hardly picture a night elf priestess at the inn. The wolf-men were another matter. Calor had come into town with a string of their heads. He worked for the Carevin family, hunters of demons, undead and other monstrosities.",
    "The clerk's notes held no Velinde, but the mention of wolf-men caught him. The Carevins hunted such things, and Jonathan Carevin headed the household.",
    "Jonathan Carevin did not apologize for his suspicion. A stranger had walked into his home in dark times asking about worgen, and he meant to have answers.",
    "In the Carevin house, Jonathan heard the question about worgen with open suspicion. Evil lay under every rock these days, he said, and he would have answers before he gave any.")
q(1043, "The Scythe of Elune", "Duskwood", 30, VL,
    "Jonathan Carevin did not understand the motives behind the search, but if it meant fewer worgen in Duskwood he could forgo understanding for results. The beasts had first appeared at a mine to the south, Roland's Doom, and it was overrun with them still.",
    "The worgen had come out of nowhere, as far as Darkshire knew, and the mine south of town was where they were first seen. Jonathan asked that anything of import found there be shared with him.",
    "Jonathan found the account from the mine interesting. The Carevin family could not reach the root of the trouble, he said. It would do what it could to contain the worgen in Duskwood. Calor would make that his first priority.",
    "What came out of Roland's Doom was an interesting account, Jonathan said. His family could not finish the matter, only hold the worgen's numbers down, and he set Calor to it.", 4)
q(1044, "Answered Questions", "Darnassus", 30, VL,
    "Jonathan Carevin promised the worgen would be reined in. He bore Velinde no ill will for the evil she had brought into his woods. Others ought to hear, he said, what the mines of Duskwood had revealed.",
    "What had been found in Roland's Doom belonged in {p:Darnassus}. Jonathan kept the stranger no longer.",
    "So that was Velinde's fate, Thyn'tel said. The high priestess would be disappointed, for the two had been friends. It unsettled Thyn'tel that the Scythe of Elune, surely a boon from the goddess, had fallen out of her servants' hands.",
    "Thyn'tel Bladeweaver heard how the search for Velinde had ended. She owed thanks for it, she said, and worried where the Scythe of Elune had gone. That was a matter for another time.", 5)
q(1021, "Vile Satyr! Dryads in Danger!", "Ashenvale", 32, AD,
    "Illiyana's sisters had gone to take back the Branch of Cenarius from the satyrs and had been gone two whole days. They had been looking for the ruins of a night elf temple in Xavian, to the northeast, with Anilia leading them.",
    "At the Shrine of Aessina, Illiyana did not know what to think. Anilia had led the search for the stolen Branch of Cenarius into Xavian and had not come back.",
    "Anilia was found in Xavian with a gaping wound in her side, on the verge of death.",
    "The search found Anilia among the ruins of Xavian, dying of a wound in her side.")
q(1031, "The Branch of Cenarius", "Ashenvale", 32, AD,
    "Anilia drew her rescuer close, pointed to the arch to the north and breathed a name, Geltharis, before she died. Her last wish was plain enough. The Branch of Cenarius had to go back to dryad hands.",
    "With her last breath Anilia named Geltharis as the thief of the Branch of Cenarius and pointed north. There was nothing to do for her but finish what she had started.",
    "Illiyana could not believe Anilia was gone. Only yesterday they had been running and playing in the woods, she said, and those days were over now.",
    "The Branch of Cenarius came back to Illiyana along with the news of Anilia's death. She spoke of the days they had played together in the forest, and said those days were done.", 5)
q(1032, "Satyr Slaying!", "Ashenvale", 32, AD,
    "Illiyana said she almost felt sad, and knew one thing that might help. The satyrs that had taken Anilia from her could die, and their horns would prove it.",
    "Illiyana wanted Anilia avenged on the satyrs of Xavian, with their horns as proof.",
    "Illiyana took the satyr horns and said her sister's spirit was gladdened.",
    "The horns of Anilia's killers reached the Shrine of Aessina. Illiyana believed her sister's spirit was gladdened by it.")
q(971, "Knowledge in the Deeps", "Blackfathom Deeps", 23, "alliance_gerrig",
    "Gerrig Bonegrip in Ironforge collected old lore, the kind that opened doorways and could wake Those Who Sleep. He had heard of the Lorgalis Manuscript at the bottom of {p:Blackfathom Deeps}, the old dwelling of long-dead elves, and wanted it.",
    "The Lorgalis Manuscript was said to lie deep in Blackfathom Deeps in Ashenvale. Elves of great knowledge had lived there before their city fell. Gerrig Bonegrip promised not to forget whoever brought it to him, not even after the end days.",
    "Gerrig called it a joyous day. Copies of the Lorgalis Manuscript would be made and spread among his brothers and sisters, and he said the service was greater than its bearer knew.",
    "The manuscript from Blackfathom reached Gerrig Bonegrip in Ironforge. He spoke of brothers and sisters who would read it, and offered a gift as the gratitude his kind extended to their allies.", 4)
-- Gaxim's campaign: the NG-5, the scroll, the two covert operations and the reports home.
q(1072, "An Old Colleague", IF, 21, AG,
    "Gaxim's most advanced device needed a special charge, Nitromirglyceronium, and only one person could make it. His old friend Lomac Gearstrip was in {p:Tinker Town}, in Ironforge.",
    "Gaxim admitted the mission might be a last one, so he wanted the good stuff. NG-5 came from Lomac Gearstrip in Tinker Town, and someone had to talk him into making it.",
    "Lomac Gearstrip wanted to know why he should believe that Gaxim had sent anyone. He asked twice.",
    "In Tinker Town, Lomac greeted Gaxim's name with suspicion and demanded proof that the request was not a lie.")
q(1073, "Ineptitude + Chemicals = Fun", IF, 21, AG,
    "Lomac laughed at the idea of using Nitromirglyceronium to save a forest, and would gladly supply it just to see someone explode. He was out of it, though, and wanted the right potions brought before he brewed more.",
    "NG-5 was Lomac's greatest creation, and he would not hand a sample to just anyone. The potions he needed for it would show whether the asker knew any alchemy.",
    "The potions satisfied Lomac. The stranger seemed to know something about alchemy, he said, and the world was not all swords and sorcery.",
    "Lomac said the potions would do nicely. He had what he needed to make the NG-5.")
q(1074, "Ineptitude + Chemicals = Fun", "Stonetalon Mountains", 21, AG,
    "Lomac handed over the NG-5 with a warning that it was volatile, and a greeting for Gaxim if the courier really was his friend.",
    "The Nitromirglyceronium was ready for the crossing back to Stonetalon. Lomac's parting words were to enjoy blowing oneself up if the friendship with Gaxim was a lie.",
    "Gaxim took the NG-5 and explained its purpose. It would ignite wagons of dynamite, he said, and make the perfect distraction.",
    "The volatile charge reached Gaxim in {p:Stonetalon Mountains}. He called it the one ingredient that could set off whole wagons of dynamite, and promised the distraction would be worth seeing.")
q(1075, "A Scroll from Mauren", SW, 21, AG,
    "Gaxim's next piece was remote detonation. With a little magic the NG-5 could go off at the push of a button. The spell had to come from Collin Mauren in Stormwind's {p:Mage Quarter}.",
    "A device that set off explosives from a distance needed a mage's help. Gaxim named Collin Mauren, a human in the Mage Quarter of Stormwind.",
    "Collin Mauren turned the request over. A spell to detonate explosives from a distance would take some thought.",
    "In the Mage Quarter, Mauren heard what Gaxim needed and began considering how such a spell might work.")
q(1077, "Special Delivery for Gaxim", "Stonetalon Mountains", 21, AG,
    "Collin Mauren had his spell ready and sent his regards to Gaxim with it. He wanted to hear how the adventure ended.",
    "The scroll from Stormwind was the last part of Gaxim's remote explosive. Mauren asked only to be told how it went.",
    "Gaxim called Mauren's spell perfect. Mixed with the NG-5 it made a remote explosive. The distraction it caused would cover a theft of the Venture Company's letters and engineering plans.",
    "With the spell in hand, Gaxim had his remote explosive. The plan was now a distraction and a burglary, aimed at the Venture Company's plans and letters to slow its deforestation.")
q(1079, "Covert Ops - Alpha", "Stonetalon Mountains", 22, AG,
    "Gaxim's devices were done. Plan Alpha was not about the size of the blast, he said. It was about coming back with the Venture Company's engineering plans from the lumber mill south of Cragpool Lake.",
    "Gaxim's notes explained where to place the detonators and the NG-5. The target was the lumber mill below Cragpool Lake and the plans kept inside it.",
    "The engineering plans came out of the lumber mill. Gaxim called it a huge blow to the Venture Company, whose machines could now be studied for weaknesses and copied.",
    "Gaxim had the Venture Company's plans in hand and called it a wonderful day. Their designs would show him their weaknesses and feed his own inventions.", 4)
q(1080, "Covert Ops - Beta", "Stonetalon Mountains", 22, AG,
    "Plan Beta ran like Plan Alpha, a distraction and a theft, except that the prize this time was the Venture Company's letters. Gaxim wanted them, and the thief back alive.",
    "Gaxim's notes said where the explosives should go. Beyond the distraction, only the letters mattered.",
    "The letters reached Gaxim, who said Kaela and the Sentinels would be delighted. With his creations and a willing agent, he felt unstoppable.",
    "Gaxim was thrilled by the stolen letters and declared the partnership unstoppable. Kaela and the Sentinels would hear of it next.", 4)
q(1091, "Kaela's Update", "Stonetalon Mountains", 22, AG,
    "Gaxim sent the stolen letters on to Kaela. The instructions were to say how well it had gone, and that it could not have been done without a little magic.",
    "The letters stolen from the Venture Company were bound for Kaela, with the credit for Gaxim's magic to be mentioned.",
    "Kaela found the letters interesting indeed, and said the work with Gaxim had been done very well.",
    "The letters reached Kaela Shadowspear. She called their contents interesting and praised the work done beside Gaxim.")
q(1082, "Update for Sentinel Thenysil", "Ashenvale", 22, AG,
    "Kaela sent word back to {p:Astranaar} that she and Gaxim were alive and well on their way to stopping the Venture Company. Tara Thenysil would want to hear it.",
    "There was good news at last for Tara in Astranaar. Her friend Kaela was alive, the gnome too, and the work in Stonetalon was going forward.",
    "Tara thanked the messenger for the service to the Sentinels. She was glad to hear Kaela was well, and even Gaxim.",
    "The news reached Tara Thenysil in Astranaar. Kaela was safe, and Tara allowed that she was glad about Gaxim too.")
q(1081, "Reception from Tyrande", "Darnassus", 28, AG,
    "Tara Thenysil believed Tyrande Whisperwind herself would want to give thanks. What had begun in Stonetalon might strengthen the night elves' foothold there, and the {p:Temple of the Moon} in Darnassus waited.",
    "The work in Stonetalon had earned an audience with the High Priestess. Tara sent the Sentinels' ally to the Temple of the Moon.",
    "Tyrande had heard the name before. She was pleased with the path chosen by one still full of youth, she said, and gave a gift in appreciation.",
    "In the Temple of the Moon, Tyrande Whisperwind said the name was already known to her, and offered a gift for the work in Stonetalon.", 5)
q(1083, "Enraged Spirits", "Stonetalon Mountains", 26, AG,
    "Kaela did not know what the Venture Company had done in the {p:Charred Vale}, only that the creatures there had overpowered them. In setting the forest aflame the goblins had freed burning spirits of flame, stone and rage. The land had no chance while they roamed.",
    "The first time Kaela saw the Charred Vale she had almost wept. She asked for the smoldering embers of its fire spirits as proof that their numbers were falling.",
    "The embers of the vale's fire spirits reached Kaela. She called them the remains of the enemy, and said the strength that won them served her people well.",
    "Kaela took the smoldering embers. Fewer enraged spirits walked the Charred Vale, and she thanked the strength that had thinned them.")
q(1084, "Wounded Ancients", "Stonetalon Mountains", 28, AG,
    "The treants had surely helped drive the Venture Company out of the Charred Vale, Kaela thought, and now even those guardians had turned. Gaxim suspected the goblins' weapons, and wanted shrapnel from a wounded treant to study.",
    "Something had corrupted the protectors of the vale. Gaxim's theory pointed at the weapons the goblins used in their retreat, and the proof would be the shrapnel still lodged in the treants.",
    "Kaela took the shrapnel for Gaxim. It would be more than enough, she said, for the gnome to work out how the treants were corrupted.",
    "The shrapnel from the wounded treants went to Kaela, who meant to give it to Gaxim right away.")
q(1078, "Retrieval for Mauren", SW, 26, AG,
    "Travelers kept asking Collin Mauren about the Stonetalon Mountains. He had a request of his own. Basilisks had once lived in the Charred Vale whose scales, ground to dust, made a fine reagent for his spells.",
    "Collin Mauren wanted a few basilisk scales from the Charred Vale, if the creatures still lived there. There was no rush, he said, and he paid well.",
    "Mauren called the scales perfect and thanked their bearer greatly. One day, he hoped, he might return the help.",
    "The basilisk scales reached Collin Mauren in the Mage Quarter. He paid, and promised to remember the favor.")
P.questIDs[1035].highlight = {"The Shadethicket Oracle's moonstone reached Pelturas in time, he said, with Relara down to her last breaths. He gave the thing he held dearest after his daughter.", "Pelturas took the fallen moonstone and called his daughter saved. In thanks he gave what he treasured most after Relara."}
P.questIDs[1009].highlight = {"Ruuzel died on the isle at Zoram's northern edge. The Ring of Zoram, the key to the statuette's lock, went to Talen, who paid for it and swore never to forget.", "Talen paid for the Ring of Zoram taken from Ruuzel. He had the key to his statuette at last."}
P.questIDs[1017].highlight = {"Sarilus Foulborne's head came down from Dreadmist Peak to Velene Starstrike, who gave the Light of Elune in return.", "Velene received the head of the mage who had fouled her pools, and gave the Light of Elune, a draught for when death was near."}
P.questIDs[1054].highlight = {"Dal Bloodclaw's skull reached Raene in Astranaar. She hoped it would keep the Thistlefur at bay a while longer.", "Raene took the Thistlefur chieftain's skull and hoped for a little breathing room for Astranaar."}
P.questIDs[1012].highlight = {"The maddened spirits of Taneel Darkwood, Uthil Mooncall and Mavoris Cloudsbreak were destroyed in the barrow den. Kayneth called it grim work done to victims, and hoped the rest found peace.", "Kayneth felt the anguish of the Dor'danil barrows lessen. The three druid leaders were gone, and he hoped the other spirits could rest."}
P.questIDs[1044].highlight = {"The search for Velinde Starsong ended before Thyn'tel in Darnassus. The high priestess would be disappointed, she said, and the Scythe of Elune was out of the goddess's servants' hands.", "Thyn'tel heard Velinde's fate and gave her thanks. The Scythe of Elune troubled her, a matter for another time."}
P.questIDs[1031].highlight = {"The Branch of Cenarius came back to Illiyana with the news that Anilia was dead. Only yesterday they had played in the woods, she said.", "Illiyana had the Branch of Cenarius back, and her sister Anilia was dead. Those days of playing in the forest were over, she said."}
P.questIDs[1079].highlight = {"The Venture Company's engineering plans came out of the lumber mill south of Cragpool Lake. Gaxim called it a huge blow to the company.", "Gaxim had the Venture Company's plans from the lumber mill and called it a wonderful day."}
P.questIDs[1080].highlight = {"The Venture Company's letters, the prize of Plan Beta, reached Gaxim. Kaela and the Sentinels would be delighted, he said.", "With the stolen letters in hand, Gaxim said that together they were unstoppable."}
P.questIDs[1081].highlight = {"Tyrande Whisperwind received the Sentinels' ally in the Temple of the Moon. The name was known to her, she said, and she gave a gift for the work in Stonetalon.", "In the Temple of the Moon, Tyrande gave a gift of appreciation for what had begun in Stonetalon."}
P.questIDs[971].highlight = {"The Lorgalis Manuscript came up from Blackfathom Deeps to Gerrig Bonegrip in Ironforge, who promised copies for his brothers and sisters.", "Gerrig Bonegrip called the day joyous. The Lorgalis Manuscript would be copied and spread."}
P.threads.alliance_boran = "the Blind Princess's lost cargo"
P.threads.alliance_theramore = "Fiora Longears's work from Theramore"
P.threads.alliance_kraul = "the dead of Razorfen Kraul"
q(34, "An Unwelcome Guest", R, 24, K,
    "Martie Jainrose's garden in {p:Lakeshire} had been trampled again, and she knew the brute. Marshal Marris called the boar Bellygrub. Her daffodils were ruined until next season, and she offered a reward for his tusk. He foraged in the field southwest of town.",
    "A boar named Bellygrub had pillaged Martie Jainrose's garden once too often. She wanted to see his tusk.",
    "Martie called the menace laid to rest. Her garden would be in full bloom that season, she said.",
    "Bellygrub's tusk reached Martie Jainrose, who looked forward to a garden in bloom.")
q(281, "Reclaiming Goods", "Wetlands", 25, "alliance_boran",
    "Murlocs had raided the merchant vessel Blind Princess off Menethil. The ship got away, but much of its cargo went overboard with the creatures, among it a valuable statuette of Terenas Menethil. Karl Boran wanted it back from the coastal hovels.",
    "Karl Boran sent a search through the murloc hovels on the coast for the Blind Princess's lost cargo, and above all for the Menethil Statuette.",
    "The first crate was clawed and water-stained. Under the rotted straw lay an armload of red bottles, and no statuette.",
    "A scratched crate among the hovels held soggy straw and red-colored bottles. The statuette was elsewhere.")
q(284, "The Search Continues", "Wetlands", 25, "alliance_boran",
    "The cluster of hovels held no trace of the Menethil Statuette. Two more lay to the north and northeast.",
    "The search for the Blind Princess's statuette went on to the next murloc hovels up the coast.",
    "An untouched barrel gave up a pungent smell of cheese, a little wet and still tasty.",
    "The next barrel held cheese, wet but good, and nothing of Terenas Menethil.")
q(285, "Search More Hovels", "Wetlands", 25, "alliance_boran",
    "A thorough inspection of another group of hovels turned up nothing. One of the hovels to the north had to have the statuette.",
    "Each empty hovel made the next one likelier. The search pushed north along the murloc coast.",
    "A barrel lay half buried in the mud and grass of the last hovel.",
    "The search ended at a barrel sunk halfway into the muck.")
q(286, "Return the Statuette", "Wetlands", 25, "alliance_boran",
    "The barrel pulled from the muck held a silvery figurine packed in fine straw, a young, long-haired paladin with hammer upraised. It had to be the Menethil Statuette, and Karl Boran in {p:Menethil Harbor} was waiting for it.",
    "The Menethil Statuette came out of a murloc hovel's barrel, straw and all, bound for Karl Boran.",
    "Karl Boran said the captain of the Blind Princess would be relieved to have his precious cargo back. Dependable folk were good to see in trying times, he said, and he paid for services rendered.",
    "The statuette of Terenas Menethil reached Karl Boran in Menethil. The Blind Princess's captain would hear of it, and the finder was paid.", 4)
q(1132, "Fiora Longears", "Dustwallow Marsh", 20, "alliance_theramore",
    "Red Jack Flint in Menethil Harbor longed for the sea and saw it in other people's futures. His job was to tell eager souls of Kalimdor, the land of opportunity. He sent them by ship to {p:Theramore} to his partner, the elf Fiora Longears.",
    "A ship from Menethil went to the port of Theramore, where Fiora Longears started newcomers on their Kalimdor adventure, Red Jack Flint said.",
    "Fiora Longears welcomed anyone Mr. Flint sent. He was a strong judge of character, she said, and if he had sent them, they belonged in Kalimdor.",
    "In Theramore, Fiora Longears took Mr. Flint's word as proof enough that the newcomer belonged in Kalimdor.")
q(1135, "Highperch Venom", "Thousand Needles", 30, "alliance_theramore",
    "Wyvern venom, Fiora said, was worth more in some circles than the wyvern. The Highperch wyverns of Thousand Needles, west of Theramore, carried a potent kind, and she had a job for anyone unafraid of hunting them.",
    "Fiora Longears wanted venom sacs from the wyverns of {p:Highperch}, potent and valuable.",
    "Most of the sacs were nearly bursting with venom, Fiora said, the kind normally taken only from young wyverns or fertile females. It must have been quite a slaughter up at Highperch.",
    "Fiora took the venom sacs from Highperch and remarked on their fullness, and on what that said about the hunt.")
q(1142, "Mortality Wanes", "Razorfen Kraul", 30, "alliance_kraul",
    "Heralath Fallowbrook lay dying in {p:Razorfen Kraul}. The brave dwarf Lonebrow had been sent to warn Falfindel, he managed to say. One of the quilboar had stolen the pendant that bound him to his wife Treshala. He asked that it be found and taken to her in Darnassus, with word of his lonely death.",
    "A dying night elf in the Kraul had one request. His wife Treshala's pendant of bonding, stolen by the quilboar, was to go home to her in Darnassus along with the news.",
    "Treshala cried out against a cruel and intolerable world. She would carry the grief, she said, and not let Heralath's work die with him, and then she asked to be left alone to mourn.",
    "The pendant of bonding and the news of Heralath's death reached Treshala in Darnassus. She asked for solitude and spoke of carrying his work on.", 5)
-- Gnomeregan: Techbot, the green glow, Castpipe's data, Kernobee and the Sparklematic.
q(2923, "Tinkmaster Overspark", IF, 26, G,
    "Brother Sarno in Stormwind remembered Techbot as a kind and helpful tool for the gnomes, and had heard from Tinkmaster Overspark that it had malfunctioned. Overspark was in {p:Tinker Town} in Ironforge and would welcome help.",
    "Word of Techbot's breakdown had reached Stormwind. Brother Sarno sent help to its maker, Tinkmaster Overspark in Tinker Town.",
    "It was true, Overspark said. Techbot had gone rogue, and he asked for help.",
    "In Tinker Town, Overspark confirmed the worst about Techbot and accepted the offer of help.")
q(2922, "Save Techbot's Brain!", "Gnomeregan", 26, G,
    "When Gnomeregan fell, a rogue spark had jolted Tinkmaster Overspark's creation, Techbot, and polarized its positronic brain. Now it was negatronic, its behavior reversed, and it roamed {p:Gnomeregan} in a frenzy. Overspark wanted its memory core to find the cause.",
    "Techbot had once aided Overspark and his associates with countless gizmos and a limitless store of information. Its memory core, salvaged from the ruined city, might let the Tinkmaster fix it.",
    "Overspark called it wonderful and got to work at once, with a word of comfort for poor Techbot. Then he went looking for the plug for his hydro-jack swivel spanner.",
    "Techbot's memory core reached Tinkmaster Overspark, who promised the machine it would be fixed and began hunting for a spanner plug.")
q(2927, "The Day After", "Dun Morogh", 27, G,
    "Gnoarn had not always been bald. The radiation leak in Gnomeregan had taken the only gnomefro in Azeroth, and he shook his fist at the troggs. It might not be too late to save the city, he said. Ozzie Togglevolt in {p:Kharanos} and his partner Razzle were working on it.",
    "Gnoarn blamed the troggs for the loss of his hair and damned them all. He sent help to Ozzie Togglevolt in Kharanos, who was working on a solution for Gnomeregan.",
    "Ozzie had stood beside Gnoarn when the radiation bolt hit him and watched those brown locks hit the floor in clumps. Gnoarn had touched his bald head in disbelief, Ozzie said, and the look in his eyes had screamed revenge against the troggs.",
    "Ozzie remembered the day Gnoarn lost his hair, clumps and clusters of it, and the moment his anger turned on the troggs. He had not thought Gnoarn would survive the loss.")
q(2926, "Gnogaine", "Gnomeregan", 27, G,
    "Since the accident, Gnoarn talked of nothing but cleansing Gnomeregan of troggs and curing the sickness, Ozzie Togglevolt said. Ozzie and Razzle were close to a cure, or to a very powerful rum. To test it they needed a phial of green glow from the irradiated troggs.",
    "Ozzie Togglevolt in Kharanos needed fallout from Gnomeregan's irradiated troggs for a formula. Whether it cured gnomes or got them drunk, he could not yet say.",
    "Ozzie called it excellent work and prepared to test the formula. If it worked, he said, the captured leper gnome would be cured and he would have a full head of hair. Then he told everyone to stand back.",
    "The phial of green glow reached Ozzie in Kharanos. He meant to test the formula on a captured leper gnome, and hoped for a full head of hair himself.")
q(2962, "The Only Cure is More Green Glow", "Gnomeregan", 30, G,
    "The first sample had been too small and impure, Ozzie said. The troggs were not irradiated enough. He wanted green glow straight from the tap, from the irradiated slimes, lurkers and horrors of Gnomeregan. It might take several tries with the phial, he warned.",
    "Ozzie's cure needed purer fallout than troggs could give. The slimes, lurkers and horrors in the city's depths were the source, and containing it was difficult.",
    "Ozzie looked the bearer over and was impressed that all the limbs were still attached. Now, he said, it was time to see what this stuff could do.",
    "The purer green glow reached Ozzie in Kharanos. He checked for missing limbs, found none, and turned to his test.")
q(2931, "Castpipe's Task", IF, 28, G,
    "Master Mechanic Castpipe was organizing bands to re-enter Gnomeregan on a data retrieval mission of top importance. He was no member of the Enlightened Assembly of Arcanology, Alchemy and Engineering Sciences, but he was a smart gnome. The odds that it mattered were put at eighty-four percent.",
    "Castpipe needed adventurers for Gnomeregan. The errand came with a calculation, an eighty-four percent probability that the mission really was important.",
    "Castpipe was organizing data extraction missions into Gnomeregan, and told anyone there for that to listen up.",
    "In Ironforge, Master Mechanic Castpipe took on another volunteer for the data extraction and began his briefing.")
q(2930, "Data Rescue", "Gnomeregan", 30, G,
    "The gnomes had left vitally important data behind in Gnomeregan, Castpipe said. It sat on a prismatic punch card in a Matrix Punchograph 3005-D high security terminal, deep in the city. Reaching it meant clearance from the lower terminals, models A, B and C. Those needed punch cards the gnomes had also left behind, starting with white.",
    "Castpipe's data rescue began with a white punch card and climbed terminal by terminal to the 3005-D and its prismatic card.",
    "The prismatic punch card was found and the lost data recovered. Castpipe called it vitally, critically, immeasurably important, data the gnomes could not have lived another moment without. The service would be long remembered.",
    "The prismatic punch card reached Master Mechanic Castpipe, who declared the data recovered and the service to the gnomes unforgettable.", 4)
q(2925, "Klockmort's Essentials", IF, 30, G,
    "Mathiel in Darnassus had word from his gnome friend Klockmort Spannerspan in Ironforge. Klockmort needed help on a dangerous mission into Gnomeregan, the once great city now contaminated and full of mad gnomes and their devices. Mathiel could not leave his post.",
    "Mathiel's heart ached to help his friend Klockmort, and he asked someone to go in his stead to Tinkertown in Ironforge.",
    "Klockmort did need help with a mission into Gnomeregan, and declared the newcomer just the one to do it.",
    "In Tinkertown, Klockmort Spannerspan welcomed the help Mathiel had sent across the sea.")
q(2924, "Essential Artificials", "Gnomeregan", 30, G,
    "The essential artificial was a near-universal component, Klockmort Spannerspan said, and the tinkers and smiths of Gnomeregan had used it for everything. In the frantic exodus nobody had thought to take any. He needed a large supply from the artificial extrapolators deep in the city.",
    "Klockmort's new work needed essential artificials, and they were all still in Gnomeregan, in containers in its deeper halls.",
    "Klockmort had his essential artificials and could begin his experiments. The bravery had advanced gnomish research by a leap and a bound, he said.",
    "The artificials from Gnomeregan's extrapolators reached Klockmort Spannerspan in Ironforge, who could not thank the bearer enough.")
q(2928, "Gyrodrillmatic Excavationators", "Gnomeregan", 30, G,
    "Shoni the Shilent in Stormwind's Dwarven District did not have enough parts to get her fleet of gyrodrillmatic excavationators to Dun Morogh. Gnomeregan was full of bots and mechs roaming like cattle on an open range, she said. Two dozen of their robot guts would do.",
    "Shoni's excavationators needed spare parts, and Gnomeregan's robots had them. She wanted two dozen torn apart for their guts.",
    "The robot guts would do nicely, Shoni said. That made one gyrodrillmatic excavationator fixed, with three hundred and ninety-eight to go.",
    "Two dozen robots' worth of parts reached Shoni in the Dwarven District. It fixed one excavationator out of her fleet.")
q(2904, "A Fine Mess", "Gnomeregan", 30, G,
    "Kernobee came to among the troggs of Gnomeregan. The last thing he remembered was Dark Iron dwarves beating him within an inch of his life. He wanted to be led to the exit. Then Scooty in Booty Bay was to hear where he had gone. Kernobee meant to warn Tinkerwiz in Ratchet about the Dark Irons and the super rig.",
    "A battered gnome named Kernobee needed out of Gnomeregan. If he made it, Scooty in Booty Bay was to hear where he had gone and why.",
    "Scooty supposed a reward was in order for bringing Kernobee back in one piece. For anyone going back into Gnomeregan, he added something to give an edge against that backstabber Mekgineer Thermaplugg.",
    "Kernobee's message reached Scooty in Booty Bay. Scooty paid for the rescue and called Mekgineer Thermaplugg a good-for-nothing backstabber.", 4)
q(2951, "The Sparklematic 5200!", "Gnomeregan", 30, G,
    "Among the gnomes holding out against the madness in {p:Gnomeregan} stood a contraption with a plaque, the Sparklematic 5200. For a grime-encrusted item and three silver coins in the slot, it promised to put the shine back in shine-tastic.",
    "The Sparklematic 5200 wanted two things, something grimy to clean and three silver coins.",
    "The grime-encrusted item and three silver went in, and the Sparklematic 5200 surged to life. Loud, violent churning came from its heart and its frame creaked and lurched from side to side as it purged the grime.",
    "Three silver coins and a filthy object set the Sparklematic 5200 churning and groaning and lurching, hard at work on the grime.")
P.questIDs[2930].highlight = {"The prismatic punch card came out of Gnomeregan's 3005-D terminal. Castpipe called the data immeasurably important and the service unforgettable.", "Master Mechanic Castpipe had his lost data back from Gnomeregan on a prismatic punch card."}
P.questIDs[1142].highlight = {"Heralath Fallowbrook's pendant went home to his wife Treshala in Darnassus with word of his death in Razorfen Kraul. She asked to mourn alone.", "Treshala in Darnassus received her husband's pendant and the news of his death in the Kraul, and asked for solitude."}
P.questIDs[286].highlight = {"The Menethil Statuette, a silver paladin with hammer raised, came out of a murloc's barrel and back to Karl Boran in Menethil.", "Karl Boran had the Blind Princess's statuette back from the murloc hovels, and paid for dependable work."}

-- Compact outcomes remain attached to exact quest stages.
P.questIDs[463].highlight = {"The feared Greenwarden offered the name Rethiel. He said the roots and ferns spoke well of his visitor, and asked for help healing the land.", "Fitzsimmons's warning led to Rethiel in the marsh. He welcomed his visitor on the word of the roots and ferns, then asked that the land's wounds be healed."}
P.questIDs[276].highlight = {"The hunt reduced the Mosshides trampling the fen. Rethiel saw hope that his strained faith in his visitor's people might return.", "Fewer Mosshide gnolls and mongrels remained near Algaz. Rethiel praised the help for the Wetlands and cautiously hoped to trust the hunter's people again."}
P.questIDs[277].highlight = {"Rethiel received the Mosshides' fire-making flints. He meant to smash them and cast them into the sea to spare living wood.", "The captured flints reached Rethiel, who promised to break them and throw them into the sea, beyond further use against living trees."}
P.questIDs[275].highlight = {"The fen creepers were put down along the waterways. Rethiel judged the land soothed and granted a boon in thanks.", "Rethiel rewarded the hunt against the fevered fen creepers. He said the work had eased the land's suffering."}

-- Forever additions outside Zephras carry the Forever label in the compendium
-- (factcheck lane, 2026-11-05; explicit list, never inferred from the ID range).
for _, id in ipairs({98046, 98065, 98403}) do
    if P.questIDs[id] then P.questIDs[id].setting = "Forever" end
end
A.Lore.RegisterStoryPack("alliance-starters", P)

-- Independently reviewed intermediate Stalvan stages. Preserve the title fallback and existing66/98.
A.Lore.RegisterStoryPack("discovery-stalvan-stages", {
    ["sources"] = {"https://classicdb.ch/ (original quest text; exact pages listed per stage)"},
    ["questIDs"] = {
        [67] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Duskwood",
            ["level"] = 28,
            ["importance"] = 4,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Daltry's old registry placed Stalvan Mistmantle at Moonbrook Schoolhouse.", "The clerk wanted newer information about Stalvan's recorded address in Moonbrook."},
            ["after"] = {"The search at Moonbrook reached an old footlocker.", "An old footlocker opened at the end of the search for Stalvan's address."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 67", "https://classicdb.ch/?quest=67"}
        },
        [68] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Westfall",
            ["level"] = 28,
            ["importance"] = 2,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"An unsent letter lay inside the old footlocker.", "The search had uncovered a dusty letter for Daltry to examine."},
            ["after"] = {"Daltry accepted the letter as evidence that Stalvan had spent time in Moonbrook.", "The letter gave Daltry grounds to update Stalvan's entry in the town registry."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 68", "https://classicdb.ch/?quest=68"}
        },
        [69] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Duskwood",
            ["level"] = 28,
            ["importance"] = 2,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"A partly scratched-out address pointed Daltry toward the Lion's Pride Inn.", "The town registry supplied another lead in Goldshire."},
            ["after"] = {"At the Lion's Pride Inn, the name Stalvan sounded familiar to Farley.", "Farley recognized the name when the inquiry reached Goldshire's inn."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 69", "https://classicdb.ch/?quest=69"}
        },
        [70] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Elwynn Forest",
            ["level"] = 28,
            ["importance"] = 3,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Farley remembered a terrified messenger who had abandoned his correspondence during a storm.", "A letter from Stalvan remained upstairs at the inn, addressed to Stormwind's Canal District."},
            ["after"] = {"The undelivered letter reached Caretaker Folsom, who objected sharply to its arrival.", "Folsom received the old letter with an angry response."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 70", "https://classicdb.ch/?quest=70"}
        },
        [72] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Stormwind City",
            ["level"] = 28,
            ["importance"] = 4,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Folsom recalled a massacre at the estate and offered access to possessions being packed for auction.", "The Flintridge trust had run out of funds, and the remaining possessions might offer a clue."},
            ["after"] = {"The search reached a sealed crate, and its lid opened.", "Opening the crate gave the inquiry access to the packed possessions."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 72", "https://classicdb.ch/?quest=72"}
        },
        [74] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Stormwind City",
            ["level"] = 28,
            ["importance"] = 3,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"A torn journal page lay beneath a vase among the estate's old possessions.", "The crate held a journal fragment among a portrait, trophies and heirlooms."},
            ["after"] = {"Haggard found the handwriting familiar despite his failing sight.", "The page reminded Haggard of writing he had seen before his vision deteriorated."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 74", "https://classicdb.ch/?quest=74"}
        },
        [75] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Elwynn Forest",
            ["level"] = 28,
            ["importance"] = 2,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Haggard remembered a faded page among parchments in his upstairs chest.", "Poor sight prevented Haggard from examining the old papers easily, and he asked for help locating a page."},
            ["after"] = {"The faded page was found and brought to Haggard.", "Haggard received the page he had remembered in the upstairs chest."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 75", "https://classicdb.ch/?quest=75"}
        },
        [78] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Elwynn Forest",
            ["level"] = 28,
            ["importance"] = 3,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Haggard recommended Smitts at the Scarlet Raven Tavern for his knowledge of local history.", "The faded page needed examination by someone Haggard trusted to know the town's past."},
            ["after"] = {"Smitts recognized the handwriting on the page.", "At the Scarlet Raven Tavern, the writing proved familiar to Smitts."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 78", "https://classicdb.ch/?quest=78"}
        },
        [79] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Duskwood",
            ["level"] = 28,
            ["importance"] = 4,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Smitts believed the collected evidence connected Stalvan to the slaughter of visiting nobles.", "Muddy pages from an old investigation led Smitts to call for Commander Ebonlocke's attention."},
            ["after"] = {"Ebonlocke received the evidence and praised the investigation.", "The account reached Darkshire's commander, who commended the detective work."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 79", "https://classicdb.ch/?quest=79"}
        },
        [80] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Duskwood",
            ["level"] = 28,
            ["importance"] = 4,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Ebonlocke asked Daltry to compare the page's handwriting with the registry signatures.", "The commander sought an expert comparison before settling the question of authorship."},
            ["after"] = {"Daltry confirmed that the handwriting matched the registry signatures.", "The clerk's comparison established a match between the page and the town records."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 80", "https://classicdb.ch/?quest=80"}
        },
        [97] = {
            ["title"] = "The Legend of Stalvan",
            ["zone"] = "Duskwood",
            ["level"] = 28,
            ["importance"] = 3,
            ["thread"] = "alliance_stalvan",
            ["threadLabel"] = "the inquiry into Stalvan",
            ["why"] = {"Daltry's confirmation needed to reach Commander Ebonlocke.", "The handwriting comparison had supported the commander's suspicion, and Daltry urged an immediate report."},
            ["after"] = {"Ebonlocke received the confirmation and commended the work.", "The report of matching handwriting reached the commander."},
            ["noteSummary"] = "The Legend of Stalvan is an inquiry in Darkshire. The town hall's records offer a starting point for tracing a name.",
            ["noteSources"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 66 (public inquiry context)"},
            ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt: quest 97", "https://classicdb.ch/?quest=97"}
        }
    }
})
