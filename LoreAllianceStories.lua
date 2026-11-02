local _, A = ...
-- Curated Alliance beginnings and neighboring regions. This is context, not a
-- quest simulator: exact stage consequences are only selected by recorded ID.
-- Evidence: StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt.
-- That local corpus also includes the Forever additions explicitly cited below.
-- Coverage inventory: 196 exact quest IDs, 153 title contexts (21 conservative
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
    "McBride's welcome came with a warning: enemies pressed from outside the kingdom while trouble grew within its borders.", 4)
q(7, "Kobold Camp Cleanup", E, 2, N,
    "A clan of kobolds had made camp in the woods north of {p:Northshire Abbey}. McBride wanted their numbers cut back.",
    "Northshire's northern woods held a growing kobold camp, too close for the abbey's defenders to ignore.",
    "The hunt thinned the kobolds' ranks. McBride was grateful; even those small thieves could threaten Stormwind in numbers.",
    "Fewer kobolds remained in the northern woods. McBride was grateful for the help against a clan he hoped to drive out of Northshire.")
q(33, "Wolves Across the Border", E, 2, N,
    "The wolves of {p:Northshire} supplied meat as well as trouble.",
    "Tough wolf meat was worth a useful reward to a hungry cook near the abbey.",
    "There was wolf meat ready for the cooking fire.",
    "The hunt supplied the promised steaks, and the meat earned its reward.")
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
    "Willem's referral reached Milly; the trouble with her harvest still needed attending to.",
    "Milly had someone to explain her predicament to, but her grapes were still in danger.")
q(3904, "Milly's Harvest", E, 4, N,
    "Milly's picked grapes lay in the vineyards occupied by the Defias.",
    "The harvest risked theft from the brigands and trampling when the guards drove them out.",
    "Milly's harvest came back from the vineyards intact.",
    "The rescued grapes gave Milly something to keep from a harvest interrupted by brigands.", 4)
q(3905, "Grape Manifest", E, 4, N,
    "Brother Neals kept Northshire's food and drink stores from the abbey's bell tower.",
    "Milly's saved crop needed an entry in the abbey's supplies as well as safe passage from the vines.",
    "The manifest reached Brother Neals, bringing news of grapes saved for the abbey's wine.",
    "Northshire's stores could count on Milly's grapes again.")
q(47, "Gold Dust Exchange", E, 7, F,
    "Remy Two Times wanted the gold dust carried by Elwynn's kobolds. He promised the best price in Goldshire.",
    "The kobolds around Fargodeep and Jasperlode carried gold dust, and Remy Two Times was eager to buy it.",
    "Remy paid for the dust and added a small token from his associates, hinting that it might prove useful.",
    "Along with Remy's payment came a token from his associates, something he thought might come in handy.")
q(60, "Kobold Candles", E, 7, F,
    "A Stormwind apothecary needed wax from the large candles carried by Elwynn's kobolds.",
    "Candles from the occupied mines were useful supplies for the apothecary's work.",
    "The collected candles supplied the apothecary's request for wax.",
    "The candle gathering was paid for, linking work in Elwynn to a shop in Stormwind.")
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
    "The report confirmed kobolds at Jasperlode as well.",
    "Jasperlode's infestation was reported to the marshal, widening the known trouble in Elwynn.")
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
    "Marshal Dughan received the schedule as a lead; the Collector's employer remained unknown.",
    "The mysterious deliveries were reported in Goldshire, giving Dughan evidence to investigate.", 4)
q(176, 'WANTED: "Hogger"', E, 11, F,
    "{p:Hogger} had defeated earlier attempts to capture him in southwestern Elwynn.",
    "The Army's bounty named a huge gnoll who had become a persistent danger near Westbrook.",
    "Proof of Hogger's death reached Marshal Dughan, and the bounty was paid.",
    "The marshal's men were rid of Hogger, a threat they had struggled to bring down.", 5)
q(9, "The Killing Fields", W, 15, H,
    "Harvest Watchers occupied fields that Westfall's farmers still hoped to work.",
    "Even the machinery in the fields had become a danger to the farmers who stayed.",
    "The cleared Harvest Watchers earned a farmhand's pay, without putting all of Westfall right.",
    "The fields had fewer hostile machines, giving one stubborn farmer a little room to carry on.")
q(36, "Westfall Stew", W, 10, H,
    "Verna Furlbrow was preparing to leave a farm made unsafe by thieves.",
    "A broken wagon delayed the Furlbrows' departure, leaving time to pass on a stew recipe.",
    "Verna's recipe reached Salma Saldean, preserving a small connection between neighboring farms.",
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
    "The militia's scout confirmed the fighting; further service still lay ahead.")
