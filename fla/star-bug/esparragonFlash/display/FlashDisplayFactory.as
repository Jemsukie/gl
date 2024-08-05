package esparragonFlash.display
{
   import esparragon.display.EDisplayFactory;
   import esparragon.display.EGraphics;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.widgets.EFillBar;
   import esparragonFlash.widgets.FlashFillBar;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class FlashDisplayFactory implements EDisplayFactory
   {
       
      
      public function FlashDisplayFactory()
      {
         super();
      }
      
      public function createSprite() : ESprite
      {
         return new ESprite();
      }
      
      public function createTextField() : ETextField
      {
         return new FlashTextField();
      }
      
      public function createTextureFromBitmap(data:Bitmap) : ETexture
      {
         return new FlashTexture(data.bitmapData);
      }
      
      public function createTextureFromBitmapData(data:BitmapData) : ETexture
      {
         return new FlashTexture(data);
      }
      
      public function createImage(texture:ETexture) : EImage
      {
         return new FlashImage(texture);
      }
      
      public function createMovieClip() : EMovieClip
      {
         return new FlashMovieClip();
      }
      
      public function createGraphics() : EGraphics
      {
         return new FlashGraphics();
      }
      
      public function createFillBar(image:EImage, type:int, maxValue:Number = 0, color:int = -1) : EFillBar
      {
         return new FlashFillBar(image,type,maxValue,color);
      }
   }
}
