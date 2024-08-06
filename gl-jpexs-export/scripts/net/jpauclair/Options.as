package net.jpauclair
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.sampler.pauseSampling;
   import flash.sampler.startSampling;
   import flash.system.System;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import net.jpauclair.data.ClassTypeStatsHolder;
   import net.jpauclair.data.InternalEventEntry;
   import net.jpauclair.data.LoaderData;
   import net.jpauclair.event.ChangeToolEvent;
   import net.jpauclair.ui.ToolTip;
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
   
   public class Options extends Sprite
   {
      
      private static const COLOR_MOUSE_OVER:int = 16771191;
      
      private static const COLOR_MOUSE_OUT:int = 13421772;
      
      private static const COLOR_SELECTED:int = 15906565;
      
      public static var IconConfig:Class = Options_IconConfig;
      
      public static var IconConfigOut:Class = Options_IconConfigOut;
      
      public static var IconProfiler:Class = Options_IconProfiler;
      
      public static var IconProfilerOut:Class = Options_IconProfilerOut;
      
      public static var IconOverdraw:Class = Options_IconOverdraw;
      
      public static var IconOverdrawOut:Class = Options_IconOverdrawOut;
      
      public static var IconLifeCycle:Class = Options_IconLifeCycle;
      
      public static var IconLifeCyclesOut:Class = Options_IconLifeCyclesOut;
      
      public static var IconMouse:Class = Options_IconMouse;
      
      public static var IconMouseOut:Class = Options_IconMouseOut;
      
      public static var IconPercent:Class = Options_IconPercent;
      
      public static var IconPercentOut:Class = Options_IconPercentOut;
      
      public static var IconStats:Class = Options_IconStats;
      
      public static var IconStatsOut:Class = Options_IconStatsOut;
      
      public static var IconLoaders:Class = Options_IconLoaders;
      
      public static var IconLoadersOut:Class = Options_IconLoadersOut;
      
      public static var DebugerIcon:Class = Options_DebugerIcon;
      
      public static var DebugerIconDisable:Class = Options_DebugerIconDisable;
      
      public static var IconMonster:Class = Options_IconMonster;
      
      public static var IconMonsterOut:Class = Options_IconMonsterOut;
      
      public static var IconArrowDown:Class = Options_IconArrowDown;
      
      public static var IconArrowDownOut:Class = Options_IconArrowDownOut;
      
      public static var IconArrowUp:Class = Options_IconArrowUp;
      
      public static var IconArrowUpOut:Class = Options_IconArrowUpOut;
      
      public static var IconClock:Class = Options_IconClock;
      
      public static var IconClockOut:Class = Options_IconClockOut;
      
      public static var Gradient:Class = Options_Gradient;
      
      public static var IconDisk:Class = Options_IconDisk;
      
      public static var IconDiskOver:Class = Options_IconDiskOver;
      
      public static var IconDiskOut:Class = Options_IconDiskOut;
      
      public static var IconTrash:Class = Options_IconTrash;
      
      public static var IconTrashOut:Class = Options_IconTrashOut;
      
      public static var IconCam:Class = Options_IconCam;
      
      public static var IconCamOut:Class = Options_IconCamOut;
      
      public static var IconMinimize:Class = Options_IconMinimize;
      
      public static var IconMinimizeOut:Class = Options_IconMinimizeOut;
      
      public static var IconClear:Class = Options_IconClear;
      
      public static var IconClearOut:Class = Options_IconClearOut;
      
      public static var mCurrentGradient:int = 6;
      
      public static var mCurrentClock:int = 30;
      
      public static var mIsCollectingData:Boolean = false;
      
      public static var mIsSaveEnabled:Boolean = false;
      
      public static var mIsLoaderSnaptopEnabled:Boolean = false;
      
      public static var mIsPerformanceSnaptopEnabled:Boolean = false;
      
      public static var mIsClockEnabled:Boolean = false;
      
      public static var mIsCamEnabled:Boolean = false;
      
      public static const SAVE_RECORDING_EVENT:String = "SaveRecordingEvent";
      
      public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
      
      public static const LOADER_STREAM:String = "URLStream";
      
      public static const LOADER_URLLOADER:String = "URLLoader";
      
      public static const LOADER_DISPLAY_LOADER:String = "Loader";
      
      public static const LOADER_COMPLETED:String = "Success";
      
      public static const LOADER_NOT_COMPLETED:String = "Failed";
      
      private static const ZERO_PERCENT:String = "0.00";
      
      private static const ENTRY_TIME_PROPERTY:String = "entryTime";
      
      private static const FIRST_EVENT_PROPERTY:String = "mFirstEvent";
      
      private static const NO_URL_FOUND:String = "No url found";
      
      private static const CUMUL_PROPERTY:String = "Cumul";
       
      
      private var mMouseListenerButton:Sprite;
      
      private var mMinimizeButton:Sprite;
      
      private var mAutoStatButton:Sprite;
      
      private var mShowOverdraw:Sprite;
      
      private var mShowInstanciator:Sprite;
      
      private var mShowProfiler:Sprite;
      
      private var mShowInternalEvents:Sprite;
      
      private var mShowConfig:Sprite;
      
      private var iconOff:DisplayObject;
      
      private var mFoldButton:MenuButton;
      
      private var mMouseListenersButton:MenuButton;
      
      private var mStatsButton:MenuButton;
      
      private var mOverdrawButton:MenuButton;
      
      private var mInstanciationButton:MenuButton;
      
      private var mMemoryProfilerButton:MenuButton;
      
      private var mInternalEventButton:MenuButton;
      
      private var mFunctionTimeButton:MenuButton;
      
      private var mLoaderProfilerButton:MenuButton;
      
      private var mConfigButton:MenuButton;
      
      private var mSaveDiskButton:MenuButton;
      
      private var mSaveSnapshotButton:MenuButton;
      
      private var mClearButton:MenuButton;
      
      private var mGCButton:MenuButton;
      
      private var mGradientDown:Bitmap;
      
      private var mGradientUp:Bitmap;
      
      private var mClockUpOut:Bitmap;
      
      private var mClockUp:Bitmap;
      
      private var mClockIcon:Bitmap;
      
      private var mClockDownOut:Bitmap;
      
      private var mClockDown:Bitmap;
      
      private var mMinimize:Bitmap;
      
      private var debuggerIcon:DisplayObject = null;
      
      private var mLastSelected:Sprite = null;
      
      private var mToolTip:ToolTip;
      
      private var mInterface:Sprite;
      
      private var mStage:Stage;
      
      private var mButtonDict:Dictionary;
      
      public function Options(aStage:Stage = null)
      {
         this.mButtonDict = new Dictionary(true);
         super();
         this.mStage = aStage;
         this.Init();
      }
      
      public function Init() : void
      {
         if(stage)
         {
            this.OnAddedToStage();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
         }
      }
      
      private function OnAddedToStage(e:Event = null) : void
      {
         if(e.target == this)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
            var barWidth:int = 300;
            this.mStage = this.stage;
            this.graphics.beginFill(0,0.3);
            this.graphics.drawRect(0,0,barWidth,18);
            this.graphics.endFill();
            this.graphics.beginFill(13421772,0.6);
            this.graphics.drawRect(0,17,barWidth,1);
            this.graphics.endFill();
            this.graphics.beginFill(16777215,0.8);
            this.graphics.drawRect(0,18,barWidth,1);
            this.graphics.endFill();
            var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
            var myformatRight:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.RIGHT);
            var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
            this.mToolTip = new ToolTip();
            var vButtonPosX:int = 4;
            var vButtonSpacing:int = 16;
            var vButtonPosY:int = 4;
            this.mFoldButton = new MenuButton(vButtonPosX,vButtonPosY,IconMinimizeOut,IconMinimize,IconMinimizeOut,"toggleMinimize",null,"Minimize");
            addChild(this.mFoldButton);
            this.mButtonDict[this.mFoldButton] = this.mFoldButton;
            vButtonPosX += 16;
            this.mStatsButton = new MenuButton(vButtonPosX,vButtonPosY,IconStatsOut,IconStats,IconStatsOut,ChangeToolEvent.CHANGE_TOOL_EVENT,FlashStats,"Runtime Statistics");
            addChild(this.mStatsButton);
            this.mButtonDict[this.mStatsButton] = this.mStatsButton;
            vButtonPosX += 16;
            this.mMouseListenerButton = new MenuButton(vButtonPosX,vButtonPosY,IconMouseOut,IconMouse,IconMouseOut,ChangeToolEvent.CHANGE_TOOL_EVENT,MouseListeners,"Mouse Listeners");
            addChild(this.mMouseListenerButton);
            this.mButtonDict[this.mMouseListenerButton] = this.mMouseListenerButton;
            vButtonPosX += 16;
            this.mInstanciationButton = new MenuButton(vButtonPosX,vButtonPosY,IconOverdrawOut,IconOverdraw,IconOverdrawOut,ChangeToolEvent.CHANGE_TOOL_EVENT,Overdraw,"Overdraw");
            addChild(this.mInstanciationButton);
            this.mButtonDict[this.mInstanciationButton] = this.mInstanciationButton;
            vButtonPosX += 16;
            this.mInstanciationButton = new MenuButton(vButtonPosX,vButtonPosY,IconLifeCyclesOut,IconLifeCycle,IconLifeCyclesOut,ChangeToolEvent.CHANGE_TOOL_EVENT,InstancesLifeCycle,"DisplayObjects Life Cycle");
            addChild(this.mInstanciationButton);
            this.mButtonDict[this.mInstanciationButton] = this.mInstanciationButton;
            vButtonPosX += 16;
            this.mMemoryProfilerButton = new MenuButton(vButtonPosX,vButtonPosY,IconPercentOut,IconPercent,IconPercentOut,ChangeToolEvent.CHANGE_TOOL_EVENT,SamplerProfiler,"Memory Profiler");
            addChild(this.mMemoryProfilerButton);
            this.mButtonDict[this.mMemoryProfilerButton] = this.mMemoryProfilerButton;
            vButtonPosX += 16;
            this.mInternalEventButton = new MenuButton(vButtonPosX,vButtonPosY,IconProfilerOut,IconProfiler,IconProfilerOut,ChangeToolEvent.CHANGE_TOOL_EVENT,InternalEventsProfiler,"Internal Events Profiler");
            addChild(this.mInternalEventButton);
            this.mButtonDict[this.mInternalEventButton] = this.mInternalEventButton;
            vButtonPosX += 16;
            this.mFunctionTimeButton = new MenuButton(vButtonPosX,vButtonPosY,IconClockOut,IconClock,IconClockOut,ChangeToolEvent.CHANGE_TOOL_EVENT,PerformanceProfiler,"Performance Profiler");
            addChild(this.mFunctionTimeButton);
            this.mButtonDict[this.mFunctionTimeButton] = this.mFunctionTimeButton;
            vButtonPosX += 16;
            this.mLoaderProfilerButton = new MenuButton(vButtonPosX,vButtonPosY,IconLoadersOut,IconLoaders,IconLoadersOut,ChangeToolEvent.CHANGE_TOOL_EVENT,LoaderProfiler,"Loaders Profiler");
            addChild(this.mLoaderProfilerButton);
            this.mButtonDict[this.mLoaderProfilerButton] = this.mLoaderProfilerButton;
            vButtonPosX += 16;
            this.mConfigButton = new MenuButton(vButtonPosX,vButtonPosY,IconConfigOut,IconConfig,IconConfigOut,ChangeToolEvent.CHANGE_TOOL_EVENT,Configuration,"Configs");
            addChild(this.mConfigButton);
            this.mButtonDict[this.mConfigButton] = this.mConfigButton;
            vButtonPosX += 16;
            this.debuggerIcon = new DebugerIcon();
            this.iconOff = new DebugerIconDisable();
            this.debuggerIcon.x = vButtonPosX;
            this.debuggerIcon.y = 1;
            this.iconOff.x = vButtonPosX;
            this.iconOff.y = 1;
            addChild(this.iconOff);
            addChild(this.debuggerIcon);
            this.debuggerIcon.visible = false;
            vButtonPosX += 70;
            this.mGCButton = new MenuButton(vButtonPosX,vButtonPosY,IconTrashOut,IconTrash,IconTrashOut,null,null,"Force (sync) Garbage Collector",true,"Done");
            addChild(this.mGCButton);
            vButtonPosX += 16;
            var saveText:String = "Save Samples in Clipboard" + "\nSamples include NewObject, DeletedObject, FunctionTime" + "\nAll field are separated by Tabs, use a Grid editor" + "\nfor a better view / sorting / analysis.";
            this.mSaveDiskButton = new MenuButton(vButtonPosX,vButtonPosY,IconDiskOut,IconDisk,IconDiskOut,SAVE_RECORDING_EVENT,null,"Start Recording Samples",true,saveText);
            addChild(this.mSaveDiskButton);
            addEventListener(SAVE_RECORDING_EVENT,this.OnSaveRecording);
            vButtonPosX += 16;
            this.mSaveSnapshotButton = new MenuButton(vButtonPosX,vButtonPosY,IconCamOut,IconCam,IconCamOut,SAVE_SNAPSHOT_EVENT,null,"Save ALL [CurrentProfilerData] to Clipboard",true,"Saved");
            addChild(this.mSaveSnapshotButton);
            addEventListener(SAVE_SNAPSHOT_EVENT,this.OnSaveSnapshot);
            vButtonPosX += 16;
            this.mClearButton = new MenuButton(vButtonPosX,vButtonPosY,IconClearOut,IconClear,IconClearOut,null,null,"Clear Current Data",true,"Data cleared");
            addChild(this.mClearButton);
            vButtonPosX += 16;
            this.stage.addEventListener(Event.RESIZE,this.OnResize);
            this.mInterface = new Sprite();
            this.mInterface.visible = false;
            this.mInterface.x = this.stage.stageWidth;
            var obj:Bitmap = null;
            obj = new IconArrowDownOut() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 9;
            this.mInterface.addChild(obj);
            obj = new IconArrowDown() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 9;
            obj.visible = false;
            this.mInterface.addChild(obj);
            this.mGradientDown = obj;
            obj = new Gradient() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 8;
            this.mInterface.addChild(obj);
            obj = new IconArrowUpOut() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 7;
            this.mInterface.addChild(obj);
            obj = new IconArrowUp() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 7;
            obj.visible = false;
            this.mInterface.addChild(obj);
            this.mGradientUp = obj;
            obj = new IconArrowDownOut() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 5;
            this.mClockDownOut = obj;
            this.mInterface.addChild(obj);
            obj = new IconArrowDown() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 5;
            obj.visible = false;
            this.mInterface.addChild(obj);
            this.mClockDown = obj;
            obj = new IconClockOut() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 4;
            this.mInterface.addChild(obj);
            this.mClockIcon = obj;
            obj = new IconArrowUpOut() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 3;
            this.mClockUpOut = obj;
            this.mInterface.addChild(obj);
            obj = new IconArrowUp() as Bitmap;
            obj.y = 4;
            obj.x = -12 * 3;
            this.mInterface.addChild(obj);
            obj.visible = false;
            this.mClockUp = obj;
            addChild(this.mInterface);
            addChild(this.mToolTip);
            this.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseMove);
            this.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
            addEventListener(ChangeToolEvent.CHANGE_TOOL_EVENT,this.OnChangeTool);
            this.ResetColors();
            return;
         }
      }
      
      private function OnSaveSnapshot(e:Event) : void
      {
         pauseSampling();
         if(this.mSaveSnapshotButton.mIsSelected)
         {
            if(mIsLoaderSnaptopEnabled)
            {
               this.SaveLoaderSnapshot();
            }
            if(mIsPerformanceSnaptopEnabled)
            {
               this.SavePerformanceSnapshot();
            }
            if(mIsCamEnabled)
            {
               this.SaveMemorySnapshot();
            }
            this.mSaveSnapshotButton.Reset();
         }
         startSampling();
      }
      
      private function OnSaveRecording(e:Event) : void
      {
         if(mIsCollectingData)
         {
            pauseSampling();
            this.SaveCollectedData();
            startSampling();
         }
      }
      
      private function OnChangeTool(e:ChangeToolEvent) : void
      {
         var button:MenuButton = null;
         for each(button in this.mButtonDict)
         {
            if(e.target != button)
            {
               button.Reset();
            }
         }
      }
      
      public function SetStage(aStage:Stage) : void
      {
         this.mStage = aStage;
         this.mInterface.x = this.mStage.stageWidth;
      }
      
      private function OnResize(e:Event) : void
      {
         this.mInterface.x = this.mStage.stageWidth;
         trace("OnResize",e);
      }
      
      public function Update() : void
      {
         mIsCollectingData = this.mSaveDiskButton.mIsSelected;
         this.mSaveSnapshotButton.visible = mIsCamEnabled || mIsPerformanceSnaptopEnabled || mIsLoaderSnaptopEnabled;
         this.mClearButton.visible = mIsCamEnabled || mIsPerformanceSnaptopEnabled;
         if(this.mClearButton.mIsSelected)
         {
            if(mIsPerformanceSnaptopEnabled)
            {
               this.ClearPerformanceData();
            }
            if(mIsCamEnabled)
            {
               this.ClearMemoryData();
            }
            this.mClearButton.Reset();
         }
         if(this.mGCButton.mIsSelected)
         {
            SampleAnalyzer.GetInstance().ForceGC();
            this.mGCButton.Reset();
         }
      }
      
      private function ClearMemoryData() : void
      {
         SampleAnalyzer.GetInstance().ResetMemoryStats();
      }
      
      private function ClearPerformanceData() : void
      {
         SampleAnalyzer.GetInstance().ResetPerformanceStats();
      }
      
      private function SavePerformanceSnapshot() : void
      {
         var holder:InternalEventEntry = null;
         var percent:Number = NaN;
         var vFunctionTimes:Array = SampleAnalyzer.GetInstance().GetFunctionTimes();
         vFunctionTimes.sortOn(ENTRY_TIME_PROPERTY,Array.NUMERIC | Array.DESCENDING);
         var outCam:ByteArray = new ByteArray();
         var len:int = int(vFunctionTimes.length);
         var totalTime:int = 0;
         for each(holder in vFunctionTimes)
         {
            totalTime += holder.entryTime;
         }
         for each(holder in vFunctionTimes)
         {
            percent = int(holder.entryTime / totalTime * 10000) / 100;
            if(percent == 0)
            {
               outCam.writeUTFBytes(ZERO_PERCENT);
            }
            else
            {
               outCam.writeUTFBytes(String(percent));
            }
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.entryTime.toString());
            outCam.writeByte(9);
            percent = int(holder.entryTimeTotal / totalTime * 10000) / 100;
            if(percent == 0)
            {
               outCam.writeUTFBytes(ZERO_PERCENT);
            }
            else
            {
               outCam.writeUTFBytes(String(percent));
            }
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.entryTimeTotal.toString());
            outCam.writeByte(9);
            outCam.writeUTFBytes(String(holder.mStackFrame));
            outCam.writeByte(13);
            outCam.writeByte(10);
         }
         outCam.position = 0;
         System.setClipboard(outCam.readUTFBytes(outCam.length));
      }
      
      private function SaveLoaderSnapshot() : void
      {
         var ld:LoaderData = null;
         var vLoadersData:Array = LoaderAnalyser.GetInstance().GetLoadersData();
         vLoadersData.sortOn(FIRST_EVENT_PROPERTY,Array.NUMERIC | Array.DESCENDING);
         var outCam:ByteArray = new ByteArray();
         var len:int = int(vLoadersData.length);
         for each(ld in vLoadersData)
         {
            if(ld.mFirstEvent != -1)
            {
               LOADER_DISPLAY_LOADER;
               if(ld.mType == LoaderData.DISPLAY_LOADER)
               {
                  outCam.writeUTFBytes(LOADER_DISPLAY_LOADER);
               }
               else if(ld.mType == LoaderData.URL_STREAM)
               {
                  outCam.writeUTFBytes(LOADER_STREAM);
               }
               else if(ld.mType == LoaderData.URL_LOADER)
               {
                  outCam.writeUTFBytes(LOADER_URLLOADER);
               }
               outCam.writeByte(9);
               outCam.writeUTFBytes(ld.mLoadedBytes.toString());
               outCam.writeByte(9);
               if(ld.mIsFinished)
               {
                  outCam.writeUTFBytes(LOADER_COMPLETED);
               }
               else
               {
                  outCam.writeUTFBytes(LOADER_NOT_COMPLETED);
               }
               outCam.writeByte(9);
               if(ld.mUrl == null)
               {
                  outCam.writeUTFBytes(NO_URL_FOUND);
               }
               else
               {
                  outCam.writeUTFBytes(ld.mUrl);
               }
               outCam.writeByte(9);
               if(ld.mIOError)
               {
                  outCam.writeByte(9);
                  outCam.writeUTFBytes(ld.mIOError.toString());
               }
               if(ld.mSecurityError)
               {
                  outCam.writeByte(9);
                  outCam.writeUTFBytes(ld.mSecurityError.toString());
               }
               outCam.writeByte(13);
               outCam.writeByte(10);
            }
         }
         outCam.position = 0;
         System.setClipboard(outCam.readUTFBytes(outCam.length));
      }
      
      private function SaveMemorySnapshot() : void
      {
         var holder:ClassTypeStatsHolder = null;
         var classList:Array = SampleAnalyzer.GetInstance().GetClassInstanciationStats();
         classList.sortOn(CUMUL_PROPERTY,Array.NUMERIC | Array.DESCENDING);
         var outCam:ByteArray = new ByteArray();
         for each(holder in classList)
         {
            outCam.writeUTFBytes(holder.TypeName);
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.Added.toString());
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.Removed.toString());
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.Current.toString());
            outCam.writeByte(9);
            outCam.writeUTFBytes(holder.Cumul.toString());
            outCam.writeByte(13);
            outCam.writeByte(10);
         }
         outCam.position = 0;
         System.setClipboard(outCam.readUTFBytes(outCam.length));
      }
      
      private function SaveCollectedData() : void
      {
         var lastTime:Number = 0;
         var eventTime:Number = 0;
         var out:ByteArray = new ByteArray();
         var data:Array = SampleAnalyzer.GetInstance().GetFrameDataArray();
         var len:int = data.length / 2;
         lastTime = Number(data[0]);
         for(var i:int = 0; i < len; )
         {
            eventTime = Number(data[i++]);
            out.writeUTFBytes(lastTime.toString());
            out.writeByte(9);
            out.writeUTFBytes((eventTime - lastTime).toString());
            lastTime = eventTime;
            out.writeByte(9);
            out.writeUTFBytes(data[i++]);
            out.writeByte(13);
            out.writeByte(10);
         }
         out.position = 0;
         System.setClipboard(out.readUTFBytes(out.length));
      }
      
      public function ShowInterfaceCustomizer(enable:Boolean) : void
      {
         this.mInterface.visible = enable;
         this.mClockDownOut.visible = mIsClockEnabled;
         this.mClockUpOut.visible = mIsClockEnabled;
         this.mClockIcon.visible = mIsClockEnabled;
      }
      
      private function OnMouseClick(e:MouseEvent) : void
      {
         var isPaused:Boolean = SampleAnalyzer.GetInstance().IsSamplingPaused();
         SampleAnalyzer.GetInstance().PauseSampling();
         this.OnMouseMove(e);
         if(this.mGradientUp.visible)
         {
            if(mCurrentGradient <= 9)
            {
               ++mCurrentGradient;
            }
         }
         else if(this.mGradientDown.visible)
         {
            if(mCurrentGradient >= 2)
            {
               --mCurrentGradient;
            }
         }
         if(mIsClockEnabled)
         {
            if(this.mClockUp.visible)
            {
               if(mCurrentClock >= 2)
               {
                  --mCurrentClock;
               }
            }
            else if(this.mClockDown.visible)
            {
               if(mCurrentClock <= 100)
               {
                  ++mCurrentClock;
               }
            }
         }
         if(!isPaused)
         {
            SampleAnalyzer.GetInstance().ResumeSampling();
         }
      }
      
      private function OnMouseMove(e:MouseEvent) : void
      {
         var stageMouseX:int = this.stage.mouseX;
         var stageMouseY:int = this.stage.mouseY;
         if(this.mGradientUp.mouseX >= 0 && this.mGradientUp.mouseX < 12 && this.mGradientUp.mouseY >= 0 && this.mGradientUp.mouseY < 12)
         {
            this.mGradientUp.visible = true;
         }
         else
         {
            this.mGradientUp.visible = false;
         }
         if(this.mGradientDown.mouseX >= 0 && this.mGradientDown.mouseX < 12 && this.mGradientDown.mouseY >= 0 && this.mGradientDown.mouseY < 12)
         {
            this.mGradientDown.visible = true;
         }
         else
         {
            this.mGradientDown.visible = false;
         }
         if(mIsClockEnabled)
         {
            if(this.mClockDown.mouseX >= 0 && this.mClockDown.mouseX < 12 && this.mClockDown.mouseY >= 0 && this.mClockDown.mouseY < 12)
            {
               this.mClockDown.visible = true;
            }
            else
            {
               this.mClockDown.visible = false;
            }
            if(this.mClockUp.mouseX >= 0 && this.mClockUp.mouseX < 12 && this.mClockUp.mouseY >= 0 && this.mClockUp.mouseY < 12)
            {
               this.mClockUp.visible = true;
            }
            else
            {
               this.mClockUp.visible = false;
            }
         }
      }
      
      public function SetMonsterDisabled() : void
      {
         var s:Sprite = new Sprite();
         s.graphics.beginFill(0,1);
         s.graphics.drawRect(this.iconOff.x - 2,10,this.iconOff.width + 4,1);
         s.graphics.endFill();
         s.graphics.beginFill(16777215,1);
         s.graphics.drawRect(this.iconOff.x - 2,11,this.iconOff.width + 4,2);
         s.graphics.endFill();
         s.graphics.beginFill(0,1);
         s.graphics.drawRect(this.iconOff.x - 2,13,this.iconOff.width + 4,1);
         s.graphics.endFill();
         addChild(s);
      }
      
      public function Dispose() : void
      {
         this.mGradientDown = null;
         this.mGradientUp = null;
         this.mClockUp = null;
         this.mClockDown = null;
      }
      
      private function ResetColors(obj:Sprite = null, color:uint = 15906565) : void
      {
         if(this.mLastSelected != this.mShowInstanciator)
         {
            this.mShowInstanciator.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mMouseListenerButton)
         {
            this.mMouseListenerButton.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mAutoStatButton)
         {
            this.mAutoStatButton.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mShowOverdraw)
         {
            this.mShowOverdraw.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mShowProfiler)
         {
            this.mShowProfiler.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mShowInternalEvents)
         {
            this.mShowInternalEvents.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mShowConfig)
         {
            this.mShowConfig.getChildAt(1).visible = false;
         }
         if(this.mLastSelected != this.mMinimizeButton)
         {
            this.mMinimizeButton.getChildAt(1).visible = false;
         }
         if(obj != null)
         {
            obj.getChildAt(1).visible = true;
         }
      }
      
      public function OnDebuggerConnect(e:Event) : void
      {
         if(this.debuggerIcon != null)
         {
            this.debuggerIcon.visible = true;
         }
      }
      
      public function OnDebuggerDisconnect(e:Event) : void
      {
         if(this.debuggerIcon != null)
         {
            this.debuggerIcon.visible = false;
         }
      }
      
      public function ResetMenu(aButton:MenuButton) : void
      {
         var button:MenuButton = null;
         for each(button in this.mButtonDict)
         {
            if(aButton != button)
            {
               button.Reset();
            }
         }
      }
   }
}
