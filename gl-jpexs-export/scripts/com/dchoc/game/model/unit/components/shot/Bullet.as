package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class Bullet
   {
       
      
      public var mAlive:Boolean;
      
      protected var mState:int;
      
      protected var mUnit:MyUnit;
      
      protected var mTarget:MyUnit;
      
      protected var mCollIdX:Number;
      
      protected var mCollIdY:Number;
      
      protected var mLogicCollX:Number;
      
      protected var mLogicCollY:Number;
      
      public function Bullet(u:MyUnit, target:MyUnit, collId:int = 0)
      {
         super();
         this.mUnit = u;
         this.mTarget = target;
         this.mAlive = true;
         var renderData:DCBitmapMovieClip;
         if((renderData = this.mUnit.getViewComponent().getCurrentRenderData()) != null)
         {
            this.mCollIdX = renderData.getCollBoxX(collId);
            this.mCollIdY = renderData.getCollBoxY(collId);
         }
         else
         {
            this.mCollIdX = 0;
            this.mCollIdY = 0;
         }
         var coord:DCCoordinate;
         (coord = MyUnit.smCoor).x = this.mCollIdX;
         coord.y = this.mCollIdY;
         coord = InstanceMng.getViewMngPlanet().viewPosToLogicPos(coord);
         this.mLogicCollX = coord.x;
         this.mLogicCollY = coord.y;
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
      
      protected function changeState(newState:int) : void
      {
      }
      
      public function unbuild() : void
      {
      }
   }
}
