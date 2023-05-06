#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
string 使用期限=""; //不填写则不限制，格式：2018.04.08 00:00
string 账号限制="";  //不填写则不限制，填写授权数字账号，|间隔，如：8888|9999|666

enum MYPERIOD{当前=0,M1=1,M2=2,M3=3,M4=4,M5=5,M6=6,M10=10,M12=12,M15=15,M20=20,M30=30,H1=60,H2=120,H3=180,H4=240,H6=360,H8=480,H12=720,D1=1440,W1=10080,MN1=43200};
input MYPERIOD 时间周期=当前;

#define OP_BUY 0
#define OP_SELL 1
enum MY_OP2{BUY=OP_BUY,SELL=OP_SELL}; 

input int __超卖=70;
input double __手数=0.1;
input int __止损=100;
input int __止盈=100;
input int _RSI1_时间周期=14;
input ENUM_APPLIED_PRICE _RSI1_应用于=PRICE_CLOSE;

input int 最大允许滑点=900;

#define _tn_int long
#define _m_int long
#define _p_int long

input _m_int _订单识别码=0;
_m_int _内码=0;
input string 订单注释="";
_m_int 子识别码=0;
string _换注释="";
bool _b换注释=false;

_m_int 订单识别码=0;
_m_int 备份_分组码=0;
_m_int 备份_指定码=0;
int 强制判断识别码=0;

int 分组循环中=0;

int 指令执行了操盘=0;

_m_int 订单_R_识别码=0;
int 强制判断_R_识别码=0;
int 分组循环_R_中=0;

_m_int 备份_R_分组码=0;
_m_int 备份_R_指定码=0;

bool mOrderOk暂停=false;

int _点系数=1;

_tn_int _mPubTsIns[]={};
int _mPubTsInc=0;
_tn_int _mPubTsExs[]={};
int _mPubTsExc=0;
_tn_int _mPubTs2Ins[]={};
int _mPubTs2Inc=0;
_tn_int _mPubTs2Exs[]={};
int _mPubTs2Exc=0;
_tn_int _mPubTn0=0;

_tn_int _mPubHisTsIns[]={};
int _mPubHisTsInc=0;
_tn_int _mPubHisTsExs[]={};
int _mPubHisTsExc=0;
_tn_int _mPubHisTs2Ins[]={};

_tn_int _mPubHisTs2Exs[]={};

#define OP_BUYLIMIT 2
#define OP_SELLLIMIT 3
#define OP_BUYSTOP 4
#define OP_SELLSTOP 5
#define MODE_MAIN 0
#define MODE_SIGNAL 1
#define MODE_UPPER 0
#define MODE_LOWER 1
#define MODE_PLUSDI 1
#define MODE_MINUSDI 2
#define mq4_MODE_OPEN 0
#define mq4_MODE_CLOSE 3
#define mq4_MODE_VOLUME 4 
#define mq4_MODE_LOW 1
#define mq4_MODE_HIGH 2
#define mq4_MODE_TIME 5
#define MODE_GATORJAW 1
#define MODE_GATORTEETH 2
#define MODE_GATORLIPS 3
#define MODE_TENKANSEN 1 
#define MODE_KIJUNSEN 2
#define MODE_SENKOUSPANA 3
#define MODE_SENKOUSPANB 4
#define MODE_CHIKOUSPAN 5

#define MYARC 20
#define MYPC 300
_p_int _mPubi[MYPC];
double _mPubv[MYPC];
string _mPubs[MYPC];
datetime _mPubTime[MYPC];
color _mPubr[MYPC];
double _mPubFs[MYARC][MYPC]={};
_p_int _mPubIs[MYARC][MYPC]={};
int _mPubIsc[MYARC]={};
int _mPubFsc[MYARC]={};

#define MYARR_DC 1
#define MYARR_IC 1
#define MYARR_SC 1

int mArrDc[MYARR_DC];
_p_int mArrIs[MYARR_IC][300];
int mArrIc[MYARR_IC];

int mArrSc[MYARR_SC];
int mMks[20]={};

#define MYTC 300
class _TArA { public:   double a[];   double b[];   int c; };

int §=0;

_m_int gGa=0;
_m_int gGb=0;
_m_int gGa_bak=0;
_m_int gGb_bak=0;

string sym="";

int period=0;

string mPreCap="";
string mPreCapM="";
string mPreCapP=""; //此类变量会在修改参数后也删除重置
string mPreCapNoDel="";//此类变量如果是挂ea，则永不清除；若是回测，则清除
string _mInitCap_LoadTime="";
string _mCap_TimePos1=""; //时间标注点

