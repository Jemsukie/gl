package net.jpauclair.window
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.jpauclair.FlashPreloadProfiler;
   import net.jpauclair.IDisposable;
   
   public class MouseListeners extends Sprite implements IDisposable
   {
      
      private static const COLOR_MOVE:int = 11665297;
      
      private static const COLOR_CLICK:int = 15900421;
      
      private static const COLOR_XRAY:int = 11386838;
      
      private static const COLOR_ALPHA:Number = 0.3;
      
      private static const COLOR_BACKGROUND:int = 0;
       
      
      private var mMainSprite:Stage = null;
      
      private var mRenderTargetData:BitmapData = null;
      
      private var mRenderTarget:Bitmap = null;
      
      private var mRenderTargetDataRect:Rectangle = null;
      
      private var currentRenderTarget:Sprite;
      
      public function MouseListeners(mainSprite:Stage)
      {
         this.currentRenderTarget = new Sprite();
         super();
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         this.mMainSprite = mainSprite;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.mRenderTargetData = new BitmapData(this.mMainSprite.stageWidth,this.mMainSprite.stageHeight,false,0);
         this.mRenderTargetDataRect = this.mRenderTargetData.rect;
         this.mRenderTarget = new Bitmap();
         this.mRenderTarget.bitmapData = this.mRenderTargetData;
         this.addChild(this.mRenderTarget);
      }
      
      public function Dispose() : void
      {
         if(this.mRenderTarget != null)
         {
            this.mRenderTarget.bitmapData = null;
            this.mRenderTarget = null;
         }
         if(this.mRenderTargetData != null)
         {
            this.mRenderTargetData.dispose();
            this.mRenderTargetData = null;
         }
         this.mRenderTargetDataRect = null;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.mMainSprite = null;
         this.currentRenderTarget = null;
      }
      
      public function Update() : void
      {
         this.mRenderTargetData.fillRect(this.mRenderTargetData.rect,COLOR_BACKGROUND);
         this.mRenderTargetData.lock();
         this.ParseStage(this.mMainSprite);
         this.mRenderTargetData.unlock();
      }
      
      protected function ParseStage(obj:DisplayObjectContainer) : void
      {
         var child:DisplayObject = null;
         var iobj:InteractiveObject = null;
         var rect:Rectangle = null;
         if(obj == null || obj == FlashPreloadProfiler.MySprite)
         {
            return;
         }
         if(obj.mouseChildren == false)
         {
            return;
         }
         for(var i:int = 0; i < obj.numChildren; i++)
         {
            child = obj.getChildAt(i);
            if(child != null)
            {
               iobj = child as InteractiveObject;
               if(!(iobj == null || iobj.mouseEnabled == false))
               {
                  rect = child.getRect(this.mMainSprite);
                  rect = rect.intersection(this.mRenderTargetDataRect);
                  this.currentRenderTarget.graphics.clear();
                  if(iobj.hasEventListener(MouseEvent.CLICK) || iobj.hasEventListener(MouseEvent.MOUSE_DOWN) || iobj.hasEventListener(MouseEvent.MOUSE_UP))
                  {
                     this.currentRenderTarget.graphics.beginFill(COLOR_CLICK,COLOR_ALPHA / 2);
                  }
                  else if(iobj.hasEventListener(MouseEvent.MOUSE_MOVE) || iobj.hasEventListener(MouseEvent.MOUSE_OVER) || iobj.hasEventListener(MouseEvent.MOUSE_OUT))
                  {
                     this.currentRenderTarget.graphics.beginFill(COLOR_MOVE,COLOR_ALPHA / 2);
                  }
                  else
                  {
                     this.currentRenderTarget.graphics.beginFill(COLOR_XRAY,COLOR_ALPHA / 2);
                  }
                  this.currentRenderTarget.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
                  this.currentRenderTarget.graphics.endFill();
                  this.mRenderTargetData.draw(this.currentRenderTarget);
                  this.ParseStage(child as DisplayObjectContainer);
               }
            }
         }
      }
   }
}
