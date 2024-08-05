package com.dchoc.toolkit.view.map
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class DCMapViewDefMng extends DCDefMng
   {
       
      
      public function DCMapViewDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new DCMapViewDef();
      }
   }
}
