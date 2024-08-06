package com.dchoc.game.core.rule
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.bet.BetDefMng;
   import com.dchoc.game.model.contest.ContestDefMng;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.happening.HappeningDefMng;
   import com.dchoc.game.model.happening.HappeningTypeDefMng;
   import com.dchoc.game.model.items.AlliancesRewardDefMng;
   import com.dchoc.game.model.items.CollectablesDefMng;
   import com.dchoc.game.model.items.CraftingDefMng;
   import com.dchoc.game.model.items.ItemsDefMng;
   import com.dchoc.game.model.items.MisteryRewardDef;
   import com.dchoc.game.model.items.MisteryRewardDefMng;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.items.RewardsDefMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.model.items.SpecialAttacksDefMng;
   import com.dchoc.game.model.poll.PollDefMng;
   import com.dchoc.game.model.powerups.PowerUpDefMng;
   import com.dchoc.game.model.rule.AlliancesLevelDefMng;
   import com.dchoc.game.model.rule.AlliancesSettingsDefMng;
   import com.dchoc.game.model.rule.AlliancesWarTypesDefMng;
   import com.dchoc.game.model.rule.AnimationsDefMng;
   import com.dchoc.game.model.rule.BackgroundDefMng;
   import com.dchoc.game.model.rule.BetsSettingsDefMng;
   import com.dchoc.game.model.rule.BuyResourcesBoxDefMng;
   import com.dchoc.game.model.rule.CreditsDefMng;
   import com.dchoc.game.model.rule.DamageProtectionDef;
   import com.dchoc.game.model.rule.DamageProtectionDefMng;
   import com.dchoc.game.model.rule.FlagImagesDefMng;
   import com.dchoc.game.model.rule.FunnelStepDefMng;
   import com.dchoc.game.model.rule.HelpsDefMng;
   import com.dchoc.game.model.rule.InvestRewardsDefMng;
   import com.dchoc.game.model.rule.InvestsSettingsDefMng;
   import com.dchoc.game.model.rule.LevelScoreDefMng;
   import com.dchoc.game.model.rule.NPCDefMng;
   import com.dchoc.game.model.rule.NewPayerPromoDefMng;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.game.model.rule.PopupSkinDefMng;
   import com.dchoc.game.model.rule.PremiumPricesDef;
   import com.dchoc.game.model.rule.PremiumPricesDefMng;
   import com.dchoc.game.model.rule.ProtectionTimeDef;
   import com.dchoc.game.model.rule.ProtectionTimeDefMng;
   import com.dchoc.game.model.rule.RebornObstaclesDefMng;
   import com.dchoc.game.model.rule.SettingsDef;
   import com.dchoc.game.model.rule.SettingsDefMng;
   import com.dchoc.game.model.rule.ShotPriorityDefMng;
   import com.dchoc.game.model.rule.SpyCapsulesShopDefMng;
   import com.dchoc.game.model.rule.WarPointsPerHQDefMng;
   import com.dchoc.game.model.shop.PurchaseShopDefMng;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.shop.ShopDefMng;
   import com.dchoc.game.model.shop.ShopProgressDefMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.PlanetDefMng;
   import com.dchoc.game.model.space.SolarSystemDefMng;
   import com.dchoc.game.model.target.TargetDefMng;
   import com.dchoc.game.model.umbrella.UmbrellaSettingsDefMng;
   import com.dchoc.game.model.umbrella.UmbrellaSkinDefMng;
   import com.dchoc.game.model.unit.defs.CivilDefMng;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.unit.defs.DroidDefMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.unit.defs.UnitDefMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.waves.WaveDef;
   import com.dchoc.game.model.waves.WaveDefMng;
   import com.dchoc.game.model.waves.WaveSpawnDefMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.payments.DCPaidCurrency;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import com.dchoc.toolkit.view.conf.DCGUIDefMng;
   import com.dchoc.toolkit.view.map.DCMapViewDefMng;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class RuleMng extends DCRuleMng
   {
      
      private static const FILES_SKUS:Vector.<String> = new <String>["mapDefinitions.xml","mapViewDefinitions.xml","resourcesCoinsDefinitions.xml","resourcesMineralsDefinitions.xml","resourcesSilosDefinitions.xml","shipyardDefinitions.xml","decorationDefinitions.xml","wonderDefinitions.xml","levelScoreDefinitions.xml","guiDefinitions.xml","settings.xml","warSmallShipsDefinitions.xml","botShipsDefinitions.xml","groundUnitsDefinitions.xml","mecaUnitsDefinitions.xml","squadsDefinitions.xml","animationsDefinitions.xml","defensesDefinitions.xml","droidsDefinitions.xml","civilDefinitions.xml","bulletsDefinitions.xml","missionDefinitions.xml","tutorialDefinitions.xml","hangarsDefinitions.xml","bunkersDefinitions.xml","laboratoriesDefinitions.xml","npcDefinitions.xml","npcAttacksDefinitions.xml","itemsDefinitions.xml","collectablesDefinitions.xml","craftingDefinitions.xml","specialAttacksDefinitions.xml","TimePriceDiscountsDefinitions.xml","obstaclesDefinitions.xml","protectionTimeDefinitions.xml","rebornObstaclesDefinitions.xml","resourcesBoxesDefinitions.xml","rewardsDefinitions.xml","spaceStarsDefinitions.xml","creditsDefinitions.xml","planetsDefinitions.xml","misteryRewardsDefinitions.xml","damageProtectionDefinitions.xml","backgroundDefinitions.xml","alliancesLevelDefinitions.xml","alliancesSettings.xml","flagImagesDefinitions.xml","alliancesRewardsDefinitions.xml","shotPriorityDefinitions.xml","platformSettingsDefinitions.xml","funnelDefinitions.xml","investsSettings.xml","investsRewardsDefinitions.xml","spyCapsulesShopDefinitions.xml","newPayerPromoDefinitions.xml","happeningDefinitions.xml","happeningTypeWaveDefinitions.xml","happeningTypeBirthdayDefinitions.xml","happeningTypeWinterDefinitions.xml","waveSpawnDefinitions.xml","waveDefinitions.xml","powerUpDefinitions.xml","pollDefinitions.xml","popupSkinsDefinitions.xml","betsDefinitions.xml","betsSettings.xml","contestDefinitions.xml","umbrellaSettings.xml","umbrellaSkinDefinitions.xml","shopProgressDefinitions.xml","premiumShopDefinitions.xml","purchaseShopsDefinitions.xml","helpsDefinitions.xml","alliancesWarTypesDefinitions.xml","warPointsPerHQDefinitions.xml"];
      
      private static const SIG_SKUS:Vector.<String> = new <String>["alliancesLevelDefinitions.xml","alliancesRewardsDefinitions.xml","alliancesSettings.xml","alliancesWarTypesDefinitions.xml","animationsDefinitions.xml","backgroundDefinitions.xml","betsDefinitions.xml","betsSettings.xml","botShipsDefinitions.xml","bulletsDefinitions.xml","bunkersDefinitions.xml","civilDefinitions.xml","collectablesDefinitions.xml","contestDefinitions.xml","craftingDefinitions.xml","creditsDefinitions.xml","damageProtectionDefinitions.xml","decorationDefinitions.xml","defensesDefinitions.xml","droidsDefinitions.xml","flagImagesDefinitions.xml","funnelDefinitions.xml","groundUnitsDefinitions.xml","guiDefinitions.xml","hangarsDefinitions.xml","happeningDefinitions.xml","happeningTypeBirthdayDefinitions.xml","happeningTypeWaveDefinitions.xml","happeningTypeWinterDefinitions.xml","helpsDefinitions.xml","investsRewardsDefinitions.xml","investsSettings.xml","itemsDefinitions.xml","laboratoriesDefinitions.xml","levelScoreDefinitions.xml","loadingDefinitions.xml","loadingTips.xml","mapDefinitions.xml","mapViewDefinitions.xml","mecaUnitsDefinitions.xml","missionDefinitions.xml","misteryRewardsDefinitions.xml","newPayerPromoDefinitions.xml","npcAttacksDefinitions.xml","npcDefinitions.xml","obstaclesDefinitions.xml","planetsDefinitions.xml","platformSettingsDefinitions.xml","pollDefinitions.xml","popupSkinsDefinitions.xml","powerUpDefinitions.xml","premiumShopDefinitions.xml","protectionTimeDefinitions.xml","purchaseShopsDefinitions.xml","rebornObstaclesDefinitions.xml","resourcesBoxesDefinitions.xml","resourcesCoinsDefinitions.xml","resourcesMineralsDefinitions.xml","resourcesSilosDefinitions.xml","rewardsDefinitions.xml","settings.xml","shipyardDefinitions.xml","shopProgressDefinitions.xml","shotPriorityDefinitions.xml","spaceStarsDefinitions.xml","specialAttacksDefinitions.xml","spyCapsulesShopDefinitions.xml","squadsDefinitions.xml","TimePriceDiscountsDefinitions.xml","tutorialDefinitions.xml","umbrellaSettings.xml","umbrellaSkinDefinitions.xml","warPointsPerHQDefinitions.xml","warSmallShipsDefinitions.xml","waveDefinitions.xml","waveSpawnDefinitions.xml","wonderDefinitions.xml"];
      
      public static const DEFAULT_PRICE_SKU:String = "instantHouses";
      
      public static const INSTANT_HOUSES_PRICE_SKU:String = "instantUnits";
      
      public static const INSTANT_UNITS_PRICE_SKU:String = "instantUnits";
      
      public static const INSTANT_UNITS_TRAINING_PRICE_SKU:String = "instantUnitsTraining";
      
      public static const INSTANT_HAPPENING_WAVE_PRICE_SKU:String = "instantHappeningWave";
      
      public static const CONVERSION_RESOURCES_TO_USD_PRICE_SKU:String = "conversionResourcesToUSD";
      
      public static const CONVERSION_USD_TO_RESOURCES_SKU:String = "conversionUSDToResources";
      
      private static const TRANS_TYPE_STANDARD:String = "typeStandard";
       
      
      private var mBattleData:Dictionary;
      
      private var mUserCurrency:String = "";
      
      private var mCurrencyExchangeValue:Number;
      
      private var mNpcsWaves:Dictionary;
      
      private var mNpcsNpcSkus:Dictionary;
      
      private var mNpcsDeployX:Dictionary;
      
      private var mNpcsDeployY:Dictionary;
      
      private var mNpcsDeployWays:Dictionary;
      
      private var mNpcsDurations:Dictionary;
      
      private var mSigExtra:String = "";
      
      private var mShopNewSkusToMarkAsSeen:Array;
      
      private var mShopNewCount:int = -1;
      
      private var mShopProfile:Profile;
      
      public function RuleMng()
      {
         super(FILES_SKUS,SIG_SKUS);
      }
      
      override protected function childrenCreate() : void
      {
         var animDefFiles:Vector.<String> = new <String>["animationsDefinitions.xml"];
         var animationDefMng:AnimationsDefMng = new AnimationsDefMng(animDefFiles);
         InstanceMng.registerAnimationsDefMng(animationDefMng);
         childrenAddChild(animationDefMng);
         var mapViewFiles:Vector.<String> = new <String>["mapViewDefinitions.xml"];
         InstanceMng.registerMapViewDefMng(new DCMapViewDefMng(mapViewFiles,null,"assets/flash/"));
         childrenAddChild(InstanceMng.getMapViewDefMng());
         var guiDefFiles:Vector.<String> = new <String>["guiDefinitions.xml"];
         var guiDefMng:DCGUIDefMng = new DCGUIDefMng(guiDefFiles);
         InstanceMng.registerGUIDefMng(guiDefMng);
         DCInstanceMng.getInstance().registerGUIDefMng(guiDefMng);
         childrenAddChild(guiDefMng);
         var levelScoreDefFiles:Vector.<String> = new <String>["levelScoreDefinitions.xml"];
         InstanceMng.registerLevelScoreDefMng(new LevelScoreDefMng(levelScoreDefFiles));
         childrenAddChild(InstanceMng.getLevelScoreDefMng());
         var damageDefFiles:Vector.<String> = new <String>["damageProtectionDefinitions.xml"];
         InstanceMng.registerDamageProtectionDefMng(new DamageProtectionDefMng(damageDefFiles));
         childrenAddChild(InstanceMng.getDamageProtectionDefMng());
         var worldItemDefMng:WorldItemDefMng = new WorldItemDefMng();
         InstanceMng.registerWorldItemDefMng(worldItemDefMng);
         childrenAddChild(worldItemDefMng);
         WorldItemObject.setWorldItemDefMng(worldItemDefMng);
         InstanceMng.registerShipDefMng(new ShipDefMng());
         childrenAddChild(InstanceMng.getShipDefMng());
         InstanceMng.registerSettingsDefMng(new SettingsDefMng());
         childrenAddChild(InstanceMng.getSettingsDefMng());
         InstanceMng.registerTargetDefMng(new TargetDefMng());
         childrenAddChild(InstanceMng.getTargetDefMng());
         var droidDefFiles:Vector.<String> = new <String>["droidsDefinitions.xml"];
         var droidDefMng:DroidDefMng = new DroidDefMng(droidDefFiles);
         InstanceMng.registerDroidDefMng(droidDefMng);
         childrenAddChild(droidDefMng);
         var civilDefFiles:Vector.<String> = new <String>["civilDefinitions.xml"];
         var civilDefMng:CivilDefMng = new CivilDefMng(civilDefFiles);
         InstanceMng.registerCivilDefMng(civilDefMng);
         childrenAddChild(civilDefMng);
         var unitsDefFiles:Vector.<String> = new <String>["bulletsDefinitions.xml"];
         var unitsDefMng:UnitDefMng = new UnitDefMng(unitsDefFiles);
         InstanceMng.registerUnitDefMng(unitsDefMng);
         childrenAddChild(unitsDefMng);
         var itemsDefFiles:Vector.<String> = new <String>["itemsDefinitions.xml"];
         var itemsDefMng:ItemsDefMng = new ItemsDefMng(itemsDefFiles);
         InstanceMng.registerItemDefMng(itemsDefMng);
         childrenAddChild(itemsDefMng);
         var collectablesMngDefFiles:Vector.<String> = new <String>["collectablesDefinitions.xml"];
         var collectablesMng:CollectablesDefMng = new CollectablesDefMng(collectablesMngDefFiles);
         InstanceMng.registerCollectablesDefMng(collectablesMng);
         childrenAddChild(collectablesMng);
         var craftingMngDefFiles:Vector.<String> = new <String>["craftingDefinitions.xml"];
         var craftingMng:CraftingDefMng = new CraftingDefMng(craftingMngDefFiles);
         InstanceMng.registerCraftingDefMng(craftingMng);
         childrenAddChild(craftingMng);
         var specialAttacksMng:SpecialAttacksDefMng = new SpecialAttacksDefMng();
         InstanceMng.registerSpecialAttacksDefMng(specialAttacksMng);
         childrenAddChild(specialAttacksMng);
         var premiumPricesDefFiles:Vector.<String> = new <String>["TimePriceDiscountsDefinitions.xml"];
         InstanceMng.registerPremiumPricesDefMng(new PremiumPricesDefMng(premiumPricesDefFiles));
         childrenAddChild(InstanceMng.getPremiumPricesDefMng());
         var protectionTimeDefFiles:Vector.<String> = new <String>["protectionTimeDefinitions.xml"];
         InstanceMng.registerProtectionTimeDefMng(new ProtectionTimeDefMng(protectionTimeDefFiles));
         childrenAddChild(InstanceMng.getProtectionTimeDefMng());
         var rebornObstaclesDefFiles:Vector.<String> = new <String>["rebornObstaclesDefinitions.xml"];
         InstanceMng.registerRebornObstaclesDefMng(new RebornObstaclesDefMng(rebornObstaclesDefFiles));
         childrenAddChild(InstanceMng.getRebornObstaclesDefMng());
         var resourcesBoxesDefFiles:Vector.<String> = new <String>["resourcesBoxesDefinitions.xml"];
         InstanceMng.registerBuyResourcesBoxDefMng(new BuyResourcesBoxDefMng(resourcesBoxesDefFiles));
         childrenAddChild(InstanceMng.getBuyResourcesBoxDefMng());
         var rewardsDefFiles:Vector.<String> = new <String>["rewardsDefinitions.xml"];
         InstanceMng.registerRewardsDefMng(new RewardsDefMng(rewardsDefFiles));
         childrenAddChild(InstanceMng.getRewardsDefMng());
         var misteryRewardsDefFiles:Vector.<String> = new <String>["misteryRewardsDefinitions.xml"];
         InstanceMng.registerMisteryRewardDefMng(new MisteryRewardDefMng(misteryRewardsDefFiles));
         childrenAddChild(InstanceMng.getMisteryRewardDefMng());
         var solarSystemDefFiles:Vector.<String> = new <String>["spaceStarsDefinitions.xml"];
         InstanceMng.registerSolarSystemDefMng(new SolarSystemDefMng(solarSystemDefFiles));
         childrenAddChild(InstanceMng.getSolarSystemDefMng());
         var creditsDefFiles:Vector.<String> = new <String>["creditsDefinitions.xml"];
         InstanceMng.registerCreditsDefMng(new CreditsDefMng(creditsDefFiles));
         childrenAddChild(InstanceMng.getCreditsMng());
         var planetsDefFiles:Vector.<String> = new <String>["planetsDefinitions.xml"];
         InstanceMng.registerPlanetDefMng(new PlanetDefMng(planetsDefFiles));
         childrenAddChild(InstanceMng.getPlanetDefMng());
         var backgroundDefFiles:Vector.<String> = new <String>["backgroundDefinitions.xml"];
         InstanceMng.registerBackgroundDefMng(new BackgroundDefMng(backgroundDefFiles));
         childrenAddChild(InstanceMng.getBackgroundDefMng());
         var alliancesSettingsDefFiles:Vector.<String> = new <String>["alliancesSettings.xml"];
         InstanceMng.registerAlliancesSettingsDefMng(new AlliancesSettingsDefMng(alliancesSettingsDefFiles));
         childrenAddChild(InstanceMng.getAlliancesSettingsDefMng());
         var alliancesLevelDefFiles:Vector.<String> = new <String>["alliancesLevelDefinitions.xml"];
         InstanceMng.registerAlliancesLevelDefMng(new AlliancesLevelDefMng(alliancesLevelDefFiles));
         childrenAddChild(InstanceMng.getAlliancesLevelDefMng());
         var flagImagesDefFiles:Vector.<String> = new <String>["flagImagesDefinitions.xml"];
         InstanceMng.registerFlagImagesDefMng(new FlagImagesDefMng(flagImagesDefFiles));
         childrenAddChild(InstanceMng.getFlagImagesDefMng());
         var alliancesRewardsDefFiles:Vector.<String> = new <String>["alliancesRewardsDefinitions.xml"];
         InstanceMng.registerAlliancesRewardDefMng(new AlliancesRewardDefMng(alliancesRewardsDefFiles));
         childrenAddChild(InstanceMng.getAlliancesRewardDefMng());
         var files:Vector.<String> = new <String>["shotPriorityDefinitions.xml"];
         InstanceMng.registerShotPriorityDefMng(new ShotPriorityDefMng(files));
         childrenAddChild(InstanceMng.getShotPriorityDefMng());
         var platformSettings:Vector.<String> = new <String>["platformSettingsDefinitions.xml"];
         InstanceMng.registerPlatformSettingsDefMng(new PlatformSettingsDefMng(platformSettings));
         childrenAddChild(InstanceMng.getPlatformSettingsDefMng());
         var funnelFiles:Vector.<String> = new <String>["funnelDefinitions.xml"];
         InstanceMng.registerFunnelStepDefMng(new FunnelStepDefMng(funnelFiles));
         childrenAddChild(InstanceMng.getFunnelStepDefMng());
         var defFiles:Vector.<String> = new <String>["investsSettings.xml"];
         InstanceMng.registerInvestsSettingsDefMng(new InvestsSettingsDefMng(defFiles));
         childrenAddChild(InstanceMng.getInvestsSettingsDefMng());
         defFiles = new <String>["investsRewardsDefinitions.xml"];
         InstanceMng.registerInvestRewardsDefMng(new InvestRewardsDefMng(defFiles));
         childrenAddChild(InstanceMng.getInvestRewardsDefMng());
         defFiles = new <String>["spyCapsulesShopDefinitions.xml"];
         InstanceMng.registerSpyCapsulesShopDefMng(new SpyCapsulesShopDefMng(defFiles));
         childrenAddChild(InstanceMng.getSpyCapsulesShopDefMng());
         defFiles = new <String>["newPayerPromoDefinitions.xml"];
         InstanceMng.registerNewPayerPromoDefMng(new NewPayerPromoDefMng(defFiles));
         childrenAddChild(InstanceMng.getNewPayerPromoDefMng());
         defFiles = new <String>["happeningDefinitions.xml"];
         InstanceMng.registerHappeningDefMng(new HappeningDefMng(defFiles));
         childrenAddChild(InstanceMng.getHappeningDefMng());
         defFiles = new <String>["happeningDefinitions.xml"];
         InstanceMng.registerHappeningTypeDefMng(new HappeningTypeDefMng());
         childrenAddChild(InstanceMng.getHappeningTypeDefMng());
         defFiles = new <String>["waveSpawnDefinitions.xml"];
         InstanceMng.registerWaveSpawnDefMng(new WaveSpawnDefMng(defFiles));
         childrenAddChild(InstanceMng.getWaveSpawnDefMng());
         defFiles = new <String>["waveDefinitions.xml"];
         InstanceMng.registerWaveDefMng(new WaveDefMng(defFiles));
         childrenAddChild(InstanceMng.getWaveDefMng());
         if(Config.usePowerUps())
         {
            defFiles = new <String>["powerUpDefinitions.xml"];
            InstanceMng.registerPowerUpDefMng(new PowerUpDefMng(defFiles));
            childrenAddChild(InstanceMng.getPowerUpDefMng());
         }
         defFiles = new <String>["popupSkinsDefinitions.xml"];
         InstanceMng.registerPopupSkinDefMng(new PopupSkinDefMng(defFiles));
         childrenAddChild(InstanceMng.getPopupSkinDefMng());
         defFiles = new <String>["betsDefinitions.xml"];
         InstanceMng.registerBetDefMng(new BetDefMng(defFiles));
         childrenAddChild(InstanceMng.getBetDefMng());
         defFiles = new <String>["betsSettings.xml"];
         InstanceMng.registerBetsSettingsDefMng(new BetsSettingsDefMng(defFiles));
         childrenAddChild(InstanceMng.getBetsSettingsDefMng());
         defFiles = new <String>["contestDefinitions.xml"];
         InstanceMng.registerContestDefMng(new ContestDefMng(defFiles));
         childrenAddChild(InstanceMng.getContestDefMng());
         if(Config.useUmbrella())
         {
            defFiles = new <String>["umbrellaSettings.xml"];
            InstanceMng.registerUmbrellaSettingsDefMng(new UmbrellaSettingsDefMng(defFiles));
            childrenAddChild(InstanceMng.getUmbrellaSettingsDefMng());
            defFiles = new <String>["umbrellaSkinDefinitions.xml"];
            InstanceMng.registerUmbrellaSkinDefMng(new UmbrellaSkinDefMng(defFiles));
            childrenAddChild(InstanceMng.getUmbrellaSkinDefMng());
         }
         defFiles = new <String>["shopProgressDefinitions.xml"];
         InstanceMng.registerShopProgressDefMng(new ShopProgressDefMng(defFiles));
         childrenAddChild(InstanceMng.getShopProgressDefMng());
         defFiles = new <String>["purchaseShopsDefinitions.xml"];
         InstanceMng.registerPurchaseShopDefMng(new PurchaseShopDefMng(defFiles));
         childrenAddChild(InstanceMng.getPurchaseShopDefMng());
         defFiles = new <String>["premiumShopDefinitions.xml"];
         InstanceMng.registerPremiumShopDefMng(new ShopDefMng(defFiles));
         childrenAddChild(InstanceMng.getPremiumShopDefMng());
         defFiles = new <String>["helpsDefinitions.xml"];
         InstanceMng.registerHelpsDefMng(new HelpsDefMng(defFiles));
         childrenAddChild(InstanceMng.getHelpsDefMng());
         defFiles = new <String>["npcDefinitions.xml"];
         InstanceMng.registerNPCDefMng(new NPCDefMng(defFiles));
         childrenAddChild(InstanceMng.getNPCDefMng());
         defFiles = new <String>["alliancesWarTypesDefinitions.xml"];
         InstanceMng.registerAlliancesWarTypesDefMng(new AlliancesWarTypesDefMng(defFiles));
         childrenAddChild(InstanceMng.getAlliancesWarTypesDefMng());
         defFiles = new <String>["warPointsPerHQDefinitions.xml"];
         InstanceMng.registerWarPointsPerHQDefMng(new WarPointsPerHQDefMng(defFiles));
         childrenAddChild(InstanceMng.getWarPointsPerHQDefMng());
         defFiles = new <String>["pollDefinitions.xml"];
         InstanceMng.registerPollDefMng(new PollDefMng(defFiles));
         childrenAddChild(InstanceMng.getPollDefMng());
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         this.mBattleData = new Dictionary(true);
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         this.npcsUnload();
         this.mBattleData = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(filesIsFileLoaded("npcAttacksDefinitions.xml"))
         {
            this.npcsReadAttacks();
            buildAdvanceSyncStep();
         }
      }
      
      public function getDefBySku(sku:String) : DCDef
      {
         var child:DCDefMng = null;
         var i:int = 0;
         var returnValue:DCDef = null;
         if(mChildren != null)
         {
            i = mChildren.length - 1;
            while(i > -1 && returnValue == null)
            {
               if((child = mChildren[i] as DCDefMng) != null)
               {
                  returnValue = child.getDefBySku(sku);
               }
               i--;
            }
         }
         return returnValue;
      }
      
      public function getConstructionTime(item:WorldItemObject) : Number
      {
         return item.getNextDef().getConstructionTime();
      }
      
      public function getCashToCoins() : Number
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getCashToCoins();
      }
      
      public function getCashToMinerals() : Number
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getCashToMinerals();
      }
      
      public function getDefaultDroids() : int
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getDefaultDroids();
      }
      
      public function getDestroyItemProfitPercentage() : int
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getDestroyItemProfitPercentage();
      }
      
      public function getCancelBuildingUpgradeProfitPercentage() : Number
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getCancelBuildingUpgradeProfitPercentage();
      }
      
      public function getMinutePriceToCoins() : int
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getMinutesToCoins();
      }
      
      public function getMinutePriceToMinerals() : int
      {
         return InstanceMng.getSettingsDefMng().mSettingsDef.getMinutesToMinerals();
      }
      
      public function getTransactionEndBuild(item:WorldItemObject) : Transaction
      {
         var transaction:Transaction = new Transaction();
         transaction.setWorldItemObject(item);
         transaction.setTransXp(item.getNextDef().getConstructionXp());
         transaction.setTransScore(item.getNextDef().getScoreBuilt());
         return transaction;
      }
      
      public function getTransactionBuySpecialAttack(sku:String, payedWithCash:Boolean) : Transaction
      {
         return payedWithCash ? this.getTransactionBuySpecialAttackWithCash(sku) : this.getTransactionBuySpecialAttackWithItem(sku);
      }
      
      public function getTransactionBuySpecialAttackWithCash(sku:String) : Transaction
      {
         var specialAttackDef:SpecialAttacksDef = SpecialAttacksDef(InstanceMng.getSpecialAttacksDefMng().getDefBySku(sku));
         var transaction:Transaction = new Transaction();
         transaction.setTransCash(-1 * specialAttackDef.getCash());
         return transaction;
      }
      
      public function getTransactionBuySpecialAttackWithItem(sku:String) : Transaction
      {
         var specialAttackDef:SpecialAttacksDef = SpecialAttacksDef(InstanceMng.getSpecialAttacksDefMng().getDefBySku(sku));
         var transaction:Transaction = new Transaction();
         transaction.setApplyOnProfile(false);
         transaction.addTransItem(specialAttackDef.getItemSku(),-1);
         transaction.setTransRewardObject(InstanceMng.getItemsMng().getRewardFromSpecialAttackDef(specialAttackDef),-1);
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionInstantBuild(item:WorldItemObject, e:Object) : Transaction
      {
         return this.getInstantOperationTransaction(item,"WIOEventInstantBuild",e);
      }
      
      private function getTransactionInstantDemolish(item:WorldItemObject, e:Object) : Transaction
      {
         return this.getInstantOperationTransaction(item,"WIOEventInstantDemolish",e);
      }
      
      public function getTransactionInstantUpgrade(e:Object) : Transaction
      {
         var item:WorldItemObject = WorldItemObject(e.item);
         return this.getInstantOperationTransaction(item,"WIOEventInstantUpgrade",e);
      }
      
      private function getInstantOperationTransaction(item:WorldItemObject, eventName:String, e:Object, returnAlternative:Boolean = true, priceSku:String = "instantHouses") : Transaction
      {
         var cashPrice:int = 0;
         var totalCoins:int = 0;
         var totalMinerals:int = 0;
         var timeLeft:Number = NaN;
         var timeLeftMs:Number = NaN;
         var allItems:Vector.<WorldItemObject> = null;
         var instantOpCurrency:int = 0;
         var settingsDefMng:SettingsDefMng;
         var settingsDef:SettingsDef = (settingsDefMng = InstanceMng.getSettingsDefMng()).mSettingsDef;
         var transaction:Transaction = new Transaction();
         var minutePrice:int = InstanceMng.getRuleMng().getMinutePriceToCoins();
         var itemDef:WorldItemDef = item.getNextDef();
         var instantOpThreshold:Number = settingsDefMng.getInstantOpTimeThreshold();
         var labourId:int = item.labourGetId();
         if(item.labourIsWaitingForDroid() && (labourId == 1 || labourId == 0))
         {
            timeLeftMs = itemDef.getConstructionTime();
            timeLeft = DCTimerUtil.msToMin(itemDef.getConstructionTime());
         }
         else
         {
            timeLeftMs = item.getTimeLeft();
            timeLeft = DCTimerUtil.msToMin(timeLeftMs);
         }
         if(eventName == "WIOEventInstantDemolish")
         {
            timeLeftMs = 0;
            timeLeft = 0;
         }
         if(timeLeftMs < instantOpThreshold)
         {
            cashPrice = 0;
            switch((instantOpCurrency = InstanceMng.getRuleMng().getInstantOperationsCurrency()) - 1)
            {
               case 0:
                  totalCoins = -this.exchangeMinsToCoins(timeLeft);
                  break;
               case 1:
                  totalMinerals = -this.exchangeMinsToMinerals(timeLeft);
            }
         }
         else
         {
            cashPrice = -this.exchangeMinsToCash(timeLeft,priceSku);
            totalCoins = 0;
            totalMinerals = 0;
         }
         var xp:Number = 0;
         var score:Number = 0;
         if(eventName == "WIOEventInstantBuild" || eventName == "WIOEventInstantUpgrade")
         {
            xp = itemDef.getConstructionXp();
            score = itemDef.getScoreBuilt();
         }
         if(allItems)
         {
            xp *= allItems.length;
            score *= allItems.length;
            cashPrice *= allItems.length;
            totalMinerals *= allItems.length;
         }
         transaction.setTransEvent(eventName);
         transaction.setWorldItemObject(item);
         transaction.setTransCash(cashPrice);
         transaction.setTransCoins(totalCoins);
         transaction.setTransMinerals(totalMinerals);
         transaction.setTransXp(xp);
         transaction.setTransScore(score);
         transaction.setTransDroids(0);
         transaction.setTransTime(timeLeft);
         transaction.computeAmountsLeftValues();
         if(e != null)
         {
            transaction.setTransInfoPackage(e);
         }
         return transaction;
      }
      
      private function getPremiumCostOfCurrencies(trans:Transaction, checkMinerals:Boolean = false) : Number
      {
         var coinsToExchange:Number = NaN;
         var mineralsToExchange:Number = NaN;
         var premiumToCoins:Number = this.getCashToCoins();
         var premiumToMinerals:Number = this.getCashToMinerals();
         var diffCoins:Number = trans.mDifferenceCoins.value;
         var diffMinerals:Number = trans.mDifferenceMinerals.value;
         var premiumPrice:Number = 0;
         if(diffCoins < 0)
         {
            coinsToExchange = Math.abs(diffCoins);
         }
         if(checkMinerals && diffMinerals < 0)
         {
            coinsToExchange = Math.abs(diffMinerals);
         }
         return this.calculateResourcesPrice(coinsToExchange,mineralsToExchange);
      }
      
      private function getTransactionUpgrade(item:WorldItemObject, e:Object) : Transaction
      {
         var itemDef:WorldItemDef = null;
         var priceCash:Number = NaN;
         var priceCoins:Number = NaN;
         var priceMinerals:Number = NaN;
         var transaction:Transaction = null;
         var items:Vector.<WorldItemObject> = null;
         var amountItemsNeeded:int = 0;
         var priceItemSku:String = null;
         var priceItemAmount:Number = NaN;
         var i:int = 0;
         var droids:int = 1;
         if(item != null)
         {
            priceCoins = (itemDef = item.getUpgradeDef()).getConstructionCoins() * -1;
            priceMinerals = itemDef.getConstructionMineral() * -1;
            transaction = new Transaction();
            items = e.items;
            priceCoins *= !!items ? items.length : 1;
            priceMinerals *= !!items ? items.length : 1;
            if(item.mDef.isAWall() || item.mDef.isAMine())
            {
               droids = 0;
            }
            transaction.setTransEvent("WIOEventUpgradeStart");
            transaction.setWorldItemDef(itemDef);
            transaction.setTransCash(0);
            transaction.setTransCoins(Math.round(priceCoins));
            transaction.setTransMinerals(Math.round(priceMinerals));
            transaction.setTransXp(0);
            transaction.setTransScore(0);
            transaction.setTransDroids(droids);
            amountItemsNeeded = itemDef.getNumUpgradeItemsNeeded();
            for(i = 0; i < amountItemsNeeded; )
            {
               priceItemSku = itemDef.getUpgradeItemsNeededSku(i);
               priceItemAmount = itemDef.getUpgradeItemsNeededAmount(i) * -1;
               transaction.addTransItem(priceItemSku,priceItemAmount);
               i++;
            }
            transaction.setTransInfoPackage(e);
            transaction.computeAmountsLeftValues();
         }
         return transaction;
      }
      
      private function getTransactionCancelUpgrade(item:WorldItemObject, e:Object) : Transaction
      {
         var priceItemAmount:int = 0;
         var itemDef:WorldItemDef = null;
         var priceCoins:Number = NaN;
         var priceMinerals:Number = NaN;
         var priceCash:Number = NaN;
         var percentageCancelled:Number = NaN;
         var transaction:Transaction = null;
         var priceItemSku:String = null;
         var i:int = 0;
         if(item != null)
         {
            itemDef = item.getUpgradeDef();
            priceCoins = itemDef.getConstructionCoins();
            priceMinerals = itemDef.getConstructionMineral();
            priceCash = itemDef.getConstructionCash();
            percentageCancelled = this.getCancelBuildingUpgradeProfitPercentage();
            (transaction = new Transaction()).setTransEvent("WIOEventCancelUpgrade");
            transaction.setWorldItemDef(itemDef);
            transaction.setTransCash(Math.floor(priceCash * percentageCancelled / 100));
            transaction.setTransCoins(Math.floor(priceCoins * percentageCancelled / 100));
            transaction.setTransMinerals(Math.floor(priceMinerals * percentageCancelled / 100));
            for(i = 0; i < itemDef.getNumUpgradeItemsNeeded(); )
            {
               priceItemSku = itemDef.getUpgradeItemsNeededSku(i);
               priceItemAmount = Math.ceil(itemDef.getUpgradeItemsNeededAmount(i) * percentageCancelled / 100);
               transaction.addTransItem(priceItemSku,priceItemAmount);
               i++;
            }
            transaction.setTransXp(0);
            transaction.setTransDroids(0);
            transaction.setIsDevolution(true);
            transaction.setTransInfoPackage(e);
            transaction.computeAmountsLeftValues();
            transaction.setWorldItemObject(item);
         }
         return transaction;
      }
      
      private function getTransactionUnlockSlotShipyard(event:Object) : Transaction
      {
         var priceCash:Number = event.fbPrice * -1;
         var transaction:Transaction = new Transaction();
         transaction.setTransEvent("NotifyUnlockShipSlot");
         transaction.setTransCash(Math.round(priceCash));
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      private function getTransactionBuyItemsWithPremiumCurrency(event:Object) : Transaction
      {
         var arr:Array = null;
         var cashPrice:int = event.fbPrice * -1;
         var itemList:Vector.<Array> = event.itemList;
         var transaction:Transaction;
         (transaction = new Transaction()).setTransEvent("NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY");
         transaction.setTransCash(Math.round(cashPrice));
         for each(arr in itemList)
         {
            transaction.addTransItem(arr[0],arr[1],true);
         }
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      private function getTransactionDemolishStart(itemDef:WorldItemDef, e:Object) : Transaction
      {
         var transaction:Transaction = new Transaction();
         transaction.setWorldItemDef(itemDef);
         if(itemDef.requiresDroidToBeDemolished())
         {
            transaction.setTransDroids(1);
         }
         else
         {
            transaction.setTransDroids(0);
         }
         transaction.setTransInfoPackage(e);
         transaction.computeAmountsLeftValues();
         transaction.setCheckServerResponseEnabled(false);
         return transaction;
      }
      
      public function getTransactionDemolishEnd(itemDef:WorldItemDef, e:Object) : Transaction
      {
         var factor:int = 1;
         var numDroidsNeeded:int = 0;
         var priceCoins:Number = itemDef.getConstructionCoins() * factor;
         var priceMinerals:Number = itemDef.getConstructionMineral() * factor;
         var percentageDestroy:int = this.getDestroyItemProfitPercentage();
         var transaction:Transaction = new Transaction();
         var cashPrice:Number = 0;
         transaction.setTransEvent("WIOEventDemolitionEndEnd");
         transaction.setWorldItemDef(itemDef);
         transaction.setTransCoins(Math.floor(priceCoins * percentageDestroy / 100));
         transaction.setTransMinerals(Math.floor(priceMinerals * percentageDestroy / 100));
         transaction.setTransXp(0);
         transaction.setTransDroids(numDroidsNeeded);
         transaction.setTransInfoPackage(e);
         var profile:Profile;
         var coinsCapacity:Number = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getCoinsCapacity();
         var storage:Number = itemDef.getCoinsStorage();
         var mineralsCapacity:Number = profile.getMineralsCapacity();
         if(storage > 0)
         {
            coinsCapacity -= storage;
         }
         if((storage = itemDef.getMineralsStorage()) > 0)
         {
            mineralsCapacity -= storage;
         }
         transaction.computeAmountsLeftValues(coinsCapacity,mineralsCapacity);
         return transaction;
      }
      
      private function getTransactionShopBuy(itemDef:WorldItemDef, event:Object) : Transaction
      {
         var cashCreditsPrice:Number = itemDef.getConstructionCash() * -1;
         var priceCoins:Number = itemDef.getConstructionCoins() * -1;
         var priceMinerals:Number = itemDef.getConstructionMineral() * -1;
         var priceDroids:int = itemDef.requiresDroidToBePlaced() ? 1 : 0;
         var amount:int = InstanceMng.getWorld().itemsAmountGet(itemDef.mSku);
         var amountAllowed:int = this.wioMaxNumPerCurrentHQUpgradeId(itemDef.mSku);
         var transaction:Transaction;
         (transaction = new Transaction()).setTransEvent("NOTIFY_SHOP_BUY");
         transaction.setWorldItemDef(itemDef);
         transaction.setTransCash(cashCreditsPrice);
         transaction.setTransCoins(priceCoins);
         transaction.setTransMinerals(priceMinerals);
         transaction.setTransDroids(priceDroids);
         transaction.setTransResponseToValue(event);
         if(event != null)
         {
            transaction.setTransInfoPackage(event);
         }
         transaction.setTransAmountOwned(amount);
         transaction.setTransAmountAllowed(amountAllowed);
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      private function getTransactionCancelBuild(item:WorldItemObject, e:Object) : Transaction
      {
         var transaction:Transaction = null;
         var itemDef:WorldItemDef = null;
         var priceCash:Number = NaN;
         var priceCoins:Number = NaN;
         var priceMinerals:Number = NaN;
         var percentageCancelled:Number = NaN;
         if(item != null)
         {
            itemDef = item.mDef;
            priceCoins = itemDef.getConstructionCoins();
            priceMinerals = itemDef.getConstructionMineral();
            percentageCancelled = this.getCancelBuildingUpgradeProfitPercentage();
            (transaction = new Transaction()).setTransEvent("WIOEventCancelUpgrade");
            transaction.setWorldItemDef(itemDef);
            transaction.setTransCash(itemDef.getConstructionCash());
            transaction.setTransCoins(Math.floor(priceCoins * percentageCancelled / 100));
            transaction.setTransMinerals(Math.floor(priceMinerals * percentageCancelled / 100));
            transaction.setTransXp(0);
            transaction.setTransDroids(0);
            transaction.setTransInfoPackage(e);
            transaction.computeAmountsLeftValues();
            transaction.setWorldItemObject(item);
         }
         return transaction;
      }
      
      public function getTransactionDroidBuy(droidDef:DroidDef, transType:String = "typeStandard") : Transaction
      {
         var items:Array = null;
         var itemStr:String = null;
         var itemArr:Array = null;
         var priceCoins:Number = droidDef.getConstructionCoins() * -1;
         switch(transType)
         {
            case "typeStandard":
               items = this.getDroidPaymentItemsList(droidDef);
               break;
            case "typeInvest":
               items = droidDef.getInvestItemList();
         }
         var transaction:Transaction;
         (transaction = new Transaction()).setTransType(transType);
         transaction.setTransEvent("NOTIFY_DROIDS_BUY");
         transaction.setTransCoins(priceCoins);
         transaction.setTransXp(droidDef.getConstructionXp());
         for each(itemStr in items)
         {
            itemArr = itemStr.split(":");
            transaction.addTransItem(itemArr[0],itemArr[1] * -1);
         }
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionCollect(item:WorldItemObject) : Transaction
      {
         var amount:Number = item.getIncomeAmount();
         if(item.hasCollectionBonus())
         {
            amount += item.getCollectionBonusAmount();
         }
         var incomeCurrencyId:int = item.mDef.getIncomeCurrencyId();
         var transaction:Transaction;
         (transaction = new Transaction()).setTransEvent("WIORentWaitingEnd");
         transaction.setWorldItemObject(item);
         transaction.setTransDroids(0);
         switch(incomeCurrencyId - 1)
         {
            case 0:
               transaction.setTransCoins(amount);
               break;
            case 1:
               transaction.setTransMinerals(amount);
         }
         var profile:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         amount -= profile.regulateCurrency(amount,incomeCurrencyId,true,false);
         transaction.setTransXp(item.mDef.getIncomeXp(amount));
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionSpeedUpQueue(event:Object) : Transaction
      {
         var premium:int = 0;
         var sku:String = null;
         var shipyard:Shipyard = null;
         var timeShipUnderConstruction:Number = NaN;
         var trans:Transaction = null;
         var def:ShipDef = null;
         var cash:Number = NaN;
         var totalTimeLeft:int = 0;
         var count:int = 0;
         var timeMins:Number = NaN;
         var elementsSkus:String;
         var skusArr:Array = (elementsSkus = String(event.elementsSkus)).split(",");
         var shipDefMng:ShipDefMng = InstanceMng.getShipDefMng();
         var itemsDef:Vector.<ShipDef> = new Vector.<ShipDef>(0);
         for each(sku in skusArr)
         {
            if(sku != null && sku != "")
            {
               itemsDef.push(InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef.getUpgradeId()));
            }
         }
         timeShipUnderConstruction = (shipyard = Shipyard(event.item)).getShipTimeLeft();
         trans = new Transaction();
         cash = 0;
         totalTimeLeft = 0;
         count = 0;
         for each(def in itemsDef)
         {
            if(count > 0)
            {
               totalTimeLeft += def.getConstructionTime();
            }
            count++;
         }
         totalTimeLeft += timeShipUnderConstruction;
         timeMins = DCTimerUtil.msToMin(totalTimeLeft);
         cash = -this.exchangeMinsToCash(timeMins,"instantUnitsTraining");
         trans.setTransTime(timeMins);
         trans.setTransCash(cash);
         trans.computeAmountsLeftValues();
         return trans;
      }
      
      public function getTransactionSpeedUpUpgradeUnit(unitSku:String) : Transaction
      {
         var timeLeft:Number = NaN;
         var upgradeLevel:int = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(unitSku).mDef.getUpgradeId();
         var def:ShipDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(unitSku,upgradeLevel + 1);
         var gameUnit:GameUnit;
         if((gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit()) == null && def != null)
         {
            timeLeft = DCTimerUtil.msToMin(def.getCostTime());
         }
         else
         {
            if(gameUnit == null)
            {
               return null;
            }
            timeLeft = DCTimerUtil.msToMin(gameUnit.mTimeLeft);
         }
         var cash:Number = -this.exchangeMinsToCash(timeLeft,"instantUnits");
         var trans:Transaction;
         (trans = new Transaction()).setTransCash(cash);
         trans.setTransTime(timeLeft);
         trans.computeAmountsLeftValues();
         return trans;
      }
      
      public function getTransactionSpeedUpUpgradeUnitByRange(currentUnit:UnitDef, nextUnit:UnitDef, useDiscount:Boolean) : Transaction
      {
         var i:* = 0;
         var def:ShipDef = null;
         var upgradeLevel:int = currentUnit.getUpgradeId() + 1;
         var lastLevel:int = nextUnit.getUpgradeId() + 1;
         var cash:Number = 0;
         var timeLeft:Number = 0;
         var currentTimeLeft:Number = 0;
         for(i = upgradeLevel; i < lastLevel; )
         {
            def = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(currentUnit.mSku,i) as ShipDef;
            currentTimeLeft = DCTimerUtil.msToMin(def.getCostTime());
            cash += -this.exchangeMinsToCash(currentTimeLeft,"instantUnits");
            timeLeft += currentTimeLeft;
            i++;
         }
         var discount:Number = 0;
         if(useDiscount)
         {
            cash = this.applyDiscountUpgradingRange(upgradeLevel,lastLevel,cash);
         }
         var trans:Transaction;
         (trans = new Transaction()).setTransCash(cash);
         trans.setTransTime(timeLeft);
         trans.computeAmountsLeftValues();
         return trans;
      }
      
      public function getTransactionSpeedUp(itemDef:ShipDef, event:Object = null) : Transaction
      {
         var priceCash:Number = NaN;
         var timeLeft:Number = NaN;
         var transaction:Transaction = new Transaction();
         var gameUnit:GameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit();
         timeLeft = itemDef.getCostTime();
         if(gameUnit != null && gameUnit.mDef.mSku == itemDef.mSku)
         {
            timeLeft = gameUnit.mTimeLeft;
         }
         var mins:Number = DCTimerUtil.msToMin(timeLeft);
         priceCash = -this.exchangeMinsToCash(mins,"instantUnits");
         transaction.setTransEvent("NOTIFY_POPUP_OPEN_SPEEDITEM");
         transaction.setTransCash(priceCash);
         var o:Object;
         (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_POPUP_OPEN_SPEEDITEM",event.sendResponseTo)).shipyardId = event.shipyardId;
         o.unitSku = event.unitSku;
         o.unlock = event.unlock;
         transaction.setTransResponseToValue(o);
         transaction.setTransTime(mins);
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionSpeedUpWave(timeLeft:Number) : Transaction
      {
         var trans:Transaction = new Transaction();
         var timeMins:Number = DCTimerUtil.msToMin(timeLeft);
         var cash:Number = -this.exchangeMinsToCash(timeMins,"instantHappeningWave");
         trans.setTransTime(timeMins);
         trans.setTransCash(cash);
         trans.computeAmountsLeftValues();
         return trans;
      }
      
      public function getTransactionRequirements(e:Object, def:ShipDef) : Transaction
      {
         var i:int = 0;
         var priceItemSku:String = null;
         var priceItemAmount:Number = NaN;
         var coins:Number = def.getCostCoins() * -1;
         var minerals:Number = def.getCostMineral() * -1;
         var transaction:Transaction;
         (transaction = new Transaction()).setTransCoins(coins);
         transaction.setTransMinerals(minerals);
         var amountItemsNeeded:int = def.getNumUpgradeItemsNeeded();
         for(i = 0; i < amountItemsNeeded; )
         {
            priceItemSku = def.getUpgradeItemsNeededSku(i);
            priceItemAmount = def.getUpgradeItemsNeededAmount(i) * -1;
            transaction.addTransItem(priceItemSku,priceItemAmount);
            i++;
         }
         transaction.setTransInfoPackage(e);
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionTransfer(e:Object) : Transaction
      {
         var def:ShipDef = null;
         var v:Vector.<ShipDef> = e.defs;
         var minerals:Number = 0;
         var addMinerals:int = 0;
         for each(def in v)
         {
            if((addMinerals = int(def.getConstructionCoins())) == 0)
            {
               addMinerals = def.getConstructionMineral();
            }
            minerals += Math.ceil(addMinerals / 3);
         }
         if(e.transferAmount != null && minerals != e.transferAmount)
         {
            DCDebug.traceCh("ASSERT","minerals mismatch in own client! " + minerals + "," + e.transferAmount + "!! @RuleMng.getTransactionTransfer");
         }
         var returnValue:Transaction = this.createSingleTransaction(true,0,0,minerals,0,null,"",e);
         returnValue.setCloseOpenedPopups(false);
         return returnValue;
      }
      
      public function getTransactionBuyColony(e:Object) : Transaction
      {
         var coins:Number = e.coinsAmount != null ? Number(e.coinsAmount) : 0;
         var minerals:Number = e.mineralsAmount != null ? Number(e.mineralsAmount) : 0;
         var transaction:Transaction;
         (transaction = this.createSingleTransaction(true,0,coins,minerals)).setTransInfoPackage(e);
         return transaction;
      }
      
      public function getTransactionMoveColony(e:Object) : Transaction
      {
         var transaction:Transaction = new Transaction();
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(profile.getFreeColonyMoves() <= 0)
         {
            transaction = this.createSingleTransaction(true,InstanceMng.getSettingsDefMng().getMoveColonyCostPC());
         }
         else
         {
            profile.setFreeColonyMoves(profile.getFreeColonyMoves() - 1);
         }
         transaction.setTransInfoPackage(e);
         return transaction;
      }
      
      public function getTransactionCreateAlliance(e:Object) : Transaction
      {
         var alliancesSettingsDefMng:AlliancesSettingsDefMng = InstanceMng.getAlliancesSettingsDefMng();
         var transaction:Transaction = this.getTransactionFromAmountAndCurrency(alliancesSettingsDefMng.getCreateAlliancePrice(),alliancesSettingsDefMng.getCreateAllianceCurrency());
         transaction.setTransInfoPackage(e);
         return transaction;
      }
      
      public function getTransactionEditAlliance(e:Object) : Transaction
      {
         var alliancesSettingsDefMng:AlliancesSettingsDefMng = InstanceMng.getAlliancesSettingsDefMng();
         var transaction:Transaction = this.getTransactionFromAmountAndCurrency(alliancesSettingsDefMng.getEditAlliancePrice(),alliancesSettingsDefMng.getEditAllianceCurrency());
         transaction.setTransInfoPackage(e);
         return transaction;
      }
      
      public function getTransactionFromAmountAndCurrency(amount:Number, currency:int) : Transaction
      {
         var transaction:Transaction = null;
         switch(currency)
         {
            case 0:
               transaction = this.createSingleTransaction(true,amount,0,0);
               break;
            case 1:
               transaction = this.createSingleTransaction(true,0,amount,0);
               break;
            case 2:
               transaction = this.createSingleTransaction(true,0,0,amount);
         }
         return transaction;
      }
      
      public function getTransactionCancelGameUnit(def:ShipDef) : Transaction
      {
         return this.createSingleTransaction(false,0,def.getCostCoins(),def.getCostMineral());
      }
      
      public function getTransactionPremiumUpgrade(upgradedDef:WorldItemDef, item:WorldItemObject, itemsCount:int = 1) : Transaction
      {
         var returnValue:Transaction = null;
         var coinsPrice:Number = NaN;
         var mineralsPrice:Number = NaN;
         var chips:int = 0;
         var transItems:Dictionary = null;
         var itemSku:* = null;
         var amount:int = 0;
         var itemPrice:Number = NaN;
         var xp:Number = NaN;
         var score:Number = NaN;
         var t:Transaction = this.getTransactionUpgradePrice(upgradedDef);
         var timeLeft:Number = upgradedDef.getConstructionTime();
         var timeMins:Number = DCTimerUtil.msToMin(timeLeft);
         if(t != null)
         {
            coinsPrice = t.getTransCoins();
            mineralsPrice = t.getTransMinerals();
            chips = this.exchangeMinsToCash(timeMins,"instantHouses");
            transItems = t.getTransItems();
            itemPrice = 0;
            for(itemSku in transItems)
            {
               if(itemSku != null && itemSku != "")
               {
                  amount = -transItems[itemSku]["amount"];
                  itemPrice = InstanceMng.getItemsMng().getItemObjectBySku(itemSku).mDef.getOriginalChipsCost();
                  chips += itemPrice * amount;
               }
            }
            chips += this.calculateResourcesPrice(coinsPrice * -1,mineralsPrice * -1);
            xp = upgradedDef.getConstructionXp();
            score = upgradedDef.getScoreBuilt();
            chips *= itemsCount;
            xp *= itemsCount;
            score *= itemsCount;
            returnValue = this.createSingleTransaction(true,chips,0,0,xp,item,"WIOEventUpgradePremium",null,null,null,true,score);
         }
         return returnValue;
      }
      
      public function getTransactionPremiumUpgradeRange(itemDef:WorldItemDef, nextDef:WorldItemDef, item:WorldItemObject, useDiscount:Boolean, length:int = 1) : Transaction
      {
         var i:* = 0;
         var t:Transaction = null;
         var returnValue:Transaction = null;
         var def:WorldItemDef = null;
         var start:int = itemDef.getUpgradeId() + 1;
         var end:int = nextDef.getUpgradeId();
         var sku:String = itemDef.mSku;
         var cash:Number = 0;
         var xp:Number = 0;
         var score:Number = 0;
         for(i = start; i <= end; )
         {
            def = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(sku,i);
            t = this.getTransactionPremiumUpgrade(def,item,length);
            cash += t.getTransCash();
            xp += t.getTransXp();
            score += t.getTransScore();
            i++;
         }
         if(useDiscount)
         {
            cash = -this.applyDiscountUpgradingRange(start - 1,end,Math.abs(cash));
         }
         return this.createSingleTransaction(true,-cash,0,0,xp,item,"WIOEventUpgradePremium",null,null,null,true,score);
      }
      
      private function applyDiscountUpgradingRange(start:int, end:int, cash:Number) : Number
      {
         var discount:Number = 0;
         var levels:int;
         if((discount = ((levels = end - start) - 1) * InstanceMng.getSettingsDefMng().mSettingsDef.getMinDiscountUpgrade()) > InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade())
         {
            discount = InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade();
         }
         discount = cash * (discount / 100);
         return Math.ceil(cash - discount);
      }
      
      private function getTransactionUpgradePrice(itemDef:WorldItemDef) : Transaction
      {
         var transaction:Transaction = null;
         var priceCash:Number = NaN;
         var priceCoins:Number = NaN;
         var priceMinerals:Number = NaN;
         var amountItemsNeeded:int = 0;
         var priceItemSku:String = null;
         var priceItemAmount:Number = NaN;
         var i:int = 0;
         if(itemDef != null)
         {
            if(itemDef != null)
            {
               priceCoins = itemDef.getConstructionCoins() * -1;
               priceMinerals = itemDef.getConstructionMineral() * -1;
               (transaction = new Transaction()).setTransCoins(Math.round(priceCoins));
               transaction.setTransMinerals(Math.round(priceMinerals));
               amountItemsNeeded = itemDef.getNumUpgradeItemsNeeded();
               for(i = 0; i < amountItemsNeeded; )
               {
                  priceItemSku = itemDef.getUpgradeItemsNeededSku(i);
                  priceItemAmount = itemDef.getUpgradeItemsNeededAmount(i) * -1;
                  transaction.addTransItem(priceItemSku,priceItemAmount);
                  i++;
               }
            }
         }
         return transaction;
      }
      
      public function createSingleTransaction(withdraw:Boolean, cash:Number = 0, coins:Number = 0, minerals:Number = 0, xp:Number = 0, item:WorldItemObject = null, transactionEvent:String = "", infoPackage:Object = null, profile:Profile = null, responseToObject:Object = null, applyOnProfile:Boolean = true, score:Number = 0) : Transaction
      {
         var factor:int = 1;
         if(withdraw == true)
         {
            factor = -1;
         }
         var transaction:Transaction = new Transaction();
         if(cash != 0)
         {
            transaction.setTransCash(cash * factor);
         }
         if(coins != 0)
         {
            transaction.setTransCoins(coins * factor);
         }
         if(minerals != 0)
         {
            transaction.setTransMinerals(minerals * factor);
         }
         if(xp != 0)
         {
            transaction.setTransXp(xp);
         }
         if(score != 0)
         {
            transaction.setTransScore(score);
         }
         if(item != null)
         {
            transaction.setWorldItemObject(item);
         }
         if(transactionEvent != "")
         {
            transaction.setTransEvent(transactionEvent);
         }
         if(infoPackage != null)
         {
            transaction.setTransInfoPackage(infoPackage);
         }
         if(profile != null)
         {
            transaction.setTransProfile(profile);
         }
         if(responseToObject != null)
         {
            transaction.setTransResponseToValue(responseToObject);
         }
         transaction.setApplyOnProfile(applyOnProfile);
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      private function getTransactionBuyWithPremiumCurrency(event:Object) : Transaction
      {
         var priceCash:Number = event.fbPrice * -1;
         var transaction:Transaction = new Transaction();
         transaction.setTransEvent(event.cmd);
         transaction.setTransCash(Math.round(priceCash));
         transaction.computeAmountsLeftValues();
         return transaction;
      }
      
      public function getTransactionsByItemsList(items:Vector.<WorldItemObject>, operation:String) : Vector.<Transaction>
      {
         var itemsTransactions:Vector.<Transaction> = null;
         var item:WorldItemObject = null;
         var obj:Object = null;
         var t:Transaction = null;
         if(items != null)
         {
            itemsTransactions = new Vector.<Transaction>(0);
            for each(item in items)
            {
               (obj = {}).cmd = operation;
               obj.item = item;
               obj.sendResponseTo = InstanceMng.getWorldItemObjectController();
               t = InstanceMng.getRuleMng().getTransactionPack(obj);
               item.setTransaction(t);
               obj.transaction = t;
               itemsTransactions.push(t);
            }
         }
         return itemsTransactions;
      }
      
      public function getTransactionPack(event:Object) : Transaction
      {
         var transactionPack:Transaction = null;
         var transType:String = null;
         switch(event.cmd)
         {
            case "WIOEventInstantBuild":
               transactionPack = this.getTransactionInstantBuild(event.item,event);
               break;
            case "WIOEventInstantDemolish":
               transactionPack = this.getTransactionInstantDemolish(event.item,event);
               break;
            case "WIOEventDemolitionStart":
               transactionPack = this.getTransactionDemolishStart(event.item.mDef,event);
               break;
            case "WIOEventDemolitionEnd":
               transactionPack = this.getTransactionDemolishEnd(event.item.mDef,event);
               break;
            case "NOTIFY_DROIDS_BUY":
               transType = !!event.fromInvest ? "typeInvest" : "typeStandard";
               transactionPack = this.getTransactionDroidBuy(event.itemDef,transType);
               break;
            case "NOTIFY_SHOP_BUY":
               transactionPack = this.getTransactionShopBuy(event.itemDef,event);
               break;
            case "WIOEventCancelBuild":
               transactionPack = this.getTransactionCancelBuild(event.item,event);
               break;
            case "WIORentWaitingEnd":
               transactionPack = this.getTransactionCollect(event.item);
               break;
            case "WIOEventUpgradeStart":
               transactionPack = this.getTransactionUpgrade(event.item,event);
               break;
            case "WIOEventCancelUpgrade":
               transactionPack = this.getTransactionCancelUpgrade(event.item,event);
               break;
            case "WIOEventInstantUpgrade":
               transactionPack = this.getTransactionInstantUpgrade(event);
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDITEM":
               transactionPack = this.getTransactionSpeedUp(event.itemDef,event);
               break;
            case "NotifyUnlockShipSlot":
               transactionPack = this.getTransactionUnlockSlotShipyard(event);
               break;
            case "NOTIFY_BUY_DROID_WITH_PREMIUM_CURRENCY":
               transactionPack = this.getTransactionBuyWithPremiumCurrency(event);
               break;
            case "NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY":
               transactionPack = this.getTransactionBuyItemsWithPremiumCurrency(event);
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDQUEUE":
               transactionPack = this.getTransactionSpeedUpQueue(event);
               break;
            case "NotifyTransferUnitsToBunker":
               transactionPack = this.getTransactionTransfer(event);
               break;
            case "NOTIFY_STAR_BUY_PLANET_POPUP":
               transactionPack = this.getTransactionBuyColony(event);
               break;
            case "NOTIFY_STAR_MOVE_COLONY_POPUP":
               transactionPack = this.getTransactionMoveColony(event);
               break;
            case "NotifyCreateAlliance":
               transactionPack = this.getTransactionCreateAlliance(event);
               break;
            case "NotifyEditAlliance":
               transactionPack = this.getTransactionEditAlliance(event);
         }
         return transactionPack;
      }
      
      public function wioGetIncomeTimeLeft(item:WorldItemObject) : Number
      {
         var amount:Number = item.getIncomeAmountLeftToCollect();
         var t:Number = amount / item.mDef.getIncomeSpeed();
         t = Math.floor(InstanceMng.getSettingsDefMng().getIncomePace() * t);
         return item.mDef.getIncomeTime() - t;
      }
      
      public function wioMaxNumPerCurrentHQUpgradeId(sku:String) : int
      {
         var hq:WorldItemObject = InstanceMng.getWorld().itemsGetHeadquarters();
         var def:WorldItemDef = WorldItemDef(InstanceMng.getWorldItemDefMng().getDefBySku(sku));
         return hq == null ? 0 : def.getMaxNumPerHQUpgradeId(hq.mUpgradeId);
      }
      
      public function wioGetHQUpgradeIdToBuild(sku:String) : int
      {
         var returnValue:int = 0;
         var maxNumAllowed:int = 0;
         var world:World = null;
         var currentNumItems:int = 0;
         var hq:WorldItemObject = InstanceMng.getWorld().itemsGetHeadquarters();
         var worldItemDefMng:WorldItemDefMng = InstanceMng.getWorldItemDefMng();
         var def:WorldItemDef;
         if((def = WorldItemDef(worldItemDefMng.getDefBySku(sku))).getUnlockHQUpgradeIdRequired() > hq.mUpgradeId)
         {
            returnValue = def.getUnlockHQUpgradeIdRequired();
         }
         else
         {
            maxNumAllowed = this.wioMaxNumPerCurrentHQUpgradeId(sku);
            world = InstanceMng.getWorld();
            if((currentNumItems = world.itemsAmountGet(sku)) < maxNumAllowed)
            {
               returnValue = hq.mUpgradeId;
            }
            else
            {
               returnValue = def.getHQUpgradeIdForHavingNumItems(currentNumItems + 1);
            }
         }
         return returnValue;
      }
      
      private function npcsUnload() : void
      {
         this.mNpcsWaves = null;
         this.mNpcsNpcSkus = null;
         this.mNpcsDeployX = null;
         this.mNpcsDeployY = null;
         this.mNpcsDeployWays = null;
         this.mNpcsDurations = null;
      }
      
      private function npcsReadAttacks() : void
      {
         var sku:String = null;
         var attack:XML = null;
         this.mNpcsWaves = new Dictionary(true);
         this.mNpcsNpcSkus = new Dictionary(true);
         this.mNpcsDeployX = new Dictionary(true);
         this.mNpcsDeployY = new Dictionary(true);
         this.mNpcsDeployWays = new Dictionary(true);
         this.mNpcsDurations = new Dictionary(true);
         var xml:XML = filesGetFileAsXML("npcAttacksDefinitions.xml");
         for each(attack in EUtils.xmlGetChildrenList(xml,"Definition"))
         {
            sku = EUtils.xmlReadString(attack,"sku");
            this.mNpcsWaves[sku] = EUtils.xmlReadString(attack,"waves");
            this.mNpcsNpcSkus[sku] = EUtils.xmlReadString(attack,"npcSku");
            this.mNpcsDeployX[sku] = EUtils.xmlReadString(attack,"x");
            this.mNpcsDeployY[sku] = EUtils.xmlReadString(attack,"y");
            this.mNpcsDeployWays[sku] = EUtils.xmlReadString(attack,"deployWay");
            this.mNpcsDurations[sku] = DCTimerUtil.minToMs(EUtils.xmlReadNumber(attack,"duration"));
         }
      }
      
      public function npcsGetAttack(sku:String) : String
      {
         return this.mNpcsWaves[sku];
      }
      
      public function npcsGetNpcSku(sku:String) : String
      {
         return this.mNpcsNpcSkus[sku];
      }
      
      public function npcsGetDeployX(sku:String) : String
      {
         return this.mNpcsDeployX[sku];
      }
      
      public function npcsGetDeployY(sku:String) : String
      {
         return this.mNpcsDeployY[sku];
      }
      
      public function npcsGetDeployWay(sku:String) : String
      {
         return this.mNpcsDeployWays[sku];
      }
      
      public function npcsGetDuration(sku:String) : Number
      {
         return this.mNpcsDurations[sku];
      }
      
      public function waveSpawnGetAttack(waves:String) : String
      {
         var waveSku:String = null;
         var waveDef:WaveDef = null;
         var returnValue:* = "";
         var arr:Array = waves.split(",");
         var i:int = 0;
         for each(waveSku in arr)
         {
            if(waveSku.indexOf(":") != -1)
            {
               waveSku = String(waveSku.split(":")[1]);
            }
            if((waveDef = InstanceMng.getWaveDefMng().getDefBySku(waveSku) as WaveDef) == null)
            {
               DCDebug.trace("Wave \'" + waveSku + "\' not found");
            }
            else
            {
               returnValue += waveDef.getUnits();
               if(i < arr.length - 1)
               {
                  returnValue += ",";
               }
               i++;
            }
         }
         return returnValue;
      }
      
      public function getAmountDependingOnCapacity(amount:Number, isCoins:Boolean) : Number
      {
         var returnValue:Number = NaN;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var capacity:Number;
         return (capacity = isCoins ? profile.getCoinsCapacity() : profile.getMineralsCapacity()) * amount / 100;
      }
      
      public function createTransactionAcceptInvest() : Transaction
      {
         var returnValue:Transaction = new Transaction();
         returnValue.setTransCash(InstanceMng.getInvestsSettingsDefMng().getExtraCash());
         return returnValue;
      }
      
      public function createTransactionFromRewardsString(rewardsString:String) : Transaction
      {
         var reward:String = null;
         var returnValue:Transaction = new Transaction();
         var rewards:Array = rewardsString.split(",");
         for each(reward in rewards)
         {
            this.includeRewardStringToTransaction(reward,returnValue);
         }
         return returnValue;
      }
      
      private function includeRewardStringToTransaction(reward:String, t:Transaction) : void
      {
         var params:Array = null;
         var amountCode:String = null;
         var isPercentage:* = false;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var tokens:Array;
         var type:String = String((tokens = reward.split(":"))[0]);
         var amountValue:Number = 0;
         if(type == "item")
         {
            amountValue = tokens.length == 2 ? 1 : Number(tokens[2]);
         }
         else
         {
            if(isPercentage = (amountCode = String(tokens[1])).indexOf("p") > -1)
            {
               amountCode = amountCode.substr(0,amountCode.length - 1);
            }
            amountValue = Number(amountCode);
         }
         switch(type)
         {
            case "coins":
               if(isPercentage)
               {
                  amountValue = this.getAmountDependingOnCapacity(amountValue,true);
               }
               t.setTransCoins(t.getTransCoins() + amountValue);
               break;
            case "minerals":
               if(isPercentage)
               {
                  amountValue = this.getAmountDependingOnCapacity(amountValue,false);
               }
               t.setTransMinerals(t.getTransMinerals() + amountValue);
               break;
            case "item":
               t.addTransItem(tokens[1],amountValue,false);
         }
      }
      
      public function createRewardObjectFromParams(type:String, amount:Number, itemSku:String = "", specialAttackDef:SpecialAttacksDef = null, from:int = -1) : RewardObject
      {
         var params:Array = [type];
         if(type == "item")
         {
            params.push(itemSku);
         }
         params.push(amount);
         return new RewardObject(params,specialAttackDef,from);
      }
      
      public function createRewardObjectFromMisteryRewardSku(rewardSku:String, addToProfile:Boolean = true) : RewardObject
      {
         var params:* = null;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var rewardDef:MisteryRewardDef = InstanceMng.getMisteryRewardDefMng().getDefBySku(rewardSku) as MisteryRewardDef;
         var amountValue:Number = 0;
         var isPercentage:*;
         var amountCode:String;
         if(isPercentage = (amountCode = rewardDef.getAmount()).indexOf("p") > -1)
         {
            amountCode = amountCode.substr(0,amountCode.length - 1);
         }
         amountValue = Number(amountCode);
         var type:String;
         var tokens:Array = (type = rewardDef.getType()).split(":");
         switch(type)
         {
            case "coins":
               if(isPercentage)
               {
                  amountValue = this.getAmountDependingOnCapacity(amountValue,true);
               }
               if(addToProfile)
               {
                  profile.addCoins(amountValue);
               }
               break;
            case "minerals":
               if(isPercentage)
               {
                  amountValue = this.getAmountDependingOnCapacity(amountValue,false);
               }
               if(addToProfile)
               {
                  profile.addMinerals(amountValue);
               }
               break;
            case "chips":
               if(addToProfile)
               {
                  profile.addCash(amountValue);
               }
               break;
            default:
               tokens = type.split(":");
         }
         if(tokens != null && tokens[0] == "item")
         {
            (params = tokens).push(amountValue);
            type = String(tokens[0]);
         }
         else
         {
            params = [type,amountValue];
         }
         var reward:RewardObject = new RewardObject(params);
         reward.overrideDescription(rewardDef.getDescToDisplay());
         reward.overrideTitle(rewardDef.getNameToDisplay());
         return reward;
      }
      
      public function getPriceDefByOperation(priceSku:String = "instantHouses") : PremiumPricesDef
      {
         var premiumPricesDefMng:PremiumPricesDefMng = InstanceMng.getPremiumPricesDefMng();
         return PremiumPricesDef(premiumPricesDefMng.getDefBySku(priceSku));
      }
      
      public function calculateResourcesPrice(coins:Number, minerals:Number = 0, priceSku:String = "conversionResourcesToUSD") : Number
      {
         if(coins == 0 && minerals == 0)
         {
            return 0;
         }
         var setting:SettingsDef = InstanceMng.getSettingsDefMng().mSettingsDef;
         var premiumDef:PremiumPricesDef;
         if((premiumDef = PremiumPricesDef(InstanceMng.getPremiumPricesDefMng().getDefBySku(priceSku))) == null)
         {
            return -1;
         }
         var bound:Number = premiumDef.getBound();
         var multiplier:Number = premiumDef.getMultiplier();
         var divisor:Number = premiumDef.getDivisor();
         var exponent:Number = premiumDef.getExponent();
         var overallPercentCoins:Number = 100 * coins / setting.getMaxCoinsAllUpgraded();
         var overallPercentMinerals:Number = 100 * minerals / setting.getMaxMineralsAllUpgraded();
         var price:Number = Math.pow(overallPercentCoins / divisor,exponent);
         if(minerals != 0 && !isNaN(minerals))
         {
            price += Math.pow(overallPercentMinerals / divisor,exponent);
         }
         price = (price *= multiplier) / setting.getPremiumCurrencyToOneUSD();
         if((price = this.roundToCentsCurrencyValue(price)) < setting.getMinPricePremiumCurrency())
         {
            price = setting.getMinPricePremiumCurrency();
         }
         return price;
      }
      
      private function calculateMinutesPriceInUSD(minsLeft:Number, priceSku:String = "instantHouses") : Number
      {
         var priceUSD:Number = NaN;
         var priceDef:PremiumPricesDef = this.getPriceDefByOperation(priceSku);
         if(minsLeft <= priceDef.getBound())
         {
            priceUSD = minsLeft / priceDef.getMinutesToOneUSD();
         }
         else
         {
            priceUSD = Math.pow(minsLeft,priceDef.getExponent()) * priceDef.getMultiplier() / priceDef.getDivisor();
         }
         return Math.round(priceUSD * 100) / 100;
      }
      
      private function roundToCentsCurrencyValue(dollars:Number) : Number
      {
         var roundedDecimal:Number = Math.floor(dollars * 100) / 100;
         var intValue:int = roundedDecimal;
         var rest:Number = roundedDecimal - intValue;
         var decimalsFloorRounded:Number = Math.floor(rest * 10);
         var price:Number;
         var res:Number;
         if((price = Number((res = intValue + decimalsFloorRounded / 10).toFixed(2))) == 0)
         {
            price = InstanceMng.getSettingsDefMng().getMinPricePremiumCurrency();
         }
         return price;
      }
      
      public function getDroidPaymentItemsList(def:DroidDef) : Array
      {
         var profile:Profile = null;
         var returnValue:Array = null;
         if(def != null)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(profile.isCurrentPlanetCapital())
            {
               returnValue = def.getItemListMain();
            }
            else
            {
               returnValue = def.getItemListColony();
            }
         }
         return returnValue;
      }
      
      public function getDroidReleasePrice() : int
      {
         var returnValue:int = 0;
         var timeLeft:Number = DCTimerUtil.msToMin(InstanceMng.getTrafficMng().droidsGetSmallestTimeForFreeDroid());
         var droidReleaseCurrency:String = InstanceMng.getSettingsDefMng().getInstantOperationCurrency();
         switch(droidReleaseCurrency)
         {
            case "coins":
               returnValue = -InstanceMng.getRuleMng().exchangeMinsToCoins(timeLeft);
               break;
            case "minerals":
               returnValue = -InstanceMng.getRuleMng().exchangeMinsToMinerals(timeLeft);
         }
         return returnValue;
      }
      
      public function getInstantOperationsCurrency() : int
      {
         var returnValue:int = -1;
         var droidReleaseCurrency:String = InstanceMng.getSettingsDefMng().getInstantOperationCurrency();
         switch(droidReleaseCurrency)
         {
            case "coins":
               return 1;
            case "minerals":
               return 2;
            default:
               return returnValue;
         }
      }
      
      public function exchangeMinsToCoins(minutes:Number) : Number
      {
         var coins:Number = InstanceMng.getSettingsDefMng().getMinutePriceCoins() * minutes;
         var minPrice:int = InstanceMng.getSettingsDefMng().getMinPriceCoins();
         return Math.max(minPrice,coins);
      }
      
      public function exchangeMinsToMinerals(minutes:Number) : Number
      {
         var minerals:Number = InstanceMng.getSettingsDefMng().getMinutePriceCoins() * minutes;
         var minPrice:int = InstanceMng.getSettingsDefMng().getMinPriceCoins();
         return Math.max(minPrice,minerals);
      }
      
      public function exchangeMinsToCash(minutes:Number, priceSku:String = "instantHouses") : Number
      {
         var priceDef:PremiumPricesDef = this.getPriceDefByOperation(priceSku);
         if(minutes <= priceDef.getMinutesForFree())
         {
            return 0;
         }
         var priceUSD:Number = this.calculateMinutesPriceInUSD(minutes,priceSku);
         var cash:Number = Math.round(priceUSD * 10);
         var minPrice:int = InstanceMng.getSettingsDefMng().getMinPricePremiumCurrency();
         return Math.max(minPrice,cash);
      }
      
      public function canItemBeLooted(item:WorldItemObject) : Boolean
      {
         var typeId:int = item.mDef.getWorkingTypeId();
         var returnValue:Boolean = typeId == 2 || typeId == 0 || typeId == 1;
         if(returnValue)
         {
            returnValue = item.shotCanBeATarget();
         }
         return returnValue;
      }
      
      public function getBattleResourceDamage(item:WorldItemObject, damage:Number, energy:Number, doApply:Boolean, returnValue:Dictionary, doClamp:Boolean = true) : void
      {
         var profileAttacked:Profile = null;
         var profileCoins:* = NaN;
         var profileMinerals:* = NaN;
         var profileCoinsCapacityCurrentPlanet:Number = NaN;
         var profileMineralsCapacityCurrentPlanet:Number = NaN;
         var mineralsStorage:Number = NaN;
         var coinsStorage:Number = NaN;
         var income:Number = NaN;
         var data:Object = null;
         var sid:String = null;
         var world:World = null;
         var diffCoins:Number = NaN;
         var diffMinerals:Number = NaN;
         var typeId:int = item.mDef.getWorkingTypeId();
         var damageMinerals:* = 0;
         var damageCoins:* = 0;
         if(energy < 0)
         {
            damage += energy;
         }
         returnValue["applyOnProfile"] = false;
         switch(typeId)
         {
            case 0:
            case 1:
               if(item.mServerStateId == 1)
               {
                  if((income = item.getIncomeAmountLineal()) > 0)
                  {
                     damage = this.getDamageOnIncome(damage,income,energy);
                     if(doApply)
                     {
                        item.setIncomeTimeFromAmountLineal(income - damage);
                     }
                     if(typeId == 0)
                     {
                        damageCoins = damage;
                     }
                     else
                     {
                        damageMinerals = damage;
                     }
                  }
                  returnValue["applyOnProfile"] = false;
               }
               break;
            case 2:
               profileCoins = (profileAttacked = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).getCoins();
               profileMinerals = profileAttacked.getMinerals();
               if(returnValue["profileCoins"] != null)
               {
                  profileMinerals = Number(returnValue["profileMinerals"]);
                  profileCoins = Number(returnValue["profileCoins"]);
               }
               profileCoinsCapacityCurrentPlanet = profileAttacked.getCoinsCapacityCurrentPlanet();
               if(profileCoins > profileCoinsCapacityCurrentPlanet)
               {
                  profileCoins = profileCoinsCapacityCurrentPlanet;
               }
               profileMineralsCapacityCurrentPlanet = profileAttacked.getMineralsCapacityCurrentPlanet();
               if(profileMinerals > profileMineralsCapacityCurrentPlanet)
               {
                  profileMinerals = profileMineralsCapacityCurrentPlanet;
               }
               mineralsStorage = item.mDef.getMineralsStorage();
               coinsStorage = item.mDef.getCoinsStorage();
               if(mineralsStorage > 0 && coinsStorage > 0)
               {
                  damageMinerals = Math.floor(damage / 2);
                  damageMinerals = this.getDamageOnIncome(damageMinerals,profileMinerals);
                  if((damageCoins = damage - damageMinerals) > profileCoins)
                  {
                     damageCoins = profileCoins;
                     damageMinerals = damage - damageCoins;
                     damageMinerals = this.getDamageOnIncome(damageMinerals,profileMinerals);
                  }
               }
               else if(mineralsStorage > 0)
               {
                  damageMinerals = this.getDamageOnIncome(damage,profileMinerals);
               }
               else
               {
                  damageCoins = this.getDamageOnIncome(damage,profileCoins);
               }
               returnValue["applyOnProfile"] = true;
         }
         if(doApply)
         {
            sid = item.mSid;
            if((world = InstanceMng.getWorld()).mLootMaxBySid[sid] == null)
            {
               damageCoins = 0;
               damageMinerals = 0;
            }
            else
            {
               if(world.mLootSoFarBySid[sid] == null)
               {
                  world.mLootSoFarBySid[sid] = {
                     "coins":0,
                     "minerals":0
                  };
               }
               data = world.mLootSoFarBySid[sid];
               diffCoins = world.mLootMaxBySid[sid].coins - data.coins;
               diffMinerals = world.mLootMaxBySid[sid].minerals - data.minerals;
               if(damageCoins > diffCoins)
               {
                  damageCoins = diffCoins;
               }
               if(damageMinerals > diffMinerals)
               {
                  damageMinerals = diffMinerals;
               }
               if(energy <= 0)
               {
                  damageCoins = diffCoins;
                  damageMinerals = diffMinerals;
               }
               data.coins += damageCoins;
               data.minerals += damageMinerals;
            }
         }
         returnValue["damageCoins"] = damageCoins;
         returnValue["damageMinerals"] = damageMinerals;
      }
      
      public function getTransactionBattleResourceDamage(item:WorldItemObject, damage:Number, energy:Number) : Transaction
      {
         var returnValue:Transaction = null;
         this.getBattleResourceDamage(item,damage,energy,true,this.mBattleData);
         var coins:Number = Number(this.mBattleData["damageCoins"]);
         var minerals:Number = Number(this.mBattleData["damageMinerals"]);
         return this.createSingleTransaction(true,0,coins,minerals,0,item,"",null,InstanceMng.getUserInfoMng().getCurrentProfileLoaded(),this.mBattleData["applyOnProfile"]);
      }
      
      public function battleAffectsProfile(item:WorldItemObject) : Boolean
      {
         return item.mDef.getWorkingTypeId() == 2;
      }
      
      public function getTransactionAttackerFromTransactionVictim(item:WorldItemObject, t:Transaction, isDestroyed:Boolean, profile:Profile = null) : Transaction
      {
         var coins:Number = NaN;
         var minerals:Number = NaN;
         var def:SettingsDef = null;
         var xp:Number = NaN;
         var score:Number = NaN;
         var bunker:Bunker = null;
         var returnValue:Transaction = null;
         if(t != null)
         {
            coins = -t.getTransCoins();
            minerals = -t.getTransMinerals();
            def = InstanceMng.getSettingsDefMng().mSettingsDef;
            xp = Math.floor(def.getLootingXpFromCoins(coins)) + Math.floor(def.getLootingXpFromMinerals(minerals));
            score = 0;
            if(isDestroyed)
            {
               score = item.mDef.getScoreAttack();
               if(item.mDef.isABunker())
               {
                  if((bunker = Bunker(InstanceMng.getBunkerController().getFromSid(item.mSid))) != null && !bunker.isEmpty())
                  {
                     score += bunker.getUnitsScoreAttack();
                  }
               }
            }
            returnValue = this.createSingleTransaction(false,0,coins,minerals,xp,item,"",null,profile,null,false,score);
         }
         return returnValue;
      }
      
      public function applyTransactionBattleResourceDamage(item:WorldItemObject, t:Transaction, isDestroyed:Boolean) : Transaction
      {
         var tAttacker:Transaction = null;
         var userInfoMng:UserInfoMng = null;
         var profileAttacked:Profile = null;
         var profileAttacker:Profile = null;
         var doAction:* = false;
         var launchParticles:* = false;
         if(t != null)
         {
            profileAttacked = (userInfoMng = InstanceMng.getUserInfoMng()).getCurrentProfileLoaded();
            profileAttacker = userInfoMng.getProfileLogin();
            doAction = this.battleAffectsProfile(item);
            launchParticles = profileAttacked == profileAttacker;
            if(doAction)
            {
               t.setWorldItemObject(item);
               t.performAllTransactions(launchParticles);
            }
            if(doAction = profileAttacked != profileAttacker)
            {
               launchParticles = !launchParticles;
               (tAttacker = this.getTransactionAttackerFromTransactionVictim(item,t,isDestroyed)).setTransProfile(profileAttacker);
               tAttacker.performAllTransactions(launchParticles);
               if(tAttacker.getTransCoins() != 0 || tAttacker.getTransMinerals() != 0)
               {
                  profileAttacker.getUserInfoObj().setHasChanged(true);
               }
            }
         }
         return tAttacker;
      }
      
      private function getDamageOnIncome(damage:Number, income:Number, energy:Number = 100) : Number
      {
         if(income < damage || energy <= 0)
         {
            damage = income;
         }
         return damage;
      }
      
      public function getRepairingTime(energy:Number) : Number
      {
         var repairFactor:Number = InstanceMng.getSettingsDefMng().mSettingsDef.getRepairingTimeFactor();
         return repairFactor * energy / 1000;
      }
      
      public function isANewItemAllowedToBePlaced(itemDef:WorldItemDef) : Boolean
      {
         var amount:int = InstanceMng.getWorld().itemsAmountGet(itemDef.mSku);
         var amountAllowed:int = InstanceMng.getRuleMng().wioMaxNumPerCurrentHQUpgradeId(itemDef.mSku);
         return amount < amountAllowed;
      }
      
      public function getTransactionProtectionTime(def:ProtectionTimeDef) : Transaction
      {
         var pc:DCPaidCurrency = paidCurrencyGetField(def,"price");
         var returnValue:Transaction = new Transaction();
         returnValue.setTransCash(pc.mAmount);
         return returnValue;
      }
      
      public function getTransactionShipyardUnlockSlot(shipyardId:String, sendResponseTo:Object) : Transaction
      {
         var slotId:int = 0;
         var def:WorldItemDef = null;
         var price:int = 0;
         var trans:Transaction = null;
         var shipyard:Shipyard;
         if((shipyard = InstanceMng.getShipyardController().getShipyard(shipyardId)) != null)
         {
            if((slotId = shipyard.getSlotUnlockedAmount()) < 3)
            {
               def = InstanceMng.getWorldItemDefMng().getDefBySku(shipyard.getWorldItemObject().mDef.mSku) as WorldItemDef;
               if(def)
               {
                  price = int(def.getSlotsUnlockPrice()[slotId]);
                  trans = this.createSingleTransaction(true,price,0,0,0,null,null,null,null,sendResponseTo);
               }
               else
               {
                  DCDebug.traceCh("ERROR","definition for worldItem in shipyard " + shipyardId + " NOT FOUND!!",3);
               }
            }
         }
         return trans;
      }
      
      public function getQuickAttackMineralCost() : int
      {
         var maxHqLevel:int = InstanceMng.getUserInfoMng().getProfileLogin().getMaxHqLevelInAllPlanets();
         if(maxHqLevel > 0)
         {
            maxHqLevel--;
         }
         var def:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId("wonders_headquarters",maxHqLevel) as WorldItemDef;
         return def.getCostQuickAttack();
      }
      
      public function getTransactionQuickAttack(firstTime:Boolean, infoPackage:Object = null) : Transaction
      {
         return this.createSingleTransaction(true,0,0,firstTime ? 0 : this.getQuickAttackMineralCost(),0,null,"",infoPackage);
      }
      
      public function getAttackDistanceMineralCost(planetSku1:String, planetSku2:String) : Number
      {
         var distance:Number = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(planetSku1,planetSku2));
         return this.getAttackDistanceMineralCostByDistance(distance);
      }
      
      public function getAttackDistanceMineralCostByDistance(distance:Number) : Number
      {
         if(distance <= InstanceMng.getSettingsDefMng().getDistanceThreshold())
         {
            return 0;
         }
         var maxCost:Number = InstanceMng.getUserInfoMng().getProfileLogin().getMineralsCapacity() * InstanceMng.getSettingsDefMng().getAttackCostStoragePercentage() / 100;
         var cost:Number = this.getDistanceCost(distance,InstanceMng.getSettingsDefMng().getAttackCost());
         return Math.min(maxCost,cost);
      }
      
      public function getColonizeCostByDistance(distance:Number) : Number
      {
         var cost:* = this.getDistanceCost(distance,InstanceMng.getSettingsDefMng().getColonyFactor());
         var min:Number = InstanceMng.getSettingsDefMng().getMinPriceColony();
         if(cost < min)
         {
            cost = min;
         }
         return cost;
      }
      
      private function getDistanceCost(distance:Number, factor:Number) : Number
      {
         var value:Number = (2000 - 0.072 * distance) * distance * factor;
         return Math.ceil(value);
      }
      
      public function getScoreBuiltFromValue(value:Number) : Number
      {
         return Math.floor(value * InstanceMng.getSettingsDefMng().getScoreBuiltFactor());
      }
      
      public function getScoreAttackFromValue(value:Number) : Number
      {
         return Math.floor(value * InstanceMng.getSettingsDefMng().getScoreAttackFactor());
      }
      
      public function getScoreDefenseFromValue(value:Number) : Number
      {
         return Math.floor(value * InstanceMng.getSettingsDefMng().getScoreDefenseFactor());
      }
      
      public function getScoreDependingOnRole(value:Number) : Number
      {
         switch(InstanceMng.getRole().mId - 3)
         {
            case 0:
               return this.getScoreAttackFromValue(value);
            case 4:
               return this.getScoreDefenseFromValue(value);
            default:
               return this.getScoreBuiltFromValue(value);
         }
      }
      
      public function getLevel(value:Number) : int
      {
         return this.getLevelScore(value);
      }
      
      public function getLevelScore(score:Number) : int
      {
         return parseInt(InstanceMng.getLevelScoreDefMng().getLevelFromValue(score));
      }
      
      public function getNotificationFromTransaction(trans:Transaction) : Notification
      {
         var profileLogin:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var maxCoinsCapacity:Number = profileLogin.getCoinsCapacity();
         var maxMineralsCapacity:Number = profileLogin.getMineralsCapacity();
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         var returnValue:Notification = null;
         if(trans == null)
         {
            returnValue = notificationsMng.createNotificationNullTransaction();
            DCDebug.trace(returnValue.getMessageBody(),1);
            return returnValue;
         }
         if(maxCoinsCapacity < Math.abs(trans.getTransCoins()))
         {
            returnValue = notificationsMng.createNotificationNotEnoughRoomInBanks();
         }
         if(maxMineralsCapacity < Math.abs(trans.getTransMinerals()))
         {
            returnValue = notificationsMng.createNotificationNotEnoughRoomInSilos();
         }
         return returnValue;
      }
      
      public function checkUserCanAttackOtherUserByLevel(user1:UserInfo, user2:UserInfo) : Boolean
      {
         var ret:Boolean = false;
         var level1:int = user1.getLevel();
         var level2:int = user2.getLevel();
         ret = InstanceMng.getLevelScoreDefMng().checkValidAttackWithLevel(level1,level2);
         DCDebug.trace("****************************");
         DCDebug.trace("user1 (" + user1.mAccountId + ") with level=" + level1 + " wants to attack user2 (" + user2.mAccountId + ") with level=" + level2);
         DCDebug.trace(ret ? "ALLOWED" : "DENIED");
         DCDebug.trace("****************************");
         return ret;
      }
      
      public function checkUserCanAttackOtherUserByHQ(user1:UserInfo, planet:Planet) : Boolean
      {
         var ret:* = false;
         var hq1:int = user1.getCurrentPlanet().getHQLevel();
         var hq2:int;
         ret = (hq2 = planet.getHQLevel()) >= hq1;
         DCDebug.trace("****************************");
         DCDebug.trace("user1 (" + user1.mAccountId + ") with HQ=" + hq1 + " wants to attack user2 (" + planet.getOwnerAccId() + ") with HQ=" + hq2);
         DCDebug.trace(ret ? "ALLOWED" : "DENIED");
         DCDebug.trace("****************************");
         return ret;
      }
      
      public function getUpgradeHqLists(hqUpgradeId:int) : Array
      {
         var def:WorldItemDef = null;
         var type:String = null;
         var upgradedDef:WorldItemDef = null;
         var upgradedNextDef:WorldItemDef = null;
         var hqUpgradeIdNext:int = hqUpgradeId + 1;
         var separator:String = ",";
         var buyBuildings:String = "";
         var upgradeBuildings:String = "";
         for each(def in InstanceMng.getWorldItemDefMng().getAllBaseDefs())
         {
            type = this.getTextFromItemType(def);
            if(buyBuildings.indexOf(type) == -1)
            {
               if(hqUpgradeIdNext > 0 && def.getMaxNumPerHQUpgradeId(hqUpgradeIdNext) > def.getMaxNumPerHQUpgradeId(hqUpgradeId) || hqUpgradeIdNext == 0 && def.getMaxNumPerHQUpgradeId(hqUpgradeIdNext) == 1)
               {
                  buyBuildings += type + separator;
               }
            }
            if(upgradeBuildings.indexOf(type) == -1)
            {
               upgradedDef = InstanceMng.getWorldItemDefMng().getMaxDefUnlockedAtHqUpgradeId(def.getSku(),hqUpgradeId);
               upgradedNextDef = InstanceMng.getWorldItemDefMng().getMaxDefUnlockedAtHqUpgradeId(def.getSku(),hqUpgradeIdNext);
               if(upgradedDef != null && upgradedNextDef != null)
               {
                  if(upgradedNextDef.getUpgradeId() > upgradedDef.getUpgradeId())
                  {
                     upgradeBuildings += type + separator;
                  }
               }
            }
         }
         return [buyBuildings,upgradeBuildings];
      }
      
      private function getTextFromItemType(itemDef:WorldItemDef) : String
      {
         var tid:int = -1;
         if(itemDef.isARentResource() || itemDef.isASiloOfMinerals() || itemDef.isASiloOfCoins())
         {
            tid = 521;
         }
         else if(itemDef.isAWall())
         {
            tid = 174;
         }
         else if(itemDef.isATurret())
         {
            tid = 526;
         }
         else if(itemDef.isABuildingAttack())
         {
            tid = 529;
         }
         else if(itemDef.isABunker() || itemDef.isAWarpBunker())
         {
            tid = 532;
         }
         else if(itemDef.isALaboratory() || itemDef.isAnObservatory() || itemDef.isARefinery())
         {
            tid = 3711;
         }
         if(tid == -1)
         {
            return "";
         }
         return DCTextMng.getText(tid);
      }
      
      public function applyCurrentWarKOBarFormula(barValue:Number) : Number
      {
         if(barValue == 0)
         {
            return 0;
         }
         var sgn:int = barValue < 0 ? -1 : 1;
         return sgn * Math.log(Math.abs(barValue)) * 0.4342944819032518;
      }
      
      public function sigGetBattleSig(calculate:Boolean) : int
      {
         var str:String = InstanceMng.getWorldItemDefMng().sigCalculate(calculate) + InstanceMng.getShipDefMng().sigCalculate(calculate) + InstanceMng.getToolsMng().sigCalculate(calculate) + InstanceMng.getSpecialAttacksDefMng().sigCalculate(calculate) + InstanceMng.getUnitDefMng().sigCalculate(calculate) + InstanceMng.getSettingsDefMng().sigCalculate(calculate) + this.mSigExtra;
         var returnValue:int = DCUtils.getChk(str);
         DCDebug.traceCh("SigBattle","sigGetBattleSig input = " + str + " output = " + returnValue);
         return returnValue;
      }
      
      public function shopIsAnyDefNew(group:String = null) : int
      {
         var skus:String = null;
         var defs:Vector.<DCDef> = null;
         var def:DCDef = null;
         var returnValue:int = 0;
         if(this.mShopProfile != null)
         {
            skus = this.mShopProfile.flagsGetShopNewSkus();
            if(group == null)
            {
               defs = InstanceMng.getWorldItemDefMng().getNewDefs();
            }
            else
            {
               defs = InstanceMng.getWorldItemDefMng().getDefsInGroup(group);
            }
            for each(def in defs)
            {
               if(this.shopIsDefNew(def,skus))
               {
                  returnValue++;
               }
            }
         }
         return returnValue;
      }
      
      public function shopIsDefNew(def:DCDef, skus:String = null) : Boolean
      {
         var itemDef:WorldItemDef = null;
         var hqLevel:int = 0;
         var returnValue:* = false;
         if(this.mShopProfile != null)
         {
            if(skus == null)
            {
               skus = this.mShopProfile.flagsGetShopNewSkus();
            }
            if(returnValue = def.isNew() && skus.indexOf(def.mSku) == -1)
            {
               if(def is WorldItemDef)
               {
                  itemDef = WorldItemDef(def);
                  if(itemDef != null)
                  {
                     hqLevel = itemDef.getHQUpgradeIdForHavingNumItems(1) + 1;
                     returnValue = this.mShopProfile.getCapitalHqLevel() >= hqLevel;
                  }
               }
            }
         }
         return returnValue;
      }
      
      public function shopMarkNewSkuAsSeen(sku:String) : void
      {
         if(this.mShopNewSkusToMarkAsSeen == null)
         {
            this.mShopNewSkusToMarkAsSeen = [];
         }
         if(this.mShopNewSkusToMarkAsSeen.indexOf(sku) == -1)
         {
            this.mShopNewSkusToMarkAsSeen.push(sku);
         }
      }
      
      public function shopResetNews() : void
      {
         this.mShopNewCount = -1;
      }
      
      public function shopRefreshNews() : void
      {
         var sku:String = null;
         if(this.mShopNewSkusToMarkAsSeen != null)
         {
            while(this.mShopNewSkusToMarkAsSeen.length > 0)
            {
               sku = this.mShopNewSkusToMarkAsSeen.shift();
               this.mShopProfile.flagsAddShopNewSku(sku);
            }
         }
      }
      
      public function giveSpyCapsulesForFree() : Entry
      {
         return InstanceMng.getSettingsDefMng().getSpyCapsulesForFreeItemsEntry();
      }
      
      public function setUserCurrency(userCurrency:String, exchangeValue:Number) : void
      {
         this.mUserCurrency = userCurrency;
         this.mCurrencyExchangeValue = exchangeValue;
      }
      
      public function hasUserCurrency() : Boolean
      {
         return this.mUserCurrency != "";
      }
      
      public function getUserCurrency() : String
      {
         return this.mUserCurrency;
      }
      
      public function getCurrencyExchangeValue() : Number
      {
         return this.mCurrencyExchangeValue;
      }
      
      public function getMaxColonyShieldTime() : Number
      {
         var damageProtectionDef:DamageProtectionDef = InstanceMng.getDamageProtectionDefMng().getDefBySku("maxShieldAccumulate") as DamageProtectionDef;
         return DCTimerUtil.hourToMs(damageProtectionDef.getPeriodTime());
      }
      
      public function addColonyShield(sku:String) : void
      {
         var time:Number = NaN;
         var def:ProtectionTimeDef = InstanceMng.getProtectionTimeDefMng().getDefBySku(sku) as ProtectionTimeDef;
         if(def != null)
         {
            time = def.getProtectionTimeInMs();
            InstanceMng.getUserInfoMng().getProfileLogin().addProtectionTimeLeft(time);
         }
      }
      
      public function checkIfThisColonyShieldTimeWillExceedMax(sku:String) : Boolean
      {
         var profile:Profile;
         var colonyShieldTimeLeft:Number = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getProtectionTimeLeft();
         var def:ProtectionTimeDef = InstanceMng.getProtectionTimeDefMng().getDefBySku(sku) as ProtectionTimeDef;
         var colonyShieldTime:Number = def.getProtectionTimeInMs();
         return colonyShieldTimeLeft + colonyShieldTime > this.getMaxColonyShieldTime();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mShopProfile == null)
         {
            this.mShopProfile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(this.mShopProfile != null && !this.mShopProfile.isBuilt())
            {
               this.mShopProfile = null;
            }
         }
      }
   }
}