q(13, "The People's Militia", W, 14, H,
    "Defias pillagers and looters were reported around the quarry, Moonbrook and Alexston Farmstead.",
    "The militia's next effort targeted the Defias plundering Westfall's settlements.",
    "The fighting against pillagers and looters proved useful to the People's Militia.",
    "The militia had help against the looters around its farms, though other Defias bands remained.")
q(14, "The People's Militia", W, 17, H,
    "Defias had withdrawn into the Dagger Hills after plundering southern Westfall.",
    "The militia's scouts traced another band of raiders into Westfall's southern hills.",
    "The completed service earned formal induction into the People's Militia.",
    "The militia recognized the work in southern Westfall with membership in its ranks.", 5)
q(20, "Blackrock Menace", R, 21, K,
    "Blackrock orcs held Stonewatch Keep and raided the country north of Lakeshire.",
    "Lakeshire's people were hemmed in by orcs who had come down from the Burning Steppes.",
    "Battleworn axes supplied proof of losses among the raiding orcs.",
    "Lakeshire had fewer Blackrock raiders to contend with, though Stonewatch remained a threat.")
q(92, "Redridge Goulash", R, 18, K,
    "Feeding a brigade of Stormwind troops had emptied a Lakeshire cupboard.",
    "Redridge goulash required condor meat, goretusk snouts and spider meat before another meal could be cooked.",
    "The ingredients replenished the cooking supplies and became a serving of goulash.",
    "An empty cupboard yielded a hot meal once the missing ingredients arrived.")
q(120, "Messenger to Stormwind", R, 14, K,
    "Magistrate Solomon needed Stormwind to hear how badly Lakeshire required reinforcements.",
    "A besieged town's request for soldiers had to reach General Marcus Jonathan.",
    "The general received Solomon's report and promised to seek royal approval for reinforcements.",
    "Stormwind heard Lakeshire's appeal; a decision from the king was still pending.")
q(121, "Messenger to Stormwind", R, 14, K,
    "The general had a letter for Solomon while Stormwind awaited the king's response.",
    "Lakeshire's magistrate was waiting for news from the general.",
    "Solomon received the correspondence, still troubled by the uncertainty surrounding reinforcements.",
    "The reply reached Lakeshire, but it did not settle Solomon's worries about the kingdom.")
q(56, "The Night Watch", D, 24, "alliance_duskwood",
    "Stormwind's withdrawn guards had left Darkshire's defense to the Night Watch.",
    "Skeletons in Tranquil Gardens threatened a town short of defenders.",
    "The skeletons slain at Tranquil Gardens earned the Watch's thanks.",
    "Darkshire received help against the undead south of town; the Watch's wider task remained.")
q(57, "The Night Watch", D, 26, "alliance_duskwood",
    "Reports of skeletal fiends and horrors kept the Night Watch occupied beyond Darkshire.",
    "The cemeteries around Darkshire and Raven Hill remained dangerous ground.",
    "The fighting against skeletal fiends and horrors strengthened the Watch's defense.",
    "The Watch thanked the help against the dead that kept gathering around Darkshire.")
q(58, "The Night Watch", D, 30, "alliance_duskwood",
    "Plague Spreaders occupied Raven Hill's eastern mausoleum while the Watch struggled to protect Darkshire.",
    "The Night Watch lacked enough people to guard the town and handle Raven Hill's mausoleum alone.",
    "The Plague Spreaders had been thinned, and the Watch commander acknowledged the help.",
    "Raven Hill's mausoleum had fewer Plague Spreaders, easing one part of the Watch's burden.", 4)

q(179, "Dwarven Outfitters", "Dun Morogh", 1, C,
    "Adlin offered warm gloves in exchange for wolf meat in {p:Coldridge Valley}.",
    "Keeping fingers safe from frostbite began with a practical bargain at Coldridge.",
    "Adlin received the meat and kept his promise of warm gloves.",
    "Wolf meat paid for a little protection against Dun Morogh's cold.")