int mReInit=0;
int mReIniPr=0;
int OnInit() {
   string hd=MQLInfoString(MQL_PROGRAM_NAME);

   mPreCapM=hd+"_"+string(_订单识别码)+"_"; if (MQLInfoInteger(MQL_TESTER)) mPreCapM+="test_";
   if (StringLen(mPreCapM)>26) mPreCapM=StringSubstr(mPreCapM,StringLen(mPreCapM)-26);

   mPreCap=hd+"_"+string(_订单识别码)+"_"+Symbol()+"_"; if (MQLInfoInteger(MQL_TESTER)) mPreCap+="test_";
   if (StringLen(mPreCap)>26) mPreCap=StringSubstr(mPreCap,StringLen(mPreCap)-26);

   mPreCapNoDel=hd+"_"+string(_订单识别码)+"*_"+Symbol()+"_"; if (MQLInfoInteger(MQL_TESTER)) mPreCapNoDel+="test_";
   if (StringLen(mPreCapNoDel)>26) mPreCapNoDel=StringSubstr(mPreCapNoDel,StringLen(mPreCapNoDel)-26);
   
   string sycap="eano1_cur_sym";
   if (ObjectGetString(0,sycap,OBJPROP_TEXT)!=Symbol()) { //不能用字符串变量记录和判断，mt5不适用
      myObjectsDeleteAll(); //图表品种被改变
      myCreateLabel(Symbol(),sycap,0,-2000,-2000,10,255,CORNER_LEFT_UPPER);
   }
   
   if (MQLInfoInteger(MQL_TESTER)) {
      myObjectDeleteByPreCap(mPreCapM);
      myDeleteGlobalVariableByPre(mPreCapM);
      myObjectDeleteByPreCap(mPreCap);
      myDeleteGlobalVariableByPre(mPreCap);
      myObjectDeleteByPreCap(mPreCapNoDel);
      myDeleteGlobalVariableByPre(mPreCapNoDel);
   }   
   mPreCapP=mPreCap+"#_";
      
   _mInitCap_LoadTime=mPreCap+"_pub_loadtime";
   if (myGlobalVDateTimeCheck(_mInitCap_LoadTime)==false) myGlobalVDateTimeSet(_mInitCap_LoadTime,TimeCurrent());
   _mCap_TimePos1=mPreCap+"_pub_tmpos1";
   if (myGlobalVDateTimeCheck(_mCap_TimePos1)==false) myGlobalVDateTimeSet(_mCap_TimePos1,TimeCurrent());

   string cap=mPreCap+"_pub_loadea";
   if (mReInit==0 || GlobalVariableCheck(cap)==false) { //mt4非正常退出，mPreCap是无法判断的，只能通过mReInit来判断
      //显性复位

      for (int i=0;i<MYPC;++i) {
         _mPubi[i]=0;
         _mPubv[i]=0;
         _mPubs[i]="";
         _mPubTime[i]=0;
         _mPubr[i]=0;
      }
      for (int i=0;i<MYARC;++i) {
         for (int j=0;j<MYPC;++j) {
            _mPubFs[i][j]=0;
            _mPubIs[i][j]=0;
         }
         _mPubIsc[i]=0;
         _mPubFsc[i]=0;
      }
      
      ArrayInitialize(mArrDc,-1);
      ArrayInitialize(mArrIc,-1);
      ArrayInitialize(mArrSc,-1);
      mReIniPr=1;      mReInit=1; GlobalVariableSet(cap,1);
   }
   if (mReIniPr==0) {
      ArrayInitialize(mArrDc,-1);
      ArrayInitialize(mArrIc,-1);
      ArrayInitialize(mArrSc,-1);
      mReIniPr=1;
   }
   
   _内码=_订单识别码; if (_内码==0) _内码=444;
   订单识别码=_内码;
   订单_R_识别码=_内码;
   
//mt5custominit

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {

   //if (MQLInfoInteger(MQL_TESTER)==false) myObjectDeleteByPreCap(mPreCap);  //切换周期不能删除，否则按钮状态会改变
   if (reason==REASON_REMOVE || reason==REASON_CHARTCLOSE || reason==REASON_PROGRAM) {
      if (MQLInfoInteger(MQL_TESTER)==false) {
         myObjectDeleteByPreCap(mPreCapM);
         myObjectDeleteByPreCap(mPreCap);
         GlobalVariableDel(mPreCap+"_pub_loadea");
         bool ok=true;

         if (ok) {
            myDeleteGlobalVariableByPre(mPreCap);
            myDeleteGlobalVariableByPre(mPreCapM);
         }
      }
   }
   if (reason==REASON_PARAMETERS) {
      myObjectDeleteByPreCap(mPreCapP);
      myDeleteGlobalVariableByPre(mPreCapP);
      mReIniPr=0;
   }
}

void OnTick() {mEr2=0;
   if (myTimeLimit(使用期限)==false) return;
   if (myAccountNumCheck()==false) return;
   if (_订单识别码==444 || _订单识别码==-444) { Alert("~~~~~~自定识别码不能设置为444和-444这两个数字"); ExpertRemove(); return; } 
   int _tmp_w_break=0;

   mEr1=0;


   int _or=0;
   §=0; gGa=0; _mPubTsInc=_mPubTsExc=_mPubHisTsInc=_mPubHisTsExc=-1;
   period=时间周期; if (period==0) period=mt4Period();
   sym=Symbol();

   ArrayInitialize(mMks,0);      
   if (时间周期!=mt4Period() && iOpenMQL4(sym,时间周期,0)==0.00004751) Print("~~~a");
   int _ok0=-1;
   if (_ok0==-1) {
      int _ok1=myFun77_1();
      _ok0=_ok1;
      if (_ok1==1 && mEr1==0) { myFun139_1(); }
   }

}

int mErrXY=-9876543;

int mMaxX=0;
int mMaxY=0;

datetime myGlobalVDateTimeGet(string vcap) {
   string hcap=vcap+"__h";
   string lcap=vcap+"__l";
   double h=GlobalVariableGet(hcap);
   double l=GlobalVariableGet(lcap);
   double r=h*1000000+l;
   return (datetime)r;
}

void myGlobalVDateTimeSet(string vcap,datetime t) {
   string hcap=vcap+"__h";
   string lcap=vcap+"__l";
   double f=(double)t;
   double h=int(f/1000000);
   double l=int(f)%1000000;
   GlobalVariableSet(hcap,h);
   GlobalVariableSet(lcap,l);
}

bool myGlobalVDateTimeCheck(string vcap) {
   return GlobalVariableCheck(vcap+"__h");
}

bool myIsOpenByThisEA(_m_int om) {
  if (订单识别码==0 && 强制判断识别码==0)  return true;
  if (_订单识别码==0 && 强制判断识别码==0)  return true; //用户接口参数直接设置为0表示忽略识别码（判断的是“_订单识别码”，而非“订单识别码”，因此不影响区分手工单）
  if (分组循环中==1) return om==订单识别码;

   return om==订单识别码;
}

bool myIsOpenByThisEA2(_m_int om,int incSub) {
  if (订单识别码==0 && 强制判断识别码==0)  return true; 
  if (_订单识别码==0 && 强制判断识别码==0)  return true; //用户接口参数直接设置为0表示忽略识别码（判断的是“_订单识别码”，而非“订单识别码”，因此不影响区分手工单）
  if (分组循环中==1) return om==订单识别码;

   if (订单识别码==0) return om==订单识别码 || (incSub && int(om/100000)==444); //避免将其它ea的小于100000的识别码误认为是手工单
   return om==订单识别码 || (incSub && int(om/100000)==订单识别码);
}

bool myIsOpenByThis_R_E2(_m_int om,int incSub) {
  if (订单_R_识别码==0 && 强制判断_R_识别码==0)  return true;  
  if (_订单识别码==0 && 强制判断_R_识别码==0)  return true; //用户接口参数直接设置为0表示忽略识别码（判断的是“_订单识别码”，而非“订单_R_识别码”，因此不影响区分手工单）
  if (分组循环_R_中==1) return om==订单_R_识别码;

   if (订单_R_识别码==0) return om==订单_R_识别码 || (incSub && int(om/100000)==444); //避免将其它ea的小于100000的识别码误认为是手工单
   return om==订单_R_识别码 || (incSub && int(om/100000)==订单_R_识别码);
}

void myCreateLabel(string str="mylabel",string ID="def_la1",long chartid=0,int xdis=20,int ydis=20,int fontsize=12,color clr=clrRed,int corner=CORNER_LEFT_UPPER) {
    ObjectCreate(chartid,ID,OBJ_LABEL,0,0,0);
    ObjectSetInteger(chartid,ID,OBJPROP_XDISTANCE,xdis);
    ObjectSetInteger(chartid,ID,OBJPROP_YDISTANCE,ydis);
    ObjectSetString(chartid,ID,OBJPROP_FONT,"Trebuchet MS");
    ObjectSetInteger(chartid,ID,OBJPROP_FONTSIZE,fontsize);
    ObjectSetInteger(chartid,ID,OBJPROP_CORNER,corner);
    ObjectSetInteger(chartid,ID,OBJPROP_SELECTABLE,true);
    ObjectSetString(chartid,ID,OBJPROP_TOOLTIP,"\n");
    ObjectSetString(chartid,ID,OBJPROP_TEXT,str);
   ObjectSetInteger(chartid,ID,OBJPROP_COLOR,clr);
}

double myLotsValid(string sym0,double lots,bool returnMin=false) {
   double step=myMarketInfo(sym0,24);
   if (step<0.000001) { Alert("品种【",sym0,"】数据读取失败，请检查此品种是否存在。若有后缀，请包含后缀。");  return lots; }
   double ls0=lots;
   int v=(int)MathRound(lots/step); lots=v*step;
   double min=myMarketInfo(sym0,23);
   double max=myMarketInfo(sym0,25);
   if (v<-99999 || ls0>99999999) return max; //lots可能由于逆加翻倍次数太多而非常大，造成v内存溢出
   if (lots<min) {
      if (returnMin) return min;
      Alert("手数太小，不符合平台要求"); lots=-1;
   }
   if (lots>max) lots=max;
   return lots;
}

string 时间限制_时间前缀="使用期限：";
string 时间限制_时间后缀="";
string 时间过期_时间前缀="~~~~~~~已过使用期限：";
string 时间过期_时间后缀="";
bool myTimeLimit(string timestr) {
   if (timestr=="") return true;
   datetime t=StringToTime(timestr);
   if (TimeCurrent()<t) {
      myCreateLabel(时间限制_时间前缀+timestr+时间限制_时间后缀,mPreCap+"myTimeLimit",0,20,20,10,255,CORNER_LEFT_LOWER);
      return true;
   }
   else {
      myCreateLabel(时间过期_时间前缀+timestr+时间过期_时间后缀,mPreCap+"myTimeLimit",0,20,20,10,255,CORNER_LEFT_LOWER);
      return false;
   }
}

bool myAccountNumCheck() {
   if (账号限制=="") return true;
   
   ushort u_sep=StringGetCharacter("|",0);
   string ss[1000]; int c=StringSplit(账号限制,u_sep,ss);
   if (c>=1000) Alert("授权列表数量太大");
   
   string s=string(AccountInfoInteger(ACCOUNT_LOGIN));
   for (int i=0;i<c;++i) if (s==ss[i]) return true;
     
   myCreateLabel("非授权账户账号:"+s,mPreCap+"onlyuser2"); 
   return false; 
}

void myDeleteGlobalVariableByPre(string pre) {
   int len=StringLen(pre);
   for (int i=GlobalVariablesTotal()-1;i>=0;--i) {
      string cap=GlobalVariableName(i);
      if (StringSubstr(cap,0,len)==pre)
   GlobalVariableDel(cap);
   }
}

void myObjectDeleteByPreCap(string PreCap) {
//删除指定名称前缀的对象
   int len=StringLen(PreCap);
   for (int i=myObjectsTotal()-1;i>=0;--i) {
      string cap=myObjectName(i);
      if (StringSubstr(cap,0,len)==PreCap)
         myObjectDelete(cap);
   }
}

string myPeriodStr(int p0) {
   int pid=0; if (p0==0) p0=mt4Period();
   string pstr;
   switch (p0) {
      case 1: pid=0; pstr="M1"; break;
      case 5: pid=1; pstr="M5"; break;
      case 15: pid=2; pstr="M15"; break;
      case 30: pid=3; pstr="M30"; break;
      case 60: pid=4; pstr="H1"; break;
      case 240: pid=5; pstr="H4"; break;
      case 1440: pid=6; pstr="D1"; break;
      case 10080: pid=7; pstr="W1"; break;
      case 43200: pid=8; pstr="MN"; break;
      default: pstr=string(p0);
   }
   return pstr;
}

bool myOrderOks(_tn_int tn) {
   if (mOrderOk暂停) return true;
   if (_mPubTsExc>0) { for (int i=0;i<_mPubTsExc;++i) { if (_mPubTsExs[i]==tn) return false; }  }
   if (_mPubTsInc>=0){ 
      int i=0; for (;i<_mPubTsInc;++i) { if (_mPubTsIns[i]==tn) break; } 
      if (i>=_mPubTsInc) return false;  
   }
   return true;
}

bool myOrderOk2(_tn_int tn) {
   if (mOrderOk暂停) return true;
   if (_mPubTs2Exc>0) { for (int i=0;i<_mPubTs2Exc;++i) { if (_mPubTs2Exs[i]==tn) return false; }  }
   if (_mPubTs2Inc>=0){ 
      int i=0; for (;i<_mPubTs2Inc;++i) { if (_mPubTs2Ins[i]==tn) break; } 
      if (i>=_mPubTs2Inc) return false;  
   }
   return true;
}

bool myOpenOk(_tn_int tn,int type) {

   return true;
}

bool myFun77_1() {
   int funtype=0;
   double a0=double(iRSIMQL4(sym,period,_RSI1_时间周期,_RSI1_应用于,int(0+§)));
   double b0=double(int(__超卖));
   double a1=double(iRSIMQL4(sym,period,_RSI1_时间周期,_RSI1_应用于,int(0+int(§+1))));
   double b1=double(int(__超卖));
   int type=-1;
   if (a0>b0 && a1<=b1) type=OP_BUY;
   else if (a0<b0 && a1>=b1)  type=OP_SELL;
   if (funtype==0 && type==OP_BUY) return true; 
   else if (funtype==1 && type==OP_SELL) return true;
   return false;

}

_p_int myFun139_1() {
   指令执行了操盘=0;
   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)==false && MQLInfoInteger(MQL_TESTER)==false) return 0;

   _m_int magic=订单识别码;
   int slip=最大允许滑点;
   string comm=订单注释; if (_b换注释) comm=_换注释;

   double pnt=myMarketInfo(sym,11);

   int type=0; 

   double lots=myLotsValid(sym,double(__手数),true);
   double sl=double(int(__止损)*_点系数);
   double tp=double(int(__止盈)*_点系数);

   for(int pos=PositionsTotal()-1;pos>=0;pos--)           {
      if (myOrderSelectP(pos,0)==false) continue;
      if (magic!=444 && myIsOpenByThisEA2(myTOrderMagicNumber(),1)==false) continue;
      if (sym!="" && myTOrderSymbol()!=sym) continue;
      if (myOrderOks(myTOrderTicket())==false) continue;

   }
