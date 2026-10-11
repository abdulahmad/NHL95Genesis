;	3 parts in ROM order, each under its banner below. incbin only (plus the two FeaturedPictures tables).
;	Each file is a slice of the ROM written by npm run extractassets into Extracted\\Graphics.

;------------------------------------------------------------------------------------------------------------------------
;	The player pictures (FeaturedPicIdx / FeaturedPictures), the rink, the sprites, the fonts and the screen maps and bitmaps, up to
;	the team logos. One slice per asset referenced by the code (the names the code uses), one per FeaturedPictures picture
;	(Card<player>, the line 1 starter of the first team that lists it). A map starts with its 8-byte header (palette and map offsets):
;	a reference to its tiles is Label+8.

PicturePalette	;The player picture palette, then the picture of a player with none (DrawMatchupPicture, PlayerCardScreen)
	incbin	..\Extracted\NHL95\Graphics\NoPlayerPicture.map.jim
NoPicSkater2	;Generic skater picture (GetPlayerPicture, hand bit 0 set)
	incbin	..\Extracted\NHL95\Graphics\NoPicSkater2.bin
NoPicSkater1	;Generic skater picture (GetPlayerPicture, hand bit 0 clear)
	incbin	..\Extracted\NHL95\Graphics\NoPicSkater1.bin
NoPicGoalie2	;Generic goalie picture (GetPlayerPicture, hand bit 0 clear)
	incbin	..\Extracted\NHL95\Graphics\NoPicGoalie2.bin
NoPicGoalie1	;Generic goalie picture (GetPlayerPicture, hand bit 0 set)
	incbin	..\Extracted\NHL95\Graphics\NoPicGoalie1.bin