q(183, "The Boar Hunter", "Dun Morogh", 3, C,
    "Boars had grown so numerous that even the local hunter's daily outing had become dangerous.",
    "Coldridge's angry boars needed thinning before ordinary hunting could resume.",
    "The reduced boar population let the hunter return to a less dangerous day's work.",
    "The boar hunt eased a familiar danger around Coldridge's camp.")
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
    "The hunt supplied fur and meat for the planned mission.",
    "Jetsteam's provisions were stocked while preparations for the journey continued.")
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
    "The scouting and fighting supplied the information needed to finish the report.",
    "The hold had been examined, giving the report something firmer than a glimpse from outside.")
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
    "Supplies had gone to Ironband's dig, but progress at the ancient ruins remained slow.",
    "Thelsamar needed an explanation from the excavation east of the loch.",
    "Magmar Fellhew identified troggs as the cause of the delay.",
    "The troubles at the dig explained why the expedition had fallen behind.")
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
    "James Halloran's cured skins left Menethil by boat for distant markets.",
    "The tanner was running short of the softer skins from young crocolisks outside town.",
    "Halloran received skins suitable for curing and paid for the work.",
    "The marsh supplied another batch for Menethil's trade in cured hides.")

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
    "The recovered dreamcatcher brought heartfelt thanks: its owner had been one of the few to receive such a gift.")
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
    "The delivery exposed the other purpose of Wizbang's machines: brewing and distilling liquor.")
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
    "The recovered armbands earned the guards' thanks for help against the Riverpaw.",
    "Another bounty was settled along Elwynn's troubled borders.")
q(86, "Pie for Billy", E, 6, F,
    "Billy offered information about the missing necklace in exchange for a pork belly pie.",
    "Bernice's search for her necklace had become a kitchen errand: boar meat for the boy's demanded pie.",
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
    "The inquiry reached Wiley, who acknowledged his debt to Stoutmantle.",
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
    "The submerged toolbox was recovered for its owner.",
    "Tools thought lost beneath the lake returned to Lakeshire's work.")
q(127, "Selling Fish", R, 21, K,
    "Spotted sunfish from Lake Everstill were in demand, and a local trader's stock was running low.",
    "The lake's fish supplied another kind of work beside Lakeshire's military requests.",
    "The sunfish delivery replenished the trader's stock.",
    "The batch of fish changed hands in a completed lakeside bargain.")
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
    "Jitters had been living on grubs and weeds while hiding in a deserted settlement.",
    "A proper meal for Jitters meant asking about Chef Grual's crab cakes in Darkshire.",
    "The request reached Grual, who could prepare cakes once the cooking work was arranged.",
    "Darkshire's cook heard the request; Jitters had not yet received his meal.")
q(93, "Dusky Crab Cakes", D, 20, "alliance_duskwood",
    "Grual's famous crab cakes used spider legs, seasoned well enough to hide their origin.",
    "Venom Web Spiders supplied the unlikely ingredient for a Scarlet Raven specialty.",
    "Grual received the legs and began seasoning them for the skillet.",
    "The ingredients reached the kitchen, where the crab cakes' secret remained the cook's own.")
q(165, "The Hermit", D, 25, HM,
    "Elaine Carevin had not seen the old man from Raven Hill coming into town for supplies lately.",
    "A shack overlooking the cemetery was the place to check on the missing customer.",
    "The hermit said the roads were too dangerous for him and asked for help with errands.",
    "The old man at Raven Hill answered Elaine's concern with a list of favors he needed.")
q(148, "Supplies from Darkshire", D, 24, HM,
    "The hermit wanted Ghost Hair Thread from Madame Eva in Darkshire.",
    "A supply request from the cemetery shack led back to a shop on the town square.",
    "Madame Eva had no thread in stock but offered to make some if supplied with ghost hair.",
    "The simple purchase became a search for ingredients before the thread could be made.")
q(149, "Ghost Hair Thread", D, 24, HM,
    "Eva's spectral comb could gather hair from Blind Mary at the haunted farmhouse south of town.",
    "Making the hermit's thread required help from a spirit living apart from Darkshire.",
    "Blind Mary used the spectral comb on her hair.",
    "The comb served its purpose with Mary; Eva still needed it back to make the thread.")
q(154, "Return the Comb", D, 24, HM,
    "Blind Mary wanted the spectral comb taken away after using it.",
    "The comb now held the strands Madame Eva needed for her unusual spinning.",
    "Eva received enough ghost hair for the thread and a few strands besides.",
    "The returned comb gave Eva the material to make a spool for the hermit.")
q(157, "Deliver the Thread", D, 24, HM,
    "Eva's thread could bind spirits or sew life into lifeless things; the hermit claimed it was for his doors and windows.",
    "A finished spool was ready for the shack, where its requested purpose was protection from spirits.",
    "The hermit accepted the Ghost Hair Thread and paid for its delivery.",
    "The spool reached Raven Hill; the delivery itself did not reveal what the hermit would make with it.")
