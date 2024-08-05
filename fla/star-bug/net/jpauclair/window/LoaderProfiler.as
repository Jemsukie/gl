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
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.jpauclair.IDisposable;
   import net.jpauclair.LoaderAnalyser;
   import net.jpauclair.Options;
   import net.jpauclair.SampleAnalyzer;
   import net.jpauclair.data.LoaderData;
   import net.jpauclair.ui.button.MenuButton;
   
   public class LoaderProfiler extends Sprite implements IDisposable
   {
      
      private static const COLOR_BACKGROUND:int = 4473924;
      
      public static const SAVE_FUNCTION_STACK_EVENT:String = "saveFunctionStackEvent";
      
      private static const ZERO_PERCENT:String = "0.00";
       
      
      private var mMainSprite:Stage = null;
      
      private var mBitmapBackgroundData:BitmapData = null;
      
      private var mBitmapLineData:BitmapData = null;
      
      private var mBitmapBackground:Bitmap = null;
      
      private var mBitmapLine:Bitmap = null;
      
      private var mGridLine:Rectangle = null;
      
      private var mProgressCenterPosition:int = 2;
      
      private var mAddedColumnStartPos:int = 250;
      
      private var mURLColPosition:int = 280;
      
      private var mSizeColPosition:int = 280;
      
      private var mCurrentColumnStartPos:int = 370;
      
      private var mHTTPStatusColPosition:int = 430;
      
      private var mBlittingTextField:TextField;
      
      private var mBlittingTextFieldCenter:TextField;
      
      private var mBlittingTextFieldARight:TextField;
      
      private var mBlittingTextFieldMatrix:Matrix = null;
      
      private var frameCount:int = 0;
      
      private var mLastTime:int = 0;
      
      private var mStackButtonArray:Array;
      
      private var mLoaderDict:Dictionary;
      
      private var IconStack:Class;
      
      private var IconStackOut:Class;
      
      private var IconArrowDown:Class;
      
      private var IconArrowDownOut:Class;
      
      private var mLastLen:int = 0;
      
      private var mProgressBarRect:Rectangle;
      
      public function LoaderProfiler(mainSprite:Stage)
      {
         this.IconStack = LoaderProfiler_IconStack;
         this.IconStackOut = LoaderProfiler_IconStackOut;
         this.IconArrowDown = LoaderProfiler_IconArrowDown;
         this.IconArrowDownOut = LoaderProfiler_IconArrowDownOut;
         this.mProgressBarRect = new Rectangle(20,0,100,11);
         super();
         this.Init(mainSprite);
      }
      
      private function Init(mainSprite:Stage) : void
      {
         var button:MenuButton = null;
         this.mMainSprite = mainSprite;
         this.mGridLine = new Rectangle();
         var numLines:int = 15;
         this.mLoaderDict = new Dictionary(true);
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
         this.mProgressCenterPosition = 20;
         this.mHTTPStatusColPosition = 70;
         this.mSizeColPosition = 130;
         this.mURLColPosition = 235;
         this.mAddedColumnStartPos = 100;
         var barWidth:int = this.mMainSprite.stageWidth;
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,false);
         var myformat2:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.RIGHT);
         var myformatCenter:TextFormat = new TextFormat("_sans",11,16777215,false,null,null,null,null,TextFormatAlign.CENTER);
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
         this.mBlittingTextFieldCenter = new TextField();
         this.mBlittingTextFieldCenter.autoSize = TextFieldAutoSize.CENTER;
         this.mBlittingTextFieldCenter.defaultTextFormat = myformatCenter;
         this.mBlittingTextFieldCenter.selectable = false;
         this.mBlittingTextFieldCenter.filters = [myglow];
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
      }
      
      private function OnSaveStack(e:Event) : void
      {
         var mbt:MenuButton = null;
         var len:int = int(this.mStackButtonArray.length);
         for(var i:int = 0; i < len; i++)
         {
            mbt = this.mStackButtonArray[i];
            if(mbt != null && mbt.mIsSelected)
            {
               if(mbt.mUrl != null && mbt.mUrl != "")
               {
                  System.setClipboard(mbt.mUrl);
               }
               else if(mbt.mLD != null && Boolean(mbt.mLD.mIOError))
               {
                  System.setClipboard(mbt.mLD.mIOError.toString());
               }
               else if(mbt.mLD != null && Boolean(mbt.mLD.mSecurityError))
               {
                  System.setClipboard(mbt.mLD.mSecurityError.toString());
               }
            }
            if(mbt != null)
            {
               mbt.Reset();
            }
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
         var len:int = int(this.mStackButtonArray.length);
         var i:int = 0;
         var vLoadersData:Array = LoaderAnalyser.GetInstance().GetLoadersData();
         vLoadersData.sortOn("mFirstEvent",Array.NUMERIC | Array.DESCENDING);
         var lCount:int = int(vLoadersData.length);
         len = int(vLoadersData.length);
         var maxLineCount:int = (stage.stageHeight - 25) / 16;
         if(len > maxLineCount)
         {
            len = maxLineCount;
         }
         this.mBlittingTextFieldMatrix.identity();
         this.mBlittingTextFieldMatrix.ty = 22;
         this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
         this.mBlittingTextFieldCenter.text = "Progress";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mURLColPosition;
         this.mBlittingTextField.text = "Url";
         this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mHTTPStatusColPosition;
         this.mBlittingTextFieldARight.text = "Status";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.tx = this.mSizeColPosition;
         this.mBlittingTextFieldARight.text = "Size";
         this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
         this.mBlittingTextFieldMatrix.ty += 14;
         this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
         this.mBitmapBackgroundData.fillRect(this.mGridLine,4291611852);
         var ld:LoaderData = null;
         for(i = 0; i < len; i++)
         {
            ld = vLoadersData[i];
            if(ld.mFirstEvent != -1)
            {
               this.mStackButtonArray[i].visible = true;
               this.DrawProgress(vLoadersData[i],40 + i * 14);
               if(this.mStackButtonArray[i].mUrl != ld.mUrl)
               {
                  this.mStackButtonArray[i].SetToolTipText("// Click = Copy to Clipboard\n" + ld.mUrl);
                  this.mStackButtonArray[i].mUrl = ld.mUrl;
                  this.mStackButtonArray[i].mLD = ld;
               }
               else if(ld.mIOError)
               {
                  this.mStackButtonArray[i].SetToolTipText("// Click = Copy to Clipboard\n" + ld.mIOError.text + "\n" + ld.mIOError);
               }
               else if(ld.mSecurityError)
               {
                  this.mStackButtonArray[i].SetToolTipText("// Click = Copy to Clipboard\n" + ld.mSecurityError.text + "\n" + ld.mSecurityError);
               }
               this.mBlittingTextFieldMatrix.tx = this.mProgressCenterPosition;
               this.mBlittingTextFieldCenter.text = ld.mProgressText;
               this.mBitmapBackgroundData.draw(this.mBlittingTextFieldCenter,this.mBlittingTextFieldMatrix);
               this.mBlittingTextFieldMatrix.tx = this.mHTTPStatusColPosition;
               if(ld.mHTTPStatusText == null)
               {
                  this.mBlittingTextFieldARight.text = LoaderData.LOADER_DEFAULT_HTTP_STATUS;
               }
               else
               {
                  this.mBlittingTextFieldARight.text = ld.mHTTPStatusText;
               }
               this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
               this.mBlittingTextFieldMatrix.tx = this.mSizeColPosition;
               this.mBlittingTextFieldARight.text = ld.mLoadedBytesText;
               this.mBitmapBackgroundData.draw(this.mBlittingTextFieldARight,this.mBlittingTextFieldMatrix);
               this.mBlittingTextFieldMatrix.tx = this.mURLColPosition;
               if(ld.mUrl == null)
               {
                  this.mBlittingTextField.text = LoaderData.LOADER_DEFAULT_URL;
               }
               else
               {
                  this.mBlittingTextField.text = ld.mUrl;
               }
               this.mBitmapBackgroundData.draw(this.mBlittingTextField,this.mBlittingTextFieldMatrix);
               this.mBlittingTextFieldMatrix.ty += 14;
               this.mGridLine.y = this.mBlittingTextFieldMatrix.ty + 2;
               this.mBitmapBackgroundData.fillRect(this.mGridLine,4291611852);
            }
         }
         this.Render();
      }
      
      private function Render() : void
      {
         this.alpha = Options.mCurrentGradient / 10;
      }
      
      private function DrawProgress(ld:LoaderData, positionY:int) : void
      {
         this.mProgressBarRect.y = positionY;
         this.mProgressBarRect.width = 100;
         var color:uint = 4286033179;
         if(ld.mIOError != null || ld.mSecurityError != null)
         {
            color = 4289666605;
         }
         else if(ld.mProgress == 0)
         {
            color = 4282664004;
         }
         else if(ld.mType == LoaderData.DISPLAY_LOADER)
         {
            this.mProgressBarRect.width = 100 * ld.mProgress;
         }
         else if(ld.mType == LoaderData.URL_STREAM)
         {
            color = 4292453302;
         }
         else
         {
            color = 4291090413;
         }
         this.mBitmapBackgroundData.fillRect(this.mProgressBarRect,color);
      }
      
      public function Dispose() : void
      {
         var mb:MenuButton = null;
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
