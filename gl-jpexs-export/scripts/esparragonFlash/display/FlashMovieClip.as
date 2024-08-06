package esparragonFlash.display
{
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Transform;
   
   public class FlashMovieClip extends EMovieClip
   {
       
      
      private var mMovieClip:MovieClip;
      
      public function FlashMovieClip()
      {
         super();
      }
      
      override protected function extendedSetMovieClip(movieClipClass:Class) : void
      {
         if(movieClipClass != null)
         {
            if(this.mMovieClip != null)
            {
               removeChild(this.mMovieClip);
               this.mMovieClip = null;
            }
            this.mMovieClip = new movieClipClass();
            addChild(this.mMovieClip);
         }
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mMovieClip = null;
      }
      
      override public function isTextureLoaded() : Boolean
      {
         return this.mMovieClip != null;
      }
      
      override public function changeInstance(instanceName:String, dsp:ESprite) : void
      {
         var index:int = 0;
         var transform:Transform = null;
         var child:DisplayObject;
         if((child = this.mMovieClip.getChildByName(instanceName)) != null)
         {
            index = this.mMovieClip.getChildIndex(child);
            transform = child.transform;
            dsp.transform = transform;
            dsp.logicX = child.x;
            dsp.logicY = child.y;
            dsp.alpha = child.alpha;
            dsp.filters = child.filters;
            child.visible = false;
            if(!this.mMovieClip.contains(dsp))
            {
               this.mMovieClip.addChildAt(dsp,index);
            }
         }
         else if(this.mMovieClip.contains(dsp))
         {
            this.mMovieClip.removeChild(dsp);
         }
      }
   }
}
