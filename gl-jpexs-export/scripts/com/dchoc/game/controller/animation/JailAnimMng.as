package com.dchoc.game.controller.animation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.unit.defs.CivilDef;
   import com.dchoc.game.model.unit.mngs.TrafficMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   
   public class JailAnimMng extends DCComponent
   {
      
      private static const NUM_MINIONS_IN_JAIL:int = 4;
      
      private static const MINIONS_IN_JAIL_OFFX:Array = [-2,6,14,-14];
      
      private static const MINIONS_IN_JAIL_OFFY:Array = [8,6,3,3];
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_OPENING:int = 1;
      
      public static const STATE_OPENED:int = 2;
       
      
      private var mJailItems:Vector.<WorldItemObject>;
      
      private var mState:int;
      
      public function JailAnimMng()
      {
         super();
      }
      
      override protected function unbuildDo() : void
      {
         if(this.mJailItems)
         {
            this.mJailItems.length = 0;
         }
         this.mJailItems = null;
      }
      
      public function addWorldItemObject(item:WorldItemObject) : void
      {
         if(this.mJailItems == null)
         {
            this.mJailItems = new Vector.<WorldItemObject>(0);
         }
         this.mJailItems.push(item);
      }
      
      public function startAllStates() : void
      {
         var item:WorldItemObject = null;
         if(this.mJailItems == null)
         {
            return;
         }
         var changeStateFunction:Function = InstanceMng.getWorldItemObjectController().setItemClientState;
         var stateId:int = 29;
         for each(item in this.mJailItems)
         {
            changeStateFunction(item,stateId);
         }
         this.mState = 1;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var item:WorldItemObject = null;
         var itemAnim:DCBitmapMovieClip = null;
         var amountEnded:int = 0;
         var amountItems:int = 0;
         var n:int = 0;
         var trafficMng:TrafficMng = null;
         var civilsDef:CivilDef = null;
         var civil:MyUnit = null;
         var zOrder:int = 0;
         var posCenterX:Number = NaN;
         var posCenterY:Number = NaN;
         var goal:UnitComponentGoal = null;
         var i:int = 0;
         if(this.mJailItems == null)
         {
            return;
         }
         if(this.mState == 1)
         {
            amountEnded = 0;
            amountItems = int(this.mJailItems.length);
            trafficMng = InstanceMng.getTrafficMng();
            civilsDef = InstanceMng.getUnitScene().civilsGetCurrentCivilDef();
            zOrder = -InstanceMng.getMapControllerPlanet().mTilesCount;
            for(i = amountItems - 1; i >= 0; )
            {
               posCenterX = (item = this.mJailItems[i]).mViewCenterWorldX;
               posCenterY = item.mViewCenterWorldY;
               if((itemAnim = item.viewLayersAnimGet(1) as DCBitmapMovieClip) != null && itemAnim.currentFrame == itemAnim.totalFrames)
               {
                  itemAnim.mBoundingBox.mZ = zOrder;
                  itemAnim.gotoAndStop(itemAnim.totalFrames);
                  this.mJailItems.splice(i,1);
                  amountEnded++;
                  for(n = 0; n < 4; )
                  {
                     (civil = trafficMng.civilsCreateCivil(civilsDef,0,0)).setPositionInViewSpace(posCenterX + MINIONS_IN_JAIL_OFFX[n],posCenterY + MINIONS_IN_JAIL_OFFY[n]);
                     (goal = civil.getGoalComponent()).changeState(101);
                     n++;
                  }
               }
               i--;
            }
            if(amountEnded == amountItems)
            {
               this.mState = 2;
            }
         }
      }
   }
}
