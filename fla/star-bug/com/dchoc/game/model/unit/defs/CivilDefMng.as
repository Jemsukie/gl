package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class CivilDefMng extends DCDefMng
   {
       
      
      public function CivilDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
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
         return new CivilDef();
      }
   }
}
