package net.jpauclair.window
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import net.jpauclair.IDisposable;
   import net.jpauclair.Options;
   import net.jpauclair.data.FrameStatistics;
   
   public class FlashStats extends Bitmap implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
      
      public static var stats:FrameStatistics = new FrameStatistics();
      
      public static var mMemoryValues:Vector.<int> = null;
      
      public static var mMemoryMaxValues:Vector.<int> = null;
      
      public static var mSamplingCount:int = 300;
      
      public static var mSamplingStartIdx:int = 0;
      
      public static var IsStaticInitialized:Boolean = InitStatic();
       
      
      private var mMainSprite:Stage = null;
      
      private var mMemoryUseBitmapData:BitmapData = null;
      
      private var mBitmapBackgroundData:BitmapData = null;
      
      private var mBitmapBackground:Bitmap = null;
      
      private var mGridLine:Rectangle = null;
      
      private var mTypeColumnStartPos:int = 2;
      
      private var mCurrentColumnStartPos:int = 80;
      
      private var mMinColumnStartPos:int = 130;
      
      private var mMaxColumnStartPos:int = 180;
      
      private var mBlittingTextField:TextField;
      
      private var mBlittingTextFieldARight:TextField;
      
      private var mBlittingTextFieldMatrix:Matrix = null;
      
      private var frameCount:int = 0;
      
      private var mLastTime:int = 0;
      
      private var statsLastFrame:FrameStatistics;
      
      private var timer:int;
      
      private var ms_prev:int;
      
      private var fps:int = 0;
      
      private var mDrawGraphics:Sprite;
      
      private var mDrawGraphicsMatrix:Matrix;
      
      private var mGraphPos:Point;
      
      private var mCurrentMaxMemGraph:int = 0;
      
      private var lastGraphHeight:int = 0;
      
      private var mProfilerWasActive:Boolean = false;
      
      public function FlashStats(mainSprite:Stage)
      {
         super();
         this.mProfilerWasActive = Configuration.PROFILE_MEMGRAPH;
         Configuration.PROFILE_MEMGRAPH = true;
         this.Init(mainSprite);
      }
      
      private static function InitStatic() : Boolean
      {
         mMemoryValues = new Vector.<int>(mSamplingCount);
         mMemoryMaxValues = new Vector.<int>(mSamplingCount);
         for(var i:int = 0; i < mSamplingCount; i++)
         {
            mMemoryValues[i] = -1;
            mMemoryMaxValues[i] = -1;
         }
         return true;
      }
      
      private function Init(mainSprite:Stage) : void
      {
         this.statsLastFrame = new FrameStatistics();
         this.mMainSprite = mainSprite;
         this.mGridLine = new Rectangle();
         var numLines:int = 15;
         for(var i:int = 0; i < mSamplingCount; i++)
         {
            if(!this.mProfilerWasActive)
            {
               mMemoryMaxValues[i] = -1;
               mMemoryValues[i] = -1;
            }
            if(mMemoryMaxValues[i] > stats.MemoryMax)
            {
               stats.MemoryMax = mMemoryMaxValues[i];
            }
         }
         this.mBitmapBackgroundData = new BitmapData(this.mMainSprite.stageWidth,this.mMainSprite.stageHeight,true,0);
         this.mMemoryUseBitmapData = new BitmapData(this.mMainSprite.stageWidth,150,false,4294967295);
         this.mGraphPos = new Point(0,this.mMainSprite.stageHeight - 150);
         this.mDrawGraphics = new Sprite();
         this.mDrawGraphicsMatrix = new Matrix(1,0,0,1,this.mMainSprite.stageWidth - 5);
         this.mDrawGraphics.graphics.lineStyle(3,4294901760);
         this.mGridLine.width = this.mMainSprite.stageWidth;
         this.mGridLine.height = 1;
         this.bitmapData = this.mBitmapBackgroundData;
         var barWidth:int = this.mMainSprite.stageWidth;
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myformat2:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.RIGHT);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.mBlittingTextField = new TextField();
         this.mBlittingTextField.autoSize = TextFieldAutoSize.LEFT;
         this.mBlittingTextField.defaultTextFormat = myformat;
         this.mBlittingTextField.selectable = false;
         this.mBlittingTextField.filters = [myglow];
         this.mBlittingTextFieldARight = new TextField();
         this.mBlittingTextFieldARight.autoSize = TextFieldAutoSize.RIGHT;
         this.mBlittingTextFieldARight.defaultTextFormat = myformat2;
         this.mBlittingTextFieldARight.selectable = false;
         this.mBlittingTextFieldARight.filters = [myglow];
         this.mBlittingTextFieldMatrix = new Matrix();
         this.fps = mainSprite.frameRate;
         stats.MemoryFree = System.freeMemory / 1024;
         stats.MemoryPrivate = System.privateMemory / 1024;
         stats.MemoryCurrent = System.totalMemory / 1024;
         this.statsLastFrame.Copy(stats);
         this.mCurrentMaxMemGraph = stats.MemoryCurrent;
      }
      
      public function Update() : void
      {
         var sliceWidth:Number = NaN;
         var i:int = 0;
         var sampleVal:int = 0;
         var val:int = 0;
         var it:int = 0;
         var currentX:int = 0;
         this.timer = getTimer();
         if(this.timer - 1000 < this.ms_prev)
         {
            ++this.fps;
            return;
         }
         stats.FpsCurrent = this.fps;
         this.ms_prev = this.timer;
         this.mBitmapBackgroundData.fillRect(this.mBitmapBackgroundData.rect,4278190080);
         stats.MemoryFree = System.freeMemory / 1024;
         stats.MemoryPrivate = System.privateMemory / 1024;
         stats.MemoryCurrent = System.totalMemory / 1024;
         if(stats.MemoryCurrent < stats.MemoryMin)
         {
            stats.MemoryMin = stats.MemoryCurrent;
         }
         if(stats.MemoryCurrent > stats.MemoryMax)
         {
            stats.MemoryMax = stats.MemoryCurrent;
         }
         if(stats.FpsCurrent < stats.FpsMin)
         {
            stats.FpsMin = stats.FpsCurrent;
         }
         if(stats.FpsCurrent > stats.FpsMax)
         {
            stats.FpsMax = stats.FpsCurrent;
         }
         this.mBlittingTextFieldMatrix.identity();
         this.mBlittingTextFieldMatrix.ty = 22;
         if(Configuration.PROFILE_MEMGRAPH)
         {
            this.mDrawGraphics.graphics.clear();
            sliceWidth = stage.stageWidth / mSamplingCount;
            i = 0;
            sampleVal = 0;
            val = 0;
            this.mDrawGraphics.graphics.lineStyle(5,4294901760);
            it = mSamplingStartIdx;
            currentX = mSamplingCount * sliceWidth;
            this.mDrawGraphics.graphics.moveTo(currentX,150);
            for(i = 0; i < mSamplingCount; i++)
            {
               sampleVal = mMemoryMaxValues[it % mSamplingCount];
               it++;
               if(sampleVal != -1)
               {
                  val = 150 - sampleVal / stats.MemoryMax * 148;
                  this.mDrawGraphics.graphics.lineTo(currentX,val);
                  currentX -= sliceWidth;
               }
            }
            this.mDrawGraphics.graphics.lineStyle(3,4278190335);
            it = mSamplingStartIdx;
            currentX = mSamplingCount * sliceWidth;
            this.mDrawGraphics.graphics.moveTo(currentX,150);
            for(i = 0; i < mSamplingCount; i++)
            {
               sampleVal = mMemoryValues[it % mSamplingCount];
               it++;
               if(sampleVal != -1)
               {
                  val = 150 - sampleVal / stats.MemoryMax * 148;
                  this.mDrawGraphics.graphics.lineTo(currentX,val);
                  currentX -= sliceWidth;
               }
            }
            this.mMemoryUseBitmapData.fillRect(this.mMemoryUseBitmapData.rect,4287137928);
            this.mMemoryUseBitmapData.draw(this.mDrawGraphics);
         }
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = "Current";
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
         this.mBlittingTextFieldARight.text = "Min";
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
         this.mBlittingTextFieldARight.text = "Max";
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.bitmapData.fillRect(this.mGridLine,4291611852);
         this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
         this.mBlittingTextField.text = "fps:";
         this.bitmapData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.FpsCurrent.toString() + " / " + this.mMainSprite.frameRate;
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.FpsMin.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.FpsMax.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.bitmapData.fillRect(this.mGridLine,4291611852);
         this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
         this.mBlittingTextField.text = "total-memory (Ko):";
         this.bitmapData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.MemoryCurrent.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMinColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.MemoryMin.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mMaxColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.MemoryMax.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.bitmapData.fillRect(this.mGridLine,4291611852);
         this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
         this.mBlittingTextField.text = "free-memory (Ko):";
         this.bitmapData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.MemoryFree.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.bitmapData.fillRect(this.mGridLine,4291611852);
         this.mBlittingTextFieldMatrix.tx = this.mTypeColumnStartPos;
         this.mBlittingTextField.text = "private-memory (Ko):";
         this.bitmapData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = stats.MemoryPrivate.toString();
         this.bitmapData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.bitmapData.fillRect(this.mGridLine,4291611852);
         this.Render();
         this.statsLastFrame.Copy(stats);
         this.fps = 0;
      }
      
      private function Render() : void
      {
         this.bitmapData.copyPixels(this.mMemoryUseBitmapData,this.mMemoryUseBitmapData.rect,this.mGraphPos);
         this.alpha = Options.mCurrentGradient / 10;
      }
      
      public function Dispose() : void
      {
         Configuration.PROFILE_MEMGRAPH = this.mProfilerWasActive;
         this.mMemoryUseBitmapData.dispose();
         this.mMemoryUseBitmapData = null;
         this.mBitmapBackgroundData.dispose();
         this.mBitmapBackgroundData = null;
         this.mBitmapBackground = null;
         this.mGridLine = null;
         this.mBlittingTextField = null;
         this.mBlittingTextFieldARight = null;
         this.mBlittingTextFieldMatrix = null;
         this.statsLastFrame = null;
         this.mDrawGraphics = null;
         this.mDrawGraphicsMatrix = null;
         this.mGraphPos = null;
         if(this.mMainSprite != null && this.mMainSprite != null)
         {
            this.mMainSprite = null;
         }
      }
   }
}
