package com.dchoc.game.model.contest
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class ContestDefMng extends DCDefMng
   {
      
      public static var EASTER_SKU:String = "easter";
       
      
      public function ContestDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new ContestDef();
      }
   }
}
