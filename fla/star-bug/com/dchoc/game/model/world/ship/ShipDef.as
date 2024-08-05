package com.dchoc.game.model.world.ship
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.ShotPriorityDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ShipDef extends UnitDef
   {
      
      private static const FIELD_CONSTRUCTION_PC:String = "construction";
      
      private static const FIELD_UNLOCK_PC:String = "unlock";
      
      private static const FIELD_COST_PC:String = "cost";
       
      
      private var mSecureConstructionTime:SecureNumber;
      
      private var mConstructionCoins:SecureInt;
      
      private var mConstructionMineral:SecureInt;
      
      private var mExperience:SecureInt;
      
      private var mIcon:String = "";
      
      private var mSize:SecureInt;
      
      private var mAttack:SecureInt;
      
      private var mDefense:SecureInt;
      
      private var mCapacity:SecureInt;
      
      private var mCostTime:SecureNumber;
      
      private var mCostCoins:SecureNumber;
      
      private var mCostMineral:SecureNumber;
      
      public function ShipDef()
      {
         mSecureConstructionTime = new SecureNumber("ShipDef.mSecureConstructionTime");
         mConstructionCoins = new SecureInt("ShipDef.mConstructionCoins");
         mConstructionMineral = new SecureInt("ShipDef.mConstructionMineral");
         mExperience = new SecureInt("ShipDef.mExperience");
         mSize = new SecureInt("ShipDef.mSize");
         mAttack = new SecureInt("ShipDef.mAttack");
         mDefense = new SecureInt("ShipDef.mDefense");
         mCapacity = new SecureInt("ShipDef.mCapacity");
         mCostTime = new SecureNumber("ShipDef.mCostTime");
         mCostCoins = new SecureNumber("ShipDef.mCostCoins");
         mCostMineral = new SecureNumber("ShipDef.mCostMineral");
         super();
         setAnimAngleOffset(-1.5707963267948966);
      }
      
      public function getConstructionTime() : Number
      {
         return this.mSecureConstructionTime.value;
      }
      
      private function setConstructionTime(value:Number) : void
      {
         this.mSecureConstructionTime.value = DCTimerUtil.minToMs(value);
      }
      
      public function getConstructionCoins() : int
      {
         return this.mConstructionCoins.value;
      }
      
      private function setConstructionCoins(value:int) : void
      {
         this.mConstructionCoins.value = value;
      }
      
      public function getConstructionCash() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"construction").mAmount;
      }
      
      public function getConstructionMineral() : int
      {
         return this.mConstructionMineral.value;
      }
      
      private function setConstructionMineral(value:int) : void
      {
         this.mConstructionMineral.value = value;
      }
      
      public function getExperience() : int
      {
         return this.mExperience.value;
      }
      
      private function setExperience(value:int) : void
      {
         this.mExperience.value = value;
      }
      
      public function getUnlockCash() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"unlock").mAmount;
      }
      
      public function getIcon() : String
      {
         return this.mIcon;
      }
      
      private function setIcon(value:String) : void
      {
         this.mIcon = value;
      }
      
      public function getSize() : int
      {
         return this.mSize.value;
      }
      
      private function setSize(value:int) : void
      {
         this.mSize.value = value;
      }
      
      public function getAttack() : int
      {
         return this.mAttack.value;
      }
      
      private function setAttack(value:int) : void
      {
         this.mAttack.value = value;
      }
      
      public function getShield() : int
      {
         return this.mDefense.value;
      }
      
      private function setShield(value:int) : void
      {
         this.mDefense.value = value;
      }
      
      public function getCapacity() : int
      {
         return this.mCapacity.value;
      }
      
      private function setCapacity(value:int) : void
      {
         this.mCapacity.value = value;
      }
      
      public function getSpeed() : Number
      {
         return getMaxSpeed();
      }
      
      public function getCostTime() : Number
      {
         return this.mCostTime.value;
      }
      
      private function setCostTime(value:Number) : void
      {
         this.mCostTime.value = DCTimerUtil.minToMs(value);
      }
      
      public function getCostCoins() : Number
      {
         return this.mCostCoins.value;
      }
      
      private function setCostCoins(value:Number) : void
      {
         this.mCostCoins.value = value;
      }
      
      public function getCostMineral() : Number
      {
         return this.mCostMineral.value;
      }
      
      private function setCostMineral(value:Number) : void
      {
         this.mCostMineral.value = value;
      }
      
      public function getCostCash() : Number
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"cost").mAmount;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "constructionTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "exp";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExperience(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "constructionCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionCoins(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "constructionMineral";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionMineral(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "size";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSize(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "attack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAttack(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shield";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShield(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "capacity";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCapacity(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "costTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCostTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "costCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCostCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "costMineral";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCostMineral(EUtils.xmlReadNumber(info,attribute));
         }
         paidCurrencyRead("construction",info);
         paidCurrencyRead("unlock",info);
         paidCurrencyRead("cost",info);
      }
      
      override public function build() : void
      {
         var val:int = 2;
         switch(mTypeId - 1)
         {
            case 0:
               if(isAnUmbrellaShip())
               {
                  val = 9;
                  break;
               }
               val = 8;
               break;
            case 1:
               val = 6;
               break;
            case 2:
               val = 7;
         }
         setUnitTypeId(val);
         super.build();
      }
      
      public function setValues(shotDamage:Number, maxEnergy:Number, constructionTime:Number, maxSpeed:Number) : void
      {
         this.mSecureConstructionTime.value = constructionTime;
         setShotDamage(shotDamage);
         setMaxEnergy(maxEnergy);
         setMaxSpeed(maxSpeed);
      }
      
      public function getShotPriorityTargetTooltipTid() : int
      {
         var shotPriorityTypeTid:int = 0;
         var shotPriorityDef:ShotPriorityDef = ShotPriorityDef(InstanceMng.getShotPriorityDefMng().getDefBySku(getShotPriorityTarget()));
         if(shotPriorityDef != null)
         {
            shotPriorityTypeTid = shotPriorityDef.getInfoTid();
         }
         return shotPriorityTypeTid;
      }
      
      public function getOwnerShipyardType() : String
      {
         return ShipDefMng.TYPE_SKUS[getTypeId()];
      }
      
      public function getShipyardDef() : WorldItemDef
      {
         var i:int = 0;
         var shipyard:WorldItemDef = null;
         var defs:Vector.<DCDef> = InstanceMng.getWorldItemDefMng().getDefsFromTypeId(3);
         var shipyardsCount:int = int(defs.length);
         var unitShipyardType:String = this.getOwnerShipyardType();
         for(i = 0; i < shipyardsCount; )
         {
            if((shipyard = defs[i] as WorldItemDef) != null)
            {
               if(unitShipyardType == shipyard.getShipsFiles())
               {
                  return shipyard;
               }
            }
            i++;
         }
         return null;
      }
   }
}
