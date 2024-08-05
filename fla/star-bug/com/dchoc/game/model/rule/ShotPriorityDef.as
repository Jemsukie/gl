package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   
   public class ShotPriorityDef extends DCDef
   {
      
      private static const TID_KEY:String = "INFO";
       
      
      public function ShotPriorityDef()
      {
         super();
      }
      
      public function getInfoTid() : int
      {
         var returnValue:int = 177;
         if(mTidDictionary != null)
         {
            if(mTidDictionary["INFO"] != null)
            {
               if(mTidDictionary["INFO"] != null)
               {
                  returnValue = int(TextIDs[mTidDictionary["INFO"]]);
               }
            }
         }
         return returnValue;
      }
   }
}
