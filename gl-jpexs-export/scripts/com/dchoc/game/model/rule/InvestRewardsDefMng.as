package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class InvestRewardsDefMng extends DCDefMng
   {
       
      
      public function InvestRewardsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new InvestRewardsDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
