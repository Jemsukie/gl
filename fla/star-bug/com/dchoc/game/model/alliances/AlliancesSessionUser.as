package com.dchoc.game.model.alliances
{
   public class AlliancesSessionUser extends AlliancesUser
   {
      
      private static var smInstance:AlliancesSessionUser;
       
      
      public function AlliancesSessionUser()
      {
         super();
      }
      
      public static function getInstance() : AlliancesSessionUser
      {
         if(!smInstance)
         {
            smInstance = new AlliancesSessionUser();
         }
         return smInstance;
      }
   }
}
