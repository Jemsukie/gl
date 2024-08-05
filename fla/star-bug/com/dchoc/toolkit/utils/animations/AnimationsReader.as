package com.dchoc.toolkit.utils.animations
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class AnimationsReader
   {
       
      
      public function AnimationsReader()
      {
         super();
      }
      
      public static function getAnimations(file:String) : Dictionary
      {
         var i:int = 0;
         var currentAnim:Array = null;
         var framesCount:int = 0;
         var frames:Vector.<int> = null;
         var j:int = 0;
         var anims:Dictionary = new Dictionary();
         var animTmp:Array;
         var length:int = int((animTmp = file.split("\n")).length);
         for(i = 0; i < length; )
         {
            framesCount = (currentAnim = animTmp[i].split(",")).length - 1;
            frames = new Vector.<int>(framesCount,true);
            for(j = 0; j < framesCount; )
            {
               frames[j] = int(currentAnim[j + 1]);
               j++;
            }
            anims[currentAnim[0]] = frames;
            i++;
         }
         return anims;
      }
      
      public static function getCor(bytes:ByteArray) : Vector.<int>
      {
         var cor:Vector.<int> = null;
         var i:int = 0;
         if(bytes != null)
         {
            bytes.position = 0;
            cor = new Vector.<int>(bytes.length / 2,true);
            for(i = 0; i < cor.length; )
            {
               cor[i] = bytes.readShort();
               i++;
            }
            return cor;
         }
         return null;
      }
      
      public static function getMap(bytes:ByteArray) : Vector.<int>
      {
         var i:int = 0;
         bytes.position = 0;
         var map:Vector.<int> = new Vector.<int>(bytes.length,true);
         for(i = 0; i < map.length; )
         {
            map[i] = bytes.readByte();
            i++;
         }
         return map;
      }
      
      public static function getAnimationFromFrame(anim:MovieClip, frameName:String) : MovieClip
      {
         anim.gotoAndStop(frameName);
         var myBitmapData:BitmapData;
         (myBitmapData = new BitmapData(anim.width,anim.height,true,16777215)).draw(anim);
         var result:MovieClip = new MovieClip();
         var resBMP:Bitmap = new Bitmap(myBitmapData);
         result.addChild(resBMP);
         return result;
      }
   }
}
