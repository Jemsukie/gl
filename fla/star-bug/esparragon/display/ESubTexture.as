package esparragon.display
{
   import esparragon.utils.EUtils;
   import flash.geom.Rectangle;
   
   public class ESubTexture
   {
       
      
      private var mClipRectangle:Rectangle;
      
      private var mFrameX:int;
      
      private var mFrameY:int;
      
      private var mFrameWidth:int;
      
      private var mFrameHeight:int;
      
      public function ESubTexture()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.mClipRectangle = null;
      }
      
      public function fromXml(frameXml:XML) : void
      {
         var x:int = EUtils.xmlReadInt(frameXml,"x");
         var y:int = EUtils.xmlReadInt(frameXml,"y");
         var width:int = EUtils.xmlReadInt(frameXml,"width");
         var height:int = EUtils.xmlReadInt(frameXml,"height");
         this.mFrameX = EUtils.xmlReadInt(frameXml,"frameX");
         this.mFrameY = EUtils.xmlReadInt(frameXml,"frameY");
         this.mFrameWidth = EUtils.xmlReadInt(frameXml,"frameWidth");
         this.mFrameHeight = EUtils.xmlReadInt(frameXml,"frameHeight");
         this.mClipRectangle = new Rectangle(x,y,width,height);
      }
      
      public function get clipRectangle() : Rectangle
      {
         return this.mClipRectangle;
      }
      
      public function get frameX() : int
      {
         return this.mFrameX;
      }
      
      public function get frameY() : int
      {
         return this.mFrameY;
      }
      
      public function get width() : int
      {
         return this.mClipRectangle == null ? 0 : int(this.mClipRectangle.width);
      }
      
      public function get height() : int
      {
         return this.mClipRectangle == null ? 0 : int(this.mClipRectangle.height);
      }
   }
}
