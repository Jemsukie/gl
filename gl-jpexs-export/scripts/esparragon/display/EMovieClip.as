package esparragon.display
{
   import esparragon.core.Esparragon;
   
   public class EMovieClip extends ESprite
   {
       
      
      private var mGroupId:String;
      
      private var mSwfAssetId:String;
      
      private var mClipName:String;
      
      protected var mOnSetTextureLoaded:Function;
      
      public function EMovieClip()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mGroupId = null;
         this.mSwfAssetId = null;
         this.mClipName = null;
      }
      
      override protected function poolReturn() : void
      {
         Esparragon.poolReturnEMovieClip(this);
      }
      
      public function set onSetTextureLoaded(value:Function) : void
      {
         this.mOnSetTextureLoaded = value;
         if(this.mOnSetTextureLoaded != null && this.isTextureLoaded())
         {
            this.onSetTextureLoadedCall();
         }
      }
      
      protected function onSetTextureLoadedCall() : void
      {
         this.mOnSetTextureLoaded(this);
      }
      
      public function setMovieClip(groupId:String, swfAssetId:String, clipName:String, movieClipClass:Class) : void
      {
         this.mGroupId = groupId;
         this.mSwfAssetId = swfAssetId;
         this.mClipName = clipName;
         this.extendedSetMovieClip(movieClipClass);
         if(getLayoutArea() != null)
         {
            layoutApplyTransformations(getLayoutArea());
         }
         if(this.mOnSetTextureLoaded != null)
         {
            this.onSetTextureLoadedCall();
         }
      }
      
      protected function extendedSetMovieClip(movieClipClass:Class) : void
      {
      }
      
      public function getGroupId() : String
      {
         return this.mGroupId;
      }
      
      public function getSwfAssetId() : String
      {
         return this.mSwfAssetId;
      }
      
      public function getClipName() : String
      {
         return this.mClipName;
      }
      
      public function isTextureLoaded() : Boolean
      {
         return false;
      }
      
      public function changeInstance(instanceName:String, dsp:ESprite) : void
      {
      }
   }
}
