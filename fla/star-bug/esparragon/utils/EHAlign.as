package esparragon.utils
{
   public class EHAlign
   {
      
      public static const LEFT:String = "left";
      
      public static const CENTER:String = "center";
      
      public static const RIGHT:String = "right";
       
      
      public function EHAlign()
      {
         super();
      }
      
      public static function isValid(hAlign:String) : Boolean
      {
         return hAlign == "left" || hAlign == "center" || hAlign == "right";
      }
   }
}
