Qgtk2.pas - rychl� programov�n� v Pascalu s knihovnami gtk2
-----------------------------------------------------------


Freepascal 2.0 umo��uje vyu��vat gtk2 knihovny pro X-windows, 
nebo i pro M$ windows.     
Pou�it� gtk2 knihoven je v�ak trochu komplikovan� a trv� asi
v�t�inou mnoho t�dn�, ne� se to n�kdo nau��. 
Programov� jednotka qgtk2.pas toto velmi zjednodu�uje a urychluje,
neumo��uje sice pln� vyu��t v�ech mo�nost� gtk2, ale p�esto pro
mnoho jednodu���ch program� bude bohat� sta�it. 

Qgtk2.pas vzniklo upravou qgtk.pas, ktere poziva gtk1.
Ve verzi 0.9 je jeste mnoho v gtk2 obsolentnich a deprecated funkci, 
ale funguje to.



Nutno mit nainstalovany Freepascal 2.0 (a vyssi)
 http://www.freepascal.org/

Pro M$ Windows jsou nutne gtk2 dll knihovny
Mozno stahnout z http://members.lycos.co.uk/alexv6/



Zmeny v qgtk2 oproti qgtk:

nepouziva se qgdkfont, font urcuje primo qfontname

Promene qfontname a podobne qfontname0 jsou ve tvaru "Sans Bold 12" (pouziva se pango)
(a ne jak to bylo v qgtk ve tvaru "-*-helvetica-medium-r-*-*-*-120-*-*-p-*-iso8859-2")



License: GNU GENERAL PUBLIC LICENSE                                                             
                                                                                                
(c) 2005 Jirka Bubenicek  - hebrak@yahoo.com
