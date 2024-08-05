package com.dchoc.toolkit.core.customizer
{
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class DCCustomizerPopupDef
   {
      
      private static const IMAGE_LOADING:int = 0;
      
      private static const IMAGE_LOADED:int = 1;
      
      private static const IMAGE_FAILED:int = 2;
       
      
      private var mId:int;
      
      private var mTitle:String;
      
      private var mText:String;
      
      private var mImage:Bitmap;
      
      private var mImageUrl:String;
      
      private var mImageState:int;
      
      private var mLoader:Loader;
      
      private var mButtons:Array;
      
      private var mSkin:String;
      
      public function DCCustomizerPopupDef(info:XML)
      {
         var actionButton:XML = null;
         var req:URLRequest = null;
         var context:LoaderContext = null;
         super();
         this.mId = EUtils.xmlReadInt(info,"id");
         this.mTitle = EUtils.xmlReadString(info,"title");
         this.mText = EUtils.xmlReadString(info,"text");
         if(EUtils.xmlIsAttribute(info,"skin"))
         {
            this.mSkin = EUtils.xmlReadString(info,"skin");
         }
         if(EUtils.xmlIsAttribute(info,"img"))
         {
            this.mImageUrl = EUtils.xmlReadString(info,"img");
            this.mLoader = new Loader();
            req = new URLRequest(this.mImageUrl);
            context = new LoaderContext(true);
            this.mLoader.contentLoaderInfo.addEventListener("complete",this.onComplete);
            this.mLoader.contentLoaderInfo.addEventListener("ioError",this.onError);
            this.mLoader.load(req,context);
            this.mImageState = 0;
         }
         this.mButtons = [];
         for each(actionButton in EUtils.xmlGetChildrenList(info,"actionButton"))
         {
            this.mButtons.push(new DCCustomizerButtonDef(actionButton));
         }
      }
      
      public function destroy() : void
      {
         var i:int = 0;
         if(this.mLoader != null)
         {
            this.mLoader.unload();
            this.removeLoaderListeners();
            this.mLoader = null;
         }
         this.mId = 0;
         this.mTitle = null;
         this.mText = null;
         if(this.mImage != null)
         {
            if(this.mImage.bitmapData != null)
            {
               this.mImage.bitmapData.dispose();
               this.mImage.bitmapData = null;
            }
            this.mImage = null;
         }
         this.mImageUrl = null;
         this.mImageState = 0;
         if(this.mButtons != null)
         {
            for(i = 0; i < this.mButtons.length; )
            {
               this.mButtons[i].destroy();
               this.mButtons[i] = null;
               i++;
            }
            this.mButtons = null;
         }
      }
      
      public function getTitle() : String
      {
         return this.mTitle;
      }
      
      public function getText() : String
      {
         return this.mText;
      }
      
      public function getImage() : Bitmap
      {
         return this.mImage;
      }
      
      public function getImageUrl() : String
      {
         return this.mImageUrl;
      }
      
      public function getButton(index:int = 0) : DCCustomizerButtonDef
      {
         return this.mButtons[index];
      }
      
      public function getButtonsAmount() : uint
      {
         return this.mButtons.length;
      }
      
      private function onComplete(e:Event) : void
      {
         var loader:Loader = e.target.loader as Loader;
         this.mImage = Bitmap(loader.content);
         this.mImageState = 1;
         this.removeLoaderListeners();
      }
      
      private function onError(e:IOErrorEvent) : void
      {
         this.mImageState = 2;
         this.removeLoaderListeners();
      }
      
      private function removeLoaderListeners() : void
      {
         if(this.mLoader.contentLoaderInfo.hasEventListener("complete"))
         {
            this.mLoader.contentLoaderInfo.removeEventListener("complete",this.onComplete);
            this.mLoader.contentLoaderInfo.removeEventListener("ioError",this.onError);
         }
      }
      
      public function getSkin() : String
      {
         return this.mSkin;
      }
   }
}
