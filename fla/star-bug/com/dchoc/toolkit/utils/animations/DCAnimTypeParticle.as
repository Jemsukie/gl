package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.utils.Dictionary;
   
   public class DCAnimTypeParticle extends DCAnimType
   {
       
      
      private var mAttributeSku:String;
      
      private var mImpStartId:int;
      
      private var mCollisionBoxType:uint;
      
      private var mCollisionBoxes:Dictionary;
      
      private var mCollisionBoxesCount:Dictionary;
      
      private var mMinTimeToWaitMS:int;
      
      private var mMaxTimeToWaitMS:int;
      
      private var mTimerIsEnabled:Boolean;
      
      public function DCAnimTypeParticle(id:int, collisionBoxType:uint, impStarId:int, attributeSku:String = null, minTimeToWaitMS:int = 0, maxTimeToWaitMS:int = 0)
      {
         super(id);
         this.mCollisionBoxType = collisionBoxType;
         this.mImpStartId = impStarId;
         this.mAttributeSku = attributeSku;
         this.mMinTimeToWaitMS = minTimeToWaitMS;
         this.mMaxTimeToWaitMS = maxTimeToWaitMS;
         this.mTimerIsEnabled = this.mMinTimeToWaitMS > 0 || this.mMaxTimeToWaitMS > 0;
         this.mCollisionBoxes = new Dictionary(true);
         this.mCollisionBoxesCount = new Dictionary(true);
      }
      
      override public function unload() : void
      {
         super.unload();
         this.mAttributeSku = null;
         this.mCollisionBoxes = null;
         this.mCollisionBoxesCount = null;
      }
      
      override public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         var itemCollisionBoxSku:String = null;
         var currentBoxId:int = 0;
         var anim:DCDisplayObject = null;
         var returnValue:int = -1;
         if(this.mAttributeSku != null)
         {
            itemCollisionBoxSku = item.viewGetCollisionBoxPackageSku();
            if(this.mCollisionBoxes[itemCollisionBoxSku] == null)
            {
               this.mCollisionBoxes[itemCollisionBoxSku] = DCInstanceMng.getInstance().getCollisionBoxMng().getCollisionBoxesByType(itemCollisionBoxSku,this.mCollisionBoxType);
               if(this.mCollisionBoxes[itemCollisionBoxSku] != null)
               {
                  this.mCollisionBoxesCount[itemCollisionBoxSku] = this.mCollisionBoxes[itemCollisionBoxSku].length;
               }
            }
            if(this.mCollisionBoxes[itemCollisionBoxSku] != null)
            {
               if(!this.mTimerIsEnabled || item.viewLayersGetTimer(layerId) <= 0)
               {
                  currentBoxId = int(item.viewLayersGetAttribute(layerId,this.mAttributeSku));
                  anim = item.viewLayersAnimGet(layerId);
                  if(currentBoxId == -1 || anim != null)
                  {
                     if(currentBoxId == -1 || anim.hasEnded())
                     {
                        item.viewLayersSetTimer(layerId,DCMath.randomNumber(this.mMinTimeToWaitMS,this.mMaxTimeToWaitMS));
                        if(currentBoxId == -1)
                        {
                           currentBoxId = -2;
                        }
                        currentBoxId = this.selectCollisionBoxId(currentBoxId,this.mCollisionBoxesCount[itemCollisionBoxSku]);
                        item.viewLayersSetAttribute(currentBoxId,layerId,this.mAttributeSku);
                     }
                  }
                  else
                  {
                     currentBoxId = this.selectCollisionBoxId(currentBoxId,this.mCollisionBoxesCount[itemCollisionBoxSku]);
                     item.viewLayersSetAttribute(currentBoxId,layerId,this.mAttributeSku);
                  }
                  if(currentBoxId > -1)
                  {
                     currentBoxId = int(this.mCollisionBoxes[itemCollisionBoxSku][currentBoxId].id);
                     returnValue = this.mImpStartId + currentBoxId;
                  }
               }
            }
         }
         return returnValue;
      }
      
      private function selectCollisionBoxId(currentBoxId:int, totalCount:int) : int
      {
         if(currentBoxId == -2)
         {
            currentBoxId = -1;
         }
         currentBoxId++;
         return int(currentBoxId % totalCount);
      }
   }
}
