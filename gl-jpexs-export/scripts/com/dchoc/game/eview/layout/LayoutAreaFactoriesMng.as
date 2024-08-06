package com.dchoc.game.eview.layout
{
   import esparragon.layout.ELayoutAreaFactoriesMng;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   
   public class LayoutAreaFactoriesMng extends ELayoutAreaFactoriesMng
   {
      
      public static const POPUP_BODY:String = "body";
      
      public static const POPUP_BKG:String = "bg";
      
      public static const POPUP_FOOTER:String = "footer";
      
      public static const POPUP_CLOSE:String = "btn_close";
      
      public static const POPUP_TITLE:String = "text_title";
      
      public static const POPUP_TAB:String = "tab";
      
      public static const POP_XL:String = "PopXL";
      
      public static const POP_XL_TABS:String = "PopXLTabs";
      
      public static const POP_XL_TABS_NO_FOOTER:String = "PopXLTabsNoFooter";
      
      public static const POP_XL_NO_TABS_NO_FOOTER:String = "PopXLNoTabsNoFooter";
      
      public static const POP_L:String = "PopL";
      
      public static const POP_L_TABS:String = "PopLTabs";
      
      public static const POP_M:String = "PopM";
      
      public static const POP_S:String = "PopS";
      
      public static const JACKPOT:String = "Jackpot";
      
      public static const POP_BETTING:String = "PopBetting";
      
      public static const POP_BATTLE:String = "PopBattle";
      
      public static const POP_VICTORY:String = "PopVictory";
      
      public static const POP_SPEECH:String = "PopSpeech";
      
      public static const POP_SPEECH_RIGHT:String = "PopSpeechRight";
      
      public static const POP_NOTIFICATIONS:String = "PopNotifications";
      
      public static const POP_NOTIFICATIONS_ICONS:String = "PopNotificationsIcons";
      
      public static const POP_NOTIFICATIONS_MEDIUM:String = "PopNotificationsMedium";
      
      public static const POP_MISSION:String = "PopMission";
      
      public static const POP_MISSION_BOX:String = "PopMissionBox";
      
      public static const POP_MISSION_COMPLETE:String = "PopMissionComplete";
      
      public static const POP_OFFER:String = "PopupLayoutOffer";
      
      public static const POP_ONE_TIME_OFFER:String = "PopupLayoutOneTimeOffer";
      
      public static const POP_INVENTORY:String = "PopupLayoutInventory";
      
      public static const LAYOUT_ITEM_INVENTORY_SKIN:String = "SkinInventoryBox";
      
      public static const POP_HANGAR_UNITS:String = "PopupLayoutHangarUnits";
      
      public static const POP_HANGAR_EMPTY:String = "PopupLayoutHangarEmpty";
      
      public static const POP_BUNKER:String = "PopupLayoutBunker";
      
      public static const POP_BUNKER_FRIENDS:String = "PopupLayoutBunkerFriends";
      
      public static const POP_SHOP_RESOURCES:String = "PopupShopResources";
      
      public static const POP_INSTRUCTIONS:String = "LayoutPopupInstructions";
      
      public static const POP_LABORATORY:String = "PopupLayoutLab";
      
      public static const POP_LAB_INFO:String = "PopupLayoutLabInfo";
      
      public static const CONTAINER_REQUIREMENTS:String = "ContainerRequirements";
      
      public static const CONTAINER_REQUIREMENTS_2_ITEMS:String = "ContainerRequirements2Items";
      
      public static const CONTAINER_COST:String = "ContainerCost";
      
      public static const CONTAINER_CHIPS:String = "ContainerChips";
      
      public static const CONTAINER_UNIT_INFO:String = "ContainerUnitInfo";
      
      public static const WARNING_STRIPE:String = "WarningStripe";
      
      public static const DISCOUNT_BOX:String = "DiscountBox";
      
      public static const SPECIAL_INFO_BOX:String = "SpecialInfoBox";
      
      public static const HQ_INFO_BOX:String = "HQInfoBox";
      
      public static const CONTAINER_UNLOCK:String = "ContainerUnlock";
      
      public static const BODY_CONTEST_AMBASSADOR:String = "BodyAmbassador";
      
      public static const STRIPE_CONTEST_LEADERBOARD:String = "StripeContestLeaderboard";
      
      public static const STRIPE_CONTEST_REWARDS:String = "StripeContestRewards";
      
      public static const HEADER_CONTEST_LEADERBOARD:String = "ContestLeaderboardHeader";
      
      public static const HEADER_CONTEST_REWARDS:String = "ContestRewardsHeader";
      
      public static const PREMIUM_SHOP_PAGE_CLOCK:String = "PremiumShopPageClock";
      
      public static const PREMIUM_SHOP_ITEM_BOX:String = "PremiumShopItemBox";
      
      public static const PREMIUM_SHOP_ITEM_BOX_SHIELD:String = "PremiumShopItemBoxShield";
      
      public static const PREMIUM_SHOP_PAGE:String = "PremiumShopPage";
      
      public static const PREMIUM_SHOP_PAGE_OFFER:String = "PremiumShopPageOffer";
      
      public static const PREMIUM_SHOP_OFFERS_BOX:String = "PremiumShopOffersBox";
      
      public static const PREMIUM_SHOP_HEADER_TEXT:String = "PremiumShopHeaderText";
      
      public static const PREMIUM_SHOP_HEADER_TEXT_BTN:String = "PremiumShopHeaderTextBtn";
      
      public static const BET_BOX:String = "BetBox";
      
      public static const BET_RESULTS_VICTORY_BAR:String = "BetResultsVictoryBar";
      
      public static const BET_RESULTS_BATTLE_BAR:String = "BetResultsBattleBar";
      
      public static const PROFILE_RES:String = "ProfileRes";
      
      public static const PROFILE_BASIC:String = "ProfileBasic";
      
      public static const CONTAINER_RESULTS:String = "ContainerResults";
      
      public static const CONTAINER_RESULTS_MATCH:String = "ContainerResultsMatch";
      
      public static const PRODUCTION_BAR:String = "ProductionBar";
      
      public static const LAYOUT_ICON_TEXT_XL:String = "IconTextXL";
      
      public static const LAYOUT_ICON_TEXT_L_LARGE:String = "IconTextLLarge";
      
      public static const LAYOUT_ICON_TEXT_L:String = "IconTextL";
      
      public static const LAYOUT_ICON_TEXT_M:String = "IconTextM";
      
      public static const LAYOUT_ICON_TEXT_M_LARGE:String = "IconTextMLarge";
      
      public static const LAYOUT_ICON_TEXT_S:String = "IconTextS";
      
      public static const LAYOUT_ICON_TEXT_S_LARGE:String = "IconTextSLarge";
      
      public static const LAYOUT_ICON_TEXT_XS:String = "IconTextXS";
      
      public static const LAYOUT_ICON_TWO_TEXTS_XS:String = "IconTwoTextsXS";
      
      public static const LAYOUT_H_ICON_TWO_TEXTS_XS:String = "HIconTwoTextsXS";
      
      public static const LAYOUT_ICON_TEXT_XS_LARGE:String = "IconTextXSLarge";
      
      public static const LAYOUT_ICON_BAR_L:String = "IconBarL";
      
      public static const LAYOUT_ICON_BAR_M:String = "IconBarM";
      
      public static const LAYOUT_ICON_BAR_S:String = "IconBarS";
      
      public static const LAYOUT_ICON_BAR_XS:String = "IconBarXS";
      
      public static const LAYOUT_ICON_BAR_XXS:String = "IconBarXXS";
      
      public static const LAYOUT_ICON_BAR_HUD_L:String = "IconBarHudL";
      
      public static const LAYOUT_ICON_BAR_HUD_M:String = "IconBarHudM";
      
      public static const LAYOUT_ICON_BAR_HUD_M_NO_BTN:String = "IconBarHudMNoBtn";
      
      public static const LAYOUT_ICON_BAR_HUD_L_NO_BTN:String = "IconBarHudLNoBtn";
      
      public static const LAYOUT_ICON_BAR_HUD_S:String = "IconBarHudS";
      
      public static const LAYOUT_ICON_MISSION_HUD:String = "IconMissionHud";
      
      public static const LAYOUT_NOTIFICATION_AREA_HUD:String = "NotificationAreaHud";
      
      public static const LAYOUT_NAVIGATION_BAR_HUD:String = "NavigationBarHud";
      
      public static const LAYOUT_NAVIGATION_INFO_HUD:String = "NavigationInfoHud";
      
      public static const LAYOUT_MISSION_DROP_HUD:String = "MissionDropDownHud";
      
      public static const LAYOUT_OPTIONS_DROP_HUD:String = "OptionsDropDownHud";
      
      public static const LAYOUT_HUD_NAVIGATION_TAB:String = "LayoutHudNavigationTab";
      
      public static const PAGINATION:String = "Pagination";
      
      public static const LAYOUT_BOX_REWARD:String = "BoxReward";
      
      public static const LAYOUT_BOX_COLONY:String = "BoxColony";
      
      public static const LAYOUT_BOX_COLONY_S:String = "BoxColonyS";
      
      public static const LAYOUT_BOX_COLONY_XS:String = "BoxColonyXS";
      
      public static const LAYOUT_BOX_GALAXY:String = "BoxGalaxy";
      
      public static const LAYOUT_ITEM_CRAFTING:String = "BoxCrafting";
      
      public static const LAYOUT_ITEM_INVENTORY:String = "BoxInventory";
      
      public static const LAYOUT_ITEM_UNIT:String = "BoxUnits";
      
      public static const LAYOUT_ITEM_UNIT_WITH_BUTTONS:String = "BoxUnitsButtons";
      
      public static const LAYOUT_ITEM_UNIT_WITH_BUTTONS_SMALL:String = "BoxUnitsButtonsSmall";
      
      public static const LAYOUT_FRIEND_BOX_BUTTON:String = "BoxFriendButton";
      
      public static const LAYOUT_FRIEND_HELP_BOX:String = "BoxFriendHelp";
      
      public static const LAYOUT_ITEM_CONTAINER:String = "ContainerItem";
      
      public static const LAYOUT_ITEM_CONTAINER_S:String = "ContainerItemS";
      
      public static const LAYOUT_ITEM_CONTAINER_BUTTON_ICON:String = "ContainerItemButtonIcon";
      
      public static const LAYOUT_ITEM_CONTAINER_BUTTON_ICON_S:String = "ContainerItemButtonIconSmall";
      
      public static const LAYOUT_ITEM_CONTAINER_BUTTON_ICON_L:String = "ContainerItemButtonIconLarge";
      
      public static const LAYOUT_ITEM_VERTICAL_L:String = "ContainerItemVerticalL";
      
      public static const LAYOUT_ITEM_VERTICAL_M:String = "ContainerItemVerticalM";
      
      public static const LAYOUT_ITEM_VERTICAL_S:String = "ContainerItemVerticalS";
      
      public static const LAYOUT_ITEM_VERTICAL_XS:String = "ContainerItemVerticalXS";
      
      public static const LAYOUT_CENTER_ICON_TEXT_XS:String = "CenterIconTextXS";
      
      public static const LAYOUT_FEEDBACK_TEXTFIELD:String = "TextFieldAnimation";
      
      public static const LAYOUT_HUD_LOOTING_INFO:String = "LayoutHudLootingInfo";
      
      public static const LAYOUT_HUD_BATTLE_TIMER:String = "LayoutHudBattleTimer";
      
      public static const LAYOUT_HUD_COLLECTION_CONTAINER:String = "LayoutHudCollectionContainer";
      
      public static const HUD_AREA_TOP:String = "hud_top_normal";
      
      public static const HUD_AREA_TOP_VISIT:String = "hud_top_s";
      
      public static const HUD_AREA_BOTTOM:String = "hud_bottom_normal";
      
      public static const HUD_AREA_BOTTOM_SMALL:String = "hud_bottom_normal";
      
      public static const LAYOUT_HUD_TOP:String = "LayoutHudTop";
      
      public static const LAYOUT_HUD_TOP_VISITING:String = "LayoutHudTopVisiting";
      
      public static const LAYOUT_HUD_TOP_SPYING:String = "LayoutHudTopSpying";
      
      public static const LAYOUT_HUD_TOP_REPLAY:String = "LayoutHudTopReplay";
      
      public static const LAYOUT_HUD_LEFT:String = "LayoutHudLeft";
      
      public static const LAYOUT_HUD_LEFT_VISITING:String = "LayoutHudLeftVisiting";
      
      public static const LAYOUT_HUD_LEFT_SPYING:String = "LayoutHudLeftSpying";
      
      public static const LAYOUT_HUD_RIGHT:String = "LayoutHudRight";
      
      public static const LAYOUT_HUD_BOTTOM:String = "LayoutHudBottom";
      
      public static const LAYOUT_HUD_BOTTOM_SMALL:String = "LayoutHudBottomSmall";
      
      public static const LAYOUT_HUD_BOTTOM_SHOP:String = "LayoutHudBottomShop";
      
      public static const LAYOUT_HUD_BOTTOM_SHIPYARD:String = "LayoutHudBottomShipyard";
      
      public static const LAYOUT_HUD_BOTTOM_ATTACK:String = "LayoutHudBottomAttack";
      
      public static const LAYOUT_HUD_BOTTOM_WAR_BAR_UNITS:String = "LayoutHudBottomUnits";
      
      public static const LAYOUT_HUD_BOTTOM_WAR_BAR_UNITS_S:String = "LayoutHudBottomUnitsSmall";
      
      public static const LAYOUT_HUD_BOTTOM_WAR_BAR_MERCENARIES:String = "LayoutHudBottomMercenaries";
      
      public static const LAYOUT_POPUP_CHIPS_SHOP:String = "PopupChipsShop";
      
      public static const LAYOUT_BOX_CHIPS:String = "BoxChips";
      
      public static const LAYOUT_TEXT_PRICE:String = "TextPrice";
      
      public static const LAYOUT_TEXT_PRICE_OFFER:String = "TextPriceOffer";
      
      public static const LAYOUT_TEXT_PRICE_OFFER_DISCOUNT:String = "TextPriceOfferDiscount";
      
      public static const SPEECH_CONTENT_1_TEXT:String = "ContainerTextField";
      
      public static const SPEECH_CONTENT_2_TEXTS:String = "ContainerTextField2";
      
      public static const SPEECH_CONTENT_3_TEXTS:String = "ContainerTextField3";
      
      public static const SPEECH_CONTENT_2_TEXTS_ICON:String = "ContainerTextIcons";
      
      public static const SPEECH_CONTENT_TEXT_ICONS:String = "ContainerTextIcons";
      
      public static const SPEECH_CONTENT_ICONS:String = "ContainerSpeechIcons";
      
      public static const SPEECH_CONTENT_TEXT_ICON_3:String = "ContainerTextFieldIcon3";
      
      public static const CONTAINER_IMG_TEXT:String = "ContainerImgText";
      
      public static const SIZE_XXL:String = "XXL";
      
      public static const SIZE_XL:String = "XL";
      
      public static const SIZE_L:String = "L";
      
      public static const SIZE_M:String = "M";
      
      public static const SIZE_S:String = "S";
      
      public static const SIZE_XS:String = "XS";
      
      public static const SIZE_HUD_M:String = "HudM";
      
      public static const SIZE_HUD_L:String = "HudL";
      
      public static const SIZE_HUD:String = "Hud";
      
      public static const SIZE_HUD_ICON_AREA:String = "HudIconArea";
      
      public static const SIZE_INSIDE:String = "Inside";
      
      public static const BTN_XXL:String = "BtnXXL";
      
      public static const BTN_XL:String = "BtnXL";
      
      public static const BTN_L:String = "BtnL";
      
      public static const BTN_M:String = "BtnM";
      
      public static const BTN_S:String = "BtnS";
      
      public static const BTN_XS:String = "BtnXS";
      
      public static const I_BTN_XXL:String = "IBtnXXL";
      
      public static const I_BTN_XL:String = "IBtnXL";
      
      public static const I_BTN_L:String = "IBtnL";
      
      public static const I_BTN_M:String = "IBtnM";
      
      public static const I_BTN_S:String = "IBtnS";
      
      public static const I_BTN_XS:String = "IBtnXS";
      
      public static const I_BTN_INSIDE:String = "IBtnInside";
      
      public static const STRIPE_L:String = "ContainerStripeL";
      
      public static const STRIPE_S:String = "ContainerStripeS";
      
      public static const STRIPE_XS:String = "ContainerStripeXS";
      
      public static const STRIPE_S_HIGHER:String = "ContainerStripeSHigher";
      
      public static const BTN_IMG_M:String = "BtnImgM";
      
      public static const TAB_HEADER:String = "TabHeader";
      
      public static const TOOLTIP_TEXTFIELD_TEXT:String = "TooltipTextfieldText";
      
      public static const TOOLTIP_TEXTFIELD_TITLE:String = "TooltipTextfieldTitle";
      
      public static const TOOLTIP_HUD_TEXT:String = "TooltipHudText";
      
      public static const TOOLTIP_HUD_SHOP:String = "TooltipHudShop";
      
      public static const TOOLTIP_HUD_SHOP_NO_PROTECTION:String = "TooltipHudShopNoProtection";
      
      public static const LAYOUT_HUD_DROP_DOWN_EMPTY_ARROW_DOWN:String = "LayoutHudEmptyDropDown";
      
      public static const LAYOUT_HUD_DROP_DOWN_EMPTY_ARROW_UP:String = "LayoutHudEmptyDropDownArrowUp";
      
      public static const LAYOUT_CURRENT_UPGRADING_UNIT:String = "CurrentUpgradingUnit";
      
      public static const LAYOUT_POPUP_CREATE_ALLIANCES:String = "LayoutPopupCreateAlliance";
      
      public static const LAYOUT_POPUP_EDIT_ALLIANCES:String = "LayoutPopupEditAlliance";
      
      public static const LAYOUT_BODY_JOIN_ALLIANCE:String = "LayoutBodyJoinAlliance";
      
      public static const LAYOUT_STRIPE_ALLIANCE_LEADERBOARD:String = "StripeAlliancesLeaderBoard";
      
      public static const LAYOUT_ALLIANCE_HEADQUARTER:String = "LayoutBodyAllianceHeadQuarter";
      
      public static const LAYOUT_POPUP_ALLIANCE_MEMBERS:String = "LayoutBodyAllianceMembers";
      
      public static const LAYOUT_ALLIANCE_WAR:String = "LayoutBodyAllianceWar";
      
      public static const LAYOUT_ACTIONS_TOOLTIP:String = "LayoutActionsTooltip";
      
      public static const LAYOUT_ALLIANCE_LEADERBOARD:String = "LayoutBodyAllianceLeaderboard";
      
      public static const LAYOUT_ALLIANCE_REWARDS:String = "LayoutBodyAllianceRewards";
      
      public static const LAYOUT_ALLIANCE_REWARD_BOX:String = "LayoutAllianceRewardBox";
      
      public static const LAYOUT_ALLIANCE_PAGE_NEWS:String = "LayoutAlliancePageNews";
      
      public static const LAYOUT_ALLIANCES_NOTIFICATION:String = "LayoutNotificationAlliances";
      
      public static const LAYOUT_ALLIANCES_SUGGESTED_WAR_BOX:String = "LayoutAllianceWarSuggested";
      
      public static const LAYOUT_NOTIFICATION_FEEDBACK:String = "PopNotificaionFeedBack";
      
      public static const LAYOUT_CONTAINER_COLONIZE:String = "LayoutContainerColonizeRequirements";
      
      public static const LAYOUT_COLONIZED:String = "LayoutColonized";
      
      public static const LAYOUT_MOVE_COLONIES:String = "LayoutMoveColonies";
      
      public static const LAYOUT_SYSTEM_VISIT:String = "LayoutSystemVisit";
      
      public static const LAYOUT_PROFILE_EXTENDED:String = "ProfileExtended";
      
      public static const LAYOUT_PROFILE_EXTENDED_PLANET:String = "ProfileExtendedPlanet";
      
      public static const LAYOUT_BATTLE_RESULT:String = "LayoutBattleSummary";
      
      public static const LAYOUT_POPUP_PRE_ATTACK:String = "LayoutPreAttack";
      
      public static const LAYOUT_INVEST_NEGOTIATION:String = "LayoutInvestNegotiation";
      
      public static const LAYOUT_INVEST_GRADUATED:String = "LayoutInvestGraduated";
      
      public static const LAYOUT_INVEST_TRAINEES:String = "LayoutInvestTrainees";
      
      public static const LAYOUT_INVEST_STRIPE:String = "StripeInvestments";
      
      public static const LAYOUT_HAPPENINGS_ATTACK:String = "LayoutHappeningsPopupAttack";
      
      public static const LAYOUT_HAPPENINGS_END:String = "LayoutHappeningsPopupEnd";
      
      public static const LAYOUT_HAPPENINGS_ANTIZOMBIE_KIT:String = "LayoutHappeningsAntiZombieKit";
      
      public static const LAYOUT_HAPPENINGS_INITIAL_KIT:String = "LayoutHappeningsInitialKit";
      
      public static const LAYOUT_HAPPENINGS_ICON_UNIT:String = "LayoutHappeningsIconUnit";
      
      public static const LAYOUT_HAPPENINGS_BIRTHDAY_INITIAL:String = "LayoutHappeningsBirthdayInitial";
      
      public static const LAYOUT_HAPPENINGS_WINTER_PROGRESS:String = "LayoutHappeningsWinterProgress";
      
      public static const POP_PASS_FRIEND_SCORE:String = "PopPassFriendScore";
      
      public static const LAYOUT_STRIPE_FRIEND_PASSED:String = "StripeFriendPassed";
      
      public static const LAYOUT_SOLAR_SYSTEM_BOX:String = "LayoutSolarSystem";
      
      public static const LAYOUT_LOADING_SCREEN:String = "LayoutLoadingScreen";
       
      
      public function LayoutAreaFactoriesMng()
      {
         super();
         addColorBehavior(16711680,new ELayoutBehaviorCenterAndScale());
      }
      
      override protected function createFactory(sku:String) : ELayoutAreaFactory
      {
         return createFactoryFromDisplayObjectContainer(new EmbeddedAssets[sku]());
      }
   }
}
