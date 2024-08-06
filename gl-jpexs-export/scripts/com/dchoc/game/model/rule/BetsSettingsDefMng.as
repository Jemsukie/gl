package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class BetsSettingsDefMng extends DCDefMng
   {
       
      
      private var mBetsSettingsDef:BetsSettingsDef;
      
      public function BetsSettingsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mBetsSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.mBetsSettingsDef = BetsSettingsDef(getDefBySku("1"));
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new BetsSettingsDef();
      }
      
      public function getMinimumPlayerLevel() : int
      {
         return this.mBetsSettingsDef != null ? this.mBetsSettingsDef.getMinimumPlayerLevel() : 0;
      }
      
      public function getMinimumHQLevel() : int
      {
         return this.mBetsSettingsDef != null ? this.mBetsSettingsDef.getMinimumHQLevel() : 0;
      }
      
      public function getBetWaitingTimeout() : int
      {
         return this.mBetsSettingsDef != null ? this.mBetsSettingsDef.getBetWaitingTimeout() : 0;
      }
      
      public function getBetSummaryFakeSentencesChangeTime() : int
      {
         return this.mBetsSettingsDef != null ? this.mBetsSettingsDef.getBetSummaryFakeSentencesChangeTime() : 0;
      }
      
      public function getUseBets() : Boolean
      {
         if(this.mBetsSettingsDef != null)
         {
            return this.mBetsSettingsDef.getUseBets();
         }
         return false;
      }
      
      public function getSummaryAnimationResultTime() : int
      {
         return this.mBetsSettingsDef != null ? this.mBetsSettingsDef.getSummaryAnimationResultTime() : 0;
      }
   }
}
