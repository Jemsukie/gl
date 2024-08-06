package com.dchoc.game.core.utils.memory
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.memory.DCPoolMng;
   import flash.display.MovieClip;
   
   public class PoolMng extends DCPoolMng
   {
      
      private static const WIDTH:int = 32;
      
      private static const HEIGHT:int = 32;
      
      private static const COLOR:uint = 16777215;
       
      
      public function PoolMng()
      {
         super();
      }
      
      override public function animGet(fileSku:String, animSku:String) : *
      {
         var returnValue:DCDisplayObject = null;
         var tmp:MovieClip = null;
         returnValue = InstanceMng.getResourceMng().getDCDisplayObject(fileSku,animSku);
         if(returnValue == null)
         {
            if(tmp == null)
            {
               tmp = new MovieClip();
               DCUtils.fillRect(tmp.graphics,32 >> 1,-16,32,32,16777215,-1);
            }
            returnValue = new DCDisplayObjectSWF(tmp);
         }
         return returnValue;
      }
   }
}