q(158, "Zombie Juice", D, 24, HM,
    "The hermit asked for strong liquor from Tavernkeep Smitts, claiming the nights had grown too cold.",
    "Zombie Juice was another request from the isolated shack, this time leading to the Scarlet Raven.",
    "Smitts received the unusual request for Zombie Juice.",
    "The tavernkeeper knew the liquor, but a bottle had yet to be prepared for the hermit.")
q(156, "Gather Rot Blossoms", D, 24, HM,
    "Smitts needed rot blossoms from the skulls of Duskwood's skeletons to brew Zombie Juice.",
    "The graveyards supplied a grim ingredient for the hermit's requested drink.",
    "Smitts accepted the blossoms and promised to tell the Night Watch about the help against the skeletons.",
    "The brewing ingredients arrived, with news of fewer skeletons to pass to Althea Ebonlocke.")
q(159, "Juice Delivery", D, 24, HM,
    "Smitts's finished liquor came with a warning about its extraordinary strength.",
    "The bottle was ready for the hermit who had asked for something to warm his cold nights.",
    "The hermit received the Zombie Juice and offered payment.",
    "The liquor reached the shack, completing another of the old man's requests.")
q(133, "Ghoulish Effigy", D, 27, HM,
    "The hermit asked for ghoul ribs to make what he described as a scarecrow against the dead.",
    "His account of ghouls at the walls provided a reason for another unsettling shopping list.",
    "The ribs reached the hermit, who pronounced them suitable for his purpose.",
    "The requested bones were delivered; the claimed protection had not been demonstrated.")
q(134, "Ogre Thieves", D, 30, HM,
    "The hermit said ogres had driven him away from a crate of herbs and tools.",
    "His missing crate was believed to lie near the ogre mound in southern Duskwood.",
    "The crate returned to the hermit, who eagerly accepted it.",
    "The tools and herbs reached the shack, adding to the supplies gathered at the old man's request.")
q(160, "Note to the Mayor", D, 30, HM,
    "The hermit sent a note to Mayor Ello Ebonlocke, claiming they were old friends.",
    "After his supply errands, Abercrombie wanted a letter carried into Darkshire.",
    "Ello did not recognize Abercrombie's name and could not read the letter's ancient language.",
    "The mayor received the note, but its unreadable writing left the hermit's purpose unresolved.", 4)
q(218, "The Stolen Journal", "Dun Morogh", 5, C,
    "A marked troll had carried Grelin's notebook into the cave.",
    "The report from Coldridge depended on recovering a journal taken by the trolls.",
    "Grelin recovered his notebook and could finish the report intended for Senir.",
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
    "The favor was done, giving the brewers more room to attend to their work.")
q(320, "Return to Bellowfiz", "Dun Morogh", 8, M,
    "The cask of Evershine was ready to travel from Brewnall to Bellowfiz.",
    "The brewing errand still needed its final delivery after the work around the village.",
    "Bellowfiz received the Evershine and decided to open a bottle.",
    "The cask reached its waiting recipient, completing the delivery.")
q(418, "Thelsamar Blood Sausages", "Loch Modan", 11, L,
    "Vidra fed children and excavation workers with sausages made from the loch's surrounding wildlife.",
    "Bear meat, boar intestines and spider ichor were the ingredients waiting to become a Thelsamar meal.",
    "Vidra received the supplies and shared the sausage recipe along with instructions to eat them fresh.",
    "The ingredients reached Thelsamar's kitchen, where the recipe became part of the payment for gathering them.")
q(455, "The Algaz Gauntlet", "Wetlands", 21, V,
    "Dragonmaw orcs had moved into Dun Algaz, threatening the road between Loch Modan and Menethil Harbor.",
    "The passage to the Wetlands needed a fighting scout to carry news through the orc foothold.",
    "Valstag received the report of the Dragonmaw advance; its cause remained a mystery.",
    "News reached Menethil of a threat to its inland connection, with more work against the orcs ahead.", 4)
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
    "Dark Iron sappers had been seen by Stonewrought Dam after the attacks on Dun Modr and the Thandol Span.",
    "With much of the dam's security detail reassigned, Hinderweir needed a clue to the sappers' purpose.",
    "A suspicious barrel at the dam contained an unfamiliar powder.",
    "The search uncovered a strange-smelling powder that still needed examination.")
