package net.jpauclair.window
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import net.jpauclair.IDisposable;
   import net.jpauclair.Options;
   import net.jpauclair.SampleAnalyzer;
   import net.jpauclair.data.InternalEventEntry;
   import net.jpauclair.ui.button.MenuButton;
   
   public class PerformanceProfiler extends Sprite implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
      
      public static const SAVE_FUNCTION_STACK_EVENT:String = "saveFunctionStackEvent";
      
      private static const ZERO_PERCENT:String = "0.00";
      
      private static const ENTRY_TIME_PROPERTY:String = "entryTime";
      
      private static const ENTRY_TIME_TOTAL_PROPERTY:String = "entryTimeTotal";
       
      
      private var mMainSprite:Stage = null;
      
      private var mBitmapBackgroundData:BitmapData = null;
      
      private var mBitmapLineData:BitmapData = null;
      
      private var mBitmapBackground:Bitmap = null;
      
      private var mBitmapLine:Bitmap = null;
      
      private var mGridLine:Rectangle = null;
      
      private var mClassPathColumnStartPos:int = 2;
      
      private var mAddedColumnStartPos:int = 250;
      
      private var mDeletedColumnStartPos:int = 280;
      
      private var mCurrentColumnStartPos:int = 370;
      
      private var mCumulColumnStartPos:int = 430;
      
      private var mBlittingTextField:TextField;
      
      private var mBlittingTextFieldARight:TextField;
      
      private var mBlittingTextFieldMatrix:Matrix = null;
      
      private var frameCount:int = 0;
      
      private var mLastTime:int = 0;
      
      private var mStackButtonArray:Array;
      
      private var IconStack:Class;
      
      private var IconStackOut:Class;
      
      private var IconArrowDown:Class;
      
      private var IconArrowDownOut:Class;
      
      private var mSelfSortButton:MenuButton;
      
      private var mTotalSortButton:MenuButton;
      
      private var mLastLen:int = 0;
      
      private var mUseSelfSort:Boolean = true;
      
      private var mProfilerWasActive:Boolean = false;
      
      public function PerformanceProfiler(mainSprite:Stage)
      {
         this.IconStack = PerformanceProfiler_IconStack;
         this.IconStackOut = PerformanceProfiler_IconStackOut;
         this.IconArrowDown = PerformanceProfiler_IconArrowDown;
         this.IconArrowDownOut = PerformanceProfiler_IconArrowDownOut;
         super();
         this.mProfilerWasActive = Configuration.PROFILE_FUNCTION;
         Configuration.PROFILE_FUNCTION = true;
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         var button:MenuButton = null;
         this.mMainSprite = mainSprite;
         this.mGridLine = new Rectangle();
         var numLines:int = 15;
         this.mBitmapBackgroundData = new BitmapData(this.mMainSprite.stageWidth,this.mMainSprite.stageHeight,true,0);
         this.mBitmapBackground = new Bitmap(this.mBitmapBackgroundData);
         this.mBitmapLineData = new BitmapData(this.mMainSprite.stageWidth,13,true,2298468096);
         this.mBitmapLine = new Bitmap(this.mBitmapLineData);
         this.mBitmapLine.y = -20;
         addChild(this.mBitmapBackground);
         addChild(this.mBitmapLine);
         this.mouseEnabled = false;
         this.mGridLine.width = this.mMainSprite.stageWidth;
         this.mGridLine.height = 1;
         this.mCumulColumnStartPos = this.mMainSprite.stageWidth - 110;
         this.mCurrentColumnStartPos = this.mCumulColumnStartPos - 40;
         this.mDeletedColumnStartPos = this.mCurrentColumnStartPos - 100;
         this.mAddedColumnStartPos = this.mDeletedColumnStartPos - 40;
         var barWidth:int = this.mMainSprite.stageWidth;
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myformat2:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.RIGHT);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.mBlittingTextField = new TextField();
         this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
         this.mBlittingTextField.defaultTextFormat = myformat;
         this.mBlittingTextField.selectable = false;
         this.mBlittingTextField.filters = [myglow];
         this.mBlittingTextField.mouseEnabled = false;
         this.mBlittingTextFieldARight = new TextField();
         this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
         this.mBlittingTextFieldARight.defaultTextFormat = myformat2;
         this.mBlittingTextFieldARight.selectable = false;
         this.mBlittingTextFieldARight.filters = [myglow];
         this.mBlittingTextFieldARight.mouseEnabled = false;
         this.mBlittingTextFieldMatrix = new Matrix();
         if(mainSprite.loaderInfo.applicationDomain.hasDefinition("flash.sampler.setSamplerCallback"))
         {
         }
         var maxLineCount:int = (mainSprite.stage.stageHeight - 25) / 16;
         this.mStackButtonArray = new Array();
         for(var i:int = 0; i < maxLineCount; i++)
         {
            button = new MenuButton(3,39 + i * 14,this.IconStackOut,this.IconStack,this.IconStackOut,SAVE_FUNCTION_STACK_EVENT,null,"",true,"Saved");
            this.mStackButtonArray.push(button);
            addChild(button);
            button.visible = false;
         }
         addEventListener(SAVE_FUNCTION_STACK_EVENT,this.OnSaveStack);
         this.mSelfSortButton = new MenuButton(this.mDeletedColumnStartPos - 14,25,this.IconArrowDownOut,this.IconArrowDown,this.IconArrowDownOut,null,null,"Sort by Self-Time",true,"");
         addChild(this.mSelfSortButton);
         this.mTotalSortButton = new MenuButton(this.mCumulColumnStartPos - 14,25,this.IconArrowDownOut,this.IconArrowDown,this.IconArrowDownOut,null,null,"Sort by Total-Time",true,"");
         addChild(this.mTotalSortButton);
      }
      
      private function OnSaveStack(e:Event) : void
      {
         var mbt:MenuButton = null;
         var o:String = null;
         var len:int = int(this.mStackButtonArray.length);
         for(var i:int = 0; i < len; i++)
         {
            mbt = this.mStackButtonArray[i];
            if(mbt != null && mbt.mIsSelected)
            {
               o = String(mbt.mInternalEvent.mStackFrame);
               while(o.indexOf(",") != -1)
               {
                  o = o.replace(",","\n");
               }
               System.setClipboard(o);
            }
            if(mbt != null)
            {
               mbt.Reset();
            }
         }
      }
      
      private function OnCopyStack(e:Event) : void
      {
         System.setClipboard(e.target.mInternalEvent.mStackFrame);
      }
      
      public function Update() : void
      {
         var percent:Number = NaN;
         if(this.mTotalSortButton.mIsSelected)
         {
            this.mUseSelfSort = false;
            this.mTotalSortButton.mIsSelected = false;
         }
         if(this.mSelfSortButton.mIsSelected)
         {
            this.mUseSelfSort = true;
            this.mSelfSortButton.mIsSelected = false;
         }
         if(mouseY >= 42 && mouseY < 42 + this.mLastLen * 14)
         {
            this.mBitmapLine.y = mouseY - mouseY % 14 - 3;
         }
         else
         {
            this.mBitmapLine.y = -20;
         }
         if(this.frameCount++ % Options.mCurrentClock != 0)
         {
            return;
         }
         var diff:int = getTimer() - this.mLastTime;
         this.mLastTime = getTimer();
         SampleAnalyzer.GetInstance().PauseSampling();
         SampleAnalyzer.GetInstance().ProcessSampling();
         this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect,4278190080);
         var vFunctionTimes:Array = SampleAnalyzer.GetInstance().GetFunctionTimes();
         if(this.mUseSelfSort)
         {
            vFunctionTimes.sortOn(ENTRY_TIME_PROPERTY,Array.NUMERIC | Array.DESCENDING);
         }
         else
         {
            vFunctionTimes.sortOn(ENTRY_TIME_TOTAL_PROPERTY,Array.NUMERIC | Array.DESCENDING);
         }
         var len:int = int(this.mStackButtonArray.length);
         var i:int = 0;
         var holder:InternalEventEntry = null;
         len = int(vFunctionTimes.length);
         var totalTime:int = 0;
         this.mLastLen = len;
         for(i = 0; i < len; i++)
         {
            holder = vFunctionTimes[i];
            totalTime += holder.entryTime;
         }
         var maxLineCount:int = (stage.stageHeight - 25) / 16;
         if(len > maxLineCount)
         {
            len = maxLineCount;
         }
         this.mBlittingTextFieldMatrix.identity();
         this.mBlittingTextFieldMatrix.ty = 22;
         this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
         this.mBlittingTextField.text = "[FunctionName]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
         this.mBlittingTextFieldARight.text = "(%)";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Self] (µs)";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Total] (µs)";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
         this.mBlittingTextFieldARight.text = "(%)";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.mBitmapBackgroundData.fillRect(this.mGridLine,4291611852);
         for(i = 0; i < len; i++)
         {
            this.mStackButtonArray[i].visible = true;
            holder = vFunctionTimes[i];
            if(this.mStackButtonArray[i].mInternalEvent != holder)
            {
               this.mStackButtonArray[i].SetToolTipText("// Click = Copy to Clipboard\n" + holder.mStack);
               this.mStackButtonArray[i].mInternalEvent = holder;
            }
            this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos + 16;
            this.mBlittingTextField.text = holder.qName;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
            percent = int(holder.entryTime / totalTime * 10000) / 100;
            if(percent == 0)
            {
               this.mBlittingTextFieldARight.text = ZERO_PERCENT;
            }
            else
            {
               this.mBlittingTextFieldARight.text = String(percent);
            }
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.entryTime.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.entryTimeTotal.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
            percent = int(holder.entryTimeTotal / totalTime * 10000) / 100;
            if(percent == 0)
            {
               this.mBlittingTextFieldARight.text = ZERO_PERCENT;
            }
            else
            {
               this.mBlittingTextFieldARight.text = String(percent);
            }
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.ty += 14;
            this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
            this.mBitmapBackgroundData.fillRect(this.mGridLine,4291611852);
         }
         this.Render();
      }
      
      private function Render() : void
      {
         this.alpha = Options.mCurrentGradient / 10;
      }
      
      public function Dispose() : void
      {
         var mb:MenuButton = null;
         Configuration.PROFILE_FUNCTION = this.mProfilerWasActive;
         if(!this.mProfilerWasActive)
         {
            SampleAnalyzer.GetInstance().ResetPerformanceStats();
         }
         for each(mb in this.mStackButtonArray)
         {
            mb.Dispose();
         }
         this.mStackButtonArray = null;
         this.mGridLine = null;
         this.mBlittingTextField = null;
         this.mBlittingTextFieldARight = null;
         this.mBlittingTextFieldMatrix = null;
         this.mBitmapBackgroundData.dispose();
         this.mBitmapBackgroundData = null;
         this.mBitmapBackground = null;
         if(this.mMainSprite != null && this.mMainSprite != null)
         {
            this.mMainSprite = null;
         }
      }
   }
}