for(int pos=OrdersTotal()-1;pos>=0;pos--)           {
      if (myOrderSelectO(pos,0)==false) continue;
      if (magic!=444 && myIsOpenByThisEA2(myTOrderMagicNumber(),1)==false) continue;
      if (sym!="" && myTOrderSymbol()!=sym) continue;
      if (myOrderOks(myTOrderTicket())==false) continue;

   }

_tn_int tn=0;
for (int w=0;w<1+0;++w) { if (w>0) { Sleep(3000); Alert("~~~m=",magic,"~~~slip=",slip,"~~~~~建仓重试",w); myRefreshRates(); } 
   double op=0;
   if (type==OP_BUY) {
      op=myMarketInfo(sym,10);
      if (sl>0.001) sl=op-sl*myMarketInfo(sym,11);
      if (tp>0.001) tp=op+tp*myMarketInfo(sym,11);
   }
   else if (type==OP_SELL) {
      op=myMarketInfo(sym,9);
      if (sl>0.001) sl=op+sl*myMarketInfo(sym,11);
      if (tp>0.001) tp=op-tp*myMarketInfo(sym,11);
   }
   else return 0;
   tn=myOrderSend(sym,type,lots,op,slip,sl,tp,comm,magic);
   if (tn>0 && myOpenOk(tn,type)==false) return 0;
   if (tn>0 && w>0) Alert("~~~~重试建仓成功");
   if (tn<=0) {
      int err=GetLastError();
      if (err==134) { Alert("~~~~~~~~~~保证金不足，建仓手数无效：",lots); Sleep(3000); return 0; }
      else if (err>=135 && err<=138) { Alert("~~m=",magic,"~~~网速慢或平台服务器卡~~~~~建仓失败：",err); continue; }
      else Alert("~~m=",magic,"~~~~~~~~建仓失败：",err);
      Sleep(3000); break; 
   }

   if (tn>0) { 指令执行了操盘=1; break; }
}   
   return tn;

}

