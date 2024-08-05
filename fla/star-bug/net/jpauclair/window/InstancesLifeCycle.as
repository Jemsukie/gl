package net.jpauclair.window
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.jpauclair.FlashPreloadProfiler;
   import net.jpauclair.IDisposable;
   
   public class InstancesLifeCycle extends Sprite implements IDisposable
   {
      
      private static const COLOR_CREATE:int = 15900421;
      
      private static const COLOR_RE_USE:int = 15539267;
      
      private static const COLOR_REMOVED:int = 6595830;
      
      private static const COLOR_WAITING_GC:int = 11665297;
      
      private static const COLOR_ALPHA:Number = 0.3;
      
      private static const COLOR_BACKGROUND:int = 4473924;
       
      
      private var mMainSprite:Stage = null;
      
      private var mAssetsDict:Dictionary = null;
      
      private var renderTarget1:Shape = null;
      
      private var renderTarget2:Shape = null;
      
      private var currentRenderTarget:Shape = null;
      
      private var mLegend:Sprite = null;
      
      private var mInfos:TextField;
      
      private var mLegendTxt:Array = null;
      
      private var mAddedLastSecond:int = 0;
      
      private var mRemovedLastSecond:int = 0;
      
      private var mDOTotal:int = 0;
      
      private var mDOToCollect:int = 0;
      
      private var mLastTick:int = 0;
      
      public function InstancesLifeCycle(mainSprite:Stage)
      {
         super();
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         this.mMainSprite = mainSprite;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.mLegend = new Sprite();
         this.mAssetsDict = new Dictionary(true);
         this.renderTarget1 = new Shape();
         this.renderTarget2 = new Shape();
         this.currentRenderTarget = this.renderTarget2;
         this.addChild(this.renderTarget1);
         this.addChild(this.renderTarget2);
         this.mLegend.y = this.mMainSprite.stageHeight - 28;
         this.mLegend.graphics.clear();
         this.mLegend.graphics.beginFill(COLOR_CREATE,1);
         this.mLegend.graphics.drawRect(2,0,10,7);
         this.mLegend.graphics.endFill();
         this.mLegend.graphics.beginFill(COLOR_RE_USE,1);
         this.mLegend.graphics.drawRect(2 + 60,0,10,7);
         this.mLegend.graphics.endFill();
         this.mLegend.graphics.beginFill(COLOR_REMOVED,1);
         this.mLegend.graphics.drawRect(2 + 120,0,10,7);
         this.mLegend.graphics.endFill();
         this.mLegend.graphics.beginFill(COLOR_WAITING_GC,1);
         this.mLegend.graphics.drawRect(2 + 180,0,10,7);
         this.mLegend.graphics.endFill();
         addChild(this.mLegend);
         this.mLegend.alpha = 0.5;
         this.mMainSprite.addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,true);
         this.mMainSprite.addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedToStage,true);
         this.swapChildren(this.renderTarget1,this.renderTarget2);
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
         var myformatSmall:TextFormat = new TextFormat("_sans",9,16777215,false);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.mInfos = new TextField();
         this.mInfos.autoSize = TextFieldAutoSize.LEFT;
         this.mInfos.defaultTextFormat = myformat;
         this.mInfos.selectable = false;
         this.mInfos.text = "";
         this.mInfos.filters = [myglow];
         this.mInfos.x = 2;
         addChild(this.mInfos);
         this.mInfos.y = this.mMainSprite.stageHeight - bgSprite.height;
         this.mLegendTxt = [new TextField(),new TextField(),new TextField(),new TextField()];
         for(var i:int = 0; i < 4; i++)
         {
            this.mLegendTxt[i].autoSize = TextFieldAutoSize.LEFT;
            this.mLegendTxt[i].defaultTextFormat = myformatSmall;
            this.mLegendTxt[i].selectable = false;
            this.mLegendTxt[i].filters = [myglow];
            this.mLegend.addChild(this.mLegendTxt[i]);
            this.mLegendTxt[i].y = -4;
         }
         this.mLegendTxt[0].x = 12;
         this.mLegendTxt[0].text = "Create";
         this.mLegendTxt[1].x = 12 + 60;
         this.mLegendTxt[1].text = "Re-Use";
         this.mLegendTxt[2].x = 12 + 120;
         this.mLegendTxt[2].text = "Removed";
         this.mLegendTxt[3].x = 12 + 180;
         this.mLegendTxt[3].text = "Waiting GC";
         this.ParseStage(this.mMainSprite);
      }
      
      public function Dispose() : void
      {
         var i:int = 0;
         for(this.mInfos = null; i < this.mLegendTxt.length; )
         {
            this.mLegend.removeChild(this.mLegendTxt[i]);
            this.mLegendTxt[i] = null;
            i++;
         }
         removeChild(this.mLegend);
         this.mLegend = null;
         if(this.mMainSprite != null && this.mMainSprite != null)
         {
            this.mMainSprite.removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,true);
            this.mMainSprite.removeEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedToStage,true);
            this.mMainSprite = null;
         }
         this.mAssetsDict = null;
         this.renderTarget1 = null;
         this.renderTarget2 = null;
         this.currentRenderTarget = null;
      }
      
      private function SwapRenderTarget() : void
      {
         if(this.currentRenderTarget == this.renderTarget1)
         {
            this.currentRenderTarget = this.renderTarget2;
         }
         else
         {
            this.currentRenderTarget = this.renderTarget1;
         }
         this.swapChildren(this.renderTarget1,this.renderTarget2);
      }
      
      public function Update() : void
      {
         var obj3:Object = null;
         var text:String = null;
         this.SwapRenderTarget();
         if(getTimer() - this.mLastTick >= 1000)
         {
            this.mLastTick = getTimer();
            text = "DisplayObjectOnStage[ " + this.mDOTotal + " ]\tAddedToStage[ " + this.mAddedLastSecond + " ]\tRemovedFromStage[ " + this.mRemovedLastSecond + " ]\tWaitingGC[ " + this.mDOToCollect + " ]";
            this.mInfos.text = text;
            this.mDOTotal = this.mDOTotal + this.mAddedLastSecond - this.mRemovedLastSecond;
            this.mRemovedLastSecond = this.mAddedLastSecond = 0;
         }
         this.currentRenderTarget.graphics.clear();
         this.currentRenderTarget.graphics.beginFill(COLOR_BACKGROUND,COLOR_ALPHA / 1);
         this.currentRenderTarget.graphics.drawRect(0,0,this.mMainSprite.stageWidth,this.mMainSprite.stageHeight);
         this.currentRenderTarget.graphics.endFill();
         var rect:Rectangle = null;
         this.mDOToCollect = 0;
         for(obj3 in this.mAssetsDict)
         {
            if(obj3.stage != null && this.mAssetsDict[obj3] == false)
            {
               ++this.mDOToCollect;
               rect = obj3.getRect(this.mMainSprite);
               this.currentRenderTarget.graphics.beginFill(COLOR_WAITING_GC,COLOR_ALPHA / 4);
               this.currentRenderTarget.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
               this.currentRenderTarget.graphics.endFill();
            }
         }
      }
      
      private function OnAddedToStage(e:Event) : void
      {
         var obj:DisplayObject = e.target as DisplayObject;
         if(obj == this.mMainSprite)
         {
            return;
         }
         if(obj == FlashPreloadProfiler.MySprite)
         {
            return;
         }
         var rect:Rectangle = obj.getRect(this.mMainSprite);
         var newObj:Boolean = true;
         if(this.mAssetsDict[obj] == true)
         {
            newObj = false;
         }
         if(newObj)
         {
            ++this.mAddedLastSecond;
            this.currentRenderTarget.graphics.beginFill(COLOR_CREATE,0.9);
            if(rect.width < 8 && rect.width < 8)
            {
               this.currentRenderTarget.graphics.drawCircle(rect.x,rect.y,4);
            }
            else
            {
               this.currentRenderTarget.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
            }
            this.currentRenderTarget.graphics.endFill();
            this.mAssetsDict[obj] = true;
         }
         else
         {
            this.currentRenderTarget.graphics.beginFill(COLOR_RE_USE,0.9);
            if(rect.width < 8 && rect.width < 8)
            {
               this.currentRenderTarget.graphics.drawCircle(rect.x,rect.y,4);
            }
            else
            {
               this.currentRenderTarget.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
            }
            this.currentRenderTarget.graphics.endFill();
         }
      }
      
      private function OnRemovedToStage(e:Event) : void
      {
         var obj:DisplayObject = e.target as DisplayObject;
         if(obj == this.mMainSprite)
         {
            return;
         }
         if(obj == FlashPreloadProfiler.MySprite)
         {
            return;
         }
         if(this.mAssetsDict[obj] == true)
         {
            ++this.mRemovedLastSecond;
         }
         var rect:Rectangle = obj.getRect(this.mMainSprite);
         this.currentRenderTarget.graphics.beginFill(COLOR_REMOVED,0.9);
         this.currentRenderTarget.graphics.drawRect(rect.x - 2,rect.y - 2,rect.width + 4,rect.height + 4);
         this.currentRenderTarget.graphics.endFill();
         this.mAssetsDict[obj] = false;
      }
      
      private function ParseStage(obj:DisplayObjectContainer) : void
      {
         if(obj == null || obj == FlashPreloadProfiler.MySprite)
         {
            return;
         }
         for(var i:int = 0; i < obj.numChildren; i++)
         {
            ++this.mDOTotal;
            this.ParseStage(obj.getChildAt(i) as DisplayObjectContainer);
         }
      }
   }
}
