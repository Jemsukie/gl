package com.dchoc.toolkit.utils.xml
{
   import esparragon.utils.EUtils;
   
   public class DCXMLUtil
   {
      
      public static const CHUNK_SIZE:int = 64;
       
      
      private var mPersistence:XML;
      
      private var mXML:XML;
      
      private var mValues:Vector.<String>;
      
      private var mChunkSize:int;
      
      private var mIndex:int;
      
      private var mDataStr:String;
      
      public function DCXMLUtil(xml:XML, values:Vector.<String>, chunkSize:int = 64)
      {
         super();
         this.mXML = xml;
         this.mValues = values;
         this.mChunkSize = chunkSize;
      }
      
      private function doChunks() : void
      {
         var length:int = 0;
         var i:int = 0;
         this.mDataStr = "";
         this.mIndex = 0;
         for(length = int(this.mValues.length); i < length; )
         {
            this.mDataStr += this.mValues[i] + ",";
            this.mIndex++;
            if(this.mIndex == this.mChunkSize)
            {
               this.writeChunk();
            }
            i++;
         }
         this.writeChunk();
      }
      
      private function writeChunk() : void
      {
         var thisXML:XML = this.mXML.copy();
         this.mIndex = 0;
         EUtils.xmlSetAttribute(thisXML,"chunk",this.mDataStr);
         this.mPersistence.appendChild(thisXML);
         this.mDataStr = "";
      }
      
      public function addToXML(persistence:XML) : void
      {
         this.mPersistence = persistence;
         this.doChunks();
      }
      
      public function getPersistence() : XML
      {
         return this.mPersistence;
      }
   }
}