int mt4Type(long mt5Type) {
   if (mt5Type==POSITION_TYPE_BUY) return OP_BUY;
   if (mt5Type==POSITION_TYPE_SELL) return OP_SELL;
   if (mt5Type==ORDER_TYPE_BUY) return OP_BUY; 
   if (mt5Type==ORDER_TYPE_SELL) return OP_SELL;
   if (mt5Type==ORDER_TYPE_BUY_LIMIT) return OP_BUYLIMIT;
   if (mt5Type==ORDER_TYPE_SELL_LIMIT) return OP_SELLLIMIT;
   if (mt5Type==ORDER_TYPE_BUY_STOP) return OP_BUYSTOP;
   if (mt5Type==ORDER_TYPE_SELL_STOP) return OP_SELLSTOP;
   if (mt5Type==ORDER_TYPE_BUY_STOP_LIMIT) return 6;
   if (mt5Type==ORDER_TYPE_SELL_STOP_LIMIT) return 7;
   if (mt5Type==ORDER_TYPE_CLOSE_BY) return 8;
   return 9; //原mt4程序中会有ts[10]这样的判断
}

int mt4Period() { //转成mt4的秒数表达方式
   int tf=Period();
   switch(tf) {
      case PERIOD_CURRENT: return 0;
      case PERIOD_M1: return 1;
      case PERIOD_M2: return 2;
      case PERIOD_M3: return 3;
      case PERIOD_M4: return 4;
      case PERIOD_M5: return 5;
      case PERIOD_M6: return 6;
      case PERIOD_M10: return 10;
      case PERIOD_M12: return 12;
      case PERIOD_M15: return 15;
      case PERIOD_M30: return 30;
      case PERIOD_H1: return 60;
      case PERIOD_H2: return 120;
      case PERIOD_H3: return 180;
      case PERIOD_H4: return 240;
      case PERIOD_H6: return 360;
      case PERIOD_H8: return 480;
      case PERIOD_H12: return 720;
      case PERIOD_D1: return 1440;
      case PERIOD_W1: return 10080;
      case PERIOD_MN1: return 43200;
      default: return 0;
   }
}

