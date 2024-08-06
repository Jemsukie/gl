package com.dchoc.toolkit.utils.animations
{
   public class DCAnimType
   {
       
      
      public var mId:int;
      
      public function DCAnimType(id:int)
      {
         super();
         this.mId = id;
      }
      
      public function unload() : void
      {
      }
      
      public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         return -1;
      }
   }
}
