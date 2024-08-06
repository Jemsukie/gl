package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class ShotPriorityDefMng extends DCDefMng
   {
       
      
      public function ShotPriorityDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new ShotPriorityDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