int mt5PedTomt4(ENUM_TIMEFRAMES tf) { //转成mt4的秒数表达方式
   switch(tf) {
      case PERIOD_CURRENT: return 0;
      case PERIOD_M1: return 1;
      case PERIOD_M2: return 2;
      case PERIOD_M3: return 3;
      case PERIOD_M4: return 4;
      case PERIOD_M5: return 5;
      case PERIOD_M6: return 6;
      case PERIOD_M10: return 10;
      case PERIOD_M12: return 12;
      case PERIOD_M15: return 15;
      case PERIOD_M30: return 30;
      case PERIOD_H1: return 60;
      case PERIOD_H2: return 120;
      case PERIOD_H3: return 180;
      case PERIOD_H4: return 240;
      case PERIOD_H6: return 360;
      case PERIOD_H8: return 480;
      case PERIOD_H12: return 720;
      case PERIOD_D1: return 1440;
      case PERIOD_W1: return 10080;
      case PERIOD_MN1: return 43200;
      default: return 0;
   }
}

ENUM_TIMEFRAMES TFMigrate(int tf) {
   switch(tf) {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);      
      case 5: return(PERIOD_M5);
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 120: return(PERIOD_H2);
      case 180: return(PERIOD_H3);
      case 240: return(PERIOD_H4);
      case 360: return(PERIOD_H6);
      case 480: return(PERIOD_H8);
      case 720: return(PERIOD_H12);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
      case 16385: return(PERIOD_H1);
      case 16386: return(PERIOD_H2);
      case 16387: return(PERIOD_H3);
      case 16388: return(PERIOD_H4);
      case 16390: return(PERIOD_H6);
      case 16392: return(PERIOD_H8);
      case 16396: return(PERIOD_H12);
      case 16408: return(PERIOD_D1);
      case 32769: return(PERIOD_W1);
      case 49153: return(PERIOD_MN1);      
      default: return(PERIOD_CURRENT);
   }
}

ENUM_MA_METHOD MethodMigrate(int method) {
   switch(method) {
      case 0: return(MODE_SMA);
      case 1: return(MODE_EMA);
      case 2: return(MODE_SMMA);
      case 3: return(MODE_LWMA);
      default: return(MODE_SMA);
   }
}

ENUM_APPLIED_PRICE PriceMigrate(int price) {
   switch(price) {
      case 1: return(PRICE_CLOSE);
      case 2: return(PRICE_OPEN);
      case 3: return(PRICE_HIGH);
      case 4: return(PRICE_LOW);
      case 5: return(PRICE_MEDIAN);
      case 6: return(PRICE_TYPICAL);
      case 7: return(PRICE_WEIGHTED);
      default: return(PRICE_CLOSE);
   }
}

ENUM_STO_PRICE StoFieldMigrate(int field) {
   switch(field) {
      case 0: return(STO_LOWHIGH);
      case 1: return(STO_CLOSECLOSE);
      default: return(STO_LOWHIGH);
   }
}

int mEr1=0;
int mEr2=0;
double CopyBufferMQL4(int handle,int index,int shift) {
//不明白官网为什么要时候用switch语句
   double buf[];
   switch (index) {
      case 0: if(CopyBuffer(handle,0,shift,1,buf)>0) return(buf[0]); break;
      case 1: if(CopyBuffer(handle,1,shift,1,buf)>0) return(buf[0]); break;
      case 2: if(CopyBuffer(handle,2,shift,1,buf)>0) return(buf[0]); break;
      case 3: if(CopyBuffer(handle,3,shift,1,buf)>0) return(buf[0]); break;
      case 4: if(CopyBuffer(handle,4,shift,1,buf)>0) return(buf[0]); break;
      case 5: if(CopyBuffer(handle,5,shift,1,buf)>0) return(buf[0]); break;
      case 6: if(CopyBuffer(handle,6,shift,1,buf)>0) return(buf[0]); break;
      case 7: if(CopyBuffer(handle,7,shift,1,buf)>0) return(buf[0]); break;
      default: if(CopyBuffer(handle,index,shift,1,buf)>0) return(buf[0]); break;
   }
   mEr1=mEr2=1;
   return(EMPTY_VALUE);
}

