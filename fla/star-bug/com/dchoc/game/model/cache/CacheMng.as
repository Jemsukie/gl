package com.dchoc.game.model.cache
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.utils.Dictionary;
   
   public class CacheMng
   {
       
      
      private var mData:Dictionary;
      
      public function CacheMng()
      {
         super();
      }
      
      public function unload() : void
      {
         var obj:Object = null;
         for each(obj in this.mData)
         {
            obj = null;
         }
         this.mData = null;
      }
      
      public function getCachedInfoById(id:String) : Object
      {
         var returnValue:Object = null;
         if(this.mData == null)
         {
            DCDebug.trace("An error has occurred as the mData is null and it shouldn\'t be.",1);
            return null;
         }
         if(this.mData[id] != null)
         {
            return this.mData[id];
         }
         DCDebug.trace("The requested information couldn\'t be found in the cache",1);
         return null;
      }
      
      public function setCachedInfoById(key:String, data:Object) : void
      {
         if(this.mData == null)
         {
            this.mData = new Dictionary();
         }
         if(this.mData[key] != null)
         {
            DCDebug.trace("This key already have a value stored, overriding",1);
         }
         this.mData[key] = data;
      }
      
      public function removeCachedInfoById(key:String) : void
      {
         if(this.mData == null)
         {
            DCDebug.trace("This main data structure is null, no information deleted.",1);
            return;
         }
         if(this.mData[key] == null)
         {
            DCDebug.trace("This key doesn\'t have a value associated, skipping.",1);
            return;
         }
         this.mData[key] = null;
      }
   }
}
