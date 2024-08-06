package esparragon.resources
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.widgets.EButton;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class EPool
   {
       
      
      protected var mImagesProfileFromUrl:Dictionary;
      
      public function EPool()
      {
         super();
      }
      
      public function destroy() : void
      {
         var k:* = null;
         if(this.mImagesProfileFromUrl != null)
         {
            for(k in this.mImagesProfileFromUrl)
            {
               delete this.mImagesProfileFromUrl[k];
            }
            this.mImagesProfileFromUrl = null;
         }
      }
      
      public function returnESprite(value:ESprite) : void
      {
         var parent:DisplayObjectContainer = null;
         var eParent:ESprite = null;
         if(value != null)
         {
            if(value.parent != null)
            {
               parent = value.parent;
               if(parent != null)
               {
                  eParent = parent as ESprite;
                  if(eParent != null)
                  {
                     eParent.eRemoveChild(value);
                  }
                  else
                  {
                     parent.removeChild(value);
                  }
               }
            }
         }
      }
      
      public function returnETextField(value:ETextField) : void
      {
         if(value != null)
         {
            this.returnESprite(value);
            InstanceMng.getEResourcesMng().returnETextField(value);
         }
      }
      
      public function returnEImage(image:EImage) : void
      {
         var disposeTexture:Boolean = false;
         var url:String = null;
         var texture:ETexture = null;
         if(image != null)
         {
            this.returnESprite(image);
            disposeTexture = false;
            if(this.mImagesProfileFromUrl != null && this.mImagesProfileFromUrl[image] != null)
            {
               url = String(this.mImagesProfileFromUrl[image]);
               InstanceMng.getGraphicsCacheMng().removeUsage(url);
               texture = image.getTexture();
               if(texture != null)
               {
                  texture.setBitmapData(null,false);
                  texture.destroy();
               }
               delete this.mImagesProfileFromUrl[image];
               disposeTexture = false;
            }
            InstanceMng.getEResourcesMng().returnEImage(image,disposeTexture);
         }
      }
      
      public function returnEMovieClip(movieClip:EMovieClip) : void
      {
         this.returnESprite(movieClip);
         InstanceMng.getEResourcesMng().returnEMovieClip(movieClip);
      }
      
      public function returnButton(button:EButton) : void
      {
         InstanceMng.getViewFactory().removeButtonBehaviors(button);
         this.returnETextField(button.getTextField());
         this.returnEImage(button.getIcon());
         this.returnEImage(button.getBackground());
      }
   }
}
