package com.dchoc.game.model.userdata
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.utils.EUtils;
   
   public class UserInfo extends DCComponent
   {
       
      
      public var mExtId:String = "none";
      
      public var mAccountId:String = "-1";
      
      private var mPlayerName:SecureString;
      
      public var mThumbnailURL:String = null;
      
      public var mIsNeighbor:SecureBoolean;
      
      private var mXp:SecureNumber;
      
      public var mIsOwnerProfile:SecureBoolean;
      
      public var mHasChanged:SecureBoolean;
      
      public var mIsNPC:SecureBoolean;
      
      public var mNpcPhrase:String = "";
      
      public var mDescription:String = "";
      
      public var mMissionSku:String;
      
      public var mHQLevelRequired:String;
      
      public var mWishlistSkus:Array = null;
      
      public var mParentProfile:Profile;
      
      public var mBackgroundType:String = "background_animated";
      
      public var mIsTutorialCompleted:SecureBoolean;
      
      public var mDamageProtectionTimeLeft:SecureNumber;
      
      public var mIsOnline:SecureBoolean;
      
      public var mIsOnlineCooldownTimeLeft:SecureNumber;
      
      public var mPlanetsInfo:XML;
      
      public var mLastOwnerPlanetVisited:String;
      
      public var mLastOwnerStarIdVisited:Number = -1;
      
      public var mLastOwnerStarCoordVisited:DCCoordinate;
      
      public var mLastOwnerStarNameVisited:String;
      
      public var mPlanets:Vector.<Planet>;
      
      private var mHQLevel:SecureInt;
      
      public var mColoniesStarsCoordinates:Vector.<DCCoordinate>;
      
      private var mPlatform:SecureString;
      
      private var mScore:SecureNumber;
      
      private var mScoreExtra:SecureNumber;
      
      private var mCheckHQLevelForSpying:SecureBoolean;
      
      private var mAttackCostPercentage:SecureInt;
      
      private var mInviteAddRequestSent:SecureBoolean;
      
      public var mAttackInfoDateLastAttack:SecureNumber;
      
      public var mAttackInfoAmountAttacks:SecureInt;
      
      public var mAttackHasAttacked:SecureBoolean;
      
      public var mNumBattlesPlayerWon:SecureInt;
      
      public var mNumBattlesPlayerLost:SecureInt;
      
      public function UserInfo()
      {
         mPlayerName = new SecureString("UserInfo.mPlayerName","Name");
         mIsNeighbor = new SecureBoolean("UserInfo.mIsNeighbor");
         mXp = new SecureNumber("UserInfo.mXp");
         mIsOwnerProfile = new SecureBoolean("UserInfo.mIsOwnerProfile");
         mHasChanged = new SecureBoolean("UserInfo.mHasChanged");
         mIsNPC = new SecureBoolean("UserInfo.mIsNPC");
         mIsTutorialCompleted = new SecureBoolean("UserInfo.mIsTutorialCompleted",true);
         mDamageProtectionTimeLeft = new SecureNumber("UserInfo.mDamageProtectionTimeLeft");
         mIsOnline = new SecureBoolean("UserInfo.mIsOnline");
         mIsOnlineCooldownTimeLeft = new SecureNumber("UserInfo.mIsOnlineCooldownTimeLeft");
         mHQLevel = new SecureInt("UserInfo.mHQLevel");
         mPlatform = new SecureString("UserInfo.mPlatform");
         mScore = new SecureNumber("UserInfo.mScore");
         mScoreExtra = new SecureNumber("UserInfo.mScoreExtra");
         mCheckHQLevelForSpying = new SecureBoolean("UserInfo.mCheckHQLevelForSpying");
         mAttackCostPercentage = new SecureInt("UserInfo.mAttackCostPercentage");
         mInviteAddRequestSent = new SecureBoolean("UserInfo.mInviteAddRequestSent");
         mAttackInfoDateLastAttack = new SecureNumber("UserInfo.mAttackInfoDateLastAttack");
         mAttackInfoAmountAttacks = new SecureInt("UserInfo.mAttackInfoAmountAttacks");
         mAttackHasAttacked = new SecureBoolean("UserInfo.mAttackHasAttacked");
         mNumBattlesPlayerWon = new SecureInt("UserInfo.mNumBattlesPlayerWon");
         mNumBattlesPlayerLost = new SecureInt("UserInfo.mNumBattlesPlayerLost");
         super();
      }
      
      public function getPlatform() : String
      {
         return this.mPlatform.value;
      }
      
      public function getExtId() : String
      {
         return this.mExtId;
      }
      
      public function getAccountId() : String
      {
         return this.mAccountId;
      }
      
      public function getPlayerName() : String
      {
         return this.mPlayerName.value;
      }
      
      public function getPlayerFirstName() : String
      {
         var returnValue:String = this.getPlayerName();
         if(returnValue != null)
         {
            returnValue = String(returnValue.split(" ")[0]);
         }
         return returnValue;
      }
      
      public function getThumbnailURL() : String
      {
         return this.mThumbnailURL;
      }
      
      public function isNeighbor() : Boolean
      {
         return this.mIsNeighbor.value;
      }
      
      public function getXp() : Number
      {
         return this.mXp.value;
      }
      
      public function getIsOwnerProfile() : Boolean
      {
         return this.mIsOwnerProfile.value;
      }
      
      public function getParentProfile() : Profile
      {
         return this.mParentProfile;
      }
      
      public function getHasToCheckHQLevelForSpying() : Boolean
      {
         return this.mCheckHQLevelForSpying.value;
      }
      
      public function getAttackCostPercentage() : int
      {
         return this.mAttackCostPercentage.value;
      }
      
      public function isFriendlyNPC() : Boolean
      {
         return this.mIsNPC.value && this.mIsNeighbor.value;
      }
      
      public function getHQLevel() : int
      {
         return this.mHQLevel.value;
      }
      
      public function getHQLevelFromPlanetId(planetId:String) : int
      {
         var length:int = 0;
         var i:int = 0;
         var planet:Planet = null;
         var returnValue:int = -1;
         if(this.mPlanets != null)
         {
            length = int(this.mPlanets.length);
            i = 0;
            while(i < length && returnValue == -1)
            {
               planet = this.mPlanets[i];
               if(planet.getPlanetId() == planetId)
               {
                  returnValue = planet.getHQLevel();
               }
               i++;
            }
         }
         return returnValue;
      }
      
      public function getLevel() : int
      {
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         return ruleMng.getLevelScore(this.getScore());
      }
      
      public function getCapital() : Planet
      {
         var planet:Planet = null;
         if(this.mPlanets == null)
         {
            this.buildPlanetsInfo();
         }
         for each(planet in this.mPlanets)
         {
            if(planet.isCapital())
            {
               return planet;
            }
         }
         return planet;
      }
      
      public function getPlanetById(planetId:String) : Planet
      {
         var p:Planet = null;
         if(this.mPlanets == null)
         {
            this.buildPlanetsInfo();
         }
         for each(p in this.mPlanets)
         {
            if(p.getPlanetId() == planetId)
            {
               return p;
            }
         }
         return null;
      }
      
      public function getCurrentPlanet() : Planet
      {
         return this.getPlanetById(this.getParentProfile().getCurrentPlanetId());
      }
      
      public function getPlanetOrder(planetId:String) : int
      {
         var p:Planet = this.getPlanetById(planetId);
         return p == null || this.mPlanets == null ? 0 : int(this.mPlanets.indexOf(p));
      }
      
      public function getPlanetsAmount() : int
      {
         if(this.mPlanets == null)
         {
            this.buildPlanetsInfo();
         }
         if(this.mPlanets)
         {
            return this.mPlanets.length;
         }
         return 0;
      }
      
      public function getColoniesAmount() : int
      {
         return this.getPlanetsAmount() - 1;
      }
      
      public function getPlanets() : Vector.<Planet>
      {
         return this.mPlanets;
      }
      
      public function getLastOwnerPlanetIdVisited() : String
      {
         if(this.mLastOwnerPlanetVisited == null)
         {
            return this.getCapital().getPlanetId();
         }
         return this.mLastOwnerPlanetVisited;
      }
      
      public function getLastOwnerStarIdVisited() : Number
      {
         if(this.mLastOwnerStarIdVisited == -1)
         {
            return this.getCapital().getParentStarId();
         }
         return this.mLastOwnerStarIdVisited;
      }
      
      public function getLastOwnerStarCoordVisited() : DCCoordinate
      {
         if(this.mLastOwnerStarCoordVisited == null)
         {
            return this.getCapital().getParentStarCoords();
         }
         return this.mLastOwnerStarCoordVisited;
      }
      
      public function getLastOwnerStarNameVisited() : String
      {
         if(this.mLastOwnerStarNameVisited == null)
         {
            return this.getCapital().getParentStarName();
         }
         return this.mLastOwnerStarNameVisited;
      }
      
      public function getPlanetClosestTo(planetSku:String) : Planet
      {
         var planet:Planet = null;
         var distance:Number = NaN;
         var currentMinDistance:* = 1.7976931348623157e+308;
         var planetPos:* = -1;
         var i:int = 0;
         for each(planet in this.mPlanets)
         {
            distance = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(planetSku,planet.getSku()));
            if(distance < currentMinDistance)
            {
               currentMinDistance = distance;
               planetPos = i;
            }
            i++;
         }
         if(planetPos > -1)
         {
            return this.mPlanets[planetPos];
         }
         return null;
      }
      
      public function hasExtId() : Boolean
      {
         return this.mExtId != null && this.mExtId != "";
      }
      
      public function getScore() : Number
      {
         if(isNaN(this.mScore.value) || isNaN(this.mScoreExtra.value))
         {
            return 0;
         }
         return this.mScore.value + InstanceMng.getRuleMng().getScoreDependingOnRole(this.mScoreExtra.value);
      }
      
      public function setPlatform(platform:String) : void
      {
         this.mPlatform.value = platform;
      }
      
      public function setExtId(extId:String) : void
      {
         this.mExtId = extId;
      }
      
      public function setAccountId(accountID:String) : void
      {
         this.mAccountId = accountID;
      }
      
      public function setPlayerName(name:String) : void
      {
         this.mPlayerName.value = name;
         this.mHasChanged.value = true;
      }
      
      public function setIsTutorialCompleted(tutorialCompleted:Boolean) : void
      {
         this.mIsTutorialCompleted.value = tutorialCompleted;
      }
      
      public function setDamageProtectionLeft(dp:Number) : void
      {
         this.mDamageProtectionTimeLeft.value = dp;
      }
      
      public function setIsOnline(online:Boolean) : void
      {
         this.mIsOnline.value = online;
      }
      
      public function setIsOnlineCooldownTimeLeft(onlineCooldownTimeLeft:Number) : void
      {
         this.mIsOnlineCooldownTimeLeft.value = onlineCooldownTimeLeft;
      }
      
      public function setThumbnailURL(thumbnailURL:String) : void
      {
         if(thumbnailURL == "" || thumbnailURL.indexOf("static.ak.fbcdn.net") > -1)
         {
            thumbnailURL = null;
         }
         this.mThumbnailURL = thumbnailURL;
         this.mHasChanged.value = true;
      }
      
      public function setIsNeighbor(isNeighbor:Boolean) : void
      {
         this.mIsNeighbor.value = isNeighbor;
      }
      
      public function setHasToCheckHQLevelForSpying(value:Boolean) : void
      {
         this.mCheckHQLevelForSpying.value = value;
      }
      
      public function setAttackCostPercentage(value:int) : void
      {
         this.mAttackCostPercentage.value = value;
      }
      
      public function addXp(xp:Number) : void
      {
         this.mXp.value += xp;
         this.mHasChanged.value = true;
      }
      
      public function setHasChanged(value:Boolean) : void
      {
         this.mHasChanged.value = value;
      }
      
      public function getHasChanged() : Boolean
      {
         return this.mHasChanged.value;
      }
      
      public function setIsOwnerProfile(isProfile:Boolean) : void
      {
         this.mIsOwnerProfile.value = isProfile;
      }
      
      public function setParentProfile(value:Profile) : void
      {
         this.mParentProfile = value;
      }
      
      public function setWishlist(value:String) : void
      {
         var i:int = 0;
         this.mWishlistSkus = value.split(",");
         for(i = this.mWishlistSkus.length - 1; i >= 0; )
         {
            if(this.mWishlistSkus[i] == "")
            {
               this.mWishlistSkus.splice(i,1);
            }
            i--;
         }
      }
      
      public function getWishlistSkus() : Array
      {
         return this.mWishlistSkus;
      }
      
      public function setPlanetsInfo(planets:XML) : void
      {
         this.mPlanetsInfo = planets;
         this.buildPlanetsInfo();
         var capital:Planet = this.getCapital();
         if(capital != null)
         {
            this.setHQLevel(String(capital.getHQLevel()));
         }
      }
      
      public function setLastOwnerPlanetVisited(planetId:String) : void
      {
         if(planetId != null)
         {
            this.mLastOwnerPlanetVisited = planetId;
         }
      }
      
      public function setLastOwnerStarInfoVisited(starId:Number, starCoord:DCCoordinate, starName:String) : void
      {
         if(starId != -1)
         {
            this.mLastOwnerStarIdVisited = starId;
         }
         if(starCoord != null)
         {
            this.mLastOwnerStarCoordVisited = starCoord;
         }
         if(starName != "")
         {
            this.mLastOwnerStarNameVisited = starName;
         }
      }
      
      public function setHQLevel(value:String) : void
      {
         this.mHQLevel.value = int(value);
      }
      
      public function setScore(value:Number) : void
      {
         this.mScore.value = value;
         this.mScoreExtra.value = 0;
         this.mHasChanged.value = true;
      }
      
      public function addScore(value:Number) : void
      {
         this.mScoreExtra.value += value;
         this.mHasChanged.value = true;
      }
      
      public function buildPlanetsInfo(resetPlanets:Boolean = true) : Vector.<Planet>
      {
         var planetInfo:XML = null;
         var planet:Planet = null;
         var isCapital:Boolean = false;
         var colonyIdx:int = 0;
         var hqLevel:int = 0;
         var planets:Vector.<Planet> = new Vector.<Planet>(0);
         var index:int = 0;
         if(this.mPlanetsInfo != null)
         {
            colonyIdx = 0;
            for each(planetInfo in EUtils.xmlGetChildrenList(this.mPlanetsInfo,"Planet"))
            {
               isCapital = EUtils.xmlReadBoolean(planetInfo,"capital");
               planet = new Planet();
               hqLevel = int(EUtils.xmlIsAttribute(planetInfo,"HQLevel") ? EUtils.xmlReadInt(planetInfo,"HQLevel") : 1);
               planet.setHQLevel(hqLevel);
               planet.setIsCapital(isCapital);
               planet.setParentStarName(EUtils.xmlReadString(planetInfo,"starName"));
               planet.setParentStarType(EUtils.xmlReadInt(planetInfo,"starType"));
               planet.setParentStarId(EUtils.xmlReadNumber(planetInfo,"starId"));
               planet.setAccIdOwner(this.mAccountId);
               planet.setSku(EUtils.xmlReadString(planetInfo,"sku"));
               planet.setPlanetId(EUtils.xmlReadString(planetInfo,"planetId"));
               planet.setColonyIdx(colonyIdx++);
               planet.setReserved(EUtils.xmlReadBoolean(planetInfo,"reserved"));
               planet.setNotBuilt(EUtils.xmlReadBoolean(planetInfo,"notBuilt"));
               planet.setName(planet.getStringId());
               planets.push(planet);
            }
            if(resetPlanets == true)
            {
               this.mPlanets = null;
            }
            if(this.mPlanets == null)
            {
               this.mPlanets = new Vector.<Planet>(0);
               this.mPlanets = planets;
            }
         }
         return planets;
      }
      
      public function addColonyBought(planetId:String, sku:String, hqLevel:int) : Planet
      {
         if(this.mPlanets == null)
         {
            this.mPlanets = new Vector.<Planet>(0);
         }
         var colonyIdx:int = int(this.mPlanets.length);
         var planet:Planet;
         (planet = new Planet()).setSku(sku);
         planet.setPlanetId(planetId);
         planet.setHQLevel(hqLevel);
         planet.setAccIdOwner(this.mAccountId);
         planet.setColonyIdx(colonyIdx);
         planet.setName(planet.getStringId());
         this.mPlanets.push(planet);
         return planet;
      }
      
      public function updateColonyMoved(planetId:String, sku:String) : Planet
      {
         var planet:Planet = null;
         var planetIdx:int = parseInt(planetId) - 1;
         if(this.mPlanets.length > planetIdx)
         {
            (planet = this.mPlanets[planetIdx]).setSku(sku);
            return planet;
         }
         return null;
      }
      
      public function checkIfPlanetBelongsToUser(planetId:String) : Boolean
      {
         var returnValue:Boolean = false;
         var planet:Planet = null;
         if(this.mPlanets == null)
         {
            this.buildPlanetsInfo();
         }
         for each(planet in this.mPlanets)
         {
            if(planet.getPlanetId() == planetId)
            {
               return true;
            }
         }
         return returnValue;
      }
      
      public function getUserColoniesStarsCoords() : Vector.<DCCoordinate>
      {
         var planet:Planet = null;
         if(this.mColoniesStarsCoordinates == null)
         {
            this.mColoniesStarsCoordinates = new Vector.<DCCoordinate>(0);
            if(this.mPlanets != null)
            {
               for each(planet in this.mPlanets)
               {
                  this.mColoniesStarsCoordinates.push(planet.getParentStarCoords());
               }
            }
         }
         return this.mColoniesStarsCoordinates;
      }
      
      public function checkIfStarHoldsAnyUserPlanet(starCoord:DCCoordinate) : Boolean
      {
         var coord:DCCoordinate = null;
         var returnValue:Boolean = false;
         if(this.mColoniesStarsCoordinates == null)
         {
            this.getUserColoniesStarsCoords();
         }
         for each(coord in this.mColoniesStarsCoordinates)
         {
            if(coord != null)
            {
               if(coord.x == starCoord.x && coord.y == starCoord.y)
               {
                  return true;
               }
            }
         }
         return returnValue;
      }
      
      public function attackReset() : void
      {
         this.mAttackHasAttacked.value = false;
         this.mAttackInfoDateLastAttack.value = 0;
      }
      
      public function attackAddAttack(dateTime:Number) : void
      {
         this.mAttackHasAttacked.value = true;
         this.mAttackInfoDateLastAttack.value = dateTime;
         this.mAttackInfoAmountAttacks.value++;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var e:Object = null;
         super.logicUpdateDo(dt);
         if(this.mHasChanged.value == true && this.mParentProfile != null)
         {
            e = {
               "cmd":"EventProfileHasChanged",
               "target":this.getParentProfile()
            };
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),e,true);
            this.mHasChanged.value = false;
         }
      }
      
      public function logicUpdateDamageProtectionTime(dt:int) : void
      {
         if(this.mDamageProtectionTimeLeft.value > 0)
         {
            this.mDamageProtectionTimeLeft.value = Math.max(0,this.mDamageProtectionTimeLeft.value - dt);
         }
      }
      
      public function logicUpdateOnlineTime(dt:int) : void
      {
         if(this.mIsOnline.value)
         {
            this.mIsOnlineCooldownTimeLeft.value = Math.max(0,this.mIsOnlineCooldownTimeLeft.value - dt);
            this.mIsOnline.value = this.mIsOnlineCooldownTimeLeft.value > 0;
         }
      }
      
      public function setInviteRequestSent() : void
      {
         this.mInviteAddRequestSent.value = true;
      }
      
      public function getIsInviteRequestSent() : Boolean
      {
         return this.mInviteAddRequestSent.value;
      }
   }
}
