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
   import net.jpauclair.data.ClassTypeStatsHolder;
   
   public class SamplerProfiler extends Sprite implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
       
      
      private var mMainSprite:Stage = null;
      
      private var mBitmapBackgroundData:BitmapData = null;
      
      private var mBitmapLineData:BitmapData = null;
      
      private var mBitmapBackground:Bitmap = null;
      
      private var mBitmapLine:Bitmap = null;
      
      private var mGridLine:Rectangle = null;
      
      private var mClassPathColumnStartPos:int = 2;
      
      private var mAddedColumnStartPos:int = 250;
      
      private var mDeletedColumnStartPos:int = 300;
      
      private var mCurrentColumnStartPos:int = 370;
      
      private var mCumulColumnStartPos:int = 430;
      
      private var mBlittingTextField:TextField;
      
      private var mBlittingTextFieldARight:TextField;
      
      private var mBlittingTextFieldMatrix:Matrix = null;
      
      private var frameCount:int = 0;
      
      private var mLastTime:int = 0;
      
      private var mProfilerWasActive:Boolean = false;
      
      private var mLastLen:int = 0;
      
      public function SamplerProfiler(mainSprite:Stage)
      {
         super();
         this.mProfilerWasActive = Configuration.PROFILE_MEMORY;
         Configuration.PROFILE_MEMORY = true;
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         this.mMainSprite = mainSprite;
         this.mGridLine = new Rectangle();
         this.mouseEnabled = false;
         this.mBitmapBackgroundData = new BitmapData(this.mMainSprite.stageWidth,this.mMainSprite.stageHeight,true,0);
         this.mBitmapBackground = new Bitmap(this.mBitmapBackgroundData);
         this.mGridLine.width = this.mMainSprite.stageWidth;
         this.mGridLine.height = 1;
         this.mBitmapLineData = new BitmapData(this.mMainSprite.stageWidth,13,true,2298468096);
         this.mBitmapLine = new Bitmap(this.mBitmapLineData);
         this.mBitmapLine.y = -20;
         addChild(this.mBitmapBackground);
         addChild(this.mBitmapLine);
         this.mCumulColumnStartPos = this.mMainSprite.stageWidth - 110;
         this.mCurrentColumnStartPos = this.mCumulColumnStartPos - 80;
         this.mDeletedColumnStartPos = this.mCurrentColumnStartPos - 80;
         this.mAddedColumnStartPos = this.mDeletedColumnStartPos - 80;
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
      }
      
      public function Update() : void
      {
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
         var classList:Array = SampleAnalyzer.GetInstance().GetClassInstanciationStats();
         classList.sortOn("Cumul",Array.NUMERIC | Array.DESCENDING);
         var holder:ClassTypeStatsHolder = null;
         var len:int = int(classList.length);
         var maxLineCount:int = (stage.stageHeight - 25) / 16;
         if(len > maxLineCount)
         {
            len = maxLineCount;
         }
         this.mBlittingTextFieldMatrix.identity();
         this.mBlittingTextFieldMatrix.ty = 22;
         this.mLastLen = len;
         this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
         this.mBlittingTextField.text = "[QName]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Add]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Del]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Current]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
         this.mBlittingTextFieldARight.text = "[Cumul]";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.mBitmapBackgroundData.fillRect(this.mGridLine,4291611852);
         for(var i:int = 0; i < len; i++)
         {
            holder = classList[i];
            this.mBlittingTextFieldMatrix.tx = this.mClassPathColumnStartPos;
            this.mBlittingTextField.text = holder.TypeName;
            this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mAddedColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.Added.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mDeletedColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.Removed.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCurrentColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.Current.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            this.mBlittingTextFieldMatrix.tx = this.mCumulColumnStartPos;
            this.mBlittingTextFieldARight.text = holder.Cumul.toString();
            this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
            holder.Added = 0;
            holder.Removed = 0;
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
         Configuration.PROFILE_MEMORY = this.mProfilerWasActive;
         if(!this.mProfilerWasActive)
         {
            SampleAnalyzer.GetInstance().ResetMemoryStats();
         }
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
