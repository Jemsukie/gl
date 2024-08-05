package esparragonFlash.display
{
   import esparragon.display.ESubTexture;
   import esparragon.display.ETexture;
   import flash.display.BitmapData;
   
   public class FlashTexture implements ETexture
   {
       
      
      private var mBitmapData:BitmapData;
      
      private var mOffX:int;
      
      private var mOffY:int;
      
      private var mSubTextureRef:ESubTexture;
      
      public function FlashTexture(bitmapData:BitmapData = null)
      {
         super();
         this.mBitmapData = bitmapData;
         this.reset();
      }
      
      private function reset() : void
      {
         this.mOffX = 0;
         this.mOffY = 0;
      }
      
      public function destroy() : void
      {
         if(this.mBitmapData != null)
         {
            this.mBitmapData.dispose();
            this.mBitmapData = null;
         }
         this.reset();
         this.mSubTextureRef = null;
      }
      
      public function getData() : Object
      {
         return this.mBitmapData;
      }
      
      public function setBitmapData(value:BitmapData, disposeOld:Boolean = true) : void
      {
         if(this.mBitmapData != null && disposeOld)
         {
            this.mBitmapData.dispose();
         }
         this.mBitmapData = value;
      }
      
      public function getBitmapData() : BitmapData
      {
         return this.mBitmapData;
      }
      
      public function isLoaded() : Boolean
      {
         return this.mBitmapData != null;
      }
      
      public function getOffX() : int
      {
         return this.mSubTextureRef != null ? int(-this.mSubTextureRef.frameX) : this.mOffX;
      }
      
      public function setOffX(value:int) : void
      {
         this.mOffX = value;
      }
      
      public function getOffY() : int
      {
         return this.mSubTextureRef != null ? int(-this.mSubTextureRef.frameY) : this.mOffY;
      }
      
      public function setOffY(value:int) : void
      {
         this.mOffY = value;
      }
      
      public function setSubTexture(value:ESubTexture) : void
      {
         this.mSubTextureRef = value;
      }
      
      public function getSubTexture() : ESubTexture
      {
         return this.mSubTextureRef;
      }
   }
}
