package esparragon.display
{
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class ESpriteContainer extends ESprite
   {
       
      
      private var mContents:Dictionary;
      
      public function ESpriteContainer()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         var k:* = null;
         var sprite:ESprite = null;
         if(this.mContents != null)
         {
            for(k in this.mContents)
            {
               sprite = this.mContents[k] as ESprite;
               if(sprite != null)
               {
                  sprite.destroy();
               }
               delete this.mContents[k];
            }
            this.mContents = null;
         }
      }
      
      public function setContent(sku:String, e:ESprite) : void
      {
         var sprite:ESprite = null;
         if(this.mContents == null)
         {
            this.mContents = new Dictionary();
         }
         if(this.mContents[sku] != e)
         {
            sprite = this.mContents[sku] as ESprite;
            if(sprite != null)
            {
               sprite.destroy();
            }
            if(e)
            {
               this.mContents[sku] = e;
            }
            else
            {
               delete this.mContents[sku];
            }
         }
      }
      
      public function getContent(sku:String) : ESprite
      {
         return this.mContents != null ? this.mContents[sku] : null;
      }
      
      public function getContentAsETextField(sku:String) : ETextField
      {
         var content:ESprite = this.getContent(sku);
         return content == null ? null : content as ETextField;
      }
      
      public function getContentAsEFillBar(sku:String) : EFillBar
      {
         var content:ESprite = this.getContent(sku);
         return content == null ? null : content as EFillBar;
      }
      
      public function getContentAsESpriteContainer(sku:String) : ESpriteContainer
      {
         var content:ESprite = this.getContent(sku);
         return content == null ? null : content as ESpriteContainer;
      }
      
      public function getContentAsEImage(sku:String) : EImage
      {
         var content:ESprite = this.getContent(sku);
         return content == null ? null : content as EImage;
      }
      
      public function getContentAsEButton(sku:String) : EButton
      {
         var content:ESprite = this.getContent(sku);
         return content == null ? null : content as EButton;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var k:* = null;
         var sprite:ESprite = null;
         super.logicUpdate(dt);
         if(this.mContents != null)
         {
            for(k in this.mContents)
            {
               sprite = this.mContents[k] as ESprite;
               if(sprite != null)
               {
                  sprite.mTimeSinceLastLogicUpdate += dt;
                  if(!Config.USE_LAZY_LOGIC_UPDATES || sprite.mTimeSinceLastLogicUpdate >= sprite.mLogicUpdateFrequency)
                  {
                     sprite.mTimeSinceLastLogicUpdate = 0;
                     sprite.logicUpdate(dt);
                  }
               }
            }
         }
      }
      
      public function sortChildren(displayObjectContainer:DisplayObjectContainer) : void
      {
         var numChildren:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         var esprite:ESprite = null;
         var parent:ESprite = null;
         if(displayObjectContainer != null)
         {
            numChildren = displayObjectContainer.numChildren;
            for(i = 0; i < numChildren; )
            {
               child = displayObjectContainer.getChildAt(i);
               if((esprite = this.getContent(child.name)) != null && esprite.parent == this)
               {
                  eAddChildAt(esprite,i);
               }
               i++;
            }
         }
      }
      
      public function checkContentsLoaded() : Boolean
      {
         var content:ESprite = null;
         var img:EImage = null;
         var container:ESpriteContainer = null;
         var returnValue:Boolean = true;
         for each(content in this.mContents)
         {
            if(content is EImage)
            {
               img = EImage(content);
               returnValue = img.isTextureLoaded();
            }
            else if(content is ESpriteContainer)
            {
               container = content as ESpriteContainer;
               returnValue = container.checkContentsLoaded();
            }
            if(!returnValue)
            {
               return returnValue;
            }
         }
         return returnValue;
      }
   }
}