long mTt=0;
bool myOrderSelectP(ulong tnOri,int isTn,int isHis=0) {
   if (isTn==1) {
      Alert("~~~~~~~~Select Tn err1"); return false;
   }
   else {
      if (isHis==0) {
         mTt=1;
         ulong tn=PositionGetTicket(int(tnOri)); if (tn<=0) return false;
      }
      else {
         mTt=2;
         ulong ticket=HistoryDealGetTicket(int(tnOri)); if (ticket<=0) return false;
         long e=HistoryDealGetInteger(ticket,DEAL_ENTRY); if (e==DEAL_ENTRY_IN) return false; //持仓单   
      }
   }
   return true;
}
bool myOrderSelectO(ulong tnOri,int isTn,int isHis=0) {
   if (isTn==1) {
      Alert("~~~~~~~~Select Tn err2"); return false;
   }
   else {
      if (isHis==0) {
         mTt=0;
         ulong tn=OrderGetTicket(int(tnOri)); if (tn<=0) return false;
         if (mt4Type(OrderGetInteger(ORDER_TYPE))<=1) return false; //类型BUY或SELL，不处理，因为这两种类型不应该在order中出现
      }
      else {
         mTt=2;
         ulong ticket=HistoryDealGetTicket(int(tnOri)); if (ticket<=0) return false;
         long e=HistoryDealGetInteger(ticket,DEAL_ENTRY); if (e==DEAL_ENTRY_IN) return false; //持仓单   
      }
   }
   return true;
}

int mFill=-1;
long myOrderSend(string sy,int type0,double lots,double op,int slip,double sl,double tp,string cmm=NULL,long magic=0,datetime expp=0,color clr2=clrNONE) {
   ENUM_ORDER_TYPE type=0;
   if (type0==0) type=ORDER_TYPE_BUY;
   else if (type0==1) type=ORDER_TYPE_SELL;
   else if (type0==2) type=ORDER_TYPE_BUY_LIMIT;
   else if (type0==3) type=ORDER_TYPE_SELL_LIMIT;
   else if (type0==4) type=ORDER_TYPE_BUY_STOP;
   else if (type0==5) type=ORDER_TYPE_SELL_STOP;
   else if (type0==6) type=ORDER_TYPE_BUY_STOP_LIMIT;
   else if (type0==7) type=ORDER_TYPE_SELL_STOP_LIMIT;
   else if (type0==8) type=ORDER_TYPE_CLOSE_BY;
   MqlTradeRequest request={};
   MqlTradeResult  result={};
   if (type0<=1) request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
   else request.action=TRADE_ACTION_PENDING;
   request.symbol   =sy;                              // 交易品种
   request.volume   =lots;                                   // 0.1手交易量 
   request.type     =type;                        // 订单类型
   request.price    =op                                  ; // 持仓价格
   request.deviation=slip;                                     // 允许价格偏差
   request.magic    =magic;                          // 订单幻数
   request.comment=cmm;
   request.sl=sl;
   request.tp=tp;
   ENUM_ORDER_TYPE_FILLING fs[]={ORDER_FILLING_FOK,ORDER_FILLING_IOC,ORDER_FILLING_RETURN};
   bool b=false; int ttc=0; long tn=0;
   for (int z=0;z<6;++z) {
      if (mFill<0) mFill=fs[(ttc++)%3];
      request.type_filling=(ENUM_ORDER_TYPE_FILLING)mFill;
      b=OrderSend(request,result);
      if (result.retcode==TRADE_RETCODE_INVALID_FILL) { b=false; mFill=fs[(ttc++)%3]; Sleep(2000); continue; }
      else if (result.retcode==TRADE_RETCODE_CONNECTION) { Alert("~~~~~~建仓失败",sy,",ls=",lots,"~与经纪商的服务器无连接，建仓失败。"); return -1; } //与服务器无连接
      else if (result.retcode==TRADE_RETCODE_DONE) b=true;
      else b=false;
      if (b==false) {
         Print("~~~~~~建仓",sy,",ls=",lots,"~~~失败~~retcode=",result.retcode,"，~~~op0=",op,",bid2=",result.bid,",ask2=",result.ask);
         Sleep(2000);
         break;  //不重试，否则多次重试会被服务器一次建仓很多单。
      }
      else {
         Print("~~~~~~~~~~~~~~ok~~order open ",sy," #",result.order);
         tn=(long)result.order; break;
      }
   }
   
   if (tn>0 && type0<=1) { //必须等待buy和sell从order变为postion，否则后续的修改止损止盈或读取建仓价等操作将出错
      int i=0,wc=500; for (i=0;i<wc;++i) {
         if (PositionSelectByTicket(tn)) break;
         ulong ta=GetTickCount64();
         while (GetTickCount64()-ta<30) {
            if (PositionSelectByTicket(tn)) { ta=0; break; }
         }
         if (ta==0) break;
      }   
      if (i>=wc) { Alert("~~~~服务器太卡，订单建仓未成功c #",tn); return 0; }
   }
   
   return tn;
} 

