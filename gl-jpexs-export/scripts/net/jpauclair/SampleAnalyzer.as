package net.jpauclair
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.LocalConnection;
   import flash.net.URLLoader;
   import flash.net.URLStream;
   import flash.sampler.DeleteObjectSample;
   import flash.sampler.NewObjectSample;
   import flash.sampler.Sample;
   import flash.sampler.clearSamples;
   import flash.sampler.getSamples;
   import flash.sampler.pauseSampling;
   import flash.sampler.setSamplerCallback;
   import flash.sampler.startSampling;
   import flash.sampler.stopSampling;
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import net.jpauclair.data.ClassTypeStatsHolder;
   import net.jpauclair.data.InternalEventEntry;
   import net.jpauclair.data.InternalEventsStatsHolder;
   import net.jpauclair.window.Configuration;
   import net.jpauclair.window.FlashStats;
   
   public class SampleAnalyzer
   {
      
      private static const INTERNAL_EVENT_VERIFY:String = "[verify]";
      
      private static const INTERNAL_EVENT_MARK:String = "[mark]";
      
      private static const INTERNAL_EVENT_REAP:String = "[reap]";
      
      private static const INTERNAL_EVENT_SWEEP:String = "[sweep]";
      
      private static const INTERNAL_EVENT_ENTERFRAME:String = "[enterFrameEvent]";
      
      private static const INTERNAL_EVENT_TIMER_TICK:String = "flash.utils::Timer/tick";
      
      private static const INTERNAL_EVENT_PRE_RENDER:String = "[pre-render]";
      
      private static const INTERNAL_EVENT_RENDER:String = "[render]";
      
      private static const INTERNAL_EVENT_AVM1:String = "[avm1]";
      
      private static const INTERNAL_EVENT_MOUSE:String = "[mouseEvent]";
      
      private static const INTERNAL_EVENT_IO:String = "[io]";
      
      private static const INTERNAL_EVENT_EXECUTE_QUEUE:String = "[execute-queued]";
      
      private static var mInstance:SampleAnalyzer = null;
       
      
      private var mInternalStats:InternalEventsStatsHolder;
      
      private var mFullObjectDict:Dictionary = null;
      
      private var mObjectTypeDict:Dictionary = null;
      
      private var mInternalPlayerActionDict:Dictionary = null;
      
      private var mFunctionTimes:Dictionary = null;
      
      private var mFunctionTimesArray:Array = null;
      
      private var mStatsTypeList:Array = null;
      
      private var lastSampleTime:Number = 0;
      
      private var lastSample:Sample = null;
      
      private var mIsSampling:Boolean = false;
      
      private var mIsSamplingPaused:Boolean = false;
      
      private var tempArray:Array = null;
      
      private var mIsRecording:Boolean = false;
      
      private var ms_prev:int = 0;
      
      public function SampleAnalyzer()
      {
         this.mInternalStats = new InternalEventsStatsHolder();
         super();
         this.mFullObjectDict = new Dictionary();
         this.mObjectTypeDict = new Dictionary();
         this.mInternalPlayerActionDict = new Dictionary();
         this.mFunctionTimes = new Dictionary();
         this.mFunctionTimesArray = new Array();
         this.mStatsTypeList = new Array();
         this.lastSampleTime = 0;
         mInstance = this;
         this.tempArray = new Array();
         setSamplerCallback(this.SamplerCallBack);
      }
      
      public static function GetInstance() : SampleAnalyzer
      {
         if(mInstance == null)
         {
            mInstance = new SampleAnalyzer();
         }
         return mInstance;
      }
      
      public function StartSampling() : void
      {
         this.mIsSampling = true;
         this.mIsSamplingPaused = false;
         startSampling();
      }
      
      public function PauseSampling() : void
      {
         if(this.mIsSampling && !this.mIsSamplingPaused)
         {
            pauseSampling();
            this.mIsSamplingPaused = true;
         }
      }
      
      public function IsSamplingPaused() : Boolean
      {
         return this.mIsSamplingPaused;
      }
      
      public function ResumeSampling() : void
      {
         if(this.mIsSampling && this.mIsSamplingPaused)
         {
            startSampling();
            this.mIsSamplingPaused = false;
         }
      }
      
      public function StopSampling() : void
      {
         this.mIsSampling = false;
         this.mIsSamplingPaused = false;
         stopSampling();
      }
      
      public function ClearSamples() : void
      {
         clearSamples();
      }
      
      public function ForceGC() : void
      {
         try
         {
            new LocalConnection().connect("Force GC!");
            new LocalConnection().connect("Force GC!");
         }
         catch(e:Error)
         {
         }
      }
      
      public function GetInternalsEvents() : InternalEventsStatsHolder
      {
         return this.mInternalStats;
      }
      
      public function GetFunctionTimes() : Array
      {
         return this.mFunctionTimesArray;
      }
      
      public function GetClassInstanciationStats() : Array
      {
         return this.mStatsTypeList;
      }
      
      public function GetFrameDataArray() : Array
      {
         return this.tempArray;
      }
      
      public function ResetMemoryStats() : void
      {
         var stat:ClassTypeStatsHolder = null;
         for each(stat in this.mStatsTypeList)
         {
            stat.Added = 0;
            stat.Removed = 0;
            stat.Current = 0;
            stat.Cumul = 0;
         }
      }
      
      public function ResetPerformanceStats() : void
      {
         var stat:InternalEventEntry = null;
         for each(stat in this.mFunctionTimes)
         {
            stat.Clear();
         }
      }
      
      private function SamplerCallBack(e:* = null) : void
      {
         pauseSampling();
         this.ProcessSampling();
         startSampling();
      }
      
      public function ProcessSampling() : void
      {
         var newSample:NewObjectSample = null;
         var deleteSample:DeleteObjectSample = null;
         var s:Sample = null;
         var timer:int = 0;
         var timeDiff:Number = NaN;
         var obj:* = undefined;
         var sf:String = null;
         var stackLen:int = 0;
         var currentStackDepth:int = 0;
         var functionName:String = null;
         var stat:* = undefined;
         var statEntry:InternalEventEntry = null;
         pauseSampling();
         if(Configuration.PROFILE_MEMGRAPH)
         {
            timer = getTimer();
            if(timer >= this.ms_prev + 300)
            {
               --FlashStats.mSamplingStartIdx;
               if(FlashStats.mSamplingStartIdx < 0)
               {
                  FlashStats.mSamplingStartIdx = FlashStats.mSamplingCount - 1;
               }
               this.ms_prev = timer;
               FlashStats.mMemoryValues[FlashStats.mSamplingStartIdx % FlashStats.mSamplingCount] = System.totalMemory / 1024;
               if(System.totalMemory / 1024 > FlashStats.stats.MemoryMax)
               {
                  FlashStats.stats.MemoryMax = System.totalMemory / 1024;
               }
               FlashStats.mMemoryMaxValues[FlashStats.mSamplingStartIdx % FlashStats.mSamplingCount] = FlashStats.stats.MemoryMax;
            }
         }
         var o:* = getSamples();
         var holder:ClassTypeStatsHolder = null;
         if(Options.mIsCollectingData)
         {
            if(!this.mIsRecording)
            {
               this.tempArray.splice();
               this.mIsRecording = true;
            }
         }
         else
         {
            this.mIsRecording = false;
         }
         var sampleStack:Array = null;
         for each(s in o)
         {
            if(this.lastSampleTime == 0)
            {
               this.lastSampleTime = s.time;
            }
            timeDiff = s.time - this.lastSampleTime;
            this.lastSampleTime = s.time;
            newSample = s as NewObjectSample;
            sampleStack = s.stack;
            if(newSample != null)
            {
               obj = newSample.object;
               if(Options.mIsCollectingData)
               {
                  if(sampleStack != null)
                  {
                     this.tempArray.push(s.time,"NewObject\t" + newSample.id + "\t" + newSample.type + "\t" + sampleStack);
                  }
               }
               if(obj is Event && sampleStack != null && sampleStack.length == 1)
               {
                  if(sampleStack[0].name == INTERNAL_EVENT_ENTERFRAME)
                  {
                     this.mInternalStats.mFree.Add(timeDiff);
                  }
               }
               if(Configuration.PROFILE_LOADERS)
               {
                  if(obj is Loader)
                  {
                     LoaderAnalyser.GetInstance().PushLoader(obj);
                  }
                  else if(obj is URLStream)
                  {
                     LoaderAnalyser.GetInstance().PushLoader(obj);
                  }
                  else if(obj is URLLoader)
                  {
                     LoaderAnalyser.GetInstance().PushLoader(obj);
                  }
               }
               if(Configuration.PROFILE_MEMORY)
               {
                  holder = this.mObjectTypeDict[newSample.type] as ClassTypeStatsHolder;
                  if(holder == null)
                  {
                     holder = new ClassTypeStatsHolder();
                     holder.Type = newSample.type;
                     holder.TypeName = getQualifiedClassName(newSample.type);
                     this.mStatsTypeList.push(holder);
                     this.mObjectTypeDict[newSample.type] = holder;
                     this.mFullObjectDict[newSample.id] = holder;
                  }
                  else
                  {
                     ++holder.Added;
                     ++holder.Cumul;
                     ++holder.Current;
                     this.mFullObjectDict[newSample.id] = holder;
                  }
               }
               continue;
            }
            if((deleteSample = s as DeleteObjectSample) != null)
            {
               if(Options.mIsCollectingData)
               {
                  this.tempArray.push(s.time,"DeletedObject\t" + deleteSample.id);
               }
               if(Configuration.PROFILE_MEMORY)
               {
                  if(this.mFullObjectDict[deleteSample.id] != undefined)
                  {
                     holder = this.mFullObjectDict[deleteSample.id];
                     ++holder.Removed;
                     --holder.Current;
                     if(holder.Current > int.MAX_VALUE / 2)
                     {
                        holder.Current = 0;
                     }
                     delete this.mFullObjectDict[deleteSample.id];
                  }
               }
               continue;
            }
            if(Options.mIsCollectingData)
            {
               if(sampleStack != null)
               {
                  this.tempArray.push(s.time,"BaseSample\t" + sampleStack);
               }
            }
            sf = null;
            if(Configuration.PROFILE_FUNCTION)
            {
               stackLen = int(sampleStack.length);
               sf = String(sampleStack[stackLen - 1].name);
               for(currentStackDepth = 0; currentStackDepth < stackLen; currentStackDepth++)
               {
                  functionName = String(sampleStack[currentStackDepth].name);
                  stat = this.mFunctionTimes[functionName];
                  if(stat == undefined)
                  {
                     stat = new InternalEventEntry();
                     stat.SetStack(sampleStack);
                     stat.qName = functionName;
                     this.mFunctionTimesArray.push(stat);
                     this.mFunctionTimes[functionName] = stat;
                  }
                  statEntry = stat;
                  if(currentStackDepth == 0)
                  {
                     statEntry.Add(timeDiff);
                  }
                  else
                  {
                     statEntry.AddParentTime(timeDiff);
                  }
               }
            }
            if(!Configuration.PROFILE_INTERNAL_EVENTS)
            {
               continue;
            }
            if(sf == null)
            {
               sf = String(sampleStack[sampleStack.length - 1].name);
            }
            switch(sf)
            {
               case INTERNAL_EVENT_ENTERFRAME:
                  this.mInternalStats.mEnterFrame.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_MARK:
                  this.mInternalStats.mMark.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_REAP:
                  this.mInternalStats.mReap.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_SWEEP:
                  this.mInternalStats.mSweep.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_PRE_RENDER:
                  this.mInternalStats.mPreRender.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_RENDER:
                  this.mInternalStats.mRender.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_VERIFY:
                  this.mInternalStats.mVerify.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_TIMER_TICK:
                  this.mInternalStats.mTimers.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_AVM1:
                  this.mInternalStats.mAvm1.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_MOUSE:
                  this.mInternalStats.mMouse.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_IO:
                  this.mInternalStats.mIo.Add(timeDiff);
                  break;
               case INTERNAL_EVENT_EXECUTE_QUEUE:
                  this.mInternalStats.mExecuteQueue.Add(timeDiff);
                  break;
            }
         }
         this.lastSample = s;
         clearSamples();
      }
   }
}
