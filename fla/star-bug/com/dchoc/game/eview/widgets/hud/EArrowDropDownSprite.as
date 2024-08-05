package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   
   public class EArrowDropDownSprite extends EDropDownSprite
   {
       
      
      protected var mIconsArea:EImage;
      
      protected var mIconsContentArea:ESpriteContainer;
      
      protected var mTabArea:EImage;
      
      protected var mArrow:EImage;
      
      protected var mTabLayoutArea:ELayoutArea;
      
      protected var mArrowLayoutArea:ELayoutArea;
      
      protected var mArrowCloseRotation:Number;
      
      protected var mArrowOpenRotation:Number;
      
      public function EArrowDropDownSprite(direction:int = 1)
      {
         super(direction);
      }
      
      public function build() : void
      {
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mIconsArea = null;
         this.mIconsContentArea = null;
         this.mTabArea = null;
         this.mArrow = null;
         if(this.mTabLayoutArea != null)
         {
            this.mTabLayoutArea.destroy();
            this.mTabLayoutArea = null;
         }
         if(this.mArrowLayoutArea != null)
         {
            this.mArrowLayoutArea.destroy();
            this.mArrowLayoutArea = null;
         }
      }
      
      override public function isOpen() : Boolean
      {
         return this.mIconsContentArea.scaleLogicY && this.mIconsContentArea.scaleLogicX;
      }
      
      protected function onArrowClick(evt:EEvent) : void
      {
         if(this.isOpen())
         {
            this.close(true);
         }
         else
         {
            this.open(true);
         }
      }
      
      override public function close(animated:Boolean = true) : void
      {
         super.close(animated);
         this.mArrow.rotation = this.mArrowOpenRotation;
      }
      
      override public function open(animated:Boolean = true) : void
      {
         super.open(animated);
         this.mArrow.rotation = this.mArrowCloseRotation;
      }
      
      override protected function createTweenOpenDo() : GTween
      {
         var returnValue:GTween = createTweenOpen(this.mIconsArea);
         returnValue.onChange = this.onUpdateTween;
         return returnValue;
      }
      
      override protected function createTweenCloseDo() : GTween
      {
         var returnValue:GTween = createTweenClose(this.mIconsArea);
         returnValue.onChange = this.onUpdateTween;
         return returnValue;
      }
      
      override protected function addContentDo(content:ESprite) : void
      {
         this.mIconsContentArea.eAddChild(content);
      }
      
      override protected function removeContentDo(content:ESprite) : void
      {
         this.mIconsContentArea.eRemoveChild(content);
      }
      
      protected function onUpdateTween(tween:GTween) : void
      {
      }
      
      protected function setTabAreaX(value:Number) : void
      {
         this.mTabArea.logicLeft = value;
         this.mTabLayoutArea.x = this.mTabArea.logicLeft;
      }
      
      protected function setArrowX(value:Number) : void
      {
         this.mArrow.logicLeft = value;
         this.mArrowLayoutArea.x = this.mArrow.logicLeft;
      }
      
      protected function setTabAreaY(value:Number) : void
      {
         this.mTabArea.logicTop = value;
         this.mTabLayoutArea.y = this.mTabArea.logicTop;
      }
      
      protected function setArrowY(value:Number) : void
      {
         this.mArrow.logicTop = value;
         this.mArrowLayoutArea.y = this.mArrow.logicTop;
      }
   }
}
