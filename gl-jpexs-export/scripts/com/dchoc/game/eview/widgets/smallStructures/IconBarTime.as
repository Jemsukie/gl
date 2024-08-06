package com.dchoc.game.eview.widgets.smallStructures
{
   public class IconBarTime extends IconBar
   {
       
      
      protected var mOnUpdateFunc:Function;
      
      protected var mOnUpdateParams:Array;
      
      public function IconBarTime(onUpdateFunc:Function, onUpdateParams:Array)
      {
         super();
         this.mOnUpdateFunc = onUpdateFunc;
         this.mOnUpdateParams = onUpdateParams;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mOnUpdateFunc != null)
         {
            this.mOnUpdateFunc(this,dt,this.mOnUpdateParams);
         }
      }
   }
}
