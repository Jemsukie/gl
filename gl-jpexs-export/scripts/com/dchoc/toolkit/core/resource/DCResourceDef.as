package com.dchoc.toolkit.core.resource
{
   public class DCResourceDef
   {
      
      public static const PROFILE_ASSETS:Boolean = true;
      
      private static var smResourceMng:DCResourceMng;
       
      
      protected var mSku:String;
      
      protected var mIsLoaded:Boolean;
      
      protected var mIsImmediate:Boolean;
      
      protected var mIsBlocker:Boolean;
      
      protected var mHasBeenRequested:Boolean;
      
      protected var mHasBeenEnqueued:Boolean;
      
      protected var mResource:*;
      
      public function DCResourceDef(sku:String, isBlocker:Boolean = true, isImmediate:Boolean = true)
      {
         super();
         this.mSku = sku;
         this.mIsBlocker = isBlocker;
         this.mIsImmediate = isImmediate;
         this.mIsLoaded = false;
         this.mHasBeenRequested = false;
      }
      
      public static function setResourceMng(value:DCResourceMng) : void
      {
         smResourceMng = value;
      }
      
      public static function unloadStatic() : void
      {
         smResourceMng = null;
      }
      
      public function request() : void
      {
         if(!this.mHasBeenRequested)
         {
            this.mHasBeenRequested = true;
         }
      }
      
      public function getResource(type:String = null, decode:Boolean = false) : *
      {
         return this.mResource;
      }
      
      public function unload() : void
      {
         this.mIsLoaded = false;
         this.mHasBeenRequested = false;
      }
      
      protected function setResource(r:*) : void
      {
         this.mResource = r;
         this.mIsLoaded = true;
         smResourceMng.notifyResourceLoaded(this);
      }
      
      protected function markAsFailed() : void
      {
         smResourceMng.notifyResourceFailed(this);
      }
      
      public function hasBeenRequested() : Boolean
      {
         return this.mHasBeenRequested;
      }
      
      public function setHasBeenRequested(value:Boolean) : void
      {
         this.mHasBeenRequested = value;
      }
      
      public function hasBeenEnqueued() : Boolean
      {
         return this.mHasBeenEnqueued;
      }
      
      public function setHasBeenEnqueued(value:Boolean) : void
      {
         this.mHasBeenEnqueued = value;
      }
      
      public function isLoaded() : Boolean
      {
         return this.mIsLoaded;
      }
      
      public function isBlocker() : Boolean
      {
         return this.mIsBlocker;
      }
      
      public function isImmediate() : Boolean
      {
         return this.mIsImmediate;
      }
      
      public function setIsImmediate(value:Boolean) : void
      {
         this.mIsImmediate = value;
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      public function canBeEnqueued() : Boolean
      {
         return false;
      }
   }
}
