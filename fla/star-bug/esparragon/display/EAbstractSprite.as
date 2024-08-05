package esparragon.display
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class EAbstractSprite extends Sprite
   {
       
      
      private var mInitialColorTransform:ColorTransform;
      
      private var mColorTransformsStack:Vector.<ColorTransform>;
      
      public function EAbstractSprite()
      {
         super();
         this.mInitialColorTransform = this.transform.colorTransform;
         this.mColorTransformsStack = new Vector.<ColorTransform>(0);
      }
      
      public function eAddChild(child:EAbstractSprite) : EAbstractSprite
      {
         this.addChild(child as Sprite);
         return child;
      }
      
      public function eAddChildAt(child:EAbstractSprite, index:int) : void
      {
         this.addChildAt(child as Sprite,index);
      }
      
      public function eRemoveChild(child:EAbstractSprite, checkContains:Boolean = true) : void
      {
         if(!checkContains || this.contains(child))
         {
            this.removeChild(child as Sprite);
         }
      }
      
      public function eRemoveAllChildren() : void
      {
         while(this.numChildren)
         {
            this.removeChildAt(0);
         }
      }
      
      public function eContains(child:EAbstractSprite) : Boolean
      {
         return this.contains(child as Sprite);
      }
      
      public function eGetChildAt(index:int) : ESprite
      {
         return getChildAt(index) as ESprite;
      }
      
      public function eGetChildIndex(child:EAbstractSprite) : int
      {
         return getChildIndex(child as Sprite);
      }
      
      public function setColor(color:uint, t:Number) : void
      {
         var start:ColorTransform = this.transform.colorTransform;
         var end:ColorTransform = new ColorTransform();
         var result:ColorTransform = new ColorTransform();
         end.color = color;
         result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier) * t;
         result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier) * t;
         result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier) * t;
         result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier) * t;
         result.redOffset = start.redOffset + (end.redOffset - start.redOffset) * t;
         result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset) * t;
         result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset) * t;
         result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * t;
         this.mColorTransformsStack.push(result);
         this.transform.colorTransform = result;
      }
      
      public function rollbackColor() : void
      {
         var color:ColorTransform = null;
         this.mColorTransformsStack.pop();
         if(this.mColorTransformsStack.length)
         {
            color = this.mColorTransformsStack[this.mColorTransformsStack.length - 1];
         }
         else
         {
            color = this.mInitialColorTransform;
         }
         this.transform.colorTransform = color;
      }
      
      public function resetColor() : void
      {
         this.transform.colorTransform = this.mInitialColorTransform;
         this.mColorTransformsStack.length = 0;
      }
      
      public function setMask(theMask:DisplayObject) : void
      {
         mask = theMask;
      }
      
      public function destroyMask() : void
      {
         if(mask != null)
         {
            if(contains(mask))
            {
               removeChild(mask);
            }
            mask = null;
         }
      }
   }
}
