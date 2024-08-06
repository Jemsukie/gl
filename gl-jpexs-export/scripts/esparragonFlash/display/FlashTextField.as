package esparragonFlash.display
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import esparragon.display.ETextField;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class FlashTextField extends ETextField
   {
      
      private static const DEFAULT_TEXT:String = "?";
       
      
      private var mTextField:TextField;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mVAlign:String;
      
      private var mHAlign:String;
      
      private var mAutoScale:Boolean;
      
      private var mFontName:String;
      
      private var mFontSize:Number;
      
      private var mText:String;
      
      private var mColor:uint;
      
      private var mBold:Boolean;
      
      private var mItalic:Boolean;
      
      private var mUnderline:Boolean;
      
      private var mKerning:Boolean;
      
      private var mBorder:Boolean;
      
      private var mAutoSize:Boolean;
      
      private var mWordWrap:Boolean;
      
      private var mMultiline:Boolean;
      
      private var mOriginalWidth:Number;
      
      private var mOriginalHeight:Number;
      
      private var mUpdateTextField:Boolean = false;
      
      private var mVisible:Boolean;
      
      private var mHasBeenInitialized:Boolean;
      
      private var mTextColorTransformsStack:Vector.<uint>;
      
      private var mInitialTextColorTransform:uint;
      
      public function FlashTextField(width:int = 100, height:int = 100, text:String = null, fontName:String = "Verdana", fontSize:Number = 12, color:uint = 16777215, bold:Boolean = false)
      {
         super();
         this.mTextField = new TextField();
         this.setEditable(false);
         addChild(this.mTextField);
         this.mWidth = width;
         this.mHeight = height;
         this.mOriginalWidth = this.mWidth;
         this.mOriginalHeight = this.mHeight;
         this.setBorder(false);
         this.mAutoScale = true;
         this.mVAlign = "center";
         this.mHAlign = "center";
         this.mWordWrap = false;
         this.mVisible = super.visible;
         if(text != null)
         {
            this.setText(text);
            this.mHasBeenInitialized = true;
         }
         else
         {
            this.setText("?");
            super.visible = false;
            this.mHasBeenInitialized = false;
         }
         this.setFontName(fontName);
         this.mFontSize = fontSize;
         this.mColor = color;
         this.mBold = bold;
         this.mKerning = true;
         this.mMultiline = true;
         this.mTextColorTransformsStack = new Vector.<uint>(0);
         this.mInitialTextColorTransform = this.mColor;
         this.changeDefaultFormat();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mTextField = null;
         this.mUpdateTextField = false;
      }
      
      override public function get visible() : Boolean
      {
         return this.mVisible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         this.mVisible = value;
         if(this.mHasBeenInitialized)
         {
            super.visible = value;
         }
      }
      
      override public function setText(value:String) : void
      {
         if(!this.mHasBeenInitialized)
         {
            this.mHasBeenInitialized = true;
            this.visible = this.mVisible;
         }
         if(value != this.mText)
         {
            if(value == null)
            {
               value = "";
            }
            this.mText = value;
            if(!checkTextFieldGlyphs(this.mText))
            {
               this.changeDefaultFormat();
            }
         }
      }
      
      override public function getText() : String
      {
         return this.mTextField.text;
      }
      
      override public function setWordWrap(value:Boolean) : void
      {
         this.mWordWrap = value;
         this.changeDefaultFormat();
      }
      
      override public function setVAlign(value:String) : void
      {
         this.mVAlign = value;
         this.changeDefaultFormat();
      }
      
      private function performVAlign() : void
      {
         var textlineMetrics:TextLineMetrics = null;
         var ctextHeight:Number = this.mTextField.textHeight;
         if(this.mVAlign == "top" || ctextHeight == 0)
         {
            this.mTextField.y = 0;
         }
         else if(this.mVAlign == "center")
         {
            this.mTextField.y = (this.mHeight - ctextHeight) / 2;
         }
         else
         {
            this.mTextField.y = this.mHeight - ctextHeight - 4;
         }
         var ctextWidth:Number = this.mTextField.width;
         if(this.mHAlign == "left" || ctextWidth == 0)
         {
            this.mTextField.x = 0;
         }
         else if(this.mHAlign == "center")
         {
            this.mTextField.x = (this.mWidth - ctextWidth) / 2;
         }
         else
         {
            this.mTextField.x = this.mWidth - ctextWidth - 4;
         }
         if(this.mFontName == "font_galaxy")
         {
            textlineMetrics = this.mTextField.getLineMetrics(0);
            this.mTextField.y -= textlineMetrics.descent / 2;
         }
      }
      
      override public function setHAlign(value:String) : void
      {
         this.mHAlign = value;
         this.changeDefaultFormat();
      }
      
      override public function setBorder(value:Boolean) : void
      {
         var graphics:Graphics = this.graphics;
         this.mBorder = value;
         graphics.clear();
         if(value)
         {
            graphics.lineStyle(1);
            graphics.beginFill(16711935,0);
            graphics.drawRect(0,0,this.mWidth,this.mHeight);
            graphics.endFill();
         }
      }
      
      override protected function updateFilters() : void
      {
         this.mTextField.filters = mFilters;
      }
      
      override public function setAutoScale(value:Boolean) : void
      {
         this.mAutoScale = value;
         this.changeDefaultFormat();
      }
      
      override public function getAutoScale() : Boolean
      {
         return this.mAutoScale;
      }
      
      private function autoScaleNativeTextField() : void
      {
         var format:TextFormat = null;
         var size:Number = Number(this.mTextField.defaultTextFormat.size);
         var maxHeight:Number = this.mHeight;
         maxHeight -= 4;
         var maxWidth:Number = this.mWidth - 4;
         while(this.mTextField.textWidth > maxWidth || this.mTextField.textHeight > maxHeight)
         {
            if(size <= 9)
            {
               break;
            }
            format = this.mTextField.defaultTextFormat;
            format.size = size--;
            this.mTextField.defaultTextFormat = format;
            this.mTextField.text = this.mTextField.text;
         }
      }
      
      override protected function applyFontName(value:String) : void
      {
         this.mFontName = value;
         if(!checkTextFieldGlyphs(this.mText))
         {
            this.changeDefaultFormat();
         }
      }
      
      override public function setFontName(value:String) : void
      {
         mFontNameDefault = value;
         this.applyFontName(value);
      }
      
      override public function getFontName() : String
      {
         return this.mFontName;
      }
      
      override public function setFontSize(fontSize:Number) : void
      {
         this.mFontSize = fontSize;
         this.changeDefaultFormat();
      }
      
      override public function getFontSize() : Number
      {
         return this.mFontSize;
      }
      
      override public function getFontSizeAfterScale() : Number
      {
         return this.mTextField.defaultTextFormat.size as Number;
      }
      
      private function changeDefaultFormat() : void
      {
         this.updateTextField();
         this.mUpdateTextField = this.mTextField != null && this.mTextField.embedFonts;
      }
      
      private function updateTextField() : void
      {
         var embedFonts:Boolean = false;
         this.mWidth = this.mOriginalWidth;
         this.mHeight = this.mOriginalHeight;
         this.mTextField.width = this.mWidth;
         this.mTextField.height = this.mHeight;
         this.setBorder(this.mBorder);
         this.mTextField.gridFitType = "subpixel";
         this.mTextField.antiAliasType = "advanced";
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(profile != null && profile.getFlagsReaded())
         {
            this.mTextField.antiAliasType = profile.getTextAntiAliasingMode();
            this.mTextField.sharpness = profile.getTextSharpness();
            this.mTextField.thickness = profile.getTextThickness();
         }
         var format:TextFormat = new TextFormat(this.mFontName,this.mFontSize,this.mColor,this.mBold,this.mItalic,this.mUnderline,null,null,this.mHAlign);
         format.kerning = this.mKerning;
         this.mTextField.defaultTextFormat = format;
         this.mTextField.text = this.mText;
         this.mTextField.multiline = this.mMultiline;
         var words:int = int(this.mTextField.text.split(" ").length);
         if(this.mTextField.type == "input")
         {
            this.mTextField.wordWrap = this.mWordWrap;
         }
         else
         {
            this.mTextField.wordWrap = words > 1 || this.mWordWrap;
         }
         if(this.mTextField.textWidth == 0 || this.mTextField.textHeight == 0 || this.mFontName == "Arial Unicode MS")
         {
            embedFonts = false;
         }
         else
         {
            embedFonts = isAnEmbeddedFont(this.mFontName);
         }
         this.mTextField.embedFonts = embedFonts;
         if(this.mAutoScale)
         {
            this.autoScaleNativeTextField();
         }
         if(this.mTextField.type == "dynamic")
         {
            this.mTextField.width = this.mTextField.textWidth + 4 + 3;
            this.mTextField.height = this.mTextField.textHeight + 4 + 1;
            if(this.mAutoSize)
            {
               this.mWidth = this.mTextField.width;
               this.mHeight = this.mTextField.height;
            }
         }
         this.changeColors();
         this.performVAlign();
      }
      
      override public function setTextColor(color:uint) : void
      {
         this.mColor = color;
         this.mTextColorTransformsStack.push(this.mColor);
         this.changeDefaultFormat();
      }
      
      override public function rollbackTextColor() : void
      {
         var color:uint = 0;
         this.mTextColorTransformsStack.pop();
         if(this.mTextColorTransformsStack.length)
         {
            color = this.mTextColorTransformsStack[this.mTextColorTransformsStack.length - 1];
         }
         else
         {
            color = this.mInitialTextColorTransform;
         }
         this.mColor = color;
      }
      
      override public function resetTextColor() : void
      {
         this.mColor = this.mInitialTextColorTransform;
         this.mTextColorTransformsStack.length = 0;
      }
      
      override public function getColor() : uint
      {
         return this.mColor;
      }
      
      override public function setKerning(value:Boolean) : void
      {
         this.mKerning = value;
         this.changeDefaultFormat();
      }
      
      override public function setBold(value:Boolean) : void
      {
         this.mBold = value;
         this.changeDefaultFormat();
      }
      
      override public function setItalic(value:Boolean) : void
      {
         this.mItalic = value;
         this.changeDefaultFormat();
      }
      
      override public function setUnderline(value:Boolean) : void
      {
         this.mUnderline = value;
         this.changeDefaultFormat();
      }
      
      override public function get mostLeft() : Number
      {
         return logicLeft;
      }
      
      override public function get mostRight() : Number
      {
         return this.mostLeft + this.width;
      }
      
      override public function get mostTop() : Number
      {
         return logicTop;
      }
      
      override public function get mostBottom() : Number
      {
         return this.mostTop + this.height;
      }
      
      override public function set height(value:Number) : void
      {
         this.mHeight = value;
         this.mOriginalHeight = value;
         this.changeDefaultFormat();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function set width(value:Number) : void
      {
         this.mWidth = value;
         this.mOriginalWidth = value;
         this.changeDefaultFormat();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override protected function get textWidth() : Number
      {
         return this.mTextField.textWidth;
      }
      
      override protected function get textHeight() : Number
      {
         return this.mTextField.textHeight;
      }
      
      override public function autoSize(value:Boolean) : void
      {
         this.mAutoSize = value;
         this.changeDefaultFormat();
      }
      
      override public function getStrBoundaries(str:String) : Rectangle
      {
         var startsAt:int = 0;
         var startX:Number = NaN;
         var w:Number = NaN;
         var end:Number = NaN;
         var i:* = 0;
         if(str != null)
         {
            startsAt = this.getText().indexOf(str);
            if(startsAt > -1)
            {
               startX = this.mTextField.x + this.mTextField.getCharBoundaries(startsAt).x;
               w = 0;
               end = startsAt + str.length;
               for(i = startsAt; i < end; )
               {
                  w += this.mTextField.getCharBoundaries(i).width;
                  i++;
               }
               return new Rectangle(startX,0,w,this.textHeight);
            }
         }
         return null;
      }
      
      override public function getTextField() : TextField
      {
         return this.mTextField;
      }
      
      override public function setMaxChars(value:int) : void
      {
         this.mTextField.maxChars = value;
      }
      
      override public function setEditable(value:Boolean) : void
      {
         if(value)
         {
            this.mTextField.type = "input";
            this.mTextField.selectable = true;
         }
         else
         {
            this.mTextField.type = "dynamic";
            this.mTextField.selectable = false;
         }
      }
      
      override public function setMultiline(value:Boolean) : void
      {
         this.mMultiline = value;
         this.mUpdateTextField = true;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mUpdateTextField)
         {
            this.updateTextField();
            this.mUpdateTextField = false;
         }
      }
      
      private function changeColors() : void
      {
         var endIndex:int = 0;
         var formats:Array = null;
         var format:TextFormat = null;
         var currentFormat:TextFormat = null;
         var colorStr:* = null;
         var color:Number = NaN;
         var length:int = 0;
         var i:int = 0;
         var text:String;
         var startIndex:int = (text = this.mText).indexOf("{0x");
         while(startIndex > -1)
         {
            if(formats == null)
            {
               formats = [];
            }
            colorStr = text.substr(startIndex + 1,8);
            color = parseInt(colorStr);
            if(isNaN(color))
            {
               throw new Error("Bad color format in text: " + text);
            }
            colorStr = "{" + colorStr + "}";
            if((endIndex = (text = text.replace(colorStr,"")).indexOf("{/}")) == -1)
            {
               throw new Error("There is no color clausure in text: " + text);
            }
            text = text.replace("{/}","");
            format = new TextFormat();
            currentFormat = this.mTextField.defaultTextFormat;
            format.font = currentFormat.font;
            format.color = int(color);
            format.size = currentFormat.size;
            formats.push(new Array(format,startIndex,endIndex));
            startIndex = text.indexOf("{0x");
         }
         if(formats != null)
         {
            if((length = int(formats.length)) > 0)
            {
               this.mTextField.text = text;
               for(i = 0; i < length; )
               {
                  format = formats[i][0];
                  startIndex = int(formats[i][1]);
                  if(startIndex < -1 || startIndex >= text.length)
                  {
                     startIndex = -1;
                  }
                  if((endIndex = int(formats[i][2])) > text.length)
                  {
                     endIndex = text.length;
                  }
                  this.mTextField.setTextFormat(format,startIndex,endIndex);
                  i++;
               }
            }
         }
      }
   }
}