q(199, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "The barrel's powder offered a clue to the Dark Iron activity near the dam.",
    "A sample from the suspicious barrel needed to reach Hinderweir.",
    "Hinderweir received the sample and recognized a reason for alarm.",
    "The powder reached the dam's defender; its exact nature still needed an expert's attention.")
q(161, "A Dark Threat Looms", "Wetlands", 18, SD,
    "Hinderweir suspected an explosive and needed Ashlan Stonesmirk's expertise at Dun Modr.",
    "Identifying the powder meant carrying a sample through the Wetlands to the explosives specialist.",
    "Stonesmirk received the sample and took Hinderweir's concern seriously.",
    "The suspicious powder reached the expert assigned to the Dun Modr regiment.")
q(274, "A Dark Threat Looms", "Loch Modan", 18, SD,
    "Stonesmirk identified the powder as Seaforium, a danger once exposed to water.",
    "A mixture to halt the explosive reaction required a colloid and ingredients found around the loch.",
    "Hinderweir received Stonesmirk's warning and the disarming colloid.",
    "The dam's defender learned what the powder was; the remaining disarming materials still had to be gathered.")
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
    "Huldar had survived a Dark Iron ambush. What troubled him was Saean: after nearly a year working together, he had never suspected the man's allegiance.",
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
    "Merrin's weekly letters had stopped, leaving Tarrel without news from the Whelgar expedition.",
    "An unexplained silence from the dig sent a search toward the excavation east of Menethil.",
    "Merrin was found alive at the excavation.",
    "The search reached Merrin, but Tarrel still needed word of what had happened.")
q(306, "In Search of The Excavation Team", "Wetlands", 24, WX,
    "Raptors had overwhelmed the dig, and Merrin had a note explaining how Ormer sheltered the survivors.",
    "Tarrel needed to know that Merrin, Ormer and the prospector had survived the attack.",
    "Merrin's note reached Tarrel with news of the three survivors and the losses at the dig.",
    "Tarrel learned that Merrin lived; the expedition's troubles were still unresolved.")
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
    "The Goaz Stone's interrupted text hinted at a divine plan and a doomed prophecy.",
    "Four missing fragments lay among the artifacts and loose soil of the raptor-held excavation.",
    "The restored stone let the prospector resume translating Titan script, including a reference to Old Gods chained beneath the land.",
    "Ados, Modr, Golm and Neru completed the tablet; the wider meaning of its prophecy still needed translation.", 4)
q(303, "The Dark Iron War", "Wetlands", 30, DI,
    "The Dark Irons held Dun Modr after the destruction at the Thandol Span.",
    "The defenders needed pressure kept on the Dark Iron encampment while they waited for reserves.",
    "The attack put pressure on the encampment, but the reserve force had still not arrived.",
    "The defenders praised the blow struck against the Dark Iron forces at Dun Modr.", 4)
q(304, "A Grim Task", "Wetlands", 34, DI,
    "Roggo's information named Balgaras the Foul as the elusive leader of the Dark Iron band in the Wetlands.",
    "The losses at Dun Modr and the Thandol Span had brought a bounty on the warlock directing the attackers.",
    "Balgaras was dead, leaving the remaining Dark Irons to be dealt with before another leader arrived.",
    "The warlock's ear settled the bounty without reclaiming all the ground his soldiers held.", 4)
q(473, "Report to Captain Stoutfist", "Wetlands", 28, V,
    "Dragonmaw activity beyond Dun Algaz had brought a request for help from Captain Stoutfist.",
    "Menethil's war room was gathering assistance against the orcs' growing strength.",
    "Stoutfist received the referral and had a task ready.",
    "The report reached Menethil's captain, bringing the Dragonmaw problem into his hands.")
q(464, "War Banners", "Wetlands", 28, V,
    "Dragonmaw survivors had gathered strength in an encampment northeast of Menethil.",
    "Stoutfist wanted banners as evidence of a strike on the orcs who had fled Grim Batol.",
    "The banners reached Stoutfist, who identified Nek'rosh as the clan's current leader.",
    "Proof of the fighting brought an account of Nek'rosh's inherited feud with the red dragons.")
q(465, "Nek'rosh's Gambit", "Wetlands", 31, V,
    "Nek'rosh had built catapults for a siege while the fighting in Dun Algaz blocked Menethil's reinforcements.",
    "Stoutfist supplied tinder for an attack on the siege engines in the Dragonmaw camp.",
    "Tinder caught on the catapult and the flames spread.",
    "The siege engine was set alight; Nek'rosh himself still remained to be dealt with.", 4)
