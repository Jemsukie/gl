package com.dchoc.game.utils.popup
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.utils.popup.DCPopupEffect;
   
   public class PopupEffectMoveFading extends DCPopupEffect
   {
       
      
      private var mIsFadeout:Boolean;
      
      private var mTime:Number;
      
      private var mTimeMax:Number;
      
      private var mHasToDisappear:Boolean;
      
      private var mViewMngRef:ViewMngrGame;
      
      private var mViewMngLayer:String;
      
      public function PopupEffectMoveFading(fadeout:Boolean, time:Number, hasToDisappear:Boolean, layerName:String)
      {
         super();
         this.mIsFadeout = fadeout;
         this.mTime = time;
         this.mTimeMax = time;
         this.mHasToDisappear = hasToDisappear;
         this.mViewMngRef = InstanceMng.getViewMngGame();
         this.mViewMngLayer = layerName;
      }
      
      override public function initialize() : void
      {
         if(this.mIsFadeout == false)
         {
            mPopup.getForm().alpha = 0;
         }
         if(this.mViewMngRef.contains(mPopup.getForm()) == false)
         {
            mPopup.show(false);
            this.mViewMngRef.addChildToLayer(mPopup.getForm(),this.mViewMngLayer);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(securityChecks() == false)
         {
            return;
         }
         this.mTime = Math.max(0,this.mTime - dt);
         var timeRel:Number = this.mTime / this.mTimeMax;
         var alpha:* = timeRel;
         if(this.mIsFadeout == false)
         {
            alpha = 1 - alpha;
         }
         mPopup.getForm().alpha = alpha;
         if(this.mTime == 0)
         {
            setHasEnded(true);
            if(this.mHasToDisappear && this.mViewMngRef.contains(mPopup.getForm()) == true)
            {
               this.mViewMngRef.removeChildFromLayer(mPopup.getForm(),this.mViewMngLayer);
               mPopup.close();
            }
         }
      }
   }
}
