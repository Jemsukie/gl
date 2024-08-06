package esparragon.display
{
   import flash.display.BitmapData;
   
   public interface ETexture
   {
       
      
      function destroy() : void;
      
      function getData() : Object;
      
      function setBitmapData(param1:BitmapData, param2:Boolean = true) : void;
      
      function getBitmapData() : BitmapData;
      
      function isLoaded() : Boolean;
      
      function setOffX(param1:int) : void;
      
      function getOffX() : int;
      
      function setOffY(param1:int) : void;
      
      function getOffY() : int;
      
      function setSubTexture(param1:ESubTexture) : void;
      
      function getSubTexture() : ESubTexture;
   }
}
