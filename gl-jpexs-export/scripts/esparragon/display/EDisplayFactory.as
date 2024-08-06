package esparragon.display
{
   import esparragon.widgets.EFillBar;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public interface EDisplayFactory
   {
       
      
      function createSprite() : ESprite;
      
      function createTextField() : ETextField;
      
      function createTextureFromBitmap(param1:Bitmap) : ETexture;
      
      function createTextureFromBitmapData(param1:BitmapData) : ETexture;
      
      function createImage(param1:ETexture) : EImage;
      
      function createMovieClip() : EMovieClip;
      
      function createGraphics() : EGraphics;
      
      function createFillBar(param1:EImage, param2:int, param3:Number = 0, param4:int = -1) : EFillBar;
   }
}
