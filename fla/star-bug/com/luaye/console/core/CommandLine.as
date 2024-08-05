package com.luaye.console.core
{
   import com.luaye.console.Console;
   import com.luaye.console.utils.Utils;
   import com.luaye.console.utils.WeakObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class CommandLine extends EventDispatcher
   {
      
      public static const CHANGED_SCOPE:String = "changedScope";
      
      private static const VALUE_CONST:String = "#";
      
      private static const MAX_INTERNAL_STACK_TRACE:int = 1;
       
      
      private var _saved:WeakObject;
      
      private var _scope:*;
      
      private var _prevScope:*;
      
      private var _reserved:Array;
      
      private var _values:Array;
      
      private var _master:Console;
      
      private var _tools:CommandTools;
      
      public function CommandLine(m:Console)
      {
         super();
         this._master = m;
         this._tools = new CommandTools(this.report);
         this._saved = new WeakObject();
         this._scope = m;
         this._saved.set("C",m);
         this._reserved = new Array("returned","base","C");
      }
      
      public function set base(obj:Object) : void
      {
         if(this.base)
         {
            this.report("Set new commandLine base from " + this.base + " to " + obj,10);
         }
         else
         {
            this._scope = obj;
            dispatchEvent(new Event("changedScope"));
         }
         this._saved.set("base",obj,this._master.strongRef);
      }
      
      public function get base() : Object
      {
         return this._saved.get("base");
      }
      
      public function destroy() : void
      {
         this._saved = null;
         this._master = null;
         this._reserved = null;
         this._tools = null;
      }
      
      public function store(n:String, obj:Object, strong:Boolean = false) : void
      {
         var str:String = null;
         strong = strong || this._master.strongRef || obj is Function;
         n = n.replace(/[^\w]*/g,"");
         if(this._reserved.indexOf(n) >= 0)
         {
            this.report("ERROR: The name [" + n + "] is reserved",10);
            return;
         }
         this._saved.set(n,obj,strong);
         if(!this._master.quiet)
         {
            str = strong ? "STRONG" : "WEAK";
            this.report("Stored <p5>$" + n + "</p5> for <b>" + getQualifiedClassName(obj) + "</b> using <b>" + str + "</b> reference.",-1);
         }
      }
      
      public function get scopeString() : String
      {
         return Utils.shortClassName(this._scope);
      }
      
      public function run(str:String) : *
      {
         this.report("&gt; " + str,5,false);
         if(!this._master.commandLineAllowed)
         {
            this.report("CommandLine is disabled.",10);
            return null;
         }
         var v:* = null;
         var isClean:* = this._values == null;
         if(isClean)
         {
            this._values = [];
         }
         try
         {
            if(str.charAt(0) == "/")
            {
               this.execCommand(str);
            }
            else
            {
               v = this.exec(str);
            }
         }
         catch(e:Error)
         {
            reportError(e);
         }
         if(isClean)
         {
            this._values = null;
         }
         return v;
      }
      
      private function execCommand(str:String) : void
      {
         var sii:uint = 0;
         var sii2:uint = 0;
         var X:* = null;
         var sao:* = undefined;
         var viewAll:Boolean = false;
         var brk:int = str.indexOf(" ");
         var cmd:String = str.substring(1,brk > 0 ? brk : str.length);
         var param:String = brk > 0 ? str.substring(brk + 1) : "";
         if(cmd == "help")
         {
            this._tools.printHelp();
         }
         else if(cmd == "remap")
         {
            this.doReturn(this._tools.reMap(param,this._master.stage));
         }
         else if(cmd == "strong")
         {
            if(param == "true")
            {
               this._master.strongRef = true;
               this.report("Now using STRONG referencing.",10);
            }
            else if(param == "false")
            {
               this._master.strongRef = false;
               this.report("Now using WEAK referencing.",10);
            }
            else if(this._master.strongRef)
            {
               this.report("Using STRONG referencing. \'/strong false\' to use weak",-2);
            }
            else
            {
               this.report("Using WEAK referencing. \'/strong true\' to use strong",-2);
            }
         }
         else if(cmd == "save" || cmd == "store" || cmd == "savestrong" || cmd == "storestrong")
         {
            if(this._scope)
            {
               if(!(param = param.replace(/[^\w]/g,"")))
               {
                  this.report("ERROR: Give a name to save.",10);
               }
               else
               {
                  this.store(param,this._scope,cmd == "savestrong" || cmd == "storestrong");
               }
            }
            else
            {
               this.report("Nothing to save",10);
            }
         }
         else if(cmd == "string")
         {
            this.report("String with " + param.length + " chars stored. Use /save <i>(name)</i> to save.",-2);
            this._scope = param;
            dispatchEvent(new Event("changedScope"));
         }
         else if(cmd == "saved" || cmd == "stored")
         {
            this.report("Saved vars: ",-1);
            sii = 0;
            sii2 = 0;
            for(X in this._saved)
            {
               sao = this._saved[X];
               sii++;
               if(sao == null)
               {
                  sii2++;
               }
               this.report("<b>$" + X + "</b> = " + (sao == null ? "null" : getQualifiedClassName(sao)),-2);
            }
            this.report("Found " + sii + " item(s), " + sii2 + " empty (or garbage collected).",-1);
         }
         else if(cmd == "filter" || cmd == "search")
         {
            this._master.filterText = str.substring(8);
         }
         else if(cmd == "inspect" || cmd == "inspectfull")
         {
            if(this._scope)
            {
               viewAll = cmd == "inspectfull" ? true : false;
               this.inspect(this._scope,viewAll);
            }
            else
            {
               this.report("Empty",10);
            }
         }
         else if(cmd == "map")
         {
            if(this._scope)
            {
               this.map(this._scope as DisplayObjectContainer,int(param));
            }
            else
            {
               this.report("Empty",10);
            }
         }
         else if(cmd == "/")
         {
            this.doReturn(!!this._prevScope ? this._prevScope : this.base);
         }
         else if(cmd == "scope")
         {
            this.doReturn(this._saved["returned"],true);
         }
         else if(cmd == "base")
         {
            this.doReturn(this.base);
         }
         else
         {
            this.report("Undefined command <b>/help</b> for info.",10);
         }
      }
      
      private function exec(str:String) : *
      {
         var line:String = null;
         var match:String = null;
         var quote:String = null;
         var start:int = 0;
         var end:int = 0;
         var string:String = null;
         var strReg:RegExp;
         var result:Object = (strReg = /('(.*?)[^\\]')|("(.*?)[^\\]")|''|""/).exec(str);
         while(result != null)
         {
            quote = (match = String(result[0])).charAt(0);
            start = match.indexOf(quote);
            end = match.lastIndexOf(quote);
            string = match.substring(start + 1,end).replace(/\\(.)/g,"$1");
            str = this.tempValue(str,new Value(string),result.index + start,result.index + end + 1);
            result = strReg.exec(str);
         }
         if(str.search(/'|"/) >= 0)
         {
            throw new Error("Bad syntax extra quotation marks");
         }
         var v:* = null;
         var lineBreaks:Array = str.split(/\s*;\s*/);
         for each(line in lineBreaks)
         {
            if(line.length)
            {
               v = this.execNest(line);
            }
         }
         return v;
      }
      
      private function execNest(line:String) : *
      {
         var firstClose:int = 0;
         var indopen2:* = 0;
         var indClose:int = 0;
         var inside:String = null;
         var isfun:Boolean = false;
         var fi:int = 0;
         var char:String = null;
         var params:Array = null;
         var X:* = null;
         var groupv:* = undefined;
         line = this.ignoreWhite(line);
         var indOpen:int = line.lastIndexOf("(");
         while(indOpen >= 0)
         {
            firstClose = line.indexOf(")",indOpen);
            if(line.substring(indOpen + 1,firstClose).search(/\w/) >= 0)
            {
               indopen2 = indOpen;
               indClose = indOpen + 1;
               while(indopen2 >= 0 && indopen2 < indClose)
               {
                  indopen2++;
                  indopen2 = line.indexOf("(",indopen2);
                  indClose = line.indexOf(")",indClose + 1);
               }
               inside = line.substring(indOpen + 1,indClose);
               isfun = false;
               fi = indOpen - 1;
               while(!((char = line.charAt(fi)).match(/[^\s]/) || fi <= 0))
               {
                  fi--;
               }
               if(char.match(/\w/))
               {
                  isfun = true;
               }
               if(isfun)
               {
                  params = inside.split(",");
                  line = this.tempValue(line,new Value(params),indOpen + 1,indClose);
                  for(X in params)
                  {
                     params[X] = this.execOperations(this.ignoreWhite(params[X])).value;
                  }
               }
               else
               {
                  groupv = new Value(groupv);
                  line = this.tempValue(line,groupv,indOpen,indClose + 1);
                  groupv.value = this.execOperations(this.ignoreWhite(inside)).value;
               }
            }
            indOpen = line.lastIndexOf("(",indOpen - 1);
         }
         var v:* = this.execOperations(line).value;
         this.doReturn(v);
         return v;
      }
      
      private function tempValue(str:String, v:*, indOpen:int, indClose:int) : String
      {
         str = Utils.replaceByIndexes(str,"#" + this._values.length,indOpen,indClose);
         this._values.push(v);
         return str;
      }
      
      private function execOperations(str:String) : Value
      {
         var i:int = 0;
         var op:String = null;
         var res:* = undefined;
         var lastindex:int = 0;
         var index:int = 0;
         var operation:String = null;
         var reg:RegExp;
         var result:Object = (reg = /\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof\s)\s*/g).exec(str);
         var seq:Array = [];
         if(result == null)
         {
            seq.push(str);
         }
         else
         {
            lastindex = 0;
            while(result != null)
            {
               index = int(result.index);
               operation = String(result[0]);
               if((result = reg.exec(str)) == null)
               {
                  seq.push(str.substring(lastindex,index));
                  seq.push(operation.replace(/\s/g,""));
                  seq.push(str.substring(index + operation.length));
               }
               else
               {
                  seq.push(str.substring(lastindex,index));
                  seq.push(operation.replace(/\s/g,""));
                  lastindex = index + operation.length;
               }
            }
         }
         var len:int = int(seq.length);
         for(i = 0; i < len; )
         {
            seq[i] = this.execSimple(seq[i]);
            i += 2;
         }
         var setter:RegExp = /((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=/;
         for(i = 1; i < len; )
         {
            op = String(seq[i]);
            if(op.replace(setter,"") != "")
            {
               res = this.operate(seq[i - 1].value,op,seq[i + 1].value);
               seq[i - 1].value = res;
               seq.splice(i,2);
               i -= 2;
               len -= 2;
            }
            i += 2;
         }
         seq.reverse();
         var v:Value = seq[0];
         for(i = 1; i < len; )
         {
            op = String(seq[i]);
            if(op.replace(setter,"") == "")
            {
               v = seq[i + 1];
               if(op.length > 1)
               {
                  op = op.substring(0,op.length - 1);
               }
               res = this.operate(v.value,op,seq[i - 1].value);
               v.value = res;
               if(v.base != null)
               {
                  v.base[v.prop] = v.value;
               }
            }
            i += 2;
         }
         return v;
      }
      
      private function execSimple(str:String) : Value
      {
         var firstparts:Array = null;
         var newstr:* = null;
         var defclose:int = 0;
         var newobj:* = undefined;
         var classstr:String = null;
         var def:* = undefined;
         var havemore:* = false;
         var index:int = 0;
         var isFun:* = false;
         var basestr:String = null;
         var newv:Value = null;
         var newbase:* = undefined;
         var closeindex:int = 0;
         var paramstr:String = null;
         var params:Array = null;
         var nss:Array = null;
         var ns:Namespace = null;
         var nsv:* = undefined;
         var v:Value = new Value();
         if(str.indexOf("new ") == 0)
         {
            newstr = str;
            if((defclose = str.indexOf(")")) >= 0)
            {
               newstr = str.substring(0,defclose + 1);
            }
            newobj = this.makeNew(newstr.substring(4));
            str = this.tempValue(str,new Value(newobj,newobj,newstr),0,newstr.length);
         }
         var result:Object;
         var reg:RegExp;
         if((result = (reg = /\.|\(/g).exec(str)) == null || !isNaN(Number(str)))
         {
            return this.execValue(str,null);
         }
         firstparts = str.split("(")[0].split(".");
         if(firstparts.length > 0)
         {
            while(firstparts.length)
            {
               classstr = firstparts.join(".");
               try
               {
                  def = getDefinitionByName(this.ignoreWhite(classstr));
                  havemore = str.length > classstr.length;
                  str = this.tempValue(str,new Value(def,def,classstr),0,classstr.length);
                  if(havemore)
                  {
                     reg.lastIndex = 0;
                     result = reg.exec(str);
                     break;
                  }
                  return this.execValue(str,null);
               }
               catch(e:Error)
               {
                  firstparts.pop();
               }
            }
         }
         var previndex:int = 0;
         while(true)
         {
            if(result == null)
            {
               return v;
            }
            index = int(result.index);
            isFun = str.charAt(index) == "(";
            basestr = this.ignoreWhite(str.substring(previndex,index));
            newbase = (newv = this.execValue(basestr,v.base)).value;
            v.base = newv.base;
            if(isFun)
            {
               closeindex = str.indexOf(")",index);
               paramstr = (paramstr = str.substring(index + 1,closeindex)).replace(/\s/g,"");
               params = [];
               if(paramstr)
               {
                  params = this.execValue(paramstr).value;
               }
               if(!(newbase is Function))
               {
                  try
                  {
                     nss = [AS3,flash_proxy];
                     for each(ns in nss)
                     {
                        if((nsv = v.base.ns::[basestr]) is Function)
                        {
                           newbase = nsv;
                           break;
                        }
                     }
                  }
                  catch(e:Error)
                  {
                  }
                  if(!(newbase is Function))
                  {
                     break;
                  }
               }
               v.value = (newbase as Function).apply(v.base,params);
               v.base = v.value;
               index = closeindex + 1;
            }
            else
            {
               v.value = newbase;
            }
            v.prop = basestr;
            previndex = index + 1;
            reg.lastIndex = index + 1;
            if((result = reg.exec(str)) != null)
            {
               v.base = v.value;
            }
            else if(index + 1 < str.length)
            {
               v.base = v.value;
               reg.lastIndex = str.length;
               result = {"index":str.length};
            }
         }
         throw new Error(basestr + " is not a function.");
      }
      
      private function execValue(str:String, base:* = null) : Value
      {
         var v:Value = null;
         var vv:Value = null;
         var key:String = null;
         var nobase:Boolean = !!base ? false : true;
         v = new Value(null,base,str);
         base = !!base ? base : this._scope;
         if(nobase && (!base || !base.hasOwnProperty(str)))
         {
            if(str == "true")
            {
               v.value = true;
            }
            else if(str == "false")
            {
               v.value = false;
            }
            else if(str == "this")
            {
               v.base = this._scope;
               v.value = this._scope;
            }
            else if(str == "null")
            {
               v.value = null;
            }
            else if(str == "NaN")
            {
               v.value = NaN;
            }
            else if(str == "Infinity")
            {
               v.value = Infinity;
            }
            else if(str == "undefined")
            {
               v.value = undefined;
            }
            else if(!isNaN(Number(str)))
            {
               v.value = Number(str);
            }
            else if(str.indexOf("#") == 0)
            {
               vv = this._values[str.substring("#".length)];
               v.base = vv.base;
               v.value = vv.value;
            }
            else if(str.charAt(0) == "$")
            {
               key = str.substring(1);
               v.value = this._saved[key];
               if(this._reserved.indexOf(key) < 0)
               {
                  if(v.value == null)
                  {
                     this.store(key,v.value);
                  }
                  v.base = this._saved;
                  v.prop = key;
               }
            }
            else
            {
               try
               {
                  v.value = getDefinitionByName(str);
                  v.base = v.value;
               }
               catch(e:Error)
               {
                  v.base = base;
                  v.value = base[str];
               }
            }
         }
         else
         {
            v.base = base;
            v.value = base[str];
         }
         return v;
      }
      
      private function operate(v1:*, op:String, v2:*) : *
      {
         switch(op)
         {
            case "=":
               return v2;
            case "+":
               return v1 + v2;
            case "-":
               return v1 - v2;
            case "*":
               return v1 * v2;
            case "/":
               return v1 / v2;
            case "%":
               return v1 % v2;
            case "^":
               return v1 ^ v2;
            case "&":
               return v1 & v2;
            case ">>":
               return v1 >> v2;
            case ">>>":
               return v1 >>> v2;
            case "<<":
               return v1 << v2;
            case "~":
               return ~v2;
            case "|":
               return v1 | v2;
            case "!":
               return !v2;
            case ">":
               return v1 > v2;
            case ">=":
               return v1 >= v2;
            case "<":
               return v1 < v2;
            case "<=":
               return v1 <= v2;
            case "||":
               return v1 || v2;
            case "&&":
               return v1 && v2;
            case "is":
               return v1 is v2;
            case "typeof":
               return typeof v2;
            case "==":
               return v1 == v2;
            case "===":
               return v1 === v2;
            case "!=":
               return v1 != v2;
            case "!==":
               return v1 !== v2;
            default:
               return;
         }
      }
      
      private function makeNew(str:String) : *
      {
         var closeindex:int = 0;
         var paramstr:String = null;
         var p:Array = null;
         var len:int = 0;
         var openindex:int;
         var defstr:String = (openindex = str.indexOf("(")) > 0 ? str.substring(0,openindex) : str;
         defstr = this.ignoreWhite(defstr);
         var def:* = this.execValue(defstr).value;
         if(openindex > 0)
         {
            closeindex = str.indexOf(")",openindex);
            paramstr = (paramstr = str.substring(openindex + 1,closeindex)).replace(/\s/g,"");
            p = [];
            if(paramstr)
            {
               p = this.execValue(paramstr).value;
            }
            if((len = int(p.length)) == 0)
            {
               return new def();
            }
            if(len == 1)
            {
               return new def(p[0]);
            }
            if(len == 2)
            {
               return new def(p[0],p[1]);
            }
            if(len == 3)
            {
               return new def(p[0],p[1],p[2]);
            }
            if(len == 4)
            {
               return new def(p[0],p[1],p[2],p[3]);
            }
            if(len == 5)
            {
               return new def(p[0],p[1],p[2],p[3],p[4]);
            }
            if(len == 6)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5]);
            }
            if(len == 7)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6]);
            }
            if(len == 8)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);
            }
            if(len == 9)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8]);
            }
            if(len == 10)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9]);
            }
            if(len == 11)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10]);
            }
            if(len == 12)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11]);
            }
            if(len == 13)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12]);
            }
            if(len == 14)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13]);
            }
            if(len == 15)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14]);
            }
            if(len >= 16)
            {
               return new def(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15]);
            }
         }
         return null;
      }
      
      private function ignoreWhite(str:String) : String
      {
         str = str.replace(/\s*(.*)/,"$1");
         var i:int = str.length - 1;
         while(i > 0)
         {
            if(!str.charAt(i).match(/\s/))
            {
               break;
            }
            str = str.substring(0,i);
            i--;
         }
         return str;
      }
      
      private function doReturn(returned:*, force:Boolean = false) : void
      {
         var newb:Boolean = false;
         var typ:* = typeof returned;
         if(returned)
         {
            this._saved.set("returned",returned,true);
            if(returned !== this._scope && (force || typ == "object" || typ == "xml"))
            {
               newb = true;
               this._prevScope = this._scope;
               this._scope = returned;
               dispatchEvent(new Event("changedScope"));
            }
         }
         var rtext:String = (rtext = (rtext = returned).replace(/</gim,"&lt;")).replace(/>/gim,"&gt;");
         this.report((newb ? "<b>+</b> " : "") + "Returned " + getQualifiedClassName(returned) + ": <b>" + rtext + "</b>",-2);
      }
      
      private function reportError(e:Error) : void
      {
         var i:int = 0;
         var line:String = null;
         var str:String = e.hasOwnProperty("getStackTrace") ? e.getStackTrace() : String(e);
         if(!str)
         {
            str = String(e);
         }
         var lines:Array = str.split(/\n\s*/);
         var p:int = 10;
         var internalerrs:int = 0;
         var self:String = getQualifiedClassName(this);
         var len:int = int(lines.length);
         var parts:Array = [];
         for(i = 0; i < len; )
         {
            line = String(lines[i]);
            if(line.search(new RegExp("\\s*at " + self)) == 0)
            {
               if(internalerrs >= 1 && i > 0)
               {
                  break;
               }
               internalerrs++;
            }
            parts.push("<p" + p + ">&gt;&nbsp;" + line.replace(/\s/,"&nbsp;") + "</p" + p + ">");
            if(p > 6)
            {
               p--;
            }
            i++;
         }
         this.report(parts.join("\n"),9);
      }
      
      public function map(base:DisplayObjectContainer, maxStep:uint = 0) : void
      {
         this._tools.map(base,maxStep);
      }
      
      public function inspect(obj:Object, viewAll:Boolean = true) : void
      {
         this._tools.inspect(obj,viewAll);
      }
      
      public function report(obj:*, priority:Number = 1, skipSafe:Boolean = true) : void
      {
         this._master.report(obj,priority,skipSafe);
      }
   }
}

class Value
{
    
   
   public var base:Object;
   
   public var prop:String;
   
   public var value:*;
   
   public function Value(v:* = null, b:Object = null, p:String = null)
   {
      super();
      this.base = b;
      this.prop = p;
      this.value = v;
   }
}