bool myOrderClose(long tn,double ls,double price,int slipage,color=clrNONE) {
   ENUM_ORDER_TYPE_FILLING fs[]={ORDER_FILLING_FOK,ORDER_FILLING_IOC,ORDER_FILLING_RETURN};
   bool b=false; int ttc=0;
   for (int z=0;z<6;++z) {
         MqlTradeResult result={}; 
         MqlTradeRequest request={}; 
         if (mFill<0) mFill=fs[(ttc++)%3];
         request.type_filling=(ENUM_ORDER_TYPE_FILLING)mFill;
         request.action   =TRADE_ACTION_DEAL;        // 交易操作类型
         request.position =tn;
         request.symbol   =PositionGetString(POSITION_SYMBOL);
         request.volume   =ls;//PositionGetDouble(POSITION_VOLUME);
         request.deviation=1000;                        // 允许价格偏差
         request.magic    =PositionGetInteger(POSITION_MAGIC);
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)            {
            request.price=SymbolInfoDouble(PositionGetString(POSITION_SYMBOL),SYMBOL_BID);
            request.type =ORDER_TYPE_SELL;
           }
         else        {
            request.price=SymbolInfoDouble(PositionGetString(POSITION_SYMBOL),SYMBOL_ASK);
            request.type =ORDER_TYPE_BUY;
           }
         b=OrderSend(request,result);
         if (result.retcode==TRADE_RETCODE_INVALID_FILL) { b=false; mFill=fs[(ttc++)%3]; }
         else if (result.retcode==TRADE_RETCODE_DONE) b=true;
         else b=false;
         if(!b) {
            Sleep(2000);
            Print("~~~~~~平仓 #",tn,"~~~失败~~retcode=",result.retcode,"，再次尝试~~~",z);
         }
         else {
            Print("~~~~~~~~~~~~~~~~~~~ok~~close#",tn);
            break;
         }
   }            
   return b;
}

bool myOrderDelete(long tn,color=clrNONE) {
   ENUM_ORDER_TYPE_FILLING fs[]={ORDER_FILLING_FOK,ORDER_FILLING_IOC,ORDER_FILLING_RETURN};
   bool b=false; int ttc=0;
   for (int z=0;z<6;++z) {
      MqlTradeResult result={}; 
      MqlTradeRequest request={}; 
      if (mFill<0) mFill=fs[(ttc++)%3];
      request.type_filling=(ENUM_ORDER_TYPE_FILLING)mFill;
      request.order=tn; 
      request.action=TRADE_ACTION_REMOVE; 
      b=OrderSend(request,result); 
      if (result.retcode==TRADE_RETCODE_INVALID_FILL) { b=false; mFill=fs[(ttc++)%3]; }
      else if (result.retcode==TRADE_RETCODE_DONE) b=true;
      else b=false;
      if(!b) {
         Sleep(2000);
         Print("~~~~~~挂单删除 #",tn,"~~~失败~~retcode=",result.retcode,"，再次尝试~~~",z);
      }
      else {
         Print("~~~ok~~delete#",tn);
         break;
      }
   }            
   return b;
}

bool myOrderModify(long tn,double op,double sl,double tp,long expp,color clr2=clrNONE) {
   ENUM_ORDER_TYPE_FILLING fs[]={ORDER_FILLING_FOK,ORDER_FILLING_IOC,ORDER_FILLING_RETURN};
   bool b=false; int ttc=0;
   MqlTradeRequest request={};
   MqlTradeResult  result={};
   if (mTt==1) {
      for (int z=0;z<6;++z) {
         if (mFill<0) mFill=fs[(ttc++)%3];
         request.type_filling=(ENUM_ORDER_TYPE_FILLING)mFill;
         request.action=TRADE_ACTION_SLTP;                           // 交易操作类型
         request.position = tn;
         request.symbol   =PositionGetString(POSITION_SYMBOL);
         request.tp = tp;
         request.sl = sl;
         request.magic =PositionGetInteger(POSITION_MAGIC);
         b=OrderSend(request,result);
         if (result.retcode==TRADE_RETCODE_INVALID_FILL) { b=false; mFill=fs[(ttc++)%3]; }
         else if (result.retcode==TRADE_RETCODE_DONE) b=true;
         else b=false;
         if(!b) {
            Sleep(2000);
            Print("~~~~~~mod #",tn,"~~~失败~~retcode=",result.retcode,"，再次尝试~~~",z);
         }
         else {
            Print("~~~ok~~mod#",tn);
            break;
         }
      }
   }
   else if (mTt==0) {
      for (int z=0;z<6;++z) {
         if (mFill<0) mFill=fs[(ttc++)%3];
         request.type_filling=(ENUM_ORDER_TYPE_FILLING)mFill;
         request.action=TRADE_ACTION_MODIFY;                           // 交易操作类型
         request.order = tn;
         request.symbol   =OrderGetString(ORDER_SYMBOL);  
         request.tp = tp;
         request.sl = sl;
         request.price=op;
         request.magic =OrderGetInteger(ORDER_MAGIC);
         b=OrderSend(request,result);
         if (result.retcode==TRADE_RETCODE_INVALID_FILL) { b=false; mFill=fs[(ttc++)%3]; }
         else if (result.retcode==TRADE_RETCODE_DONE) b=true;
         else b=false;
         if(!b) {
            Sleep(2000);
            Print("~~~~~~mod #",tn,"~~~失败~~retcode=",result.retcode,"，再次尝试~~~",z);
         }
         else {
            Print("~~~ok~~mod#",tn);
            break;
         }
      } 
   }
   else Print("~~~~~~~~~~OrderModify err: history rec");
   return b;
}

long mSTn=0;
int mHisType=0;
double mHisSl=0;
double mHisTp=0;
double mHisSwap=0;
double mHisProfit=0;
double mHisCommission=0;
double mHisLots=0;
double mHisOrderOpenPrice=0;
double mHisOrderClosePrice=0;
long mHisMagic=0;
long mHisTicket=0;
long mHisExp=0;
datetime mHisOrderOpenTime=0;
datetime mHisOrderCloseTime=0;
string mHisSymbol="";
string mHisComment="";

