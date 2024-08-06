package com.dchoc.toolkit.view.gui.popups
{
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class DCContent extends DCComponentUI implements DCIContent
   {
       
      
      protected var mBox:DisplayObjectContainer;
      
      protected var mBase:DisplayObject;
      
      protected var mBaseX:Number = 0;
      
      protected var mBaseY:Number = 0;
      
      protected var mBaseW:Number = 0;
      
      protected var mBaseH:Number = 0;
      
      public function DCContent(box:DisplayObjectContainer = null)
      {
         super();
         this.setBoxAndBuild(box);
      }
      
      protected function setBoxAndBuild(box:DisplayObjectContainer) : void
      {
         if(box != null)
         {
            this.mBox = box;
            if(this.mBox is MovieClip)
            {
               MovieClip(this.mBox).stop();
            }
            this.mBox.cacheAsBitmap = true;
            this.mBase = this.mBox.getChildByName("base");
            if(this.mBase != null)
            {
               this.mBaseX = this.mBase.x;
               this.mBaseY = this.mBase.y;
               this.mBaseW = this.mBase.width;
               this.mBaseH = this.mBase.height;
            }
         }
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
      }
      
      protected function performOtherChecks(child:DisplayObject) : void
      {
      }
      
      public function resize() : void
      {
      }
      
      public function destroy() : void
      {
      }
      
      public function getForm() : DisplayObjectContainer
      {
         return this.mBox;
      }
      
      public function setXYWH(x:Number, y:Number, w:Number, h:Number) : void
      {
         this.mBox.x = x;
         this.mBox.y = y;
         this.mBox.width = w;
         this.mBox.height = h;
      }
      
      public function setX(x:Number) : void
      {
         this.mBox.x = x;
      }
      
      public function setY(y:Number) : void
      {
         this.mBox.y = y;
      }
      
      public function fillInfo(contentInfo:*, idx0:int = 0) : void
      {
      }
      
      public function removeViewElements() : void
      {
      }
      
      public function replaceChild(child:DisplayObject, replacement:DisplayObject) : void
      {
         var index:int = 0;
         replacement.x = child.x;
         replacement.y = child.y;
         replacement.name = child.name;
         if(this.mBox.contains(child))
         {
            index = this.mBox.getChildIndex(child);
            if(index > -1)
            {
               this.mBox.removeChildAt(index);
               this.mBox.addChildAt(replacement,index);
            }
         }
      }
      
      public function setLoadingBoxInstance(child:DisplayObject) : DisplayObjectContainer
      {
         var myClass:Class = EmbeddedAssets.LoadingAnim#1;
         var loadingTimeBox:DisplayObjectContainer = new myClass();
         this.replaceChild(child,loadingTimeBox);
         return loadingTimeBox;
      }
   }
}