q(474, "Defeat Nek'rosh", "Wetlands", 32, V,
    "With the catapults burned, the remaining task was to confront Chieftain Nek'rosh.",
    "The threat to Menethil still had its commander after the destruction of the siege engines.",
    "Nek'rosh's death completed the strike, and Stoutfist credited the destroyed catapults with making Menethil safe.",
    "The captain rewarded the blow against the Dragonmaw leader and the immediate siege threat.", 5)
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
    "A visit to Ironbeard's Tomb ended with an ooze swallowing a bag thrown during an escape.",
    "The lost bag's contents still mattered to its owner, even among the oozes near Dun Modr.",
    "The bag was recovered, and its owner offered a salvaged item as thanks.",
    "The belongings returned from the ooze, settling an errand born of a narrow escape.")

-- The western routes: remedies remain attempts until their own recorded
-- result, and a request for forest spirits does not restore the Charred Vale.
local AC, AZ, ST = "alliance_relara", "alliance_zoram", "alliance_stonetalon"
P.threads[AC] = "the search for Relara's cure"
P.threads[AZ] = "the ruins along the Zoram Strand"
P.threads[ST] = "the damaged forests of Stonetalon"
q(1010, "Bathran's Hair", "Ashenvale", 20, AC,
    "Orendil sought a plant from Bathran's Haunt to treat a child whose illness seemed more than physical.",
    "Bathran's Hair had a reputation for easing ailments of the spirit.",
    "Orendil received the plant and prepared to mix a possible cure.",
    "The herb reached Orendil, along with troubling news of Forsaken at the old ruins.")
q(1020, "Orendil's Cure", "Ashenvale", 20, AC,
    "Orendil's medicine needed carrying to Pelturas Whitemoon in Astranaar.",
    "Relara's parent awaited help while the child's illness grew dangerous.",
    "Pelturas received Orendil's medicine and placed hope in the healer's skill.",
    "The remedy reached Relara's household, but its effect was not yet known.")
q(1033, "Elune's Tear", "Ashenvale", 22, AC,
    "Orendil's first remedy had only slowed Relara's illness, leaving Pelturas to seek a stronger treatment.",
    "A stone called Elune's Tear lay on the isle in Iris Lake and was said to wash away corruption.",
    "Pelturas received the stone and planned to place it in a stew for Relara.",
    "Elune's Tear reached the household as another hoped-for remedy.")
q(1034, "The Ruins of Stardust", "Ashenvale", 23, AC,
    "Relara's nightmares had eased after Elune's Tear, but her fever remained.",
    "Frosted dust from the southern ruins offered the next treatment Orendil had suggested.",
    "Pelturas received the dust and prepared to make a poultice for the fever.",
    "The ingredients for the poultice reached Pelturas, who still had to apply the treatment.")
q(1035, "Fallen Sky Lake", "Ashenvale", 30, AC,
    "Relara's fever had passed, but Pelturas believed a moonstone was needed to restore her strength.",
    "A Shadethicket Oracle hoarded the fallen moonstones once gathered by the lake.",
    "Pelturas received the moonstone and credited its recovery with saving Relara.",
    "The moonstone reached Relara's parent, who expected its power to return her strength.", 5)
q(1008, "The Zoram Strand", "Ashenvale", 19, AZ,
    "Naga had returned to the coast above Zoram's drowned ruins for reasons the Sentinels did not know.",
    "The northwestern shore held the remnants of a night elf city lost in the Sundering.",
    "The fighting against the coastal naga earned the Sentinels' approval.",
    "The shore's defenders acknowledged the strike without explaining why the naga had returned.")
q(1007, "The Ancient Statuette", "Ashenvale", 20, AZ,
    "A naga ambush had driven a traveler from his vessel and cost him a prized statuette.",
    "The lost figure was the reason its owner had ventured among Zoram's submerged ruins.",
    "The statuette was returned to its owner, who hoped it would unlock the old city's secrets.",
    "The recovered figure restored the traveler's prized possession while its secrets remained closed.")
q(1009, "Ruuzel", "Ashenvale", 25, AZ,
    "The Ring of Zoram was believed to open the statuette's ancient lock.",
    "The naga leader Ruuzel held the ring once possessed by the drowned city's rulers.",
    "The ring was recovered and paid for, supplying the key its seeker had requested.",
    "The ancient ring reached the statuette's owner; what it might reveal was still ahead.", 4)
