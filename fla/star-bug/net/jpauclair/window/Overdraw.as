package net.jpauclair.window
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import net.jpauclair.FlashPreloadProfiler;
   import net.jpauclair.IDisposable;
   
   public class Overdraw extends Sprite implements IDisposable
   {
      
      private static const COLOR_XRAY:int = 11386838;
      
      private static const COLOR_XRAY_INVISIBLE:int = 16733696;
      
      private static const COLOR_ALPHA:Number = 0.3;
      
      private static const COLOR_BACKGROUND:int = 0;
       
      
      private var mMainSprite:Stage = null;
      
      private var mRenderTargetData:BitmapData = null;
      
      private var mRenderTargetDataRect:Rectangle = null;
      
      private var mRenderTarget:Bitmap = null;
      
      private var currentRenderTarget:Sprite;
      
      private var mInfos:TextField;
      
      private var mTimer:Timer;
      
      private var mDOTotal:int = 0;
      
      private var mMaxDepth:int = 0;
      
      private var mLastTick:int = 0;
      
      public function Overdraw(mainSprite:Stage)
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
         var barWidth:int = this.mMainSprite.stageWidth;
         var bgSprite:Sprite = new Sprite();
         bgSprite.graphics.beginFill(0,0.3);
         bgSprite.graphics.drawRect(0,0,barWidth,17);
         bgSprite.graphics.endFill();
         bgSprite.graphics.beginFill(13421772,0.6);
         bgSprite.graphics.drawRect(0,1,barWidth,1);
         bgSprite.graphics.endFill();
         bgSprite.graphics.beginFill(16777215,0.8);
         bgSprite.graphics.drawRect(0,0,barWidth,1);
         bgSprite.graphics.endFill();
         addChild(bgSprite);
         bgSprite.y = this.mMainSprite.stageHeight - bgSprite.height;
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.mInfos = new TextField();
         this.mInfos.autoSize = TextFieldAutoSize.LEFT;
         this.mInfos.defaultTextFormat = myformat;
         this.mInfos.selectable = false;
         this.mInfos.text = "FlashPreloadProfiler";
         this.mInfos.filters = [myglow];
         this.mInfos.x = 2;
         addChild(this.mInfos);
         this.mInfos.y = this.mMainSprite.stageHeight - bgSprite.height;
      }
      
      public function Dispose() : void
      {
         this.mInfos = null;
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
         var text:String = null;
         if(getTimer() - this.mLastTick >= 1000)
         {
            this.mLastTick = getTimer();
            text = "DisplayObjectOnStage[ " + this.mDOTotal + " ]\tMaxDepth[ " + this.mMaxDepth + " ]";
            this.mInfos.text = text;
         }
         this.mRenderTargetData.fillRect(this.mRenderTargetData.rect,COLOR_BACKGROUND);
         this.mMaxDepth = 0;
         this.mDOTotal = 0;
         this.mRenderTargetData.lock();
         this.ParseStage(this.mMainSprite);
         this.mRenderTargetData.unlock();
      }
      
      private function ParseStage(obj:DisplayObjectContainer, depth:int = 1) : void
      {
         var child:DisplayObject = null;
         var rect:Rectangle = null;
         if(obj == null || obj == FlashPreloadProfiler.MySprite)
         {
            return;
         }
         if(this.mMaxDepth < depth)
         {
            this.mMaxDepth = depth;
         }
         for(var i:int = 0; i < obj.numChildren; i++)
         {
            ++this.mDOTotal;
            child = obj.getChildAt(i);
            if(child != null)
            {
               rect = child.getRect(this.mMainSprite);
               rect = rect.intersection(this.mRenderTargetDataRect);
               this.currentRenderTarget.graphics.clear();
               if(child.visible == false || child.alpha == 0)
               {
                  this.currentRenderTarget.graphics.beginFill(COLOR_XRAY_INVISIBLE,COLOR_ALPHA / 6);
               }
               else
               {
                  this.currentRenderTarget.graphics.beginFill(COLOR_XRAY,COLOR_ALPHA / 6);
               }
               this.currentRenderTarget.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
               this.currentRenderTarget.graphics.endFill();
               this.mRenderTargetData.draw(this.currentRenderTarget);
               this.ParseStage(child as DisplayObjectContainer,depth + 1);
            }
         }
      }
   }
}
