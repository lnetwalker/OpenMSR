{$H+}
unit markupv2;
{ Pascal Code Markup unit.

  Written by Trustmaster.
   http://www.psp.furtopia.org

  Modified by L505
   http://z505.com 

 May 2005: 
 ---------
  Took out the <br> to use <pre> tags in the header and </pre> tag in the 
  footer. 
  --Lars

 November 2005
 -------------
  Added the "finally" keyword
  --Lars    
 
}
interface

function  HTMLASC(str:string):string;
function  markup_code(swrd:string):string;
function  markup_space(sln:string):string;
function  markup_line(sln:string):string;
procedure markup_file(fname:string);
procedure markup_fileWrite(fname,newname:string);

implementation

uses 
  substrings;

function HTMLASC(str:string):string;
var
  i,len,cnt: integer;
  chr,asc,tmp: string;
  strtab: array[33..255] of string;
  chrtab: array[33..255] of string;
begin
{Chartable and Stringtable are generated by program, but we'll save CPU time}
  chrtab[33]:= '!';
  chrtab[34]:= '"';
  chrtab[35]:= '#';
  chrtab[36]:= '$';
  chrtab[37]:= '%';
  chrtab[38]:= '&';
  chrtab[39]:= '''';
  chrtab[40]:= '(';
  chrtab[41]:= ')';
  chrtab[42]:= '*';
  chrtab[43]:= '+';
  chrtab[44]:= ',';
  chrtab[45]:= '-';
  chrtab[46]:= '.';
  chrtab[47]:= '/';
  chrtab[48]:= '0';
  chrtab[49]:= '1';
  chrtab[50]:= '2';
  chrtab[51]:= '3';
  chrtab[52]:= '4';
  chrtab[53]:= '5';
  chrtab[54]:= '6';
  chrtab[55]:= '7';
  chrtab[56]:= '8';
  chrtab[57]:= '9';
  chrtab[58]:= ':';
  chrtab[59]:= ';';
  chrtab[60]:= '<';
  chrtab[61]:= '=';
  chrtab[62]:= '>';
  chrtab[63]:= '?';
  chrtab[64]:= '@';
  chrtab[65]:= 'A';
  chrtab[66]:= 'B';
  chrtab[67]:= 'C';
  chrtab[68]:= 'D';
  chrtab[69]:= 'E';
  chrtab[70]:= 'F';
  chrtab[71]:= 'G';
  chrtab[72]:= 'H';
  chrtab[73]:= 'I';
  chrtab[74]:= 'J';
  chrtab[75]:= 'K';
  chrtab[76]:= 'L';
  chrtab[77]:= 'M';
  chrtab[78]:= 'N';
  chrtab[79]:= 'O';
  chrtab[80]:= 'P';
  chrtab[81]:= 'Q';
  chrtab[82]:= 'R';
  chrtab[83]:= 'S';
  chrtab[84]:= 'T';
  chrtab[85]:= 'U';
  chrtab[86]:= 'V';
  chrtab[87]:= 'W';
  chrtab[88]:= 'X';
  chrtab[89]:= 'Y';
  chrtab[90]:= 'Z';
  chrtab[91]:= '[';
  chrtab[92]:= '\';
  chrtab[93]:= ']';
  chrtab[94]:= '^';
  chrtab[95]:= '_';
  chrtab[96]:= '`';
  chrtab[97]:= 'a';
  chrtab[98]:= 'b';
  chrtab[99]:= 'c';
  chrtab[100]:= 'd';
  chrtab[101]:= 'e';
  chrtab[102]:= 'f';
  chrtab[103]:= 'g';
  chrtab[104]:= 'h';
  chrtab[105]:= 'i';
  chrtab[106]:= 'j';
  chrtab[107]:= 'k';
  chrtab[108]:= 'l';
  chrtab[109]:= 'm';
  chrtab[110]:= 'n';
  chrtab[111]:= 'o';
  chrtab[112]:= 'p';
  chrtab[113]:= 'q';
  chrtab[114]:= 'r';
  chrtab[115]:= 's';
  chrtab[116]:= 't';
  chrtab[117]:= 'u';
  chrtab[118]:= 'v';
  chrtab[119]:= 'w';
  chrtab[120]:= 'x';
  chrtab[121]:= 'y';
  chrtab[122]:= 'z';
  chrtab[123]:= '{';
  chrtab[124]:= '|';
  chrtab[125]:= '}';
  chrtab[126]:= '~';
  chrtab[127]:= '';
  chrtab[128]:= '�';
  chrtab[129]:= '�';
  chrtab[130]:= '�';
  chrtab[131]:= '�';
  chrtab[132]:= '�';
  chrtab[133]:= '�';
  chrtab[134]:= '�';
  chrtab[135]:= '�';
  chrtab[136]:= '�';
  chrtab[137]:= '�';
  chrtab[138]:= '�';
  chrtab[139]:= '�';
  chrtab[140]:= '�';
  chrtab[141]:= '�';
  chrtab[142]:= '�';
  chrtab[143]:= '�';
  chrtab[144]:= '�';
  chrtab[145]:= '�';
  chrtab[146]:= '�';
  chrtab[147]:= '�';
  chrtab[148]:= '�';
  chrtab[149]:= '�';
  chrtab[150]:= '�';
  chrtab[151]:= '�';
  chrtab[152]:= '�';
  chrtab[153]:= '�';
  chrtab[154]:= '�';
  chrtab[155]:= '�';
  chrtab[156]:= '�';
  chrtab[157]:= '�';
  chrtab[158]:= '�';
  chrtab[159]:= '�';
  chrtab[160]:= '�';
  chrtab[161]:= '�';
  chrtab[162]:= '�';
  chrtab[163]:= '�';
  chrtab[164]:= '�';
  chrtab[165]:= '�';
  chrtab[166]:= '�';
  chrtab[167]:= '�';
  chrtab[168]:= '�';
  chrtab[169]:= '�';
  chrtab[170]:= '�';
  chrtab[171]:= '�';
  chrtab[172]:= '�';
  chrtab[173]:= '�';
  chrtab[174]:= '�';
  chrtab[175]:= '�';
  chrtab[176]:= '�';
  chrtab[177]:= '�';
  chrtab[178]:= '�';
  chrtab[179]:= '�';
  chrtab[180]:= '�';
  chrtab[181]:= '�';
  chrtab[182]:= '�';
  chrtab[183]:= '�';
  chrtab[184]:= '�';
  chrtab[185]:= '�';
  chrtab[186]:= '�';
  chrtab[187]:= '�';
  chrtab[188]:= '�';
  chrtab[189]:= '�';
  chrtab[190]:= '�';
  chrtab[191]:= '�';
  chrtab[192]:= '�';
  chrtab[193]:= '�';
  chrtab[194]:= '�';
  chrtab[195]:= '�';
  chrtab[196]:= '�';
  chrtab[197]:= '�';
  chrtab[198]:= '�';
  chrtab[199]:= '�';
  chrtab[200]:= '�';
  chrtab[201]:= '�';
  chrtab[202]:= '�';
  chrtab[203]:= '�';
  chrtab[204]:= '�';
  chrtab[205]:= '�';
  chrtab[206]:= '�';
  chrtab[207]:= '�';
  chrtab[208]:= '�';
  chrtab[209]:= '�';
  chrtab[210]:= '�';
  chrtab[211]:= '�';
  chrtab[212]:= '�';
  chrtab[213]:= '�';
  chrtab[214]:= '�';
  chrtab[215]:= '�';
  chrtab[216]:= '�';
  chrtab[217]:= '�';
  chrtab[218]:= '�';
  chrtab[219]:= '�';
  chrtab[220]:= '�';
  chrtab[221]:= '�';
  chrtab[222]:= '�';
  chrtab[223]:= '�';
  chrtab[224]:= '�';
  chrtab[225]:= '�';
  chrtab[226]:= '�';
  chrtab[227]:= '�';
  chrtab[228]:= '�';
  chrtab[229]:= '�';
  chrtab[230]:= '�';
  chrtab[231]:= '�';
  chrtab[232]:= '�';
  chrtab[233]:= '�';
  chrtab[234]:= '�';
  chrtab[235]:= '�';
  chrtab[236]:= '�';
  chrtab[237]:= '�';
  chrtab[238]:= '�';
  chrtab[239]:= '�';
  chrtab[240]:= '�';
  chrtab[241]:= '�';
  chrtab[242]:= '�';
  chrtab[243]:= '�';
  chrtab[244]:= '�';
  chrtab[245]:= '�';
  chrtab[246]:= '�';
  chrtab[247]:= '�';
  chrtab[248]:= '�';
  chrtab[249]:= '�';
  chrtab[250]:= '�';
  chrtab[251]:= '�';
  chrtab[252]:= '�';
  chrtab[253]:= '�';
  chrtab[254]:= '�';
  chrtab[255]:= '�';
  strtab[33]:= '&#0033;';
  strtab[34]:= '&#0034;';
  strtab[35]:= '&#0035;';
  strtab[36]:= '&#0036;';
  strtab[37]:= '&#0037;';
  strtab[38]:= '&#0038;';
  strtab[39]:= '&#0039;';
  strtab[40]:= '&#0040;';
  strtab[41]:= '&#0041;';
  strtab[42]:= '&#0042;';
  strtab[43]:= '&#0043;';
  strtab[44]:= '&#0044;';
  strtab[45]:= '&#0045;';
  strtab[46]:= '&#0046;';
  strtab[47]:= '&#0047;';
  strtab[48]:= '&#0048;';
  strtab[49]:= '&#0049;';
  strtab[50]:= '&#0050;';
  strtab[51]:= '&#0051;';
  strtab[52]:= '&#0052;';
  strtab[53]:= '&#0053;';
  strtab[54]:= '&#0054;';
  strtab[55]:= '&#0055;';
  strtab[56]:= '&#0056;';
  strtab[57]:= '&#0057;';
  strtab[58]:= '&#0058;';
  strtab[59]:= '&#0059;';
  strtab[60]:= '&#0060;';
  strtab[61]:= '&#0061;';
  strtab[62]:= '&#0062;';
  strtab[63]:= '&#0063;';
  strtab[64]:= '&#0064;';
  strtab[65]:= '&#0065;';
  strtab[66]:= '&#0066;';
  strtab[67]:= '&#0067;';
  strtab[68]:= '&#0068;';
  strtab[69]:= '&#0069;';
  strtab[70]:= '&#0070;';
  strtab[71]:= '&#0071;';
  strtab[72]:= '&#0072;';
  strtab[73]:= '&#0073;';
  strtab[74]:= '&#0074;';
  strtab[75]:= '&#0075;';
  strtab[76]:= '&#0076;';
  strtab[77]:= '&#0077;';
  strtab[78]:= '&#0078;';
  strtab[79]:= '&#0079;';
  strtab[80]:= '&#0080;';
  strtab[81]:= '&#0081;';
  strtab[82]:= '&#0082;';
  strtab[83]:= '&#0083;';
  strtab[84]:= '&#0084;';
  strtab[85]:= '&#0085;';
  strtab[86]:= '&#0086;';
  strtab[87]:= '&#0087;';
  strtab[88]:= '&#0088;';
  strtab[89]:= '&#0089;';
  strtab[90]:= '&#0090;';
  strtab[91]:= '&#0091;';
  strtab[92]:= '&#0092;';
  strtab[93]:= '&#0093;';
  strtab[94]:= '&#0094;';
  strtab[95]:= '&#0095;';
  strtab[96]:= '&#0096;';
  strtab[97]:= '&#0097;';
  strtab[98]:= '&#0098;';
  strtab[99]:= '&#0099;';
  strtab[100]:= '&#0100;';
  strtab[101]:= '&#0101;';
  strtab[102]:= '&#0102;';
  strtab[103]:= '&#0103;';
  strtab[104]:= '&#0104;';
  strtab[105]:= '&#0105;';
  strtab[106]:= '&#0106;';
  strtab[107]:= '&#0107;';
  strtab[108]:= '&#0108;';
  strtab[109]:= '&#0109;';
  strtab[110]:= '&#0110;';
  strtab[111]:= '&#0111;';
  strtab[112]:= '&#0112;';
  strtab[113]:= '&#0113;';
  strtab[114]:= '&#0114;';
  strtab[115]:= '&#0115;';
  strtab[116]:= '&#0116;';
  strtab[117]:= '&#0117;';
  strtab[118]:= '&#0118;';
  strtab[119]:= '&#0119;';
  strtab[120]:= '&#0120;';
  strtab[121]:= '&#0121;';
  strtab[122]:= '&#0122;';
  strtab[123]:= '&#0123;';
  strtab[124]:= '&#0124;';
  strtab[125]:= '&#0125;';
  strtab[126]:= '&#0126;';
  strtab[127]:= '&#0127;';
  strtab[128]:= '&#0128;';
  strtab[129]:= '&#0129;';
  strtab[130]:= '&#0130;';
  strtab[131]:= '&#0131;';
  strtab[132]:= '&#0132;';
  strtab[133]:= '&#0133;';
  strtab[134]:= '&#0134;';
  strtab[135]:= '&#0135;';
  strtab[136]:= '&#0136;';
  strtab[137]:= '&#0137;';
  strtab[138]:= '&#0138;';
  strtab[139]:= '&#0139;';
  strtab[140]:= '&#0140;';
  strtab[141]:= '&#0141;';
  strtab[142]:= '&#0142;';
  strtab[143]:= '&#0143;';
  strtab[144]:= '&#0144;';
  strtab[145]:= '&#0145;';
  strtab[146]:= '&#0146;';
  strtab[147]:= '&#0147;';
  strtab[148]:= '&#0148;';
  strtab[149]:= '&#0149;';
  strtab[150]:= '&#0150;';
  strtab[151]:= '&#0151;';
  strtab[152]:= '&#0152;';
  strtab[153]:= '&#0153;';
  strtab[154]:= '&#0154;';
  strtab[155]:= '&#0155;';
  strtab[156]:= '&#0156;';
  strtab[157]:= '&#0157;';
  strtab[158]:= '&#0158;';
  strtab[159]:= '&#0159;';
  strtab[160]:= '&#0160;';
  strtab[161]:= '&#0161;';
  strtab[162]:= '&#0162;';
  strtab[163]:= '&#0163;';
  strtab[164]:= '&#0164;';
  strtab[165]:= '&#0165;';
  strtab[166]:= '&#0166;';
  strtab[167]:= '&#0167;';
  strtab[168]:= '&#0168;';
  strtab[169]:= '&#0169;';
  strtab[170]:= '&#0170;';
  strtab[171]:= '&#0171;';
  strtab[172]:= '&#0172;';
  strtab[173]:= '&#0173;';
  strtab[174]:= '&#0174;';
  strtab[175]:= '&#0175;';
  strtab[176]:= '&#0176;';
  strtab[177]:= '&#0177;';
  strtab[178]:= '&#0178;';
  strtab[179]:= '&#0179;';
  strtab[180]:= '&#0180;';
  strtab[181]:= '&#0181;';
  strtab[182]:= '&#0182;';
  strtab[183]:= '&#0183;';
  strtab[184]:= '&#0184;';
  strtab[185]:= '&#0185;';
  strtab[186]:= '&#0186;';
  strtab[187]:= '&#0187;';
  strtab[188]:= '&#0188;';
  strtab[189]:= '&#0189;';
  strtab[190]:= '&#0190;';
  strtab[191]:= '&#0191;';
  strtab[192]:= '&#0192;';
  strtab[193]:= '&#0193;';
  strtab[194]:= '&#0194;';
  strtab[195]:= '&#0195;';
  strtab[196]:= '&#0196;';
  strtab[197]:= '&#0197;';
  strtab[198]:= '&#0198;';
  strtab[199]:= '&#0199;';
  strtab[200]:= '&#0200;';
  strtab[201]:= '&#0201;';
  strtab[202]:= '&#0202;';
  strtab[203]:= '&#0203;';
  strtab[204]:= '&#0204;';
  strtab[205]:= '&#0205;';
  strtab[206]:= '&#0206;';
  strtab[207]:= '&#0207;';
  strtab[208]:= '&#0208;';
  strtab[209]:= '&#0209;';
  strtab[210]:= '&#0210;';
  strtab[211]:= '&#0211;';
  strtab[212]:= '&#0212;';
  strtab[213]:= '&#0213;';
  strtab[214]:= '&#0214;';
  strtab[215]:= '&#0215;';
  strtab[216]:= '&#0216;';
  strtab[217]:= '&#0217;';
  strtab[218]:= '&#0218;';
  strtab[219]:= '&#0219;';
  strtab[220]:= '&#0220;';
  strtab[221]:= '&#0221;';
  strtab[222]:= '&#0222;';
  strtab[223]:= '&#0223;';
  strtab[224]:= '&#0224;';
  strtab[225]:= '&#0225;';
  strtab[226]:= '&#0226;';
  strtab[227]:= '&#0227;';
  strtab[228]:= '&#0228;';
  strtab[229]:= '&#0229;';
  strtab[230]:= '&#0230;';
  strtab[231]:= '&#0231;';
  strtab[232]:= '&#0232;';
  strtab[233]:= '&#0233;';
  strtab[234]:= '&#0234;';
  strtab[235]:= '&#0235;';
  strtab[236]:= '&#0236;';
  strtab[237]:= '&#0237;';
  strtab[238]:= '&#0238;';
  strtab[239]:= '&#0239;';
  strtab[240]:= '&#0240;';
  strtab[241]:= '&#0241;';
  strtab[242]:= '&#0242;';
  strtab[243]:= '&#0243;';
  strtab[244]:= '&#0244;';
  strtab[245]:= '&#0245;';
  strtab[246]:= '&#0246;';
  strtab[247]:= '&#0247;';
  strtab[248]:= '&#0248;';
  strtab[249]:= '&#0249;';
  strtab[250]:= '&#0250;';
  strtab[251]:= '&#0251;';
  strtab[252]:= '&#0252;';
  strtab[253]:= '&#0253;';
  strtab[254]:= '&#0254;';
  strtab[255]:= '&#0255;';
  len:= length(str);
  for cnt:= 1 to len do
   begin
    asc:= ' ';
    chr:= copy(str,cnt,1);
     for i:= 33 to 255 do if chrtab[i] = chr then asc:= strtab[i];
     tmp:= tmp+asc;
   end;
  HTMLASC:= tmp;
end;

function markup_code(swrd:string):string;
var
  tmp: string;
begin
  tmp:= swrd;
  if swrd = HTMLASC('and') then
    tmp:= '<span class="opr">' + HTMLASC('and') + '</span>';
  if swrd = HTMLASC('or') then 
    tmp:= '<span class="opr">' + HTMLASC('or') + '</span>';
  if swrd = HTMLASC('not') then 
    tmp:='<span class="opr">' + HTMLASC('not') + '</span>';
  if swrd = HTMLASC('xor') then
    tmp:='<span class="opr">' + HTMLASC('xor') + '</span>';
  if swrd = HTMLASC('div') then
    tmp:='<span class="opr">' + HTMLASC('div') + '</span>';
  if swrd = HTMLASC('mod') then
    tmp:='<span class="opr">' + HTMLASC('mod') + '</span>';
  if swrd = HTMLASC('shl') then
    tmp:='<span class="opr">'+HTMLASC('shl') + '</span>';
  if swrd = HTMLASC('shr') then
    tmp:='<span class="opr">' + HTMLASC('shr') + '</span>';
  if swrd = HTMLASC('begin') then
    tmp:='<span class="rsv">' + HTMLASC('begin') + '</span>';   //L505: updated
  if swrd = HTMLASC('end') then
    tmp:='<span class="rsv">' + HTMLASC('end') + '</span>';     //L505: updated
  if swrd = HTMLASC('end;') then
    tmp:='<span class="rsv">' + HTMLASC('end;') + '</span>';    //L505: updated
  if swrd = HTMLASC('end.') then
    tmp:='<span class="rsv">' + HTMLASC('end.') + '</span>';    //L505: updated
  if swrd = HTMLASC('integer') then
    tmp:='<span class="typ">' + HTMLASC('integer') + '</span>';
  if swrd = HTMLASC('char') then
    tmp:='<span class="typ">' + HTMLASC('char') + '</span>';
  if swrd = HTMLASC('boolean') then
    tmp:='<span class="typ">' + HTMLASC('boolean') + '</span>';
  if swrd = HTMLASC('string') then
    tmp:='<span class="typ">' + HTMLASC('string') + '</span>';
  if swrd = HTMLASC('pchar') then
    tmp:='<span class="typ">' + HTMLASC('pchar') + '</span>';
  if swrd = HTMLASC('longint') then
    tmp:='<span class="typ">' + HTMLASC('longint') + '</span>';
  if swrd = HTMLASC('word') then
    tmp:='<span class="typ">' + HTMLASC('word') + '</span>';
  if swrd = HTMLASC('byte') then
    tmp:='<span class="typ">' + HTMLASC('byte') + '</span>';
  if swrd = HTMLASC('array') then
    tmp:='<span class="typ">' + HTMLASC('file') + '</span>';
  if swrd = HTMLASC('text') then 
    tmp:='<span class="typ">' + HTMLASC('text') + '</span>';
  if swrd = HTMLASC('of') then
    tmp:='<span class="typ">' + HTMLASC('of') + '</span>';
  if swrd = HTMLASC('record') then
    tmp:='<span class="typ">' + HTMLASC('record') + '</span>';
  if swrd = HTMLASC('set') then
    tmp:='<span class="typ">' + HTMLASC('set') + '</span>';
  if swrd = HTMLASC('real') then
    tmp:='<span class="typ">' + HTMLASC('real') + '</span>';
  if swrd = HTMLASC('program') then
    tmp:='<span class="rsv">' + HTMLASC('program') + '</span>';
  if swrd = HTMLASC('unit') then
    tmp:='<span class="rsv">' + HTMLASC('unit') + '</span>';
  if swrd = HTMLASC('library') then
    tmp:='<span class="rsv">' + HTMLASC('library') + '</span>';
  if swrd = HTMLASC('uses') then
    tmp:='<span class="rsv">' + HTMLASC('uses') + '</span>';
  if swrd = HTMLASC('var') then
    tmp:='<span class="rsv">' + HTMLASC('var') + '</span>';
  if swrd = HTMLASC('const') then
    tmp:='<span class="rsv">' + HTMLASC('const') + '</span>';
  if swrd = HTMLASC('interface') then
    tmp:='<span class="rsv">' + HTMLASC('interface') + '</span>';
  if swrd = HTMLASC('implementation') then
    tmp:='<span class="rsv">' + HTMLASC('implementation') + '</span>';
  if swrd = HTMLASC('exports') then
    tmp:='<span class="rsv">' + HTMLASC('exports') + '</span>';
  if swrd = HTMLASC('external') then
    tmp:='<span class="rsv">' + HTMLASC('external') + '</span>';
  if swrd = HTMLASC('function') then
    tmp:='<span class="rsv">' + HTMLASC('function') + '</span>';
  if swrd = HTMLASC('procedure') then
    tmp:='<span class="rsv">' + HTMLASC('procedure') + '</span>';
  if swrd = HTMLASC('label') then
    tmp:='<span class="rsv">' + HTMLASC('label') + '</span>';
  if swrd = HTMLASC('goto') then
    tmp:='<span class="rsv">' + HTMLASC('goto') + '</span>';
  if swrd = HTMLASC('case') then
    tmp:='<span class="rsv">' + HTMLASC('case') + '</span>';
  if swrd = HTMLASC('if') then
    tmp:='<span class="rsv">' + HTMLASC('if') + '</span>';
  if swrd = HTMLASC('then') then
    tmp:='<span class="rsv">' + HTMLASC('then') + '</span>';
  if swrd = HTMLASC('else') then
    tmp:='<span class="rsv">' + HTMLASC('else') + '</span>';
  if swrd = HTMLASC('for') then
    tmp:='<span class="rsv">' + HTMLASC('for') + '</span>';
  if swrd = HTMLASC('to') then
    tmp:='<span class="rsv">' + HTMLASC('to') + '</span>';
  if swrd = HTMLASC('downto') then
    tmp:='<span class="rsv">' + HTMLASC('downto') + '</span>';
  if swrd = HTMLASC('do') then
    tmp:='<span class="rsv">' + HTMLASC('do') + '</span>';
  if swrd = HTMLASC('repeat') then
    tmp:='<span class="rsv">' + HTMLASC('repeat') + '</span>';
  if swrd = HTMLASC('until') then
    tmp:='<span class="rsv">' + HTMLASC('until') + '</span>';
  if swrd = HTMLASC('while') then
    tmp:='<span class="rsv">' + HTMLASC('while') + '</span>';
  if swrd = HTMLASC('with') then
    tmp:='<span class="rsv">' + HTMLASC('with') + '</span>';
  if swrd = HTMLASC('asm') then
    tmp:='<span class="rsv">' + HTMLASC('asm') + '</span>';
  if swrd = HTMLASC('try') then
    tmp:='<span class="rsv">' + HTMLASC('try') + '</span>';
  if swrd = HTMLASC('except') then
    tmp:='<span class="rsv">' + HTMLASC('except') + '</span>';
  if swrd = HTMLASC('finally') then
    tmp:='<span class="rsv">' + HTMLASC('finally') + '</span>';   //L505: updated
  if swrd = HTMLASC('class') then
    tmp:='<span class="rsv">' + HTMLASC('class') + '</span>';

  tmp:= SubstrReplace(tmp,
                      HTMLASC('='),
                     '<span class="opr">' + HTMLASC('=') + '</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('/'),
                      '<span class="opr">'+HTMLASC('/') + '</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('<'),
                      '<span class="opr">' + HTMLASC('<') + '</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('>'),
                      '<span class="opr">' + HTMLASC('>') + '</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(';'),
                      '<span class="opr">' + HTMLASC(';') + '</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('{'),
                      '<span class="cmt"><i>' + HTMLASC('{') + '');     //L505: updated
  tmp:= SubstrReplace(tmp,
                      HTMLASC('}'),
                      ''+HTMLASC('}') + '</i></span>');               //L505: updated
  tmp:= SubstrReplace(tmp,
                      HTMLASC('$'),
                      '<span class="crd">' + HTMLASC('$')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(','),
                      '<span class="opr">' + HTMLASC(',')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(':'),
                      '<span class="opr">' + HTMLASC(':')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('*'),
                      '<span class="opr">' + HTMLASC('*')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('+'),
                      '<span class="opr">' + HTMLASC('+')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('-'),
                      '<span class="opr">' + HTMLASC('-')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('^'),
                      '<span class="opr">' + HTMLASC('^')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('@'),
                      '<span class="opr">' + HTMLASC('@')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('('),
                      '<span class="opr">' + HTMLASC('(')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(')'),
                      '<span class="opr">' + HTMLASC(')')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('['),
                      '<span class="opr">' + HTMLASC('[')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(']'),
                      '<span class="opr">' + HTMLASC(']')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC(''''),
                      '<span class="opr">' + HTMLASC('''')+'</span>');
  tmp:= SubstrReplace(tmp,
                      HTMLASC('.'),
                      '<span class="opr">' + HTMLASC('.')+'</span>');
  markup_code:= tmp;
end;

function markup_space(sln:string):string;
var
 chr,tmp: string;
begin
  tmp:= sln;
  chr:= copy(tmp,1,1);
  if chr=' ' then
  begin
    delete(tmp,1,1);
    insert('&nbsp;',tmp,1);
  end;
  if SubstrExists(sln,
                 '<span class="opr">' + HTMLASC('/') + '</span>' + '<span class="opr">'+HTMLASC('/')+'</span>') 
     then
  begin
     tmp:= SubstrReplace(tmp,
                        '<span class="opr">'+HTMLASC('/')+'</span>'+'<span class="opr">'+HTMLASC('/')+'</span>',
                        '<span class="cmt"><i>'+HTMLASC('//')); //L505: updated
     tmp:= tmp + '</i></span>'; //L505: updated
  end;
  markup_space:= tmp;
end;

function markup_line(sln:string):string;
var
 tmp,wrd,chr:string;
 cnt,posn,len:integer;
begin
  len:= length(sln);
  cnt:= 1;
  while cnt <= len do
  begin
    chr:= copy(sln,cnt,1);
     inc(cnt);
     if chr<>' ' then
     begin
       wrd:= chr;
        repeat
         if cnt>len then break;
         chr:= copy(sln,cnt,1);
         inc(cnt);
         if chr<>' ' then
           wrd:= wrd + chr
         else 
           break;
        until (chr = ' ') or (cnt > len);
        wrd:= markup_code(wrd);
        tmp:= tmp+wrd;
        if chr = ' ' then
          tmp:= tmp + chr;
     end else
     begin
       tmp:= tmp + chr;
     end;
  end;
  tmp:= markup_space(tmp);
  tmp:= tmp + ''; //L505: I took <br> out, in order to use <pre> tag in header/footer file.
  markup_line:= tmp;
end;

procedure markup_file(fname:string);
var
 fh  : text;
 buff: string;
begin
  assign(fh,fname);
  reset(fh);
  while not eof(fh) do
  begin
    readln(fh,buff);
    buff:= HTMLASC(buff);
    buff:= markup_line(buff);
    writeln(buff);
  end;
  close(fh);
end;

procedure markup_fileWrite(fname,newname:string);
var
  fh,fh2: text;
  buff  : string;
begin
  assign(fh,fname);
  assign(fh2,newname);
  reset(fh);
  append(fh2);
  while not eof(fh) do
  begin
    readln(fh,buff);
    buff:= HTMLASC(buff);
    buff:= markup_line(buff);
    writeln(fh2,buff);
  end;
  close(fh);
  close(fh2);
end;

end.

  




