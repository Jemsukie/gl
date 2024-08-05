package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class UnitDefMng extends DCDefMng
   {
      
      public static const TYPE_OFF:int = 3;
       
      
      public function UnitDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath,resourceDefs);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new UnitDef();
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
      
      public function getDefBySkuAndUpgradeId(sku:String, upgradeId:int) : UnitDef
      {
         return getDefBySku(UnitDef.getIdFromSkuAndUpgradeId(sku,upgradeId)) as UnitDef;
      }
   }
}
