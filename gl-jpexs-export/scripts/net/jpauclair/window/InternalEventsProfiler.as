package net.jpauclair.window
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import net.jpauclair.IDisposable;
   import net.jpauclair.Options;
   import net.jpauclair.SampleAnalyzer;
   import net.jpauclair.data.InternalEventsStatsHolder;
   
   public class InternalEventsProfiler extends Bitmap implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
      
      private static const VERIFY_COLOR:uint = 4278255615;
      
      private static const REAP_COLOR:uint = 4284887040;
      
      private static const MARK_COLOR:uint = 4294962980;
      
      private static const SWEEP_COLOR:uint = 4293394432;
      
      private static const ENTER_FRAME_COLOR:uint = 4289583566;
      
      private static const TIMERS_COLOR:uint = 4279978900;
      
      private static const PRE_RENDER_COLOR:uint = 4286272171;
      
      private static const RENDER_COLOR:uint = 4278242675;
      
      private static const AVM1_COLOR:uint = 4285430294;
      
      private static const IO_COLOR:uint = 4280475136;
      
      private static const MOUSE_COLOR:uint = 4294901976;
      
      private static const EXECUTE_QUEUE_COLOR:uint = 4294967295;
      
      private static const FREE_COLOR:uint = 4294967295;
       
      
      private var mMainSprite:Stage = null;
      
      private var mInternalEventsLabels:TextField;
      
      private var mFrameDivisionData:BitmapData = null;
      
      private var mFrameDivision:Bitmap = null;
      
      private var mInterface:Sprite = null;
      
      private var mBitmapBackgroundData:BitmapData = null;
      
      private var mBitmapBackground:Bitmap = null;
      
      private var frameCount:int = 0;
      
      private var mLastTime:int = 0;
      
      private var mProfilerWasActive:Boolean = false;
      
      public function InternalEventsProfiler(mainSprite:Stage)
      {
         super();
         this.mProfilerWasActive = Configuration.PROFILE_INTERNAL_EVENTS;
         Configuration.PROFILE_INTERNAL_EVENTS = true;
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         var txtField:TextField = null;
         this.mMainSprite = mainSprite;
         this.mInterface = new Sprite();
         this.mBitmapBackgroundData = new BitmapData(this.mMainSprite.stageWidth,this.mMainSprite.stageHeight,true,0);
         this.bitmapData = this.mBitmapBackgroundData;
         var barWidth:int = this.mMainSprite.stageWidth;
         var bgSprite:Sprite = new Sprite();
         this.mInterface.graphics.beginFill(0,1);
         this.mInterface.graphics.drawRect(0,18,barWidth,this.mMainSprite.stageHeight - 18);
         this.mInterface.graphics.endFill();
         this.mInterface.graphics.beginFill(13421772,1);
         this.mInterface.graphics.drawRect(0,19,barWidth,1);
         this.mInterface.graphics.endFill();
         this.mInterface.graphics.beginFill(16777215,1);
         this.mInterface.graphics.drawRect(0,18,barWidth,1);
         this.mInterface.graphics.endFill();
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myformat2:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.RIGHT);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         var yPos:int = 22;
         this.mFrameDivisionData = new BitmapData(mainSprite.stageWidth,mainSprite.stageHeight - 50 - 22,false,0);
         this.mFrameDivision = new Bitmap(this.mFrameDivisionData);
         this.mInterface.addChild(this.mFrameDivision);
         this.mFrameDivision.x = 0;
         this.mFrameDivision.y = mainSprite.stageHeight - this.mFrameDivisionData.height;
         var mEventsHeaderData:BitmapData = new BitmapData(mainSprite.stageWidth,50,false,0);
         var mEventsHeader:Bitmap = new Bitmap(mEventsHeaderData);
         mEventsHeader.y = 22;
         this.mInterface.addChild(mEventsHeader);
         var rect:Rectangle = new Rectangle();
         rect.width = rect.height = 10;
         this.mInternalEventsLabels = new TextField();
         this.mInternalEventsLabels.autoSize = TextFieldAutoSize.LEFT;
         this.mInternalEventsLabels.defaultTextFormat = myformat;
         this.mInternalEventsLabels.selectable = false;
         this.mInternalEventsLabels.filters = [myglow];
         var m:Matrix = new Matrix();
         m.identity();
         rect.x = 4;
         rect.y = 2;
         mEventsHeaderData.fillRect(rect,VERIFY_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "VERIFY";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 1 * 100;
         rect.y = 2;
         mEventsHeaderData.fillRect(rect,MARK_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "MARK";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 2 * 100;
         rect.y = 2;
         mEventsHeaderData.fillRect(rect,REAP_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "REAP";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 3 * 100;
         rect.y = 2;
         mEventsHeaderData.fillRect(rect,SWEEP_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "SWEEP";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4;
         rect.y = 2 + 1 * 14;
         mEventsHeaderData.fillRect(rect,ENTER_FRAME_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "ENTER FRAME";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 1 * 100;
         rect.y = 2 + 1 * 14;
         mEventsHeaderData.fillRect(rect,TIMERS_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "TIMERS";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 2 * 100;
         rect.y = 2 + 1 * 14;
         mEventsHeaderData.fillRect(rect,PRE_RENDER_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "PRE-RENDER";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 3 * 100;
         rect.y = 2 + 1 * 14;
         mEventsHeaderData.fillRect(rect,RENDER_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "RENDER";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 0 * 100;
         rect.y = 2 + 2 * 14;
         mEventsHeaderData.fillRect(rect,AVM1_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "AVM1";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 1 * 100;
         rect.y = 2 + 2 * 14;
         mEventsHeaderData.fillRect(rect,IO_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "IO";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 2 * 100;
         rect.y = 2 + 2 * 14;
         mEventsHeaderData.fillRect(rect,MOUSE_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "MOUSE";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 4 + 3 * 100;
         rect.y = 2 + 2 * 14;
         mEventsHeaderData.fillRect(rect,EXECUTE_QUEUE_COLOR);
         m.tx = rect.x + 12;
         m.ty = rect.y - 4;
         this.mInternalEventsLabels.text = "FREE";
         mEventsHeaderData.draw(this.mInternalEventsLabels,m);
         rect.x = 0;
         rect.y = mEventsHeaderData.height - 5;
         rect.width = mEventsHeaderData.width;
         rect.height = 3;
         mEventsHeaderData.fillRect(rect,4287137928);
         rect.x = 0;
         rect.y = mEventsHeaderData.height - 4;
         rect.width = mEventsHeaderData.width;
         rect.height = 1;
         mEventsHeaderData.fillRect(rect,4294967295);
         if(mainSprite.loaderInfo.applicationDomain.hasDefinition("flash.sampler.setSamplerCallback"))
         {
         }
      }
      
      public function Update() : void
      {
         if(this.frameCount++ % Options.mCurrentClock != 0)
         {
            return;
         }
         var diff:int = getTimer() - this.mLastTime;
         this.mLastTime = getTimer();
         SampleAnalyzer.GetInstance().PauseSampling();
         SampleAnalyzer.GetInstance().ProcessSampling();
         var internalEvents:InternalEventsStatsHolder = SampleAnalyzer.GetInstance().GetInternalsEvents();
         var totalTime:Number = internalEvents.FrameTime;
         var lastX:uint = 0;
         var ratio:uint = 0;
         this.mFrameDivisionData.scroll(0,4);
         ratio = Math.ceil(internalEvents.mVerify.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),VERIFY_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mMark.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),MARK_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mReap.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),REAP_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mSweep.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),SWEEP_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mEnterFrame.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),ENTER_FRAME_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mTimers.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),TIMERS_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mPreRender.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),PRE_RENDER_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mRender.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),RENDER_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mFree.entryTime / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,ratio,2),FREE_COLOR);
         lastX += ratio;
         ratio = Math.ceil(internalEvents.mFree.entryCount * 33 / totalTime * this.mFrameDivisionData.width);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX,0,1,2),4278190080);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX + 1,0,1,2),4294967295);
         this.mFrameDivisionData.fillRect(new Rectangle(lastX + 2,0,1,2),4278190080);
         internalEvents.ResetFrame();
         this.Render();
      }
      
      private function Render() : void
      {
         this.mBitmapBackgroundData.lock();
         this.mBitmapBackgroundData.floodFill(0,0,0);
         this.mBitmapBackgroundData.draw(this.mInterface,null);
         this.mBitmapBackgroundData.unlock(this.mBitmapBackgroundData.rect);
         this.alpha = Options.mCurrentGradient / 10;
         this.cacheAsBitmap = true;
      }
      
      public function Dispose() : void
      {
         Configuration.PROFILE_INTERNAL_EVENTS = this.mProfilerWasActive;
         this.mInterface.graphics.clear();
         this.mInternalEventsLabels = null;
         this.mFrameDivisionData = null;
         this.mFrameDivision = null;
         this.mInterface = null;
         this.mBitmapBackgroundData = null;
         this.mBitmapBackground = null;
         if(this.mMainSprite != null && this.mMainSprite != null)
         {
            this.mMainSprite = null;
         }
      }
   }
}
