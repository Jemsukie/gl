package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class EmbeddedAssets implements IEventDispatcher
   {
      
      private static var FontEsparragon#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-974332693§;
      
      private static var FontEsparragon2#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-723081117§;
      
      private static var LoadingScreenFirstTime#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1427535892;
      
      private static var LoadingAnim#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c151523281;
      
      private static var LayoutHudTop#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c725184361;
      
      private static var LayoutHudLeft#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-469349743§;
      
      private static var LayoutHudTopVisiting#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1833849410;
      
      private static var LayoutHudLeftVisiting#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-590563766§;
      
      private static var LayoutHudTopReplay#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-313237998§;
      
      private static var LayoutHudTopSpying#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-283089453§;
      
      private static var LayoutHudLeftSpying#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2127140901§;
      
      private static var LayoutHudRight#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c209433362;
      
      private static var LayoutHudBottom#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2144365579§;
      
      private static var LayoutHudBottomSmall#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1272977454§;
      
      private static var LayoutHudBottomShop#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-413341713§;
      
      private static var LayoutHudBottomShipyard#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2082132369§;
      
      private static var LayoutHudBottomAttack#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1479159261;
      
      private static var LayoutHudBottomUnits#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1271782086§;
      
      private static var LayoutHudBottomUnitsSmall#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1217207219§;
      
      private static var LayoutHudBottomMercenaries#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c190252125;
      
      private static var LayoutHudNavigationTab#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1338665515§;
      
      private static var MissionDropDownHud#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c484093759;
      
      private static var OptionsDropDownHud#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-53926967§;
      
      private static var LayoutHudCollectionContainer#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c95996603;
      
      private static var LayoutHudLootingInfo#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c84740414;
      
      private static var LayoutHudBattleTimer#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1136645247§;
      
      private static var LayoutHudEmptyDropDown#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-319314544§;
      
      private static var LayoutHudEmptyDropDownArrowUp#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c327015058;
      
      private static var IconBarHudL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c445107214;
      
      private static var IconBarHudM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c445107213;
      
      private static var IconBarHudMNoBtn#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c31394894;
      
      private static var IconBarHudLNoBtn#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c128242861;
      
      private static var IconBarHudS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c445107255;
      
      private static var IconMissionHud#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c852874085;
      
      private static var NavigationBarHud#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c336259577;
      
      private static var NavigationInfoHud#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1427091504;
      
      private static var NotificationAreaHud#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1140769090§;
      
      private static var LayoutSolarSystem#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1297550553§;
      
      private static var PopXL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c472907616;
      
      private static var PopXLTabs#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c170592386;
      
      private static var PopXLTabsNoFooter#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-696472706§;
      
      private static var PopXLNoTabsNoFooter#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1161512163§;
      
      private static var PopL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1877422590;
      
      private static var PopLTabs#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1483970584;
      
      private static var PopM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1877422589;
      
      private static var PopS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1877422567;
      
      private static var PopBetting#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c193484755;
      
      private static var BetBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-394386721§;
      
      private static var PopBattle#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c778032324;
      
      private static var PopVictory#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1676205248;
      
      private static var BetResultsVictoryBar#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1127608683;
      
      private static var BetResultsBattleBar#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c57738391;
      
      private static var ContainerResults#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1755574252§;
      
      private static var ContainerResultsMatch#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2014221843§;
      
      private static var PopMissionComplete#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-612004683§;
      
      private static var PopMission#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1203767970§;
      
      private static var PopMissionBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-4651987§;
      
      private static var PopupChipsShop#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1346915920;
      
      private static var BoxChips#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-11348867§;
      
      private static var TextPrice#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1941263001;
      
      private static var TextPriceOffer#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c745663713;
      
      private static var TextPriceOfferDiscount#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c943756608;
      
      private static var LayoutPopupInstructions#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1283175750;
      
      private static var LayoutPopupCreateAlliance#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1133390576§;
      
      private static var LayoutPopupEditAlliance#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c2054388226;
      
      private static var LayoutBodyJoinAlliance#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-541203252§;
      
      private static var LayoutBodyAllianceHeadQuarter#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-61941308§;
      
      private static var LayoutBodyAllianceMembers#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1169327063;
      
      private static var LayoutBodyAllianceWar#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1027355648;
      
      private static var LayoutBodyAllianceLeaderboard#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c213938875;
      
      private static var LayoutBodyAllianceRewards#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1085884964§;
      
      private static var LayoutAllianceRewardBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-538827878§;
      
      private static var LayoutAlliancePageNews#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c860866534;
      
      private static var LayoutNotificationAlliances#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1631215290§;
      
      private static var LayoutAllianceWarSuggested#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1465251229;
      
      private static var LayoutBattleSummary#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c673221537;
      
      private static var LayoutPreAttack#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1713836732;
      
      private static var BtnXXL#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-380814127§;
      
      private static var BtnXL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c602016173;
      
      private static var BtnL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1876855889;
      
      private static var BtnM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1876855888;
      
      private static var BtnS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1876855898;
      
      private static var BtnXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c602016214;
      
      private static var BtnHUDL#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-261047156§;
      
      private static var BtnHUDM#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-261047117§;
      
      private static var IBtnXXL#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-707687372§;
      
      private static var IBtnXL#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-495330646§;
      
      private static var IBtnL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c599193332;
      
      private static var IBtnM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c599193339;
      
      private static var IBtnS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c599193341;
      
      private static var IBtnXS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-495330605§;
      
      private static var IBtnINSIDE#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1028993966§;
      
      private static var IBtnHUD#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-707671903§;
      
      private static var IBtnHUDICONAREA#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-969739733§;
      
      private static var TabHeader#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-420984605§;
      
      private static var BtnImgM#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-260052409§;
      
      private static var IconTextXL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c338852895;
      
      private static var IconTextL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c123468583;
      
      private static var IconTextLLarge#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1210546548;
      
      private static var IconTextM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c123468582;
      
      private static var IconTextMLarge#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1246990357;
      
      private static var IconTextS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c123468584;
      
      private static var IconTextSLarge#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1139372845§;
      
      private static var IconTextXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c338852864;
      
      private static var IconTwoTextsXS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-153305037§;
      
      private static var HIconTwoTextsXS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-119816361§;
      
      private static var IconTextXSLarge#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1586989829§;
      
      private static var IconBarL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c774078359;
      
      private static var IconBarM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c774078358;
      
      private static var IconBarS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c774078360;
      
      private static var IconBarXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c106663376;
      
      private static var IconBarXXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c902117528;
      
      private static var ProfileRes#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1060136090;
      
      private static var ProfileExtended#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2077205533§;
      
      private static var ProfileExtendedPlanet#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1266417221§;
      
      private static var ProfileBasic#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1029459908;
      
      private static var ProductionBar#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-560526053§;
      
      private static var Pagination#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1362225153§;
      
      private static var BoxUnits#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-128880091§;
      
      private static var BoxUnitsButtons#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1962733432;
      
      private static var BoxUnitsButtonsSmall#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-691170993§;
      
      private static var BoxFriendButton#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c492782810;
      
      private static var BoxFriendHelp#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1063288181§;
      
      private static var BoxCrafting#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c173747592;
      
      private static var BoxInventory#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2145109072§;
      
      private static var BoxReward#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2058084773§;
      
      private static var BoxColony#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1673158656§;
      
      private static var BoxColonyS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1545563315;
      
      private static var BoxColonyXS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1762902435§;
      
      private static var BoxGalaxy#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1705522630§;
      
      private static var ContainerItem#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-925821263§;
      
      private static var ContainerItemS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1569540894§;
      
      private static var ContainerItemButtonIcon#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1759781346§;
      
      private static var ContainerItemButtonIconSmall#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1522769129;
      
      private static var ContainerItemButtonIconLarge#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1515873853;
      
      private static var ContainerItemVerticalL#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c55384839;
      
      private static var ContainerItemVerticalM#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c55384838;
      
      private static var ContainerItemVerticalS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c55384840;
      
      private static var ContainerItemVerticalXS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1643884512§;
      
      private static var TextFieldAnimation#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1780432538;
      
      private static var ContainerStripeL#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-977165661§;
      
      private static var ContainerStripeS#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-977165660§;
      
      private static var ContainerStripeXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c185902340;
      
      private static var ContainerStripeSHigher#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1764117899§;
      
      private static var CenterIconTextXS#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1136648155;
      
      private static var StripeAlliancesLeaderBoard#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1657876723;
      
      private static var SkinInventoryBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1697267795§;
      
      private static var ContainerTextField#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1129405581;
      
      private static var ContainerTextField2#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1609060167;
      
      private static var ContainerTextField3#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1609060166;
      
      private static var ContainerTextTextIcon#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c202005809;
      
      private static var ContainerTextFieldIcon3#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c708185551;
      
      private static var ContainerTextIcons#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1132112557;
      
      private static var ContainerImgText#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-407464782§;
      
      private static var ContainerSpeechIcons#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-599661062§;
      
      private static var PopSpeech#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c329264146;
      
      private static var PopSpeechRight#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-301463416§;
      
      private static var PopNotifications#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-846752006§;
      
      private static var PopNotificationsIcons#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-331051870§;
      
      private static var PopNotificationsMedium#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c186817965;
      
      private static var PopNotificaionFeedBack#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1011982916;
      
      private static var LayoutContainerColonizeRequirements#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-846247207§;
      
      private static var LayoutColonized#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1744035904;
      
      private static var LayoutMoveColonies#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1586234698§;
      
      private static var LayoutSystemVisit#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1683616339;
      
      private static var BodyAmbassador#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1305536630;
      
      private static var StripeContestLeaderboard#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1484780069§;
      
      private static var StripeContestRewards#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1447997692;
      
      private static var ContestLeaderboardHeader#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1819083621§;
      
      private static var ContestRewardsHeader#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-916629508§;
      
      private static var PopupLayoutOffer#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1945450549§;
      
      private static var PopupLayoutOneTimeOffer#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2115715618§;
      
      private static var PopupLayoutInventory#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1227282741§;
      
      private static var PopupLayoutHangarUnits#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-461061733§;
      
      private static var PopupLayoutHangarEmpty#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-341404555§;
      
      private static var PopupLayoutBunker#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c2018968594;
      
      private static var PopupLayoutBunkerFriends#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-180036281§;
      
      private static var PopupLayoutLab#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c611315994;
      
      private static var CurrentUpgradingUnit#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-458328635§;
      
      private static var PopupLayoutLabInfo#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c275088708;
      
      private static var ContainerRequirements#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c668165132;
      
      private static var ContainerRequirements2Items#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1539477662;
      
      private static var ContainerCost#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-925572529§;
      
      private static var ContainerChips#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1583569173§;
      
      private static var ContainerUnitInfo#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2036735630§;
      
      private static var WarningStripe#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-504605852§;
      
      private static var DiscountBox#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c2090703275;
      
      private static var HQInfoBox#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1133569425;
      
      private static var ContainerUnlock#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c15469056;
      
      private static var SpecialInfoBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-664332155§;
      
      private static var PremiumShopPageClock#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1223622089§;
      
      private static var PremiumShopPage#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c295291673;
      
      private static var PremiumShopPageOffer#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1212431263§;
      
      private static var PremiumShopItemBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1655170482§;
      
      private static var PremiumShopItemBoxShield#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1864411189;
      
      private static var PremiumShopOffersBox#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-261229558§;
      
      private static var PremiumShopHeaderText#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c404310150;
      
      private static var PremiumShopHeaderTextBtn#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c264799380;
      
      private static var PopupShopResources#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-349105466§;
      
      private static var TooltipTextfieldTitle#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2039112017§;
      
      private static var TooltipTextfieldText#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-4823462§;
      
      private static var TooltipHudText#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-999371136§;
      
      private static var TooltipHudShop#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-999409329§;
      
      private static var TooltipHudShopNoProtection#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-592726043§;
      
      private static var LayoutInvestNegotiation#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1241344893§;
      
      private static var LayoutInvestGraduated#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1550007045§;
      
      private static var LayoutInvestTrainees#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c378863727;
      
      private static var StripeInvestments#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1963219982§;
      
      private static var LayoutHappeningsPopupAttack#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c821619222;
      
      private static var LayoutHappeningsPopupEnd#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1491657427§;
      
      private static var LayoutHappeningsInitialKit#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-1939581710§;
      
      private static var LayoutHappeningsAntiZombieKit#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c710204204;
      
      private static var LayoutHappeningsIconUnit#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c2071808095;
      
      private static var LayoutHappeningsBirthdayInitial#1528:Class = §Stars_swf$de9dc153578c056528c630561583ec3c-2429077§;
      
      private static var LayoutHappeningsWinterProgress#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1217057938;
      
      private static var PopPassFriendScore#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c888492439;
      
      private static var StripeFriendPassed#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1382281214;
      
      private static var LayoutLoadingScreen#1528:Class = Stars_swf$de9dc153578c056528c630561583ec3c1836059327;
      
      private static var _bindingEventDispatcher:EventDispatcher = new EventDispatcher();
       
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function EmbeddedAssets()
      {
         this._bindingEventDispatcher = new EventDispatcher(this);
         super();
      }
      
      [Bindable]
      public static function get FontEsparragon#1() : Class
      {
         return EmbeddedAssets.FontEsparragon#1528;
      }
      
      public static function set FontEsparragon#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.FontEsparragon#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.FontEsparragon#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"FontEsparragon",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get FontEsparragon2#1() : Class
      {
         return EmbeddedAssets.FontEsparragon2#1528;
      }
      
      public static function set FontEsparragon2#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.FontEsparragon2#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.FontEsparragon2#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"FontEsparragon2",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LoadingScreenFirstTime#1() : Class
      {
         return EmbeddedAssets.LoadingScreenFirstTime#1528;
      }
      
      public static function set LoadingScreenFirstTime#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LoadingScreenFirstTime#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LoadingScreenFirstTime#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LoadingScreenFirstTime",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LoadingAnim#1() : Class
      {
         return EmbeddedAssets.LoadingAnim#1528;
      }
      
      public static function set LoadingAnim#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LoadingAnim#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LoadingAnim#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LoadingAnim",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudTop#1() : Class
      {
         return EmbeddedAssets.LayoutHudTop#1528;
      }
      
      public static function set LayoutHudTop#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudTop#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudTop#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudTop",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudLeft#1() : Class
      {
         return EmbeddedAssets.LayoutHudLeft#1528;
      }
      
      public static function set LayoutHudLeft#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudLeft#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudLeft#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudLeft",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudTopVisiting#1() : Class
      {
         return EmbeddedAssets.LayoutHudTopVisiting#1528;
      }
      
      public static function set LayoutHudTopVisiting#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudTopVisiting#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudTopVisiting#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudTopVisiting",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudLeftVisiting#1() : Class
      {
         return EmbeddedAssets.LayoutHudLeftVisiting#1528;
      }
      
      public static function set LayoutHudLeftVisiting#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudLeftVisiting#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudLeftVisiting#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudLeftVisiting",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudTopReplay#1() : Class
      {
         return EmbeddedAssets.LayoutHudTopReplay#1528;
      }
      
      public static function set LayoutHudTopReplay#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudTopReplay#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudTopReplay#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudTopReplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudTopSpying#1() : Class
      {
         return EmbeddedAssets.LayoutHudTopSpying#1528;
      }
      
      public static function set LayoutHudTopSpying#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudTopSpying#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudTopSpying#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudTopSpying",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudLeftSpying#1() : Class
      {
         return EmbeddedAssets.LayoutHudLeftSpying#1528;
      }
      
      public static function set LayoutHudLeftSpying#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudLeftSpying#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudLeftSpying#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudLeftSpying",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudRight#1() : Class
      {
         return EmbeddedAssets.LayoutHudRight#1528;
      }
      
      public static function set LayoutHudRight#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudRight#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudRight#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudRight",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottom#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottom#1528;
      }
      
      public static function set LayoutHudBottom#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottom#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottom#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottom",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomSmall#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomSmall#1528;
      }
      
      public static function set LayoutHudBottomSmall#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomSmall#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomSmall#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomSmall",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomShop#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomShop#1528;
      }
      
      public static function set LayoutHudBottomShop#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomShop#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomShop#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomShop",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomShipyard#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomShipyard#1528;
      }
      
      public static function set LayoutHudBottomShipyard#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomShipyard#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomShipyard#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomShipyard",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomAttack#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomAttack#1528;
      }
      
      public static function set LayoutHudBottomAttack#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomAttack#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomAttack#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomAttack",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomUnits#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomUnits#1528;
      }
      
      public static function set LayoutHudBottomUnits#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomUnits#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomUnits#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomUnits",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomUnitsSmall#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomUnitsSmall#1528;
      }
      
      public static function set LayoutHudBottomUnitsSmall#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomUnitsSmall#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomUnitsSmall#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomUnitsSmall",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBottomMercenaries#1() : Class
      {
         return EmbeddedAssets.LayoutHudBottomMercenaries#1528;
      }
      
      public static function set LayoutHudBottomMercenaries#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBottomMercenaries#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBottomMercenaries#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBottomMercenaries",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudNavigationTab#1() : Class
      {
         return EmbeddedAssets.LayoutHudNavigationTab#1528;
      }
      
      public static function set LayoutHudNavigationTab#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudNavigationTab#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudNavigationTab#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudNavigationTab",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get MissionDropDownHud#1() : Class
      {
         return EmbeddedAssets.MissionDropDownHud#1528;
      }
      
      public static function set MissionDropDownHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.MissionDropDownHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.MissionDropDownHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"MissionDropDownHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get OptionsDropDownHud#1() : Class
      {
         return EmbeddedAssets.OptionsDropDownHud#1528;
      }
      
      public static function set OptionsDropDownHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.OptionsDropDownHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.OptionsDropDownHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"OptionsDropDownHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudCollectionContainer#1() : Class
      {
         return EmbeddedAssets.LayoutHudCollectionContainer#1528;
      }
      
      public static function set LayoutHudCollectionContainer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudCollectionContainer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudCollectionContainer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudCollectionContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudLootingInfo#1() : Class
      {
         return EmbeddedAssets.LayoutHudLootingInfo#1528;
      }
      
      public static function set LayoutHudLootingInfo#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudLootingInfo#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudLootingInfo#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudLootingInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudBattleTimer#1() : Class
      {
         return EmbeddedAssets.LayoutHudBattleTimer#1528;
      }
      
      public static function set LayoutHudBattleTimer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudBattleTimer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudBattleTimer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudBattleTimer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudEmptyDropDown#1() : Class
      {
         return EmbeddedAssets.LayoutHudEmptyDropDown#1528;
      }
      
      public static function set LayoutHudEmptyDropDown#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudEmptyDropDown#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudEmptyDropDown#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudEmptyDropDown",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHudEmptyDropDownArrowUp#1() : Class
      {
         return EmbeddedAssets.LayoutHudEmptyDropDownArrowUp#1528;
      }
      
      public static function set LayoutHudEmptyDropDownArrowUp#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHudEmptyDropDownArrowUp#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHudEmptyDropDownArrowUp#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHudEmptyDropDownArrowUp",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarHudL#1() : Class
      {
         return EmbeddedAssets.IconBarHudL#1528;
      }
      
      public static function set IconBarHudL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarHudL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarHudL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarHudL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarHudM#1() : Class
      {
         return EmbeddedAssets.IconBarHudM#1528;
      }
      
      public static function set IconBarHudM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarHudM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarHudM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarHudM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarHudMNoBtn#1() : Class
      {
         return EmbeddedAssets.IconBarHudMNoBtn#1528;
      }
      
      public static function set IconBarHudMNoBtn#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarHudMNoBtn#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarHudMNoBtn#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarHudMNoBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarHudLNoBtn#1() : Class
      {
         return EmbeddedAssets.IconBarHudLNoBtn#1528;
      }
      
      public static function set IconBarHudLNoBtn#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarHudLNoBtn#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarHudLNoBtn#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarHudLNoBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarHudS#1() : Class
      {
         return EmbeddedAssets.IconBarHudS#1528;
      }
      
      public static function set IconBarHudS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarHudS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarHudS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarHudS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconMissionHud#1() : Class
      {
         return EmbeddedAssets.IconMissionHud#1528;
      }
      
      public static function set IconMissionHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconMissionHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconMissionHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconMissionHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get NavigationBarHud#1() : Class
      {
         return EmbeddedAssets.NavigationBarHud#1528;
      }
      
      public static function set NavigationBarHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.NavigationBarHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.NavigationBarHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"NavigationBarHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get NavigationInfoHud#1() : Class
      {
         return EmbeddedAssets.NavigationInfoHud#1528;
      }
      
      public static function set NavigationInfoHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.NavigationInfoHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.NavigationInfoHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"NavigationInfoHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get NotificationAreaHud#1() : Class
      {
         return EmbeddedAssets.NotificationAreaHud#1528;
      }
      
      public static function set NotificationAreaHud#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.NotificationAreaHud#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.NotificationAreaHud#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"NotificationAreaHud",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutSolarSystem#1() : Class
      {
         return EmbeddedAssets.LayoutSolarSystem#1528;
      }
      
      public static function set LayoutSolarSystem#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutSolarSystem#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutSolarSystem#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutSolarSystem",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopXL#1() : Class
      {
         return EmbeddedAssets.PopXL#1528;
      }
      
      public static function set PopXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopXLTabs#1() : Class
      {
         return EmbeddedAssets.PopXLTabs#1528;
      }
      
      public static function set PopXLTabs#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopXLTabs#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopXLTabs#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopXLTabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopXLTabsNoFooter#1() : Class
      {
         return EmbeddedAssets.PopXLTabsNoFooter#1528;
      }
      
      public static function set PopXLTabsNoFooter#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopXLTabsNoFooter#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopXLTabsNoFooter#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopXLTabsNoFooter",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopXLNoTabsNoFooter#1() : Class
      {
         return EmbeddedAssets.PopXLNoTabsNoFooter#1528;
      }
      
      public static function set PopXLNoTabsNoFooter#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopXLNoTabsNoFooter#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopXLNoTabsNoFooter#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopXLNoTabsNoFooter",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopL#1() : Class
      {
         return EmbeddedAssets.PopL#1528;
      }
      
      public static function set PopL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopLTabs#1() : Class
      {
         return EmbeddedAssets.PopLTabs#1528;
      }
      
      public static function set PopLTabs#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopLTabs#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopLTabs#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopLTabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopM#1() : Class
      {
         return EmbeddedAssets.PopM#1528;
      }
      
      public static function set PopM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopS#1() : Class
      {
         return EmbeddedAssets.PopS#1528;
      }
      
      public static function set PopS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopBetting#1() : Class
      {
         return EmbeddedAssets.PopBetting#1528;
      }
      
      public static function set PopBetting#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopBetting#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopBetting#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopBetting",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BetBox#1() : Class
      {
         return EmbeddedAssets.BetBox#1528;
      }
      
      public static function set BetBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BetBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BetBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BetBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopBattle#1() : Class
      {
         return EmbeddedAssets.PopBattle#1528;
      }
      
      public static function set PopBattle#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopBattle#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopBattle#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopBattle",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopVictory#1() : Class
      {
         return EmbeddedAssets.PopVictory#1528;
      }
      
      public static function set PopVictory#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopVictory#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopVictory#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopVictory",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BetResultsVictoryBar#1() : Class
      {
         return EmbeddedAssets.BetResultsVictoryBar#1528;
      }
      
      public static function set BetResultsVictoryBar#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BetResultsVictoryBar#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BetResultsVictoryBar#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BetResultsVictoryBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BetResultsBattleBar#1() : Class
      {
         return EmbeddedAssets.BetResultsBattleBar#1528;
      }
      
      public static function set BetResultsBattleBar#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BetResultsBattleBar#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BetResultsBattleBar#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BetResultsBattleBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerResults#1() : Class
      {
         return EmbeddedAssets.ContainerResults#1528;
      }
      
      public static function set ContainerResults#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerResults#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerResults#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerResults",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerResultsMatch#1() : Class
      {
         return EmbeddedAssets.ContainerResultsMatch#1528;
      }
      
      public static function set ContainerResultsMatch#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerResultsMatch#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerResultsMatch#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerResultsMatch",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopMissionComplete#1() : Class
      {
         return EmbeddedAssets.PopMissionComplete#1528;
      }
      
      public static function set PopMissionComplete#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopMissionComplete#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopMissionComplete#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopMissionComplete",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopMission#1() : Class
      {
         return EmbeddedAssets.PopMission#1528;
      }
      
      public static function set PopMission#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopMission#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopMission#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopMission",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopMissionBox#1() : Class
      {
         return EmbeddedAssets.PopMissionBox#1528;
      }
      
      public static function set PopMissionBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopMissionBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopMissionBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopMissionBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupChipsShop#1() : Class
      {
         return EmbeddedAssets.PopupChipsShop#1528;
      }
      
      public static function set PopupChipsShop#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupChipsShop#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupChipsShop#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupChipsShop",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxChips#1() : Class
      {
         return EmbeddedAssets.BoxChips#1528;
      }
      
      public static function set BoxChips#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxChips#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxChips#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxChips",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TextPrice#1() : Class
      {
         return EmbeddedAssets.TextPrice#1528;
      }
      
      public static function set TextPrice#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TextPrice#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TextPrice#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TextPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TextPriceOffer#1() : Class
      {
         return EmbeddedAssets.TextPriceOffer#1528;
      }
      
      public static function set TextPriceOffer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TextPriceOffer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TextPriceOffer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TextPriceOffer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TextPriceOfferDiscount#1() : Class
      {
         return EmbeddedAssets.TextPriceOfferDiscount#1528;
      }
      
      public static function set TextPriceOfferDiscount#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TextPriceOfferDiscount#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TextPriceOfferDiscount#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TextPriceOfferDiscount",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutPopupInstructions#1() : Class
      {
         return EmbeddedAssets.LayoutPopupInstructions#1528;
      }
      
      public static function set LayoutPopupInstructions#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutPopupInstructions#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutPopupInstructions#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutPopupInstructions",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutPopupCreateAlliance#1() : Class
      {
         return EmbeddedAssets.LayoutPopupCreateAlliance#1528;
      }
      
      public static function set LayoutPopupCreateAlliance#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutPopupCreateAlliance#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutPopupCreateAlliance#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutPopupCreateAlliance",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutPopupEditAlliance#1() : Class
      {
         return EmbeddedAssets.LayoutPopupEditAlliance#1528;
      }
      
      public static function set LayoutPopupEditAlliance#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutPopupEditAlliance#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutPopupEditAlliance#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutPopupEditAlliance",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyJoinAlliance#1() : Class
      {
         return EmbeddedAssets.LayoutBodyJoinAlliance#1528;
      }
      
      public static function set LayoutBodyJoinAlliance#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyJoinAlliance#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyJoinAlliance#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyJoinAlliance",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyAllianceHeadQuarter#1() : Class
      {
         return EmbeddedAssets.LayoutBodyAllianceHeadQuarter#1528;
      }
      
      public static function set LayoutBodyAllianceHeadQuarter#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyAllianceHeadQuarter#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyAllianceHeadQuarter#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyAllianceHeadQuarter",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyAllianceMembers#1() : Class
      {
         return EmbeddedAssets.LayoutBodyAllianceMembers#1528;
      }
      
      public static function set LayoutBodyAllianceMembers#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyAllianceMembers#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyAllianceMembers#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyAllianceMembers",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyAllianceWar#1() : Class
      {
         return EmbeddedAssets.LayoutBodyAllianceWar#1528;
      }
      
      public static function set LayoutBodyAllianceWar#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyAllianceWar#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyAllianceWar#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyAllianceWar",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyAllianceLeaderboard#1() : Class
      {
         return EmbeddedAssets.LayoutBodyAllianceLeaderboard#1528;
      }
      
      public static function set LayoutBodyAllianceLeaderboard#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyAllianceLeaderboard#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyAllianceLeaderboard#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyAllianceLeaderboard",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBodyAllianceRewards#1() : Class
      {
         return EmbeddedAssets.LayoutBodyAllianceRewards#1528;
      }
      
      public static function set LayoutBodyAllianceRewards#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBodyAllianceRewards#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBodyAllianceRewards#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBodyAllianceRewards",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutAllianceRewardBox#1() : Class
      {
         return EmbeddedAssets.LayoutAllianceRewardBox#1528;
      }
      
      public static function set LayoutAllianceRewardBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutAllianceRewardBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutAllianceRewardBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutAllianceRewardBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutAlliancePageNews#1() : Class
      {
         return EmbeddedAssets.LayoutAlliancePageNews#1528;
      }
      
      public static function set LayoutAlliancePageNews#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutAlliancePageNews#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutAlliancePageNews#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutAlliancePageNews",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutNotificationAlliances#1() : Class
      {
         return EmbeddedAssets.LayoutNotificationAlliances#1528;
      }
      
      public static function set LayoutNotificationAlliances#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutNotificationAlliances#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutNotificationAlliances#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutNotificationAlliances",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutAllianceWarSuggested#1() : Class
      {
         return EmbeddedAssets.LayoutAllianceWarSuggested#1528;
      }
      
      public static function set LayoutAllianceWarSuggested#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutAllianceWarSuggested#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutAllianceWarSuggested#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutAllianceWarSuggested",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutBattleSummary#1() : Class
      {
         return EmbeddedAssets.LayoutBattleSummary#1528;
      }
      
      public static function set LayoutBattleSummary#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutBattleSummary#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutBattleSummary#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutBattleSummary",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutPreAttack#1() : Class
      {
         return EmbeddedAssets.LayoutPreAttack#1528;
      }
      
      public static function set LayoutPreAttack#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutPreAttack#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutPreAttack#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutPreAttack",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnXXL#1() : Class
      {
         return EmbeddedAssets.BtnXXL#1528;
      }
      
      public static function set BtnXXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnXXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnXXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnXXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnXL#1() : Class
      {
         return EmbeddedAssets.BtnXL#1528;
      }
      
      public static function set BtnXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnL#1() : Class
      {
         return EmbeddedAssets.BtnL#1528;
      }
      
      public static function set BtnL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnM#1() : Class
      {
         return EmbeddedAssets.BtnM#1528;
      }
      
      public static function set BtnM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnS#1() : Class
      {
         return EmbeddedAssets.BtnS#1528;
      }
      
      public static function set BtnS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnXS#1() : Class
      {
         return EmbeddedAssets.BtnXS#1528;
      }
      
      public static function set BtnXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnHUDL#1() : Class
      {
         return EmbeddedAssets.BtnHUDL#1528;
      }
      
      public static function set BtnHUDL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnHUDL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnHUDL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnHUDL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnHUDM#1() : Class
      {
         return EmbeddedAssets.BtnHUDM#1528;
      }
      
      public static function set BtnHUDM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnHUDM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnHUDM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnHUDM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnXXL#1() : Class
      {
         return EmbeddedAssets.IBtnXXL#1528;
      }
      
      public static function set IBtnXXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnXXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnXXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnXXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnXL#1() : Class
      {
         return EmbeddedAssets.IBtnXL#1528;
      }
      
      public static function set IBtnXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnL#1() : Class
      {
         return EmbeddedAssets.IBtnL#1528;
      }
      
      public static function set IBtnL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnM#1() : Class
      {
         return EmbeddedAssets.IBtnM#1528;
      }
      
      public static function set IBtnM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnS#1() : Class
      {
         return EmbeddedAssets.IBtnS#1528;
      }
      
      public static function set IBtnS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnXS#1() : Class
      {
         return EmbeddedAssets.IBtnXS#1528;
      }
      
      public static function set IBtnXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnINSIDE#1() : Class
      {
         return EmbeddedAssets.IBtnINSIDE#1528;
      }
      
      public static function set IBtnINSIDE#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnINSIDE#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnINSIDE#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnINSIDE",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnHUD#1() : Class
      {
         return EmbeddedAssets.IBtnHUD#1528;
      }
      
      public static function set IBtnHUD#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnHUD#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnHUD#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnHUD",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IBtnHUDICONAREA#1() : Class
      {
         return EmbeddedAssets.IBtnHUDICONAREA#1528;
      }
      
      public static function set IBtnHUDICONAREA#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IBtnHUDICONAREA#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IBtnHUDICONAREA#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IBtnHUDICONAREA",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TabHeader#1() : Class
      {
         return EmbeddedAssets.TabHeader#1528;
      }
      
      public static function set TabHeader#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TabHeader#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TabHeader#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TabHeader",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BtnImgM#1() : Class
      {
         return EmbeddedAssets.BtnImgM#1528;
      }
      
      public static function set BtnImgM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BtnImgM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BtnImgM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BtnImgM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextXL#1() : Class
      {
         return EmbeddedAssets.IconTextXL#1528;
      }
      
      public static function set IconTextXL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextXL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextXL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextXL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextL#1() : Class
      {
         return EmbeddedAssets.IconTextL#1528;
      }
      
      public static function set IconTextL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextLLarge#1() : Class
      {
         return EmbeddedAssets.IconTextLLarge#1528;
      }
      
      public static function set IconTextLLarge#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextLLarge#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextLLarge#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextLLarge",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextM#1() : Class
      {
         return EmbeddedAssets.IconTextM#1528;
      }
      
      public static function set IconTextM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextMLarge#1() : Class
      {
         return EmbeddedAssets.IconTextMLarge#1528;
      }
      
      public static function set IconTextMLarge#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextMLarge#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextMLarge#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextMLarge",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextS#1() : Class
      {
         return EmbeddedAssets.IconTextS#1528;
      }
      
      public static function set IconTextS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextSLarge#1() : Class
      {
         return EmbeddedAssets.IconTextSLarge#1528;
      }
      
      public static function set IconTextSLarge#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextSLarge#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextSLarge#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextSLarge",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextXS#1() : Class
      {
         return EmbeddedAssets.IconTextXS#1528;
      }
      
      public static function set IconTextXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTwoTextsXS#1() : Class
      {
         return EmbeddedAssets.IconTwoTextsXS#1528;
      }
      
      public static function set IconTwoTextsXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTwoTextsXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTwoTextsXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTwoTextsXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get HIconTwoTextsXS#1() : Class
      {
         return EmbeddedAssets.HIconTwoTextsXS#1528;
      }
      
      public static function set HIconTwoTextsXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.HIconTwoTextsXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.HIconTwoTextsXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"HIconTwoTextsXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconTextXSLarge#1() : Class
      {
         return EmbeddedAssets.IconTextXSLarge#1528;
      }
      
      public static function set IconTextXSLarge#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconTextXSLarge#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconTextXSLarge#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconTextXSLarge",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarL#1() : Class
      {
         return EmbeddedAssets.IconBarL#1528;
      }
      
      public static function set IconBarL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarM#1() : Class
      {
         return EmbeddedAssets.IconBarM#1528;
      }
      
      public static function set IconBarM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarS#1() : Class
      {
         return EmbeddedAssets.IconBarS#1528;
      }
      
      public static function set IconBarS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarXS#1() : Class
      {
         return EmbeddedAssets.IconBarXS#1528;
      }
      
      public static function set IconBarXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get IconBarXXS#1() : Class
      {
         return EmbeddedAssets.IconBarXXS#1528;
      }
      
      public static function set IconBarXXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.IconBarXXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.IconBarXXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"IconBarXXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ProfileRes#1() : Class
      {
         return EmbeddedAssets.ProfileRes#1528;
      }
      
      public static function set ProfileRes#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ProfileRes#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ProfileRes#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ProfileRes",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ProfileExtended#1() : Class
      {
         return EmbeddedAssets.ProfileExtended#1528;
      }
      
      public static function set ProfileExtended#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ProfileExtended#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ProfileExtended#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ProfileExtended",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ProfileExtendedPlanet#1() : Class
      {
         return EmbeddedAssets.ProfileExtendedPlanet#1528;
      }
      
      public static function set ProfileExtendedPlanet#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ProfileExtendedPlanet#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ProfileExtendedPlanet#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ProfileExtendedPlanet",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ProfileBasic#1() : Class
      {
         return EmbeddedAssets.ProfileBasic#1528;
      }
      
      public static function set ProfileBasic#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ProfileBasic#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ProfileBasic#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ProfileBasic",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ProductionBar#1() : Class
      {
         return EmbeddedAssets.ProductionBar#1528;
      }
      
      public static function set ProductionBar#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ProductionBar#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ProductionBar#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ProductionBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get Pagination#1() : Class
      {
         return EmbeddedAssets.Pagination#1528;
      }
      
      public static function set Pagination#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.Pagination#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.Pagination#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"Pagination",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxUnits#1() : Class
      {
         return EmbeddedAssets.BoxUnits#1528;
      }
      
      public static function set BoxUnits#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxUnits#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxUnits#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxUnits",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxUnitsButtons#1() : Class
      {
         return EmbeddedAssets.BoxUnitsButtons#1528;
      }
      
      public static function set BoxUnitsButtons#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxUnitsButtons#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxUnitsButtons#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxUnitsButtons",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxUnitsButtonsSmall#1() : Class
      {
         return EmbeddedAssets.BoxUnitsButtonsSmall#1528;
      }
      
      public static function set BoxUnitsButtonsSmall#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxUnitsButtonsSmall#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxUnitsButtonsSmall#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxUnitsButtonsSmall",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxFriendButton#1() : Class
      {
         return EmbeddedAssets.BoxFriendButton#1528;
      }
      
      public static function set BoxFriendButton#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxFriendButton#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxFriendButton#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxFriendButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxFriendHelp#1() : Class
      {
         return EmbeddedAssets.BoxFriendHelp#1528;
      }
      
      public static function set BoxFriendHelp#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxFriendHelp#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxFriendHelp#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxFriendHelp",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxCrafting#1() : Class
      {
         return EmbeddedAssets.BoxCrafting#1528;
      }
      
      public static function set BoxCrafting#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxCrafting#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxCrafting#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxCrafting",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxInventory#1() : Class
      {
         return EmbeddedAssets.BoxInventory#1528;
      }
      
      public static function set BoxInventory#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxInventory#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxInventory#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxInventory",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxReward#1() : Class
      {
         return EmbeddedAssets.BoxReward#1528;
      }
      
      public static function set BoxReward#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxReward#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxReward#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxReward",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxColony#1() : Class
      {
         return EmbeddedAssets.BoxColony#1528;
      }
      
      public static function set BoxColony#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxColony#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxColony#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxColony",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxColonyS#1() : Class
      {
         return EmbeddedAssets.BoxColonyS#1528;
      }
      
      public static function set BoxColonyS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxColonyS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxColonyS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxColonyS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxColonyXS#1() : Class
      {
         return EmbeddedAssets.BoxColonyXS#1528;
      }
      
      public static function set BoxColonyXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxColonyXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxColonyXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxColonyXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BoxGalaxy#1() : Class
      {
         return EmbeddedAssets.BoxGalaxy#1528;
      }
      
      public static function set BoxGalaxy#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BoxGalaxy#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BoxGalaxy#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BoxGalaxy",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItem#1() : Class
      {
         return EmbeddedAssets.ContainerItem#1528;
      }
      
      public static function set ContainerItem#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItem#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItem#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemS#1() : Class
      {
         return EmbeddedAssets.ContainerItemS#1528;
      }
      
      public static function set ContainerItemS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemButtonIcon#1() : Class
      {
         return EmbeddedAssets.ContainerItemButtonIcon#1528;
      }
      
      public static function set ContainerItemButtonIcon#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemButtonIcon#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemButtonIcon#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemButtonIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemButtonIconSmall#1() : Class
      {
         return EmbeddedAssets.ContainerItemButtonIconSmall#1528;
      }
      
      public static function set ContainerItemButtonIconSmall#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemButtonIconSmall#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemButtonIconSmall#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemButtonIconSmall",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemButtonIconLarge#1() : Class
      {
         return EmbeddedAssets.ContainerItemButtonIconLarge#1528;
      }
      
      public static function set ContainerItemButtonIconLarge#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemButtonIconLarge#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemButtonIconLarge#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemButtonIconLarge",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemVerticalL#1() : Class
      {
         return EmbeddedAssets.ContainerItemVerticalL#1528;
      }
      
      public static function set ContainerItemVerticalL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemVerticalL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemVerticalL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemVerticalL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemVerticalM#1() : Class
      {
         return EmbeddedAssets.ContainerItemVerticalM#1528;
      }
      
      public static function set ContainerItemVerticalM#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemVerticalM#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemVerticalM#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemVerticalM",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemVerticalS#1() : Class
      {
         return EmbeddedAssets.ContainerItemVerticalS#1528;
      }
      
      public static function set ContainerItemVerticalS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemVerticalS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemVerticalS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemVerticalS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerItemVerticalXS#1() : Class
      {
         return EmbeddedAssets.ContainerItemVerticalXS#1528;
      }
      
      public static function set ContainerItemVerticalXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerItemVerticalXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerItemVerticalXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerItemVerticalXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TextFieldAnimation#1() : Class
      {
         return EmbeddedAssets.TextFieldAnimation#1528;
      }
      
      public static function set TextFieldAnimation#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TextFieldAnimation#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TextFieldAnimation#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TextFieldAnimation",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerStripeL#1() : Class
      {
         return EmbeddedAssets.ContainerStripeL#1528;
      }
      
      public static function set ContainerStripeL#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerStripeL#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerStripeL#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerStripeL",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerStripeS#1() : Class
      {
         return EmbeddedAssets.ContainerStripeS#1528;
      }
      
      public static function set ContainerStripeS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerStripeS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerStripeS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerStripeS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerStripeXS#1() : Class
      {
         return EmbeddedAssets.ContainerStripeXS#1528;
      }
      
      public static function set ContainerStripeXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerStripeXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerStripeXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerStripeXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerStripeSHigher#1() : Class
      {
         return EmbeddedAssets.ContainerStripeSHigher#1528;
      }
      
      public static function set ContainerStripeSHigher#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerStripeSHigher#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerStripeSHigher#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerStripeSHigher",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get CenterIconTextXS#1() : Class
      {
         return EmbeddedAssets.CenterIconTextXS#1528;
      }
      
      public static function set CenterIconTextXS#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.CenterIconTextXS#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.CenterIconTextXS#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"CenterIconTextXS",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get StripeAlliancesLeaderBoard#1() : Class
      {
         return EmbeddedAssets.StripeAlliancesLeaderBoard#1528;
      }
      
      public static function set StripeAlliancesLeaderBoard#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.StripeAlliancesLeaderBoard#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.StripeAlliancesLeaderBoard#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"StripeAlliancesLeaderBoard",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get SkinInventoryBox#1() : Class
      {
         return EmbeddedAssets.SkinInventoryBox#1528;
      }
      
      public static function set SkinInventoryBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.SkinInventoryBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.SkinInventoryBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"SkinInventoryBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextField#1() : Class
      {
         return EmbeddedAssets.ContainerTextField#1528;
      }
      
      public static function set ContainerTextField#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextField#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextField#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextField",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextField2#1() : Class
      {
         return EmbeddedAssets.ContainerTextField2#1528;
      }
      
      public static function set ContainerTextField2#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextField2#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextField2#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextField2",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextField3#1() : Class
      {
         return EmbeddedAssets.ContainerTextField3#1528;
      }
      
      public static function set ContainerTextField3#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextField3#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextField3#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextField3",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextTextIcon#1() : Class
      {
         return EmbeddedAssets.ContainerTextTextIcon#1528;
      }
      
      public static function set ContainerTextTextIcon#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextTextIcon#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextTextIcon#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextTextIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextFieldIcon3#1() : Class
      {
         return EmbeddedAssets.ContainerTextFieldIcon3#1528;
      }
      
      public static function set ContainerTextFieldIcon3#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextFieldIcon3#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextFieldIcon3#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextFieldIcon3",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerTextIcons#1() : Class
      {
         return EmbeddedAssets.ContainerTextIcons#1528;
      }
      
      public static function set ContainerTextIcons#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerTextIcons#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerTextIcons#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerTextIcons",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerImgText#1() : Class
      {
         return EmbeddedAssets.ContainerImgText#1528;
      }
      
      public static function set ContainerImgText#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerImgText#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerImgText#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerImgText",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerSpeechIcons#1() : Class
      {
         return EmbeddedAssets.ContainerSpeechIcons#1528;
      }
      
      public static function set ContainerSpeechIcons#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerSpeechIcons#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerSpeechIcons#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerSpeechIcons",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopSpeech#1() : Class
      {
         return EmbeddedAssets.PopSpeech#1528;
      }
      
      public static function set PopSpeech#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopSpeech#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopSpeech#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopSpeech",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopSpeechRight#1() : Class
      {
         return EmbeddedAssets.PopSpeechRight#1528;
      }
      
      public static function set PopSpeechRight#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopSpeechRight#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopSpeechRight#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopSpeechRight",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopNotifications#1() : Class
      {
         return EmbeddedAssets.PopNotifications#1528;
      }
      
      public static function set PopNotifications#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopNotifications#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopNotifications#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopNotifications",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopNotificationsIcons#1() : Class
      {
         return EmbeddedAssets.PopNotificationsIcons#1528;
      }
      
      public static function set PopNotificationsIcons#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopNotificationsIcons#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopNotificationsIcons#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopNotificationsIcons",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopNotificationsMedium#1() : Class
      {
         return EmbeddedAssets.PopNotificationsMedium#1528;
      }
      
      public static function set PopNotificationsMedium#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopNotificationsMedium#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopNotificationsMedium#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopNotificationsMedium",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopNotificaionFeedBack#1() : Class
      {
         return EmbeddedAssets.PopNotificaionFeedBack#1528;
      }
      
      public static function set PopNotificaionFeedBack#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopNotificaionFeedBack#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopNotificaionFeedBack#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopNotificaionFeedBack",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutContainerColonizeRequirements#1() : Class
      {
         return EmbeddedAssets.LayoutContainerColonizeRequirements#1528;
      }
      
      public static function set LayoutContainerColonizeRequirements#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutContainerColonizeRequirements#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutContainerColonizeRequirements#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutContainerColonizeRequirements",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutColonized#1() : Class
      {
         return EmbeddedAssets.LayoutColonized#1528;
      }
      
      public static function set LayoutColonized#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutColonized#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutColonized#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutColonized",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutMoveColonies#1() : Class
      {
         return EmbeddedAssets.LayoutMoveColonies#1528;
      }
      
      public static function set LayoutMoveColonies#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutMoveColonies#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutMoveColonies#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutMoveColonies",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutSystemVisit#1() : Class
      {
         return EmbeddedAssets.LayoutSystemVisit#1528;
      }
      
      public static function set LayoutSystemVisit#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutSystemVisit#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutSystemVisit#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutSystemVisit",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get BodyAmbassador#1() : Class
      {
         return EmbeddedAssets.BodyAmbassador#1528;
      }
      
      public static function set BodyAmbassador#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.BodyAmbassador#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.BodyAmbassador#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"BodyAmbassador",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get StripeContestLeaderboard#1() : Class
      {
         return EmbeddedAssets.StripeContestLeaderboard#1528;
      }
      
      public static function set StripeContestLeaderboard#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.StripeContestLeaderboard#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.StripeContestLeaderboard#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"StripeContestLeaderboard",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get StripeContestRewards#1() : Class
      {
         return EmbeddedAssets.StripeContestRewards#1528;
      }
      
      public static function set StripeContestRewards#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.StripeContestRewards#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.StripeContestRewards#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"StripeContestRewards",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContestLeaderboardHeader#1() : Class
      {
         return EmbeddedAssets.ContestLeaderboardHeader#1528;
      }
      
      public static function set ContestLeaderboardHeader#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContestLeaderboardHeader#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContestLeaderboardHeader#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContestLeaderboardHeader",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContestRewardsHeader#1() : Class
      {
         return EmbeddedAssets.ContestRewardsHeader#1528;
      }
      
      public static function set ContestRewardsHeader#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContestRewardsHeader#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContestRewardsHeader#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContestRewardsHeader",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutOffer#1() : Class
      {
         return EmbeddedAssets.PopupLayoutOffer#1528;
      }
      
      public static function set PopupLayoutOffer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutOffer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutOffer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutOffer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutOneTimeOffer#1() : Class
      {
         return EmbeddedAssets.PopupLayoutOneTimeOffer#1528;
      }
      
      public static function set PopupLayoutOneTimeOffer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutOneTimeOffer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutOneTimeOffer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutOneTimeOffer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutInventory#1() : Class
      {
         return EmbeddedAssets.PopupLayoutInventory#1528;
      }
      
      public static function set PopupLayoutInventory#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutInventory#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutInventory#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutInventory",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutHangarUnits#1() : Class
      {
         return EmbeddedAssets.PopupLayoutHangarUnits#1528;
      }
      
      public static function set PopupLayoutHangarUnits#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutHangarUnits#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutHangarUnits#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutHangarUnits",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutHangarEmpty#1() : Class
      {
         return EmbeddedAssets.PopupLayoutHangarEmpty#1528;
      }
      
      public static function set PopupLayoutHangarEmpty#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutHangarEmpty#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutHangarEmpty#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutHangarEmpty",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutBunker#1() : Class
      {
         return EmbeddedAssets.PopupLayoutBunker#1528;
      }
      
      public static function set PopupLayoutBunker#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutBunker#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutBunker#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutBunker",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutBunkerFriends#1() : Class
      {
         return EmbeddedAssets.PopupLayoutBunkerFriends#1528;
      }
      
      public static function set PopupLayoutBunkerFriends#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutBunkerFriends#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutBunkerFriends#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutBunkerFriends",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutLab#1() : Class
      {
         return EmbeddedAssets.PopupLayoutLab#1528;
      }
      
      public static function set PopupLayoutLab#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutLab#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutLab#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutLab",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get CurrentUpgradingUnit#1() : Class
      {
         return EmbeddedAssets.CurrentUpgradingUnit#1528;
      }
      
      public static function set CurrentUpgradingUnit#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.CurrentUpgradingUnit#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.CurrentUpgradingUnit#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"CurrentUpgradingUnit",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupLayoutLabInfo#1() : Class
      {
         return EmbeddedAssets.PopupLayoutLabInfo#1528;
      }
      
      public static function set PopupLayoutLabInfo#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupLayoutLabInfo#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupLayoutLabInfo#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupLayoutLabInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerRequirements#1() : Class
      {
         return EmbeddedAssets.ContainerRequirements#1528;
      }
      
      public static function set ContainerRequirements#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerRequirements#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerRequirements#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerRequirements",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerRequirements2Items#1() : Class
      {
         return EmbeddedAssets.ContainerRequirements2Items#1528;
      }
      
      public static function set ContainerRequirements2Items#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerRequirements2Items#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerRequirements2Items#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerRequirements2Items",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerCost#1() : Class
      {
         return EmbeddedAssets.ContainerCost#1528;
      }
      
      public static function set ContainerCost#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerCost#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerCost#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerChips#1() : Class
      {
         return EmbeddedAssets.ContainerChips#1528;
      }
      
      public static function set ContainerChips#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerChips#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerChips#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerChips",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerUnitInfo#1() : Class
      {
         return EmbeddedAssets.ContainerUnitInfo#1528;
      }
      
      public static function set ContainerUnitInfo#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerUnitInfo#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerUnitInfo#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerUnitInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get WarningStripe#1() : Class
      {
         return EmbeddedAssets.WarningStripe#1528;
      }
      
      public static function set WarningStripe#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.WarningStripe#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.WarningStripe#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"WarningStripe",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get DiscountBox#1() : Class
      {
         return EmbeddedAssets.DiscountBox#1528;
      }
      
      public static function set DiscountBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.DiscountBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.DiscountBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"DiscountBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get HQInfoBox#1() : Class
      {
         return EmbeddedAssets.HQInfoBox#1528;
      }
      
      public static function set HQInfoBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.HQInfoBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.HQInfoBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"HQInfoBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get ContainerUnlock#1() : Class
      {
         return EmbeddedAssets.ContainerUnlock#1528;
      }
      
      public static function set ContainerUnlock#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.ContainerUnlock#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.ContainerUnlock#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"ContainerUnlock",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get SpecialInfoBox#1() : Class
      {
         return EmbeddedAssets.SpecialInfoBox#1528;
      }
      
      public static function set SpecialInfoBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.SpecialInfoBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.SpecialInfoBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"SpecialInfoBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopPageClock#1() : Class
      {
         return EmbeddedAssets.PremiumShopPageClock#1528;
      }
      
      public static function set PremiumShopPageClock#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopPageClock#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopPageClock#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopPageClock",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopPage#1() : Class
      {
         return EmbeddedAssets.PremiumShopPage#1528;
      }
      
      public static function set PremiumShopPage#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopPage#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopPage#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopPage",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopPageOffer#1() : Class
      {
         return EmbeddedAssets.PremiumShopPageOffer#1528;
      }
      
      public static function set PremiumShopPageOffer#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopPageOffer#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopPageOffer#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopPageOffer",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopItemBox#1() : Class
      {
         return EmbeddedAssets.PremiumShopItemBox#1528;
      }
      
      public static function set PremiumShopItemBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopItemBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopItemBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopItemBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopItemBoxShield#1() : Class
      {
         return EmbeddedAssets.PremiumShopItemBoxShield#1528;
      }
      
      public static function set PremiumShopItemBoxShield#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopItemBoxShield#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopItemBoxShield#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopItemBoxShield",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopOffersBox#1() : Class
      {
         return EmbeddedAssets.PremiumShopOffersBox#1528;
      }
      
      public static function set PremiumShopOffersBox#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopOffersBox#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopOffersBox#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopOffersBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopHeaderText#1() : Class
      {
         return EmbeddedAssets.PremiumShopHeaderText#1528;
      }
      
      public static function set PremiumShopHeaderText#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopHeaderText#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopHeaderText#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopHeaderText",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PremiumShopHeaderTextBtn#1() : Class
      {
         return EmbeddedAssets.PremiumShopHeaderTextBtn#1528;
      }
      
      public static function set PremiumShopHeaderTextBtn#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PremiumShopHeaderTextBtn#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PremiumShopHeaderTextBtn#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PremiumShopHeaderTextBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopupShopResources#1() : Class
      {
         return EmbeddedAssets.PopupShopResources#1528;
      }
      
      public static function set PopupShopResources#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopupShopResources#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopupShopResources#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopupShopResources",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TooltipTextfieldTitle#1() : Class
      {
         return EmbeddedAssets.TooltipTextfieldTitle#1528;
      }
      
      public static function set TooltipTextfieldTitle#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TooltipTextfieldTitle#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TooltipTextfieldTitle#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TooltipTextfieldTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TooltipTextfieldText#1() : Class
      {
         return EmbeddedAssets.TooltipTextfieldText#1528;
      }
      
      public static function set TooltipTextfieldText#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TooltipTextfieldText#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TooltipTextfieldText#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TooltipTextfieldText",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TooltipHudText#1() : Class
      {
         return EmbeddedAssets.TooltipHudText#1528;
      }
      
      public static function set TooltipHudText#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TooltipHudText#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TooltipHudText#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TooltipHudText",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TooltipHudShop#1() : Class
      {
         return EmbeddedAssets.TooltipHudShop#1528;
      }
      
      public static function set TooltipHudShop#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TooltipHudShop#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TooltipHudShop#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TooltipHudShop",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get TooltipHudShopNoProtection#1() : Class
      {
         return EmbeddedAssets.TooltipHudShopNoProtection#1528;
      }
      
      public static function set TooltipHudShopNoProtection#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.TooltipHudShopNoProtection#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.TooltipHudShopNoProtection#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"TooltipHudShopNoProtection",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutInvestNegotiation#1() : Class
      {
         return EmbeddedAssets.LayoutInvestNegotiation#1528;
      }
      
      public static function set LayoutInvestNegotiation#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutInvestNegotiation#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutInvestNegotiation#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutInvestNegotiation",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutInvestGraduated#1() : Class
      {
         return EmbeddedAssets.LayoutInvestGraduated#1528;
      }
      
      public static function set LayoutInvestGraduated#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutInvestGraduated#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutInvestGraduated#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutInvestGraduated",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutInvestTrainees#1() : Class
      {
         return EmbeddedAssets.LayoutInvestTrainees#1528;
      }
      
      public static function set LayoutInvestTrainees#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutInvestTrainees#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutInvestTrainees#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutInvestTrainees",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get StripeInvestments#1() : Class
      {
         return EmbeddedAssets.StripeInvestments#1528;
      }
      
      public static function set StripeInvestments#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.StripeInvestments#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.StripeInvestments#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"StripeInvestments",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsPopupAttack#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsPopupAttack#1528;
      }
      
      public static function set LayoutHappeningsPopupAttack#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsPopupAttack#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsPopupAttack#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsPopupAttack",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsPopupEnd#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsPopupEnd#1528;
      }
      
      public static function set LayoutHappeningsPopupEnd#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsPopupEnd#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsPopupEnd#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsPopupEnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsInitialKit#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsInitialKit#1528;
      }
      
      public static function set LayoutHappeningsInitialKit#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsInitialKit#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsInitialKit#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsInitialKit",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsAntiZombieKit#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsAntiZombieKit#1528;
      }
      
      public static function set LayoutHappeningsAntiZombieKit#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsAntiZombieKit#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsAntiZombieKit#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsAntiZombieKit",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsIconUnit#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsIconUnit#1528;
      }
      
      public static function set LayoutHappeningsIconUnit#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsIconUnit#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsIconUnit#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsIconUnit",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsBirthdayInitial#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsBirthdayInitial#1528;
      }
      
      public static function set LayoutHappeningsBirthdayInitial#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsBirthdayInitial#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsBirthdayInitial#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsBirthdayInitial",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutHappeningsWinterProgress#1() : Class
      {
         return EmbeddedAssets.LayoutHappeningsWinterProgress#1528;
      }
      
      public static function set LayoutHappeningsWinterProgress#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutHappeningsWinterProgress#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutHappeningsWinterProgress#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutHappeningsWinterProgress",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get PopPassFriendScore#1() : Class
      {
         return EmbeddedAssets.PopPassFriendScore#1528;
      }
      
      public static function set PopPassFriendScore#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.PopPassFriendScore#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.PopPassFriendScore#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"PopPassFriendScore",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get StripeFriendPassed#1() : Class
      {
         return EmbeddedAssets.StripeFriendPassed#1528;
      }
      
      public static function set StripeFriendPassed#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.StripeFriendPassed#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.StripeFriendPassed#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"StripeFriendPassed",_loc2_,param1));
            }
         }
      }
      
      [Bindable]
      public static function get LayoutLoadingScreen#1() : Class
      {
         return EmbeddedAssets.LayoutLoadingScreen#1528;
      }
      
      public static function set LayoutLoadingScreen#1(param1:Class) : void
      {
         var _loc2_:* = EmbeddedAssets.LayoutLoadingScreen#1528;
         if(_loc2_ !== param1)
         {
            EmbeddedAssets.LayoutLoadingScreen#1528 = param1;
            if(EmbeddedAssets._bindingEventDispatcher.hasEventListener("propertyChange"))
            {
               EmbeddedAssets._bindingEventDispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(EmbeddedAssets,"LayoutLoadingScreen",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return EmbeddedAssets._bindingEventDispatcher;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}
