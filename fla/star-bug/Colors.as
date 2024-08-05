package
{
   public class Colors
   {
      
      public static const NONE:int = -1;
      
      public static const WHITE:uint = 16777215;
      
      public static const GREY:uint = 11184810;
      
      public static const RED:uint = 16711680;
      
      public static const ORANGE:uint = 16750848;
      
      public static const YELLOW:uint = 16776960;
      
      public static const GREEN:uint = 65280;
      
      public static const PURPLE:uint = 10040319;
      
      public static const PINK:uint = 16711935;
      
      public static const CYAN:uint = 65535;
      
      public static const GOLD:uint = 16763904;
      
      public static const LIGHT_BLUE:uint = 2003199;
      
      public static const LIGHT_CYAN:uint = 8454143;
      
      public static const LIGHT_GREEN:uint = 10092492;
      
      public static const UMBRELLA_COLOR:uint = 11123432;
       
      
      public function Colors()
      {
         super();
      }
      
      public static function colorToString(color:uint) : String
      {
         return "0x" + color.toString(16);
      }
   }
}