q(1056, "Journey to Stonetalon Peak", "Stonetalon Mountains", 18, ST,
    "Faldreas directed aid through the Talondeep Path toward Keeper Albagorm on Stonetalon Peak.",
    "The forest spirits' concerns led beyond Ashenvale into the damaged mountains.",
    "Albagorm received the arrival from Faldreas and the forest spirits.",
    "The referral reached the keeper on Stonetalon Peak, where his own requests awaited.")
q(1057, "Reclaiming the Charred Vale", "Stonetalon Mountains", 27, ST,
    "Bloodfury harpies blocked access to the vale after industrialists had burned its forest.",
    "Albagorm needed a way into the damaged land before regrowth could begin.",
    "The Bloodfuries suffered losses, opening the possibility of beginning restoration.",
    "The fighting reduced the harpy obstacle; restoring the forest was work still to come.", 4)
q(1059, "Reclaiming the Charred Vale", "Thousand Needles", 27, ST,
    "Albagorm sought Falfindel Waywarder's help before the Bloodfuries could regroup.",
    "A druid near the edge of Feralas might call forest spirits to aid the Charred Vale.",
    "Falfindel received Albagorm's urgent request and considered summoning help.",
    "The appeal reached Falfindel; the arrival of forest spirits and the vale's recovery were still ahead.")
q(1070, "On Guard in Stonetalon", "Stonetalon Mountains", 21, ST,
    "Tara had heard nothing from Kaela Shadowspear after the Sentinel went to investigate Stonetalon.",
    "Kaela's mission with a gnome mage had left friends in Ashenvale waiting for news.",
    "Kaela was found and welcomed the referral from Tara.",
    "The search reached Kaela in Stonetalon, though she had no good news about the land yet.")
q(1085, "On Guard in Stonetalon", "Stonetalon Mountains", 21, ST,
    "Kaela directed further help toward Gaxim, the gnome working beside her against the Venture Company.",
    "The devastation in Stonetalon had brought a Sentinel and an engineer together.",
    "Gaxim received the introduction and explained his faith in engineering, alchemy and magic.",
    "The referral reached the gnome whose inventions were intended to help the night elves' forests.")
q(1071, "A Gnome's Respite", "Stonetalon Mountains", 21, ST,
    "Gaxim needed time to plan his inventions while Venture Company goblins worked in Windshear Crag.",
    "Keeping the goblins at bay would give the engineer room to organize his next attempt.",
    "Gaxim thanked the fighting and began outlining a plan that would need more explosives.",
    "The respite let Gaxim develop his next idea, with its supplies and execution still ahead.")
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

