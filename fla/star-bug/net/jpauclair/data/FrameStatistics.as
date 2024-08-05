package net.jpauclair.data
{
   public class FrameStatistics
   {
       
      
      public var FpsCurrent:int = 0;
      
      public var FpsMin:int = 2147483647;
      
      public var FpsMax:int = 0;
      
      public var MemoryCurrent:int = 0;
      
      public var MemoryMin:int = 2147483647;
      
      public var MemoryMax:int = 0;
      
      public var MemoryFree:uint = 0;
      
      public var MemoryPrivate:uint = 0;
      
      public function FrameStatistics()
      {
         super();
      }
      
      public function Copy(obj:FrameStatistics) : void
      {
         this.FpsCurrent = obj.FpsCurrent;
         this.FpsMin = obj.FpsMin;
         this.FpsMax = obj.FpsMax;
         this.MemoryCurrent = obj.MemoryCurrent;
         this.MemoryMin = obj.MemoryMin;
         this.MemoryMax = obj.MemoryMax;
         this.MemoryFree = obj.MemoryFree;
         this.MemoryPrivate = obj.MemoryPrivate;
      }
   }
}
