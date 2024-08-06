package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class DroidDefMng extends DCDefMng
   {
      
      private static const DROID_ASSET_ID:String = "dr_001_001";
       
      
      private var mCurrentDroidDef:DroidDef;
      
      public function DroidDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 1 && InstanceMng.getAnimationsDefMng().isBuilt())
         {
            buildAdvanceSyncStep();
         }
         super.buildDoSyncStep(step);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new DroidDef();
      }
      
      public function getCurrentDroidDef() : DroidDef
      {
         this.mCurrentDroidDef = null;
         if(this.mCurrentDroidDef == null)
         {
            this.initializeCurrentDroidDef();
         }
         return this.mCurrentDroidDef;
      }
      
      public function upgradeCurrentDroidDef(upgradeId:int = -1) : void
      {
         var nextUpgradeId:int = upgradeId == -1 ? this.mCurrentDroidDef.getUpgradeId() + 1 : upgradeId;
         var nextDroidSku:String = "dr_001_001_" + nextUpgradeId;
         var nextDef:DroidDef = getDefBySku(nextDroidSku) as DroidDef;
         this.mCurrentDroidDef = nextDef;
      }
      
      private function initializeCurrentDroidDef() : void
      {
         if(this.mCurrentDroidDef != null)
         {
            return;
         }
         this.mCurrentDroidDef = getDefBySku("dr_001_001") as DroidDef;
         var amountDroidsBought:int = InstanceMng.getUserInfoMng().getProfileLogin().getMaxDroidsAmount();
         this.upgradeCurrentDroidDef(amountDroidsBought);
      }
      
      public function getMaxAmountDroids() : int
      {
         var upgrade:int = 1;
         var droidSku:String = "dr_001_001_" + upgrade;
         var droidDef:DCDef = getDefBySku(droidSku);
         while(droidDef != null)
         {
            upgrade++;
            droidSku = "dr_001_001_" + upgrade;
            droidDef = getDefBySku(droidSku);
         }
         return upgrade;
      }
   }
}
