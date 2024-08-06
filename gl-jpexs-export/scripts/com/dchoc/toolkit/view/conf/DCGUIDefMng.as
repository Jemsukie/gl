package com.dchoc.toolkit.view.conf
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class DCGUIDefMng extends DCDefMng
   {
       
      
      public function DCGUIDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new DCGUIDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var guiDefObj:DCGUIDef = null;
         var guiDefVector:Vector.<DCDef> = getDefs();
         for(i = guiDefVector.length - 1; i > 0; )
         {
            guiDefObj = DCGUIDef(guiDefVector[i]);
            i--;
         }
      }
   }
}
