package com.dchoc.game.model.gameunit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.upgrade.EPopupUpgrade;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class GameUnit
   {
      
      private static var smGameUnitMng:GameUnitMng;
       
      
      public var mDef:ShipDef;
      
      private var mSecureSku:SecureString;
      
      private var mSecureTimeLeft:SecureNumber;
      
      private var mSecureIsUnlocked:SecureBoolean;
      
      private var mSecurePaused:SecureBoolean;
      
      public function GameUnit(gameUnitMng:GameUnitMng)
      {
         mSecureSku = new SecureString("GameUnit.mSecureSku");
         mSecureTimeLeft = new SecureNumber("GameUnit.mSecureTimeLeft");
         mSecureIsUnlocked = new SecureBoolean("GameUnit.mSecureIsUnlocked");
         mSecurePaused = new SecureBoolean("GameUnit.mSecurePaused");
         super();
         if(smGameUnitMng == null)
         {
            smGameUnitMng = gameUnitMng;
         }
      }
      
      public static function unloadStatic() : void
      {
         smGameUnitMng = null;
      }
      
      public static function createGameUnit(sku:String, def:ShipDef, timeLeft:Number, isUnlocked:Boolean, mng:GameUnitMng) : GameUnit
      {
         var gu:GameUnit;
         (gu = new GameUnit(mng)).setValues(sku,def,timeLeft,isUnlocked);
         return gu;
      }
      
      public function setValues(sku:String, def:ShipDef, timeLeft:Number, isUnlocked:Boolean) : void
      {
         this.mSku = sku;
         this.mDef = def;
         this.mTimeLeft = timeLeft;
         this.mIsUnlocked = isUnlocked;
      }
      
      public function isLocked() : Boolean
      {
         return this.mIsUnlocked == false && this.mTimeLeft == -1;
      }
      
      public function isUnLocking() : Boolean
      {
         return this.mIsUnlocked == false && this.mTimeLeft > -1;
      }
      
      public function isUpgrading() : Boolean
      {
         return this.mIsUnlocked && this.mTimeLeft > -1;
      }
      
      public function set mSku(value:String) : void
      {
         this.mSecureSku.value = value;
      }
      
      public function get mSku() : String
      {
         return this.mSecureSku.value;
      }
      
      public function set mTimeLeft(value:Number) : void
      {
         this.mSecureTimeLeft.value = value;
      }
      
      public function get mTimeLeft() : Number
      {
         return this.mSecureTimeLeft.value;
      }
      
      public function set mIsUnlocked(value:Boolean) : void
      {
         this.mSecureIsUnlocked.value = value;
      }
      
      public function get mIsUnlocked() : Boolean
      {
         return this.mSecureIsUnlocked.value;
      }
      
      public function set mPaused(value:Boolean) : void
      {
         this.mSecurePaused.value = value;
      }
      
      public function get mPaused() : Boolean
      {
         return this.mSecurePaused.value;
      }
      
      public function upgradeUnit(transaction:Transaction, nextDef:ShipDef) : void
      {
         var levelsUp:int = 0;
         if(this.mIsUnlocked == false)
         {
            this.mIsUnlocked = true;
            InstanceMng.getUserDataMng().updateGameUnits_unlockCompleted(this.mSku,transaction);
            InstanceMng.getTargetMng().updateProgress("unlock",1,this.mSku);
         }
         else
         {
            levelsUp = 1;
            if(nextDef == null)
            {
               this.mDef = this.getNextDef();
            }
            else
            {
               levelsUp = nextDef.getUpgradeId() - this.mDef.getUpgradeId();
               this.mDef = nextDef;
            }
            InstanceMng.getUserDataMng().updateGameUnits_upgradeCompleted(this.mSku,this.mDef.getUpgradeId(),transaction);
            InstanceMng.getTargetMng().updateProgress("upgrade",levelsUp,this.mSku);
         }
         this.mTimeLeft = -1;
      }
      
      public function startUpgrade(transaction:Transaction) : void
      {
         this.mTimeLeft = this.getNextDef().getCostTime();
         smGameUnitMng.addToUpgrading(this);
         if(transaction != null)
         {
            if(this.mIsUnlocked == false)
            {
               InstanceMng.getUserDataMng().updateGameUnits_unlockStart(this.mSku,this.mTimeLeft,transaction);
            }
            else
            {
               InstanceMng.getUserDataMng().updateGameUnits_upgradeStart(this.mSku,this.mDef.getUpgradeId() + 1,this.mTimeLeft,transaction);
            }
         }
      }
      
      public function logicUpdate(dt:Number) : Boolean
      {
         var popup:DCIPopup = null;
         if(this.mTimeLeft == -1)
         {
            return true;
         }
         if(this.mPaused)
         {
            return false;
         }
         this.mTimeLeft -= dt;
         if(this.mTimeLeft <= 0)
         {
            this.mTimeLeft = -1;
            this.upgradeUnit(null,null);
            popup = InstanceMng.getPopupMng().getPopupOpened("PopupUpgrade") as EPopupUpgrade;
            if(popup != null)
            {
               popup.notify({"cmd":"NotifyLoadUnitsSelection"});
            }
            return true;
         }
         return false;
      }
      
      public function getNextDef() : ShipDef
      {
         if(this.mIsUnlocked == false)
         {
            return this.mDef;
         }
         var nextDef:ShipDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(this.mSku,this.mDef.getUpgradeId() + 1);
         return nextDef == null ? this.mDef : nextDef;
      }
      
      public function getMaxDef() : ShipDef
      {
         return InstanceMng.getShipDefMng().getMaxUpgradeDefBySku(this.mSku);
      }
   }
}