void myObjectsDeleteAll(int subwin=-99,int type=-99) {
   if (subwin==-99) ObjectsDeleteAll(0);
   else ObjectsDeleteAll(0,subwin,type);
}

double iOpenMQL4(string symbol,int tf,int index) {   
   if(index < 0) return(-1);
   double Arr[];
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(CopyOpen(symbol,timeframe, index, 1, Arr)>0) return(Arr[0]);
   else return(-1);
}

double myMarketInfo(string sy,int type) {
   if (type==1) return SymbolInfoDouble(sy,SYMBOL_LASTLOW); //MODE_LOW 1
   if (type==2) return SymbolInfoDouble(sy,SYMBOL_LASTHIGH); //MODE_HIGH 2
   if (type==5) return (double)SymbolInfoInteger(sy,SYMBOL_TIME); //MODE_TIME 5
   if (type==9) return SymbolInfoDouble(sy,SYMBOL_BID); //MODE_BID 9
   if (type==10) return SymbolInfoDouble(sy,SYMBOL_ASK); //MODE_ASK 10
   if (type==11) return SymbolInfoDouble(sy,SYMBOL_POINT); //MODE_POINT 11
   if (type==12) return (double)SymbolInfoInteger(sy,SYMBOL_DIGITS); //MODE_DIGITS 12
   if (type==13) return (double)SymbolInfoInteger(sy,SYMBOL_SPREAD); //MODE_SPREAD 13
   if (type==14) return (double)SymbolInfoInteger(sy,SYMBOL_TRADE_STOPS_LEVEL); //MODE_STOPLEVEL 14
   if (type==15) return SymbolInfoDouble(sy,SYMBOL_TRADE_CONTRACT_SIZE); //MODE_LOTSIZE 15
   if (type==16) return SymbolInfoDouble(sy,SYMBOL_TRADE_TICK_VALUE); //MODE_TICKVALUE 16
   if (type==17) return SymbolInfoDouble(sy,SYMBOL_TRADE_TICK_SIZE); //MODE_TICKSIZE 17
   if (type==18) return SymbolInfoDouble(sy,SYMBOL_SWAP_LONG); //MODE_SWAPLONG 18
   if (type==19) return SymbolInfoDouble(sy,SYMBOL_SWAP_SHORT); //MODE_SWAPSHORT 19
   if (type==23) return SymbolInfoDouble(sy,SYMBOL_VOLUME_MIN); //MODE_MINLOT 23
   if (type==24) return SymbolInfoDouble(sy,SYMBOL_VOLUME_STEP); //MODE_LOTSTEP 24
   if (type==25) return SymbolInfoDouble(sy,SYMBOL_VOLUME_MAX); //MODE_MAXLOT 25
   if (type==26) return (double)SymbolInfoInteger(sy,SYMBOL_SWAP_MODE); //MODE_SWAPTYPE 26
   if (type==27) return (double)SymbolInfoInteger(sy,SYMBOL_TRADE_CALC_MODE); //MODE_PROFITCALC_MODE // 27
   if (type==29) return SymbolInfoDouble(sy,SYMBOL_MARGIN_INITIAL); //MODE_MARGININIT 29
   if (type==30) return SymbolInfoDouble(sy,SYMBOL_MARGIN_MAINTENANCE); //MODE_MARGINMAINTENANCE 30
   if (type==32) {
      double f1=0,f2=0; bool aa=0;
      aa=OrderCalcMargin(ORDER_TYPE_BUY,sy,1.0,SymbolInfoDouble(sy,SYMBOL_ASK),f1);
      aa=OrderCalcMargin(ORDER_TYPE_SELL,sy,1.0,SymbolInfoDouble(sy,SYMBOL_BID),f2);
      return (f1+f2)/2; //MODE_MARGINREQUIRED 32
   }
   if (type==33) return (double)SymbolInfoInteger(sy,SYMBOL_TRADE_FREEZE_LEVEL); //MODE_FREEZELEVEL 33
   Alert("~~~~~EA错误：markinfo不可识别ID:",type);
   return 0;
}

int myObjectsTotal(){
   return ObjectsTotal(0);
}
int myObjectsTotal(long a,int sub=-1){
   return ObjectsTotal(a,sub);
}

string myObjectName(int i) {
   return ObjectName(0,i);
}
string myObjectName(long a,int i,int sub=-1) {
   return ObjectName(a,i,sub);
}

bool myObjectDelete(string cap) {
   return ObjectDelete(0,cap);
}
bool myObjectDelete(long a,string cap) {
   return ObjectDelete(a,cap);
}

double iRSIMQL4(string symbol,
                int tf,
                int ped,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iRSI(symbol,timeframe,ped,applied_price);
   if(handle<0)
     {
      Print("此 iRSI 对象不能创建: 错误",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
long myTOrderMagicNumber() {
	if (mTt==0) return OrderGetInteger(ORDER_MAGIC);
   else if (mTt==1) return PositionGetInteger(POSITION_MAGIC);
   else if (mTt>=2) return mHisMagic;
   return 0;
}

string myTOrderSymbol() {
	if (mTt==0) return OrderGetString(ORDER_SYMBOL);
   else if (mTt==1) return PositionGetString(POSITION_SYMBOL);
   else if (mTt>=2) return mHisSymbol;
   return "";
}

long myTOrderTicket() {
	if (mTt==0) return OrderGetInteger(ORDER_TICKET);
   else if (mTt==1) return PositionGetInteger(POSITION_TICKET);
   else if (mTt>=2) return mHisTicket;
   return 0;
}

void myRefreshRates() { //无需做任何操作
}

