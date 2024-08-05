package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class InvestsSettingsDefMng extends DCDefMng
   {
       
      
      private var mInvestsSettingsDef:InvestsSettingsDef;
      
      public function InvestsSettingsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mInvestsSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.mInvestsSettingsDef = InvestsSettingsDef(getDefBySku("1"));
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new InvestsSettingsDef();
      }
      
      public function getLevelGoal() : int
      {
         return InvestsSettingsDef != null ? this.mInvestsSettingsDef.getLevelGoal() : 0;
      }
      
      public function getGoalTime() : Number
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getGoalTime() : 0;
      }
      
      public function getRemindTime() : Number
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getRemindTime() : 0;
      }
      
      public function getHurryUpTime() : Number
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getHurryUpTime() : 0;
      }
      
      public function getExtraCash() : int
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getExtraCash() : 0;
      }
      
      public function getUnlockMissionSku() : String
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getUnlockMissionSku() : "";
      }
      
      public function getRefreshInfoTime() : Number
      {
         return this.mInvestsSettingsDef != null ? this.mInvestsSettingsDef.getRefreshInfoTime() : 0;
      }
   }
}
