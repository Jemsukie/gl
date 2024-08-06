package esparragon.display
{
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.layout.ELayoutArea;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class EScrollArea extends ESpriteContainer
   {
      
      public static const DIRECTION_VERTICAL:int = 0;
      
      public static const DIRECTION_HORIZONTAL:int = 1;
       
      
      private var MAX_SCROLL_AMOUNT_PER_TICK:int = 25;
      
      protected var mFirstElementIndex:int = 0;
      
      protected var mElements:Vector.<ESpriteContainer>;
      
      protected var mContent:ESpriteContainer;
      
      protected var mAccumulatedScrollNeeded:int;
      
      private var mMaxScrollAmount:int;
      
      private var mRealContentSize:int;
      
      private var mRealNumberOfScrollableElements:int;
      
      protected var mScrollBar:EScrollBar;
      
      protected var mOnSetDataCallback:Function;
      
      private var mLayout:ELayoutArea;
      
      private var mScrollElementClass:Class;
      
      private var mMask:Shape;
      
      public function EScrollArea(direction:int = 0)
      {
         super();
         this.mElements = new Vector.<ESpriteContainer>(0);
         this.mContent = new ESpriteContainer();
      }
      
      public function build(layout:ELayoutArea, realNumberOfScrollableElements:int, scrollElementClass:Class, setDataCallback:Function, spacing:int = 0) : void
      {
         var spacingToAdd:int = 0;
         var esprite:ESpriteContainer = null;
         this.destroyElements();
         this.mLayout = layout;
         this.mScrollElementClass = scrollElementClass;
         this.setOnSetDataCallback(setDataCallback);
         this.mRealNumberOfScrollableElements = realNumberOfScrollableElements;
         var previousHeight:int = -1;
         var iterations:int = 0;
         this.mRealContentSize = 0;
         while(iterations < realNumberOfScrollableElements)
         {
            spacingToAdd = int(iterations == 0 ? 0 : spacing);
            previousHeight = this.mContent.height + spacingToAdd;
            iterations++;
            esprite = new scrollElementClass();
            this.mOnSetDataCallback(esprite,this.mElements.length,true);
            esprite.logicTop = previousHeight;
            this.mElements.push(esprite);
            this.mContent.eAddChild(esprite);
            this.mContent.setContent("iteration" + iterations,esprite);
            this.mRealContentSize += esprite.height + spacingToAdd;
         }
         this.eAddChild(this.mContent);
         this.setContent("content",this.mContent);
         this.mMask = new Shape();
         this.mMask.graphics.beginFill(16777215);
         this.mMask.graphics.drawRect(0,0,layout.width,layout.height);
         this.mMask.graphics.endFill();
         this.mContent.setMask(this.mMask);
         this.addChild(this.mMask);
         this.mMaxScrollAmount = this.mRealContentSize - this.mMask.height;
         this.MAX_SCROLL_AMOUNT_PER_TICK = layout.height / this.mElements.length - 1;
         layoutApplyTransformations(layout);
         if(this.mScrollBar != null)
         {
            if(this.getLogicYRelative() > 1)
            {
               this.setLogicYRelative(1);
            }
            this.mScrollBar.visible = this.mRealContentSize > this.mContent.mask.height;
         }
      }
      
      public function setScrollBar(scrollBar:EScrollBar) : void
      {
         var parent:Sprite = null;
         if(this.mScrollBar)
         {
            this.eRemoveChild(this.mScrollBar);
         }
         this.mScrollBar = scrollBar;
         this.mScrollBar.setScrollArea(this);
         this.mScrollBar.logicLeft = this.getVisibleWidth();
         if(this.mRealContentSize <= this.mContent.mask.height)
         {
            this.mScrollBar.visible = false;
         }
         this.eAddChild(this.mScrollBar);
         this.setContent("scrollBar",this.mScrollBar);
         if(this.mScrollBar.visible)
         {
            parent = this.tryToFindParent(this) as Sprite;
            if(parent)
            {
               parent.addEventListener("mouseWheel",this.mScrollBar.onMouseWheel);
            }
         }
      }
      
      private function tryToFindParent(currentObject:*, numAttempts:int = 0) : *
      {
         if(currentObject == null || numAttempts > 10)
         {
            return this;
         }
         if(currentObject is DCIPopup || currentObject.parent == null)
         {
            return currentObject;
         }
         return tryToFindParent(currentObject.parent,numAttempts + 1);
      }
      
      public function getScrollBar() : EScrollBar
      {
         return this.mScrollBar;
      }
      
      public function getVisibleWidth() : int
      {
         if(this.mContent && this.mContent.mask)
         {
            return this.mContent.mask.width;
         }
         return 0;
      }
      
      public function getVisibleHeight() : int
      {
         if(this.mContent && this.mContent.mask)
         {
            return this.mContent.mask.height;
         }
         return 0;
      }
      
      private function destroyElements() : void
      {
         if(this.mMask != null)
         {
            this.mContent.setMask(null);
            this.removeChild(this.mMask);
            this.mMask = null;
         }
         while(this.mContent.numChildren)
         {
            (this.mContent.getChildAt(0) as ESprite).destroy();
         }
         this.mContent.eRemoveAllChildren();
         while(this.mElements.length)
         {
            this.mElements.pop().destroy();
         }
      }
      
      private function setOnSetDataCallback(callback:Function) : void
      {
         this.mOnSetDataCallback = callback;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var scrollAmount:int = 0;
         var container:ESprite = null;
         super.logicUpdate(dt);
         while(this.mAccumulatedScrollNeeded != 0)
         {
            scrollAmount = Math.min(Math.abs(this.mAccumulatedScrollNeeded),this.MAX_SCROLL_AMOUNT_PER_TICK) * (this.mAccumulatedScrollNeeded > 0 ? 1 : -1);
            this.mContent.logicTop -= scrollAmount;
            this.mAccumulatedScrollNeeded -= scrollAmount;
            if(this.mScrollBar)
            {
               this.mScrollBar.logicUpdate(dt);
            }
            if(scrollAmount < 0)
            {
               container = this.mElements[this.mFirstElementIndex % this.mElements.length];
               if(this.mContent.logicTop + container.logicTop > 0 && this.mFirstElementIndex > 0)
               {
                  this.mFirstElementIndex--;
                  container = this.mElements[this.mFirstElementIndex % this.mElements.length];
                  this.mOnSetDataCallback(container,this.mFirstElementIndex,false);
                  container.logicTop -= container.height * this.mElements.length;
               }
            }
            else if(scrollAmount > 0)
            {
               container = this.mElements[(this.mFirstElementIndex + this.mElements.length - 1) % this.mElements.length];
               if(container.logicTop + container.height + this.mContent.logicTop - this.getVisibleHeight() < 0 && this.mFirstElementIndex + this.mElements.length < this.mRealNumberOfScrollableElements)
               {
                  this.mFirstElementIndex++;
                  container = this.mElements[(this.mFirstElementIndex + this.mElements.length - 1) % this.mElements.length];
                  this.mOnSetDataCallback(container,this.mFirstElementIndex + this.mElements.length - 1,false);
                  container.logicTop += container.height * this.mElements.length;
               }
            }
         }
      }
      
      public function scroll(pixels:int) : void
      {
         this.mAccumulatedScrollNeeded += pixels;
         if(this.mContent.logicTop - this.mAccumulatedScrollNeeded > 0)
         {
            this.mAccumulatedScrollNeeded = this.mContent.logicTop;
         }
         else if(this.mContent.logicTop - this.mAccumulatedScrollNeeded < -this.mMaxScrollAmount)
         {
            this.mAccumulatedScrollNeeded = this.mContent.logicTop + this.mMaxScrollAmount;
         }
      }
      
      private function reloadViewWithNumElements(newNumElements:int) : void
      {
         if(this.mRealNumberOfScrollableElements != newNumElements)
         {
            this.build(this.mLayout,newNumElements,this.mScrollElementClass,this.mOnSetDataCallback);
         }
         else
         {
            this.reloadViewOnlyElements();
         }
      }
      
      private function reloadViewOnlyElements() : void
      {
         var i:int = 0;
         for(i = 0; i < this.mElements.length; )
         {
            this.mOnSetDataCallback(this.mElements[(this.mFirstElementIndex + i) % this.mElements.length],this.mFirstElementIndex + i,false);
            i++;
         }
      }
      
      public function reloadView(newNumScrollableItems:int = -1) : void
      {
         if(newNumScrollableItems == -1)
         {
            newNumScrollableItems = this.mRealNumberOfScrollableElements;
         }
         this.reloadViewWithNumElements(newNumScrollableItems);
      }
      
      public function getLogicYRelative() : Number
      {
         return -this.mContent.logicTop / this.mMaxScrollAmount;
      }
      
      public function setLogicYRelative(value:Number) : void
      {
         var scrollAmount:int = value * this.mMaxScrollAmount + this.mContent.logicTop;
         this.scroll(scrollAmount);
      }
      
      public function getElements() : Vector.<ESpriteContainer>
      {
         return this.mElements;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.destroyElements();
         if(this.mScrollBar != null)
         {
            this.mScrollBar.destroy();
            this.mScrollBar = null;
         }
         this.mOnSetDataCallback = null;
         this.mLayout = null;
         this.mScrollElementClass = null;
      }
   }
}
