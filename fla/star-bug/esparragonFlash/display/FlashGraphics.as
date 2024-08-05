package esparragonFlash.display
{
   import esparragon.display.EGraphics;
   
   public class FlashGraphics extends EGraphics
   {
       
      
      public function FlashGraphics()
      {
         super();
      }
      
      override public function drawRect(width:Number, height:Number, color:uint = 0) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(color,1);
         this.graphics.drawRect(0,0,width,height);
         this.graphics.endFill();
      }
   }
}
