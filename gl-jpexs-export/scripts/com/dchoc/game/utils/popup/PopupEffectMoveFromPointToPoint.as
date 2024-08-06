package com.dchoc.game.utils.popup
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.utils.popup.DCPopupEffect;
   
   public class PopupEffectMoveFromPointToPoint extends DCPopupEffect
   {
       
      
      private var mPointA:DCCoordinate;
      
      private var mPointB:DCCoordinate;
      
      private var mPointBAK:DCCoordinate;
      
      private var mTime:Number;
      
      private var mTimeMax:Number;
      
      private var mHasToDisappear:Boolean;
      
      private var mViewMngRef:ViewMngrGame;
      
      private var mViewMngLayer:String;
      
      private var mViewMngLayerPos:int;
      
      public function PopupEffectMoveFromPointToPoint(pointA:DCCoordinate, pointB:DCCoordinate, time:Number, hasToDisappear:Boolean, viewMngLayer:String, viewMngLayerPos:int = -1)
      {
         super();
         this.mPointA = pointA;
         this.mPointB = pointB;
         this.mTime = time;
         this.mTimeMax = time;
         this.mHasToDisappear = hasToDisappear;
         this.mViewMngRef = InstanceMng.getViewMngGame();
         this.mViewMngLayer = viewMngLayer;
         this.mViewMngLayerPos = viewMngLayerPos;
      }
      
      override public function initialize() : void
      {
         this.mPointBAK = new DCCoordinate(mPopup.getForm().x,mPopup.getForm().y);
         mPopup.setX(this.mPointA.x);
         mPopup.setY(this.mPointA.y);
         if(this.mViewMngRef.contains(mPopup.getForm()) == false)
         {
            this.mViewMngRef.addChildToLayer(mPopup.getForm(),this.mViewMngLayer,this.mViewMngLayerPos);
            mPopup.show(false);
         }
      }
      
      override public function endEffect() : void
      {
         this.logicUpdate(this.mTimeMax);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(securityChecks() == false)
         {
            return;
         }
         this.mTime = Math.max(0,this.mTime - dt);
         var timeRel:Number = this.mTime / this.mTimeMax;
         var posx:Number = (1 - timeRel) * this.mPointB.x + timeRel * this.mPointA.x;
         var posy:Number = (1 - timeRel) * this.mPointB.y + timeRel * this.mPointA.y;
         mPopup.setX(posx);
         mPopup.setY(posy);
         if(this.mTime == 0)
         {
            setHasEnded(true);
            if(this.mHasToDisappear)
            {
               if(this.mViewMngRef.contains(mPopup.getForm()) == true)
               {
                  this.mViewMngRef.removeChildFromLayer(mPopup.getForm(),this.mViewMngLayer);
               }
               mPopup.close();
               if(this.mPointBAK != null)
               {
                  mPopup.setX(this.mPointBAK.x);
                  mPopup.setY(this.mPointBAK.y);
               }
            }
         }
      }
   }
}
