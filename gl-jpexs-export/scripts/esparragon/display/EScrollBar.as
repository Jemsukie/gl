package esparragon.display
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import esparragon.events.EEvent;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EScrollBar extends ESpriteContainer
   {
      
      public static const DIRECTION_VERTICAL:int = 0;
      
      public static const DIRECTION_HORIZONTAL:int = 1;
       
      
      protected var mScrollDirection:int;
      
      protected var mLeftArrow:EImage;
      
      protected var mRightArrow:EImage;
      
      protected var mScrollBkg:EImage;
      
      protected var mScrollDragger:EImage;
      
      protected var mScrollArea:EScrollArea;
      
      protected var mScrollAmount:int;
      
      protected var mScrollDraggerTopPos:int;
      
      protected var mScrollDraggerBottomPos:int;
      
      private var mDragOffsetWhenClicked:Number;
      
      private var mPoint:Point;
      
      private var mDragOffset:int;
      
      private var mIsDraggingBkg:Boolean;
      
      private var mIsDraggingDragger:Boolean;
      
      private var mHasDraggedThisStep:Boolean;
      
      private var mHasDragged:Boolean;
      
      private var mStage:Stage;
      
      private var mTimeSinceLastDraggerUpdate:int;
      
      private var mDraggerUpdateInterval:int = 0;
      
      public function EScrollBar(direction:int, leftArrow:EImage, rightArrow:EImage, barBg:EImage, scrollDragger:EImage, area:EScrollArea)
      {
         this.mLogicUpdateFrequency = 200;
         super();
         this.mScrollDirection = direction;
         this.mLeftArrow = leftArrow;
         this.mRightArrow = rightArrow;
         this.mScrollBkg = barBg;
         this.mScrollDragger = scrollDragger;
         eAddChild(this.mScrollBkg);
         eAddChild(this.mScrollDragger);
         eAddChild(this.mLeftArrow);
         eAddChild(this.mRightArrow);
         setContent("left",this.mLeftArrow);
         setContent("right",this.mRightArrow);
         setContent("bkg",this.mScrollBkg);
         setContent("dragger",this.mScrollDragger);
         this.mLeftArrow.eAddEventListener("click",this.onPrevious);
         this.mRightArrow.eAddEventListener("click",this.onNext);
         this.mScrollDragger.eAddEventListener("mouseDown",this.onDragIn);
         this.mScrollBkg.eAddEventListener("mouseDown",this.onDragBkgMouseDown);
         this.mScrollBkg.addEventListener("mouseWheel",this.onMouseWheel);
         this.mScrollDragger.eAddEventListener("addedToStage",this.onDraggerAddToStage);
         this.mScrollDragger.addEventListener("mouseWheel",this.onMouseWheel);
         area.setScrollBar(this);
         this.mRightArrow.onSetTextureLoaded = this.configurePositioning;
         this.mLeftArrow.onSetTextureLoaded = this.configurePositioning;
         this.mScrollBkg.onSetTextureLoaded = this.configurePositioning;
         this.mScrollDragger.onSetTextureLoaded = this.configurePositioning;
         this.mPoint = new Point();
      }
      
      public function setScrollArea(area:EScrollArea) : void
      {
         this.mScrollArea = area;
         if(!area)
         {
            this.mIsDraggingBkg = false;
            this.mIsDraggingDragger = false;
         }
         this.mScrollAmount = 30;
      }
      
      public function setScrollAmount(value:int) : void
      {
         this.mScrollAmount = value;
      }
      
      public function setDraggerUpdateInterval(value:int) : void
      {
         this.mDraggerUpdateInterval = value;
      }
      
      protected function onPrevious(evt:EEvent) : void
      {
         if(this.mScrollArea)
         {
            this.mScrollArea.scroll(-this.mScrollAmount);
         }
      }
      
      protected function onNext(evt:EEvent) : void
      {
         if(this.mScrollArea)
         {
            this.mScrollArea.scroll(this.mScrollAmount);
         }
      }
      
      private function onDraggerAddToStage(evt:EEvent) : void
      {
         this.mStage = this.mScrollDragger.stage;
         if(this.mStage != null)
         {
            this.mStage.addEventListener("mouseUp",this.onDrag);
            this.mStage.addEventListener("mouseOut",this.onDrag);
         }
      }
      
      protected function onDragBkgMouseDown(evt:EEvent) : void
      {
         var diff:int = 0;
         this.mDragOffset = this.mScrollDragger.height / 2;
         if(this.mScrollDirection == 0)
         {
            diff = evt.localY * evt.getTarget().scaleY;
         }
         else
         {
            diff = evt.localX * evt.getTarget().scaleX;
         }
         if(!this.mHasDraggedThisStep)
         {
            this.mScrollArea.setLogicYRelative(this.getDraggerPositionRelative(diff));
            this.mHasDraggedThisStep = true;
         }
         this.mIsDraggingBkg = true;
      }
      
      public function onMouseWheel(e:MouseEvent) : void
      {
         var sign:int = 0;
         var profile:Profile = null;
         if(this.mScrollArea)
         {
            sign = e.delta < 0 ? 1 : -1;
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(profile)
            {
               if(profile.getScrollZoomInverted())
               {
                  sign = -sign;
               }
            }
            this.mScrollArea.scroll(sign * this.mScrollAmount);
         }
      }
      
      protected function onDragIn(evt:EEvent) : void
      {
         if(this.mScrollArea && evt.buttonDown)
         {
            this.mIsDraggingBkg = true;
            this.mIsDraggingDragger = true;
            this.mDragOffsetWhenClicked = evt.localY;
            if(this.mDragOffsetWhenClicked < 0 || this.mDragOffsetWhenClicked > this.mScrollDragger.height)
            {
               this.mDragOffsetWhenClicked = this.mDragOffset;
            }
         }
      }
      
      private function dragMove() : void
      {
         if(this.mStage == null || this.mScrollArea == null || !this.mIsDraggingBkg && !this.mIsDraggingDragger)
         {
            return;
         }
         var diff:Number = NaN;
         var localPoint:Point = this.mScrollDragger.globalToLocal(this.mPoint);
         this.mPoint.x = this.mStage.mouseX;
         this.mPoint.y = this.mStage.mouseY;
         if(this.mScrollDirection == 0)
         {
            diff = localPoint.y + this.mScrollDragger.logicTop - this.mScrollDraggerTopPos - this.mDragOffsetWhenClicked;
            if(diff > this.mScrollDraggerBottomPos - this.mScrollDraggerTopPos)
            {
               diff = this.mScrollDraggerBottomPos - this.mScrollDraggerTopPos;
            }
            else if(diff < 0)
            {
               diff = 0;
            }
            diff /= this.mScrollDraggerBottomPos - this.mScrollDraggerTopPos;
         }
         else
         {
            diff = localPoint.x + this.mScrollDragger.logicLeft - this.mLeftArrow.width;
         }
         if(!this.mHasDraggedThisStep)
         {
            this.mScrollArea.setLogicYRelative(diff);
            this.mHasDraggedThisStep = true;
            this.mTimeSinceLastDraggerUpdate = 0;
         }
      }
      
      protected function onDrag(evt:MouseEvent) : void
      {
         var type:String = evt.type;
         if(type == "mouseDown")
         {
            this.mDragOffset = this.mScrollDirection == 0 ? int(evt.localY) : int(evt.localX);
            if(this.mScrollArea && evt.buttonDown)
            {
               this.mIsDraggingBkg = true;
               this.mIsDraggingDragger = true;
            }
         }
         else if(type == "mouseUp" || type == "mouseOut" && evt.target == this.mStage)
         {
            this.mIsDraggingBkg = false;
            this.mIsDraggingDragger = false;
         }
      }
      
      private function getDraggerPositionRelative(absoluteYPosInPixels:int = 0) : Number
      {
         return Math.min(1,Math.max(0,(absoluteYPosInPixels - this.mDragOffset) / (this.mScrollDraggerBottomPos - this.mScrollDraggerTopPos)));
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var areaLogicY:Number = NaN;
         super.logicUpdate(dt);
         if(this.mScrollArea)
         {
            if(this.mIsDraggingDragger)
            {
               this.mTimeSinceLastDraggerUpdate += dt;
               if(this.mTimeSinceLastDraggerUpdate > this.mDraggerUpdateInterval)
               {
                  this.dragMove();
               }
            }
            areaLogicY = this.mScrollArea.getLogicYRelative();
            this.mScrollDragger.logicTop = this.mScrollDraggerTopPos + (this.mScrollDraggerBottomPos - this.mScrollDraggerTopPos) * areaLogicY;
         }
         this.mHasDragged = this.mHasDraggedThisStep;
         this.mHasDraggedThisStep = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mScrollArea = null;
         this.mLeftArrow.eRemoveEventListener("click",this.onPrevious);
         this.mRightArrow.eRemoveEventListener("click",this.onNext);
         this.mScrollDragger.eRemoveEventListener("mouseDown",this.onDragIn);
         this.mScrollBkg.eRemoveEventListener("mouseDown",this.onDragBkgMouseDown);
         if(this.mStage != null)
         {
            this.mStage.removeEventListener("mouseUp",this.onDrag);
            this.mStage.removeEventListener("mouseOut",this.onDrag);
            this.mStage = null;
         }
         this.mPoint = null;
      }
      
      private function configurePositioning(img:EImage) : void
      {
         if(this.mScrollDirection == 0)
         {
            this.mLeftArrow.logicTop = 0;
            this.mRightArrow.logicTop = this.mScrollArea.getVisibleHeight();
            this.mScrollBkg.height = this.mScrollArea.getVisibleHeight() - this.mLeftArrow.height - this.mRightArrow.height;
            this.mScrollBkg.logicTop = this.mLeftArrow.logicTop + this.mLeftArrow.height;
            this.mScrollBkg.scaleLogicX = 1;
            this.mScrollDragger.logicTop = this.mScrollBkg.logicTop;
            this.mScrollDragger.logicLeft = this.mScrollBkg.logicLeft + (this.mScrollBkg.width - this.mScrollDragger.width) / 2;
            this.mScrollDraggerTopPos = this.mLeftArrow.height;
            this.mScrollDraggerBottomPos = this.mScrollArea.getVisibleHeight() - this.mRightArrow.height - this.mScrollDragger.height;
         }
      }
      
      public function hasDraggedThisStep() : Boolean
      {
         return this.mHasDragged;
      }
   }
}
