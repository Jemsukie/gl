package net.jpauclair.window
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import net.jpauclair.IDisposable;
   import net.jpauclair.Options;
   import net.jpauclair.ui.button.MenuButton;
   
   public class Configuration extends Sprite implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
      
      public static const SETUP_MEMORY_PROFILING_ENABLED:String = "SETUP_MEMORY_PROFILING_ENABLED";
      
      public static const SETUP_INTERNALEVENT_PROFILING_ENABLED:String = "SETUP_INTERNALEVENT_PROFILING_ENABLED";
      
      public static const SETUP_FUNCTION_PROFILING_ENABLED:String = "SETUP_FUNCTION_PROFILING_ENABLED";
      
      public static const SETUP_LOADERS_PROFILING_ENABLED:String = "SETUP_LOADERS_PROFILING_ENABLED";
      
      public static const SETUP_SOCKETS_PROFILING_ENABLED:String = "SETUP_SOCKETS_PROFILING_ENABLED";
      
      public static const SETUP_MEMGRAPH_PROFILING_ENABLED:String = "SETUP_MEMGRAPH_PROFILING_ENABLED";
      
      public static const SETUP_MONSTER_DEBUGGER:String = "SETUP_MONSTER_DEBUGGER";
      
      private static var _PROFILE_MEMORY:Boolean = false;
      
      private static var _PROFILE_FUNCTION:Boolean = false;
      
      private static var _PROFILE_INTERNAL_EVENTS:Boolean = false;
      
      private static var _PROFILE_LOADERS:Boolean = false;
      
      private static var _PROFILE_SOCKETS:Boolean = false;
      
      private static var _PROFILE_MEMGRAPH:Boolean = false;
      
      private static var _PROFILE_MONSTER:Boolean = false;
      
      private static var mSaveObj:SharedObject;
       
      
      private var mMainSprite:Sprite = null;
      
      private var mInfos:TextField;
      
      private var IconLink:Class;
      
      private var IconLinkOut:Class;
      
      private var mStatsButton:MenuButton;
      
      private var mMemoryProfilerButton:MenuButton;
      
      private var mInternalEventButton:MenuButton;
      
      private var mFunctionTimeButton:MenuButton;
      
      private var mLoaderProfilerButton:MenuButton;
      
      private var mMonsters:MenuButton;
      
      private var mButtonDict:Dictionary;
      
      private var mSaveDiskButton:MenuButton;
      
      public function Configuration(mainSprite:Sprite)
      {
         this.IconLink = Configuration_IconLink;
         this.IconLinkOut = Configuration_IconLinkOut;
         this.mButtonDict = new Dictionary(true);
         super();
         this.Init(mainSprite);
      }
      
      public static function Load() : void
      {
         var o:* = undefined;
         trace("Loading configs...");
         PROFILE_MEMORY = true;
         PROFILE_INTERNAL_EVENTS = true;
         PROFILE_FUNCTION = true;
         PROFILE_LOADERS = true;
         PROFILE_SOCKETS = true;
         PROFILE_MEMGRAPH = true;
         PROFILE_MONSTER = false;
         try
         {
            mSaveObj = SharedObject.getLocal("FlashPreloadProfiler");
            trace("valid object",mSaveObj.data);
            for(o in mSaveObj.data)
            {
               trace(o,mSaveObj.data[o]);
            }
         }
         catch(e:Error)
         {
            mSaveObj = new SharedObject();
            Save();
            trace("creating new Save file");
         }
         if(mSaveObj.data[SETUP_MEMORY_PROFILING_ENABLED] != undefined)
         {
            PROFILE_MEMORY = mSaveObj.data[SETUP_MEMORY_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_INTERNALEVENT_PROFILING_ENABLED] != undefined)
         {
            PROFILE_INTERNAL_EVENTS = mSaveObj.data[SETUP_INTERNALEVENT_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_FUNCTION_PROFILING_ENABLED] != undefined)
         {
            PROFILE_FUNCTION = mSaveObj.data[SETUP_FUNCTION_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_LOADERS_PROFILING_ENABLED] != undefined)
         {
            PROFILE_LOADERS = mSaveObj.data[SETUP_LOADERS_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_SOCKETS_PROFILING_ENABLED] != undefined)
         {
            PROFILE_SOCKETS = mSaveObj.data[SETUP_SOCKETS_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_MEMGRAPH_PROFILING_ENABLED] != undefined)
         {
            PROFILE_MEMGRAPH = mSaveObj.data[SETUP_MEMGRAPH_PROFILING_ENABLED];
         }
         if(mSaveObj.data[SETUP_MONSTER_DEBUGGER] != undefined)
         {
            PROFILE_MONSTER = mSaveObj.data[SETUP_MONSTER_DEBUGGER];
         }
      }
      
      private static function Save() : void
      {
         trace("Saving!");
         mSaveObj.clear();
         mSaveObj.setProperty(SETUP_MEMORY_PROFILING_ENABLED,PROFILE_MEMORY);
         mSaveObj.setProperty(SETUP_INTERNALEVENT_PROFILING_ENABLED,PROFILE_INTERNAL_EVENTS);
         mSaveObj.setProperty(SETUP_FUNCTION_PROFILING_ENABLED,PROFILE_FUNCTION);
         mSaveObj.setProperty(SETUP_LOADERS_PROFILING_ENABLED,PROFILE_LOADERS);
         mSaveObj.setProperty(SETUP_SOCKETS_PROFILING_ENABLED,PROFILE_SOCKETS);
         mSaveObj.setProperty(SETUP_MEMGRAPH_PROFILING_ENABLED,PROFILE_MEMGRAPH);
         mSaveObj.setProperty(SETUP_MONSTER_DEBUGGER,PROFILE_MONSTER);
         mSaveObj.flush();
      }
      
      public static function get PROFILE_MEMORY() : Boolean
      {
         return _PROFILE_MEMORY;
      }
      
      public static function set PROFILE_MEMORY(value:Boolean) : void
      {
         _PROFILE_MEMORY = value;
      }
      
      public static function get PROFILE_FUNCTION() : Boolean
      {
         return _PROFILE_FUNCTION;
      }
      
      public static function set PROFILE_FUNCTION(value:Boolean) : void
      {
         _PROFILE_FUNCTION = value;
      }
      
      public static function get PROFILE_INTERNAL_EVENTS() : Boolean
      {
         return _PROFILE_INTERNAL_EVENTS;
      }
      
      public static function set PROFILE_INTERNAL_EVENTS(value:Boolean) : void
      {
         _PROFILE_INTERNAL_EVENTS = value;
      }
      
      public static function get PROFILE_LOADERS() : Boolean
      {
         return _PROFILE_LOADERS;
      }
      
      public static function set PROFILE_LOADERS(value:Boolean) : void
      {
         _PROFILE_LOADERS = value;
      }
      
      public static function get PROFILE_SOCKETS() : Boolean
      {
         return _PROFILE_SOCKETS;
      }
      
      public static function set PROFILE_SOCKETS(value:Boolean) : void
      {
         _PROFILE_SOCKETS = value;
      }
      
      public static function get PROFILE_MEMGRAPH() : Boolean
      {
         return _PROFILE_MEMGRAPH;
      }
      
      public static function set PROFILE_MEMGRAPH(value:Boolean) : void
      {
         _PROFILE_MEMGRAPH = value;
      }
      
      public static function get PROFILE_MONSTER() : Boolean
      {
         return _PROFILE_MONSTER;
      }
      
      public static function set PROFILE_MONSTER(value:Boolean) : void
      {
         _PROFILE_MONSTER = value;
      }
      
      private function Init(mainSprite:Sprite) : void
      {
         this.mMainSprite = mainSprite;
         this.mouseEnabled = false;
         var barWidth:int = this.mMainSprite.stage.stageWidth;
         var bgSprite:Sprite = new Sprite();
         this.graphics.beginFill(0,0.3);
         this.graphics.drawRect(0,18,barWidth,this.mMainSprite.stage.stageHeight - 18);
         this.graphics.endFill();
         this.graphics.beginFill(13421772,0.6);
         this.graphics.drawRect(0,19,barWidth,1);
         this.graphics.endFill();
         this.graphics.beginFill(16777215,0.8);
         this.graphics.drawRect(0,18,barWidth,1);
         this.graphics.endFill();
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.mInfos = new TextField();
         this.mInfos.mouseEnabled = false;
         this.mInfos.autoSize = TextFieldAutoSize.LEFT;
         this.mInfos.defaultTextFormat = myformat;
         this.mInfos.selectable = false;
         this.mInfos.appendText("FlashPreloadProfiler!nFor help or support:\nhttp://jpauclair.net/flashpreloadprofiler/\n");
         this.mInfos.appendText("\nContinous profiling:\n The profiler will run in background all the time\n and start before the profiled application");
         this.mInfos.appendText("\n*Each profiler running \"in background\" is going to use some CPU and memory");
         this.mInfos.filters = [myglow];
         this.mInfos.x = 2;
         this.mInfos.y = 22;
         addChild(this.mInfos);
         var vButtonPosX:int = 4;
         var vButtonSpacing:int = 16;
         var vButtonPosY:int = 130;
         this.mStatsButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconStatsOut,Options.IconStats,Options.IconStatsOut,null,null,"Toggle to ACTIVATE MemoryGraph continuous profiling",true,"Toggle to DEACTIVATE MemoryGraph continuous profiling");
         addChild(this.mStatsButton);
         this.mButtonDict[this.mStatsButton] = this.mStatsButton;
         vButtonPosX += 16;
         if(PROFILE_MEMGRAPH)
         {
            this.mStatsButton.OnClick(null);
         }
         this.mMemoryProfilerButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconPercentOut,Options.IconPercent,Options.IconPercentOut,null,null,"Toggle to ACTIVATE memory continuous profiling",true,"Toggle to DEACTIVATE memory continuous profiling");
         addChild(this.mMemoryProfilerButton);
         this.mButtonDict[this.mMemoryProfilerButton] = this.mMemoryProfilerButton;
         vButtonPosX += 16;
         if(PROFILE_MEMORY)
         {
            this.mMemoryProfilerButton.OnClick(null);
         }
         this.mInternalEventButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconProfilerOut,Options.IconProfiler,Options.IconProfilerOut,null,null,"Toggle to ACTIVATE InternalEvents continuous profiling",true,"Toggle to DEACTIVATE InternalEvents continuous profiling");
         addChild(this.mInternalEventButton);
         this.mButtonDict[this.mInternalEventButton] = this.mInternalEventButton;
         vButtonPosX += 16;
         if(PROFILE_INTERNAL_EVENTS)
         {
            this.mInternalEventButton.OnClick(null);
         }
         this.mFunctionTimeButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconClockOut,Options.IconClock,Options.IconClockOut,null,null,"Toggle to ACTIVATE performance continuous profiling",true,"Toggle to DEACTIVATE performance continuous profiling");
         addChild(this.mFunctionTimeButton);
         this.mButtonDict[this.mFunctionTimeButton] = this.mFunctionTimeButton;
         vButtonPosX += 16;
         if(PROFILE_FUNCTION)
         {
            this.mFunctionTimeButton.OnClick(null);
         }
         this.mLoaderProfilerButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconLoadersOut,Options.IconLoaders,Options.IconLoadersOut,null,null,"Toggle to ACTIVATE loaders continuous profiling",true,"Toggle to DEACTIVATE loaders continuous profiling");
         addChild(this.mLoaderProfilerButton);
         this.mButtonDict[this.mLoaderProfilerButton] = this.mLoaderProfilerButton;
         vButtonPosX += 16;
         if(PROFILE_LOADERS)
         {
            this.mLoaderProfilerButton.OnClick(null);
         }
         this.mMonsters = new MenuButton(vButtonPosX,vButtonPosY,Options.IconMonsterOut,Options.IconMonster,Options.IconMonsterOut,null,null,"Toggle to ACTIVATE MonsterDebugger at next launch",true,"Toggle to DEACTIVATE MonsterDebugger at next launch");
         addChild(this.mMonsters);
         this.mButtonDict[this.mMonsters] = this.mMonsters;
         vButtonPosX += 16;
         if(_PROFILE_MONSTER)
         {
            this.mMonsters.OnClick(null);
         }
         this.mInfos = new TextField();
         this.mInfos.mouseEnabled = false;
         this.mInfos.autoSize = TextFieldAutoSize.LEFT;
         this.mInfos.defaultTextFormat = myformat;
         this.mInfos.selectable = false;
         this.mInfos.appendText("* All options will still be valid at next launch if you save!");
         this.mInfos.filters = [myglow];
         this.mInfos.x = 2;
         this.mInfos.y = 150;
         addChild(this.mInfos);
         vButtonPosY = 170;
         vButtonPosX = 4;
         this.mSaveDiskButton = new MenuButton(vButtonPosX,vButtonPosY,Options.IconDiskOut,Options.IconDisk,Options.IconDiskOut,null,null,"Save options in SharedObject");
         addChild(this.mSaveDiskButton);
      }
      
      public function Update() : void
      {
         if(this.mMemoryProfilerButton.mIsSelected != Configuration.PROFILE_MEMORY)
         {
            Configuration.PROFILE_MEMORY = this.mMemoryProfilerButton.mIsSelected;
         }
         if(this.mStatsButton.mIsSelected != Configuration.PROFILE_MEMGRAPH)
         {
            Configuration.PROFILE_MEMGRAPH = this.mStatsButton.mIsSelected;
         }
         if(this.mInternalEventButton.mIsSelected != Configuration.PROFILE_INTERNAL_EVENTS)
         {
            Configuration.PROFILE_INTERNAL_EVENTS = this.mInternalEventButton.mIsSelected;
         }
         if(this.mFunctionTimeButton.mIsSelected != Configuration.PROFILE_FUNCTION)
         {
            Configuration.PROFILE_FUNCTION = this.mFunctionTimeButton.mIsSelected;
         }
         if(this.mLoaderProfilerButton.mIsSelected != Configuration.PROFILE_LOADERS)
         {
            Configuration.PROFILE_LOADERS = this.mLoaderProfilerButton.mIsSelected;
         }
         if(this.mMonsters.mIsSelected != Configuration.PROFILE_MONSTER)
         {
            Configuration.PROFILE_MONSTER = this.mMonsters.mIsSelected;
         }
         if(this.mSaveDiskButton.mIsSelected)
         {
            this.mSaveDiskButton.mIsSelected = false;
            Save();
            this.mSaveDiskButton.Reset();
         }
      }
      
      public function Dispose() : void
      {
         this.graphics.clear();
         this.mInfos = null;
         if(this.mMainSprite != null && this.mMainSprite.stage != null)
         {
            this.mMainSprite = null;
         }
      }
   }
}
