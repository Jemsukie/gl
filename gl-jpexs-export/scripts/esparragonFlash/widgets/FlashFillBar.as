package esparragonFlash.widgets
{
   import esparragon.display.EImage;
   import esparragon.widgets.EFillBar;
   import flash.geom.Rectangle;
   
   public class FlashFillBar extends EFillBar
   {
       
      
      private var mMaskRect:Rectangle;
      
      public function FlashFillBar(fillBar:EImage, type:int, maxValue:Number = 0, color:int = -1)
      {
         super(fillBar,type,maxValue);
         if(color > -1)
         {
            setColor(color,1);
         }
      }
      
      override protected function calculateClipRect(img:EImage = null) : void
      {
         var fillBarImg:EImage = getFillBarImg();
         if(this.mMaskRect == null)
         {
            this.mMaskRect = new Rectangle();
         }
         this.mMaskRect.height = fillBarImg.height;
         if(mType == 0 && mMaxValue == 0)
         {
            this.mMaskRect.width = fillBarImg.width;
         }
         else if(mType == 1 && mCurrentValue == 0)
         {
            this.mMaskRect.width = 0;
         }
         else
         {
            this.mMaskRect.width = (mCurrentValue - mMinValue) * fillBarImg.width / (mMaxValue - mMinValue);
         }
         scrollRect = this.mMaskRect;
      }
   }
}
