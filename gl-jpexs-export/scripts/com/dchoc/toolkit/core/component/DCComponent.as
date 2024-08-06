package com.dchoc.toolkit.core.component
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.profiler.DCProfiler;
   import esparragon.utils.EUtils;
   import flash.utils.getQualifiedClassName;
   
   public class DCComponent implements DCIComponent
   {
      
      private static var smBuildSyncStepThreshold:int = 50;
      
      public static var smBuildSyncErrorShown:Boolean = false;
      
      public static const MODE_COMPLETE:int = 0;
      
      private static const CHILDREN_LOAD_MAX_STEPS:int = 1;
      
      private static const CHILDREN_BUILD_MAX_STEPS:int = 1;
       
      
      protected var mIsLoaded:Boolean;
      
      protected var mLoadCurrentStep:int;
      
      protected var mLoadTotalSteps:int;
      
      protected var mBuildSyncCurrentStep:int;
      
      protected var mBuildSyncTotalSteps:int;
      
      protected var mBuildSyncSameStep:int;
      
      protected var mBuildSyncLastStep:int;
      
      protected var mBuildSyncErrorShown:Boolean;
      
      private var mBuildAsyncCurrentStep:int;
      
      protected var mBuildAsyncTotalSteps:int;
      
      private var mIsBuilt:Boolean;
      
      protected var mIsBegun:Boolean;
      
      protected var mIsAutomaticBegin:Boolean;
      
      private var mIsBeginAllowed:Boolean;
      
      protected var mIsEnabled:Boolean;
      
      protected var mBuiltOnce:Boolean;
      
      protected var className:String;
      
      private var mProfileInfo:Object;
      
      protected var mChildren:Vector.<DCComponent>;
      
      private var mChildrenLoadCurrentStep:int;
      
      private var mChildrenLoadTotalSteps:int;
      
      private var mChildrenBuildCurrentStep:int;
      
      private var mChildrenBuildTotalSteps:int;
      
      protected var mPersistenceData:XML;
      
      public var mLogicUpdateFrequency:int;
      
      public var mTimeSinceLastLogicUpdate:int;
      
      public function DCComponent()
      {
         super();
         this.init();
         if(Config.DEBUG_MODE)
         {
            this.className = getQualifiedClassName(this);
         }
      }
      
      private function init() : void
      {
         this.setup();
         this.reset();
         this.childrenCreate();
      }
      
      protected function setup() : void
      {
         this.mIsAutomaticBegin = true;
         this.mIsBeginAllowed = false;
         this.mLoadTotalSteps = 1;
         this.mBuildSyncTotalSteps = 0;
         this.mBuildAsyncTotalSteps = 1;
      }
      
      private function reset() : void
      {
         this.loadReset();
         this.buildReset();
         this.mIsBegun = false;
         this.mIsEnabled = false;
      }
      
      public function load() : void
      {
         if(!this.mIsLoaded)
         {
            if(Config.ENABLE_PROFILING && this.mProfileInfo == null)
            {
               this.mProfileInfo = DCProfiler.beginProfile(this.className + "_load");
            }
            if(this.mLoadCurrentStep == 0 && this.mChildren == null)
            {
               this.childrenCreate();
            }
            if(this.mLoadCurrentStep < this.mLoadTotalSteps)
            {
               this.loadDoStep(this.mLoadCurrentStep);
               this.mLoadCurrentStep++;
            }
            this.mChildrenLoadCurrentStep = this.childrenLoad();
            this.mIsLoaded = this.mLoadCurrentStep == this.mLoadTotalSteps && this.mChildrenLoadCurrentStep == this.mChildrenLoadTotalSteps;
            if(Config.ENABLE_PROFILING && this.mIsLoaded && this.mProfileInfo != null)
            {
               if(Config.DEBUG_MODE)
               {
                  DCDebug.traceCh("PROFILING",DCProfiler.endProfileReport(this.mProfileInfo));
               }
               this.mProfileInfo = null;
            }
         }
      }
      
      protected function loadDoStep(step:int) : void
      {
      }
      
      public function loadGetCurrentStep() : int
      {
         return this.mLoadCurrentStep + this.mChildrenLoadCurrentStep;
      }
      
      public function loadGetTotalSteps() : int
      {
         return this.mLoadTotalSteps + this.mChildrenLoadTotalSteps;
      }
      
      public function unload() : void
      {
         if(this.mIsLoaded)
         {
            this.unbuild();
            this.childrenUnload();
            this.childrenUncreate();
            this.unloadDo();
            this.loadReset();
         }
      }
      
      protected function unloadDo() : void
      {
      }
      
      private function loadReset() : void
      {
         this.mLoadCurrentStep = 0;
         this.mIsLoaded = false;
         this.mChildrenLoadCurrentStep = 0;
      }
      
      public function isLoaded() : Boolean
      {
         return this.mIsLoaded;
      }
      
      public function build() : void
      {
         if(this.mIsLoaded && !this.mIsBuilt)
         {
            if(Config.ENABLE_PROFILING && this.mProfileInfo == null)
            {
               this.mProfileInfo = DCProfiler.beginProfile(this.className + "_build");
            }
            this.mChildrenBuildCurrentStep = this.childrenBuild();
            if(this.mBuildAsyncCurrentStep < this.mBuildAsyncTotalSteps)
            {
               this.buildDoAsyncStep(this.mBuildAsyncCurrentStep);
               this.mBuildAsyncCurrentStep++;
            }
            if(this.mBuildSyncCurrentStep < this.mBuildSyncTotalSteps)
            {
               if(this.mBuildSyncLastStep == this.mBuildSyncCurrentStep)
               {
                  this.mBuildSyncSameStep++;
                  if(Config.DEBUG_CONSOLE && this.mBuildSyncSameStep > smBuildSyncStepThreshold && (!this.mBuildSyncErrorShown || smBuildSyncErrorShown))
                  {
                     this.mBuildSyncErrorShown = true;
                     DCDebug.traceCh("LOADING"," [BUILD SYNC]: " + this + " Probably stuck in sync step " + this.mBuildSyncCurrentStep);
                  }
               }
               this.buildDoSyncStep(this.mBuildSyncCurrentStep);
            }
            this.mIsBuilt = this.mBuildSyncCurrentStep == this.mBuildSyncTotalSteps && this.mBuildAsyncCurrentStep == this.mBuildAsyncTotalSteps && this.mChildrenBuildCurrentStep == this.mChildrenBuildTotalSteps;
            this.mBuiltOnce ||= this.mIsBuilt;
            if(Config.ENABLE_PROFILING && this.mIsBuilt && this.mProfileInfo != null)
            {
               if(Config.DEBUG_MODE)
               {
                  DCDebug.traceCh("PROFILING",DCProfiler.endProfileReport(this.className + "_build"));
               }
               this.mProfileInfo = null;
            }
         }
      }
      
      public function buildGetCurrentStep() : int
      {
         return this.mBuildSyncCurrentStep + this.mBuildAsyncCurrentStep + this.mChildrenBuildCurrentStep;
      }
      
      public function buildGetTotalSteps() : int
      {
         return this.mBuildSyncTotalSteps + this.mBuildAsyncTotalSteps + this.mChildrenBuildTotalSteps;
      }
      
      public function unbuild(mode:int = 0) : void
      {
         if(this.mIsBuilt)
         {
            this.end();
            if(mode == 0)
            {
               this.childrenUnbuild();
            }
            else
            {
               this.childrenUnbuildMode(mode);
            }
            this.unbuildDo();
            this.buildReset();
         }
      }
      
      public function unbuildMode(mode:int) : void
      {
      }
      
      private function buildReset() : void
      {
         this.mIsBuilt = false;
         this.mBuildSyncCurrentStep = 0;
         this.mBuildSyncLastStep = 0;
         this.mBuildSyncSameStep = 0;
         this.mBuildSyncErrorShown = false;
         this.mBuildAsyncCurrentStep = 0;
         this.mChildrenBuildCurrentStep = 0;
         this.mPersistenceData = null;
      }
      
      protected function buildDoSyncStep(step:int) : void
      {
      }
      
      protected function buildDoAsyncStep(step:int) : void
      {
      }
      
      protected function unbuildDo() : void
      {
      }
      
      public function buildAdvanceSyncStep() : void
      {
         this.mBuildSyncLastStep = this.mBuildSyncCurrentStep;
         this.mBuildSyncCurrentStep++;
         this.mBuildSyncSameStep = 0;
         if(this.mBuildSyncCurrentStep > this.mBuildSyncTotalSteps)
         {
            this.mBuildSyncCurrentStep = this.mBuildSyncTotalSteps;
         }
      }
      
      public function isBuilt() : Boolean
      {
         return this.mIsBuilt;
      }
      
      public function setIsAutomaticBegin(value:Boolean) : void
      {
         this.mIsAutomaticBegin = value;
      }
      
      public function setIsBeginAllowed(value:Boolean) : void
      {
         this.mIsBeginAllowed = value;
         this.childrenSetIsBeginAllowed(value);
      }
      
      public function begin() : void
      {
         if(this.mIsAutomaticBegin || this.mIsBeginAllowed)
         {
            if(this.mIsBuilt && !this.mIsBegun)
            {
               this.childrenBegin();
               this.mIsBegun = true;
               this.setEnabled(true);
               this.beginDo();
            }
         }
      }
      
      protected function beginDo() : void
      {
      }
      
      public function end() : void
      {
         if(this.mIsBegun)
         {
            this.childrenEnd();
            this.endDo();
            this.mIsBegun = false;
            this.mIsBeginAllowed = false;
         }
      }
      
      protected function endDo() : void
      {
      }
      
      public function isBegun() : Boolean
      {
         return this.mIsBegun;
      }
      
      public function isRunning() : Boolean
      {
         return true;
      }
      
      public function isPaused() : Boolean
      {
         return !this.mIsEnabled;
      }
      
      public function pause() : void
      {
         this.setEnabled(false);
      }
      
      public function resume() : void
      {
         this.setEnabled(true);
      }
      
      public function setEnabled(v:Boolean) : void
      {
         this.mIsEnabled = v;
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mIsBegun)
         {
            this.mTimeSinceLastLogicUpdate += dt;
            this.childrenLogicUpdate(dt);
            if(!Config.USE_LAZY_LOGIC_UPDATES || this.mTimeSinceLastLogicUpdate >= this.mLogicUpdateFrequency)
            {
               this.mTimeSinceLastLogicUpdate = 0;
               this.logicUpdateDo(dt);
            }
         }
         else
         {
            this.load();
            this.build();
            this.begin();
         }
      }
      
      public function requestResources() : void
      {
         this.requestResourcesDo();
         this.childrenRequestResources();
      }
      
      protected function requestResourcesDo() : void
      {
      }
      
      protected function logicUpdateDo(dt:int) : void
      {
      }
      
      protected function childrenCreate() : void
      {
      }
      
      protected function childrenUncreate() : void
      {
         if(this.mChildren != null)
         {
            while(this.mChildren.length > 0)
            {
               this.mChildren.shift();
            }
            this.mChildren = null;
         }
         this.mChildrenLoadCurrentStep = 0;
         this.mChildrenLoadTotalSteps = 0;
         this.mChildrenBuildCurrentStep = 0;
         this.mChildrenBuildTotalSteps = 0;
      }
      
      protected function childrenAddChild(c:DCComponent) : int
      {
         var index:int = -1;
         if(c != null)
         {
            if(this.mChildren == null)
            {
               this.mChildren = new Vector.<DCComponent>(0);
            }
            index = this.mChildren.push(c) - 1;
            this.mChildrenLoadTotalSteps += c.loadGetTotalSteps();
            this.mChildrenBuildTotalSteps += c.buildGetTotalSteps();
         }
         return index;
      }
      
      protected function childrenLoad() : int
      {
         var currentStepsPrev:int = 0;
         var currentSteps:int = 0;
         var c:DCComponent = null;
         var returnValue:int = 0;
         var stepsSoFar:int = 0;
         for each(c in this.mChildren)
         {
            currentStepsPrev = c.loadGetCurrentStep();
            c.load();
            currentSteps = c.loadGetCurrentStep();
            returnValue += currentSteps;
            if((stepsSoFar += currentSteps - currentStepsPrev) > 1 - 1)
            {
               break;
            }
         }
         return returnValue;
      }
      
      protected function childrenUnload() : void
      {
         var i:int = 0;
         if(this.mChildren != null)
         {
            for(i = this.mChildren.length - 1; i > -1; )
            {
               DCComponent(this.mChildren[i]).unload();
               i--;
            }
         }
      }
      
      protected function childrenBuild() : int
      {
         var currentStepsPrev:int = 0;
         var currentSteps:int = 0;
         var c:DCComponent = null;
         var returnValue:int = 0;
         var stepsSoFar:int = 0;
         for each(c in this.mChildren)
         {
            currentStepsPrev = c.buildGetCurrentStep();
            c.build();
            currentSteps = c.buildGetCurrentStep();
            returnValue += currentSteps;
            if((stepsSoFar += currentSteps - currentStepsPrev) > 1 - 1)
            {
               break;
            }
         }
         return returnValue;
      }
      
      private function childrenUnbuild() : void
      {
         var i:int = 0;
         if(this.mChildren != null)
         {
            for(i = this.mChildren.length - 1; i > -1; )
            {
               DCComponent(this.mChildren[i]).unbuild();
               i--;
            }
         }
      }
      
      protected function childrenUnbuildMode(mode:int) : void
      {
         this.childrenUnbuild();
      }
      
      protected function childrenSetIsBeginAllowed(value:Boolean) : void
      {
         var c:DCComponent = null;
         for each(c in this.mChildren)
         {
            c.setIsBeginAllowed(value);
         }
      }
      
      protected function childrenBegin() : void
      {
         var c:DCComponent = null;
         for each(c in this.mChildren)
         {
            c.begin();
         }
      }
      
      protected function childrenEnd() : void
      {
         var i:int = 0;
         if(this.mChildren != null)
         {
            for(i = this.mChildren.length - 1; i > -1; )
            {
               DCComponent(this.mChildren[i]).end();
               i--;
            }
         }
      }
      
      public function childrenRequestResources() : void
      {
         var c:DCComponent = null;
         for each(c in this.mChildren)
         {
            c.requestResources();
         }
      }
      
      protected function childrenLogicUpdate(dt:int) : void
      {
         var c:DCComponent = null;
         for each(c in this.mChildren)
         {
            c.mTimeSinceLastLogicUpdate += dt;
            if(!Config.USE_LAZY_LOGIC_UPDATES || c.mTimeSinceLastLogicUpdate >= c.mLogicUpdateFrequency)
            {
               c.mTimeSinceLastLogicUpdate = 0;
               c.logicUpdate(dt);
            }
         }
      }
      
      public function createGetCurrentStep() : int
      {
         return this.loadGetCurrentStep() + this.buildGetCurrentStep();
      }
      
      public function createGetTotalSteps() : int
      {
         return this.loadGetTotalSteps() + this.buildGetTotalSteps();
      }
      
      public function notify(e:Object) : Boolean
      {
         return false;
      }
      
      public function persistenceSetData(value:XML) : void
      {
         this.mPersistenceData = value;
      }
      
      public function persistenceIsLoaded() : Boolean
      {
         return this.mPersistenceData != null;
      }
      
      public function persistenceGetData() : XML
      {
         return EUtils.stringToXML("<World/>");
      }
      
      public function persistenceGetRaw() : XML
      {
         return this.mPersistenceData;
      }
   }
}
