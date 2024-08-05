package esparragon.widgets
{
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   
   public class EFillBar extends ESpriteContainer
   {
      
      private static const FILL_BAR_ID:String = "fillBar";
      
      private static const MAX_TIME:int = 1000;
      
      public static const TYPE_BASE:int = 0;
      
      public static const TYPE_BAR:int = 1;
       
      
      protected var mMinValue:Number;
      
      protected var mMaxValue:Number;
      
      protected var mCurrentValue:Number;
      
      private var mMaxTime:int;
      
      private var mUpdateBarTime:int;
      
      private var mFinalValue:Number;
      
      private var mStartValue:Number;
      
      protected var mType:int;
      
      public function EFillBar(fillBar:EImage, type:int, maxValue:Number = 0)
      {
         super();
         setContent("fillBar",fillBar);
         eAddChild(fillBar);
         fillBar.onSetTextureLoaded = this.calculateClipRect;
         this.setMaxValue(maxValue);
         this.setMinValue(0);
         this.setValue(0);
         this.mFinalValue = 0;
         this.mStartValue = 0;
         this.mUpdateBarTime = 0;
         this.mMaxTime = 0;
         this.mType = type;
      }
      
      public function getFillBarImg() : EImage
      {
         return getContent("fillBar") as EImage;
      }
      
      public function setMinValue(value:Number) : void
      {
         this.mMinValue = value;
         this.calculateClipRect();
      }
      
      public function setMaxValue(value:Number) : void
      {
         this.mMaxValue = value;
         this.calculateClipRect();
      }
      
      public function setValue(value:Number) : void
      {
         this.mCurrentValue = value;
         this.calculateClipRect();
      }
      
      public function getCurrentValue() : Number
      {
         return this.mCurrentValue;
      }
      
      public function setValueAnimated(previousValue:Number, value:Number, time:Number = 1000) : void
      {
         this.mCurrentValue = previousValue;
         this.mStartValue = previousValue;
         this.mFinalValue = value;
         this.mMaxTime = time;
         this.mUpdateBarTime = 0;
         this.mMaxTime = 1000;
         this.calculateClipRect();
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mUpdateBarTime < this.mMaxTime)
         {
            this.mUpdateBarTime += dt;
            if(this.mUpdateBarTime > this.mMaxTime)
            {
               this.mUpdateBarTime = this.mMaxTime;
            }
            this.setValue(this.mStartValue + this.mUpdateBarTime * (this.mFinalValue - this.mStartValue) / this.mMaxTime);
         }
      }
      
      protected function calculateClipRect(img:EImage = null) : void
      {
      }
   }
}
