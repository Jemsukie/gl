package com.dchoc.game.model.userdata
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.items.AlliancesRewardsMng;
   import com.dchoc.game.model.rule.SettingsDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.utils.EUtils;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class Profile extends DCComponent
   {
      
      private static const FLAGS_ALLIANCES_WELCOME_ID:String = "alliancesWelcomeId";
      
      private static const FLAGS_ALLIANCES_CURRENT_WAR_ENEMY_ALLIANCE_ID:String = "alliancesCurrentWarEnemyId";
      
      private static const FLAGS_ALLIANCES_CURRENT_WAR_TIME_STARTED:String = "alliancesCurrentWarTimeStarted";
      
      private static const FLAGS_ALLIANCES_ALLIANCE_ID:String = "alliancesId";
      
      private static const FLAGS_ALLIANCES_GROUPS_WELCOME_POPUP:String = "alliancesGroupsWelcomePopup";
      
      private static const FLAGS_ALLIANCES_FIRST_WAR:String = "alliancesFirstWar";
      
      private static const FLAGS_BLACK_HOLE_INTRO_POPUP:String = "blackHoleIntroPopup";
      
      private static const FLAGS_BLACK_HOLE_BATTLE_WON_POPUP:String = "blackHoleBattleWonPopup";
      
      private static const FLAGS_INVESTMENTS_WELCOME_ID:String = "investmentsWelcomeId";
      
      private static const FLAGS_BETS_SHOW_NEW_TIP:String = "betsShowNewTip";
      
      private static const FLAGS_START_NOW_POPUP_TIME_OVER:String = "startNowPopupTimeOver";
      
      private static const FLAGS_SHOP_NEW_SKUS:String = "showNewSkus";
      
      private static const FLAGS_FIRST_SHIELD_USED:String = "firstShieldUsed";
      
      private static const FLAGS_FLATBED:String = "flatbed";
      
      private static const FLAGS_SOUND:String = "sound";
      
      private static const FLAGS_MUSIC:String = "music";
      
      private static const FLAGS_SFX:String = "sfx";
      
      private static const FLAGS_SOUND_VOLUME:String = "soundVolume";
      
      private static const FLAGS_MUSIC_VOLUME:String = "musicVolume";
      
      private static const FLAGS_SFX_VOLUME:String = "sfxVolume";
      
      private static const FLAGS_QUALITY:String = "quality";
      
      private static const FLAGS_SKIN:String = "skin";
      
      private static const FLAGS_LOCALE:String = "locale";
      
      public static const FLAGS_ZOOM:String = "zoom";
      
      public static const FLAGS_FRAMERATE_LIMIT:String = "framerateLimit";
      
      public static const FLAGS_FULLSCREEN_RESOLUTION:String = "fullscreenResolution";
      
      private static const FLAGS_TEXT_ANTI_ALIASING_MODE:String = "textAAMode";
      
      private static const FLAGS_TEXT_SHARPNESS:String = "textSharpness";
      
      private static const FLAGS_TEXT_THICKNESS:String = "textThickness";
      
      private static const FLAGS_STREAMER_MODE:String = "streamerMode";
      
      private static const FLAGS_ANIMATED_BACKGROUND:String = "animatedBackground";
      
      private static const FLAGS_FULLSCREEN:String = "fullscreen";
      
      private static const FLAGS_FOUNDATIONS:String = "foundations";
      
      private static const FLAGS_CIVILS_COLOR:String = "civilsColor";
      
      private static const FLAGS_CIVILS_POPULATION:String = "civilsPopulation";
      
      private static const FLAGS_INVISIBLE_WALLS:String = "invisibleWalls";
      
      private static const FLAGS_INVISIBLE_HANGAR_UNITS:String = "invisibleHangarUnits";
      
      private static const FLAGS_CONFIRM_END_BATTLE:String = "confirmEndBattle";
      
      private static const FLAGS_HOTKEYS:String = "hotkeys";
      
      private static const FLAGS_PARTICLES:String = "particles";
      
      private static const FLAGS_SCROLL_ZOOM_ENABLED:String = "scrollZoomEnabled";
      
      private static const FLAGS_SCROLL_ZOOM_INVERTED:String = "scrollZoomInverted";
      
      private static const FLAGS_USE_MISTERY_GIFTS_OPENED_SO_FAR:String = "misteryGiftsOpenedSoFar";
      
      private static const FLAGS_REFINING_SKU:String = "__refinerySku";
      
      private static const FLAGS_REFINERY_COLLECT_TIME:String = "__refineryCollectTime";
      
      private static const FLAGS_SERVER_MAINTENANCE_TIME:String = "serverMaintenanceTime";
      
      private static const FLAGS_RECENT_CLICKS:String = "recentClicks";
      
      private static const FLAGS_RECENT_CLICK_CONFIDENCE:String = "recentClickConfidence";
       
      
      private var mCash:SecureNumber;
      
      private var mCoins:SecureNumber;
      
      private var mCoinsCapacity:SecureNumber;
      
      private var mCoinsCapacityTotalColonies:SecureNumber;
      
      private var mCoinsCapacityPlanets:Dictionary;
      
      private var mMinerals:SecureNumber;
      
      private var mBadges:SecureNumber;
      
      private var mDroids:SecureNumber;
      
      private var mMaxDroids:SecureNumber;
      
      private var mBadgesCapacity:SecureNumber;
      
      private var mMineralsCapacity:SecureNumber;
      
      private var mMineralsCapacityTotalColonies:SecureNumber;
      
      private var mMineralsCapacityPlanets:Dictionary;
      
      private var mInitialScore:SecureInt;
      
      private var mLevel:SecureInt;
      
      private var mLastLevelNotified:SecureInt;
      
      private var mLevelCheck:SecureBoolean;
      
      private var mPlayerRank:SecureInt;
      
      private var mIsOwner:SecureBoolean;
      
      private var mId:SecureInt;
      
      private var mTutorialCompleted:SecureBoolean;
      
      private var mUserInfoObj:UserInfo;
      
      private var mScoreOff:SecureNumber;
      
      private var mProtectionTimeLeft:SecureNumber;
      
      private var mProtectionTimeTotal:SecureNumber;
      
      private var mDailyBonusTimeLeft:SecureNumber;
      
      public var mIsFan:Boolean;
      
      private var mHasBeenBuiltBefore:SecureBoolean;
      
      private var mCurrentPlanetOrderSku:SecureString;
      
      private var mCurrentPlanetId:SecureString;
      
      private var mIsCurrentPlanetCapital:SecureBoolean;
      
      public var mLastVisit:Number;
      
      private var mInvestorAccountId:SecureString;
      
      private var mInvestNews:SecureBoolean;
      
      private var mSpyCapsulesForFreeTimeLeft:SecureNumber;
      
      private var mShowOfferNewPayerPromo:SecureBoolean;
      
      private var mCreateObstaclesCount:SecureInt;
      
      private var mOnlineProtectionTimeOver:SecureNumber;
      
      private var mDailyLoginStreak:SecureInt;
      
      private var mDailyLoginRewardClaimed:SecureBoolean;
      
      private var mFreeColonyMoves:SecureInt;
      
      private var mFlags:Dictionary;
      
      private var mFlagsReaded:SecureBoolean;
      
      public function Profile()
      {
         mCash = new SecureNumber("Profile.mCash");
         mCoins = new SecureNumber("Profile.mCoins");
         mCoinsCapacity = new SecureNumber("Profile.mCoinsCapacity");
         mCoinsCapacityTotalColonies = new SecureNumber("Profile.mCoinsCapacityTotalColonies");
         mMinerals = new SecureNumber("Profile.mMinerals");
         mBadges = new SecureNumber("Profile.mBadges");
         mDroids = new SecureNumber("Profile.mDroids");
         mMaxDroids = new SecureNumber("Profile.mMaxDroids");
         mBadgesCapacity = new SecureNumber("Profile.mBadgesCapacity");
         mMineralsCapacity = new SecureNumber("Profile.mMineralsCapacity");
         mMineralsCapacityTotalColonies = new SecureNumber("Profile.mMineralsCapacityTotalColonies");
         mInitialScore = new SecureInt("Profile.mInitialScore");
         mLevel = new SecureInt("Profile.mLevel",1);
         mLastLevelNotified = new SecureInt("Profile.mLastLevelNotified",-1);
         mLevelCheck = new SecureBoolean("Profile.mLevelCheck");
         mPlayerRank = new SecureInt("Profile.mPlayerRank",1);
         mIsOwner = new SecureBoolean("Profile.mIsOwner");
         mId = new SecureInt("Profile.mId",1);
         mTutorialCompleted = new SecureBoolean("Profile.mTutorialCompleted");
         mScoreOff = new SecureNumber("Profile.mScoreOff");
         mProtectionTimeLeft = new SecureNumber("Profile.mProtectionTimeLeft");
         mProtectionTimeTotal = new SecureNumber("Profile.mProtectionTimeTotal");
         mDailyBonusTimeLeft = new SecureNumber("Profile.mDailyBonusTimeLeft");
         mHasBeenBuiltBefore = new SecureBoolean("Profile.mHasBeenBuiltBefore");
         mCurrentPlanetOrderSku = new SecureString("Profile.mCurrentPlanetOrderSku");
         mCurrentPlanetId = new SecureString("Profile.mCurrentPlanetId");
         mIsCurrentPlanetCapital = new SecureBoolean("Profile.mIsCurrentPlanetCapital");
         mInvestorAccountId = new SecureString("Profile.mInvestorAccountId");
         mInvestNews = new SecureBoolean("Profile.mInvestNews");
         mSpyCapsulesForFreeTimeLeft = new SecureNumber("Profile.mSpyCapsulesForFreeTimeLeft");
         mShowOfferNewPayerPromo = new SecureBoolean("Profile.mShowOfferNewPayerPromo");
         mCreateObstaclesCount = new SecureInt("Profile.mCreateObstaclesCount",1);
         mOnlineProtectionTimeOver = new SecureNumber("Profile.mOnlineProtectionTimeOver",-1);
         mDailyLoginStreak = new SecureInt("Profile.mDailyLoginStreak",1);
         mDailyLoginRewardClaimed = new SecureBoolean("Profile.mDailyLoginRewardClaimed",true);
         mFreeColonyMoves = new SecureInt("Profile.mFreeColonyMoves",1);
         mFlagsReaded = new SecureBoolean("Profile.mFlagsReaded");
         super();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
         this.mHasBeenBuiltBefore.value = false;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(mPersistenceData != null)
         {
            this.setupCommonAttributes();
            this.setupMiscellaneousAttributes();
            this.setupPlanetsAttributes();
            this.setupPlanetsEconomicAttributes();
            if(!this.mHasBeenBuiltBefore.value)
            {
               this.mHasBeenBuiltBefore.value = true;
            }
            buildAdvanceSyncStep();
         }
      }
      
      private function setupPlanetsEconomicAttributes() : void
      {
         var planetInfo:XML = null;
         var planetId:String = null;
         var coinsLimit:Number = NaN;
         var mineralsLimit:Number = NaN;
         var attribute:String = null;
         var baseCoinsAndMineralsCapacity:Number = NaN;
         var planetsXML:XML = EUtils.XMLListToXML(EUtils.xmlGetChildrenList(mPersistenceData,"Planets"));
         this.mCoinsCapacityTotalColonies.value = 0;
         this.mMineralsCapacityTotalColonies.value = 0;
         if(Config.DEBUG_MODE || UserDataMng.mUserIsVIP)
         {
            attribute = "baseCoinsAndMineralsCapacity";
            if(EUtils.xmlIsAttribute(planetsXML,attribute))
            {
               baseCoinsAndMineralsCapacity = EUtils.xmlReadNumber(planetsXML,attribute);
               this.mCoinsCapacityTotalColonies.value += baseCoinsAndMineralsCapacity;
               this.mMineralsCapacityTotalColonies.value += baseCoinsAndMineralsCapacity;
            }
         }
         this.mCoinsCapacityPlanets = new Dictionary(false);
         this.mMineralsCapacityPlanets = new Dictionary(false);
         this.mIsCurrentPlanetCapital.value = true;
         for each(planetInfo in EUtils.xmlGetChildrenList(planetsXML,"Planet"))
         {
            planetId = EUtils.xmlReadString(planetInfo,"planetId");
            coinsLimit = EUtils.xmlReadNumber(planetInfo,"coinsLimit");
            mineralsLimit = EUtils.xmlReadNumber(planetInfo,"mineralsLimit");
            this.mCoinsCapacityPlanets[planetId] = coinsLimit;
            this.mMineralsCapacityPlanets[planetId] = mineralsLimit;
            if(planetId != this.mCurrentPlanetId.value && InstanceMng.getRole().mId != 7)
            {
               this.mCoinsCapacityTotalColonies.value += coinsLimit;
               this.mMineralsCapacityTotalColonies.value += mineralsLimit;
            }
            else
            {
               this.mIsCurrentPlanetCapital.value = EUtils.xmlReadBoolean(planetInfo,"capital");
            }
         }
      }
      
      private function setupMiscellaneousAttributes() : void
      {
         var locale:String = null;
         var fullscreenRes:String = null;
         var stage:Stage = null;
         var fsRect:Rectangle = null;
         var framerateLimit:int = 0;
         var isFanResponse:Object;
         if((isFanResponse = InstanceMng.getUserDataMng().getFile(UserDataMng.KEY_IS_FAN)) != null && isFanResponse.hasOwnProperty("isFan"))
         {
            this.mIsFan = isFanResponse.isFan;
         }
         this.readFlagsFromProfile();
         if(this.getIsOwner())
         {
            locale = this.getLocale();
            if(DCTextMng.langListGetIds().indexOf(locale) > -1)
            {
               DCTextMng.langSetLang(locale);
               DCTextMng.langBuild(InstanceMng.getEResourcesMng().getAssetString(locale,"locale"));
            }
            else
            {
               this.setLocale("EN");
            }
            if(InstanceMng.getSkinsMng().getSkinBySku(this.getSkin()))
            {
               InstanceMng.getSkinsMng().changeSkin(this.getSkin());
            }
            InstanceMng.getSkinsMng().setCurrentFoundationSku(this.getFoundations());
            fullscreenRes = this.getFullscreenResolution();
            stage = InstanceMng.getApplication().stageGetStage().getImplementation();
            if(fullscreenRes != "" && fullscreenRes.indexOf(",") > -1)
            {
               fsRect = new Rectangle(0,0,fullscreenRes.split(",")[0],fullscreenRes.split(",")[1]);
               stage.fullScreenSourceRect = fsRect;
            }
            framerateLimit = this.getFramerateLimit();
            if(framerateLimit >= 5 && framerateLimit <= 120)
            {
               stage.frameRate = framerateLimit;
            }
         }
      }
      
      private function setupPlanetsAttributes() : void
      {
         var capital:Planet = null;
         this.setCurrentPlanetId(InstanceMng.getApplication().goToGetCurrentPlanetId());
         var roleId:int = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
         if(this.getCurrentPlanetId() == null)
         {
            capital = this.mUserInfoObj.getCapital();
            if(capital != null)
            {
               this.setCurrentPlanetId(capital.getPlanetId());
            }
         }
         if(roleId == 0 && this.getCurrentPlanetId() != null)
         {
            InstanceMng.getApplication().goToSetCurrentDestinationInfo(this.getCurrentPlanetId(),this.mUserInfoObj);
         }
         var currentPlanetOrderId:int = this.mUserInfoObj.getPlanetOrder(this.getCurrentPlanetId());
         if(currentPlanetOrderId == -1)
         {
            if(Config.DEBUG_ASSERTS)
            {
               DCDebug.trace("Error in Profile: " + this.getCurrentPlanetId() + " is not a planet of the user",1);
            }
            currentPlanetOrderId = 0;
         }
         this.mCurrentPlanetOrderSku.value = "" + (currentPlanetOrderId + 1);
      }
      
      private function setupCommonAttributes() : void
      {
         var settingsObject:SettingsDef = null;
         var alliancesRewardsMng:AlliancesRewardsMng = null;
         var alliancesRewardsGained:String = null;
         this.mTutorialCompleted.value = EUtils.xmlReadBoolean(mPersistenceData,"tutorialCompleted");
         if(this.mTutorialCompleted.value || this.mHasBeenBuiltBefore.value)
         {
            this.mCoins.value = EUtils.xmlReadNumber(mPersistenceData,"DCCoins");
            this.mCash.value = EUtils.xmlReadNumber(mPersistenceData,"DCCash");
            this.mMinerals.value = EUtils.xmlReadNumber(mPersistenceData,"DCMinerals");
            this.mBadges.value = EUtils.xmlReadNumber(mPersistenceData,"DCBadges");
            this.mDroids.value = EUtils.xmlReadNumber(mPersistenceData,"DCDroids");
         }
         else
         {
            settingsObject = InstanceMng.getSettingsDefMng().mSettingsDef;
            this.mMinerals.value = settingsObject.mDefaultMinerals.value;
            this.mCoins.value = settingsObject.mDefaultCoins.value;
            this.mCash.value = settingsObject.getDefaultCash();
            this.mBadges.value = 0;
            this.mDroids.value = InstanceMng.getRuleMng().getDefaultDroids();
         }
         this.mUserInfoObj.setScore(EUtils.xmlReadNumber(mPersistenceData,"score"));
         this.mInitialScore.value = this.mUserInfoObj.getScore();
         this.mLevel.value = this.mUserInfoObj.getLevel();
         this.resetScoreOff();
         this.mMineralsCapacity.value = 0;
         this.mCoinsCapacity.value = 0;
         this.mMaxDroids.value = this.mDroids.value;
         this.mProtectionTimeLeft.value = EUtils.xmlReadNumber(mPersistenceData,"damageProtectionTimeLeft");
         this.mProtectionTimeTotal.value = EUtils.xmlReadNumber(mPersistenceData,"damageProtectionTimeTotal");
         this.mDailyBonusTimeLeft.value = EUtils.xmlReadNumber(mPersistenceData,"dailyBonusTimeLeft");
         this.mDailyLoginStreak.value = EUtils.xmlReadInt(mPersistenceData,"dailyLoginStreak");
         this.mDailyLoginRewardClaimed.value = EUtils.xmlReadBoolean(mPersistenceData,"dailyLoginRewardClaimed");
         this.mFreeColonyMoves.value = EUtils.xmlReadInt(mPersistenceData,"freeColonyMoves");
         this.mLastLevelNotified.value = EUtils.xmlIsAttribute(mPersistenceData,"lastLevelNotified") ? EUtils.xmlReadInt(mPersistenceData,"lastLevelNotified") : this.mLevel.value;
         if(this.mLastLevelNotified.value <= 0)
         {
            this.mLastLevelNotified.value = this.mLevel.value;
         }
         var MAX_LEVEL_UPS_IN_A_ROW:int = 3;
         if(this.mLevel.value - this.mLastLevelNotified.value > MAX_LEVEL_UPS_IN_A_ROW)
         {
            this.mLastLevelNotified.value = this.mLevel.value - MAX_LEVEL_UPS_IN_A_ROW;
         }
         this.enableLevelUpCheck();
         if(this.getIsOwner())
         {
            this.mPlayerRank.value = EUtils.xmlReadInt(mPersistenceData,"DCPlayerRank");
         }
         var attribute:String = "lastVisitTime";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.setLastVisit(EUtils.xmlReadNumber(mPersistenceData,attribute));
         }
         attribute = "alliancesRewardsGained";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            alliancesRewardsMng = InstanceMng.getAlliancesRewardsMng();
            if(alliancesRewardsMng != null)
            {
               alliancesRewardsGained = EUtils.xmlReadString(mPersistenceData,attribute);
               alliancesRewardsMng.setRewardsGained(alliancesRewardsGained);
            }
         }
         attribute = "inversorAccountId";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.mInvestorAccountId.value = EUtils.xmlReadString(mPersistenceData,attribute);
         }
         attribute = "investNews";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.mInvestNews.value = EUtils.xmlReadBoolean(mPersistenceData,attribute);
         }
         attribute = "spyCapsulesTimeLeft";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.mSpyCapsulesForFreeTimeLeft.value = EUtils.xmlReadNumber(mPersistenceData,attribute);
         }
         attribute = "createObstacles";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.mCreateObstaclesCount.value = EUtils.xmlReadInt(mPersistenceData,attribute);
         }
         attribute = "onlineProtectionTimeOver";
         if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
         {
            this.mOnlineProtectionTimeOver.value = EUtils.xmlReadNumber(mPersistenceData,attribute);
            if(this.mOnlineProtectionTimeOver.value <= 0)
            {
               this.mOnlineProtectionTimeOver.value = -1;
            }
         }
      }
      
      public function getAlliancesRewardGainedData() : String
      {
         var attribute:String = null;
         var returnValue:String = "";
         if(mPersistenceData != null)
         {
            attribute = "alliancesRewardsGained";
            if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
            {
               returnValue = EUtils.xmlReadString(mPersistenceData,attribute);
            }
         }
         return returnValue;
      }
      
      override protected function unbuildDo() : void
      {
         this.mCoinsCapacityPlanets = null;
         this.mMineralsCapacityPlanets = null;
      }
      
      override protected function beginDo() : void
      {
         if(this.getIsOwner())
         {
            this.getSound();
            this.getMusic();
            this.getSfx();
            this.getMusicVolume();
            this.getSoundVolume();
            this.getSfxVolume();
            this.getQuality();
         }
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.flagsLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mUserInfoObj = null;
         this.flagsUnload();
      }
      
      public function areAnyInvestNews() : Boolean
      {
         return this.mInvestNews.value;
      }
      
      public function getInvestorAccountId() : String
      {
         return this.mInvestorAccountId.value;
      }
      
      public function hasAnInvestorValid() : Boolean
      {
         return this.mInvestorAccountId.value != null && this.mInvestorAccountId.value != "";
      }
      
      public function getLastVisit() : Number
      {
         return this.mLastVisit;
      }
      
      public function getCash() : Number
      {
         return this.mCash.value;
      }
      
      public function getCoins() : Number
      {
         return this.mCoins.value;
      }
      
      public function getMinerals() : Number
      {
         return this.mMinerals.value;
      }
      
      public function getBadges() : Number
      {
         return this.mBadges.value;
      }
      
      public function getLevel() : int
      {
         if(this.mUserInfoObj != null && this.mUserInfoObj.getLevel() != this.mLevel.value)
         {
            DCDebug.traceCh("ASSERT","[INFO] Mismatch in Profile.getLevel (" + this.mLevel.value + ") / UserInfo.getLevel (" + this.mUserInfoObj.getLevel() + ")!",1);
         }
         return this.mLevel.value;
      }
      
      public function getLastLevelNotified() : int
      {
         return this.mLastLevelNotified.value;
      }
      
      public function getId() : int
      {
         return this.mId.value;
      }
      
      public function getPlayerName() : String
      {
         return this.mUserInfoObj.getPlayerName();
      }
      
      public function getPlayerFirstName() : String
      {
         return this.mUserInfoObj.getPlayerFirstName();
      }
      
      public function getXp() : Number
      {
         return this.mUserInfoObj.getXp();
      }
      
      public function getScore() : Number
      {
         return this.mUserInfoObj.getScore();
      }
      
      public function getScoreOff() : Number
      {
         return this.mScoreOff.value;
      }
      
      public function resetScoreOff() : void
      {
         this.mScoreOff.value = 0;
      }
      
      public function getPlayerRank() : int
      {
         return this.mPlayerRank.value;
      }
      
      public function getMineralsCapacity() : Number
      {
         return this.mMineralsCapacity.value;
      }
      
      public function getPlanetMineralsCapacity(planetId:String) : Number
      {
         return this.mMineralsCapacityPlanets[planetId];
      }
      
      public function getCoinsCapacity() : Number
      {
         return this.mCoinsCapacity.value;
      }
      
      public function getPlanetCoinsCapacity(planetId:String) : Number
      {
         return this.mCoinsCapacityPlanets[planetId];
      }
      
      public function getCoinsFit() : Number
      {
         return this.getCoinsCapacity() - this.getCoins();
      }
      
      public function wouldCoinsFit(amount:Number) : Boolean
      {
         amount = Math.floor(amount);
         return amount <= this.getCoinsFit();
      }
      
      public function getMineralsFit() : Number
      {
         return this.getMineralsCapacity() - this.getMinerals();
      }
      
      public function wouldMineralsFit(amount:Number) : Boolean
      {
         amount = Math.floor(amount);
         return amount <= this.getMineralsFit();
      }
      
      public function getDroids() : Number
      {
         return this.mDroids.value;
      }
      
      public function getDroidsBusy() : int
      {
         return this.mMaxDroids.value - this.mDroids.value;
      }
      
      public function getMaxDroidsAmount() : Number
      {
         return this.mMaxDroids.value;
      }
      
      public function isTutorialCompleted() : Boolean
      {
         return this.mTutorialCompleted.value;
      }
      
      public function getProtectionTimeLeft() : Number
      {
         return this.mProtectionTimeLeft.value;
      }
      
      public function getProtectionTimeTotal() : Number
      {
         return this.mProtectionTimeTotal.value;
      }
      
      public function getProtectionTimeLeftPercentage() : Number
      {
         if(this.mProtectionTimeTotal.value == 0)
         {
            return 1;
         }
         return this.mProtectionTimeLeft.value / this.mProtectionTimeTotal.value;
      }
      
      public function getThumbnailURL() : String
      {
         return this.mUserInfoObj.getThumbnailURL();
      }
      
      public function getAccountId() : String
      {
         if(this.mUserInfoObj)
         {
            return this.mUserInfoObj.getAccountId();
         }
         return null;
      }
      
      public function getExtId() : String
      {
         return this.mUserInfoObj.getExtId();
      }
      
      public function getUserInfoObj() : UserInfo
      {
         return this.mUserInfoObj;
      }
      
      public function getIsOwner() : Boolean
      {
         return this.mId.value == 0;
      }
      
      public function setDailyBonusTimeLeft(value:Number) : void
      {
         this.mDailyBonusTimeLeft.value = value;
      }
      
      public function getDailyBonusTimeLeft() : Number
      {
         return this.mDailyBonusTimeLeft.value;
      }
      
      public function getCapitalPlanet() : Planet
      {
         return this.mUserInfoObj.getCapital();
      }
      
      public function getCurrentPlanetOrderSku() : String
      {
         return this.mCurrentPlanetOrderSku.value;
      }
      
      public function getCurrentPlanetId() : String
      {
         return this.mCurrentPlanetId.value;
      }
      
      public function getCurrentPlanetHqLevel() : int
      {
         return this.mUserInfoObj.getPlanetById(this.getCurrentPlanetId()).getHQLevel();
      }
      
      public function getCapitalHqLevel() : int
      {
         var returnValue:int = 0;
         if(this.mUserInfoObj.getCapital() != null)
         {
            returnValue = this.mUserInfoObj.getCapital().getHQLevel();
         }
         return returnValue;
      }
      
      public function getMaxHqLevelInAllPlanets() : int
      {
         var p:Planet = null;
         var maxHqLevel:int = 0;
         for each(p in this.mUserInfoObj.getPlanets())
         {
            if(p.getHQLevel() > maxHqLevel)
            {
               maxHqLevel = p.getHQLevel();
            }
         }
         return maxHqLevel;
      }
      
      public function isCurrentPlanetCapital() : Boolean
      {
         return this.mIsCurrentPlanetCapital.value;
      }
      
      public function getSpyCapsulesForFreeTimeLeft() : Number
      {
         return this.mSpyCapsulesForFreeTimeLeft.value;
      }
      
      public function getCountObstaclesToCreate() : int
      {
         return this.mCreateObstaclesCount.value;
      }
      
      public function getOnlineProtectionTimeOver() : Number
      {
         return this.mOnlineProtectionTimeOver.value;
      }
      
      public function getOnlineProtectionTimeLeft() : Number
      {
         var returnValue:Number = this.getOnlineProtectionTimeOver() - InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         if(returnValue < 0)
         {
            returnValue = 0;
         }
         return returnValue;
      }
      
      public function setCountObstaclesToCreate(value:int) : void
      {
         this.mCreateObstaclesCount.value = value;
      }
      
      public function setLastVisit(value:Number) : void
      {
         this.mLastVisit = value;
      }
      
      public function setPlayerName(playerName:String) : void
      {
         if(this.mUserInfoObj != null)
         {
            this.mUserInfoObj.setPlayerName(playerName);
            this.mUserInfoObj.setHasChanged(true);
         }
      }
      
      public function setTutorialCompleted(complete:Boolean) : void
      {
         this.mTutorialCompleted.value = complete;
      }
      
      public function setCash(cash:Number) : void
      {
         cash = Math.floor(cash);
         this.mCash.value = cash;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addCash(cash:Number) : void
      {
         cash = Math.floor(cash);
         this.mCash.value += cash;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function subtractCash(cash:Number) : void
      {
         cash = Math.floor(cash);
         this.mCash.value -= cash;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setCoins(coins:Number) : void
      {
         coins = Math.floor(coins);
         this.regulateCurrency(coins,1,false,true);
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addCoins(coins:Number) : Number
      {
         coins = Math.floor(coins);
         var difference:Number = this.regulateCurrency(coins,1,true,true);
         this.mUserInfoObj.setHasChanged(true);
         return difference;
      }
      
      public function refillCoins() : void
      {
         this.setCoins(this.getCoinsCapacity());
      }
      
      public function regulateCurrency(amount:Number, currency:int, isAddition:Boolean = true, doEffective:Boolean = true) : Number
      {
         var difference:Number = 0;
         switch(currency - 1)
         {
            case 0:
               if(isAddition)
               {
                  if(this.mCoinsCapacity.value < this.mCoins.value + amount)
                  {
                     difference = this.mCoins.value + amount - this.mCoinsCapacity.value;
                  }
               }
               else if(this.mCoinsCapacity.value < amount)
               {
                  difference = amount - this.mCoinsCapacity.value;
               }
               if(doEffective)
               {
                  if(difference > 0)
                  {
                     this.mCoins.value = this.mCoinsCapacity.value;
                  }
                  else if(isAddition)
                  {
                     this.mCoins.value += amount;
                  }
                  else
                  {
                     this.mCoins.value = amount;
                  }
               }
               break;
            case 1:
               if(isAddition)
               {
                  if(this.mMinerals.value < this.mMinerals.value + amount)
                  {
                     difference = this.mMinerals.value + amount - this.mMineralsCapacity.value;
                  }
               }
               else if(this.mMineralsCapacity.value < amount)
               {
                  difference = amount - this.mMineralsCapacity.value;
               }
               if(doEffective)
               {
                  if(difference > 0)
                  {
                     this.mMinerals.value = this.mMineralsCapacity.value;
                  }
                  else if(isAddition)
                  {
                     this.mMinerals.value += amount;
                  }
                  else
                  {
                     this.mMinerals.value = amount;
                  }
               }
               break;
            case 7:
               if(isAddition)
               {
                  if(this.mBadges.value < this.mBadges.value + amount)
                  {
                     difference = this.mBadges.value + amount - this.getBadgesCapacity();
                  }
               }
               else if(this.getBadgesCapacity() < amount)
               {
                  difference = amount - this.getBadgesCapacity();
               }
               if(doEffective)
               {
                  if(difference > 0)
                  {
                     this.mBadges.value = this.getBadgesCapacity();
                     break;
                  }
                  if(isAddition)
                  {
                     this.mBadges.value += amount;
                     break;
                  }
                  this.mBadges.value = amount;
                  break;
               }
         }
         MessageCenter.getInstance().sendMessage("updateHud");
         return difference;
      }
      
      public function subtractCoins(coins:Number) : void
      {
         coins = Math.floor(coins);
         var diff:Number = coins - this.mCoins.value;
         if(diff > 0)
         {
            this.mCoins.value -= coins - diff;
         }
         else
         {
            this.mCoins.value -= coins;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setMinerals(minerals:Number) : void
      {
         minerals = Math.floor(minerals);
         this.regulateCurrency(minerals,2,false,true);
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addMinerals(minerals:Number) : Number
      {
         minerals = Math.floor(minerals);
         var difference:Number = this.regulateCurrency(minerals,2,true,true);
         this.mUserInfoObj.setHasChanged(true);
         return difference;
      }
      
      public function refillMinerals() : void
      {
         this.setMinerals(this.getMineralsCapacity());
      }
      
      public function subtractMinerals(minerals:Number) : void
      {
         minerals = Math.floor(minerals);
         this.mMinerals.value -= minerals;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setMineralsCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mMineralsCapacity.value = amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function resetMineralsCapacityAmount() : void
      {
         this.setMineralsCapacityAmount(this.mMineralsCapacityTotalColonies.value);
      }
      
      public function addMineralCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mMineralsCapacity.value += amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function subtractMineralCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mMineralsCapacity.value -= amount;
         if(this.mMinerals.value > this.mMineralsCapacity.value)
         {
            this.mMinerals.value = this.mMineralsCapacity.value;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function resetCoinsCapacityAmount() : void
      {
         this.setCoinsCapacityAmount(this.mCoinsCapacityTotalColonies.value);
      }
      
      public function setCoinsCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mCoinsCapacity.value = amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addCoinsCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mCoinsCapacity.value += amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function subtractCoinsCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mCoinsCapacity.value -= amount;
         if(this.mCoins.value > this.mCoinsCapacity.value)
         {
            this.mCoins.value = this.mCoinsCapacity.value;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function getCoinsCapacityCurrentPlanet() : Number
      {
         return this.mCoinsCapacity.value - this.mCoinsCapacityTotalColonies.value;
      }
      
      public function getMineralsCapacityCurrentPlanet() : Number
      {
         return this.mMineralsCapacity.value - this.mMineralsCapacityTotalColonies.value;
      }
      
      public function setBadges(badges:Number) : void
      {
         badges = Math.floor(badges);
         this.regulateCurrency(badges,8,false,true);
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addBadges(badges:Number) : Number
      {
         badges = Math.floor(badges);
         var difference:Number = this.regulateCurrency(badges,8,true,true);
         this.mUserInfoObj.setHasChanged(true);
         return difference;
      }
      
      public function refillBadges() : void
      {
         this.setBadges(this.getBadgesCapacity());
      }
      
      public function subtractBadges(badges:Number) : void
      {
         badges = Math.floor(badges);
         this.mBadges.value -= badges;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setBadgesCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mBadgesCapacity.value = amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function resetBadgesCapacityAmount() : void
      {
         this.setBadgesCapacityAmount(this.mBadgesCapacity.value);
      }
      
      public function addBadgesCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mBadgesCapacity.value += amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function subtractBadgesCapacityAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mBadgesCapacity.value -= amount;
         if(this.mBadges.value > this.mBadgesCapacity.value)
         {
            this.mBadges.value = this.mBadgesCapacity.value;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function getBadgesCapacity() : Number
      {
         var alliance:Alliance = (InstanceMng.getAlliancesController() as AlliancesControllerStar).getMyAlliance();
         return alliance == null ? 0 : InstanceMng.getAlliancesLevelDefMng().getMaxBadgesFromScore(alliance.getScore());
      }
      
      public function addDroids(amount:int) : void
      {
         this.mDroids.value += amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function resetDroids() : void
      {
         this.mDroids.value = this.mMaxDroids.value;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setMaxDroidsAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mMaxDroids.value = amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addMaxDroidsAmount(amount:Number) : void
      {
         amount = Math.floor(amount);
         this.mMaxDroids.value += amount;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setRank(rank:int) : void
      {
         this.mPlayerRank.value = rank;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function getAmountByCurrency(type:int) : Number
      {
         var returnValue:Number = 0;
         switch(type)
         {
            case 0:
               returnValue = this.mCash.value;
               break;
            case 1:
               returnValue = this.mCoins.value;
               break;
            case 2:
               returnValue = this.mMinerals.value;
               break;
            case 3:
               returnValue = this.mMineralsCapacity.value;
               break;
            case 4:
               returnValue = this.mDroids.value;
               break;
            case 5:
               returnValue = this.mMaxDroids.value;
               break;
            case 7:
               returnValue = this.mCoinsCapacity.value;
         }
         return returnValue;
      }
      
      public function setAmountByCurrency(type:int, amount:Number) : void
      {
         amount = Math.floor(amount);
         switch(type)
         {
            case 0:
               this.mCash.value = amount;
               break;
            case 1:
               this.mCoins.value = amount;
               break;
            case 2:
               this.mMinerals.value = amount;
               break;
            case 3:
               this.mMineralsCapacity.value = amount;
               break;
            case 4:
               this.mDroids.value = amount;
               break;
            case 5:
               this.mMaxDroids.value = amount;
               break;
            case 7:
               this.mCoinsCapacity.value = amount;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function addAmountByCurrency(type:int, amount:Number) : void
      {
         amount = Math.floor(amount);
         switch(type)
         {
            case 0:
               this.mCash.value += amount;
               break;
            case 1:
               this.mCoins.value += amount;
               break;
            case 2:
               this.mMinerals.value += amount;
               break;
            case 3:
               this.mMineralsCapacity.value += amount;
               break;
            case 4:
               this.mDroids.value += amount;
               break;
            case 5:
               this.mMaxDroids.value += amount;
               break;
            case 7:
               this.mCoinsCapacity.value += amount;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function subtractAmountByCurrency(type:int, amount:Number) : void
      {
         amount = Math.floor(amount);
         switch(type)
         {
            case 0:
               this.mCash.value -= amount;
               break;
            case 1:
               this.mCoins.value -= amount;
               break;
            case 2:
               this.mMinerals.value -= amount;
               break;
            case 3:
               this.mMineralsCapacity.value -= amount;
               break;
            case 4:
               this.mDroids.value -= amount;
               break;
            case 5:
               this.mMaxDroids.value -= amount;
               break;
            case 7:
               this.mCoinsCapacity.value -= amount;
         }
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setLevel(level:int) : void
      {
         this.mLevel.value = level;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setIsOwner(isOwner:Boolean) : void
      {
         this.mIsOwner.value = isOwner;
         this.mUserInfoObj.setHasChanged(true);
      }
      
      public function setId(id:int) : void
      {
         this.mId.value = id;
      }
      
      public function addXp(xp:Number) : void
      {
         if(this.mUserInfoObj != null)
         {
            this.mUserInfoObj.addXp(xp);
         }
      }
      
      public function addScore(value:Number) : void
      {
         if(this.mUserInfoObj == null)
         {
            return;
         }
         this.mUserInfoObj.addScore(value);
         this.mScoreOff.value += value;
         this.setLevelDependingOnCurrentScore();
      }
      
      private function enableLevelUpCheck() : void
      {
         if(InstanceMng.getRole().mId == 0)
         {
            this.mLevelCheck.value = false;
         }
      }
      
      private function setLevelDependingOnCurrentScore() : void
      {
         var levelShouldHave:int = this.getLevelFromScore();
         var currentProfileLevel:int = this.getLevel();
         var nextLevel:* = levelShouldHave;
         if(levelShouldHave > currentProfileLevel)
         {
            this.enableLevelUpCheck();
            this.setLevel(nextLevel);
         }
      }
      
      public function getLevelFromScore() : int
      {
         return parseInt(InstanceMng.getLevelScoreDefMng().getLevelFromValue(this.getScore()));
      }
      
      public function setProtectionTimeLeft(value:Number) : void
      {
         this.mProtectionTimeLeft.value = value;
         this.mProtectionTimeTotal.value = value;
      }
      
      public function addProtectionTimeLeft(value:Number) : void
      {
         this.mProtectionTimeLeft.value += value;
         this.mProtectionTimeTotal.value += value;
      }
      
      public function setThumbnailURL(value:String) : void
      {
         this.mUserInfoObj.setThumbnailURL(value);
      }
      
      public function setAccountId(value:String) : void
      {
         this.mUserInfoObj.setAccountId(value);
      }
      
      public function setExtId(value:String) : void
      {
         this.mUserInfoObj.setExtId(value);
      }
      
      public function setUserInfoObj(value:UserInfo) : void
      {
         this.mUserInfoObj = value;
         this.mUserInfoObj.setParentProfile(this);
      }
      
      public function setCurrentPlanetId(value:String) : void
      {
         this.mCurrentPlanetId.value = value;
      }
      
      public function setSpyCapsulesForFreeTimeLeft(value:Number) : void
      {
         this.mSpyCapsulesForFreeTimeLeft.value = value;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var backLastLevelNotified:int = 0;
         var friendsPassed:Vector.<UserInfo> = null;
         var o:Object = null;
         var level:* = 0;
         if(this.mIsOwner.value && !this.mLevelCheck.value)
         {
            if(this.mLevel.value > this.mLastLevelNotified.value)
            {
               backLastLevelNotified = this.mLastLevelNotified.value;
               this.mLastLevelNotified.value = this.mLevel.value;
               for(level = backLastLevelNotified; level < this.mLevel.value; )
               {
                  (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyLevelUp")).level = level + 1;
                  friendsPassed = InstanceMng.getUserInfoMng().getPassedFriendsByScore(this.mInitialScore.value);
                  o.friendsPassed = friendsPassed;
                  o.finalLevel = level + 1 == this.mLevel.value;
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,false);
                  level++;
               }
            }
            this.mLevelCheck.value = true;
            this.mInitialScore.value = this.mUserInfoObj.getScore();
         }
         if(this.mUserInfoObj != null)
         {
            if(this.mUserInfoObj.getHasChanged())
            {
               MessageCenter.getInstance().sendMessage("updateHud");
            }
            this.mUserInfoObj.logicUpdate(dt);
         }
         if(this.mProtectionTimeLeft.value > 0)
         {
            if(this.mProtectionTimeLeft.value - dt >= 0)
            {
               this.mProtectionTimeLeft.value -= dt;
            }
            else
            {
               this.mProtectionTimeLeft.value = 0;
            }
         }
      }
      
      private function flagsLoad() : void
      {
         this.mFlags = new Dictionary(true);
      }
      
      private function flagsUnload() : void
      {
         this.mFlags = null;
      }
      
      public function getFlagsReaded() : Boolean
      {
         return this.mFlagsReaded.value;
      }
      
      private function readFlagsFromProfile() : void
      {
         var attribute:String = null;
         if(mPersistenceData != null && !this.mFlagsReaded.value)
         {
            attribute = "flags";
            if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
            {
               this.flagsRead(EUtils.xmlReadString(mPersistenceData,attribute));
            }
            this.mFlagsReaded.value = true;
         }
         DCDebug.traceCh("Flags","Flags read from profile (owner = " + this.getIsOwner() + "): " + this.mFlags);
      }
      
      private function flagsRead(flags:String) : void
      {
         var key:String = null;
         var info:Array = null;
         var flagsArray:Array = flags.split(",");
         DCDebug.traceCh("Flags","Reading flags from raw: " + flags);
         for each(key in flagsArray)
         {
            if(key != "")
            {
               if((info = key.split(":")).length == 1)
               {
                  this.mFlags[key] = 1;
               }
               else
               {
                  this.mFlags[info[0]] = info[1];
               }
            }
         }
         DCDebug.traceCh("Flags","flagsRead = " + this.mFlags);
      }
      
      private function flagsToString() : String
      {
         var key:* = null;
         var returnValue:String = "";
         for(key in this.mFlags)
         {
            returnValue += key + ":" + this.mFlags[key] + ",";
         }
         return returnValue;
      }
      
      public function flagsGetValue(key:String) : Object
      {
         DCDebug.traceCh("Flags","Fetching value for " + key);
         DCDebug.traceCh("Flags","Value is " + this.mFlags[key]);
         if(this.mFlags[key] == null || this.mFlags[key] == undefined)
         {
            return null;
         }
         return this.mFlags[key];
      }
      
      public function flagsSetValue(key:String, v:Object, trans:Transaction = null) : void
      {
         DCDebug.traceCh("Flags","Setting flag " + key + " to " + v);
         flagsSetValueLocal(key,v);
         InstanceMng.getUserDataMng().updateProfile_setFlag(key,v,trans);
      }
      
      public function flagsSetValueLocal(key:String, v:Object) : void
      {
         this.mFlags[key] = v;
         DCDebug.traceCh("Flags","Setting flags LOCALLY " + key + " to " + v);
      }
      
      public function flagsGetValueAsInt(key:String) : int
      {
         var returnValue:int = 0;
         if(this.flagsGetValue(key) != null)
         {
            returnValue = int(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsGetValueAsNumber(key:String) : Number
      {
         var returnValue:Number = 0;
         if(this.flagsGetValue(key) != null)
         {
            returnValue = Number(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsGetValueAsString(key:String) : String
      {
         var returnValue:String = "";
         if(this.flagsGetValue(key) != null)
         {
            returnValue = String(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsAccumValue(key:String, off:int) : void
      {
         var value:int = this.flagsGetValueAsInt(key);
         value += off;
         this.flagsSetValue(key,value);
      }
      
      public function flagsGetAlliancesWelcomeId() : int
      {
         var returnValue:int = -1;
         var key:String = "alliancesWelcomeId";
         if(this.mFlags[key] != null)
         {
            returnValue = int(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsSetAlliancesWelcomeId(id:int) : void
      {
         this.flagsSetValue("alliancesWelcomeId",id);
      }
      
      public function flagsSetAllianceFirstWar(id:int) : void
      {
         this.flagsSetValue("alliancesFirstWar",id);
      }
      
      public function flagsGetAllianceFirstWarDone() : int
      {
         var returnValue:int = -1;
         var key:String = "alliancesFirstWar";
         if(this.mFlags[key] != null)
         {
            returnValue = int(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsGetAlliancesGroupsWelcomePopup() : int
      {
         var returnValue:int = 0;
         var key:String = "alliancesGroupsWelcomePopup";
         if(this.mFlags[key] != null)
         {
            returnValue = int(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsSetAlliancesGroupsWelcomePopup(id:int) : void
      {
         this.flagsSetValue("alliancesGroupsWelcomePopup",id);
      }
      
      public function flagsGetInvestmentsWelcomeId() : int
      {
         var returnValue:int = -1;
         var key:String = "investmentsWelcomeId";
         if(this.mFlags[key] != null)
         {
            returnValue = int(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsSetInvestmentsWelcomeId(id:int) : void
      {
         this.flagsSetValue("investmentsWelcomeId",id);
      }
      
      public function flagsGetBlackHoleIntroPopupWasShown() : Boolean
      {
         var returnValue:Boolean = false;
         var key:String = "blackHoleIntroPopup";
         if(this.mFlags[key] != null)
         {
            returnValue = DCUtils.stringToBoolean(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsSetBlackHoleIntroPopup(id:int) : void
      {
         this.flagsSetValue("blackHoleIntroPopup",id);
      }
      
      public function flagsGetBlackHoleBattleWonPopupWasShown() : Boolean
      {
         var returnValue:Boolean = false;
         var key:String = "blackHoleBattleWonPopup";
         if(this.mFlags[key] != null)
         {
            returnValue = DCUtils.stringToBoolean(this.mFlags[key]);
         }
         return returnValue;
      }
      
      public function flagsSetBlackHoleBattleWonPopup(id:int) : void
      {
         this.flagsSetValue("blackHoleBattleWonPopup",id);
      }
      
      public function flagsGetCurrentWarTimeStarted() : Number
      {
         return this.flagsGetValueAsNumber("alliancesCurrentWarTimeStarted");
      }
      
      public function flagsSetCurrentWarTimeStarted(value:Number) : void
      {
         this.flagsSetValue("alliancesCurrentWarTimeStarted",value);
      }
      
      public function flagsGetCurrentWarEnemyAllianceId() : String
      {
         return this.flagsGetValueAsString("alliancesCurrentWarEnemyId");
      }
      
      public function flagsSetCurrentWarEnemyAllianceId(value:String) : void
      {
         this.flagsSetValue("alliancesCurrentWarEnemyId",value);
      }
      
      public function flagsGetMyAllianceId() : String
      {
         return this.flagsGetValueAsString("alliancesId");
      }
      
      public function flagsSetMyAllianceId(value:String) : void
      {
         this.flagsSetValue("alliancesId",value);
      }
      
      public function flagsGetShopNewSkus() : String
      {
         return this.flagsGetValueAsString("showNewSkus");
      }
      
      public function flagsIsShopNewSku(sku:String) : Boolean
      {
         var value:String = this.flagsGetValueAsString("showNewSkus");
         return value.indexOf(sku) > -1;
      }
      
      public function flagsAddShopNewSku(sku:String) : void
      {
         var value:String = this.flagsGetValueAsString("showNewSkus");
         if(value.indexOf(sku) == -1)
         {
            value += sku + "|";
         }
         this.flagsSetValue("showNewSkus",value);
      }
      
      public function flagsGetBetsShowNewTip() : Boolean
      {
         return this.flagsGetValueAsInt("betsShowNewTip") == 0;
      }
      
      public function flagsSetBetsShowNewTip(value:int) : void
      {
         this.flagsSetValue("betsShowNewTip",value);
      }
      
      public function flagsGetStartNowPopupTimeOver() : Number
      {
         return this.flagsGetValueAsNumber("startNowPopupTimeOver");
      }
      
      public function flagsSetStartNowPopupTimeOver(value:Number) : void
      {
         this.flagsSetValue("startNowPopupTimeOver",value);
      }
      
      public function flagsGetFirstShieldUsed() : Boolean
      {
         return this.flagsGetValueAsInt("firstShieldUsed") == 1;
      }
      
      public function flagsSetFirstShieldUsed(value:Boolean) : void
      {
         var valueInt:int = value ? 1 : 0;
         this.flagsSetValue("firstShieldUsed",valueInt);
      }
      
      public function setSound(value:Boolean) : void
      {
         this.flagsSetValue("sound",value ? "1" : "2");
         if(value)
         {
            SoundManager.getInstance().muteOff();
         }
         else
         {
            SoundManager.getInstance().muteOn();
         }
         var params:Dictionary = new Dictionary();
         params["value"] = value;
         MessageCenter.getInstance().sendMessage("soundSetting",params);
      }
      
      public function getSound() : Boolean
      {
         var result:* = false;
         if(this.flagsGetValue("sound") != null)
         {
            result = this.flagsGetValueAsInt("sound") == 1;
            if(result)
            {
               SoundManager.getInstance().muteOff();
            }
            else
            {
               SoundManager.getInstance().muteOn();
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setSound(true);
         }
         return true;
      }
      
      public function setMusic(value:Boolean) : void
      {
         this.flagsSetValue("music",value ? "1" : "2");
         SoundManager.getInstance().setMusicOn(value);
         var params:Dictionary = new Dictionary();
         params["value"] = value;
         MessageCenter.getInstance().sendMessage("musicSetting",params);
      }
      
      public function getMusic() : Boolean
      {
         var result:* = false;
         if(this.flagsGetValue("music") != null)
         {
            result = this.flagsGetValueAsInt("music") == 1;
            if(result != SoundManager.getInstance().isMusicOn())
            {
               SoundManager.getInstance().setMusicOn(result);
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setMusic(true);
         }
         return true;
      }
      
      public function setSfx(value:Boolean) : void
      {
         this.flagsSetValue("sfx",value ? "1" : "2");
         SoundManager.getInstance().setSfxOn(value);
      }
      
      public function getSfx() : Boolean
      {
         var result:* = false;
         if(this.flagsGetValue("sfx") != null)
         {
            result = this.flagsGetValueAsInt("sfx") == 1;
            if(result != SoundManager.getInstance().isSfxOn())
            {
               SoundManager.getInstance().setSfxOn(result);
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setSfx(true);
         }
         return true;
      }
      
      public function getSoundVolume() : int
      {
         var result:int = 0;
         if(this.flagsGetValue("soundVolume") != null)
         {
            result = this.flagsGetValueAsInt("soundVolume");
            if(result != SoundManager.getInstance().getGeneralVolume())
            {
               SoundManager.getInstance().setGeneralVolume(result / 100);
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setSoundVolume(100);
         }
         return 100;
      }
      
      public function setSoundVolume(value:int) : void
      {
         this.flagsSetValue("soundVolume",value);
         SoundManager.getInstance().setGeneralVolume(value / 100);
      }
      
      public function getMusicVolume() : int
      {
         var result:int = 0;
         if(this.flagsGetValue("musicVolume") != null)
         {
            result = this.flagsGetValueAsInt("musicVolume");
            if(result != SoundManager.getInstance().getMusicVolume())
            {
               SoundManager.getInstance().setMusicVolume(result / 100);
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setMusicVolume(100);
         }
         return 100;
      }
      
      public function setMusicVolume(value:int) : void
      {
         this.flagsSetValue("musicVolume",value);
         SoundManager.getInstance().setMusicVolume(value / 100);
      }
      
      public function getSfxVolume() : int
      {
         var result:int = 0;
         if(this.flagsGetValue("sfxVolume") != null)
         {
            result = this.flagsGetValueAsInt("sfxVolume");
            if(result != SoundManager.getInstance().getSfxVolume())
            {
               SoundManager.getInstance().setSfxVolume(result / 100);
            }
            return result;
         }
         if(this.getIsOwner() && isBuilt())
         {
            this.setSfxVolume(100);
         }
         return 100;
      }
      
      public function setSfxVolume(value:int) : void
      {
         this.flagsSetValue("sfxVolume",value);
         SoundManager.getInstance().setSfxVolume(value / 100);
      }
      
      public function setQuality(value:String) : void
      {
         this.flagsSetValue("quality",value == "high" ? "1" : "0");
         var params:Dictionary = new Dictionary();
         params["value"] = value;
         MessageCenter.getInstance().sendMessage("qualitySetting",params);
      }
      
      public function getQuality() : String
      {
         var result:int = 0;
         var quality:String = "high";
         if(this.flagsGetValue("quality") != null)
         {
            result = this.flagsGetValueAsInt("quality");
            quality = result == 1 ? "high" : "low";
         }
         else
         {
            this.setQuality(quality);
         }
         return quality;
      }
      
      public function getBoolQuality() : Boolean
      {
         var result:int = 0;
         var quality:String = "high";
         if(this.flagsGetValue("quality") != null)
         {
            result = this.flagsGetValueAsInt("quality");
            quality = result == 1 ? "high" : "low";
         }
         return quality == "high";
      }
      
      public function setFlatbed(value:int) : void
      {
         this.flagsSetValue("flatbed",value);
      }
      
      public function toggleFlatbed() : void
      {
         var flatBed:* = this.getFlatbed();
         flatBed = !flatBed;
         this.flagsSetValue("flatbed",flatBed ? 1 : 0);
      }
      
      public function getFlatbed() : Boolean
      {
         return this.flagsGetValueAsInt("flatbed") == 1;
      }
      
      public function setSkin(value:String) : void
      {
         this.flagsSetValue("skin",value);
      }
      
      public function getSkin() : String
      {
         return this.flagsGetValueAsString("skin");
      }
      
      public function setFoundations(value:String) : void
      {
         this.flagsSetValue("foundations",value);
      }
      
      public function getFoundations() : String
      {
         return this.flagsGetValueAsString("foundations");
      }
      
      public function setCivilsColor(value:String, trans:Transaction) : void
      {
         this.flagsSetValue("civilsColor",value,trans);
      }
      
      public function getCivilsColor() : String
      {
         return "";
      }
      
      public function setCivilsPopulation(value:int) : void
      {
         this.flagsSetValue("civilsPopulation",value);
      }
      
      public function getCivilsPopulation() : int
      {
         if(this.flagsGetValue("civilsPopulation") != null)
         {
            return this.flagsGetValueAsInt("civilsPopulation");
         }
         return 2;
      }
      
      public function setHotkeys(value:String) : void
      {
         this.flagsSetValue("hotkeys",value);
      }
      
      public function getHotkeys() : String
      {
         return this.flagsGetValueAsString("hotkeys");
      }
      
      public function setLocale(value:String) : void
      {
         this.flagsSetValue("locale",value);
      }
      
      public function getLocale() : String
      {
         return this.flagsGetValueAsString("locale");
      }
      
      public function setZoom(value:int, doAnim:Boolean = false) : void
      {
         this.flagsSetValue("zoom",value);
         InstanceMng.getGUIController().setZoomFromBarValue(value,doAnim);
      }
      
      public function getZoom(doSet:Boolean = true) : int
      {
         var result:int = 50;
         if(this.flagsGetValue("zoom") != null)
         {
            result = this.flagsGetValueAsInt("zoom");
         }
         else
         {
            this.setZoom(result);
         }
         if(doSet)
         {
            InstanceMng.getGUIController().setZoomFromBarValue(result);
         }
         return result;
      }
      
      public function setFramerateLimit(value:int) : void
      {
         this.flagsSetValue("framerateLimit",value);
      }
      
      public function getFramerateLimit() : int
      {
         var result:int = this.flagsGetValueAsInt("framerateLimit");
         if(result >= 5 && result <= 120)
         {
            return result;
         }
         return 60;
      }
      
      public function setFullscreenResolution(value:String) : void
      {
         this.flagsSetValue("fullscreenResolution",value);
      }
      
      public function getFullscreenResolution() : String
      {
         return this.flagsGetValueAsString("fullscreenResolution");
      }
      
      public function setTextAntiAliasingMode(value:String) : void
      {
         this.flagsSetValue("textAAMode",value);
      }
      
      public function getTextAntiAliasingMode() : String
      {
         var result:String = "advanced";
         if(this.flagsGetValue("textAAMode") != null)
         {
            result = this.flagsGetValueAsString("textAAMode");
         }
         return result;
      }
      
      public function setTextSharpness(value:int) : void
      {
         this.flagsSetValue("textSharpness",value);
      }
      
      public function getTextSharpness() : int
      {
         return this.flagsGetValueAsInt("textSharpness");
      }
      
      public function setTextThickness(value:int) : void
      {
         this.flagsSetValue("textThickness",value);
      }
      
      public function getTextThickness() : int
      {
         return this.flagsGetValueAsInt("textThickness");
      }
      
      public function setStreamerMode(value:int) : void
      {
         this.flagsSetValue("streamerMode",value);
      }
      
      public function toggleStreamerMode() : void
      {
         var streamerMode:* = this.getStreamerMode();
         streamerMode = !streamerMode;
         this.flagsSetValue("streamerMode",streamerMode ? 1 : 0);
      }
      
      public function getStreamerMode() : Boolean
      {
         return this.flagsGetValueAsInt("streamerMode") == 1;
      }
      
      public function setAnimatedBackground(value:int) : void
      {
         this.flagsSetValue("animatedBackground",value);
      }
      
      public function getAnimatedBackground() : Boolean
      {
         if(this.flagsGetValue("animatedBackground") != null)
         {
            return this.flagsGetValueAsInt("animatedBackground") == 1;
         }
         return true;
      }
      
      public function setFullscreen(value:int) : void
      {
         this.flagsSetValue("fullscreen",value);
      }
      
      public function getFullscreen() : Boolean
      {
         return this.flagsGetValueAsInt("fullscreen") == 1;
      }
      
      public function setInvisibleWalls(value:int) : void
      {
         this.flagsSetValue("invisibleWalls",value);
      }
      
      public function getInvisibleWalls() : Boolean
      {
         return this.flagsGetValueAsInt("invisibleWalls") == 1;
      }
      
      public function setInvisibleHangarUnits(value:int) : void
      {
         this.flagsSetValue("invisibleHangarUnits",value);
      }
      
      public function getInvisibleHangarUnits() : Boolean
      {
         return this.flagsGetValueAsInt("invisibleHangarUnits") == 1;
      }
      
      public function setConfirmEndBattle(value:int) : void
      {
         this.flagsSetValue("confirmEndBattle",value);
      }
      
      public function getConfirmEndBattle() : Boolean
      {
         return this.flagsGetValueAsInt("confirmEndBattle") == 1;
      }
      
      public function setParticles(value:int) : void
      {
         this.flagsSetValue("particles",value);
      }
      
      public function getParticles() : int
      {
         var returnValue:int = 2;
         if(this.flagsGetValue("particles") != null)
         {
            returnValue = this.flagsGetValueAsInt("particles");
            if(returnValue == 0)
            {
               returnValue = 1;
            }
            return returnValue;
         }
         return returnValue;
      }
      
      public function setScrollZoomEnabled(value:int) : void
      {
         this.flagsSetValue("scrollZoomEnabled",value);
      }
      
      public function getScrollZoomEnabled() : Boolean
      {
         if(this.flagsGetValue("scrollZoomEnabled") != null)
         {
            return this.flagsGetValueAsInt("scrollZoomEnabled") == 1;
         }
         return true;
      }
      
      public function setScrollZoomInverted(value:int) : void
      {
         this.flagsSetValue("scrollZoomInverted",value);
      }
      
      public function getScrollZoomInverted() : Boolean
      {
         return this.flagsGetValueAsInt("scrollZoomInverted") == 1;
      }
      
      public function getExpendables() : String
      {
         var attribute:String = null;
         var returnValue:String = "";
         if(mPersistenceData != null)
         {
            attribute = "expendables";
            if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
            {
               returnValue = EUtils.xmlReadString(mPersistenceData,attribute);
            }
         }
         return returnValue;
      }
      
      public function misteryGiftsGetAmountOpenedSoFar() : int
      {
         return this.flagsGetValueAsInt("misteryGiftsOpenedSoFar");
      }
      
      public function misteryGiftsAccumOpenedSoFar() : void
      {
         var amount:int = this.misteryGiftsGetAmountOpenedSoFar();
         amount++;
         this.flagsSetValue("misteryGiftsOpenedSoFar",amount);
      }
      
      public function setRefiningSku(value:String) : void
      {
         this.flagsSetValueLocal("__refinerySku",value);
      }
      
      public function getRefiningSku() : String
      {
         return this.flagsGetValueAsString("__refinerySku");
      }
      
      public function setRefiningTime(value:Number) : void
      {
         this.flagsSetValueLocal("__refineryCollectTime",value);
      }
      
      public function getRefiningTime() : Number
      {
         return this.flagsGetValueAsNumber("__refineryCollectTime");
      }
      
      public function setDailyLoginStreak(value:int) : void
      {
         this.mDailyLoginStreak.value = value;
      }
      
      public function getDailyLoginStreak() : int
      {
         return this.mDailyLoginStreak.value;
      }
      
      public function setDailyRewardClaimed(value:Boolean) : void
      {
         this.mDailyLoginRewardClaimed.value = value;
      }
      
      public function getDailyRewardClaimed() : Boolean
      {
         return this.mDailyLoginRewardClaimed.value;
      }
      
      public function setRecentClicks(value:String) : void
      {
         this.flagsSetValue("recentClicks",value);
      }
      
      public function getRecentClicks() : String
      {
         return this.flagsGetValueAsString("recentClicks");
      }
      
      public function setRecentClickConfidence(value:Number) : void
      {
         this.flagsSetValue("recentClickConfidence",value);
      }
      
      public function getRecentClickConfidence() : Number
      {
         return this.flagsGetValueAsNumber("recentClickConfidence");
      }
      
      public function setMaintenanceEnabledTimestamp(value:Number) : void
      {
         this.flagsSetValueLocal("serverMaintenanceTime",value);
      }
      
      public function getMaintenanceEnabledTimestamp() : Number
      {
         return this.flagsGetValueAsNumber("serverMaintenanceTime");
      }
      
      public function getFreeColonyMoves() : int
      {
         return this.mFreeColonyMoves.value;
      }
      
      public function setFreeColonyMoves(value:int) : void
      {
         this.mFreeColonyMoves.value = value;
      }
      
      override public function persistenceGetData() : XML
      {
         var planetXML:XML = null;
         var planet:Planet = null;
         var tutoCompleted:int = 1;
         var role:Role = InstanceMng.getRole();
         if(role.isTutorialCompletedUpdateable())
         {
            tutoCompleted = this.mTutorialCompleted.value ? 1 : 0;
         }
         var levelBasedOnScore:int = 1;
         var xml:XML = <Profile umbrellaEnergy="{Config.useUmbrella() ? InstanceMng.getUmbrellaMng().energyGetTarget() : 0}" umbrellaMaxEnergy="{Config.useUmbrella() ? InstanceMng.getUmbrellaMng().energyGetMax() : 0}" exp="{this.mUserInfoObj.getXp()}" score="{this.getScore()}" levelBasedOnScore="{levelBasedOnScore}" DCCoins="{this.mCoins.value}" DCCash="{this.mCash.value}" DCMinerals="{this.mMinerals.value}" DCPlayerRank="{this.mPlayerRank.value}" DCDroids="{this.mMaxDroids.value}" tutorialCompleted="{tutoCompleted}" damageProtectionTimeLeft="{this.mProtectionTimeLeft.value}" damageProtectionTimeTotal="{this.mProtectionTimeTotal.value}" flags="{this.flagsToString()}" expendables="{InstanceMng.getWorld().expendablesGetPersistenceString()}"/>;
         var userPlanets:Vector.<Planet> = this.mUserInfoObj.getPlanets();
         var XMLPlanets:XML = <Planets/>;
         for each(planet in userPlanets)
         {
            planetXML = <Planet sku="{planet.getSku()}" planetId="{planet.getPlanetId()}" planetType="{planet.getType()}" capital="{!!planet.isCapital() ? 1 : 0}" HQLevel="{planet.getHQLevel()}" starId="{planet.getParentStarId()}" starType="{planet.getParentStarType()}" starName="{planet.getParentStarName()}"/>;
            XMLPlanets.appendChild(planetXML);
         }
         xml.appendChild(XMLPlanets);
         if(Config.useHappenings())
         {
            xml.appendChild(InstanceMng.getHappeningMng().persistenceGetData());
         }
         if(Config.usePowerUps())
         {
            xml.appendChild(InstanceMng.getPowerUpMng().persistenceGetDataOwner());
         }
         return xml;
      }
      
      override public function persistenceSetData(value:XML) : void
      {
         super.persistenceSetData(value);
      }
      
      public function setShowOfferNewPayerPromo(value:Boolean) : void
      {
         this.mShowOfferNewPayerPromo.value = value;
      }
      
      public function getShowOfferNewPayerPromo() : Boolean
      {
         return this.mShowOfferNewPayerPromo.value;
      }
   }
}
