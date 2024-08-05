package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.UnitComponent;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.unit.defs.UnitDef;
   
   public class UnitComponentShot extends UnitComponent
   {
       
      
      public var mWaitForAnim:Boolean;
      
      public function UnitComponentShot(waitForAnim:Boolean = false)
      {
         super(null);
         this.mWaitForAnim = waitForAnim;
      }
      
      override protected function buildDo(def:UnitDef, u:MyUnit) : void
      {
         super.buildDo(def,u);
         this.reset(u);
      }
      
      override public function reset(u:MyUnit) : void
      {
         var timeToWaitBetweenShots:Number = u.mDef.getShotWaitingTime();
         if(timeToWaitBetweenShots > 0)
         {
            u.mData[10] = 0;
            u.mData[11] = timeToWaitBetweenShots;
         }
      }
      
      public function setWaitTimeToShot(u:MyUnit) : void
      {
         var timeToWaitBetweenShots:Number = NaN;
         if(u != null)
         {
            timeToWaitBetweenShots = u.mDef.getShotWaitingTime();
            if(timeToWaitBetweenShots > 0)
            {
               u.mData[10] = timeToWaitBetweenShots;
               u.mData[11] = timeToWaitBetweenShots;
            }
         }
      }
      
      public function isShotAllowed(u:MyUnit) : Boolean
      {
         var viewComp:UnitComponentView = null;
         var returnValue:* = true;
         if(u.mData[10] != null)
         {
            returnValue = u.mData[10] <= 0;
         }
         if(returnValue && this.mWaitForAnim)
         {
            viewComp = u.getViewComponent();
            if(viewComp != null)
            {
               returnValue = !viewComp.isPlayingAnimId("shooting");
            }
         }
         return returnValue;
      }
      
      public function shoot(u:MyUnit, target:MyUnit = null) : Boolean
      {
         var viewComp:UnitComponentView = null;
         var returnValue:Boolean = this.isShotAllowed(u);
         if(returnValue)
         {
            if(this.mWaitForAnim)
            {
               if((viewComp = u.getViewComponent()) != null)
               {
                  viewComp.setAnimationId("shooting",-1,true,true,true,false);
               }
            }
            if(u.mData[11] != null)
            {
               u.mData[10] = u.mData[11];
            }
            this.shootDo(u,target);
         }
         return returnValue;
      }
      
      protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
      }
      
      public function doShoot(u:MyUnit, target:MyUnit = null) : void
      {
         this.shootDo(u,target);
      }
      
      public function stopShot() : void
      {
      }
   }
}