CardGuyHebert	;Guy Hebert player picture (FeaturedPictures ANH 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGuyHebert.bin
CardBobCorkum	;Bob Corkum player picture (FeaturedPictures ANH 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBobCorkum.bin
CardTerryYake	;Terry Yake player picture (FeaturedPictures ANH 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTerryYake.bin
CardGarryValk	;Garry Valk player picture (FeaturedPictures ANH 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGarryValk.bin
CardSeanHill	;Sean Hill player picture (FeaturedPictures ANH 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSeanHill.bin
CardBillHoulder	;Bill Houlder player picture (FeaturedPictures ANH 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBillHoulder.bin
CardJonCasey	;Jon Casey player picture (FeaturedPictures BOS 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJonCasey.bin
CardAdamOates	;Adam Oates player picture (FeaturedPictures BOS 4, ASE 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAdamOates.bin
CardBryanSmolinski	;Bryan Smolinski player picture (FeaturedPictures BOS 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBryanSmolinski.bin
CardCamNeely	;Cam Neely player picture (FeaturedPictures BOS 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCamNeely.bin
CardRayBourque	;Ray Bourque player picture (FeaturedPictures BOS 1, ASE 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRayBourque.bin
CardAlIafrate	;Al Iafrate player picture (FeaturedPictures BOS 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlIafrate.bin
CardDominikHasek	;Dominik Hasek player picture (FeaturedPictures BUF 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDominikHasek.bin
CardPatLaFontaine	;Pat LaFontaine player picture (FeaturedPictures BUF 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPatLaFontaine.bin
CardDaleHawerchuk	;Dale Hawerchuk player picture (FeaturedPictures BUF 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDaleHawerchuk.bin
CardAlexnderMogilny	;Alexnder Mogilny player picture (FeaturedPictures BUF 5, ASE 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexnderMogilny.bin
CardDougBodger	;Doug Bodger player picture (FeaturedPictures BUF 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDougBodger.bin
CardPetrSvoboda	;Petr Svoboda player picture (FeaturedPictures BUF 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPetrSvoboda.bin
CardMikeVernon	;Mike Vernon player picture (FeaturedPictures CGY 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMikeVernon.bin
CardJoeNieuwendyk	;Joe Nieuwendyk player picture (FeaturedPictures CGY 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJoeNieuwendyk.bin
CardGaryRoberts	;Gary Roberts player picture (FeaturedPictures CGY 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGaryRoberts.bin
CardTheorenFleury	;Theoren Fleury player picture (FeaturedPictures CGY 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTheorenFleury.bin
CardZarleyZalapski	;Zarley Zalapski player picture (FeaturedPictures CGY 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardZarleyZalapski.bin
CardAlMacInnis	;Al MacInnis player picture (FeaturedPictures CGY 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlMacInnis.bin
CardEdBelfour	;Ed Belfour player picture (FeaturedPictures CHI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardEdBelfour.bin
CardJeremyRoenick	;Jeremy Roenick player picture (FeaturedPictures CHI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJeremyRoenick.bin
CardMichelGoulet	;Michel Goulet player picture (FeaturedPictures CHI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMichelGoulet.bin
CardJoeMurphy	;Joe Murphy player picture (FeaturedPictures CHI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJoeMurphy.bin
CardChrisChelios	;Chris Chelios player picture (FeaturedPictures CHI 2, ASW 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardChrisChelios.bin
CardSteveSmith	;Steve Smith player picture (FeaturedPictures CHI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveSmith.bin
CardAndyMoog	;Andy Moog player picture (FeaturedPictures DAL 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAndyMoog.bin
CardMikeModano	;Mike Modano player picture (FeaturedPictures DAL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMikeModano.bin
CardDaveGagner	;Dave Gagner player picture (FeaturedPictures DAL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDaveGagner.bin
CardRussCourtnall	;Russ Courtnall player picture (FeaturedPictures DAL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRussCourtnall.bin
CardMarkTinordi	;Mark Tinordi player picture (FeaturedPictures DAL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMarkTinordi.bin
CardDerianHatcher	;Derian Hatcher player picture (FeaturedPictures DAL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDerianHatcher.bin
CardBobEssensa	;Bob Essensa player picture (FeaturedPictures DET 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBobEssensa.bin
CardSteveYzerman	;Steve Yzerman player picture (FeaturedPictures DET 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveYzerman.bin
CardSergeiFedorov	;Sergei Fedorov player picture (FeaturedPictures DET 3, ASW 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSergeiFedorov.bin
CardDinoCiccarelli	;Dino Ciccarelli player picture (FeaturedPictures DET 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDinoCiccarelli.bin
CardPaulCoffey	;Paul Coffey player picture (FeaturedPictures DET 2, ASW 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPaulCoffey.bin
CardSteveChiasson	;Steve Chiasson player picture (FeaturedPictures DET 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveChiasson.bin
CardBillRanford	;Bill Ranford player picture (FeaturedPictures EDM 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBillRanford.bin
CardDougWeight	;Doug Weight player picture (FeaturedPictures EDM 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDougWeight.bin
CardShayneCorson	;Shayne Corson player picture (FeaturedPictures EDM 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardShayneCorson.bin
CardZdenoCiger	;Zdeno Ciger player picture (FeaturedPictures EDM 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardZdenoCiger.bin
CardIgorKravchuk	;Igor Kravchuk player picture (FeaturedPictures EDM 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardIgorKravchuk.bin
CardBobBeers	;Bob Beers player picture (FeaturedPictures EDM 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBobBeers.bin
CardJohnVanbiesbrk	;John Vanbiesbrk player picture (FeaturedPictures FLA 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJohnVanbiesbrk.bin
CardJesseBelanger	;Jesse Belanger player picture (FeaturedPictures FLA 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJesseBelanger.bin
CardAndreiLomakin	;Andrei Lomakin player picture (FeaturedPictures FLA 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAndreiLomakin.bin
CardBobKudelski	;Bob Kudelski player picture (FeaturedPictures FLA 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBobKudelski.bin
CardBrianBenning	;Brian Benning player picture (FeaturedPictures FLA 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrianBenning.bin
CardGordMurphy	;Gord Murphy player picture (FeaturedPictures FLA 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGordMurphy.bin
CardSeanBurke	;Sean Burke player picture (FeaturedPictures HFD 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSeanBurke.bin
CardAndrewCassels	;Andrew Cassels player picture (FeaturedPictures HFD 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAndrewCassels.bin
CardGeoffSanderson	;Geoff Sanderson player picture (FeaturedPictures HFD 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGeoffSanderson.bin
CardPatVerbeek	;Pat Verbeek player picture (FeaturedPictures HFD 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPatVerbeek.bin
CardAlexnderGodynyuk	;Alexnder Godynyuk player picture (FeaturedPictures HFD 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexnderGodynyuk.bin
CardChrisPronger	;Chris Pronger player picture (FeaturedPictures HFD 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardChrisPronger.bin
CardKellyHrudey	;Kelly Hrudey player picture (FeaturedPictures LA 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKellyHrudey.bin
CardWayneGretzky	;Wayne Gretzky player picture (FeaturedPictures LA 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardWayneGretzky.bin
CardLucRobitaille	;Luc Robitaille player picture (FeaturedPictures LA 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardLucRobitaille.bin
CardJariKurri	;Jari Kurri player picture (FeaturedPictures LA 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJariKurri.bin
CardRobBlake	;Rob Blake player picture (FeaturedPictures LA 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRobBlake.bin
CardMartyMcSorley	;Marty McSorley player picture (FeaturedPictures LA 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMartyMcSorley.bin
CardPatrickRoy	;Patrick Roy player picture (FeaturedPictures MTL 0, ASE 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPatrickRoy.bin
CardKirkMuller	;Kirk Muller player picture (FeaturedPictures MTL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKirkMuller.bin
CardVincentDamphousse	;Vincent Damphousse player picture (FeaturedPictures MTL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardVincentDamphousse.bin
CardBrianBellows	;Brian Bellows player picture (FeaturedPictures MTL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrianBellows.bin
CardEricDesjardins	;Eric Desjardins player picture (FeaturedPictures MTL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardEricDesjardins.bin
CardMattSchneider	;Matt Schneider player picture (FeaturedPictures MTL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMattSchneider.bin
CardChrisTerreri	;Chris Terreri player picture (FeaturedPictures NJ 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardChrisTerreri.bin
CardCoreyMillen	;Corey Millen player picture (FeaturedPictures NJ 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCoreyMillen.bin
CardJohnMacLean	;John MacLean player picture (FeaturedPictures NJ 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJohnMacLean.bin
CardStephaneRicher	;Stephane Richer player picture (FeaturedPictures NJ 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardStephaneRicher.bin
CardScottStevens	;Scott Stevens player picture (FeaturedPictures NJ 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardScottStevens.bin
CardScottNiedrmayer	;Scott Niedrmayer player picture (FeaturedPictures NJ 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardScottNiedrmayer.bin
CardRonHextall	;Ron Hextall player picture (FeaturedPictures NYI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRonHextall.bin
CardPierreTurgeon	;Pierre Turgeon player picture (FeaturedPictures NYI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPierreTurgeon.bin
CardBenoitHogue	;Benoit Hogue player picture (FeaturedPictures NYI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBenoitHogue.bin
CardSteveThomas	;Steve Thomas player picture (FeaturedPictures NYI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveThomas.bin
CardDariusKasparitis	;Darius Kasparitis player picture (FeaturedPictures NYI 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDariusKasparitis.bin
CardVladimirMalakhov	;Vladimir Malakhov player picture (FeaturedPictures NYI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardVladimirMalakhov.bin
CardMikeRichter	;Mike Richter player picture (FeaturedPictures NYR 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMikeRichter.bin
CardMarkMessier	;Mark Messier player picture (FeaturedPictures NYR 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMarkMessier.bin
CardAdamGraves	;Adam Graves player picture (FeaturedPictures NYR 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAdamGraves.bin
CardSteveLarmer	;Steve Larmer player picture (FeaturedPictures NYR 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveLarmer.bin
CardBrianLeetch	;Brian Leetch player picture (FeaturedPictures NYR 1, ASE 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrianLeetch.bin
CardSergeiZubov	;Sergei Zubov player picture (FeaturedPictures NYR 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSergeiZubov.bin
CardCraigBillington	;Craig Billington player picture (FeaturedPictures OTW 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCraigBillington.bin
CardAlexnderDaigle	;Alexnder Daigle player picture (FeaturedPictures OTW 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexnderDaigle.bin
CardAlexeiYashin	;Alexei Yashin player picture (FeaturedPictures OTW 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexeiYashin.bin
CardSylvainTurgeon	;Sylvain Turgeon player picture (FeaturedPictures OTW 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSylvainTurgeon.bin
CardNormMaciver	;Norm Maciver player picture (FeaturedPictures OTW 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardNormMaciver.bin
CardBradShaw	;Brad Shaw player picture (FeaturedPictures OTW 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBradShaw.bin
CardDominicRoussel	;Dominic Roussel player picture (FeaturedPictures PHI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDominicRoussel.bin
CardEricLindros	;Eric Lindros player picture (FeaturedPictures PHI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardEricLindros.bin
CardRodBrindAmour	;Rod BrindAmour player picture (FeaturedPictures PHI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRodBrindAmour.bin
CardMarkRecchi	;Mark Recchi player picture (FeaturedPictures PHI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMarkRecchi.bin
CardGarryGalley	;Garry Galley player picture (FeaturedPictures PHI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGarryGalley.bin
CardDimitriYushkevich	;Dimitri Yushkevich player picture (FeaturedPictures PHI 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDimitriYushkevich.bin
CardTomBarrasso	;Tom Barrasso player picture (FeaturedPictures PIT 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTomBarrasso.bin
CardMarioLemieux	;Mario Lemieux player picture (FeaturedPictures PIT 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMarioLemieux.bin
CardKevinStevens	;Kevin Stevens player picture (FeaturedPictures PIT 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKevinStevens.bin
CardJaromirJagr	;Jaromir Jagr player picture (FeaturedPictures PIT 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJaromirJagr.bin
CardUlfSamuelsson	;Ulf Samuelsson player picture (FeaturedPictures PIT 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardUlfSamuelsson.bin
CardLarryMurphy	;Larry Murphy player picture (FeaturedPictures PIT 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardLarryMurphy.bin
CardStephaneFiset	;Stephane Fiset player picture (FeaturedPictures QUE 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardStephaneFiset.bin
CardJoeSakic	;Joe Sakic player picture (FeaturedPictures QUE 4, ASE 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJoeSakic.bin
CardMatsSundin	;Mats Sundin player picture (FeaturedPictures QUE 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMatsSundin.bin
CardValeriKamensky	;Valeri Kamensky player picture (FeaturedPictures QUE 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardValeriKamensky.bin
CardCurtisLeschyshyn	;Curtis Leschyshyn player picture (FeaturedPictures QUE 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCurtisLeschyshyn.bin
CardAlexeiGusarov	;Alexei Gusarov player picture (FeaturedPictures QUE 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexeiGusarov.bin
CardArtursIrbe	;Arturs Irbe player picture (FeaturedPictures SJ 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardArtursIrbe.bin
CardIgorLarionov	;Igor Larionov player picture (FeaturedPictures SJ 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardIgorLarionov.bin
CardUlfDahlen	;Ulf Dahlen player picture (FeaturedPictures SJ 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardUlfDahlen.bin
CardSergeiMakarov	;Sergei Makarov player picture (FeaturedPictures SJ 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSergeiMakarov.bin
CardJeffNorton	;Jeff Norton player picture (FeaturedPictures SJ 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJeffNorton.bin
CardSandisOzolinsh	;Sandis Ozolinsh player picture (FeaturedPictures SJ 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSandisOzolinsh.bin
CardCurtisJoseph	;Curtis Joseph player picture (FeaturedPictures STL 0, ASW 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCurtisJoseph.bin
CardCraigJanney	;Craig Janney player picture (FeaturedPictures STL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCraigJanney.bin
CardBrendanShanahan	;Brendan Shanahan player picture (FeaturedPictures STL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrendanShanahan.bin
CardBrettHull	;Brett Hull player picture (FeaturedPictures STL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrettHull.bin
CardPhilHousley	;Phil Housley player picture (FeaturedPictures STL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPhilHousley.bin
CardSteveDuchesne	;Steve Duchesne player picture (FeaturedPictures STL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSteveDuchesne.bin
CardDarenPuppa	;Daren Puppa player picture (FeaturedPictures TB 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDarenPuppa.bin
CardChrisGratton	;Chris Gratton player picture (FeaturedPictures TB 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardChrisGratton.bin
CardBrianBradley	;Brian Bradley player picture (FeaturedPictures TB 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardBrianBradley.bin
CardPetrKlima	;Petr Klima player picture (FeaturedPictures TB 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPetrKlima.bin
CardRomanHamrlik	;Roman Hamrlik player picture (FeaturedPictures TB 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardRomanHamrlik.bin
CardShawnChambers	;Shawn Chambers player picture (FeaturedPictures TB 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardShawnChambers.bin
CardFelixPotvin	;Felix Potvin player picture (FeaturedPictures TOR 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardFelixPotvin.bin
CardDougGilmour	;Doug Gilmour player picture (FeaturedPictures TOR 4, ASW 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDougGilmour.bin
CardWendelClark	;Wendel Clark player picture (FeaturedPictures TOR 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardWendelClark.bin
CardDaveAndreychuk	;Dave Andreychuk player picture (FeaturedPictures TOR 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDaveAndreychuk.bin
CardJamieMacoun	;Jamie Macoun player picture (FeaturedPictures TOR 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJamieMacoun.bin
CardDaveEllett	;Dave Ellett player picture (FeaturedPictures TOR 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDaveEllett.bin
CardKirkMcLean	;Kirk McLean player picture (FeaturedPictures VAN 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKirkMcLean.bin
CardCliffRonning	;Cliff Ronning player picture (FeaturedPictures VAN 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardCliffRonning.bin
CardGeoffCourtnall	;Geoff Courtnall player picture (FeaturedPictures VAN 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardGeoffCourtnall.bin
CardPavelBure	;Pavel Bure player picture (FeaturedPictures VAN 5, ASW 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardPavelBure.bin
CardJyrkiLumme	;Jyrki Lumme player picture (FeaturedPictures VAN 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJyrkiLumme.bin
CardJeffBrown	;Jeff Brown player picture (FeaturedPictures VAN 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJeffBrown.bin
CardDonBeaupre	;Don Beaupre player picture (FeaturedPictures WSH 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDonBeaupre.bin
CardMikeRidley	;Mike Ridley player picture (FeaturedPictures WSH 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardMikeRidley.bin
CardJoeJuneau	;Joe Juneau player picture (FeaturedPictures WSH 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardJoeJuneau.bin
CardDimitriKhristich	;Dimitri Khristich player picture (FeaturedPictures WSH 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDimitriKhristich.bin
CardKevinHatcher	;Kevin Hatcher player picture (FeaturedPictures WSH 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKevinHatcher.bin
CardSylvainCote	;Sylvain Cote player picture (FeaturedPictures WSH 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardSylvainCote.bin
CardTimCheveldae	;Tim Cheveldae player picture (FeaturedPictures WPG 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTimCheveldae.bin
CardAlexeiZhamnov	;Alexei Zhamnov player picture (FeaturedPictures WPG 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardAlexeiZhamnov.bin
CardKeithTkachuk	;Keith Tkachuk player picture (FeaturedPictures WPG 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardKeithTkachuk.bin
CardTeemuSelanne	;Teemu Selanne player picture (FeaturedPictures WPG 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTeemuSelanne.bin
CardTeppoNumminen	;Teppo Numminen player picture (FeaturedPictures WPG 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardTeppoNumminen.bin
CardDaveManson	;Dave Manson player picture (FeaturedPictures WPG 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\CardDaveManson.bin
FeaturedPicIdx	;The FeaturedPictures index of the line 1 starters (G, LD, RD, LW, C, RW) of each team (GetPlayerPicture)
	dc.b	0,5,4,3,1,2	;ANH
	dc.b	6,10,11,8,7,9	;BOS
	dc.b	12,16,17,14,13,15	;BUF
	dc.b	18,22,23,20,19,21	;CGY
	dc.b	24,29,28,26,25,27	;CHI
	dc.b	30,34,35,32,31,33	;DAL
	dc.b	36,41,40,38,37,39	;DET
	dc.b	42,46,47,44,43,45	;EDM
	dc.b	48,52,53,50,49,51	;FLA
	dc.b	54,58,59,56,55,57	;HFD
	dc.b	60,64,65,62,61,63	;LA
	dc.b	66,71,70,68,67,69	;MTL
	dc.b	72,77,76,75,73,74	;NJ
	dc.b	78,83,82,80,79,81	;NYI
	dc.b	84,88,89,86,85,87	;NYR
	dc.b	90,94,95,93,92,91	;OTW
	dc.b	96,100,101,98,97,99	;PHI
	dc.b	102,106,107,104,103,105	;PIT
	dc.b	108,113,112,111,109,110	;QUE
	dc.b	114,118,119,116,115,117	;SJ
	dc.b	120,125,124,122,121,123	;STL
	dc.b	126,131,130,127,128,129	;TB
	dc.b	132,136,137,134,133,135	;TOR
	dc.b	138,142,143,140,139,141	;VAN
	dc.b	144,149,148,147,145,146	;WSH
	dc.b	150,155,154,152,151,153	;WPG
	dc.b	66,10,88,109,7,15	;ASE
	dc.b	120,40,28,38,133,141	;ASW
FeaturedPictures	;The 160 player pictures (GetPlayerPicture)
	dc.l	CardGuyHebert,CardBobCorkum,CardTerryYake,CardGarryValk
	dc.l	CardSeanHill,CardBillHoulder,CardJonCasey,CardAdamOates
	dc.l	CardBryanSmolinski,CardCamNeely,CardRayBourque,CardAlIafrate
	dc.l	CardDominikHasek,CardPatLaFontaine,CardDaleHawerchuk,CardAlexnderMogilny
	dc.l	CardDougBodger,CardPetrSvoboda,CardMikeVernon,CardJoeNieuwendyk
	dc.l	CardGaryRoberts,CardTheorenFleury,CardZarleyZalapski,CardAlMacInnis
	dc.l	CardEdBelfour,CardJeremyRoenick,CardMichelGoulet,CardJoeMurphy
	dc.l	CardChrisChelios,CardSteveSmith,CardAndyMoog,CardMikeModano
	dc.l	CardDaveGagner,CardRussCourtnall,CardMarkTinordi,CardDerianHatcher
	dc.l	CardBobEssensa,CardSteveYzerman,CardSergeiFedorov,CardDinoCiccarelli
	dc.l	CardPaulCoffey,CardSteveChiasson,CardBillRanford,CardDougWeight
	dc.l	CardShayneCorson,CardZdenoCiger,CardIgorKravchuk,CardBobBeers
	dc.l	CardJohnVanbiesbrk,CardJesseBelanger,CardAndreiLomakin,CardBobKudelski
	dc.l	CardBrianBenning,CardGordMurphy,CardSeanBurke,CardAndrewCassels
	dc.l	CardGeoffSanderson,CardPatVerbeek,CardAlexnderGodynyuk,CardChrisPronger
	dc.l	CardKellyHrudey,CardWayneGretzky,CardLucRobitaille,CardJariKurri
	dc.l	CardRobBlake,CardMartyMcSorley,CardPatrickRoy,CardKirkMuller
	dc.l	CardVincentDamphousse,CardBrianBellows,CardEricDesjardins,CardMattSchneider
	dc.l	CardChrisTerreri,CardCoreyMillen,CardJohnMacLean,CardStephaneRicher
	dc.l	CardScottStevens,CardScottNiedrmayer,CardRonHextall,CardPierreTurgeon
	dc.l	CardBenoitHogue,CardSteveThomas,CardDariusKasparitis,CardVladimirMalakhov
	dc.l	CardMikeRichter,CardMarkMessier,CardAdamGraves,CardSteveLarmer
	dc.l	CardBrianLeetch,CardSergeiZubov,CardCraigBillington,CardAlexnderDaigle
	dc.l	CardAlexeiYashin,CardSylvainTurgeon,CardNormMaciver,CardBradShaw
	dc.l	CardDominicRoussel,CardEricLindros,CardRodBrindAmour,CardMarkRecchi
	dc.l	CardGarryGalley,CardDimitriYushkevich,CardTomBarrasso,CardMarioLemieux
	dc.l	CardKevinStevens,CardJaromirJagr,CardUlfSamuelsson,CardLarryMurphy
	dc.l	CardStephaneFiset,CardJoeSakic,CardMatsSundin,CardValeriKamensky
	dc.l	CardCurtisLeschyshyn,CardAlexeiGusarov,CardArtursIrbe,CardIgorLarionov
	dc.l	CardUlfDahlen,CardSergeiMakarov,CardJeffNorton,CardSandisOzolinsh
	dc.l	CardCurtisJoseph,CardCraigJanney,CardBrendanShanahan,CardBrettHull
	dc.l	CardPhilHousley,CardSteveDuchesne,CardDarenPuppa,CardChrisGratton
	dc.l	CardBrianBradley,CardPetrKlima,CardRomanHamrlik,CardShawnChambers
	dc.l	CardFelixPotvin,CardDougGilmour,CardWendelClark,CardDaveAndreychuk
	dc.l	CardJamieMacoun,CardDaveEllett,CardKirkMcLean,CardCliffRonning
	dc.l	CardGeoffCourtnall,CardPavelBure,CardJyrkiLumme,CardJeffBrown
	dc.l	CardDonBeaupre,CardMikeRidley,CardJoeJuneau,CardDimitriKhristich
	dc.l	CardKevinHatcher,CardSylvainCote,CardTimCheveldae,CardAlexeiZhamnov
	dc.l	CardKeithTkachuk,CardTeemuSelanne,CardTeppoNumminen,CardDaveManson
	dc.l	NoPicSkater2,NoPicSkater1,NoPicGoalie1,NoPicGoalie2
Rinktilelist	;The ice rink map; Rinktilelist+8 = the rink tiles
	incbin	..\Extracted\NHL95\Graphics\Rinktilelist.map.jim
Sprites	;The sprite header: long offsets from here and (to frameSprData), then a word
	incbin	..\Extracted\NHL95\Graphics\Sprites.bin
Spritetiles	;The sprite tiles
	incbin	..\Extracted\NHL95\Graphics\Spritetiles.bin
frameSprData
	incbin	..\Extracted\NHL95\Graphics\frameSprData.bin
HotList	;The hot spot byte pair of each frame
	incbin	..\Extracted\NHL95\Graphics\HotSpotList.bin
RosterFont	;Data
	incbin	..\Extracted\NHL95\Graphics\RosterFont.bin
SmallFontMap	;The SmallFontMap map
	incbin	..\Extracted\NHL95\Graphics\SmallFontMap.map.jim
SmallFontMap2	;The SmallFontMap2 map
	incbin	..\Extracted\NHL95\Graphics\SmallFontMap2.map.jim
PauseBgBitmap	;The PauseBgBitmap map
	incbin	..\Extracted\NHL95\Graphics\PauseBgBitmap.map.jim
PeriodNumberBitmap	;The PeriodNumberBitmap map
	incbin	..\Extracted\NHL95\Graphics\PeriodNumberBitmap.map.jim
TabBitmap	;The TabBitmap map
	incbin	..\Extracted\NHL95\Graphics\TabBitmap.map.jim
PauseFontMap	;The PauseFontMap map
	incbin	..\Extracted\NHL95\Graphics\PauseFontMap.map.jim
ClockDigitsBitmap	;The ClockDigitsBitmap map
	incbin	..\Extracted\NHL95\Graphics\ClockDigitsBitmap.map.jim
RosterBitmap	;The RosterBitmap map
	incbin	..\Extracted\NHL95\Graphics\RosterBitmap.map.jim
Teamblocksmap	;The Teamblocksmap map
	incbin	..\Extracted\NHL95\Graphics\Teamblocksmap.map.jim
PauseTeamBlocksMap	;The PauseTeamBlocksMap map
	incbin	..\Extracted\NHL95\Graphics\PauseTeamBlocksMap.map.jim
FaceOffMap	;The face-off map; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\FaceOffMap.map.jim
FaceoffTiles	equ	FaceOffMap	;the same address
FaceOffSprites	;The face-off sprites; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\FaceOffSprites.map.jim
FaceoffTiles2	equ	FaceOffSprites	;the same address
Framermap	;The Framermap map
	incbin	..\Extracted\NHL95\Graphics\Framermap.map.jim
Framermap2	;The Framermap2 map
	incbin	..\Extracted\NHL95\Graphics\Framermap2.map.jim
EnergyBarMap	;The EnergyBarMap map
	incbin	..\Extracted\NHL95\Graphics\EnergyBarMap.map.jim
EASportsMap	;The EASportsMap map
	incbin	..\Extracted\NHL95\Graphics\EASportsMap.map.jim
RefTiles	;The RefTiles map
	incbin	..\Extracted\NHL95\Graphics\RefTiles.map.jim
RefTilesHor	;The RefTilesHor map
	incbin	..\Extracted\NHL95\Graphics\RefTilesHor.map.jim
SetupFont	;The SetupFont map
	incbin	..\Extracted\NHL95\Graphics\SetupFont.map.jim
SetupBgMap2	;The SetupBgMap2 map
	incbin	..\Extracted\NHL95\Graphics\SetupBgMap2.map.jim
SetupBgMap1	;The SetupBgMap1 map
	incbin	..\Extracted\NHL95\Graphics\SetupBgMap1.map.jim
TeamBitmaps	;The TeamBitmaps map
	incbin	..\Extracted\NHL95\Graphics\TeamBitmaps.map.jim
BigFontMap3	;The BigFontMap3 map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap3.map.jim
BigFontMap	;The BigFontMap map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap.map.jim
BigFontMap2	;The BigFontMap2 map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap2.map.jim
RevRinkTilelist	;Data
	incbin	..\Extracted\NHL95\Graphics\RevRinkTilelist.bin
ReplayMap	;The ReplayMap map
	incbin	..\Extracted\NHL95\Graphics\ReplayMap.map.jim
ReplayIconMap	;The ReplayIconMap map
	incbin	..\Extracted\NHL95\Graphics\ReplayIconMap.map.jim
HiScoreBgMap	;The HiScoreBgMap map
	incbin	..\Extracted\NHL95\Graphics\HiScoreBgMap.map.jim
HiScoreImg	;The HiScoreImg map
	incbin	..\Extracted\NHL95\Graphics\HiScoreImg.map.jim
ControllerBgMap	;The ControllerBgMap map
	incbin	..\Extracted\NHL95\Graphics\ControllerBgMap.map.jim
GamesTodayLogoMap	;The GamesTodayLogoMap map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayLogoMap.map.jim
GamesTodayMap1	;The GamesTodayMap1 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap1.map.jim
GamesTodayMap2	;The GamesTodayMap2 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap2.map.jim
GamesTodayMap3	;The GamesTodayMap3 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap3.map.jim
CalendarBgMap	;The CalendarBgMap map
	incbin	..\Extracted\NHL95\Graphics\CalendarBgMap.map.jim
CalOpponentMap	;The CalOpponentMap map
	incbin	..\Extracted\NHL95\Graphics\CalOpponentMap.map.jim
CalDayMap	;The CalDayMap map
	incbin	..\Extracted\NHL95\Graphics\CalDayMap.map.jim
CalMonthMap	;The CalMonthMap map
	incbin	..\Extracted\NHL95\Graphics\CalMonthMap.map.jim
CalCheckMap	;Data
	incbin	..\Extracted\NHL95\Graphics\CalCheckMap.bin
CalResultMap	;The CalResultMap map
	incbin	..\Extracted\NHL95\Graphics\CalResultMap.map.jim
ControllerTitleMap	;The ControllerTitleMap map
	incbin	..\Extracted\NHL95\Graphics\ControllerTitleMap.map.jim
PadCursorMap	;The PadCursorMap map
	incbin	..\Extracted\NHL95\Graphics\PadCursorMap.map.jim
PadIconMap1	;The PadIconMap1 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap1.map.jim
PadIconMap2	;The PadIconMap2 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap2.map.jim
PadIconMap3	;The PadIconMap3 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap3.map.jim
PadIconMap4	;The PadIconMap4 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap4.map.jim
PlayerStatsBgMap	;The PlayerStatsBgMap map
	incbin	..\Extracted\NHL95\Graphics\PlayerStatsBgMap.map.jim
PlayerStatsTitleMap	;The PlayerStatsTitleMap map
	incbin	..\Extracted\NHL95\Graphics\PlayerStatsTitleMap.map.jim
PeriodStatsMap	;The PeriodStatsMap map
	incbin	..\Extracted\NHL95\Graphics\PeriodStatsMap.map.jim
HighlightsBgMap	;The HighlightsBgMap map
	incbin	..\Extracted\NHL95\Graphics\HighlightsBgMap.map.jim
WaitBoxMap	;The WaitBoxMap map
	incbin	..\Extracted\NHL95\Graphics\WaitBoxMap.map.jim
LineEditorBgMap	;The LineEditorBgMap map
	incbin	..\Extracted\NHL95\Graphics\LineEditorBgMap.map.jim
Screen6Tiles1	equ	LineEditorBgMap+8	;the tiles
PlayerSelectMap2	;The PlayerSelectMap2 map
	incbin	..\Extracted\NHL95\Graphics\PlayerSelectMap2.map.jim
Screen6Tiles2	equ	PlayerSelectMap2+8	;the tiles
PlayerSelectMap1	;The PlayerSelectMap1 map
	incbin	..\Extracted\NHL95\Graphics\PlayerSelectMap1.map.jim
CreateBgMap	;The CreateBgMap map
	incbin	..\Extracted\NHL95\Graphics\CreateBgMap.map.jim
TradeBgMap	;The TradeBgMap map
	incbin	..\Extracted\NHL95\Graphics\TradeBgMap.map.jim
AwardsBgMap	;The AwardsBgMap map
	incbin	..\Extracted\NHL95\Graphics\AwardsBgMap.map.jim
FinalistsPanelMap	;The FinalistsPanelMap map
	incbin	..\Extracted\NHL95\Graphics\FinalistsPanelMap.map.jim
WinnerPanelMap	;The WinnerPanelMap map
	incbin	..\Extracted\NHL95\Graphics\WinnerPanelMap.map.jim
HartPic	;The HartPic map
	incbin	..\Extracted\NHL95\Graphics\HartPic.map.jim
NorrisPic	;The NorrisPic map
	incbin	..\Extracted\NHL95\Graphics\NorrisPic.map.jim
VezinaPic	;The VezinaPic map
	incbin	..\Extracted\NHL95\Graphics\VezinaPic.map.jim
ArtRossPic	;The ArtRossPic map
	incbin	..\Extracted\NHL95\Graphics\ArtRossPic.map.jim
SelkePic	;The SelkePic map
	incbin	..\Extracted\NHL95\Graphics\SelkePic.map.jim
JenningsPic	;The JenningsPic map
	incbin	..\Extracted\NHL95\Graphics\JenningsPic.map.jim
PresidentsPic	;The PresidentsPic map
	incbin	..\Extracted\NHL95\Graphics\PresidentsPic.map.jim
ConnSmythePic	;The ConnSmythePic map
	incbin	..\Extracted\NHL95\Graphics\ConnSmythePic.map.jim
PearsonPic	;The PearsonPic map
	incbin	..\Extracted\NHL95\Graphics\PearsonPic.map.jim
EASNmap	;The EASNmap map
	incbin	..\Extracted\NHL95\Graphics\EASNmap.map.jim
GMDecisionMap	;The GMDecisionMap map
	incbin	..\Extracted\NHL95\Graphics\GMDecisionMap.map.jim
FreeAgentMap2	;The FreeAgentMap2 map
	incbin	..\Extracted\NHL95\Graphics\FreeAgentMap2.map.jim
FreeAgentMap1	;The FreeAgentMap1 map
	incbin	..\Extracted\NHL95\Graphics\FreeAgentMap1.map.jim
TradeAdvantageMap2	;The TradeAdvantageMap2 map
	incbin	..\Extracted\NHL95\Graphics\TradeAdvantageMap2.map.jim
TradeAdvantageMap1	;The TradeAdvantageMap1 map
	incbin	..\Extracted\NHL95\Graphics\TradeAdvantageMap1.map.jim
NameEntryBgMap	;The NameEntryBgMap map
	incbin	..\Extracted\NHL95\Graphics\NameEntryBgMap.map.jim
Arrowsmap	;The Arrowsmap map
	incbin	..\Extracted\NHL95\Graphics\Arrowsmap.map.jim
ScoutMap	;The ScoutMap map
	incbin	..\Extracted\NHL95\Graphics\ScoutMap.map.jim
PlayoffSprite	;The PlayoffSprite map
	incbin	..\Extracted\NHL95\Graphics\PlayoffSprite.map.jim
ScoutReportMap	;The ScoutReportMap map
	incbin	..\Extracted\NHL95\Graphics\ScoutReportMap.map.jim
HotIconMap	;The HotIconMap map
	incbin	..\Extracted\NHL95\Graphics\HotIconMap.map.jim
ColdIconMap	;The ColdIconMap map
	incbin	..\Extracted\NHL95\Graphics\ColdIconMap.map.jim
RonBarrMap	;The RonBarrMap map
	incbin	..\Extracted\NHL95\Graphics\RonBarrMap.map.jim
CrowdFrameList	;The crowd sprites; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\CrowdFrameList.map.jim
TitleScreenImg	;The TitleScreenImg map
	incbin	..\Extracted\NHL95\Graphics\TitleScreenImg.map.jim
TitleImg	;The TitleImg map
	incbin	..\Extracted\NHL95\Graphics\TitleImg.map.jim
StanleyCupImg	;The StanleyCupImg map
	incbin	..\Extracted\NHL95\Graphics\StanleyCupImg.map.jim
CupSprites	;The CupSprites map
	incbin	..\Extracted\NHL95\Graphics\CupSprites.map.jim
logoANH	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoANA.map.jim
logoBOS	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoBOS.map.jim
logoBUF	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoBUF.map.jim
logoCGY	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoCGY.map.jim
logoCHI	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoCHI.map.jim
logoDET	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoDET.map.jim
logoEDM	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoEDM.map.jim
logoFLA	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoFLA.map.jim
logoHFD	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoHFD.map.jim
logoNYI	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNYI.map.jim
logoLA	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoLA.map.jim
logoDAL	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoDAL.map.jim
logoMTL	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoMTL.map.jim
logoNJ	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNJ.map.jim
logoNYR	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNYR.map.jim
logoOTW	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoOTW.map.jim
logoPHI	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoPHI.map.jim
logoPIT	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoPIT.map.jim
logoQUE	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoQUE.map.jim
logoSJ	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoSJ.map.jim
logoSTL	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoSTL.map.jim
logoTB	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoTB.map.jim
logoTOR	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoTOR.map.jim
logoVAN	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoVAN.map.jim
logoWSH	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoWSH.map.jim
logoWPG	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoWPG.map.jim
logoASE	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoASE.map.jim
logoASW	;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoASW.map.jim

;------------------------------------------------------------------------------------------------------------------------
;	TeamLogoPalettes, one 32 byte palette per team in TeamList order. 25 are unchanged from 94; DAL, ASE and ASW
;	are new.

TeamLogoPalettes	;Team logo palettes, 16 colors per team (DrawMatchupLogo, NameEntryScreen, DrawTeamBitmap)
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalANHA.pal	;ANH, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalBOS.pal	;BOS, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalBUFA.pal	;BUF, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalCGYA.pal	;CGY, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalCHIA.pal	;CHI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalDALA95.pal	;DAL, new palette
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalDETA.pal	;DET, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalEDMA.pal	;EDM, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalFLA.pal	;FLA, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalHFD.pal	;HFD, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalLAA.pal	;LA, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalMTLA.pal	;MTL, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNJA.pal	;NJ, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNYIA.pal	;NYI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNYRA.pal	;NYR, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalOTWA.pal	;OTW, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalPHIA.pal	;PHI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalPITA.pal	;PIT, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalQUEA.pal	;QUE, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalSJ.pal	;SJ, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalSTLA.pal	;STL, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalTBA.pal	;TB, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalTORA.pal	;TOR, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalVANA.pal	;VAN, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalWSHA.pal	;WSH, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalWPGA.pal	;WPG, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalASEA95.pal	;ASE, new palette
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalASWA95.pal	;ASW, new palette

;------------------------------------------------------------------------------------------------------------------------
;	ArenaGfxBank: the home team graphics LoadHomeTeamGfx loads, $30A bytes per team, read through
;	TeamGfxList (TeamList order; ASE and ASW share one). One incbin per team in bank order.

ArenaGfxBank	;LoadHomeTeamGfx: one block of $30A bytes per team (TeamGfxList)
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxANH.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxBUF.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxCGY.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxCHI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxDAL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxDET.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxEDM.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxFLA.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxHFD.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxLA.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxMTL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNJ.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNYI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNYR.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxOTW.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxPHI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxPIT.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxQUE.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxSJ.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxSTL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxTB.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxTOR.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxVAN.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxWSH.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxWPG.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxBOS.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxASEASW.bin