-- Shared titles cannot turn the first referral (66) into the execution (98).
-- Original quest description/completion: corpus_vanilla_quests.txt #66, #98.
q(66, "The Legend of Stalvan", D, 28, "alliance_stalvan",
    "Madame Eva feared for her granddaughter Alyssa, and her search for an answer had brought her the name Stalvan.",
    "Eva's cards had shown Death; the name Stalvan was her only lead.",
    "The inquiry reached the clerk in Darkshire's town hall.",
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
P.questIDs[921].highlight = {"With moonwell water returned, Tenaron spoke of Hyjal's cost to Nordrassil and of Elune's wells, whose ancient waters came from the Well of Eternity.", "The moonwell errand carried Tenaron's lesson: Nordrassil's power had been spent at Hyjal, while Elune's shrines held the ancient magic of the Well of Eternity."}
P.questIDs[932].highlight = {"Tallonkai wanted the matter kept quiet: the satyr Melenas and his grell were embarrassingly close to home. Melenas's death ended that concern.", "Tallonkai received proof of Melenas's death. The satyr gathering grell in nearby Fel Rock had been dealt with."}
P.questIDs[483].highlight = {"Four Relics of Wakening were recovered from Gnarlpine-held Ban'ethil, ready for the ritual meant to wake its trapped druids.", "The recovered Relics of Wakening made preparations possible for the sleeping druids in Ban'ethil, endangered by Gnarlpine invaders."}
P.questIDs[2438].highlight = {"The emerald dreamcatcher was recovered from Starbreeze. Tallonkai prized it as a rare gift from Ban'ethil's warden.", "A rare gift from Ban'ethil's warden returned from corrupted Starbreeze: the emerald dreamcatcher its owner had feared lost."}
P.questIDs[2866].highlight = {"Among naga-held Solarsal's ruins, the search found a newer gazebo: its glyphs were unfamiliar, and its stone was warm.", "The Solarsal investigation found a gazebo newer than the ruins around it, with warm stone and repeating, unreadable glyphs."}
P.questIDs[2867].highlight = {"The gazebo report disturbed Shandris. Whatever the Hatecrest's purpose, she wanted further help against their presence in Feralas.", "Shandris found the news from Solarsal disturbing and asked for more help against the naga around the strange gazebo."}
P.questIDs[2869].highlight = {"Hatecrest scales proved the counterattack Latronicus wanted on Sardor Isle. He considered sending them to Pratt for crafting.", "Latronicus accepted scales from the Hatecrest as proof of the fighting on Sardor Isle, then wondered what Pratt could make of them."}
P.questIDs[255].highlight = {"With Ironforge's soldiers months away, Bluntnose welcomed help against Thelsamar's ogres. He hoped the town could soon turn its attention to the troggs.", "Thelsamar's ogres suffered losses while Ironforge's reinforcements were still months away. Bluntnose offered thanks, already thinking of the troggs."}
P.questIDs[267].highlight = {"With Ironforge's Reserve away, Rugelfuss needed help against Loch Modan's troggs. The returned teeth earned his thanks and the praise he imagined from King Magni.", "Trogg teeth reached Captain Rugelfuss, whose regiment could not leave the gate. He declared that such defense of dwarven lands would make King Magni proud."}
P.questIDs[263].highlight = {"The fight against Stonesplinter shamans and bonesnappers earned Wallbang's salute and a recommendation to speak with the captain.", "Wallbang praised the fighting against the Stonesplinter shamans and bonesnappers. He thought the captain might now offer a greater responsibility."}
P.questIDs[273].highlight = {"Huldar's powder shipment was found after a Dark Iron ambush. The betrayal of Saean, a colleague of nearly a year, had stunned him.", "The search reached Huldar and the powder shipment. He had weathered the Dark Iron ambush, but never expected Saean to side with the attackers."}
P.questIDs[298].highlight = {"Ironband's report brought another powder request to Jern, who wondered what had become of the shipment he had sent weeks earlier.", "Jern received Ironband's report and request for blastpowder. A generous shipment had already left Thelsamar weeks before; where had it gone?"}
P.questIDs[294].highlight = {"Raptors drawn to Whelgar's excavation had killed Ormer's fellow workers. The first hunt brought vengeance while duty kept him beside Merrin and the Prospector.", "The raptors west of the bluff suffered Ormer's first reprisal for his fallen coworkers. He said he would have joined the fighting if duty to Merrin and the Prospector allowed it."}
P.questIDs[295].highlight = {"The next hunt thinned the scytheclaws and razormaws below the bluff, earning Ormer's hearty praise.", "Ormer welcomed the losses among the scytheclaws and razormaws that crowded the excavation below his shelter."}
P.questIDs[296].highlight = {"Sarltooth's talon proved Ormer's final target dead. He hoped the vengeance for the fallen workers would deter attacks on King Magni's people.", "Ormer received Sarltooth's talon and remembered the dwarves killed at their work. He believed the vengeance would make the creatures fear another attack."}

-- Compact outcomes remain attached to exact quest stages.
P.questIDs[463].highlight = {"The feared Greenwarden offered the name Rethiel. He said the roots and ferns spoke well of his visitor, and asked for help healing the land.", "Fitzsimmons's warning led to Rethiel in the marsh. He welcomed his visitor on the word of the roots and ferns, then asked that the land's wounds be healed."}
P.questIDs[276].highlight = {"The hunt reduced the Mosshides trampling the fen. Rethiel saw hope that his strained faith in his visitor's people might return.", "Fewer Mosshide gnolls and mongrels remained near Algaz. Rethiel praised the help for the Wetlands and cautiously hoped to trust the hunter's people again."}
P.questIDs[277].highlight = {"Rethiel received the Mosshides' fire-making flints. He meant to smash them and cast them into the sea to spare living wood.", "The captured flints reached Rethiel, who promised to break them and throw them into the sea, beyond further use against living trees."}
P.questIDs[275].highlight = {"The fen creepers were put down along the waterways. Rethiel judged the land soothed and granted a boon in thanks.", "Rethiel rewarded the hunt against the fevered fen creepers. He said the work had eased the land's suffering."}

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
            ["why"] = {"Haggard recommended Smitts at the Scarlet Raven Tavern for his knowledge of local history.", "The faded page needed examination by someone Haggard trusted to recognize a local story."},
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
