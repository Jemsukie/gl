package com.dchoc.game.model.powerups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class PowerUpMng extends DCComponent
   {
      
      public static const MODE_OWNER:int = 0;
      
      public static const MODE_ATTACKER:int = 1;
       
      
      private const FACTION_DEFENDER:int = 1;
      
      private const FACTION_ATTACKER:int = 0;
      
      private const FACTIONS_COUNT:int = 2;
      
      private var mPowerUpsDefsByTypesByFaction:Vector.<Dictionary>;
      
      private var mPowerUpsByFaction:Vector.<Dictionary>;
      
      private var mNeedsToBeUpdatedByFaction:Vector.<Boolean>;
      
      private var mPersistenceOwner:XML;
      
      private var mFactionIdOfTheOwner:int;
      
      private var mWorld:World;
      
      private var mPowerUpDefMng:PowerUpDefMng;
      
      private var mUserDataMng:UserDataMng;
      
      private var mMode:int;
      
      private var mUnitsPowerUpsStr:Vector.<Dictionary>;
      
      private var mUnitsPowerUpsSkus:Vector.<Dictionary>;
      
      public function PowerUpMng()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var i:int = 0;
         if(step == 0)
         {
            if(this.mPowerUpsDefsByTypesByFaction == null)
            {
               this.mPowerUpsDefsByTypesByFaction = new Vector.<Dictionary>(2);
               this.mPowerUpsByFaction = new Vector.<Dictionary>(2);
               for(i = 0; i < 2; )
               {
                  this.mPowerUpsDefsByTypesByFaction[i] = new Dictionary();
                  this.mPowerUpsByFaction[i] = new Dictionary();
                  i++;
               }
            }
            if(this.mNeedsToBeUpdatedByFaction == null)
            {
               this.mNeedsToBeUpdatedByFaction = new Vector.<Boolean>(2);
            }
            this.unitsLoad();
            this.mWorld = InstanceMng.getWorld();
            this.mPowerUpDefMng = InstanceMng.getPowerUpDefMng();
            this.mUserDataMng = InstanceMng.getUserDataMng();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mPowerUpsByFaction = null;
         this.mNeedsToBeUpdatedByFaction = null;
         this.mWorld = null;
         this.mPowerUpDefMng = null;
         this.mUserDataMng = null;
         this.unitsUnload();
      }
      
      public function setPowerUpsUniverse(xml:XML) : void
      {
         var roleId:int = InstanceMng.getRole().mId;
         switch(roleId)
         {
            case 0:
               this.setPowerUpsFromXML(null,0,true);
               this.setPowerUpsFromXML(xml,1,true);
               this.mPersistenceOwner = this.persistenceGetDataByFaction(1,true);
               this.mFactionIdOfTheOwner = 1;
               this.modeSetMode(0);
               break;
            default:
               this.setPowerUpsFromXML(xml,1,true);
               this.setPowerUpsFromXML(this.mPersistenceOwner,0,true);
               this.mFactionIdOfTheOwner = 0;
               this.modeSetMode(1);
         }
      }
      
      private function setPowerUpsFromXML(xml:XML, faction:int, clear:Boolean) : void
      {
         var k:* = null;
         var powerUpXML:XML = null;
         if(clear)
         {
            for(k in this.mPowerUpsByFaction[faction])
            {
               delete this.mPowerUpsByFaction[faction][k];
            }
            for(k in this.mPowerUpsDefsByTypesByFaction[faction])
            {
               delete this.mPowerUpsDefsByTypesByFaction[faction][k];
            }
            this.unitsClear();
         }
         if(xml != null)
         {
            for each(powerUpXML in EUtils.xmlGetChildrenList(xml,"PowerUp"))
            {
               this.setPowerUpFromXML(powerUpXML,faction);
            }
         }
      }
      
      private function setPowerUpFromXML(xml:XML, faction:int) : void
      {
         var defsByTypes:Dictionary = null;
         var type:String = null;
         var defTypeActive:PowerUpDef = null;
         var timeLeft:Number = NaN;
         var timeOver:Number = NaN;
         var serverCurrentMillis:Number = NaN;
         var powerUp:PowerUp = null;
         var dictionary:Dictionary = this.mPowerUpsByFaction[faction];
         var sku:String = EUtils.xmlReadString(xml,"sku");
         var def:PowerUpDef;
         if((def = this.mPowerUpDefMng.getDefBySku(sku) as PowerUpDef) == null)
         {
            return;
         }
         defsByTypes = this.mPowerUpsDefsByTypesByFaction[faction];
         type = def.getType();
         if((defTypeActive = defsByTypes[type]) == null)
         {
            serverCurrentMillis = this.mUserDataMng.getServerCurrentTimemillis();
            if(EUtils.xmlIsAttribute(xml,"timeLeft"))
            {
               timeLeft = EUtils.xmlReadNumber(xml,"timeLeft");
               timeOver = serverCurrentMillis + timeLeft;
            }
            else
            {
               timeLeft = EUtils.xmlReadNumber(xml,"timeOver");
               timeLeft = timeOver - serverCurrentMillis;
            }
            if(timeLeft > 0)
            {
               powerUp = dictionary[sku];
               if(powerUp == null)
               {
                  powerUp = new PowerUp();
               }
               powerUp.build(def,timeOver,timeLeft);
               dictionary[sku] = powerUp;
               defsByTypes[type] = def;
            }
         }
         else
         {
            DCDebug.traceCh("ERROR"," PowerUpMng.setPowerUpFromXML(): There\'s another power up with sku <" + defTypeActive.mSku + "> already active so this sku <" + sku + "> has been ignored.");
         }
      }
      
      private function needsToCheckTime() : Boolean
      {
         return !InstanceMng.getUnitScene().battleIsRunning();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var i:int = 0;
         var dictionary:Dictionary = null;
         var powerUp:PowerUp = null;
         var k:* = null;
         var timeOver:Number = NaN;
         var currentTime:Number = NaN;
         var checkTime:Boolean = false;
         var state:int = 0;
         var newState:int = 0;
         var sku:String = null;
         var type:String = null;
         var defsByTypes:Dictionary = null;
         var powerUpDef:PowerUpDef = null;
         var defTypeActive:PowerUpDef = null;
         var checkTimeIsAllowed:Boolean = false;
         if(this.mPowerUpsByFaction != null)
         {
            currentTime = this.mUserDataMng.getServerCurrentTimemillis();
            checkTimeIsAllowed = this.needsToCheckTime();
            for(i = 0; i < 2; )
            {
               dictionary = this.mPowerUpsByFaction[i];
               checkTime = checkTimeIsAllowed && this.mNeedsToBeUpdatedByFaction[i];
               for(k in dictionary)
               {
                  sku = k;
                  powerUp = PowerUp(dictionary[k]);
                  if(powerUp != null)
                  {
                     powerUpDef = powerUp.getDef();
                     state = powerUp.getState();
                     newState = powerUp.logicUpdate(currentTime,checkTime);
                     if(state != newState)
                     {
                        switch(newState - 1)
                        {
                           case 0:
                              this.notifyPowerUpSwitch(i,powerUp.getDef(),true);
                              break;
                           case 1:
                              if(powerUpDef != null)
                              {
                                 defsByTypes = this.mPowerUpsDefsByTypesByFaction[i];
                                 type = powerUpDef.getType();
                                 if((defTypeActive = defsByTypes[type]) != null && defTypeActive.getType() == type)
                                 {
                                    defsByTypes[type] = null;
                                 }
                                 this.notifyPowerUpSwitch(i,powerUpDef,false);
                                 break;
                              }
                        }
                     }
                     if(newState == 2)
                     {
                        dictionary[k] = null;
                     }
                  }
               }
               i++;
            }
         }
      }
      
      private function notifyPowerUpSwitch(faction:int, def:PowerUpDef, pOn:Boolean) : void
      {
         if(faction == 1)
         {
            if(def.getTarget() == "items")
            {
               if(InstanceMng.getApplication().viewGetMode() == 0)
               {
                  this.mWorld.notifyEventToItems({
                     "cmd":"WIOEventPowerUpSwitch",
                     "powerUpSku":def.mSku,
                     "group":def.getSubtarget(),
                     "on":pOn
                  });
               }
            }
         }
      }
      
      public function powerUpActivate(sku:String) : void
      {
         var str:* = null;
         var xml:XML = null;
         var faction:int = this.mFactionIdOfTheOwner;
         var powerUpDef:PowerUpDef;
         if((powerUpDef = InstanceMng.getPowerUpDefMng().getDefBySku(sku) as PowerUpDef) != null)
         {
            str = "<PowerUp sku=\"" + sku + "\" timeLeft=\"" + powerUpDef.getDuration() + "\"/>";
            xml = EUtils.stringToXML(str);
            this.setPowerUpFromXML(xml,faction);
            this.mPersistenceOwner = this.persistenceGetDataByFaction(faction,true);
         }
      }
      
      private function modeSetMode(value:int) : void
      {
         this.mMode = value;
         switch(this.mMode)
         {
            case 0:
               this.mNeedsToBeUpdatedByFaction[1] = true;
               this.mNeedsToBeUpdatedByFaction[0] = false;
               break;
            case 1:
               this.mNeedsToBeUpdatedByFaction[1] = false;
               this.mNeedsToBeUpdatedByFaction[0] = false;
         }
      }
      
      public function persistenceGetDataOwner() : XML
      {
         return this.persistenceGetDataByFaction(this.mFactionIdOfTheOwner,false);
      }
      
      public function persistenceGetDataByFaction(faction:int, useTimeOver:Boolean) : XML
      {
         var k:* = null;
         var sku:String = null;
         var powerUp:PowerUp = null;
         var powerUpStr:* = null;
         var time:Number = NaN;
         var dictionary:Dictionary = this.mPowerUpsByFaction[faction];
         var returnValue:XML = EUtils.stringToXML("<PowerUps/>");
         var currentTime:Number = this.mUserDataMng.getServerCurrentTimemillis();
         for(k in dictionary)
         {
            sku = k;
            powerUp = PowerUp(dictionary[k]);
            if(powerUp != null)
            {
               if(useTimeOver)
               {
                  powerUpStr = "<PowerUp sku=\"" + sku + "\" timeOver=\"" + powerUp.getTimeOver() + "\"/>";
               }
               else
               {
                  if((time = powerUp.getTimeOver() - currentTime) < 0)
                  {
                     time = 1;
                  }
                  powerUpStr = "<PowerUp sku=\"" + sku + "\" timeLeft=\"" + time + "\"/>";
               }
               returnValue.appendChild(EUtils.stringToXML(powerUpStr));
            }
         }
         return returnValue;
      }
      
      private function getPowerUp(sku:String, factionId:int = -1) : PowerUp
      {
         if(factionId == -1)
         {
            factionId = this.mFactionIdOfTheOwner;
         }
         var dictionary:Dictionary = this.mPowerUpsByFaction[factionId];
         var returnValue:PowerUp = null;
         if(dictionary != null)
         {
            returnValue = dictionary[sku];
         }
         return returnValue;
      }
      
      public function isPowerUpActive(sku:String, factionId:int = -1) : Boolean
      {
         return this.getPowerUpTimeLeft(sku,factionId) > 0;
      }
      
      public function getPowerUpTimeLeft(sku:String, factionId:int = -1) : Number
      {
         if(factionId == -1)
         {
            factionId = this.mFactionIdOfTheOwner;
         }
         var returnValue:Number = 0;
         var powerUp:PowerUp = this.getPowerUp(sku,factionId);
         if(powerUp != null)
         {
            if(this.needsToCheckTime() && this.mNeedsToBeUpdatedByFaction[factionId])
            {
               returnValue = powerUp.getTimeOver() - this.mUserDataMng.getServerCurrentTimemillis();
            }
            else
            {
               returnValue = powerUp.getTimeLeftOrig();
            }
         }
         if(returnValue < 0)
         {
            returnValue = 0;
         }
         return returnValue;
      }
      
      public function getPowerUpsActiveAsStr(factionId:int = -1) : String
      {
         var i:int = 0;
         var k:* = null;
         var sku:String = null;
         var returnValue:String = "";
         if(factionId == -1)
         {
            factionId = this.mFactionIdOfTheOwner;
         }
         var dictionary:Dictionary = this.mPowerUpsByFaction[factionId];
         for(k in dictionary)
         {
            sku = k;
            if(this.isPowerUpActive(sku,factionId))
            {
               returnValue += sku + ",";
            }
         }
         return returnValue;
      }
      
      public function isAnyPowerUpActive(factionId:int = -1) : Boolean
      {
         return this.getPowerUpsActiveAsStr(factionId) != "";
      }
      
      public function isPowerUpSkuTheOneInItsTypeOn(sku:String, factionId:int) : Boolean
      {
         var type:String = null;
         var defActive:PowerUpDef = null;
         var returnValue:* = false;
         var def:PowerUpDef;
         if((def = this.mPowerUpDefMng.getDefBySku(sku) as PowerUpDef) != null)
         {
            type = def.getType();
            if(this.mPowerUpsDefsByTypesByFaction[factionId] != null)
            {
               if((defActive = this.mPowerUpsDefsByTypesByFaction[factionId][type]) != null)
               {
                  returnValue = defActive.mSku == sku;
               }
            }
         }
         return returnValue;
      }
      
      public function getPowerUpDefByType(type:String, factionId:int) : PowerUpDef
      {
         return this.mPowerUpsDefsByTypesByFaction[factionId][type];
      }
      
      private function unitsLoad() : void
      {
         this.mUnitsPowerUpsStr = new Vector.<Dictionary>(0);
         this.mUnitsPowerUpsSkus = new Vector.<Dictionary>(0);
      }
      
      private function unitsUnload() : void
      {
         this.mUnitsPowerUpsStr = null;
         this.mUnitsPowerUpsSkus = null;
      }
      
      private function unitsClear() : void
      {
         var i:int = 0;
         for(i = 0; i < 2; )
         {
            this.mUnitsPowerUpsStr[i] = null;
            this.mUnitsPowerUpsSkus[i] = null;
            i++;
         }
      }
      
      public function unitsGetPowerUpDefByType(unitSku:String, type:String, factionId:int) : PowerUpDef
      {
         var returnValue:PowerUpDef;
         if((returnValue = this.getPowerUpDefByType(type,factionId)) != null)
         {
            if(!this.unitsIsPowerUpActivate(unitSku,returnValue.mSku,factionId))
            {
               returnValue = null;
            }
         }
         return returnValue;
      }
      
      public function unitsRegisterPowerUpSku(unitSku:String, powerUpSku:String, factionId:int, on:Boolean) : void
      {
         var str:String = null;
         var dictionary:Dictionary = null;
         var powerUpDef:PowerUpDef;
         if((powerUpDef = this.mPowerUpDefMng.getDefBySku(powerUpSku) as PowerUpDef) == null)
         {
            DCDebug.traceCh("ERROR"," PowerUpMng.unitsRegisterPowerUpSku() there\'s no a definition for sku : " + powerUpSku);
            return;
         }
         if(this.mUnitsPowerUpsStr[factionId] == null)
         {
            this.mUnitsPowerUpsStr[factionId] = new Dictionary();
            this.mUnitsPowerUpsSkus[factionId] = new Dictionary();
         }
         if(on)
         {
            if(this.mPowerUpsDefsByTypesByFaction[factionId][powerUpDef.getType()] == null)
            {
               this.mPowerUpsDefsByTypesByFaction[factionId][powerUpDef.getType()] = powerUpDef;
            }
            if(this.mUnitsPowerUpsSkus[factionId][unitSku] == null)
            {
               this.mUnitsPowerUpsSkus[factionId][unitSku] = new Dictionary();
            }
            if(this.mUnitsPowerUpsStr[factionId][unitSku] == null)
            {
               this.mUnitsPowerUpsStr[factionId][unitSku] = powerUpSku + ",";
            }
            else if((str = String(this.mUnitsPowerUpsStr[factionId][unitSku])).indexOf(powerUpSku) == -1)
            {
               this.mUnitsPowerUpsStr[factionId][unitSku] += powerUpSku + ",";
            }
         }
         else if(this.mUnitsPowerUpsStr[factionId][unitSku] != null)
         {
            if((str = String(this.mUnitsPowerUpsStr[factionId][unitSku])).indexOf(powerUpSku) > -1)
            {
               this.mUnitsPowerUpsStr[factionId][unitSku] = str.replace(powerUpSku + ",","");
            }
         }
         if((dictionary = this.mUnitsPowerUpsSkus[factionId][unitSku]) != null)
         {
            this.mUnitsPowerUpsSkus[factionId][unitSku][powerUpSku] = on;
         }
      }
      
      public function unitsIsPowerUpActivate(unitSku:String, powerUpSku:String, factionId:int) : Boolean
      {
         var dictionary:Dictionary = null;
         var returnValue:Boolean = false;
         if(this.mUnitsPowerUpsSkus[factionId] != null)
         {
            returnValue = (dictionary = this.mUnitsPowerUpsSkus[factionId][unitSku]) == null || dictionary[powerUpSku] == null ? false : Boolean(dictionary[powerUpSku]);
         }
         return returnValue;
      }
      
      public function unitsGetPowerUpSkusActiveByUnitSku(unitSku:String, factionId:int) : String
      {
         var returnValue:String = null;
         if(this.mUnitsPowerUpsStr[factionId] != null)
         {
            returnValue = String(this.mUnitsPowerUpsStr[factionId][unitSku]);
         }
         return returnValue;
      }
      
      public function unitsIsAnyPowerUpActiveByUnitSku(unitSku:String, factionId:int) : Boolean
      {
         var powerUpSkus:String = this.unitsGetPowerUpSkusActiveByUnitSku(unitSku,factionId);
         return powerUpSkus != null && powerUpSkus != "";
      }
      
      public function unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(unitSku:String, factionId:int, powerupType:String, amount:Number) : Number
      {
         var powerUpDef:PowerUpDef = null;
         if(this.unitsIsAnyPowerUpActiveByUnitSku(unitSku,factionId))
         {
            if(powerUpDef = InstanceMng.getPowerUpMng().unitsGetPowerUpDefByType(unitSku,powerupType,factionId))
            {
               return powerUpDef.getValueWithExtra(amount);
            }
         }
         return amount;
      }
      
      public function unitsGetActivePowerUpTypeByUnitSku(unitSku:String, factionId:int) : String
      {
         var powerUpDef:PowerUpDef = null;
         for each(var powerupType in PowerUpDefMng.POWER_UP_TYPES)
         {
            if((powerUpDef = InstanceMng.getPowerUpMng().unitsGetPowerUpDefByType(unitSku,powerupType,factionId)) != null)
            {
               return powerUpDef.getType();
            }
         }
         return "";
      }
      
      public function getEffectTypeFromPowerUpType(powerupType:String) : int
      {
         var effectType:int = 0;
         switch(powerupType)
         {
            case "turretsExtraDamage":
               effectType = 1;
               break;
            case "turretsExtraHealth":
               effectType = 3;
               break;
            case "turretsExtraRange":
               effectType = 0;
               break;
            default:
               effectType = 0;
         }
         return effectType;
      }
   }
}
