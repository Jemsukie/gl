package com.dchoc.game.model.cache
{
   import com.dchoc.game.core.instance.InstanceMng;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Matrix;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import flash.utils.Dictionary;
   
   public class GraphicsCacheMng
   {
      
      private static const MAX_IMAGES:int = 20;
      
      public static const IMAGE_SIZE:int = 50;
       
      
      private var mCachedObjects:Dictionary;
      
      private var mUses:Dictionary;
      
      private var mKeys:Vector.<String>;
      
      private var mSilhouettePicture:BitmapData;
      
      private var mMatrix:Matrix;
      
      public function GraphicsCacheMng()
      {
         super();
         this.mCachedObjects = new Dictionary(true);
         this.mUses = new Dictionary(true);
         this.mKeys = new Vector.<String>(0);
         this.mMatrix = new Matrix();
      }
      
      public function unload() : void
      {
         var bmp:BitmapData = null;
         for each(bmp in this.mCachedObjects)
         {
            bmp.dispose();
         }
         this.mCachedObjects = null;
         this.mUses = null;
         this.mKeys = null;
      }
      
      public function getCachedImage(sku:String) : BitmapData
      {
         var numObjects:int = 0;
         var flashVar:Object = null;
         var loader:Loader = null;
         var req:URLRequest = null;
         var context:LoaderContext = null;
         var i:int = 0;
         if(sku == null || sku == "")
         {
            return this.getDefaultPicture();
         }
         var bmp:BitmapData = this.mCachedObjects[sku];
         var uses:int = int(this.mUses[sku]);
         var length:int = 0;
         if(this.mKeys == null)
         {
            length = int(this.mKeys.length);
         }
         if(bmp == null)
         {
            for each(bmp in this.mCachedObjects)
            {
               numObjects++;
            }
            if(numObjects == 20)
            {
               for(i = 0; i < length; )
               {
                  if(this.mUses[this.mKeys[i]] == 0)
                  {
                     delete this.mUses[this.mKeys[i]];
                     BitmapData(this.mCachedObjects[this.mKeys[i]]).dispose();
                     delete this.mCachedObjects[this.mKeys[i]];
                     this.mKeys.splice(i,1);
                     break;
                  }
                  i++;
               }
            }
            flashVar = Star.getFlashVars();
            loader = new Loader();
            req = new URLRequest(sku);
            context = new LoaderContext(true);
            if(Security.sandboxType == "remote")
            {
               context.securityDomain = SecurityDomain.currentDomain;
            }
            context.checkPolicyFile = true;
            loader.name = sku;
            loader.contentLoaderInfo.addEventListener("complete",this.onComplete);
            loader.contentLoaderInfo.addEventListener("ioError",this.onError);
            loader.load(req,context);
            bmp = new BitmapData(50,50,true,0);
            this.mCachedObjects[loader.name] = bmp;
         }
         uses++;
         this.mUses[sku] = uses;
         return bmp;
      }
      
      public function getDefaultPicture() : BitmapData
      {
         var sp:Sprite = null;
         if(this.mSilhouettePicture == null)
         {
            this.mSilhouettePicture = new BitmapData(50,50);
            sp = new (InstanceMng.getResourceMng().getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","photo_friend"))();
            this.mSilhouettePicture.draw(sp);
         }
         return this.mSilhouettePicture;
      }
      
      private function onComplete(event:Event) : void
      {
         var bitmap:Bitmap = null;
         var loader:Loader = event.target.loader as Loader;
         loader.contentLoaderInfo.removeEventListener("complete",this.onComplete);
         loader.contentLoaderInfo.removeEventListener("ioError",this.onError);
         if(loader.contentLoaderInfo.content != null)
         {
            bitmap = Bitmap(loader.contentLoaderInfo.content);
            bitmap.smoothing = true;
            this.mMatrix.identity();
            this.mMatrix.scale(50 / bitmap.width,50 / bitmap.height);
            BitmapData(this.mCachedObjects[loader.name]).draw(bitmap,this.mMatrix,null,null,null,true);
            loader.unload();
            this.mKeys.push(loader.name);
            loader = null;
         }
      }
      
      private function onError(event:IOErrorEvent) : void
      {
         var loader:Loader = event.target.loader as Loader;
         loader.contentLoaderInfo.removeEventListener("complete",this.onComplete);
         loader.contentLoaderInfo.removeEventListener("ioError",this.onError);
      }
      
      public function removeUsage(sku:String) : void
      {
         if(sku != null && this.mUses[sku] != null)
         {
            this.mUses[sku]--;
            if(this.mUses[sku] < 0)
            {
               this.mUses[sku] = 0;
            }
         }
      }
      
      public function addImageToLoad(box:DisplayObjectContainer, url:String, addAsNewChild:Boolean = true, centered:Boolean = true) : void
      {
         var sp:Sprite = null;
         var parent:DisplayObjectContainer = null;
         var idx:int = 0;
         if(box == null)
         {
            return;
         }
         var bmp:Bitmap;
         if((bmp = box.getChildByName("image") as Bitmap) == null)
         {
            (bmp = new Bitmap()).name = "image";
            if(addAsNewChild)
            {
               (sp = new Sprite()).name = box.name;
               parent = box.parent;
               if(centered)
               {
                  sp.x = box.x - (box.width >> 1);
                  sp.y = box.y - (box.height >> 1);
               }
               else
               {
                  sp.x = box.x;
                  sp.y = box.y;
               }
               sp.addChild(bmp);
               idx = parent.getChildIndex(box);
               parent.removeChildAt(idx);
               parent.addChildAt(sp,idx);
            }
            else
            {
               box.addChild(bmp);
            }
         }
         bmp.bitmapData = this.getCachedImage(url);
         bmp.smoothing = true;
      }
   }
}
