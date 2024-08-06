package com.dchoc.toolkit.utils.text
{
   import flash.text.TextField;
   
   public class DCTextTyped
   {
       
      
      private var mText:String;
      
      private var mTextLength:int;
      
      private var mTextField:TextField;
      
      private var mCurrentCharacter:int;
      
      private var mTypeTime:int;
      
      private var mTimeAcc:int;
      
      private var mEnd:Function;
      
      private var mIsTyping:Boolean;
      
      public function DCTextTyped(textField:TextField)
      {
         super();
         this.mTextField = textField;
         this.mText = "";
         textField.htmlText = "";
      }
      
      public function typeInstant() : void
      {
         this.mCurrentCharacter = this.mTextLength;
         this.mTextField.htmlText = this.mText;
      }
      
      public function type(text:String, end:Function = null, typeTime:int = 25) : void
      {
         this.mEnd = end;
         this.mText = DCStringUtils.decodeHtml(text);
         this.mCurrentCharacter = 0;
         this.mTextLength = DCStringUtils.stripTags(text).length;
         this.mIsTyping = true;
         this.mTimeAcc = 0;
         this.mTypeTime = typeTime;
         this.update(this.mTypeTime);
      }
      
      public function isTyping() : Boolean
      {
         return this.mIsTyping;
      }
      
      public function update(dt:int) : void
      {
         var t:String = null;
         var textWithLastWord:String = null;
         var nextSpaceIdx:int = 0;
         var last_token:* = null;
         var nextWordLines:int = 0;
         var currentLines:int = 0;
         var idx:int = 0;
         var tagOpened:Boolean = false;
         var n:String = null;
         var advanceCharacters:int = 0;
         this.mTimeAcc += dt;
         advanceCharacters = this.mTimeAcc / this.mTypeTime;
         this.mTimeAcc -= advanceCharacters * this.mTypeTime;
         if(this.mTimeAcc < 0)
         {
            this.mTimeAcc = 0;
         }
         if(advanceCharacters > 0)
         {
            this.mCurrentCharacter += advanceCharacters;
            if(this.mCurrentCharacter >= this.mTextLength)
            {
               this.mIsTyping = false;
               if(this.mEnd != null)
               {
                  this.mEnd();
               }
            }
            t = DCStringUtils.substrHtml(this.mText,this.mCurrentCharacter);
            nextSpaceIdx = (textWithLastWord = DCStringUtils.stripTags(this.mText)).indexOf(" ",this.mCurrentCharacter) + 1;
            last_token = DCStringUtils.substrHtml(this.mText,nextSpaceIdx);
            if(last_token.length == 0)
            {
               last_token = textWithLastWord;
            }
            this.mTextField.htmlText = last_token;
            nextWordLines = this.mTextField.numLines;
            this.mTextField.htmlText = t;
            currentLines = this.mTextField.numLines;
            if(nextWordLines < currentLines)
            {
               this.mTextField.htmlText = t + " ";
            }
            if(nextWordLines > currentLines)
            {
               idx = t.length - 1;
               tagOpened = false;
               while(idx > 0)
               {
                  if((n = t.charAt(idx)) == ">")
                  {
                     tagOpened = true;
                  }
                  if(n == "<")
                  {
                     tagOpened = false;
                  }
                  if(n == " " && !tagOpened)
                  {
                     t = DCStringUtils.insert(t,"<br />",idx + 1);
                     this.mTextField.htmlText = t;
                     break;
                  }
                  idx--;
               }
            }
         }
      }
   }
}
