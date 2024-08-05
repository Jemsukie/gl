package esparragonFlash.display
{
   import esparragon.display.EImage;
   import esparragon.display.ESubTexture;
   import esparragon.display.ETexture;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FlashImage extends EImage
   {
       
      
      private var mImage:Bitmap;
      
      private var mRectSize:Point;
      
      public function FlashImage(texture:ETexture)
      {
         super(texture);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mRectSize = null;
      }
      
      override public function setSmooth(value:Boolean) : void
      {
         this.mImage.smoothing = value;
      }
      
      override public function setTexture(texture:ETexture) : void
      {
         var oldBitmapData:BitmapData = null;
         var newBitmapData:BitmapData = null;
         super.setTexture(texture);
         if(this.mImage == null)
         {
            this.mImage = new Bitmap();
         }
         var subTexture:ESubTexture = null;
         if(texture != null)
         {
            subTexture = texture.getSubTexture();
            oldBitmapData = this.mImage.bitmapData;
            newBitmapData = texture.getData() as BitmapData;
            this.mImage.bitmapData = newBitmapData;
            if(oldBitmapData != newBitmapData && newBitmapData != null)
            {
               notifySetTextureData();
            }
         }
         else
         {
            this.mImage.bitmapData = null;
         }
         var offX:int = 0;
         var offY:int = 0;
         if(texture != null)
         {
            offX = texture.getOffX();
            offY = texture.getOffY();
         }
         var rect:Rectangle = null;
         if(subTexture != null)
         {
            rect = subTexture.clipRectangle;
            offX += subTexture.frameX;
            offY += subTexture.frameY;
         }
         this.setImageScrollRect(rect);
         this.mImage.x = offX;
         this.mImage.y = offY;
         applyPivotLogicXY();
         if(!this.contains(this.mImage))
         {
            addChild(this.mImage);
         }
      }
      
      private function setImageScrollRect(rect:Rectangle) : void
      {
         if(this.mImage.scrollRect != null && rect == null)
         {
            if(this.mRectSize == null)
            {
               this.mRectSize = new Point();
            }
         }
         if(this.mRectSize != null && rect == null)
         {
            if(this.mImage.bitmapData != null)
            {
               this.setRectSize(this.mImage.bitmapData.width,this.mImage.bitmapData.height);
            }
            else
            {
               this.setRectSize(0,0);
            }
         }
         else if(this.mRectSize != null && rect != null)
         {
            this.setRectSize(rect.width,rect.height);
         }
         this.mImage.scrollRect = rect;
      }
      
      private function setRectSize(width:Number, height:Number) : void
      {
         if(this.mRectSize == null)
         {
            this.mRectSize = new Point();
         }
         this.mRectSize.x = width;
         this.mRectSize.y = height;
      }
      
      override public function get width() : Number
      {
         if(this.mRectSize != null)
         {
            return this.mRectSize.x * scaleX;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         if(this.mRectSize != null)
         {
            return this.mRectSize.y * scaleY;
         }
         return super.height;
      }
      
      override public function flipX() : void
      {
         if(this.mImage != null)
         {
            this.mImage.scaleX *= -1;
         }
      }
      
      override public function isFlippedX() : Boolean
      {
         return this.mImage != null && this.mImage.scaleX == -1;
      }
      
      override public function flipY() : void
      {
         if(this.mImage != null)
         {
            this.mImage.scaleY *= -1;
         }
      }
      
      override public function isFlippedY() : Boolean
      {
         return this.mImage != null && this.mImage.scaleY == -1;
      }
   }
}
