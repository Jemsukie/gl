package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.animations.DCAnimTypePerAttribute;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   
   public class AnimTypeBaseReady extends DCAnimTypePerAttribute
   {
       
      
      public function AnimTypeBaseReady(id:int, impIdStart:int, attributeSku:String)
      {
         super(id,impIdStart,attributeSku);
      }
      
      override public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         var wio:WorldItemObject = WorldItemObject(item);
         var returnValue:int = -1;
         if(wio.mDef.getCanBeRide() && (InstanceMng.getUnitScene().battleIsRunning() || !wio.decorationIsBeingRidden()))
         {
            returnValue = 40;
         }
         if(returnValue == -1)
         {
            returnValue = int(item.viewLayersGetAttribute(layerId,mAttributeSku));
            if(returnValue < WorldItemObject.BROKEN_LAST_LEVEL_ID + 1 && wio.mServerStateId == 0)
            {
               returnValue = 0;
            }
            else if(returnValue == 0)
            {
               returnValue = wio.viewGetAnimImpIdBaseReady();
            }
            else
            {
               returnValue += mImpIdStart - 1;
            }
         }
         return returnValue;
      }
   }
}
