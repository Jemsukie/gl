package esparragon.display
{
   import esparragon.core.Esparragon;
   
   public class EImage extends ESprite
   {
       
      
      protected var mTexture:ETexture;
      
      protected var mOnSetTextureLoaded:Function;
      
      public function EImage(texture:ETexture)
      {
         super();
         this.setTexture(texture);
         this.onSetTextureLoaded = null;
      }
      
      override protected function extendedDestroy() : void
      {
         this.onSetTextureLoaded = null;
         this.setTexture(null);
      }
      
      override protected function poolReturn() : void
      {
         Esparragon.poolReturnEImage(this);
      }
      
      public function set onSetTextureLoaded(value:Function) : void
      {
         this.mOnSetTextureLoaded = value;
         if(this.mOnSetTextureLoaded != null && this.isTextureLoaded())
         {
            this.onSetTextureLoadedCall();
         }
      }
      
      protected function onSetTextureLoadedCall() : void
      {
         this.mOnSetTextureLoaded(this);
      }
      
      public function setTexture(texture:ETexture) : void
      {
         this.mTexture = texture;
      }
      
      public function getTexture() : ETexture
      {
         return this.mTexture;
      }
      
      public function setSmooth(value:Boolean) : void
      {
      }
      
      public function isTextureLoaded() : Boolean
      {
         return this.mTexture != null && this.mTexture.isLoaded();
      }
      
      protected function notifySetTextureData() : void
      {
         if(this.mOnSetTextureLoaded != null && this.mTexture != null && this.mTexture.getData() != null)
         {
            this.onSetTextureLoadedCall();
         }
      }
      
      private function getSubTexture() : ESubTexture
      {
         return this.mTexture != null ? this.mTexture.getSubTexture() : null;
      }
      
      override public function get width() : Number
      {
         var subTexture:ESubTexture = this.getSubTexture();
         if(subTexture != null)
         {
            return subTexture.width;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         var subTexture:ESubTexture = this.getSubTexture();
         if(subTexture != null)
         {
            return subTexture.height;
         }
         return super.height;
      }
      
      public function flipX() : void
      {
      }
      
      public function isFlippedX() : Boolean
      {
         return false;
      }
      
      public function flipY() : void
      {
      }
      
      public function isFlippedY() : Boolean
      {
         return false;
      }
   }
}
