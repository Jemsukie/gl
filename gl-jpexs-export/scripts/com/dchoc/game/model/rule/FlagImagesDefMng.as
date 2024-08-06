package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class FlagImagesDefMng extends DCDefMng
   {
       
      
      public function FlagImagesDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new FlagImagesDef();
      }
      
      public function getDefsByType(type:String) : Vector.<FlagImagesDef>
      {
         var i:int = 0;
         var defs:Vector.<DCDef> = getDefs();
         var defsType:Vector.<FlagImagesDef> = new Vector.<FlagImagesDef>(0);
         var length:int = int(defs.length);
         for(i = 0; i < length; )
         {
            if(FlagImagesDef(defs[i]).getType() == type)
            {
               defsType.push(defs[i] as FlagImagesDef);
            }
            i++;
         }
         return defsType;
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
