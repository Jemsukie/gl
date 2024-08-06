package com.dchoc.game.model.animation
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   
   public class AnimationLogic extends DCBitmapMovieClip
   {
      
      public static const NOTIFY_STATE_END:String = "NOTIFY_STATE_END";
       
      
      protected var mNotifyComponent:DCComponent;
      
      protected var mState:int;
      
      public function AnimationLogic()
      {
         super();
      }
      
      public function changeState(newState:int) : void
      {
         var oldState:int = this.mState;
         this.mState = newState;
         this.onChangeState(newState,oldState);
      }
      
      public function setNotifyComponent(component:DCComponent) : void
      {
         this.mNotifyComponent = component;
      }
      
      protected function requestAnimByState() : void
      {
      }
      
      public function setParams(... params) : void
      {
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(getAnimation() == null)
         {
            this.requestAnimByState();
         }
      }
      
      protected function onChangeState(newState:int, oldState:int) : void
      {
      }
   }
}
