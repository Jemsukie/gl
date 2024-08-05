package net.jpauclair
{
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.sampler.*;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import net.jpauclair.event.ChangeToolEvent;
   import net.jpauclair.ui.button.MenuButton;
   import net.jpauclair.window.Configuration;
   import net.jpauclair.window.FlashStats;
   import net.jpauclair.window.InstancesLifeCycle;
   import net.jpauclair.window.InternalEventsProfiler;
   import net.jpauclair.window.LoaderProfiler;
   import net.jpauclair.window.MouseListeners;
   import net.jpauclair.window.Overdraw;
   import net.jpauclair.window.PerformanceProfiler;
   import net.jpauclair.window.SamplerProfiler;
   import nl.demonsters.debugger.MonsterDebugger;
   
   public class FlashPreloadProfiler extends Sprite
   {
      
      public static var MySprite:Sprite = null;
      
      protected static var MainStage:Stage = null;
      
      public static var MainSprite:Sprite = null;
      
      private static var mInitialized:Boolean = false;
      
      private static var mInstance:FlashPreloadProfiler = null;
      
      private static var mNextTool:Class = null;
      
      private static var mMinimize:Boolean = false;
       
      
      private var debugger:MonsterDebugger;
      
      private var mHookClass:String = "";
      
      private var mTraceFiles:Boolean = false;
      
      private var mLogo:Class;
      
      private var ShowInstancesLifeCycle:InstancesLifeCycle = null;
      
      private var ShowMouseListeners:MouseListeners = null;
      
      private var ShowOverdraw:Overdraw = null;
      
      private var ShowStats:FlashStats = null;
      
      private var ShowConfig:Configuration = null;
      
      private var ShowProfiler:SamplerProfiler = null;
      
      private var ShowPerformanceProfiler:PerformanceProfiler = null;
      
      private var ShowInternalEvents:InternalEventsProfiler = null;
      
      private var ShowLoaderProfiler:LoaderProfiler = null;
      
      private var OptionsLayer:Options = null;
      
      private var mEmbeded:Boolean = false;
      
      private var mStartMonster:Boolean = false;
      
      private var mKeepOnTop:Boolean = false;
      
      public function FlashPreloadProfiler()
      {
         this.mLogo = FlashPreloadProfiler_mLogo;
         super();
         mInstance = this;
         trace("Starting FlashPreloadProfiler!");
         Configuration.Load();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      public static function StaticChangeTool(aButton:MenuButton) : void
      {
         if(aButton == null)
         {
            mMinimize = true;
            return;
         }
         mMinimize = false;
         mNextTool = aButton.mTool;
         if(mInstance.OptionsLayer != null)
         {
            mInstance.OptionsLayer.ResetMenu(aButton);
         }
      }
      
      private function OnEnterFrame(e:Event) : void
      {
         if(MainStage == null)
         {
            return;
         }
         pauseSampling();
         SampleAnalyzer.GetInstance().ProcessSampling();
         LoaderAnalyser.GetInstance().Update();
         if(this.ShowConfig != null)
         {
            this.ShowConfig.Update();
         }
         if(this.OptionsLayer != null)
         {
            this.OptionsLayer.Update();
         }
         if(this.ShowInstancesLifeCycle != null)
         {
            this.ShowInstancesLifeCycle.Update();
         }
         if(this.ShowOverdraw != null)
         {
            this.ShowOverdraw.Update();
         }
         if(this.ShowMouseListeners != null)
         {
            this.ShowMouseListeners.Update();
         }
         if(this.ShowProfiler != null)
         {
            this.ShowProfiler.Update();
         }
         if(this.ShowPerformanceProfiler != null)
         {
            this.ShowPerformanceProfiler.Update();
         }
         if(this.ShowInternalEvents != null)
         {
            this.ShowInternalEvents.Update();
         }
         if(this.ShowLoaderProfiler != null)
         {
            this.ShowLoaderProfiler.Update();
         }
         if(this.ShowStats != null)
         {
            this.ShowStats.Update();
         }
         if(mMinimize)
         {
            this.OptionsLayer.ResetMenu(null);
            this.ClearTools();
            mMinimize = false;
         }
         if(mNextTool != null)
         {
            this.ChangeTool(mNextTool);
            mNextTool = null;
         }
         startSampling();
         clearSamples();
      }
      
      private function init(event:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         trace("Direct (embeded) profiler launch");
         this.SetRoot(this);
         this.TraceLocalParameters(this.loaderInfo);
         if(this.loaderInfo.parameters["HookClass"] != undefined)
         {
            this.mHookClass = this.loaderInfo.parameters["HookClass"];
            trace("Trying to hook to class:",this.mHookClass);
         }
         if(this.loaderInfo.parameters["TraceFiles"] != undefined)
         {
            if(this.loaderInfo.parameters["TraceFiles"] == "true")
            {
               this.mTraceFiles = true;
            }
            trace("Tracing files loaded...");
         }
         if(this.loaderInfo.parameters["MonsterDebugger"] != undefined)
         {
            if(this.loaderInfo.parameters["MonsterDebugger"] == "true")
            {
               this.mStartMonster = true;
            }
            trace("Monster debugger enabled");
         }
         MySprite = this;
         this.mouseEnabled = false;
         this.OptionsLayer = new Options(MainStage);
         addChild(this.OptionsLayer);
      }
      
      private function allCompleteHandler(event:Event) : void
      {
         var loaderInfo:LoaderInfo = null;
         try
         {
            loaderInfo = LoaderInfo(event.target);
            if(this.mTraceFiles)
            {
               trace("File loaded:",loaderInfo.url,"Class:",getQualifiedClassName(loaderInfo.content));
            }
            if(mInitialized)
            {
               return;
            }
            if(loaderInfo.content.root.stage == null)
            {
               trace("File loaded but no stage:",loaderInfo.url);
               return;
            }
            if(this.mHookClass != "" && this.mHookClass != getQualifiedClassName(loaderInfo.content))
            {
               trace("File loaded with stage but wrong class:",loaderInfo.url,getQualifiedClassName(loaderInfo.content));
               return;
            }
            trace("File loaded with stage:",loaderInfo.url,"Class:",getQualifiedClassName(loaderInfo.content));
            this.SetRoot(loaderInfo.content.root as Sprite);
         }
         catch(e:Error)
         {
            trace(e);
         }
      }
      
      private function SetRoot(aSprite:Sprite) : void
      {
         var t:Timer = null;
         root.removeEventListener("allComplete",this.allCompleteHandler);
         try
         {
            MainSprite = aSprite;
            MainStage = MainSprite.stage;
            MainStage.addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
            this.OptionsLayer.SetStage(MainStage);
            MainStage.addChild(this);
            this.TraceLocalParameters(loaderInfo);
            if(this.OptionsLayer != null)
            {
            }
            if(Configuration.PROFILE_MONSTER)
            {
               this.debugger = new MonsterDebugger(MainStage);
               MainStage.addEventListener("DebuggerDisconnected",this.OptionsLayer.OnDebuggerDisconnect);
               MainStage.addEventListener("DebuggerConnected",this.OptionsLayer.OnDebuggerConnect);
            }
            else
            {
               this.OptionsLayer.SetMonsterDisabled();
            }
            if(this.mKeepOnTop)
            {
               t = new Timer(1000,0);
               t.addEventListener(TimerEvent.TIMER,this.OnTimer);
               t.start();
            }
            mInitialized = true;
            SampleAnalyzer.GetInstance().ClearSamples();
         }
         catch(e:Error)
         {
            trace(e);
         }
      }
      
      private function OnChangeTool(e:ChangeToolEvent) : void
      {
         this.ChangeTool(e.mTool);
      }
      
      private function TraceLocalParameters(loaderInfo:LoaderInfo) : void
      {
         var paramName:String = null;
         var paramValue:String = null;
         while(paramName in loaderInfo.parameters)
         {
            paramValue = String(loaderInfo.parameters[paramName]);
            trace("Main Params:",paramName," = ",paramValue);
         }
      }
      
      private function ShowBar(event:ContextMenuEvent) : void
      {
         this.visible = !this.visible;
      }
      
      private function OnTimer(event:TimerEvent) : void
      {
         var menu:ContextMenu = null;
         var alreadyInMenu:Boolean = false;
         var i:int = 0;
         var menuItem:ContextMenuItem = null;
         Mouse.show();
         if(MainStage != null)
         {
            MainStage.addChildAt(this,MainStage.numChildren - 1);
            MainStage.addChildAt(MySprite,MainStage.numChildren - 1);
            return;
         }
      }
      
      private function ClearTools() : void
      {
         if(this.ShowConfig != null)
         {
            this.ShowConfig.Dispose();
            this.ShowConfig = null;
         }
         if(this.ShowInstancesLifeCycle != null)
         {
            this.ShowInstancesLifeCycle.Dispose();
            this.ShowInstancesLifeCycle = null;
         }
         if(this.ShowOverdraw != null)
         {
            this.ShowOverdraw.Dispose();
            this.ShowOverdraw = null;
         }
         if(this.ShowProfiler != null)
         {
            this.ShowProfiler.Dispose();
            this.ShowProfiler = null;
         }
         if(this.ShowPerformanceProfiler != null)
         {
            this.ShowPerformanceProfiler.Dispose();
            this.ShowPerformanceProfiler = null;
         }
         if(this.ShowInternalEvents != null)
         {
            this.ShowInternalEvents.Dispose();
            this.ShowInternalEvents = null;
         }
         if(this.ShowLoaderProfiler != null)
         {
            this.ShowLoaderProfiler.Dispose();
            this.ShowLoaderProfiler = null;
         }
         if(this.ShowMouseListeners != null)
         {
            this.ShowMouseListeners.Dispose();
            this.ShowMouseListeners = null;
         }
         if(this.ShowStats != null)
         {
            this.ShowStats.Dispose();
            this.ShowStats = null;
         }
         Options.mIsCamEnabled = false;
         Options.mIsPerformanceSnaptopEnabled = false;
         Options.mIsLoaderSnaptopEnabled = false;
         Options.mIsSaveEnabled = false;
         Options.mIsClockEnabled = false;
         this.OptionsLayer.ShowInterfaceCustomizer(false);
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.addChild(this.OptionsLayer);
      }
      
      private function ChangeTool(aClass:Class) : void
      {
         this.ClearTools();
         if(aClass == FlashStats)
         {
            Options.mIsSaveEnabled = false;
            this.OptionsLayer.ShowInterfaceCustomizer(true);
            this.ShowStats = new FlashStats(MainStage);
            addChildAt(this.ShowStats,0);
         }
         else if(aClass == InstancesLifeCycle)
         {
            this.ShowInstancesLifeCycle = new InstancesLifeCycle(MainStage);
            addChildAt(this.ShowInstancesLifeCycle,0);
         }
         else if(aClass == Overdraw)
         {
            this.ShowOverdraw = new Overdraw(MainStage);
            addChildAt(this.ShowOverdraw,0);
         }
         else if(aClass == Configuration)
         {
            this.ShowConfig = new Configuration(MainSprite);
            addChildAt(this.ShowConfig,0);
         }
         else if(aClass == SamplerProfiler)
         {
            Options.mIsCamEnabled = true;
            Options.mIsSaveEnabled = true;
            Options.mIsClockEnabled = true;
            this.OptionsLayer.ShowInterfaceCustomizer(true);
            this.ShowProfiler = new SamplerProfiler(MainStage);
            addChildAt(this.ShowProfiler,0);
         }
         else if(aClass == PerformanceProfiler)
         {
            Options.mIsSaveEnabled = true;
            Options.mIsClockEnabled = true;
            Options.mIsPerformanceSnaptopEnabled = true;
            this.OptionsLayer.ShowInterfaceCustomizer(true);
            this.ShowPerformanceProfiler = new PerformanceProfiler(MainStage);
            addChildAt(this.ShowPerformanceProfiler,0);
         }
         else if(aClass == InternalEventsProfiler)
         {
            Options.mIsSaveEnabled = true;
            Options.mIsClockEnabled = true;
            this.OptionsLayer.ShowInterfaceCustomizer(true);
            this.ShowInternalEvents = new InternalEventsProfiler(MainStage);
            addChildAt(this.ShowInternalEvents,0);
         }
         else if(aClass == LoaderProfiler)
         {
            Options.mIsSaveEnabled = true;
            Options.mIsClockEnabled = true;
            Options.mIsLoaderSnaptopEnabled = true;
            this.OptionsLayer.ShowInterfaceCustomizer(true);
            this.ShowLoaderProfiler = new LoaderProfiler(MainStage);
            addChildAt(this.ShowLoaderProfiler,0);
         }
         else if(aClass == MouseListeners)
         {
            this.ShowMouseListeners = new MouseListeners(MainStage);
            addChildAt(this.ShowMouseListeners,0);
         }
      }
   }
}
