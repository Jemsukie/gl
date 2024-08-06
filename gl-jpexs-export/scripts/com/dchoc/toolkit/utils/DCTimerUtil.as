package com.dchoc.toolkit.utils
{
   public class DCTimerUtil
   {
      
      private static var mDate:Date = new Date();
      
      public static const SECOND_TO_MS:Number = 1000;
      
      public static const MIN_TO_MS:Number = 60000;
      
      public static const HOUR_TO_MS:Number = 3600000;
      
      public static const DAY_TO_MS:Number = 86400000;
      
      public static const WEEK_TO_MS:Number = 604800000;
      
      public static const MONTH_TO_MS:Number = 2419200000;
      
      public static const YEAR_TO_MS:Number = 29030400000;
      
      private static const TIME_SUFFIX_DAYS:String = "d";
      
      private static const TIME_SUFFIX_HOURS:String = "h";
      
      private static const TIME_SUFFIX_MINUTES:String = "m";
      
      private static const TIME_SUFFIX_SECONDS:String = "s";
       
      
      public function DCTimerUtil()
      {
         super();
      }
      
      public static function currentTimeMillis() : Number
      {
         mDate = new Date();
         return mDate.getTime();
      }
      
      public static function hourToMs(hours:Number) : Number
      {
         return hours * 3600000;
      }
      
      public static function msToHour(time:Number) : int
      {
         return time / 3600000;
      }
      
      public static function msToDays(time:Number) : int
      {
         return time / 86400000;
      }
      
      public static function minToMs(mins:Number) : Number
      {
         return mins * 60000;
      }
      
      public static function msToMin(ms:Number) : Number
      {
         return ms / 60000;
      }
      
      public static function msToSec(ms:Number) : Number
      {
         return ms / 1000;
      }
      
      public static function secondToMs(seconds:Number) : Number
      {
         return seconds * 1000;
      }
      
      public static function daysToMs(days:Number) : Number
      {
         return days * 24 * 3600000;
      }
      
      public static function msToWeeks(time:Number) : int
      {
         return time / 604800000;
      }
      
      public static function msToMonths(time:Number) : int
      {
         return time / 2419200000;
      }
      
      public static function msToYears(time:Number) : int
      {
         return time / 29030400000;
      }
      
      public static function getDateInMs(dateString:String) : Number
      {
         var dateMembers:Array = dateString.split(":");
         var hour:int = 0;
         var minute:int = 0;
         if(dateMembers.length > 3)
         {
            hour = int(dateMembers[3]);
            minute = int(dateMembers[4]);
         }
         var date:Date = new Date(dateMembers[2],dateMembers[1] - 1,dateMembers[0],hour,minute);
         return date.getTime();
      }
      
      public static function getIsExpiredByDate(date:Date) : Boolean
      {
         var currentDate:Date = new Date();
         return date.getTime() - currentDate.getTime() <= 0;
      }
      
      public static function getIsExpiredByMs(millis:Number) : Boolean
      {
         var dateToExpire:Date = new Date();
         dateToExpire.setTime(millis);
         return getIsExpiredByDate(dateToExpire);
      }
      
      public static function getUnixTime(date:Date = null) : int
      {
         if(date == null)
         {
            date = new Date();
         }
         return Math.round(date.getTime() * 0.001);
      }
      
      public static function getTimeTextFromMs(timeMs:Number, textYears:String = null, textMonths:String = null, textWeeks:String = null, textDays:String = null, textHours:String = null, textMinutes:String = null, textSeconds:String = null, useZeros:Boolean = true, useSmartZeroUsage:Boolean = true) : String
      {
         var timeBak:Number = Math.abs(timeMs);
         var years:int = msToYears(timeBak);
         timeBak = Math.max(0,timeBak - years * 29030400000);
         var months:int = msToMonths(timeBak);
         timeBak = Math.max(0,timeBak - months * 2419200000);
         var weeks:int = msToWeeks(timeBak);
         timeBak = Math.max(0,timeBak - weeks * 604800000);
         var days:int = msToDays(timeBak);
         timeBak = Math.max(0,timeBak - days * 86400000);
         var hours:int = msToHour(timeBak);
         timeBak = Math.max(0,timeBak - hours * 3600000);
         var minutes:int = msToMin(timeBak);
         var seconds:int = (timeBak = Math.max(0,timeBak - minutes * 60000)) * 0.001;
         var hasGreaterUnit:Boolean = false;
         var timeText:* = (timeText = "") + printTime(textYears,years,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textYears != null && years > 0;
         }
         timeText += printTime(textMonths,months,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textMonths != null && months > 0;
         }
         if(years > 0)
         {
            return timeText.slice(0,timeText.length - 1);
         }
         timeText += printTime(textWeeks,weeks,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textWeeks != null && weeks > 0;
         }
         if(months > 0)
         {
            return timeText.slice(0,timeText.length - 1);
         }
         timeText += printTime(textDays,days,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textDays != null && days > 0;
         }
         if(weeks > 0)
         {
            return timeText.slice(0,timeText.length - 1);
         }
         timeText += printTime(textHours,hours,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textHours != null && hours > 0;
         }
         if(days > 0)
         {
            return timeText.slice(0,timeText.length - 1);
         }
         timeText += printTime(textMinutes,minutes,useZeros,hasGreaterUnit);
         if(useSmartZeroUsage)
         {
            hasGreaterUnit ||= textMinutes != null && minutes > 0;
         }
         if(hours > 0)
         {
            return timeText.slice(0,timeText.length - 1);
         }
         if((timeText += printTime(textSeconds,seconds,useZeros,hasGreaterUnit)) == "")
         {
            if(textSeconds != null)
            {
               timeText += seconds + " " + textSeconds + " ";
            }
            else if(textMinutes != null)
            {
               timeText += minutes + " " + textMinutes + " ";
            }
            else if(textHours != null)
            {
               timeText += hours + " " + textHours + " ";
            }
            else if(textDays != null)
            {
               timeText += days + " " + textDays + " ";
            }
            else if(textWeeks != null)
            {
               timeText += weeks + " " + textWeeks + " ";
            }
            else if(textMonths != null)
            {
               timeText += months + " " + textMonths + " ";
            }
            else if(textYears != null)
            {
               timeText += years + " " + textYears + " ";
            }
            else
            {
               timeText += " ";
            }
         }
         return timeText.slice(0,timeText.length - 1);
      }
      
      public static function getTimeFromText(text:String) : Number
      {
         var returnValue:Number = 0;
         var tokens:Array = text.split("d");
         if(tokens.length > 1)
         {
            returnValue = daysToMs(tokens[0]);
         }
         else
         {
            tokens = text.split("h");
            if(tokens.length > 1)
            {
               returnValue = hourToMs(tokens[0]);
            }
            else
            {
               tokens = text.split("m");
               if(tokens.length > 1)
               {
                  returnValue = minToMs(tokens[0]);
               }
               else
               {
                  tokens = text.split("s");
                  if(tokens.length > 1)
                  {
                     returnValue = secondToMs(tokens[0]);
                  }
                  else
                  {
                     returnValue = parseInt(text);
                  }
               }
            }
         }
         return returnValue;
      }
      
      private static function printTime(timeStr:String, timeAmount:int, useZeros:Boolean, hasGreaterUnit:Boolean) : String
      {
         if(timeStr == null)
         {
            return "";
         }
         if(useZeros == false && timeAmount == 0 && hasGreaterUnit == false)
         {
            return "";
         }
         return timeAmount + " " + timeStr + " ";
      }
      
      public static function dateFromMs(value:Number) : Date
      {
         var d:Date = new Date();
         d.setTime(value);
         return d;
      }
   }
}
