program Prova;
uses crt;
type quindici=-1..15;
     sette=0..7;
     recordTesto=record
                 color:quindici;
                 ground:sette;
                 s:string;
                 x:integer;
                 y:integer;
                 end;
     scherm=record
             color:quindici;
             ground:sette;
             text:char;
             end;
     schermOgg=record
               x:integer;
               y:integer;
               color:quindici;
               ground:sette;
               text:char;
               end;
     ottanta=1..120;
     oggetto=array[1..10000,1..2]of ottanta;
     tabella=array[0..81,0..120]of boolean;
     schermo=array[1..80,1..120]of scherm;
     schermoOgg=array[1..27,1..10000]of schermOgg;
     parol=array[1..300]of string;
     lparol=array[1..300]of integer;
     tabInteger=array[0..81,0..120]of integer;
     filechar=file of char;
     PTCType=record
     pc:array[1..80]of string;
     s:array[1..500]of string;
     end;
     PTCArray=array[1..101]of PTCType;

label caso1,caso2,caso3,caso4,caso5,casoInputTools,caso1r,casoFeature,caso6,casoInizio,casoCorrotto,CasoProgetto,caso12,casoTools;


const cursori:array[1..4]of quindici = (11,10,15,13);
      nomiColori:array[0..15]of string = ('Black','Blue','Green','Cyan','Red','Magenta','Brown','L. grey','D. grey','L. blue','L. green','L. cyan','L. red','L. magenta','Yellow','White');
      strumenti:array[0..12]of string = ('NONE','PENCIL','ERASER','RULE','COPY/MOVE','BUCKET','SEGMENT','GRID','CHESSBOARD','TEXT','RECTANGLE','TITLE','CIRCLE');
      sfumato:array[0..6]of string = ('00070815','01030911','0210','0412','0513','0614','160102030405060708091112131415');
      CampioniFeature:array[1..6]of string = (' NONE ',' SHADE ',' GRADATION ',' SPOTS ',' STRIPED 1 ',' STRIPED 2 ');
      sTastiera:string = 'qwertyuiopasdfghjklzxcvbnm';
      smTastiera:string = 'QWERTYUIOPASDFGHJKLZXCVBNM';
      chrGomma:char = chr(176);
      chrSfumato:string = chr(176)+chr(177)+chr(178)+chr(219);
      stringaCaratteri:string =chr(176)+chr(177)+chr(178)+chr(219)+chr(220)+chr(223)+chr(254)+chr(95)+chr(238)+chr(196)+chr(197)+chr(180)+chr(191)+chr(192)+chr(193)+chr(194)+chr(195)+chr(217)+chr(218)+chr(179)+chr(221)+chr(185)+chr(186)+chr(187)+chr(188)+chr(200)+chr(201)+chr(202)+chr(203)+chr(204)+chr(205)+chr(206)+chr(0);


var sss:string;

    pulisciBKP:boolean;

    SfondoInvisibile:boolean;                          // variabile che indica se lo sfondo deve essere visibile o meno

    CreaModifica:integer;

    file1,fileinput:filechar;

    Caricamento:oggetto;
    mCaricamento:integer;

    nomefile:string;

    Nptc,PTCBackground:integer;

    PAINTCODE:PTCArray;

    IsTrasparent:boolean;

    m,mCerchioCamp,mCirconfCamp,i,j:integer;           // variabili generali

    x,y,x2,y2:integer;                                 // variabili globali utilizzo per cursori

    ymaxcln:integer;                                   // altezza raggiungibile dal pulisci

    k:real;                                            // coefficiente elisse

    r:integer;                                         // raggio cerchio

    lato:integer;                                      // metà del lato della gomma diminuita di uno

    strumento:integer;                                 // indica quale strumento è in utilizzo

    ymax:integer;                                      // indica l' altezza massima occupata dalle figure

    s,text,text1,text2:char;                           // s usata come variabile per le acquisizioni da tastiera ; caratteri utilizzati per identificare gli items

    OGG,circonfCampione,cerchioCampione:oggetto;

    TABI:tabInteger;

    schermata,schermBkp,caccaBKP:schermo;              // indica tutte le specifiche della schermata, RECORD

    sfondo,ground,ground1,ground2:sette;               // sfondi

    color,color1,color2:quindici;                      // colori

    car:array[1..3,1..11]of char;                      // array contenente tutti i caratteri utilizzabili dall' utente

    gostTab,EMPTY,TArea:tabella;                       // tabelle di funzione

    Hide,HideDime:boolean;                             // variabile che indica se l' utente ha nascosto la barra strumenti

    chr220,chr223,chr0,spazio:string;                  // stringhe contenenti 80 caratteri dello stesso tipo, funzione: VELOCITA'

    title:boolean;                                     // boolean, servono per verificare se, in un preciso istante, l' utente sta utilizzando quel strumento

    EstremoRetta:boolean;                              // verifica se le coordinate di RETTA e SCHACCHIERA sono state invertite

    StrumentoSecondario:boolean;                       // TRUE quando il programma sta eseguendo la parte secondaria di uno strumento

    dx1,dy1,dx2,dy2,px1,py1,px2,py2:integer;           // globali che servono a definire i rettangoli in movimento

    corniceTab,Pcornice:tabella;                       // indica la tabella del rettangolo in movimento

    CH:array[1..3,1..7]of char;                        // contiene i vari caratteri dei fount del rettangolo
    nRettang:word;                                     // indica il tipo di fount corrente

    CHGrid:array[1..2,1..11]of char;                   // contiene i vari caratteri dei fount della griglia
    nGrid:word;                                        // indica il tipo di fount corrente

    OGGGrid:array[1..10000]of char;                    // contiene i caratteri della griglia ordinati secondo la successione di incrementi dei pixel

    TABGrid:array[1..80,1..120]of integer;             // contiene gli indici di ogni carattere contenuto nell' array OGGGrid

    spostx,sposty,spostx1,sposty1:integer;             // sopostamento della griglia rispetto alla posizione al momento della sua creazione

    ncolonne,nrighe,lcella,hcella:integer;             // caratteristiche della griglia

    ncolonnemax,nrighemax,lcellamax,hcellamax:integer;

    Dimensione,spRighe,righee:integer;                 // Dimensione = grandezza dei caratteri 1..3 ; spRighe = altezza tra ogni riga
    Layout:boolean;                                    // false = capo riga. true = frase centralizzata

    ss:char;

    Ap:array[1..5,1..38]of string;

    nCopy:word;

    nLamp,nxLamp,nyLamp:word;

    ImmagineLHM:array[1..27,1..3]of integer;          // tutte e 26 le immagini hanno : lunghezza, altezza, dimensione(m)

    Descrizione:array[1..26]of string;

    Immagine:SchermoOgg;

    nim:integer;                                      // numero immagine esterno (utile per il secchio)

    bbim:boolean;

    TabimGost:tabella;

    nFeatureEs:integer;

    nFeature:integer;

    lrettangolo,hrettangolo:integer;

    RettFea:oggetto;
    mRettFea:integer;

    CFeature:array[1..6,1..2]of integer;

    x1S,x2S,y1S,y2S:integer;                          // dimensione della schermata finale

    cacca:integer;                                    // variabile inutile

    n:integer;
    caccaTab:tabella;

procedure DrawCode(A:PTCArray;x,y:integer);       // "x,y" are the coords of the first corner (left/up) you can change them..
          var i,j,z,jj,n,nn,c,g,leng,xx,yy:integer;
              t:char;
              s,ss:string;
              b:boolean;
          const strChar:string =chr(176)+chr(177)+chr(178)+chr(219)+chr(220)+chr(223)+chr(254)+chr(95)+chr(238)+chr(196)+chr(197)+chr(180)+chr(191)+chr(192)+chr(193)+chr(194)+chr(195)+chr(217)+chr(218)+chr(179)+chr(221)+chr(185)+chr(186)+chr(187)+chr(188)+chr(200)+chr(201)+chr(202)+chr(203)+chr(204)+chr(205)+chr(206)+chr(0);
          begin
          if Nptc=101 then b:=false else b:=true;
          i:=1;
          while((length(A[Nptc].pc[i])>0)and(i<81))do i:=i+1;
          jj:=i-1;
          for i:=1 to jj do
            begin
            n:=length(A[Nptc].pc[i])div 3;
            if(b)then gotoxy(x,y+i-1) else begin xx:=x; yy:=y+i-1; end;
            for j:=1 to n do
              begin
              s:=copy(A[Nptc].pc[i],j*3-2,3);
              nn:=((ord(s[1])-41)*125*125)+((ord(s[2])-41)*125)+(ord(s[3])-41);
              str(nn,s); s:=copy('000000',1,7-length(s))+s;
              val(copy(s,1,2),c);val(copy(s,3,1),g);val(copy(s,6,2),leng);
              val(copy(s,4,2),nn);t:=strChar[nn];
              if((t=chr(0))and(g=PTCBackground)and(IsTrasparent))then
                  begin if(b)then gotoxy(wherex+leng,y+i-1) else xx:=xx+leng; end
                  else
                  if(b)then
                       begin
                       textcolor(c);
                       textbackground(g);
                       for z:=1 to leng do write(t);
                       end
                       else
                       begin
                       for z:=xx to xx+leng-1 do
                          begin
                          schermata[z,yy].color:=c;
                          schermata[z,yy].ground:=g;
                          schermata[z,yy].text:=t;
                          end;
                       xx:=xx+leng;
                       end;
              end;
            end;
          i:=1;
          while((length(A[Nptc].s[i])>0)and(i<500))do i:=i+1;
          jj:=i-1;
          for i:=1 to jj do
            begin
            s:=A[Nptc].s[i];
            val(copy(s,1,2),c);val(copy(s,3,2),g);if(b)then gotoxy(c+x-1,g+y-1) else begin xx:=c+x-1; yy:=g+y-1; end;
            val(copy(s,5,2),g);if(b)then textcolor(g);
            val(copy(s,7,1),c);if(b)then textbackground(c);
            ss:=copy(s,8,length(s)-7);if(b)then write(ss) else
                              for j:=xx to xx+length(ss)-1 do
                                 begin
                                 schermata[j,yy].color:=g;
                                 schermata[j,yy].ground:=c;
                                 schermata[j,yy].text:=ss[j-xx+1];
                                 end;
            end;
         end;

function ricercaInFile(var da:integer;s1,s2:string):string;
         var i,n,pos1,pos2:integer;
             ss:string;
             c:char;
         begin
         ss:='';
         ricercaInFile:='';
         n:=length(s1);
         seek(Fileinput,da);
         pos1:=-1;
         pos2:=-1;
         for i:=da to filesize(fileinput)-1 do
         begin
         read(Fileinput,c);
         if(i<(n+da))then
                     ss:=ss+c
                     else
                     begin
                     ss:=copy(ss,2,n-1);
                     ss:=ss+c;
                     end;
         if(ss=s1)then begin pos1:=(i+1); i:=filesize(fileinput)+1; end;
         end;
         if(pos1<>-1)then
          begin
          ss:='';
          n:=length(s2);
          for i:=pos1 to filesize(fileinput)-1 do
           begin
           read(Fileinput,c);
           if(i<(n+pos1))then
                         ss:=ss+c
                         else
                         begin
                         ss:=copy(ss,2,n-1);
                         ss:=ss+c;
                         end;
           if(ss=s2)then begin pos2:=(i-n); i:=filesize(fileinput)+1; end;
           end;
          if(pos2<>-1)then
               begin
               seek(fileinput,pos1);
               for i:=pos1 to pos2 do
                  begin
                  read(fileinput,c);
                  ricercainFile:=ricercaInFile+c;
                  end;
               da:=pos2+n+1;
               end;
          end;
         end;


function modifica():integer;
          var i,j,x,n,xx,yy:integer;
              s,ns,pop:string;
              b:boolean;
          begin
          assign(Fileinput,'input.ptc.txt');
          {$I-}
          reset(Fileinput);
          {$I+}
          if(IORESULT=2)then modifica:=1
          else
          begin
          modifica:=0;
          x:=1;
          s:=ricercaInFile(x,'PTCBackground:=',';');
          if(s='')then goto casoCorrotto;
          val(s,PTCBackground);
          s:=ricercaInFile(x,'IsTrasparent:=',';');
          if(s='')then goto casoCorrotto;
          if(s='true')then IsTrasparent:=true else IsTrasparent:=false;

          Nptc:=101;

          b:=true;
          i:=0;
          while(b)do
            begin
            i:=i+1;
            str(i,ns);
            s:=ricercainFile(x,'PAINTCODE[Nptc].pc['+ns+']:=(''',''')');
            if(s='')then b:=false
                    else
                    PAINTCODE[Nptc].pc[i]:=(s);
            end;
          b:=true;
          i:=0;
          while(b)do
            begin
            i:=i+1;
            str(i,ns);
            s:=ricercainFile(x,'PAINTCODE[Nptc].s['+ns+']:=(''',''')');
            if(s='')then b:=false
                    else
                    begin
                    pop:='';
                    for j:=1 to length(s) do
                       if not((s[j]='''')and((j mod 2)=0))then
                          pop:=pop+s[j];
                    PAINTCODE[Nptc].s[i]:=(pop);
                    end;
            end;
          s:=ricercainFile(x,'DrawCode(PAINTCODE,',',');
          if(s='')then goto casoCorrotto;
          val(s,xx);
          x:=x-1;
          s:=ricercainFile(x,',',');');
          if(s='')then goto casoCorrotto;
          val(s,yy);

          for i:=1 to 120 do
             for j:=1 to 80 do
                begin
                schermata[j,i].color:=PTCBackground;
                schermata[j,i].ground:=PTCBackground;
                end;

          DrawCode(PAINTCODE,xx,yy);
          if(yy=1000)then
                begin
                   casoCorrotto:
                   modifica:=2;
                end;
          end;
          close(Fileinput);
          end;

function cancTab():tabella;
          var i,j:integer;
          begin
          for i:=1 to 80 do
              for j:=1 to 120 do
                  cancTab[i,j]:=false;
          end;

function unisciTab(A,B:tabella):tabella;
         var i,j:integer;
         begin
         unisciTab:=A;
         for i:=1 to 80 do
             for j:=1 to 120 do
                 if(B[i,j])then
                           unisciTab[i,j]:=true;
         end;

procedure scambio(var a,b:ottanta);
          var t:ottanta;
          begin
          t:=a;
          a:=b;
          b:=t;
          end;

procedure scambia(var a,b:integer);
          var t:integer;
          begin
          t:=a;
          a:=b;
          b:=t;
          end;
procedure rettangolo(x,y,l,h,sfo:integer);
          var i:integer;
          begin                           // "l" è la lunghezza
          for i:=y to y+h-1 do            // "h" è l' altezza
                   begin                  // "x" e "y" sono le coordinate dello
                   gotoxy(x,i);           //   spigolo in alto a sinistra
                   write(chr(219))        // sfo = colore dello sfondo
                   end;
          for i:=2 to l-1 do
                   begin
                   gotoxy(x+i-1,y);
                   write(chr(223));
                   gotoxy(x+i-1,y+h-1);
                   write(chr(220))
                   end;
          textbackground(sfo);
          for i:=y to y+h-1 do
                   begin
                   gotoxy(x+l-1,i);
                   write(chr(219))
                   end;
          end;

function tasto:char;
         begin                //la funzione fa attendere il programma finche l' utente non
         repeat               //preme un tasto
         until(keypressed);
         tasto:=readkey;
         end;
function qtasto(s:string;c:char):boolean;
         var x:boolean;
             i:integer;
         begin                            //true è buono
         x:=false;
         i:=0;
         while((x=false)and(i<length(s)))do
            begin
            i:=i+1;
            if(c=s[i])then
                   x:=true;
            end;
         qtasto:=x;
         end;

function attenditasto(s:string):char;
         var ch:char;
         begin                                  //contenuti nella stringa s;  and es: j:=attenditasto('qweasdzx789456123r '+chr(13));
         repeat                                 //collegata a " TASTO "
         ch:=tasto;
         until(qtasto(s,ch));
         attenditasto:=ch;
         end;

function nTastiera(s:char):integer;
         begin
         nTastiera:=1;
         while((s<>stastiera[nTastiera])and(nTastiera<27))do
              nTastiera:=nTastiera+1;
         if(nTastiera=27)then nTastiera:=-1;
         end;

procedure incr(var A:oggetto;var m:integer;x,y:integer);
          begin
          m:=m+1;
          A[m,1]:=x; A[m,2]:=y;
          end;

procedure incrImm(var S:schermoOgg;n:integer;var m:integer;x,y,c,b:integer;t:char);
          begin
          m:=m+1;
          S[n,m].x:=x;
          S[n,m].y:=y;
          S[n,m].color:=c;
          S[n,m].ground:=b;
          S[n,m].text:=t;
          end;

function unisciOgg(var m:integer;A:oggetto;ma:integer;B:oggetto;mb:integer):oggetto;
         begin
         m:=0;
         repeat
         m:=m+1;
         incr(A,ma,B[m,1],B[m,2]);
         until(m>=mb);
         m:=ma;
         unisciOgg:=A;
         end;

function invertiColori(n:word):word;
         begin
         if((n>0)and(n<7))then invertiColori:=7-n else if((n>8)and(n<15))then invertiColori:=23-n;
         if(n=15)then invertiColori:=0 else if(n=0)then invertiColori:=15 else if((n>6)and(n<9))then invertiColori:=15-n;
         end;

function  barra(x,y:integer):boolean;
          var n:integer;
          begin
          if(strumento=8)then
                         n:=1
                         else
                         n:=0;
          barra:=true;
          if(not hide)then
              begin
              if((y>1)and(y<10+n))then
                     if(((x>2)and(x<18))or((x>19)and(x<35))or((x>36)and(x<52)))then
                               barra:=false;
              if((y>1)and(y<12)and(x>62)and(x<79))then
                               barra:=false;
              end;
          end;

function barraDime(y,x:integer):boolean;
         var n:integer;
          begin
          barraDime:=true;
          if(not hideDime)then
              begin
              if((y>18)and(y<62))then
                     if((x>21)and(x<33))then
                               barraDime:=false;
              end;
          if((y=0)or(y=81)or(x=0)or(y=81))then
                          barraDime:=false;
          end;

procedure writeFile(s:string);
          var i:integer;
          begin
          for i:=1 to length(s) do
              if(s[i]=chr(13))then
                   write(file1,chr(13),chr(10))
                   else
                   write(file1,s[i]);
          end;

function gotoxyb(x,y:integer):boolean;
          begin
          if(barra(x,y))then
                        begin
                        gotoxy(x,y);
                        gotoxyb:=true;
                        end
                        else
                        gotoxyb:=false
          end;

function corniceBarra(x,y:integer):boolean;
         var n:integer;
         begin
         corniceBarra:=false;
         if(not (Hide))then
         begin
         if(strumento=8)then
                        n:=1
                        else
                        n:=0;
         if((y>1)and(y<10+n))then
                 if((x=2)or(x=18)or(x=19)or(x=35)or(x=36)or(x=52))then
                         corniceBarra:=true;
         if((y>1)and(y<12))then
                 if((x=62)or(x=79))then
                          corniceBarra:=true;
         end;
         end;

function chrRettang(x,y:integer;b:boolean):integer;
         var xx1,yy1,xx2,yy2:integer;                               // FALSE prima    TRUE dopo
         begin
         if(b)then begin xx1:=dx1;yy1:=dy1;xx2:=dx2;yy2:=dy2; end
              else begin xx1:=px1;yy1:=py1;xx2:=px2;yy2:=py2; end;
         if(x=xx1)then begin if(y=yy1)then chrRettang:=4 else if(y=yy2)then chrRettang:=7 else chrRettang:=3;end else if(x=xx2)then begin
         if(y=yy1)then chrRettang:=5 else if(y=yy2)then chrRettang:=6 else chrRettang:=3; end else if(y=yy1)then chrRettang:=1 else chrRettang:=2;
         end;


function seRettang(x,y:integer;var n:integer):boolean;
         var nd,np:integer;
         begin
         if(strumento=10)then
         begin
         nd:=chrRettang(x,y,true);
         np:=chrRettang(x,y,false);
         if(np=nd)then
                  begin
                  n:=np;
                  seRettang:=true;
                  end
                  else
                  seRettang:=false;
         end
         else
         SeRettang:=true;
         end;

function sca(i,j:integer):integer;
         begin
         sca:=(((2*i)+j)div 2) mod 2;
         end;
function scacchi(i,j:integer):boolean;
          begin
          if(x mod 2<>0)then
              j:=j+1;
          if(x>x2)then
              j:=j+1;
          if(sca(i,j)=0)then
                  begin
                  textcolor(color1);
                  textbackground(ground1);
                  scacchi:=true;
                  end
                  else
                  begin
                  textcolor(color2);
                  textbackground(ground2);
                  scacchi:=false;
                  end;
          end;
procedure scacchiera(x,y,l,h:integer);
          var i,j:integer;
          begin
          for i:=y to y+h-1 do
              begin                                      //c = colore di codice minore
              gotoxy(x,i);
              for j:=x to x+l-1 do
               if(barra(i,j))then
                if(scacchi(i,j))then
                                write(text1)
                                else
                                write(text2);
              end;
          end;


procedure muovi(s:char;var x,y:integer);
          begin
          if((qtasto('741qaz'+chr(75),s))and(x>1))then
                            x:=x-1;
          if((qtasto('963edx'+chr(77),s))and(x<80))then
                            x:=x+1;
          if((qtasto('789qwe'+chr(72),s))and(y>1))then
                            y:=y-1;
          if((qtasto('123zsx'+chr(80),s))and(y<80))then
                            y:=y+1;
          end;

procedure fondiPXL(x,y:integer);
          begin
          schermata[x,y].color:=color;
          schermata[x,y].ground:=ground;
          schermata[x,y].text:=text;
          end;

procedure Colora(x,y:integer);
          begin
          if((strumento<13)or(barraDime(x,y)))then
          if(barra(x,y))then
                        if((strumento=2)or(title))then
                                 begin
                                 if(corniceTab[x,y])then
                                      begin
                                      if(sfondo=7)then textcolor(0) else textcolor(15);textbackground(sfondo);gotoxy(x,y);write(chrGomma);
                                      end
                                      else
                                      begin
                                      textbackground(sfondo);gotoxy(x,y);write(chr(0));
                                      end;
                                 end
                                 else
                                 if(strumento=8)then
                                          begin
                                          gotoxy(x,y);
                                          if(scacchi(y,x))then
                                                write(text1)
                                                else
                                                write(text2);
                                          end
                                          else
                                          if(strumento=3)then
                                                   begin
                                                   gotoxy(x,y);
                                                   textbackground(7);
                                                   textcolor(15);
                                                   if((x+y) mod 2=0)then
                                                                  write(chr(176))
                                                                  else
                                                                  write(chr(178));
                                                   end
                                          else
                                                         begin
                                                         textcolor(color);textbackground(ground);gotoxy(x,y);
                                                         if(strumento=7)then
                                                                 write(OGGGrid[TABGrid[x-spostx,y-sposty]])
                                                                 else
                                                                 if((strumento=10)and(nRettang<>4))then
                                                                            write(ch[nRettang,chrRettang(x,y,true)])
                                                                            else
                                                                            write(text);
                                                         end;
          end;

procedure Setta(x,y:integer);
          begin
          if((strumento<13)or(barraDime(x,y)))then
          if(barra(X,Y))then
          begin
          gotoxy(x,y);
          if((strumento=4)and(TArea[x,y]))then
                         if((not corniceTab[x,y])or(x+y+nlamp mod 3 <>0))then
                              begin
                              textcolor(inverticolori(schermata[x,y].color));
                              textbackground(inverticolori(schermata[x,y].ground));
                              write(schermata[x,y].text);
                              end
                              else
                              Colora(x,y)
                         else
          if(not gostTab[x,y])then
          begin
          textcolor(schermata[x,y].color);
          textbackground(schermata[x,y].ground);
          write(schermata[x,y].text);
          end
          else
          Colora(x,y);
          end;
          end;

procedure lampeggioArea(OGG:oggetto;m:integer);                            //if( ( (OGG[i,2] mod 2)*((OGG[i,2]-1)mod 4 +OGG[i,1]-1) )mod 4 =1)then
          var i:integer;
          begin
          if(nxlamp<>0)then
                      nxlamp:=nxlamp-1
                      else
                      nxlamp:=3;
          if(nylamp<>0)then
                      nylamp:=nylamp-1
                      else
                      nylamp:=2;

          for i:=1 to m do
            if (((OGG[i,2]+nylamp)mod 3=0)and((OGG[i,1]+nxlamp)mod 4=0))then
                                colora(OGG[i,1],OGG[i,2])
                                else
                                if(barra(OGG[i,1],OGG[i,2]))then
                               if(((OGG[i,2]+nylamp+1)mod 3=0)and((OGG[i,1]+nxlamp+1)mod 4=0))then
                                begin
                                gotoxy(OGG[i,1],OGG[i,2]);
                                textcolor(inverticolori(schermata[OGG[i,1],OGG[i,2]].color));
                                textbackground(inverticolori(schermata[OGG[i,1],OGG[i,2]].ground));
                                write(schermata[OGG[i,1],OGG[i,2]].text);
                                end
          end;

procedure lampeggio(OGG:oggetto;m:integer);                              // true => colori invertiti ; false => setta;
          var i:integer;
          begin
          if(nlamp<>0)then
                      nlamp:=nlamp-1
                      else
                      nlamp:=2;
          for i:=1 to m do
             if((i+nlamp) mod 3=0)then
                                colora(OGG[i,1],OGG[i,2])
                                else
                                if(barra(OGG[i,1],OGG[i,2]))then
                                begin
                                gotoxy(OGG[i,1],OGG[i,2]);
                                textcolor(inverticolori(schermata[OGG[i,1],OGG[i,2]].color));
                                textbackground(inverticolori(schermata[OGG[i,1],OGG[i,2]].ground));
                                write(schermata[OGG[i,1],OGG[i,2]].text);
                                end
          end;

procedure SettaNoGost(x,y:integer);
          begin
          if(barra(X,Y))then
                        begin
                        gotoxy(x,y);
                        textcolor(schermata[x,y].color);
                        textbackground(schermata[x,y].ground);
                        write(schermata[x,y].text);
                        end;
          end;

procedure pulisci;
          var i,j:integer;
          begin
          if(ymaxcln=0)then
                for j:=1 to 80 do
                     for i:=1 to 80 do
                          if((not(schermata[i,j].text = chr(0)))or(corniceBarra(i,j)))then
                               ymaxcln:=j;
          if(ymaxcln<>0)then
          begin
          for j:=1 to ymaxcln do
              for i:=1 to 80 do
                 if(not((schermata[i,j].text = chr(0))and(schermata[i,j].ground=sfondo))or(strumento=4)or(corniceBarra(i,j))or(not((caccaBKP[i,j].text = chr(0))and(caccaBKP[i,j].ground=sfondo))and(pulisciBKP)))then
                      if(not gostTab[i,j])then
                        Setta(i,j)
                        else
                    if(strumento=4)then
                    begin
                    if (((j+nylamp)mod 3=0)and((i+nxlamp)mod 4=0))then
                                 colora(i,j)
                                 else
                                 if(gotoxyb(i,j))then
                                     begin
                                     textcolor(inverticolori(schermata[i,j].color));
                                     textbackground(inverticolori(schermata[i,j].ground));
                                     write(schermata[i,j].text);
                                     end;
                     end
                     else
                     colora(i,j);
          gotoxy(1,1);
          end;
          ymaxcln:=0;
          end;

function inversoColor(c:integer):integer;
         var i,lol:integer;
         begin
         i:=-1;
         repeat
         i:=i+1;
         val(copy(sfumato[i],1,2),lol,cacca);
         until(lol=c);
         inversoColor:=i;
         end;

procedure DStile(OGG:oggetto;m,n,c1,c2:integer;bb:boolean);
         var i,j,c,b,h,min,max,lol:integer;
             t:char;
         procedure gradua(y:integer);
                   var n:integer;
                   begin
                   if(((8*y) div h)<>(8*y/h))then
                        n:=((8*y) div h)+1
                        else
                        n:=((8*y) div h);
                   if(n<5)then
                          begin
                          c:=c1+8;
                          if(c=8)then c:=0;
                          b:=c2;
                          t:=chrSfumato[5-n];
                          end
                          else
                          begin
                          c:=c2+8;
                          if(c=8)then c:=0;
                          b:=c1;
                          t:=chrSfumato[n-4];
                          end;
                   end;
         begin
         case n of
          1:begin
            textcolor(color);
            textbackground(ground);
            for i:=1 to m do
              begin
              if(gotoxyb(OGG[i,1],OGG[i,2]))then
                  write(text);
              if(bb)then
                    fondiPXL(OGG[i,1],OGG[i,2]);
              end;
            end;
          2:begin
            c1:=inversoColor(c1);
            h:=length(sfumato[c1])div 2;
            for i:=1 to m do
               begin
               val((copy(sfumato[c1],(2*random(h)+1),2)),c,cacca);
               val((copy(sfumato[c1],(2*random(h div 2)+1),2)),b,cacca);
               if(c=b)then
                      val((copy(sfumato[c1],(2*random(h)+1),2)),c,cacca);
               t:=chrSfumato[random(4)+1];
               textcolor(c);textbackground(b);
               if(gotoxyb(OGG[i,1],OGG[i,2]))then
                  write(t);
               if(bb)then
                    begin
                    schermata[OGG[i,1],OGG[i,2]].color:=c;
                    schermata[OGG[i,1],OGG[i,2]].ground:=b;
                    schermata[OGG[i,1],OGG[i,2]].text:=t;
                    end;
               end;
            end;
          3:begin
            min:=OGG[1,2]; max:=min;
            for i:=2 to m do
                begin
                if(OGG[i,2]<min)then min:=OGG[i,2];
                if(OGG[i,2]>max)then max:=OGG[i,2];
                end;
            h:=max-min+1;
            for i:=1 to m do
               begin
               gradua(OGG[i,2]-min+1);
               if(gotoxyb(OGG[i,1],OGG[i,2]))then
                  begin
                  textcolor(c);textbackground(b);
                  write(t);
                  end;
               if(bb)then
                    begin
                    schermata[OGG[i,1],OGG[i,2]].color:=c;
                    schermata[OGG[i,1],OGG[i,2]].ground:=b;
                    schermata[OGG[i,1],OGG[i,2]].text:=t;
                    end;
               end;
            end;
          4:begin
            for i:=1 to m do
               begin
               if( ( (OGG[i,2] mod 2)*((OGG[i,2]-1)mod 4 +OGG[i,1]-1) )mod 4 =1)then
                                     c:=c2+8
                                     else
                                     c:=c1+8;
                        b:=c;
                        if(b=0)then c:=0;
                        t:=chr(219);

               if(gotoxyb(OGG[i,1],OGG[i,2]))then
                  begin
                  textcolor(c);textbackground(b);
                  write(t);
                  end;
               if(bb)then
                    begin
                    schermata[OGG[i,1],OGG[i,2]].color:=c;
                    schermata[OGG[i,1],OGG[i,2]].ground:=b;
                    schermata[OGG[i,1],OGG[i,2]].text:=t;
                    end;
               end;
            end;
          5,6:begin
            for i:=1 to m do
               begin
               if((OGG[i,7-n])mod 2=0)then
                                     c:=c2+8
                                     else
                                     c:=c1+8;
                        b:=c;
                        if(b=0)then c:=0;
                        t:=chr(219);
               if(gotoxyb(OGG[i,1],OGG[i,2]))then
                  begin
                  textcolor(c);textbackground(b);
                  write(t);
                  end;
               if(bb)then
                    begin
                    schermata[OGG[i,1],OGG[i,2]].color:=c;
                    schermata[OGG[i,1],OGG[i,2]].ground:=b;
                    schermata[OGG[i,1],OGG[i,2]].text:=t;
                    end;
               end;
            end;
        end;
        end;

procedure introduzione();
         var i,j,v,p:integer;
             ss:char;
         begin
         clrscr;
         textbackground(3);
         clrscr;
         Nptc:=1;isTrasparent:=true;PTCBackground:=3;
         DrawCode(PAINTCODE,1,1);

         p:=0;
         repeat
         repeat
         v:=19;
         repeat
         if(v>66)then
         gotoxy(1,1);
         v:=v+1;
         if (v mod 20)=0 then
                 begin
                 textcolor(14);textbackground(3);
                 rettangolo(p*30+13,44,26,5,3);
                 end;
         if ((v+10)mod 20)=0 then
                  begin
                  textcolor(15);textbackground(3);
                  rettangolo(p*30+13,44,26,5,3);
                  end;
         if(v=1000000)then
               v:=2;
         delay(30);
         until(keypressed);
         textcolor(15);
         textbackground(3);
         rettangolo(p*30+13,44,26,5,3);
         ss:=readkey;
         until(qtasto('46ad'+chr(13)+chr(75)+chr(77),ss));
         if((qtasto('4a'+chr(75),ss))and(p>0))then
                                      p:=p-1;
         if((qtasto('6d'+chr(77),ss))and(p<1))then
                                         p:=p+1;
         until(ss=chr(13));
         clrscr;
         if(p=1)then
                begin
                clrscr;
                textbackground(1);
                clrscr;

                Nptc:=2;isTrasparent:=true;PTCBackground:=1;
                DrawCode(PAINTCODE,1,1);
                textcolor(15);textbackground(1);
                gotoxy(55,59);write('press any key..');
                repeat
                until(keypressed);
                readkey;

                clrscr;
                Nptc:=3;isTrasparent:=true;PTCBackground:=1;
                DrawCode(PAINTCODE,1,0);
                repeat
                until(keypressed);
                readkey;

                clrscr;
                Nptc:=9;isTrasparent:=true;PTCBackground:=1;
                Drawcode(PAINTCODE,1,1);
                repeat
                until(keypressed);
                readkey;

                clrscr;
                Nptc:=27;isTrasparent:=true;PTCBackground:=1;
                Drawcode(PAINTCODE,1,1);
                repeat
                until(keypressed);
                readkey;
                end;
         end;

procedure attenzioneFea();
          var i:integer;
          begin
          textcolor(15);
          textbackground(0);
          rettangolo(65,30,14,9,15);
          textbackground(0);
          for i:=31 to 37 do
            begin
            gotoxy(66,i);write(' ');
            gotoxy(77,i);write(' ');
            end;
          DStile(RettFea,mRettFea,nFeature,CFeature[nFeature,1],CFeature[nFeature,2],false);
          end;

function attenzione(c,p,yy:integer;d,s:string):integer;                   // c = colore domanda ; p = numero del bottone di partenza
         var i,j,z,n,nf,dmax,lmax,ld,ls,lss,x,y,lr,h,v,sf:integer;              // per d utilizza £ per mandare a capo la parte di frase successiva
             A:array[1..5]of string;
             L:array[1..5,1..3]of integer;
             F:array[1..3]of string;
             SFND:array[1..5]of integer;
             ss:char;
             lol:string;
             bFea,showFea:boolean;
         begin
         ShowFea:=false;
         if(d='would you like to apply some feature?')then
               bFea:=true
               else
               bFea:=false;

         for i:=1 to 5 do
             SFND[i]:=0;
         if(yy=0)then
                 yy:=30;
         nf:=1;
         for i:=1 to 5 do
             begin
             A[i]:='';
             for j:=1 to 3 do
                 L[i,j]:=0;
             end;
         for i:=1 to 3 do
            F[i]:='';
         for i:=1 to length(d) do
               if(d[i]='£')then
                           nf:=nf+1
                           else
                           F[nf]:=F[nf]+d[i];
         dmax:=length(F[1]);
         for i:=2 to nf do
             if(length(F[i])>dmax)then
                         dmax:=length(F[i]);
         n:=1;                                                                 //lunghezza 38
         for i:=1 to length(s) do
               begin
               if(s[i]='£')then
                           begin
                           i:=i+1;
                           lol:='';
                           while((s[i]<>' ')and(i<=length(s)))do
                              begin
                              lol:=lol+s[i];
                              i:=i+1;
                              end;
                           val(lol,SFND[n],cacca);
                           end;
               if(s[i]=' ')then
                           n:=n+1
                           else
                           if(i<=length(s))then
                           A[n]:=A[n]+s[i];
               end;
         for i:=1 to n do
            for j:=1 to length(A[i]) do
               if(A[i][j]='_')then
                             A[i][j]:=' ';
         lmax:=length(A[1]);
         for i:=2 to n do
             if(length(A[i])>lmax)then
                         lmax:=length(A[i]);
         if(lmax<=7)then
                    ls:=13
                    else
                    ls:=lmax+6;
         lss:=0;
         for i:=1 to n do
             begin
             if((ls mod 2)<>(length(A[i]) mod 2))then
                                         L[i,3]:=ls-1
                                         else
                                         L[i,3]:=ls;
             lss:=lss+L[i,3];
             end;
         lss:=lss+(n-1)*2+8;
         if(dmax<=18)then                                          //aggiunge 5 e 5 ai lati tella frase maggiore
               if(dmax mod 2=0)then
                                    ld:=38
                                    else
                                    ld:=37
               else
               ld:=dmax+10;
         if(ld>lss)then
                   begin                                              //altezza: cornice distante 1 dalla frase frase distante 1 dai bottoni bottoni distanti 1
                   lr:=ld;
                   x:=(80-lr); x:=x div 2; x:=x+1;
                   h:=8+nf;
                   y:=yy;
                   ls:=lss;
                   j:=0;
                   while((ls+(n-1)<=ld)and(ld-ls>j+4))do
                         begin
                         ls:=ls+(n-1);
                         j:=j+1;
                         end;
                   j:=j+2;                       // J = spazio trai bottoni
                   ls:=ls-8;                     // ls = nuova larghezza occupata dal primo bottone fino all' ultimo
                   for i:=1 to n do
                       begin
                       L[i,1]:=x+(lr-ls)div 2;
                       L[i,2]:=yy+3+nf;
                       z:=1;
                       while(z<i)do
                          begin
                          L[i,1]:=L[i,1]+L[z,3]+j;
                          z:=z+1;
                          end;
                       end;
                   end
                   else
                   begin
                   lr:=lss;
                   x:=(80-lr); x:=x div 2; x:=x+1;
                   h:=8+nf;
                   y:=yy;
                   for i:=1 to n do
                       begin
                       L[i,1]:=x+4;
                       L[i,2]:=yy+3+nf;
                       z:=1;
                       while(z<i)do
                          begin
                          L[i,1]:=L[i,1]+L[z,3]+2;
                          z:=z+1;
                          end;
                       end;
                   end;
         textcolor(15);textbackground(0);
         rettangolo(x,y,lr,h,sfondo);
         textbackground(15);
         for i:=y to y+h-1 do
             begin
             gotoxy(x+lr-1,i);write(chr(219));
             end;
         textbackground(0);
         textcolor(0);
         for i:=y+1 to y+h-2 do
             for j:=x+1 to x+lr-2 do
                  begin
                  gotoxy(j,i);
                  write(' ');
                  end;
         textcolor(c);
         for i:=1 to nf do
             begin
             gotoxy(x+((lr-length(F[i]))div 2),yy+1+i);
             write(F[i]);
             end;
         textcolor(15);
         for i:=1 to n do
             begin
             textbackground(SFND[i]);
             gotoxy(L[i,1]+1,L[i,2]+1);
             write(copy(spazio,1,L[i,3]-2));
             gotoxy(L[i,1]+((L[i,3]-length(A[i]))div 2),L[i,2]+1);
             write(A[i]);
             end;
         for i:=1 to n do
             begin
             textbackground(SFND[i]);
             rettangolo(L[i,1],L[i,2],L[i,3],3,0);
             end;
         repeat
         repeat
         v:=19;
         repeat
         v:=v+1;
         if(v=20)then
                 begin
                 textcolor(14);textbackground(SFND[p]);
                 rettangolo(L[p,1],L[p,2],L[p,3],3,0);
                 v:=2;
                 end;
         if(v=10)then
                  begin
                  if((p=3)and(bFea)and(not ShowFea))then
                            begin
                            ShowFea:=true;
                            attenzioneFea;
                            end;
                  textcolor(15);textbackground(SFND[p]);
                  rettangolo(L[p,1],L[p,2],L[p,3],3,0);
                  end;
         delay(30);
         until(keypressed);
         textcolor(15);
         textbackground(SFND[p]);
         rettangolo(L[p,1],L[p,2],L[p,3],3,0);
         ss:=readkey;
         until(qtasto('46ad'+chr(13)+chr(75)+chr(77),ss));
         if((qtasto('4a'+chr(75),ss))and(p>1))then
                                      p:=p-1;
         if((qtasto('6d'+chr(77),ss))and(p<n))then
                                         p:=p+1;
         until(ss=chr(13));
         if(ShowFea)then
                    begin
                    lr:=lr+13;
                    h:=h+8;
                    end;
         if((strumento<>4)and(strumento<>13))then
         begin
         for i:=y to y+h-1 do
             for j:=x to x+lr-1 do
                 if(strumento<>-2)then
                 setta(j,i)
                 else
                 begin
                 gotoxy(j,i);textbackground(0);write(' ');end;
         if(strumento<>-2)then
         pulisci;
         end;
         if(strumento=13)then
                begin
                textbackground(0);
                for i:=y to y+h-1 do
                   for j:=x to x+lr-1 do
                    if(gotoxyb(j,i))then
                     if((j=36)or(j=37))then
                      write(chr(179))
                      else
                      write(' ');
                 end;
         attenzione:=p;
         end;

procedure FinestraTools(b:boolean);
          var i,j,xn,yn:integer;
          procedure curso(n:integer);
                    begin
                    textcolor(7);
                    gotoxy(65,n+7);
                    write('X=    Y=');
                    textcolor(15);
                    gotoxy(68,n+7);write(x); if(x<10)then write(' ');
                    gotoxy(74,n+7);write(y); if(y<10)then write(' ');
                    end;
          begin
          if(not Hide)then
          begin
          if((strumento=0)or(b))then
          begin
          textbackground(0);
          for i:=5 to 10 do                                               //  65 => 76
              for j:=65 to 76 do                                          //  5  => 10
                  begin
                  gotoxy(j,i);write(' ');
                  end;
          end;
          xn:=((10-length(strumenti[round(strumento)]))div 2)+65;
          gotoxy(xn,5); if(strumento=0)then textcolor(4) else textcolor(1); textbackground(0);
          for i:=xn to xn+length(strumenti[round(strumento)])+1 do
                  write(chr(220));
          gotoxy(xn,7);
          for i:=xn to xn+length(strumenti[round(strumento)])+1 do
                  write(chr(223));
          gotoxy(xn,6);if(strumento=0)then textbackground(4) else textbackground(1);textcolor(15);write(' ',strumenti[round(strumento)],' ');

          textbackground(0);
          gotoxy(xn+length(strumenti[round(strumento)])+2,6);write(' ');
          if(strumento=8)then
                          begin
                          textcolor(15);textbackground(sfondo);write(chr(219));
                          end;
          textbackground(0);
          if(strumento=0)then
                         begin
                         textcolor(14);
                         gotoxy(68,8);write('SELECT');
                         gotoxy(65,9);write('ANOTHER TOOL');
                         end
                         else
          if(strumento=1)then
                begin
                curso(1);
                if(StrumentoSecondario)then
                                       begin
                                       textcolor(14); gotoxy(68,10); write(' LINE ')
                                       end
                                       else
                                       begin
                                       textcolor(14); gotoxy(68,10); write('POINTS');
                                       end;
                end
                else
                if(strumento=2)then
                begin
                textcolor(14);gotoxy(65,9);write('PRESS SPACE');
                gotoxy(65,10);write('TO ERASE ALL');
                textcolor(7);gotoxy(68,8);write('D = ');
                textcolor(15);write((lato*2)+1); if((lato*2)+1<10)then write(' ');
                gotoxy(70,9);write('<');gotoxy(76,9);write('>');
                textcolor(14);gotoxy(71,9);write('SPACE');
                end
                else
                if(strumento=5)then
                 curso(2)
                 else
                 if(((strumento=6)or(strumento=8)or(strumento=3)or(strumento=4))and(StrumentoSecondario))then
                          begin
                          textcolor(7);
                          gotoxy(65,8);
                          write('X1=   Y1=');
                          textcolor(15);
                          gotoxy(68,8);
                          if(EstremoRetta)then begin write(x); if(x<10)then write(' '); end else begin write(x2); if(x2<10)then write(' '); end;
                          gotoxy(74,8);
                          if(EstremoRetta)then begin write(y); if(y<10)then write(' '); end else begin write(y2); if(y2<10)then write(' '); end;
                          textcolor(7);
                          gotoxy(65,9);
                          write('X2=   Y2=');
                          textcolor(15);
                          gotoxy(68,9);
                          if(EstremoRetta)then begin write(x2); if(x2<10)then write(' '); end else begin write(x); if(x<10)then write(' '); end;
                          gotoxy(74,9);
                          if(EstremoRetta)then begin write(y2); if(y2<10)then write(' '); end else begin write(y); if(y<10)then write(' '); end;
                          if(strumento=3)then
                                         begin
                                         textcolor(7);
                                         gotoxy(65,10);
                                         write('Lx=   Ly=');
                                         textcolor(15);
                                         gotoxy(68,10);
                                         write(abs(x2-x)+1);   if(abs(x2-x)+1<10)then write(' ');
                                         gotoxy(74,10);
                                         write(abs(y2-y)+1);   if(abs(y2-y)+1<10)then write(' ');
                                         end;
                          end
                 else
                 if(((strumento=6)or(strumento=8)or(strumento=3)or(strumento=4))and(not StrumentoSecondario))then
                          begin
                          textcolor(7);
                          gotoxy(65,8);
                          write('X1=   Y1=');
                          textcolor(15);
                          gotoxy(68,8);
                          write(x); if(x<10)then write(' ');
                          gotoxy(74,8);
                          write(y); if(y<10)then write(' ');
                          end
                          else
                          if((strumento=7)or(strumento=10))then
                            begin
                            textcolor(7);
                            gotoxy(65,8);
                            write('X1=   Y1=');
                            textcolor(15);
                            gotoxy(68,8);write(dx1); if(dx1<10)then write(' ');
                            gotoxy(74,8);write(dy1); if(dy1<10)then write(' ');
                            textcolor(7);
                            gotoxy(65,9);
                            write('X2=   Y2=');
                            textcolor(15);
                            gotoxy(68,9);
                            write(dx2); if(dx2<10)then write(' ');
                            gotoxy(74,9);
                            write(dy2); if(dy2<10)then write(' ');
                            textcolor(14);
                            gotoxy(65,10);
                            if(((nGrid=3)and(strumento=7))or((nRettang=4)and(strumento=10)))then
                                                   write(' P. ENABLED')
                                                   else
                                                   write('P. DISABLED');
                            end
                    else
                  if((strumento=9)and(not StrumentoSecondario))then
                  curso(2)
                  else
                  if((strumento=11)and(not StrumentoSecondario))then
                  begin
                  textcolor(7);
                  gotoxy(65,8);
                  write('X1=   Y1=');
                  textcolor(15);
                  gotoxy(68,8);write(x); if(x<10)then write(' ');
                  gotoxy(74,8);write(y); if(y<10)then write(' ');
                  textcolor(7);
                  gotoxy(65,9);
                  write('X2=   Y2=');
                  textcolor(15);
                  gotoxy(68,9);
                  write(x2); if(x2<10)then write(' ');
                  gotoxy(74,9);
                  write(y2); if(y2<10)then write(' ');
                  end
                  else
                  if(strumento=12)then
                  begin
                  textcolor(7);gotoxy(68,8);write('R ='); gotoxy(67,9);write('K =');
                  textcolor(15);gotoxy(72,8);write(r,' '); gotoxy(71,9);write(k:1:2,'  ');
                 end;
           if(strumento=4)then
            begin
            textcolor(14);
            gotoxy(65,10);
            if(nCopy=1)then
                       write(' RETTANGLE ')
                       else
                       if(nCopy=2)then
                                  write('    LINE    ')
                                  else
                                  write('   BUCKET   ');
            end;
           end;
           end;

procedure ResetTools();
          var i,j,xn,yn:integer;
          procedure curs(n:integer);
                    begin
                    textcolor(15);
                    gotoxy(68,n+7);write(x); if(x<10)then write(' ');
                    gotoxy(74,n+7);write(y); if(y<10)then write(' ');
                    end;
          begin
          if(not Hide)then
          begin
          textbackground(0);
          if(strumento=1)then
                curs(1)
                else
                if(strumento=2)then
                begin
                textcolor(15);gotoxy(72,8);write((lato*2)+1); if((lato*2)+1<10)then write(' ');
                end
                else
                if(strumento=5)then
                 curs(2)
                 else
                 if(((strumento=6)or(strumento=8)or(strumento=3)or(strumento=4))and(StrumentoSecondario))then
                          begin
                          textcolor(15);
                          gotoxy(68,8);
                          if(EstremoRetta)then begin write(x); if(x<10)then write(' '); end else begin write(x2); if(x2<10)then write(' '); end;
                          gotoxy(74,8);
                          if(EstremoRetta)then begin write(y); if(y<10)then write(' '); end else begin write(y2); if(y2<10)then write(' '); end;
                          textcolor(15);
                          gotoxy(68,9);
                          if(EstremoRetta)then begin write(x2); if(x2<10)then write(' '); end else begin write(x); if(x<10)then write(' '); end;
                          gotoxy(74,9);
                          if(EstremoRetta)then begin write(y2); if(y2<10)then write(' '); end else begin write(y); if(y<10)then write(' '); end;
                          if(strumento=3)then
                                         begin
                                         textcolor(15);
                                         gotoxy(68,10);
                                         write(abs(x2-x)+1);   if(abs(x2-x)+1<10)then write(' ');
                                         gotoxy(74,10);
                                         write(abs(y2-y)+1);   if(abs(y2-y)+1<10)then write(' ');
                                         end;
                          end
                 else
                 if(((strumento=6)or(strumento=8)or(strumento=3)or(strumento=4))and(not StrumentoSecondario))then
                          begin
                          textcolor(15);
                          gotoxy(68,8);
                          write(x); if(x<10)then write(' ');
                          gotoxy(74,8);
                          write(y); if(y<10)then write(' ');
                          end
                          else
                          if((strumento=7)or(strumento=10))then
                            begin
                            textcolor(15);
                            gotoxy(68,8);write(dx1); if(dx1<10)then write(' ');
                            gotoxy(74,8);write(dy1); if(dy1<10)then write(' ');
                            textcolor(15);
                            gotoxy(68,9);
                            write(dx2); if(dx2<10)then write(' ');
                            gotoxy(74,9);
                            write(dy2); if(dy2<10)then write(' ');
                            end
                    else
                  if((strumento=9)and(not StrumentoSecondario))then
                  curs(2)
                  else
                  if((strumento=11)and(not StrumentoSecondario))then
                  begin
                 textcolor(15);
                 gotoxy(68,8);write(x); if(x<10)then write(' ');
                 gotoxy(74,8);write(y); if(y<10)then write(' ');
                 textcolor(15);
                 gotoxy(68,9);
                 write(x2); if(x2<10)then write(' ');
                 gotoxy(74,9);
                 write(y2); if(y2<10)then write(' ');
                 end
                 else
                 if(strumento=12)then
                 begin
                 textcolor(15);gotoxy(72,8);write(r,' '); gotoxy(71,9);write(k:1:2,'  ');
                 end;
           end;
           end;

procedure HideShow;
          var i,j,n:integer;
          begin
          if(strumento=8)then
                            n:=1
                            else
                            n:=0;
          if(Hide)then
             begin
             Hide := false;
             if(strumento<>8)then
                             for i:=1 to 15 do
                                 begin
                                 setta(i+2,10);
                                 setta(i+19,10);
                                 setta(i+36,10);
                                 end;
             textbackground(0);
             gotoxy(4,3);textcolor(12);write('    COLOR    ');gotoxy(4,4);write('    ',chr(238),'        ');
             gotoxy(4,5);if(strumento=8)then
                                        begin textcolor(color1);write('  ',chr(219),chr(219),chr(219),'   ');textcolor(color2);write(chr(219),chr(219),chr(219),'  '); end
                                        else begin textcolor(color);write('     ',chr(219),chr(219),chr(219),'     ');end;
             gotoxy(4,6);if(strumento=8)then
                                        begin textcolor(color1);write('  ',chr(219),chr(219),chr(219),'   ');textcolor(color2);write(chr(219),chr(219),chr(219),'  '); end
                                        else begin textcolor(color);write('     ',chr(219),chr(219),chr(219),'     ');end;
             gotoxy(4,7);write('             ');gotoxy(4,8);write('             ');gotoxy(4,9);write('             ');
             if(strumento=8)then
                            begin gotoxy(4+(13-(length(nomiColori[color1])))div 2,8);textcolor(15);write(nomiColori[color1]);
                                  gotoxy(4+(13-(length(nomiColori[color2])))div 2,9);textcolor(15);write(nomiColori[color2]); end
                            else begin gotoxy(4+(13-(length(nomiColori[color])))div 2,8);textcolor(15);write(nomiColori[color]); end;
             textcolor(15); rettangolo(3,2,15,8+n,sfondo);
             textbackground(0);

             gotoxy(21,3);textcolor(12);write(' BACKGROUND  ');gotoxy(21,4);write(' ',chr(238),'           ');
             gotoxy(21,5);write('             ');gotoxy(21,6);write('             ');
             if(strumento=8)then
                            begin gotoxy(23,5);textbackground(ground1);write('   ');gotoxy(23,6);write('   ');textbackground(0);
                                  gotoxy(29,5);textbackground(ground2);write('   ');gotoxy(29,6);write('   ');textbackground(0); end
                            else begin gotoxy(26,5);textbackground(ground);write('   ');gotoxy(26,6);write('   ');textbackground(0); end;
             gotoxy(21,7);write('             ');gotoxy(21,8);write('             ');gotoxy(21,9);write('             ');
             if(strumento=8)then
                            begin gotoxy(21+(13-(length(nomiColori[ground1])))div 2,8);textcolor(15);write(nomiColori[ground1]);
                                  gotoxy(21+(13-(length(nomiColori[ground2])))div 2,9);textcolor(15);write(nomiColori[ground2]); end
                            else begin gotoxy(21+(13-(length(nomiColori[ground])))div 2,8);textcolor(15);write(nomiColori[ground]); end;
             textcolor(15);rettangolo(20,2,15,8+n,sfondo);
             textbackground(0);

             gotoxy(38,3);textcolor(12);write('   PATTERN   ');gotoxy(38,4);write('   ',chr(238),'         ');
             if(strumento=8)then begin textcolor(15);gotoxy(38,5);write('   ',text1,' --> ');textcolor(color1);textbackground(ground1);write(text1);textbackground(0);write('   ');
                                       textcolor(15);gotoxy(38,7);write('   ',text2,' --> ');textcolor(color2);textbackground(ground2);write(text2);textbackground(0);write('   '); end
                                 else begin textcolor(15);gotoxy(38,5);write('   ',text,' --> ');textcolor(color);textbackground(ground);write(text);textbackground(0);write('   '); end;
             gotoxy(38,6);write('             ');
             if(strumento=8)then begin textcolor(15);gotoxy(38,9);write('chr');textcolor(7);write(' (   ,   )');textcolor(15);gotoxy(43,9);write(ord(text1));gotoxy(47,9);write(ord(text2)); end
                                       else begin textcolor(15);gotoxy(38,7);write('  chr (   )  ');gotoxy(45,7);if(ord(text)<10)then write(' ');write(ord(text)); end;
             gotoxy(38,8);write('             ');
             textcolor(15);rettangolo(37,2,15,8+n,sfondo);
             textbackground(0);


             gotoxy(64,3);textcolor(12);write('     TOOL     ');gotoxy(64,4);write('     ',chr(238),'        ');
             gotoxy(64,5);write('              ');gotoxy(64,6);write('              ');gotoxy(64,7);write('              ');
             gotoxy(64,8);write('              ');gotoxy(64,9);write('              ');gotoxy(64,10);write('              ');
             textcolor(15);rettangolo(63,2,16,10,sfondo);
             textbackground(0);

             FinestraTools(false);

             end
             else
             begin
             Hide:=true;
             for i:=2 to 10 do
                      begin
                      for j:=3 to 17 do
                                Setta(j,i);
                      for j:=20 to 34 do
                                Setta(j,i);
                      for j:=37 to 51 do
                                Setta(j,i);
                      end;
             for i:=2 to 11 do
                      for j:=63 to 78 do
                                Setta(j,i);
             end;
          pulisci;
          end;

procedure HideShowDime();
          var i,j:integer;
          begin
          HideDime:=not HideDime;
          if(not HideDime)then
                          begin
                          textbackground(0);textcolor(15);
                          rettangolo(19,22,43,11,7);textbackground(0);
                          for i:=23 to 31 do
                            for j:=20 to 60 do
                                if(gotoxyb(j,i))then
                                    write(' ');
                          textcolor(12);gotoxy(25,24);write('Now select the region of space');
                          gotoxy(30,25);write('that you want to save');
                          textcolor(14);gotoxy(22,27);write('The frame is not included in the area');
                          textcolor(7);gotoxy(29,31);write('"h" to hide this promt');
                          end
                          else
                          begin
                          for i:=22 to 32 do
                            for j:=19 to 61 do
                               setta(j,i);
                          end;
          end;

procedure contorno6(x,y:integer;b:boolean;c:integer);                        //se b "FALSA" allora oscura al contrario colora
          begin
          textcolor(c);
          gotoxy(x-1,y-1);if(b)then write(chr(201),chr(205),chr(205),chr(205),chr(187)) else write('     ');
          gotoxy(x-1,y);if(b)then write(chr(186)) else write(' ');gotoxy(x+3,y);if(b)then write(chr(186)) else write(' ');
          gotoxy(x-1,y+1);if(b)then write(chr(186)) else write(' ');gotoxy(x+3,y+1);if(b)then write(chr(186)) else write(' ');
          gotoxy(x-1,y+2);if(b)then write(chr(200),chr(205),chr(205),chr(205),chr(188)) else write('     ');
          end;
procedure contorno1(x,y:integer;b:boolean;c:integer);
          begin
          textcolor(c);
          gotoxy(x-1,y-1);if(b)then write(chr(218),chr(196),chr(191)) else write('   ');
          gotoxy(x-1,y);if(b)then write(chr(179)) else write(' ');gotoxy(x+1,y);if(b)then write(chr(179))else write(' ');
          gotoxy(x-1,y+1);if(b)then write(chr(192),chr(196),chr(217)) else write('   ');
          end;

function DRettangoloPieno(var m:integer;x1,y1,x2,y2:integer;var TAB:tabella):oggetto;
         var i,j:integer;
         begin
         m:=0;
         TAB:=cancTab;
         if(x1>x2)then scambia(x1,x2); if(y1>y2)then scambia(y1,y2);
         for i:=x1 to x2 do
             for j:=y1 to y2 do
                 begin
                 incr(DRettangoloPieno,m,i,j);
                 TAB[i,j]:=true;
                 end;
         end;

function DRettangolo(var m:integer;x1,y1,x2,y2:integer):oggetto;
          var i:integer;
          begin
          m:=0;
          corniceTab:=cancTab;
          if(y1>y2)then
                   scambia(y1,y2);
          if(x1>x2)then
                   scambia(x1,x2);
          for i:=y1 to y2 do
                begin
                incr(DRettangolo,m,x1,i);incr(DRettangolo,m,x2,i);
                corniceTab[x1,i]:=true;
                corniceTab[x2,i]:=true;
                end;
          for i:=x1 to x2 do
                begin
                incr(DRettangolo,m,i,y1);incr(DRettangolo,m,i,y2);
                corniceTab[i,y1]:=true;
                corniceTab[i,y2]:=true;
                end;
          end;

function Dcerchio(x,y,r:integer;h:real;var m:integer;var A:tabella):oggetto;
     var  x2,y2,i:integer;                                                        //il raggio prende in considerazione solo l' asse delle " X "
     begin                                                                        // H < 1 =  verticale
     m:=0;
     A:=cancTab;
     for i:=1 to 7000 do
              begin
              x2:=round(x+(COS(i/1000)*r*h));
              y2:=round(y+(SIN(i/1000)*r*2/3/h));
              if((x2>0)and(x2<81)and(y2>0)and(y2<120))then
                 if(not A[x2,y2])then
                      begin
                      incr(Dcerchio,m,x2,y2);
                      A[x2,y2]:=true
                      end
              end;
     end;

function  Dretta(x1,y1,x2,y2:integer;var m:integer;var A:tabella):oggetto;
          var i,j,kn,kd,y,ma:integer;
          begin
          m:=0;
          if(x1>x2)then
                   begin
                   scambia(x1,x2);
                   scambia(y1,y2);
                   end;
          kd:=x2-(x1-1);
          if(y1>=y2)then
                    kn:=y1-(y2-1)
                    else
                    kn:=y1-(y2+1);
          ma:=y1;
          incr(Dretta,m,x1,y1);
          for i:=1 to kd do
              begin
              y:=y1-((i*kn)div kd);
              if(abs(y-ma)>1)then
                   if(ma<y)then
                           for j:=ma+1 to y-1 do
                               incr(Dretta,m,(x1+i)-1,j)
                           else
                           for j:=y+1 to ma-1 do
                               incr(Dretta,m,(x1+i)-1,j);
              if not((y=(y1-kn))and(i<>kd-1)) then
                    begin
                    if(Dretta[m,2]<>y)then
                             incr(Dretta,m,(x1+i)-1,y);
                    incr(Dretta,m,x1+i,y);
                    end;
              ma:=y;
              end;
          A:=cancTab;
          for i:=1 to m do
              A[Dretta[i,1],Dretta[i,2]]:=true;
          end;

function DGriglia(var m,x,y,l,h:integer):oggetto;
         var i,j,z:integer;
         function caratt(n:integer):char;
                  begin
                  if(nGrid=3)then
                                caratt:=text
                                else
                                caratt:=CHGrid[nGrid,n]
                  end;
         begin
         for i:=1 to 10000 do
         OGGGrid[i]:=chr(0);
         for i:=1 to 80 do
            for j:=1 to 80 do
                TABGrid[i,j]:=0;
         m:=0;
         l:=1+((lcella+1)*ncolonne);
         h:=1+((hcella+1)*nrighe);
         x:=((80-l)div 2)+1;
         if(h>50)then
           y:=((80-h)div 2)+1
           else
           y:=20;
         incr(DGriglia,m,x,y);OGGGrid[m]:=caratt(1);TABGrid[x,y]:=m;
         incr(DGriglia,m,x+l-1,y);OGGGrid[m]:=caratt(2);TABGrid[x+l-1,y]:=m;
         incr(DGriglia,m,x,y+h-1);OGGGrid[m]:=caratt(4);TABGrid[x,y+h-1]:=m;
         incr(DGriglia,m,x+l-1,y+h-1);OGGGrid[m]:=caratt(3);TABGrid[x+l-1,y+h-1]:=m;
         for i:=0 to ncolonne-1 do
            for z:=(x+1+i+(i*lcella)) to (x+i+lcella+(i*lcella)) do
               for j:=0 to nrighe do
                     begin
                     incr(DGriglia,m,z,(y+j+(j*hcella)));
                     OGGGrid[m]:=caratt(10);
                     TABGrid[z,(y+j+(j*hcella))]:=m
                     end;
         for i:=0 to nrighe-1 do
            for z:=(y+1+i+(i*hcella)) to (y+i+hcella+(i*hcella)) do
               for j:=0 to ncolonne do
                     begin
                     incr(DGriglia,m,(x+j+(j*lcella)),z);
                     OGGGrid[m]:=caratt(11);
                     TABGrid[(x+j+(j*lcella)),z]:=m
                     end;
         for i:=1 to ncolonne-1 do
                     begin
                     incr(DGriglia,m,(x+i+(i*lcella)),y);
                     OGGGrid[m]:=caratt(5);
                     TABGrid[(x+i+(i*lcella)),y]:=m;
                     incr(DGriglia,m,(x+i+(i*lcella)),y+h-1);
                     OGGGrid[m]:=caratt(7);
                     TABGrid[(x+i+(i*lcella)),y+h-1]:=m;
                     for j:=1 to nrighe-1 do
                         begin
                         incr(DGriglia,m,(x+i+(i*lcella)),(y+j+(j*hcella)));
                         OGGGrid[m]:=caratt(9);
                         TABGrid[(x+i+(i*lcella)),(y+j+(j*hcella))]:=m;
                         end;
                     end;
         for i:=1 to nrighe-1 do
                     begin
                     incr(DGriglia,m,x,(y+i+(i*hcella)));
                     OGGGrid[m]:=caratt(8);
                     TABGrid[x,(y+i+(i*hcella))]:=m;
                     incr(DGriglia,m,x+l-1,(y+i+(i*hcella)));
                     OGGGrid[m]:=caratt(6);
                     TABGrid[x+l-1,(y+i+(i*hcella))]:=m;
                     end;
         end;

function DSecchio(var m:integer;TAB:Tabinteger;x,y:integer;var A:tabella):oggetto;
         var md,mp,n,i,j,z:integer;
             D,P:oggetto;
         begin
         md:=0;
         m:=0;
         incr(D,md,x,y);
         n:=TAB[x,y];
         A:=cancTab;
         A[x,y]:=true;
         repeat
         P:=D; mp:=md;
         md:=0;
         for i:=1 to mp do
             begin
             for j:=-1 to 1 do
                for z:=-1 to 1 do
                   if(abs(j+z)=1)then
                      if((TAB[P[i,1]+j,P[i,2]+z]=n)and(not A[P[i,1]+j,P[i,2]+z]))then
                         if(((j+z=1)and(P[i,1+abs(z)]<81))or((j+z=-1)and(P[i,1+abs(z)]>0)))then
                               begin
                               A[P[i,1]+j,P[i,2]+z]:=true;
                               incr(D,md,P[i,1]+j,P[i,2]+z);
                               end;
             end;
         until(md=0);
         for i:=1 to 80 do
           for j:=1 to 80 do
               if(A[j,i])then
               incr(DSecchio,m,j,i);
         end;

function DTitolo(var m:integer;x1,y1,x2,y2:integer;var s:string;var A:tabella):oggetto;
         var i,j,k,z,w,ww,zz,mParole,mFrasi,n,lpar,xfrase,yfrase,finefrase,itronco,itro,dime:integer;
             PAROLE:parol;
             LPAROLE:lparol;
             FRASI:array[1..50,1..3]of integer;         // 1 = parola di inizio ; 2 = parola di fine ; 3 = lunghezza frase
             larghezza,altezza:integer;
             spar:string;
             x:boolean;
         label casoFine;
         function lung(c:char):integer;
                  begin
                  case c of
                    'i','!' : lung:=2;
                    'm','v','w' : lung:=8;
                    'n','q','x' : lung:=7;
                    '''' : lung:=3;
                    else
                    lung:=6;
                    end;
                  end;
         begin
         larghezza:=x2-x1+1;
         altezza:=y2-y1+1;
         if(dimensione=3)then
                         dime:=2
                         else
                         dime:=1;
         for i:=1 to 300 do
             begin
             PAROLE[i]:='';
             LPAROLE[i]:=0;
             end;
         A:=cancTab;
         m:=0;
         mParole:=1;
         while(s[1]=' ')do
              delete(s,1,1);
         for i:=1 to length(s) do
               if(s[i]=' ')then
                           begin
                           if(s[i-1]<>' ')then
                                          mParole:=mParole+1
                                          else
                                          begin
                                          delete(s,i,1);
                                          i:=i-1;
                                          end;
                           end
                           else
                           begin
                           PAROLE[mParole]:=PAROLE[mParole]+s[i];
                           if(length(PAROLE[mParole])>1)then
                                                         LPAROLE[mParole]:=LPAROLE[mParole]+1+Dimensione;
                           LPAROLE[mParole]:=LPAROLE[mParole]+(lung(s[i])*Dime);
                           end;
         if(s[length(s)]=' ')then  mParole:=mParole-1;
         mFrasi:=1;
         FRASI[1,1]:=1;  FRASI[1,2]:=0;
         FRASI[1,3]:=0-4-Dimensione;
         finefrase:=0;
         i:=1;
         while (i<=mParole) do
                 begin
                 if(FRASI[mFrasi,3]+4+Dimensione+LPAROLE[i]<=larghezza)then
                                  begin
                                  FRASI[mfrasi,3]:=FRASI[mFrasi,3]+4+Dimensione+LPAROLE[i];
                                  FRASI[mFrasi,2]:=FRASI[mFrasi,2]+1;
                                  end
                                  else
                                  begin
                                  if(LPAROLE[i]>larghezza)then
                                                          begin
                                                          if((FRASI[mFrasi,3]+4+Dimensione+(lung(PAROLE[i][1])*Dime))>larghezza)then
                                                                           if(mFrasi<righee)then
                                                                                begin
                                                                                mFrasi:=mFrasi+1;
                                                                                FRASI[mFrasi,1]:=i;  FRASI[mFrasi,2]:=i-1;
                                                                                FRASI[mfrasi,3]:=0-4-Dimensione;
                                                                                end
                                                                                else
                                                                                begin
                                                                                finefrase:=i-1;
                                                                                goto casoFine;
                                                                                end;
                                                          lpar:=LPAROLE[i];
                                                          spar:=PAROLE[i];  //FRASI[mFrasi,3]+4+Dimensione+lpar-(lung(spar[length(spar)])*Dimensione)-1-Dimensione)
                                                          while((FRASI[mFrasi,3]+3+lpar-(lung(spar[length(spar)])*Dime))>larghezza)do           // il calcolo dello spazio tra le lettere è già stato fatto
                                                                                 begin
                                                                                 lpar:=lpar-(lung(spar[length(spar)])*Dime)-1-Dimensione;
                                                                                 delete(spar,length(spar),1);
                                                                                 end;
                                                          lpar:=lpar-(lung(spar[length(spar)])*Dime)-1-Dimensione;
                                                          delete(spar,length(spar),1);

                                                          for j:=mParole downto i+1 do
                                                              begin
                                                              LPAROLE[j+1]:=LPAROLE[j];
                                                              PAROLE[j+1]:=PAROLE[j];
                                                              end;
                                                          mParole:=mParole+1;
                                                          LPAROLE[i+1]:=LPAROLE[i]-lpar-1-Dimensione;
                                                          PAROLE[i+1]:=copy(PAROLE[i],length(spar)+1,length(PAROLE[i])-length(spar));
                                                          LPAROLE[i]:=lpar;
                                                          PAROLE[i]:=spar;

                                                          FRASI[mfrasi,3]:=FRASI[mfrasi,3]+4+Dimensione+LPAROLE[i];
                                                          FRASI[mFrasi,2]:=FRASI[mFrasi,2]+1;
                                                          end
                                                          else
                                                          if(mFrasi<righee)then
                                                                           begin
                                                                           mFrasi:=mFrasi+1;
                                                                           FRASI[mFrasi,1]:=i;  FRASI[mFrasi,2]:=i;
                                                                           FRASI[mfrasi,3]:=LPAROLE[i];
                                                                           end
                                                                           else
                                                                           begin
                                                                           if((FRASI[mFrasi,3]+4+Dimensione+(lung(PAROLE[i][1])*Dime))<=larghezza)then
                                                                           begin
                                                                           lpar:=LPAROLE[i];
                                                                           spar:=PAROLE[i];  //FRASI[mFrasi,3]+4+Dimensione+lpar-(lung(spar[length(spar)])*Dimensione)-1-Dimensione)
                                                                           while((FRASI[mFrasi,3]+3+lpar-(lung(spar[length(spar)])*Dime))>larghezza)do           // il calcolo dello spazio tra le lettere è già stato fatto
                                                                                 begin
                                                                                 lpar:=lpar-(lung(spar[length(spar)])*Dime)-1-Dimensione;
                                                                                 delete(spar,length(spar),1);
                                                                                 end;
                                                                           lpar:=lpar-(lung(spar[length(spar)])*Dime)-1-Dimensione;
                                                                           delete(spar,length(spar),1);
                                                                           LPAROLE[i]:=lpar;
                                                                           PAROLE[i]:=spar;
                                                                           FRASI[mfrasi,3]:=FRASI[mfrasi,3]+4+Dimensione+LPAROLE[i];
                                                                           FRASI[mFrasi,2]:=FRASI[mFrasi,2]+1;
                                                                           i:=i+1;
                                                                           end;
                                                                           finefrase:=i-1;
                                                                           goto casoFine;
                                                                           end;
                                  end;
                  i:=i+1;
                  end;
          casoFine:
          n:=0;
          if(fineFrase<>0)then
                 begin
                 itronco:=0;
                 itro:=0;
                 for i:=1 to finefrase do
                       itronco:=itronco+length(PAROLE[i]);
                 i:=1;
                 itro:=1;
                 while(i<=itronco)do
                       begin
                       if(s[itro]=' ')then i:=i-1;
                       itro:=itro+1;
                       i:=i+1;
                       end;
                 delete(s,itro,length(s)-itro+1);
                 end;
          for i:=1 to mFrasi do
              begin
              if(Layout)then
                        xfrase:=((larghezza-FRASI[i,3])div 2)+x1
                        else
                        xfrase:=x1;
              yfrase:=y1+((i-1)*(5*Dimensione+sprighe));
              for k:=FRASI[i,1] to FRASI[i,2] do
                     begin
                     for j:=1 to length(PAROLE[k]) do
                              begin
                              x:=false;
                              if((ord(PAROLE[k][j])<123)and(ord(PAROLE[k][j])>96))then
                                         n:=ord(PAROLE[k][j])-87
                              else
                              if((ord(PAROLE[k][j])<58)and(ord(PAROLE[k][j])>48))then
                                         n:=ord(PAROLE[k][j])-48
                                         else
                                         if((ord(PAROLE[k][j])<91)and(ord(PAROLE[k][j])>64))then
                                         n:=ord(PAROLE[k][j])-55
                                         else
                                          if(PAROLE[k][j]='''')then
                                                 n:=38
                                                 else
                                                 if(PAROLE[k][j]='0')then
                                                 n:=24
                                                 else
                                                 if(PAROLE[k][j]='!')then
                                                 n:=36
                                                 else
                                                 if(PAROLE[k][j]='?')then
                                                       n:=37
                                                       else
                                                       x:=true;
                               if(x=false)then
                                             for w:=1 to length(Ap[1,n]) do
                                                for z:=1 to 5 do
                                                   begin
                                                   if(Ap[z,n][w]='*')then
                                                       for ww:=0 to Dime-1 do
                                                           for zz:=0 to Dimensione-1 do
                                                                 begin
                                                                 incr(DTitolo,m,xfrase+ww,(YFrase-1)+(z*Dimensione)-zz);
                                                                 A[xfrase+ww,(YFrase-1)+(z*Dimensione)-zz]:=true;
                                                                 end;
                                                   if(z=5)then  xFrase:=xFrase+Dime;
                                                   end;
                               if(j<>length(PAROLE[k]))then
                                          xfrase:=xfrase+1+Dimensione
                               end;
                     if(k<>FRASI[i,2])then
                                      xfrase:=xfrase+4+Dimensione

                     end;


             end;
           end;



procedure DisegnaEccetto(x1,y1,x2,y2:integer);
          var i,j:integer;
          begin
          if(strumento<>4)then
          for i:=1 to 80 do
              for j:=1 to 120 do
                  if((gostTab[i,j])and(strumento<>5))then
                      if(not((i>=x1)and(i<=x2)and(j>=y1)and(j<=y2)))then
                           colora(i,j);

          end;

function inputColor():char;
          var i,j,x,y,v,n,c,g:integer;
              s,t:char;
          function co(x,y:integer):integer;
                   begin
                   co:=(y div 4)+((4*x)div 3)-11;
                   end;
          begin
          if(strumento=8)then
                        n:=1
                        else
                        n:=0;
          textbackground(0);
          textcolor(15);
          for i:=10 to 43 do
             begin
             textcolor(15);
             gotoxy(3,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(20);
             if(not (i=43))then    begin gotoxy(4,i+n);write('             '); end;
             if(((i-3)mod 4 =0)and(not (i=11)))then
                         for j:=1 to 2 do
                             begin
                             textcolor(co(j*6,i-3));gotoxy(j*6,i-3+n);
                             write(chr(219),chr(219),chr(219));gotoxy(j*6,i-2+n);
                             write(chr(219),chr(219),chr(219));contorno6(j*6,i-3+n,true,7);
                             end;
             end;
          if(strumento=8)then
                         begin
                         gotoxy(4,8);textcolor(9);write(chr(4));
                         gotoxy(4,9);textcolor(12);write(chr(4));
                         x:=(color1 div 8)*6+6;
                         y:=(4*color1)-((color1 div 8)*32)+12;
                         end
                         else
                         begin
                         x:=(color div 8)*6+6;
                         y:=(4*color)-((color div 8)*32)+12;
                         end;
          for i:=1 to 1+n do
          begin
          textbackground(0);
          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 contorno6(x,y+n,false,12+(-6*n+3*i));
                 v:=2;
                 end;
          if(v=10)then
                  contorno6(x,y+n,true,12+(-6*n+3*i));
          delay(24);
          until(keypressed);
          if((i=2)and(co(x,y)=color1))then
                                      contorno6(x,y+n,true,9)
                                      else
                                      contorno6(x,y+n,true,7);
          s:=readkey;
          until(qtasto('cbpt78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((qtasto('741qaz'+chr(75),s))and(x>6))then
                            x:=x-6;
          if((qtasto('963edx'+chr(77),s))and(x<12))then
                            x:=x+6;
          if((qtasto('789qwe'+chr(72),s))and(y>12))then
                            y:=y-4;
          if((qtasto('123zsx'+chr(80),s))and(y<40))then
                            y:=y+4;
          until(not qtasto('78941236qazxdews'+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((s='t')or(s='p')or(s='b'))then i:=2;
          if(s=chr(13))then
                       begin
                       c:=co(x,y);
                       if(strumento<>8)then
                                       begin
                                       g:=ground;
                                       t:=text;
                                       end
                                       else
                                       if(i=1)then
                                              begin
                                              g:=ground1;
                                              t:=text1;
                                              end
                                              else
                                              begin
                                              g:=ground2;
                                              t:=text2;
                                              end;
                       textcolor(c);
                       gotoxy(9+(6*i-3*n-6),5);textcolor(c);write(chr(219),chr(219),chr(219));
                       gotoxy(9+(6*i-3*n-6),6);write(chr(219),chr(219),chr(219));
                       if(i<2)then begin gotoxy(5,8);write('           ');end; if(i=2)then begin gotoxy(5,9);write('           '); end;
                       gotoxy(4+(13-(length(nomiColori[c])))div 2,8+i-1);textcolor(15);write(nomiColori[c]);
                       gotoxy(47,5+2*i-2);textcolor(c);textbackground(g);write(t);textbackground(0);write(' ');
                       if(strumento<>8)then
                                       color:=c
                                       else
                                       if(i=1)then
                                              begin
                                              contorno6(x,y+n,true,9);
                                              color1:=c;
                                              end
                                              else
                                              begin
                                              contorno6(x,y+n,true,12);
                                              color2:=c;
                                              end;
                       end;
          x:=(color2 div 8)*6+6;
          y:=(4*color2)-((color2 div 8)*32)+12;
          DisegnaEccetto(3,10,17,43+n);
          end;
          textbackground(0);
          textcolor(15);
          for i:=43 downto 10 do
             begin
             textcolor(15);
             gotoxy(3,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(12);
             for j:=3 to 17 do
                   if(strumento=4)then
                   if(corniceTab[j,i])then
                    begin
                    if (((i+nylamp)mod 3=0)and((j+nxlamp)mod 4=0))then
                                 colora(j,i)
                                 else
                                 if(gotoxyb(j,i))then
                                     begin
                                     textcolor(inverticolori(schermata[j,i].color));
                                     textbackground(inverticolori(schermata[j,i].ground));
                                     write(schermata[j,i].text);
                                     end;
                     end
                     else
                     Setta(j,i)
                     else
                     Setta(j,i+n);
             end;
          textbackground(0);
          if(strumento=8)then
                         begin
                         gotoxy(4,8);write(' ');
                         gotoxy(4,9);write(' ');
                         end;
          pulisci;
          if(s='c')then
                   s:=chr(13);
          inputColor:=s;
          end;

function  inputBackground():char;
          var i,j,x,y,v,n,c,g:integer;
              s,t:char;
          function co(x,y:integer):integer;
                   begin
                   co:=(((x-17)div 3)*2)+(y div 4)-7;
                   end;
          begin
          if(strumento=8)then
                        n:=1
                        else
                        n:=0;
          textbackground(0);
          textcolor(15);
          for i:=10 to 27 do
             begin
             textcolor(15);
             gotoxy(20,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(20);
             if(not (i=27))then    begin textbackground(0);gotoxy(21,i+n);write('             '); end;
             if(((i-3)mod 4 =0)and(not (i=11)))then
                         for j:=1 to 2 do
                             begin
                             textbackground(co((j*6)+17,i-3));gotoxy((j*6)+17,i-3+n);write('   ');
                             gotoxy((j*6)+17,i-2+n);write('   ');textbackground(0);contorno6((j*6)+17,i-3+n,true,7);
                             end;
             end;
          textbackground(0);
          if(strumento=8)then
                         begin
                         gotoxy(21,8);textcolor(9);write(chr(4));
                         gotoxy(21,9);textcolor(12);write(chr(4));
                         x:=(6*((ground1 div 4)+1))+17;
                         y:=(4*ground1)-((ground1 div 4)*16)+12;
                         end
                         else
                         begin
                         x:=(6*((ground div 4)+1))+17;
                         y:=(4*ground)-((ground div 4)*16)+12;
                         end;
          for i:=1 to 1+n do
          begin
          textbackground(0);
          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 contorno6(x,y+n,false,12+(-6*n+3*i));
                 v:=2;
                 end;
          if(v=10)then
                  contorno6(x,y+n,true,12+(-6*n+3*i));
          delay(24);
          until(keypressed);
          if((i=2)and(co(x,y)=ground1))then
                                      contorno6(x,y+n,true,9)
                                      else
                                      contorno6(x,y+n,true,7);
          s:=readkey;
          until(qtasto('cbpt78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((qtasto('741qaz'+chr(75),s))and(x>23))then
                            x:=x-6;
          if((qtasto('963edx'+chr(77),s))and(x<29))then
                            x:=x+6;
          if((qtasto('789qwe'+chr(72),s))and(y>12))then
                            y:=y-4;
          if((qtasto('123zsx'+chr(80),s))and(y<24))then
                            y:=y+4;
          until(not qtasto('78941236qazxdews'+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((s='t')or(s='c')or(s='p'))then i:=2;
          if(s=chr(13))then
                       begin
                       g:=co(x,y);
                       if(strumento<>8)then
                                       begin
                                       c:=color;
                                       t:=text;
                                       end
                                       else
                                       if(i=1)then
                                              begin
                                              c:=color1;
                                              t:=text1;
                                              end
                                              else
                                              begin
                                              c:=color2;
                                              t:=text2;
                                              end;
                       textbackground(g);
                       gotoxy(26+(6*i-3*n-6),5);write('   ');
                       gotoxy(26+(6*i-3*n-6),6);write('   ');
                       textbackground(0);
                       if(i<2)then begin gotoxy(22,8);write('           ');end; if(i=2)then begin gotoxy(22,9);write('           '); end;
                       gotoxy(21+(13-(length(nomiColori[g])))div 2,8+i-1);textcolor(15);write(nomiColori[g]);
                       gotoxy(47,5+2*i-2);textcolor(c);textbackground(g);write(t);textbackground(0);write(' ');
                       if(strumento<>8)then
                                       ground:=g
                                       else
                                       if(i=1)then
                                              begin
                                              contorno6(x,y+n,true,9);
                                              ground1:=g;
                                              end
                                              else
                                              begin
                                              contorno6(x,y+n,true,12);
                                              ground2:=g;
                                              end;
                      end;
          x:=(6*((ground2 div 4)+1))+17;
          y:=(4*ground2)-((ground2 div 4)*16)+12;
          DisegnaEccetto(20,10,34,27+n);
          end;
          textbackground(0);
          textcolor(15);
          for i:=27 downto 10 do
             begin
             textcolor(15);
             gotoxy(20,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(12);
             for j:=20 to 34 do
             if(strumento=4)then
                   if(corniceTab[j,i])then
                    begin
                    if (((i+nylamp)mod 3=0)and((j+nxlamp)mod 4=0))then
                                 colora(j,i)
                                 else
                                 if(gotoxyb(j,i))then
                                     begin
                                     textcolor(inverticolori(schermata[j,i].color));
                                     textbackground(inverticolori(schermata[j,i].ground));
                                     write(schermata[j,i].text);
                                     end;
                     end
                     else
                     Setta(j,i)
                     else
              Setta(j,i+n);
             end;
          textbackground(0);
          if(strumento=8)then
                         begin
                         gotoxy(21,8);write(' ');
                         gotoxy(21,9);write(' ');
                         end;
          pulisci;
          if(s='b')then
                   s:=chr(13);
          inputBackground:=s;
          end;

function  inputItems():char;
          var i,j,z,x,y,v,n,c,g:integer;
              s,t:char;
              b:boolean;
          begin
          if(strumento=8)then
                        n:=1
                        else
                        n:=0;
          textbackground(0);
          textcolor(15);
          for i:=10 to 44 do
             begin
             textcolor(15);
             gotoxy(37,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(20);
             if(not (i=44))then    begin textbackground(0);gotoxy(38,i+n);write('             '); end;
             if(((i-2)mod 3 =0)and(not (i=11)))then
                         for j:=1 to 3 do
                             begin
                             contorno1((j*4)+36,i-2+n,true,7);
                             textcolor(15);gotoxy((j*4)+36,i-2+n);write(car[j,(i div 3)-3]);
                             end;
             end;

          textbackground(0);
          if(strumento=8)then
                         begin
                         gotoxy(39,5);textcolor(9);write(chr(4));
                         gotoxy(39,7);textcolor(12);write(chr(4));
                         t:=text1
                         end
                         else
                         t:=text;
          b:=false;
          for i:=1 to 3 do
             for j:=1 to 11 do
                 if(t=car[i,j])then
                       begin
                       x:=(i*4)+36;
                       y:=(j*3)+9;
                       b:=true;
                       end;
          if(not b)then
                   begin
                   t:=car[1,2];
                   x:=40;
                   y:=15;
                   end;
          for i:=1 to 1+n do
          begin
          textbackground(0);
          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 contorno1(x,y+n,true,11-5*n+3*i);
                 textcolor(15);gotoxy(x,y+n);write(car[(x-36)div 4,(y div 3)-3]);
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  contorno1(x,y+n,false,11-5*n+3*i);
                  textcolor(15);gotoxy(x,y+n);write(car[(x-36)div 4,(y div 3)-3]);
                  end;
          delay(22);
          until(keypressed);
          if((i=2)and(car[(x-36)div 4,(y div 3)-3]=text1))then
                                      contorno1(x,y+n,true,9)
                                      else
                                      contorno1(x,y+n,true,7);

          textcolor(15);gotoxy(x,y+n);write(car[(x-36)div 4,(y div 3)-3]);
          s:=readkey;
          until(qtasto('cbpt78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((qtasto('741qaz'+chr(75),s))and(x>40))then
                            x:=x-4;
          if((qtasto('963edx'+chr(77),s))and(x<48))then
                            x:=x+4;
          if((qtasto('789qwe'+chr(72),s))and(y>12))then
                            y:=y-3;
          if((qtasto('123zsx'+chr(80),s))and(y<42))then
                            y:=y+3;
          until(not qtasto('78941236qazxdews'+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((s='t')or(s='c')or(s='b'))then i:=2;
          if(s=chr(13))then
                       begin
                       t:=car[(x-36)div 4,(y div 3)-3];
                       if(strumento<>8)then
                                       begin
                                       c:=color;
                                       g:=ground;
                                       end
                                       else
                                       if(i=1)then
                                              begin
                                              c:=color1;
                                              g:=ground1;
                                              end
                                              else
                                              begin
                                              c:=color2;
                                              g:=ground2;
                                              end;
                       textbackground(0);
                       //gotoxy(38,8-n);write('           ');
                       textcolor(15);gotoxy(41,5+2*i-2);write(t,' --> ');textcolor(c);
                       textbackground(g);write(t);textbackground(0);write(' ');
                       textcolor(15);gotoxy(41+4*i-2*n,7+n*2);if(ord(t)<10)then write(' ');write(ord(t));if(ord(t)<100)then write(' ');
                       if(strumento<>8)then
                                       text:=t
                                       else
                                       if(i=1)then
                                              begin
                                              contorno1(x,y+n,true,9);
                                              text1:=t;
                                              end
                                              else
                                              begin
                                              contorno1(x,y+n,true,12);
                                              text2:=t;
                                              end;
                      end;
          for z:=1 to 3 do
             for j:=1 to 11 do
                 if(text2=car[z,j])then
                       begin
                       x:=(z*4)+36;
                       y:=(j*3)+9;
                       end;
          DisegnaEccetto(37,10,51,44+n);
          end;
          textbackground(0);
          if(strumento=8)then
                         begin
                         gotoxy(39,5);write(' ');
                         gotoxy(39,7);write(' ');
                         end;
          textcolor(15);
          for i:=44 downto 10 do
             begin
             textcolor(15);
             gotoxy(37,i+n);write(chr(219));for j:=1 to 13 do write(chr(220));write(chr(219));
             delay(11);
             for j:=37 to 51 do
             if(strumento=4)then
                   if(corniceTab[j,i])then
                    begin
                    if (((i+nylamp)mod 3=0)and((j+nxlamp)mod 4=0))then
                                 colora(j,i)
                                 else
                                 if(gotoxyb(j,i))then
                                     begin
                                     textcolor(inverticolori(schermata[j,i].color));
                                     textbackground(inverticolori(schermata[j,i].ground));
                                     write(schermata[j,i].text);
                                     end;
                     end
                     else
                     Setta(j,i)
                     else
              Setta(j,i+n);
             end;
          pulisci;
          if(s='p')then
                   s:=chr(13);
          inputItems:=s;
          end;

function incolla(s:char):char;
          var i,j,z,xx,yy,xmin,ymin,spx,spy,xmax,ymax:integer;
              tab:array[-1..81,-1..81]of integer;
          begin
          if((ord(s)<91)and(ord(s)>64))then
             s:=chr(ord(s)+32);
          if(s='£')then nim:=27
                        else
                        nim:=nTastiera(s);
          if(ImmagineLHM[nim,1]>0)then
          begin
          xx:=(x-(ImmagineLHM[nim,1] div 2))+abs((((x-(ImmagineLHM[nim,1] div 2))-1)-abs((x-(ImmagineLHM[nim,1] div 2))-1))div 2)+((80-(x+ImmagineLHM[nim,1]-(ImmagineLHM[nim,1] div 2)))-abs(80-(x+ImmagineLHM[nim,1]-(ImmagineLHM[nim,1] div 2))))div 2;
          yy:=(y-(ImmagineLHM[nim,2] div 2))+abs((((y-(ImmagineLHM[nim,2] div 2))-1)-abs((y-(ImmagineLHM[nim,2] div 2))-1))div 2)+((80-(y+ImmagineLHM[nim,2]-(ImmagineLHM[nim,2] div 2)))-abs(80-(y+ImmagineLHM[nim,2]-(ImmagineLHM[nim,2] div 2))))div 2;
          if(xx=0)then xx:=1;
          if(yy=0)then yy:=1;
          xmin:=Immagine[nim,1].x;
          ymin:=Immagine[nim,1].y;
          xmax:=Immagine[nim,1].x;
          ymax:=Immagine[nim,1].y;
          for i:=1 to ImmagineLHM[nim,3] do
              begin
              if(Immagine[nim,i].x<xmin)then
                                      xmin:=Immagine[nim,i].x;
              if(Immagine[nim,i].y<ymin)then
                                      ymin:=Immagine[nim,i].y;
              if(Immagine[nim,i].x>xmax)then
                                      xmax:=Immagine[nim,i].x;
              if(Immagine[nim,i].y>ymax)then
                                      ymax:=Immagine[nim,i].y;
              end;
          if(s='£')then
                   begin
                   spostx1:=0;
                   sposty1:=0;
                   end
                   else
                   begin
                   spostx1:=xx-xmin;
                   sposty1:=yy-ymin;
                   end;

          for i:=-1 to 81 do
             for j:=-1 to 81 do
                 Tab[i,j]:=0;
          z:=0;
          for j:=1 to ImmagineLHM[nim,3] do
              if(Tab[Immagine[nim,j].x,Immagine[nim,j].y]=0)then
                       begin
                       z:=z+1;
                       for i:=1 to ImmagineLHM[nim,3] do
                          if((Immagine[nim,j].color=Immagine[nim,i].color)and(Immagine[nim,j].ground=Immagine[nim,i].ground)and(Immagine[nim,j].text=Immagine[nim,i].text))then
                             if(Tab[Immagine[nim,i].x,Immagine[nim,i].y]=0)then
                                      Tab[Immagine[nim,i].x,Immagine[nim,i].y]:=z;
                       end;
          for i:=1 to ImmagineLHM[nim,3] do
                                if(barra(Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1))then
                                                        begin
                                                        textcolor(Immagine[nim,i].color);
                                                        textbackground(Immagine[nim,i].ground);
                                                        gotoxy(Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1);
                                                        write(Immagine[nim,i].text);
                                                        end;
         repeat
         spx:=spostx1; spy:=sposty1;

         s:=attenditasto('78941236qazxdews'+chr(13)+chr(8)+chr(75)+chr(77)+chr(72)+chr(80));

         if((qtasto('741qaz'+chr(75),s))and((xmax+spostx1)>1))then spostx1:=spostx1-1;
         if((qtasto('963edx'+chr(77),s))and((xmin+spostx1)<80))then spostx1:=spostx1+1;
         if((qtasto('789qwe'+chr(72),s))and((ymax+sposty1)>1))then sposty1:=sposty1-1;
         if((qtasto('123zsx'+chr(80),s))and((ymin+sposty1)<80))then sposty1:=sposty1+1;

         if(not((spx=spostx1)and(spy=sposty1)))then
                            begin
                            for i:=1 to ImmagineLHM[nim,3] do
                                if(barra(Immagine[nim,i].x+spx,Immagine[nim,i].y+spy))then
                                    if((Immagine[nim,i].x+spx<81)and(Immagine[nim,i].x+spx>0)and(Immagine[nim,i].y+spy<81)and(Immagine[nim,i].y+spy>0))then
                                            if(Tab[Immagine[nim,i].x-(spostx1-spx),Immagine[nim,i].y-(sposty1-spy)]=0)then//if(not(OGGGrid[i]=OGGGrid[TABGrid[OGG[i,1]-(spostx-spx),OGG[i,2]-(sposty-spy)]]))then
                                                        setta(Immagine[nim,i].x+spx,Immagine[nim,i].y+spy);
                            for i:=1 to ImmagineLHM[nim,3] do
                                if(barra(Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1))then
                                   if((Immagine[nim,i].x+spostx1<81)and(Immagine[nim,i].x+spostx1>0)and(Immagine[nim,i].y+sposty1<81)and(Immagine[nim,i].y+sposty1>0))then
                                        if(Tab[Immagine[nim,i].x+(spostx1-spx),Immagine[nim,i].y+(sposty1-spy)]<>Tab[Immagine[nim,i].x,Immagine[nim,i].y])then//if(not(OGGGrid[i]=OGGGrid[TABGrid[OGG[i,1]+(spostx-spx),OGG[i,2]+(sposty-spy)]]))then
                                                        begin
                                                        textcolor(Immagine[nim,i].color);
                                                        textbackground(Immagine[nim,i].ground);
                                                        gotoxy(Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1);
                                                        write(Immagine[nim,i].text);
                                                        end;
                            end;
         until((s=chr(13))or(s=chr(8))or(s='t'));
         if(s=chr(13))then
                      begin
                      for i:=1 to ImmagineLHM[nim,3] do
                         if((Immagine[nim,i].x+spostx1<81)and(Immagine[nim,i].x+spostx1>0)and(Immagine[nim,i].y+sposty1<81)and(Immagine[nim,i].y+sposty1>0))then
                            begin
                            schermata[Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1].color:=Immagine[nim,i].color;
                            schermata[Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1].ground:=Immagine[nim,i].ground;
                            schermata[Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1].text:=Immagine[nim,i].text;
                            end;
                      end
                      else
                      for i:=1 to ImmagineLHM[nim,3] do
                            if((Immagine[nim,i].x+spostx1<81)and(Immagine[nim,i].x+spostx1>0)and(Immagine[nim,i].y+sposty1<81)and(Immagine[nim,i].y+sposty1>0))then
                                  setta(Immagine[nim,i].x+spostx1,Immagine[nim,i].y+sposty1);
          end;
          if(strumento=5)then
                         begin
                         Tabimgost:=cancTab;
                         for i:=1 to 80 do
                            for j:=1 to 80 do
                                 if(Tab[i,j]<>0)then
                                       Tabimgost[i+spostx1,j+sposty1]:=true;
                         end;
          if(s='t')then
                   incolla:='t'
                   else
                   incolla:='E';
          pulisci;
          end;


procedure fondiTab(TAB:tabella);
          var i,j:integer;
          begin
          for i:=1 to 120 do
              for j:=1 to 80 do
                  if(TAB[j,i])then
                         fondiPXL(j,i);
          end;

function  settaggio(s:char):char;
          begin
          if(qtasto('cpbt',s))then
                    begin
                    if(Hide)then
                            HideShow;
                    repeat
                    if(s='c')then
                             s:=inputColor
                             else
                             if(s='b')then
                                      s:=inputBackground
                                      else
                                      if(s='p')then
                                               s:=inputItems;
                    if(s='t')then
                             begin
                             if(strumento=5)then
                                            begin
                                            FondiTab(gostTab);
                                            gostTab:=cancTab;
                                            end
                                            else
                             for i:=1 to 80 do
                                 for j:=1 to 80 do
                                    if(gostTab[i,j])then
                                            begin
                                            gostTab[i,j]:=false;
                                            setta(i,j);
                                            end;
                             if(strumento<>4)then
                             goto casoInputTools;
                             end;
                    until((s=chr(13))or(s='t'));
                    if(s=chr(13))then
                          s:='E';
                    end;
          settaggio:=s;
          end;

procedure seHideShowCIB(OGG:oggetto;m:integer;s:char);
          var i:integer;
          begin
          if((ord(s)<91)and(ord(s)>64))then
                                            begin
                                            gostTab:=cancTab;
                                            for i:=1 to m do
                                                gostTab[OGG[i,1],OGG[i,2]]:=true;
                                            incolla(s);
                                            gostTab:=cancTab;
                                            end;
          if(s='h')then
                  begin
                  gostTab:=cancTab;
                  for i:=1 to m do
                       gostTab[OGG[i,1],OGG[i,2]]:=true;
                  HideShow;
                  gostTab:=cancTab;
                  end;
          if(qtasto('cpb',s))then
                            begin
                            gostTab:=cancTab;
                            for i:=1 to m do
                                gostTab[OGG[i,1],OGG[i,2]]:=true;
                            settaggio(s);
                            gostTab:=cancTab;
                            end;
          end;
function  cursorColor(x,y:integer;n:integer):integer;
          var i,c:integer;
          begin
          i:=1;
          c:=schermata[x,y].color;
          while(((cursori[i]=c)or(cursori[i]=(sfondo+8)))and(i<5))do
                 i:=i+1;
          i:=i+n;
          if(i>4)then i:=2;
          cursorColor:=cursori[i];
          textcolor(cursorColor);
          end;



function  cursore(var x,y:integer;n:integer;s:string):char;
          var v,c,g,nn:integer;
              z,t:char;                                         // n indica il numero che viene sommatto al codice del colore proposto dalla funzione CursorColor
          begin
          bbim:=false;
          repeat                                                // la tabella indica quali caselle "TRUE" far semprare come già fuse nella schermata
          repeat
          v:=19;                                                // s indica i tasti che possono essere accettati dall' utente oltre agi altri
          repeat
          v:=v+1;
          if((v=20)and(barra(x,y)))then
                 begin
                 cursorColor(x,y,n);
                 gotoxy(x,y);
                 write(chr(219));
                 v:=1;
                 end;
          if(v=10)then
                 if(not gostTab[x,y])then
                        Setta(x,y)
                        else
                        begin
                        colora(x,y);
                        end;
          delay(20);
          until(keypressed);
                 if(not gostTab[x,y])then
                        Setta(x,y)
                        else
                        begin
                        colora(x,y);
                        end;
          cursore:=readkey;
          until(qtasto('cbp78941236qazxdewshr'+smTastiera+chr(8)+chr(13)+chr(0)+s,cursore));

          if(cursore='r')then
                         begin
                         c:=schermata[x,y].color;
                         g:=schermata[x,y].ground;
                         t:=schermata[x,y].text;

                         if(strumento=8)then
                                        begin
                                        nn:=attenzione(10,1,0,'Which character do you want change?','CHAR_1£1 CHAR_2£1');
                                        if(nn=1)then
                                               begin
                                               color1:=c;
                                               ground1:=g;
                                               text1:=t;
                                               end
                                               else
                                               begin
                                               color2:=c;
                                               ground2:=g;
                                               text2:=t;
                                               end;
                                        end
                                        else
                                        begin
                                        color:=c;
                                        ground:=g;
                                        text:=t;
                                        end;
                         if(not Hide)then
                                     begin
                                     Hide:=true;
                                     HideShow;
                                     end;
                         end;
          if((ord(cursore)<91)and(ord(cursore)>64))then
                      begin
                      bbim:=true;
                      cursore:=Incolla(cursore);
                      end;
          if(cursore=chr(0))then
                cursore:=readkey;
          muovi(cursore,x,y);
          ResetTools;
          if(cursore='h')then
                         HideShow;
          cursore:=settaggio(cursore);
          until(not qtasto('E78941236qazxdewsr'+chr(75)+chr(77)+chr(72)+chr(80),cursore));
          end;

procedure disegna(PTAB:tabella;var A:oggetto;var m:integer;c:char);
          var i:integer;
          begin                                                                       //PTAB indica le caselle "TRUE" da non far colorare, perchè già colorate
          if(not (c='a'))then
              begin
              if((strumento=2)or(title))then begin textbackground(sfondo); textcolor(0); end else begin textcolor(color); textbackground(ground) end;
              for i:=1 to m do
                    if((not PTAB[A[i,1],A[i,2]])or(not(seRettang(A[i,1],A[i,2],cacca))))then
                         colora(A[i,1],A[i,2]);
              end
              else
              for i:=1 to m do
              if((not PTAB[A[i,1],A[i,2]])or(not(seRettang(A[i,1],A[i,2],cacca))))then
                                     Setta(A[i,1],A[i,2]);
          end;

procedure fondi(var OGG:oggetto;m:integer);
               var i,j:integer;
               begin
               for i:=1 to m do
                        if(round(strumento)=8)then
                                 begin
                                 j:=OGG[i,1];
                                 if(x mod 2<>0)then
                                           j:=j+1;
                                 if(x>x2)then
                                           j:=j+1;
                                 if(sca(OGG[i,2],j)=0)then
                                               begin
                                               schermata[OGG[i,1],OGG[i,2]].color:=color1;
                                               schermata[OGG[i,1],OGG[i,2]].ground:=ground1;
                                               schermata[OGG[i,1],OGG[i,2]].text:=text1;
                                               end
                                               else
                                               begin
                                               schermata[OGG[i,1],OGG[i,2]].color:=color2;
                                               schermata[OGG[i,1],OGG[i,2]].ground:=ground2;
                                               schermata[OGG[i,1],OGG[i,2]].text:=text2;
                                               end;
                                 end
                                 else
                                 begin
                                 schermata[OGG[i,1],OGG[i,2]].color:=color;
                                 schermata[OGG[i,1],OGG[i,2]].ground:=ground;
                                 if((strumento=10)and(nRettang<4))then
                                                     schermata[OGG[i,1],OGG[i,2]].text:=(ch[nRettang,chrRettang(OGG[i,1],OGG[i,2],true)])
                                                     else
                                                     if(strumento=7)then
                                                             schermata[OGG[i,1],OGG[i,2]].text:=OGGGrid[TABGrid[OGG[i,1]-spostx,OGG[i,2]-sposty]]
                                                             else
                                                             schermata[OGG[i,1],OGG[i,2]].text:=(text);
                                 end;
               end;

 procedure Rett(x,y,l,h:integer);
          var j:integer;
          begin
          for j:=y to y+h-1 do
                   begin
                   gotoxy(x,j);
                   write(chr(219))
                   end;
            for j:=2 to l-1 do
                   begin
                   gotoxy(x+j-1,y);
                   write(chr(219));
                   gotoxy(x+j-1,y+h-1);
                   write(chr(219))
                   end;
            for j:=y to y+h-1 do
                   begin
                   gotoxy(x+l-1,j);
                   write(chr(219))
                   end;
          end;
          procedure quadratino(x,y,c:integer);
                    begin
                    if(c=16)then
                        begin
                        textcolor(9);
                        gotoxy(x,y);write(chr(219));textcolor(12);write(chr(219));textcolor(10);write(chr(219));
                        gotoxy(x,y+1);textcolor(13);write(chr(219));textcolor(14);write(chr(219));textcolor(15);write(chr(219));
                        end
                        else
                        begin
                        if(c>0)then
                            c:=c+8;
                        textcolor(c);
                        gotoxy(x,y);write(chr(219),chr(219),chr(219));
                        gotoxy(x,y+1);write(chr(219),chr(219),chr(219));
                        end;
                    end;

          procedure quadrato(x,y,nc:integer);
                    begin
                    textcolor(7);textbackground(0);
                    rettangolo(x,y,11,6,0);
                    textcolor(12);
                    if(nFeature=2)then
                             begin
                             gotoxy(x+3,39);write('COLOR');
                             end
                             else
                             begin
                             gotoxy(x+2,y+1);write('COLOR ',nc);
                             end;
                    quadratino(x+4,y+3,CFeature[nFeature,nc]);
                    end;

          procedure fascia();
                    var i,lol,nn,x,y:integer;
                    begin
                    if(nFeature=2)then
                                  begin x:=13; y:=38; end
                                  else
                                  if(n=0)then begin x:=10; y:=35; end
                                         else begin x:=10; y:=42; end;
                    textcolor(15);
                    rettangolo(x,y,11,6,0);
                    rettangolo(x+10,y,71-2*x,6,0);
                    nn:=8;
                    if x=13 then
                       nn:=7;
                    for i:=1 to nn do
                    begin
                    contorno6(7+x+6*i,y+2,true,7);
                    val(copy(sfumato[i-1],1,2),lol,cacca);
                    if(x<>13)then lol:=i-1;
                    quadratino(7+x+6*i,y+2,lol);
                    end;
                    end;
          function seleOpz():integer;
                   var v,i:integer;
                   begin
                   if(n<>1)then
                   if(nFeature=2)then
                                 n:=1
                                 else
                                 n:=0;
                   repeat
                   repeat
                   v:=19;
                   repeat
                   v:=v+1;
                   if(v=20)then
                           textcolor(14);
                   if(v=10)then
                           textcolor(15);
                   if(v mod 10=0)then
                   begin
                   if(n<2)then textbackground(0)
                                  else
                                  if(n=2)then textbackground(2)
                                         else textbackground(4);
                   case n of
                   1:begin
                     if(nFeature=2)then
                                   rettangolo(13,38,11,6,0)
                                   else
                                   rettangolo(10,42,11,6,0)
                     end;
                   0:rettangolo(10,35,11,6,0);
                   2:rettangolo(27,49,12,3,0);
                   3:rettangolo(43,49,12,3,0);
                   end;
                   if(v=20)then
                           v:=2;
                   end;
                   delay(22);
                   until(keypressed);
                   textcolor(7);
                   if(n<2)then textbackground(0)
                                  else
                                  if(n=2)then textbackground(2)
                                         else textbackground(4);
                   case n of
                   1:begin
                     if(nFeature=2)then
                                   rettangolo(13,38,11,6,0)
                                   else
                                   rettangolo(10,42,11,6,0)
                     end;
                   0:rettangolo(10,35,11,6,0);
                   2:rettangolo(27,49,12,3,0);
                   3:rettangolo(43,49,12,3,0);
                   end;
                   s:=readkey;
                   until(qtasto('78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
                   if((qtasto('741qaz'+chr(75),s))and(n>1))then
                            if((s<>'7')and(s<>'q'))then
                            n:=n-1;
                   if((qtasto('63edx'+chr(77),s))and(n<3))then
                            begin
                            n:=n+1;
                            if(n=1)then n:=2;
                            end;
                   if(qtasto('789qwe'+chr(72),s))then
                          if(((nFeature=2)and(n>1))or((nFeature>2)and(n>0)))then
                            begin
                            if(n=3)then n:=n-1;
                            n:=n-1;
                            end;
                   if((qtasto('123zsx'+chr(80),s))and(n<2))then
                            n:=n+1;
                   until(s=chr(13));
                   SeleOpz:=n;
                   end;

          procedure seleColor();
                    var i,j,v,x,y,xx,yy,nn,nc:integer;
                    begin
                    if(nFeature=2)then nc:=1
                                  else
                                  if(n=0)then nc:=1 else nc:=2;
                    if(nFeature=2)then
                                  nn:=inversoColor(CFeature[nFeature,nc])
                                  else
                                  nn:=CFeature[nFeature,nc];
                    fascia;

                    repeat
                    repeat
                    v:=19;
                    if(nFeature=2)then
                                  begin x:=26+nn*6; y:=40; end
                                  else
                                  if(n=0)then begin x:=23+nn*6; y:=37; end
                                         else begin x:=23+nn*6; y:=44; end;
                    repeat
                    v:=v+1;
                    if(v=20)then
                            begin
                            contorno6(x,y,false,15);
                            v:=2;
                            end;
                    if(v=10)then
                            contorno6(x,y,true,15);
                    delay(24);
                    until(keypressed);
                    contorno6(x,y,true,7);
                    s:=readkey;
                    until(qtasto('cbpt78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
                    if((qtasto('741qaz'+chr(75),s))and(nn>0))then
                            nn:=nn-1;
                    if(qtasto('963edx'+chr(77),s))then
                          if(((nFeature=2)and(nn<6))or((nFeature>2)and(nn<7)))then
                                      nn:=nn+1;
                    until(s=chr(13));
                    textbackground(0);
                    if(nFeature=2)then
                                  begin x:=24; xx:=67; y:=38; yy:=43; end
                                  else
                                  if(n=0)then begin x:=21; xx:=70; y:=35; yy:=40; end
                                         else begin x:=21; xx:=70; y:=42; yy:=47; end;
                    for i:=y to yy do
                      for j:=x to xx do
                        begin
                        gotoxy(j,i);
                        write(' ');
                        end;
                    if(nFeature=2)then
                          val(copy(sfumato[nn],1,2),CFeature[2,1])
                          else
                          CFeature[nFeature,nc]:=nn;
                    quadrato(x-11,y,nc);
                    DStile(CerchioCampione,mcerchioCamp,nFeature,CFeature[nFeature,1],CFeature[nFeature,2],false);
                    end;

procedure Feature();
          var i,j,z,x,y,h,l,m,v:integer;
              s:char;
              ss:string;
              OGG:oggetto;
              A:array[1..6,1..2]of integer;             //1=C1  2=C2



          begin
          n:=0;
          A[2,1]:=1;A[3,1]:=1;A[3,2]:=4;A[4,1]:=4;A[4,2]:=7;A[5,1]:=6;A[5,2]:=4;A[6,1]:=6;A[6,2]:=4;
          textcolor(15);textbackground(0);
          ss:=copy(chr223,1,72);
          gotoxy(4,13);write(chr(219),ss,chr(219));
          gotoxy(4,15);write(chr(219),ss,chr(219));
          ss:=copy(spazio,1,72);
          for i:=14 to 52 do
               if(i<>15)then
                begin
                gotoxy(4,i);write(chr(219),ss,chr(219));
                end;
          ss:=copy(chr220,1,72);
          gotoxy(4,53);write(chr(219),ss,chr(219));
          textbackground(sfondo);
          for i:=13 to 53 do
            begin
            gotoxy(77,i);write(chr(219));
            end;
          textbackground(0);
          textcolor(12);
          gotoxy(6,14);
          write('FEATURES');
          textcolor(15);
          textbackground(7);
          for i:=1 to mCirconfCamp do
              begin
              gotoxy(CirconfCampione[i,1],CirconfCampione[i,2]);
              write(chr(219));
              end;

          casoFeature:
          DStile(CerchioCampione,mcerchioCamp,1,0,0,false);

          for i:=1 to 6 do
            begin
            x:=10+((i-1)mod 3)*22;
            y:=36+((i-1)div 3)*9;
            l:=17;
            h:=7;
            m:=0;
            for j:=y+1 to y+h-2 do
              for z:=x+1 to x+l-2 do
                if(not((j=y+3)and(z>=(l-length(CampioniFeature[i]))div 2+x)and(z<(l-length(CampioniFeature[i]))div 2+x+length(CampioniFeature[i]))))then
                   incr(OGG,m,z,j);
            Dstile(OGG,m,i,A[i,1],A[i,2],false);
            textcolor(7);
            textbackground(7);
            Rett(x,y,l,h);
            textbackground(0);
            textcolor(14);
            gotoxy((l-length(CampioniFeature[i]))div 2+x,y+3);
            write(CampioniFeature[i]);
            end;
          x:=10+((nFeatureEs-1)mod 3)*22;
          y:=36+((nFeatureEs-1)div 3)*9;
          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 textcolor(14);textbackground(14);
                 rett(x,y,17,7);
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  textcolor(15);textbackground(7);
                  rett(x,y,17,7);
                  end;
          delay(22);
          until(keypressed);
          textcolor(7);textbackground(7);
          rett(x,y,17,7);
          s:=readkey;
          until(qtasto('78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
          if((qtasto('741qaz'+chr(75),s))and((nFeatureEs-1)mod 3<>0))then
                            nFeatureEs:=nFeatureEs-1;
          if((qtasto('963edx'+chr(77),s))and((nFeatureEs-1)mod 3<>2))then
                            nFeatureEs:=nFeatureEs+1;
          if((qtasto('789qwe'+chr(72),s))and(nFeatureEs>3))then
                            nFeatureEs:=nFeatureEs-3;
          if((qtasto('123zsx'+chr(80),s))and(nFeatureEs<4))then
                            nFeatureEs:=nFeatureEs+3;
          x:=10+((nFeatureEs-1)mod 3)*22;
          y:=36+((nFeatureEs-1)div 3)*9;
          until(s=chr(13));
          nFeature:=nFeatureEs;
          if(nFeature<>1)then
          begin
          textbackground(0);
          for i:=36 to 51 do
            begin
            gotoxy(10,i);
            write(copy(spazio,1,61));
            end;
          textbackground(2);
          textcolor(15);
          gotoxy(28,50);write('    OK    ');
          textcolor(7);
          rettangolo(27,49,12,3,0);
          textbackground(4);
          textcolor(15);
          gotoxy(44,50);write('   UNDO   ');
          textcolor(7);
          rettangolo(43,49,12,3,0);

          DStile(CerchioCampione,mcerchioCamp,nFeature,CFeature[nFeature,1],CFeature[nFeature,2],false);

          if(nFeature=2)then
          quadrato(13,38,1)
          else
          begin
          quadrato(10,35,1); quadrato(10,42,2);
          end;
          repeat
          n:=seleOpz;
          if(n=3)then
                 begin
                 textbackground(0);
                 gotoxy(10,35);write('           ');
                 for i:=41 to 45 do
                    for j:=10 TO 23 do
                        begin
                        gotoxy(j,i);
                        write(' ');
                        end;
                 for i:=48 to 52 do
                    for j:=27 TO 32 do
                        begin
                        gotoxy(j,i);
                        write(' ');
                        end;
                 for i:=49 to 52 do
                    for j:=42 TO 54 do
                        begin
                        gotoxy(j,i);
                        write(' ');
                        end;
                 goto casoFeature;
                 end;
          if(n<>2)then seleColor;
          until(n=2);
          end;
          for i:=13 to 53 do
            for j:=4 to 77 do
               setta(j,i);


          end;




function inputCerchio():char;
         var x,x1,y,y1,r1,mp,m:integer;
             POGG,OGG:oggetto;
             PTAB,DTAB:tabella;
             s:char;
             h1:real;
         begin
         strumento:=12;
         x:=40;y:=30;
         r:=20;
         k:=1;
         StrumentoSecondario:=false;
         FinestraTools(true);
         repeat
         PTAB:=cancTab;
         OGG:=Dcerchio(x,y,r,k,m,DTAB);
         disegna(PTAB,OGG,m,text);
         repeat
         x1:=x;y1:=y;r1:=r;h1:=k;
         s:=attenditasto('hcpbt78941236qazxdews+-<>'+smTastiera+chr(8)+chr(13)+chr(0));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         seHideShowCIB(OGG,m,s);

         if(s=chr(0))then
              s:=readkey;

         muovi(s,x,y);
         if(bbim)then disegna(EMPTY,OGG,m,text);
         if((s='+')and(r<40))then
                   if(((r*k)<40)and((r/k)<50))then
                                  r:=r+1
                                  else
                                  if((r*k)>=39)then
                                  begin
                                  if(k>1.2)then
                                  k:=k-(0.04*k)
                                  end
                                  else
                                  k:=k+(0.04*k);
         if((s='-')and(r>1))then
                r:=r-1;
         if((s='>')and(k<2))then
                if((r*k)<39.5)then
                k:=k+(0.04*k)
                else
                r:=r-1;
         if((s='<')and(k>0.5))then
                if((r/k)<50)then
                k:=k-(0.04*k)
                else
                r:=r-1;
         if((k>0.97)and(k<1.03))then
                k:=1;
         if(not((r1=r)and(y1=y)and(x1=x)and(h1=k)))then
                    begin
                    ResetTools;
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=DTAB;
                    OGG:=Dcerchio(x,y,r,k,m,DTAB);
                    disegna(DTAB,POGG,mp,'a');
                    disegna(PTAB,OGG,m,text);
                    end;
         until((s=chr(13))or(s=chr(8))or(s='t'));
         if(s=chr(13))then
                     fondi(OGG,m)
                     else
                     begin
                     disegna(EMPTY,OGG,m,'a');
                     m:=0;
                     end;
         pulisci;
         until(s<>chr(13));
         inputCerchio:=s;
         strumento:=0;
         FinestraTools(false);
         strumento:=12;
         end;

function inputRetta():char;
         var v,mp,m:integer;
             POGG,OGG:oggetto;
             PTAB,DTAB:tabella;
             s:char;
             b:boolean;
         begin

         strumento:=6;
         repeat
         StrumentoSecondario:=false;
         EstremoRetta:=true;
         FinestraTools(true);
         b:=false;
         s:=cursore(x,y,0,'t');
         if((s=chr(8))or(s='t')or(s='h'))then
                     begin
                     Setta(x,y);
                     m:=0;
                     goto caso1;
                     end;
         pulisci;

         x2:=x;y2:=y;

         PTAB:=cancTab;
         OGG:=Dretta(x,y,x2,y2,m,DTAB);
         disegna(PTAB,OGG,m,text);
         b:=true;
         repeat
         StrumentoSecondario:=true;
         FinestraTools(b);
         b:=false;
         repeat
         v:=19;
         repeat
         v:=v+1;
         if((v=20)and(barra(x2,y2)))then
                 begin
                 cursorColor(x2,y2,1);
                 gotoxy(x2,y2);
                 write(chr(219));
                 v:=1;
                 end;
         if(v=10)then
                 begin
                 colora(x2,y2);
                 end;
         delay(30);
         until(keypressed);
         colora(x2,y2);
         s:=readkey;
         until(qtasto('cbpt78941236qazxdewsh '+smTastiera+chr(8)+chr(13)+chr(0),s));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         seHideShowCIB(OGG,m,s);

         if(s=chr(0))then
             s:=readkey;

         if(s=' ')then
                  begin
                  EstremoRetta:=not EstremoRetta;
                  scambia(x,x2);scambia(y,y2);
                  end;

         muovi(s,x2,y2);
         ResetTools;

         POGG:=OGG;
         mp:=m;
         PTAB:=DTAB;
         OGG:=Dretta(x,y,x2,y2,m,DTAB);
         disegna(DTAB,POGG,mp,'a');
         if(bbim)then disegna(EMPTY,OGG,m,text)
                      else
                      disegna(PTAB,OGG,m,text);
         until((s=chr(13))or(s=chr(8))or(s='t'));
         if(s=chr(13))then
                     begin
                     fondi(OGG,m);
                     scambia(x,x2);scambia(y,y2)
                     end
                     else
                     begin
                     disegna(EMPTY,OGG,m,'a');
                     m:=0;
                     end;
         caso1:
         pulisci;
         until(s='t');
         inputRetta:=s;
         strumento:=0;
         FinestraTools(false);
         strumento:=6;
         end;

function inputSecchio():char;
          var s:char;
              i,j,jj,ii,z,n,m:integer;
              TAB:tabella;
              TABI:tabinteger;
              OGG:oggetto;
          begin
          strumento:=5;
          schermBKP:=schermata;
          StrumentoSecondario:=false;
          FinestraTools(true);
          TAB:=cancTab;
          gostTab:=cancTab;
          repeat
          s:=cursore(x,y,0,'t');
          if((s<>chr(8))and(s<>'h'))then
          begin
          if(s=chr(13))then
          begin
          schermBKP:=schermata;

          for i:=1 to 80 do
            for j:=1 to 80 do
              begin
              if(schermata[j,i].ground>7)then schermata[j,i].ground:=schermata[j,i].ground-8;
              if(schermata[j,i].text=chr(219))then  schermata[j,i].ground:= schermata[j,i].color-(8*(schermata[j,i].color div 8));
              if(schermata[j,i].color=schermata[j,i].ground)then schermata[j,i].text:=chr(0);
              if(schermata[j,i].text=chr(0))then schermata[j,i].color:=schermata[j,i].ground;
              TABI[i,j]:=0;
              end;

          z:=0;
          for j:=1 to 80 do
             for i:=1 to 80 do
              if(Tabi[j,i]=0)then
                       begin
                       z:=z+1;
                       for jj:=1 to 80 do
                         for ii:=1 to 80 do
                          if ((schermata[j,i].text=schermata[jj,ii].text)and(schermata[j,i].ground=schermata[jj,ii].ground)and(schermata[j,i].color=schermata[jj,ii].color))  then
                             if(Tabi[jj,ii]=0)then
                                      Tabi[jj,ii]:=z;
                       end;

          DSecchio(cacca,TABI,x,y,TAB);
          FondiTab(Tab);
          end;
          pulisci;
          if(s=chr(13))then
               begin
               n:=attenzione(12,2,0,'would you like to apply some feature?','YES£2 NO£4 DEFAULT£1');
               if(n=1)then
                      Feature;
               if(not((n=2)or(nFeature=1)))then
                     begin
                     m:=0;
                     for i:=1 to 80 do
                        for j:=1 to 80 do
                         if(TAB[j,i])then
                           incr(OGG,m,j,i);
                     DStile(OGG,m,nFeature,CFeature[nFeature,1],CFeature[nFeature,2],true);
                     end;
               end;
          end
          else
          if(s=chr(8))then
          begin
          ymaxcln:=0;
          for i:=1 to 80 do
             for j:=1 to 80 do
                if((schermata[j,i].color<>schermBKP[j,i].color)or(schermata[j,i].ground<>schermBKP[j,i].ground)or(schermata[j,i].text<>schermBKP[j,i].text))then
                      ymaxcln:=i;
          caccaBKP:=schermata;
          schermata:=schermBKP;
          pulisciBKP:=true;
          pulisci;
          pulisciBKP:=false;
          end;
          until(s='t');
          inputSecchio:=s;
          gostTab:=cancTab;
          strumento:=0;
          FinestraTools(false);
          strumento:=5;
          end;

function inputMatita():char;
         var v,m:integer;
             s:char;
             OGG:oggetto;
             b,bb:boolean;
         begin
         b:=true;
         caso2:
         strumento:=1;
         StrumentoSecondario:=false;
         FinestraTools(b);
         b:=false;
         s:=cursore(x,y,0,' t');
         if(s='t')then
                  goto caso4;
         if(s=' ')then
                  begin
                  b:=true;
                  goto caso3;
                  end;
         if(s=chr(13))then
                      begin
                      colora(x,y);
                      schermata[x,y].color:=color;schermata[x,y].ground:=ground;schermata[x,y].text:=text;
                      end;
         pulisci;
         goto caso2;

         caso3:
         StrumentoSecondario:=true;
         FinestraTools(b);
         b:=false;
         if(s=' ')then
                  m:=0;
         if(s<>chr(8))then
         incr(OGG,m,x,y);
         repeat
         v:=19;
         repeat
         v:=v+1;
         if((v=20)and(barra(x,y)))then
                 begin
                 cursorColor(x,y,1);
                 gotoxy(x,y);
                 write(chr(219));
                 v:=1;
                 end;
         if(v=10)then
                 colora(x,y);
         delay(30);
         until(keypressed);
         colora(x,y);
         s:=readkey;
         until(qtasto('78941236qazxdews cpbht'+smTastiera+chr(8)+chr(13)+chr(0),s));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         seHideShowCIB(OGG,m,s);

         if(s=chr(0))then
             s:=readkey;
         if((s=' ')or(s=chr(13)))then
                  begin
                  fondi(OGG,m);
                  pulisci;
                  b:=true;
                  goto caso2;
                  end;

         if(bbim)then disegna(EMPTY,OGG,m,text);
         if(s=chr(8))then
                     if(m>1)then
                            begin
                            bb:=false;
                            for i:=1 to m-1 do
                               if((OGG[i,1]=OGG[m,1])and(OGG[i,2]=OGG[m,2]))then
                                                   bb:=true;
                            if(not bb)then
                                      setta(OGG[m,1],OGG[m,2]);
                            m:=m-1;
                            x:=OGG[m,1]; y:=OGG[m,2];
                            end
                            else
                            begin
                            disegna(EMPTY,OGG,m,'a');
                            b:=true;
                            goto caso2;
                            end;
         if(s='t')then
                  begin
                  disegna(EMPTY,OGG,m,'a');
                  goto caso4;
                  end;
         muovi(s,x,y);
         ResetTools;
         goto caso3;
         caso4:
         inputMatita:=s;
         strumento:=0;
         FinestraTools(false);
         strumento:=1;
         end;

function inputGomma():char;
         var x,y,v,x1,y1,l1,mp,m,cm,cmp,mo,xx1,yy1,xx2,yy2:integer;
             s:char;
             c:string;
             PTAB,DTAB:tabella;
             POGG,OGG,OGGC,POGGC,UOGG:oggetto;
         begin
         strumento:=2;
         x:=40;y:=30;
         lato:=4;
         StrumentoSecondario:=false;
         FinestraTools(true);
         corniceTab:=cancTab;
         repeat
         DTAB:=cancTab;                                                // lato = (l*2)+1
         PTAB:=cancTab;
         gostTab:=cancTab;
         Pcornice:=cancTab;
         m:=0; cm:=0;
         xx1:=(x-((lato*3)div 2)); xx2:=(x+((lato*3)div 2));
         yy1:=y-lato; yy2:=y+lato;
         for i:=xx1+1 to xx2-1 do
                for j:=yy1+1 to yy2-1 do
                    begin
                    DTAB[i,j]:=true;
                    incr(OGG,m,i,j);
                    end;
         disegna(EMPTY,OGG,m,chr(0));
         if(sfondo=0)then
                     textcolor(15)
                     else
                     textcolor(0);
         OGGC:=DRettangolo(cm,xx1,yy1,xx2,yy2);
         disegna(EMPTY,OGGC,cm,chrGomma);
         UOGG:=unisciOgg(mo,OGG,m,OGGC,cm);
         repeat
         x1:=x;y1:=y;l1:=lato;
         s:=attenditasto('htcpb78941236qazxdews+- '+smTastiera+chr(13)+chr(0));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;
         if(qtasto('htcpb',s))then UOGG:=unisciOgg(mo,OGG,m,OGGC,cm);
         seHideShowCIB(UOGG,mo,s);
         if(s=chr(0))then
            s:=readkey;
         if((s<>'t')and(s<>' '))then
          begin
          if((qtasto('741qaz'+chr(75),s))and((x-((lato*3)div 2))>1))then
                            x:=x-1;
          if((qtasto('963edx'+chr(77),s))and((x+((lato*3)div 2))<80))then
                            x:=x+1;
          if((qtasto('789qwe'+chr(72),s))and((y-lato)>1))then
                            y:=y-1;
          if((qtasto('123zsx'+chr(80),s))and((y+lato)<80))then
                            y:=y+1;

          UOGG:=unisciOgg(mo,OGG,m,OGGC,cm);

          if(bbim)then disegna(EMPTY,UOGG,mo,s);
          if((s='+')and(lato<12))then
                begin
                if((x-((lato*3)div 2))<4)then
                        x:=x+4-(x-((lato*3)div 2));
                if((x+((lato*3)div 2))>77)then
                        x:=x-4+(81-(x+((lato*3)div 2)));
                if((y-lato)<2)then
                        y:=y+2-(y-lato);
                if(lato<3)then
                       lato:=lato+1
                       else
                       lato:=lato+2;
                end;
          if((s='-')and(lato>0))then
             if(lato<3)then
                 lato:=lato-1
                 else
                 lato:=lato-2;
          end;
         if(s=' ')then
                  begin
                  gostTab:=cancTab;
                  UOGG:=unisciOgg(mo,OGG,m,OGGC,cm);
                  for i:=1 to mo do
                       gostTab[UOGG[i,1],UOGG[i,2]]:=true;
                  if(attenzione(12,2,0,'Are you really sure to erase all the page?','YES£2 NO£4')= 1)then
                                     begin
                                     gostTab:=cancTab;
                                     for i:=1 to 120 do
                                        for j:=1 to 80 do
                                             begin
                                             schermata[j,i].ground:=sfondo;
                                             schermata[j,i].text:=chr(0);
                                             schermata[j,i].color:=0;
                                             setta(j,i);
                                             end;
                                     s:='t';
                                     end
                                     else
                                     gostTab:=cancTab;
                   end;
         if(not((l1=lato)and(y1=y)and(x1=x)))then
                    begin
                    ResetTools;
                    xx1:=(x-((lato*3)div 2)); xx2:=(x+((lato*3)div 2));
                    yy1:=y-lato; yy2:=y+lato;
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=DTAB;
                    m:=0;
                    POGGC:=OGGC;
                    cmp:=cm;
                    DTAB:=cancTab;
                    Pcornice:=corniceTab;
                    textbackground(sfondo);
                    for i:=(xx1+1) to (xx2-1) do
                         for j:=(yy1+1) to (yy2-1) do
                              begin
                              DTAB[i,j]:=true;
                              incr(OGG,m,i,j);
                              end;
                    OGGC:=DRettangolo(cm,xx1,yy1,xx2,yy2);
                    if(sfondo=0)then
                             textcolor(15)
                             else
                             textcolor(0);
                    disegna(PTAB,OGG,m,chr(0));
                    if(s='-')then
                             disegna(DTAB,POGG,mp,'a');
                    disegna(unisciTab(corniceTab,DTAB),POGGC,cmp,'a');
                    if(sfondo=0)then
                             textcolor(15)
                             else
                             textcolor(0);
                    disegna(Pcornice,OGGC,cm,chrGomma);

                    end;
         until((s=chr(13))or(s='t'));
         OGG:=unisciOgg(mo,OGG,m,OGGC,cm);
         if(s=chr(13))then
         for i:=1 to mo do
               begin
               with schermata[OGG[i,1],OGG[i,2]] do
                              begin
                              color:=0;
                              ground:=sfondo;
                              text:=chr(0);
                              end;
               end;

         pulisci;
         until(s='t');
         disegna(EMPTY,OGG,mo,'a');
         gostTab:=cancTab;
         inputGomma:=s;
         Hide:=true;HideShow;
         strumento:=0;
         FinestraTools(false);
         strumento:=2;
         end;

function inputRettangolo():char;
         var v,m,mp,i,l,h:integer;
             s:char;
             c:string;
             PTAB:tabella;
             POGG,OGG:oggetto;
         begin

         dx1:=(x-(lrettangolo div 2))+abs((((x-(lrettangolo div 2))-1)-abs((x-(lrettangolo div 2))-1))div 2)+((80-(x+lrettangolo-(lrettangolo div 2)))-abs(80-(x+lrettangolo-(lrettangolo div 2))))div 2;
         dy1:=(y-(hrettangolo div 2))+abs((((y-(hrettangolo div 2))-1)-abs((y-(hrettangolo div 2))-1))div 2)+((80-(y+hrettangolo-(hrettangolo div 2)))-abs(80-(y+hrettangolo-(hrettangolo div 2))))div 2;
         dx2:=dx1+lrettangolo-1;
         dy2:=dy1+hrettangolo-1;

         px1:=0;px2:=0;py1:=0;py2:=0;

         strumento:=10;
         if(nRettang<4)then
                       StrumentoSecondario:=false
                       else
                       StrumentoSecondario:=true;

         repeat

         FinestraTools(true);

         PTAB:=cancTab;
         gostTab:=cancTab;
         m:=0;
         OGG:=DRettangolo(m,dx1,dy1,dx2,dy2);
         Disegna(EMPTY,OGG,m,text);

         repeat
         px1:=dx1;px2:=dx2;py1:=dy1;py2:=dy2;
         s:=attenditasto('htcpb78941236qazxdews+- '+smTastiera+chr(13)+chr(8)+chr(0));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         if(s=' ')then
                  begin
                  if(nRettang>1)then
                             nRettang:=nRettang-1
                             else
                             nRettang:=4;
                  Disegna(EMPTY,OGG,m,text);
                  FinestraTools(true);
                  end;


         if((qtasto('741qaz',s))and(dx1>1))then begin dx1:=dx1-1;dx2:=dx2-1; end;
         if((qtasto('963edx',s))and(dx2<80))then begin dx1:=dx1+1;dx2:=dx2+1; end;
         if((qtasto('789qwe',s))and(dy1>1))then begin dy1:=dy1-1;dy2:=dy2-1; end;
         if((qtasto('123zsx',s))and(dy2<80))then begin dy1:=dy1+1;dy2:=dy2+1; end;

         seHideShowCIB(OGG,m,s);

         if(s=chr(0))then
         begin
         s:=readkey;
         if((s=chr(75))and(dx1<(dx2-1)))then dx2:=dx2-1;
         if((s=chr(77))and(dx2<80))then dx2:=dx2+1;
         if((s=chr(72))and(dy1<(dy2-1)))then dy2:=dy2-1;
         if((s=chr(80))and(dy2<80))then dy2:=dy2+1;
         end;

         if(s='+')then
                  if((dx1>1)and(dx2<80)and(dy1>1)and(dy2<80))then
                                                             begin
                                                             dx1:=dx1-1;dx2:=dx2+1;
                                                             dy1:=dy1-1;dy2:=dy2+1;
                                                             end;
         if(s='-')then
                  if(((dx2-dx1)>2)and((dy2-dy1)>2))then
                                                   begin
                                                   dx1:=dx1+1;dx2:=dx2-1;
                                                   dy1:=dy1+1;dy2:=dy2-1;
                                                   end;

         if(bbim)then disegna(EMPTY,OGG,m,text);
         if(not((px1=dx1)and(py1=dy1)and(px2=dx2)and(py2=dy2)))then
                    begin
                    x:=dx1; y:=dy1;
                    ResetTools;
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=corniceTab;
                    m:=0;
                    OGG:=DRettangolo(m,dx1,dy1,dx2,dy2);
                    disegna(corniceTab,POGG,mp,'a');
                    disegna(PTAB,OGG,m,text);
                    end;
         until((s=chr(13))or(s=chr(8))or(s='t'));

         if(s=chr(13))then
                     fondi(OGG,m)
                     else
                     begin
                     disegna(EMPTY,OGG,m,'a');
                     m:=0;
                     end;
         pulisci;
         until(s<>chr(13));
         lrettangolo:=dx2-dx1+1;
         hrettangolo:=dy2-dy1+1;
         strumento:=0;
         FinestraTools(false);
         inputRettangolo:=s;
         strumento:=10;
         end;

function inputScacchiera():char;
         var i,j,m,xx2,yy2,n,mp,v,nn:integer;
             OGG,POGG:oggetto;
             TAB,PTAB:tabella;
             s:char;
             bb:boolean;
         begin

         color1:=color;
         ground1:=ground;
         text1:=text;

         strumento:=8;

         if(not Hide)then
                     begin
                     Hide:=true;
                     HideShow;
                     end;
         repeat
         EstremoRetta:=true;

         bb:=false;
         StrumentoSecondario:=false;
         FinestraTools(true);
         s:=cursore(x,y,0,'t');
         m:=0;

         if((s<>'t')and(s<>chr(8))and(s<>'h'))then
         begin
         StrumentoSecondario:=true;
         y2:=y;
         x2:=x;
         FinestraTools(false);

         colora(x,y);
         incr(OGG,m,x,y);
         repeat

         xx2:=x2;yy2:=y2;
         if(x2=x)then
                      n:=1
                      else
                      begin
                      bb:=true;
                      n:=2;
                      end;
         if(x2<x)then nn:=+1 else nn:=-1;

         repeat
         v:=19;
         repeat
         v:=v+1;
         if(v=20)then
                 begin
                 cursorColor(x2,y2,1);
                 if(nn<0)then
                         begin
                         if((bb)and(barra(x2+nn,y2)))then
                               begin
                               gotoxy(x2+nn,y2);
                               write(chr(219))
                               end;
                         if(barra(x2,y2))then
                                             begin
                                             gotoxy(x2,y2);
                                             write(chr(219))
                                             end;
                         end
                         else
                         begin
                         if(barra(x2,y2))then
                                             begin
                                             gotoxy(x2,y2);
                                             write(chr(219))
                                             end;
                         if((bb)and(barra(x2+nn,y2)))then
                               begin
                               gotoxy(x2+nn,y2);
                               write(chr(219))
                               end;
                         end;
                 v:=1;
                 end;
         if(v=10)then
                 begin
                 if(bb)then
                       colora(x2+nn,y2);
                 colora(x2,y2);
                 end;
         delay(30);
         until(keypressed);

         if(bb)then
               colora(x2+nn,y2);
         colora(x2,y2);
         s:=readkey;

         until(qtasto('htcpb78941236qazxdews '+smTastiera+chr(13)+chr(8)+chr(0),s));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         seHideShowCIB(OGG,m,s);

         if(s=chr(0))then
              s:=readkey;

         if((qtasto('741qaz'+chr(75),s))and(x2>n))then
                            x2:=x2-n;
         if((qtasto('963edx'+chr(77),s))and(x2<(81-n)))then
                            x2:=x2+n;
         if((qtasto('789qwe'+chr(72),s))and(y2>1))then
                            y2:=y2-1;
         if((qtasto('123zsx'+chr(80),s))and(y2<80))then
                            y2:=y2+1;


         if(bbim)then disegna(EMPTY,OGG,m,text);
         if(s=' ')then
                  begin
                  EstremoRetta:=not EstremoRetta;
                  scambia(x,x2);scambia(y,y2);
                  disegna(EMPTY,OGG,m,text);
                  end;

         if(not((xx2=x2)and(y2=yy2)))then
                    begin
                    ResetTools;
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=TAB;
                    m:=0;
                    OGG:=DRettangoloPieno(m,x,y,x2,y2,TAB);
                    disegna(TAB,POGG,mp,'a');
                    disegna(PTAB,OGG,m,text);
                    end;
         until((s=chr(13))or(s=chr(8))or(s='t'));
         end;
         if(s=chr(13))then
                     fondi(OGG,m)
                     else
                     begin
                     disegna(EMPTY,OGG,m,'a');
                     m:=0;
                     end;
         until((s='t')or(s=chr(13)));
         pulisci;
         strumento:=0;
         FinestraTools(false);
         inputScacchiera:=s;
         if(not Hide)then
                     begin
                     Hide:=true;
                     HideShow;
                     end;
         strumento:=8;
         end;

function inputGriglia():char;
         var i,j,m,spx,spy,x,y,l,h:integer;
             OGG,ICBOGG:oggetto;
             s:char;
         begin

         strumento:=7;
         if(nGrid<3)then
                    StrumentoSecondario:=false
                    else
                    StrumentoSecondario:=true;

         spostx:=0;
         sposty:=0;

         OGG:=DGriglia(m,x,y,l,h);

         dx1:=x;
         dy1:=y;
         dx2:=x+l-1;
         dy2:=y+h-1;

         FinestraTools(true);

         textcolor(color);
         textbackground(ground);

         for i:=1 to m do
             if(barra(OGG[i,1],OGG[i,2]))then
             begin
             gotoxy(OGG[i,1],OGG[i,2]);
             write(OGGGrid[i]);
             end;

         repeat
         spx:=spostx; spy:=sposty;

         s:=attenditasto('htcpb78941236qazxdews+- '+smTastiera+chr(13)+chr(8)+chr(0));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;

         if(qtasto('htcpb'+smTastiera,s))then
                            begin
                            for i:=1 to m do
                                begin
                                ICBOGG[i,1]:=OGG[i,1]+spostx;
                                ICBOGG[i,2]:=OGG[i,2]+sposty;
                                end;
                            seHideShowCIB(ICBOGG,m,s);
                            if((s='p')and(nGrid=3))then
                                  begin
                                  OGG:=DGriglia(m,x,y,l,h);
                                  for i:=1 to m do
                                  if(barra(OGG[i,1]+spostx,OGG[i,2]+sposty))then
                                                        begin
                                                        textcolor(color);
                                                        textbackground(ground);
                                                        gotoxy(OGG[i,1]+spostx,OGG[i,2]+sposty);
                                                        write(OGGGrid[i]);
                                                        end;
                                  end;
                            end;
         if(s=' ')then
                  begin
                  if(nGrid>1)then
                             nGrid:=nGrid-1
                             else
                             nGrid:=3;
                  OGG:=DGriglia(m,x,y,l,h);
                  for i:=1 to m do
                                if(barra(OGG[i,1]+spostx,OGG[i,2]+sposty))then
                                                        begin
                                                        textcolor(color);
                                                        textbackground(ground);
                                                        gotoxy(OGG[i,1]+spostx,OGG[i,2]+sposty);
                                                        write(OGGGrid[i]);
                                                        end;
                  FinestraTools(true);
                  end;
         if(s=chr(0))then
         s:=readkey;
         if((qtasto('741qaz'+chr(75),s))and((x+spostx)>1))then spostx:=spostx-1;
         if((qtasto('963edx'+chr(77),s))and((x+l-1+spostx)<80))then spostx:=spostx+1;
         if((qtasto('789qwe'+chr(72),s))and((y+sposty)>1))then sposty:=sposty-1;
         if((qtasto('123zsx'+chr(80),s))and((y+h-1+sposty)<80))then sposty:=sposty+1;

         dx1:=x+spostx;
         dy1:=y+sposty;
         dx2:=x+l-1+spostx;
         dy2:=y+h-1+sposty;
         if(not((spx=spostx)and(spy=sposty))or(bbim))then
                            begin
                            ResetTools;
                            for i:=1 to m do
                                if(barra(OGG[i,1]+spx,OGG[i,2]+spy))then
                                            if((chr(0)=OGGGrid[TABGrid[OGG[i,1]-(spostx-spx),OGG[i,2]-(sposty-spy)]]))then
                                                        setta(OGG[i,1]+spx,OGG[i,2]+spy);
                            for i:=1 to m do
                                if(barra(OGG[i,1]+spostx,OGG[i,2]+sposty))then
                                        if((not(OGGGrid[i]=OGGGrid[TABGrid[OGG[i,1]+(spostx-spx),OGG[i,2]+(sposty-spy)]]))or(bbim))then
                                                        begin
                                                        textcolor(color);
                                                        textbackground(ground);
                                                        gotoxy(OGG[i,1]+spostx,OGG[i,2]+sposty);
                                                        write(OGGGrid[i]);
                                                        end;
                            end;
         until((s=chr(13))or(s=chr(8))or(s='t'));
         for i:=1 to m do
                       begin
                       ICBOGG[i,1]:=OGG[i,1]+spostx;
                       ICBOGG[i,2]:=OGG[i,2]+sposty;
                       end;
         if(s=chr(13))then
                      fondi(ICBOGG,m)
                      else
                      begin
                      disegna(EMPTY,ICBOGG,m,'a');
                      m:=0;
                      end;
         pulisci;
         inputGriglia:=s;
         strumento:=0;
         FinestraTools(false);
         strumento:=7;
         end;

function Scrittura(var ss:string;var x,y:integer):char;
         var v,xx,n,c,g:integer;
             s:char;
         begin
         c:=color;
         g:=ground;
         if(strumento=-2)then
         begin
         color:=15;
         ground:=0;
         end;
         xx:=x;
         if(strumento=4)then
                  n:=71
                  else
                  if(strumento=-2)then
                  n:=70
                  else
                  n:=80;
         repeat
         repeat
         v:=49;
         if(strumento=-2)then
         begin
         gotoxy(x+1,y);textcolor(7);textbackground(0);
         write('.ptc ');
         end;
         repeat
         v:=v+1;
         if(v=50)then
                 begin
                 cursorColor(x,y,1);
                 if(gotoxyb(x,y))then
                                 write(chr(219));
                 v:=1;
                 end;
         if(v=25)then
                 if(x=n)then
                         begin
                         if(((xx+length(ss)-1)=n)and(gotoxyb(x,y)))then
                                                             begin
                                                             textcolor(color);textbackground(ground);
                                                             write(s);
                                                             end
                                                             else
                                                             if(strumento=4)then
                                                                      begin
                                                                      gotoxy(x,y);
                                                                      write(' ')
                                                                      end
                                                                      else
                                                                      setta(x,y);
                         end
                         else
                         if(strumento=4)then
                                        begin
                                        gotoxy(x,y);
                                        write(' ')
                                        end
                                        else
                                        setta(x,y);
         delay(10);
         until(keypressed);
         if(strumento=4)then
                        begin
                        gotoxy(x,y);
                        write(' ')
                        end
                        else
                        setta(x,y);
         s:=readkey;
         until(qtasto('qwertyuiopasdfghjklzxcvbnm\1234567890''|!"$%&/()=?^<>,.-;:_+*@#[]{} '+smTastiera+chr(13)+chr(8),s)and(not((strumento=-2)and(qtasto('\|"/?<>:*',s)))));
         if((s<>chr(13))and(s<>chr(8)))then
              begin
              if((x+1)<n+1)then
                          begin
                          ss:=ss+s;
                          if(gotoxyb(x,y))then
                                 begin
                                 textcolor(color);textbackground(ground);
                                 write(s);
                                 end;
                          x:=x+1;
                          end;
              end
              else
              if(s=chr(8))then
                          if(length(ss)<>0)then
                                                 begin
                                                 ss:=copy(ss,1,length(ss)-1);
                                                 x:=x-1;
                                                 end;
         until((s=chr(13))or(length(ss)=0));
         if(strumento=-2)then
         begin
         gotoxy(x-length(ss),y);textcolor(14);textbackground(0);
         write(ss,'.ptc ');
         end;
         Scrittura:=s;
         color:=c;
         ground:=g;
         end;

procedure creaProgetto();
          var i,j,v,pp,b,n,x,y,lol,nn,bptc,nTrasp:integer;
              ss,s:char;
              tptc:boolean;
          begin
          Strumento:=-2;
          casoProgetto:
          clrscr;
          textbackground(0);
          clrscr;
          IsTrasparent:=true;PTCBackground:=0;
          Nptc:=4;Drawcode(PAINTCODE,1,6);

          CreaModifica:=0;
          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 textcolor(14);textbackground(CreaModifica*3+1);
                 rettangolo(CreaModifica*36+8,16,30,10,0);
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  textcolor(15);textbackground(CreaModifica*3+1);
                  rettangolo(CreaModifica*36+8,16,30,10,0);
                  end;
          delay(30);
          until(keypressed);
          textcolor(15);
          textbackground(CreaModifica*3+1);
          rettangolo(CreaModifica*36+8,16,30,10,0);
          ss:=readkey;
          until(qtasto('46ad'+chr(13)+chr(75)+chr(77),ss));
          if((qtasto('4a'+chr(75),ss))and(CreaModifica>0))then
                                      CreaModifica:=CreaModifica-1;
          if((qtasto('6d'+chr(77),ss))and(CreaModifica<1))then
                                         CreaModifica:=CreaModifica+1;
          until(ss=chr(13));
          clrscr;
          textbackground(0);
          clrscr;
          if(CreaModifica=0)then b:=1 else b:=4;
          textbackground(b);
          for i:=10 to 16 do
                begin
                gotoxy(21,i);
                write('                                        ');
                end;
          gotoxy(38,12);
          if(CreaModifica=0)then write('CREATE') else write('CHANGE');
          gotoxy(36,14);
          if(CreaModifica=0)then write('A  NEW ONE') else write('AN OLD ONE');

          Nptc:=8;
          DrawCode(PAINTCODE,1,48);
          gotoxy(38,50);
          textbackground(2);
          textcolor(15);
          write('  GO  ');

          if(CreaModifica=1)then
                 begin
                 n:=modifica;
                 bptc:=PTCBackground;
                 tptc:=isTrasparent;
                 textbackground(0);
                 textcolor(15);
                 gotoxy(25,23);
                 write('rename your file as : ');textcolor(12);write('input.ptc');
                 textcolor(15); gotoxy(22,25); write('and put it in the appliation''s folder');
                 end
                 else
                 begin
                    x:=5; y:=38;
                    textcolor(7);
                    textbackground(0);
                    rettangolo(x+4,y-3,74-2*x,9,0);
                    nn:=8;
                    for i:=1 to nn do
                    begin
                    contorno6(3+x+7*i,y+2,true,7);
                    gotoxy(3+x+7*i,y+2);textbackground(i-1);
                    write('   ');gotoxy(3+x+7*i,y+3);write('   ');
                    textbackground(0);
                    end;
                 textcolor(15);textbackground(0);
                 gotoxy(26,37);
                 write('choose the background color');

                 textbackground(0);
                 textcolor(15);
                 gotoxy(26,23);
                 write('write the name of the file');
                 gotoxy(26,25);
                 write('you want to create:');
                 repeat
                 nomeFile:='';
                 x:=46;y:=25;
                 s:=Scrittura(nomeFile,x,y);
                 until((s=chr(13))and(length(nomeFile)>0));
                 nomefile:=nomefile+'.ptc';
                 nn:=0;
                 repeat
                 repeat
                 v:=19;
                 x:=15+nn*7; y:=40;
                 repeat
                 v:=v+1;
                 if(v=20)then
                            begin
                            contorno6(x,y,false,15);
                            v:=2;
                            end;
                 if(v=10)then
                            contorno6(x,y,true,15);
                 delay(24);
                 until(keypressed);
                 contorno6(x,y,true,7);
                 s:=readkey;
                 until(qtasto('cbpt78941236qazxdews'+chr(13)+chr(75)+chr(77)+chr(72)+chr(80),s));
                 if((qtasto('741qaz'+chr(75),s))and(nn>0))then
                            nn:=nn-1;
                 if(qtasto('963edx'+chr(77),s))then
                          if(nn<7)then
                                  nn:=nn+1;
                 until(s=chr(13));
                 sfondo:=nn;
                 contorno6(x,y,true,14);

                 ntrasp:=attenzione(15,2,26,'you want to make the background trasparent?','NO£4 YES£2');
                 if(ntrasp=1)then begin IsTrasparent:=false; sfondoInvisibile:=false end else begin IsTrasparent:=true; sfondoInvisibile:=true; end;

                 end;


          pp:=1;
          repeat
          caso12:
          if(CreaModifica=1)then
                 begin
                 textbackground(0);
                 for i:=28 to 43 do
                      begin
                      gotoxy(32,i);
                      write('                    ');
                      end;
                 textcolor(15);
                 for j:=1 to 2 do
                 for i:=1 to mCaricamento do
                    begin
                    textbackground(7);
                    gotoxy(Caricamento[i,1],Caricamento[i,2]);
                    write(chr(219));
                    if(i>8)then
                          begin
                          gotoxy(Caricamento[i-8,1],Caricamento[i-8,2]);
                          textbackground(0);
                          write(' ');
                          end
                          else
                          if(j>1)then
                                 begin
                                 gotoxy(Caricamento[mCaricamento+i-8,1],Caricamento[mCaricamento+i-8,2]);
                                 textbackground(0);
                                 write(' ');
                                 end;
                    delay(5);
                    end;
                 Nptc:=n+5;
                 PTCBackground:=0;
                 isTrasparent:=false;
                 DrawCode(PAINTCODE,33,29);
                 if(n=1)then
                 begin
                 gotoxy(47,23);textcolor(15);textbackground(4);write('input.ptc');
                 delay(50);
                 gotoxy(47,23);textcolor(12);textbackground(0);write('input.ptc');
                 delay(50);
                 gotoxy(47,23);textcolor(15);textbackground(4);write('input.ptc');
                 delay(50);
                 gotoxy(47,23);textcolor(12);textbackground(0);write('input.ptc');
                 end;
                 gotoxy(38,50);
                 textbackground(2);
                 textcolor(15);
                 if(n>0)then
                        write('UPDATE')
                        else
                        write('  GO  ');

                 end;

          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 textcolor(14);textbackground(4-2*pp);
                 rettangolo(8+21*pp,50-2*pp,14+10*pp,3+2*pp,0);
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  textcolor(15);textbackground(4-2*pp);
                  rettangolo(8+21*pp,50-2*pp,14+10*pp,3+2*pp,0);
                  end;
          delay(30);
          until(keypressed);
          textcolor(15);
          textbackground(4-2*pp);
          rettangolo(8+21*pp,50-2*pp,14+10*pp,3+2*pp,0);
          ss:=readkey;
          until(qtasto('46ad'+chr(13)+chr(75)+chr(77),ss));
          if((qtasto('4a'+chr(75),ss))and(pp>0))then
                                      pp:=pp-1;
          if((qtasto('6d'+chr(77),ss))and(pp<1))then
                                         pp:=pp+1;
          until(ss=chr(13));
          if(pp=0)then
                  goto casoProgetto
                  else
                  if((n>0)AND(CreaModifica=1))then
                         begin
                         n:=modifica;
                         bptc:=PTCBackground;
                         tptc:=isTrasparent;
                         if(n=0)then
                                goto caso12;
                         end;

          until((n=0)or(CreaModifica=0));
          if(CreaModifica=1)then
                 begin
                 PTCBackground:=bptc;
                 isTrasparent:=tptc;
                 sfondo:=PTCBackground;
                 end;
          clrscr;

          if(CreaModifica=0)then
            for i:=1 to 120 do
             for j:=1 to 80 do
                begin
                schermata[j,i].color:=sfondo;
                schermata[j,i].ground:=sfondo;
                end;

          strumento:=0;
          end;

function inputTesto():char;
         var i,l,ll,v,xx,yy:integer;
             s:char;
             ss:string;
         begin
         strumento:=9;
         StrumentoSecondario:=false;
         FinestraTools(true);
         caso5:
         ss:='';
         repeat
         StrumentoSecondario:=false;
         FinestraTools(false);
         s:=cursore(x,y,0,'t');
         until((s<>chr(8))and(s<>'h'));
         if(s<>'t')then
         begin
         xx:=x; yy:=y;
         if(not hide )then begin textbackground(0); gotoxy(65,9); write('            '); end;

         StrumentoSecondario:=true;

         repeat
         s:=Scrittura(ss,x,y);
         if(s=chr(8))then
                     goto caso5;
         until(s=chr(13));
         for i:=1 to length(ss) do
                     begin
                     schermata[xx+i-1,y].color:=color;
                     schermata[xx+i-1,y].ground:=ground;
                     schermata[xx+i-1,y].text:=ss[i];
                     end;
         pulisci;
         goto caso5;
         end;
         strumento:=0;
         FinestraTools(false);
         inputTesto:=s;
         strumento:=9;
         end;

function inputTitolo():char;
         var i,xx1,xx2,yy1,yy2,m,mp,n:integer;
             PTAB,DTAB:tabella;
             OGG,POGG:oggetto;
             s:char;
             sss:string;
         label casoEnd1,casoStart1;
         begin
         strumento:=11;
         x:=10; x2:=71; y:=15; y2:=14+((10*Dimensione)+spRighe);
         StrumentoSecondario:=false;
         FinestraTools(true);

         casoStart1:
         title:=true;
         righee:=2;
         x:=10; x2:=71; y:=15; y2:=14+((10*Dimensione)+spRighe);
         StrumentoSecondario:=false;
         FinestraTools(false);

         m:=0;
         corniceTab:=cancTab;
         gostTab:=cancTab;
         DTAB:=cancTab;
         OGG:=DRettangolo(m,x,y,x2,y2);
         Disegna(EMPTY,OGG,m,chrGomma);
         repeat
         xx1:=x;xx2:=x2;yy1:=y;yy2:=y2;
         s:=attenditasto('htcpb78941236qazxdews'+chr(13)+chr(8)+chr(0));

         seHideShowCIB(OGG,m,s);
         if(s=chr(0))then
         s:=readkey;
         if((qtasto('741qaz',s))and(x>1))then begin x:=x-1;x2:=x2-1; end;
         if((qtasto('963edx',s))and(x2<80))then begin x:=x+1;x2:=x2+1; end;
         if((qtasto('789qwe',s))and(y>1))then begin y:=y-1;y2:=y2-1; end;
         if((qtasto('123zsx',s))and(y2<80))then begin y:=y+1;y2:=y2+1; end;
         if((s=chr(75))and(x<(x2-5-(8*Dimensione))))then x2:=x2-1;
         if((s=chr(77))and(x2<80))then x2:=x2+1;
         if((s=chr(72))and(y<(y2-((5*Dimensione)+spRighe))))then begin y2:=y2-((5*Dimensione)+spRighe); righee:=righee-1; end;
         if((s=chr(80))and(y2+((5*Dimensione)+spRighe)<81))then begin y2:=y2+((5*Dimensione)+spRighe); righee:=righee+1; end;

         if(not((x=xx1)and(y=yy1)and(x2=xx2)and(y2=yy2)))then
                    begin
                    ResetTools;
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=corniceTab;
                    OGG:=DRettangolo(m,x,y,x2,y2);
                    disegna(corniceTab,POGG,mp,'a');
                    disegna(PTAB,OGG,m,chrGomma);
                    end;
         until((s=chr(13))or(s=chr(8))or(s='t'));
         Disegna(EMPTY,OGG,m,'a');
         title:=false;
         if(s<>chr(13))then
                       goto casoEnd1;
         m:=0;
         PTAB:=cancTab;
         sss:='';
         textbackground(0); gotoxy(65,8); write('            ');
         textbackground(0); gotoxy(65,9); write('            ');
         StrumentoSecondario:=true;
         repeat
         s:=attenditasto('qwertyuioplkjhgfdsazxcvbnm1234567890 ''?!'+smTastiera+chr(13)+chr(8));

         if((ord(s)>64)and(ord(s)<91))then
                                      s:=chr(ord(s)+32);
         if((s<>chr(8))and(s<>chr(13))and(not((s=' ')and(sss[length(sss)]=' '))))then
                     sss:=sss+s;
         if(s=chr(8))then
                     if(length(sss)>0)then
                                      delete(sss,length(sss),1)
                                      else
                                      goto casoStart1;
         if((s<>' ')and(s<>chr(13)))then
                    begin
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=DTAB;
                    OGG:=DTitolo(m,x,y,x2,y2,sss,DTAB);
                    disegna(DTAB,POGG,mp,'a');
                    disegna(PTAB,OGG,m,text);
                    end;
         until(s=chr(13));
         casoEnd1:
         if(s=chr(13))then
                     fondi(OGG,m)
                     else
                     begin
                     disegna(EMPTY,OGG,m,'a');
                     m:=0;
                     end;
         pulisci;
         if(s=chr(13))then
              begin
              n:=attenzione(12,2,0,'would you like to apply some feature?','YES£2 NO£4 DEFAULT£1');
              if(n=1)then
                     Feature;
               if(not((n=2)or(nFeature=1)))then
                     DStile(OGG,m,nFeature,CFeature[nFeature,1],CFeature[nFeature,2],true);
              end;
         title:=false;
         inputTitolo:=s;
         CorniceTab:=cancTab;
         strumento:=0;
         FinestraTools(false);
         strumento:=11;
         end;

function inputRighello():char;
         var v,mp,m:integer;
             POGG,OGG:oggetto;
             PTAB,DTAB:tabella;
             s:char;
             b:boolean;
         begin
         strumento:=3;
         repeat
         StrumentoSecondario:=false;
         EstremoRetta:=true;
         FinestraTools(true);
         b:=false;
         s:=cursore(x,y,0,'t');
         if((s=chr(8))or(s='t')or(s='h')or(s='E'))then
                     begin
                     Setta(x,y);
                     m:=0;
                     goto caso1r;
                     end;
         pulisci;

         x2:=x;y2:=y;

         PTAB:=cancTab;
         OGG:=Dretta(x,y,x2,y2,m,DTAB);
         disegna(PTAB,OGG,m,text);
         b:=true;
         repeat
         StrumentoSecondario:=true;
         FinestraTools(b);
         b:=false;
         repeat
         v:=19;
         repeat
         v:=v+1;
         if((v=20)and(barra(x2,y2)))then
                 begin
                 cursorColor(x2,y2,1);
                 gotoxy(x2,y2);
                 write(chr(219));
                 v:=1;
                 end;
         if(v=10)then
                 begin
                 colora(x2,y2);
                 end;
         delay(30);
         until(keypressed);
         colora(x2,y2);
         s:=readkey;
         until(qtasto('cbpt78941236qazxdewsh '+smTastiera+chr(8)+chr(13)+chr(0),s));
         bbim:=false;
         if((ord(s)<91)and(ord(s)>64))then
                      bbim:=true;
         seHideShowCIB(OGG,m,s);
         if(s=chr(0))then
         s:=readkey;
         if(s=' ')then
                  begin
                  EstremoRetta:=not EstremoRetta;
                  scambia(x,x2);scambia(y,y2);
                  end;



         muovi(s,x2,y2);

         ResetTools;

         POGG:=OGG;
         mp:=m;
         PTAB:=DTAB;
         OGG:=Dretta(x,y,x2,y2,m,DTAB);
         disegna(DTAB,POGG,mp,'a');
         disegna(PTAB,OGG,m,text);
         until((s=chr(13))or(s=chr(8))or(s='t'));
         disegna(EMPTY,OGG,m,'a');
         m:=0;
         caso1r:
         pulisci;
         until(s='t');
         inputRighello:=s;
         strumento:=0;
         FinestraTools(false);
         strumento:=3;
         end;

function inputcopia():char;
         var i,j,ii,jj,z,v,n,nn,mp,ma,m,mn,md,mpp,xx,yy,xxx,yyy,xmax,ymax,xmin,ymin,ao,l,h,lnome1,c,g,natt:integer;
             TAB,PAREA:tabella;
             OGG,POGG,AREA,P,D,PAREAO:oggetto;
             b,bb,overW,besc:boolean;
             s,sp:char;
             ss:string;
             TABI:tabInteger;
             MM:array[1..1000]of integer;
             OGGOGG:array[1..1000]of oggetto;

         function se():boolean;
           begin
           case j+z*2 of
             -2: se:=(P[i,2]+z)>ymin;
             1: se:=(P[i,1]+j)<xmax;
             -1: se:=(P[i,1]+j)>xmin;
             2: se:=(P[i,2]+z)<ymax;
             end;
           end;
         function n_posx(n:integer):integer;
                  begin
                  if(n<11)then n_posx:=7*n                  // y = 4*n + 20
                          else
                          if(n<20)then n_posx:=7*n-67
                                  else
                                  n_posx:=7*n-123;
                  end;
         function n_posy(n:integer):integer;
                  begin
                  if(n<11)then n_posy:=22
                          else
                          if(n<20)then n_posy:=26
                                  else
                                  n_posy:=30;
                  end;
         procedure descrivi(n:integer);               // 7,50
                   begin
                   gotoxy(20,37);
                   if(ImmagineLHM[n,1]=0)then
                                        begin
                                        textcolor(7);
                                        write('there''s no saving in this letter                    ')
                                        end
                                        else
                                        begin
                                        textcolor(15);
                                        write(Descrizione[n],copy(spazio,1,52-length(Descrizione[n])));
                                        end;
                   end;

         procedure unifica();
                  var i,j:integer;
                      TAB:tabella;
                  begin
                  mn:=0;
                  TAB:=cancTab;
                  for i:=1 to m do
                     for j:=1 to MM[i] do
                        if(not TAB[OGGOGG[i][j,1],OGGOGG[i][j,2]])then
                               begin
                               incr(OGG,mn,OGGOGG[i][j,1],OGGOGG[i][j,2]);
                               TAB[OGGOGG[i][j,1],OGGOGG[i][j,2]]:=true;
                               end;
                  end;
         begin
         nCopy:=2;                                                                      //secondario false => cursore ; true => rettangolo
         repeat
         bb:=true;
         strumento:=4;
         nlamp:=0;
         nxlamp:=0;
         nylamp:=0;

         gostTab:=cancTab;
         TArea:=cancTab;
         StrumentoSecondario:=false;
         FinestraTools(true);
         repeat
         s:=cursore(x,y,0,'t ');
         if(s=' ')then
                  begin
                  if(nCopy<3)then
                            nCopy:=nCopy+1
                            else
                            nCopy:=1;
                  FinestraTools(true);
                  end;
         if((s=chr(8))or(s='t')or(s='h')or(s='E'))then
                     begin
                     Setta(x,y);
                     m:=0;
                     end;
         until(not qtasto('hE '+chr(8),s));
         pulisci;
         xx:=x; yy:=y;

         if(s<>'t')then
         begin
         title:=true;
         mp:=0;m:=0;ma:=0;ao:=0;
         corniceTab:=cancTab;
         incr(OGG,m,x,y); corniceTab[x,y]:=true; incr(AREA,ma,x,y); TArea[x,y]:=true;
         disegna(EMPTY,OGG,m,chrGomma);
         PAREA:=cancTab;

         if(nCopy=1)then
           begin
           EstremoRetta:=true;
           StrumentoSecondario:=true;
           b:=false;
           x2:=x;y2:=y;

           FinestraTools(true);

           b:=true;
           repeat
           bb:=false;
           FinestraTools(b);

           b:=false;
           repeat
           v:=19;
           repeat
           v:=v+1;

           if(v mod 4=0)then
                        lampeggio(OGG,m);

           if((v=20)and(barra(x2,y2)))then
                 begin
                 cursorColor(x2,y2,1);
                 gotoxy(x2,y2);
                 write(chr(219));
                 v:=1;
                 end;
           if(v=10)then
                 colora(x2,y2);
           delay(20);
           until(keypressed);
           colora(x2,y2);
           s:=readkey;
           until(qtasto('cbpt78941236qazxdewsh '+chr(8)+chr(13)+chr(0),s));
           if(s=' ')then
                  begin
                  EstremoRetta:=not EstremoRetta;
                  scambia(x,x2);scambia(y,y2);
                  end;
           if(s=chr(8))then
                       begin
                       strumento:=0;
                       Disegna(EMPTY,AREA,ma,'a');
                       strumento:=4;
                       bb:=true;
                       end
                       else
                       begin
                       seHideShowCIB(AREA,ma,s);
                       if(s=chr(0))then
                                   s:=readkey;
                       muovi(s,x2,y2);
                       ResetTools;
                       POGG:=OGG;
                       mp:=m;
                       OGG:=Drettangolo(m,x,y,x2,y2);
                       AREA:=DRettangoloPieno(ma,x,y,x2,y2,TArea);
                       disegna(corniceTab,POGG,mp,'a');
                       lampeggio(OGG,m);
                       end;

           until((s=chr(13))or(bb)or(s='t'));

           end
           else
           if(nCopy=2)then
           begin
           FinestraTools(true);
           incr(OGG,m,x,y); corniceTab[x,y]:=true;
           repeat
           bb:=false;

           repeat
           v:=19;
           repeat
           v:=v+1;
           if(v mod 4=0)then
                        lampeggio(OGG,m);
           if((v=20)and(barra(x,y)))then
                 begin
                 cursorColor(x,y,1);
                 gotoxy(x,y);
                 write(chr(219));
                 v:=1;
                 end;
           if(v=10)then
                 colora(x,y);
           delay(30-(m div 30));
           until(keypressed);
           colora(x,y);
           s:=readkey;
           until(qtasto('78941236qazxdewscpbht'+chr(8)+chr(13)+chr(0),s));

           seHideShowCIB(OGG,m,s);

           if(s=chr(0))then
                       s:=readkey;

           xxx:=x;yyy:=y;
           if(s=chr(8))then
                     begin
                     if(m>1)then
                            begin
                            corniceTab[OGG[m,1],OGG[m,2]]:=false;
                            for i:=1 to m-1 do
                               if((OGG[i,1]=OGG[m,1])and(OGG[i,2]=OGG[m,2]))then
                                          corniceTab[OGG[m,1],OGG[m,2]]:=true;
                            if(not TAREA[OGG[m,1],OGG[m,2]])then
                                                            strumento:=0;
                            setta(OGG[m,1],OGG[m,2]);
                            strumento:=4;
                            m:=m-1;
                            x:=OGG[m,1]; y:=OGG[m,2];
                            end
                            else
                            bb:=true;
                     end;

           muovi(s,x,y);
           if(s<>chr(8))then
           if(not((x=xxx)and(y=yyy)))then
                                     begin incr(OGG,m,x,y); corniceTab[x,y]:=true; end;
           ResetTools;
           TArea:=cancTab;
           DRetta(xx,yy,x,y,cacca,TArea);
           TArea:=unisciTab(TArea,corniceTab);

           xmax:=OGG[1,1];xmin:=OGG[1,1]; ymax:=OGG[1,2];ymin:=OGG[1,2];
           for i:=1 to m do
               begin
               if(OGG[i,1]<xmin)then
                                xmin:=OGG[i,1];
               if(OGG[i,1]>xmax)then
                                xmax:=OGG[i,1];
               if(OGG[i,2]<ymin)then
                                ymin:=OGG[i,2];
               if(OGG[i,2]>ymax)then
                                ymax:=OGG[i,2];
               end;
           xmin:=xmin-1; xmax:=xmax+1; ymin:=ymin-1; ymax:=ymax+1;
           md:=0;
           TAB:=cancTab;
           for i:=ymin to ymax do
                begin
                incr(D,md,xmin,i);incr(D,md,xmax,i);
                TAB[xmin,i]:=true;
                TAB[xmax,i]:=true;
                end;
           for i:=xmin to xmax do
                begin
                incr(D,md,i,ymin);incr(D,md,i,ymax);
                TAB[i,ymin]:=true;
                TAB[i,ymax]:=true;
                end;

           repeat
           P:=D; mpp:=md;
           md:=0;
           for i:=1 to mpp do
             begin
             for j:=-1 to 1 do
                for z:=-1 to 1 do
                   if(abs(j+z)=1)then
                      if((not TArea[P[i,1]+j,P[i,2]+z])and(not TAB[P[i,1]+j,P[i,2]+z])and(se))then
                               begin
                               TAB[P[i,1]+j,P[i,2]+z]:=true;
                               incr(D,md,P[i,1]+j,P[i,2]+z);
                               end;
             end;
           until(md=0);

           TArea:=cancTab;
           ma:=0;
           for i:=xmin to xmax do
              for j:=ymin to ymax do
                   if(not TAB[i,j])then
                         begin
                         incr(Area,ma,i,j);
                         TArea[i,j]:=true;
                         end;
           strumento:=0;
           disegna(TAREA,PAREAO,ao,'a');
           strumento:=4;
           disegna(PAREA,Area,ma,'a');
           PAREAO:=AREA; ao:=ma;  PAREA:=TArea;
           lampeggio(OGG,m);
           until((s=chr(13))or(s='t')or(bb));

           end
           else
           begin
           sp:=' ';
           mn:=0;
           m:=0;
           for i:=1 to 1000 do
               MM[i]:=0;

           for i:=1 to 80 do
            for j:=1 to 80 do
              TABI[i,j]:=0;
           z:=0;
           for j:=1 to 80 do
             for i:=1 to 80 do
              if(Tabi[j,i]=0)then
                       begin
                       z:=z+1;
                       for jj:=1 to 80 do
                         for ii:=1 to 80 do
                          if((schermata[j,i].text=schermata[jj,ii].text)and(schermata[j,i].ground=schermata[jj,ii].ground)and(schermata[j,i].color=schermata[jj,ii].color))then
                             if(Tabi[jj,ii]=0)then
                                      Tabi[jj,ii]:=z;
                       end;
           m:=m+1;
           OGGOGG[m]:=Dsecchio(MM[m],TABI,x,y,caccaTab);
           unifica;
           corniceTab:=cancTab;
           for i:=1 to mn do
              corniceTab[OGG[i,1],OGG[i,2]]:=true;

           for i:=1 to mn do
                   if(gotoxyb(OGG[i,1],OGG[i,2]))then
                                begin
                                textcolor(inverticolori(schermata[OGG[i,1],OGG[i,2]].color));
                                textbackground(inverticolori(schermata[OGG[i,1],OGG[i,2]].ground));
                                write(schermata[OGG[i,1],OGG[i,2]].text);
                                end;

           FinestraTools(true);
           repeat
           besc:=false;
           bb:=false;

           repeat
           v:=19;
           repeat
           v:=v+1;
           if((v+1) mod 4=0)then
                        lampeggioArea(OGG,mn);

           if((v=20)and(gotoxyb(x,y)))then
                 begin
                 cursorColor(x,y,1);
                 write(chr(219));
                 v:=1;
                 end;
           if(v=10)then
                 if(not corniceTab[x,y])then
                    setta(x,y)
                    else
                    if (((y+nylamp)mod 3=0)and((x+nxlamp)mod 4=0))then
                                 colora(x,y)
                                 else
                                 if(gotoxyb(x,y))then
                                     begin
                                     textcolor(inverticolori(schermata[x,y].color));
                                     textbackground(inverticolori(schermata[x,y].ground));
                                     write(schermata[x,y].text);
                                     end;
           delay(20);
           until(keypressed);
           if(not corniceTab[x,y])then
              setta(x,y)
              else
              if (((y+nylamp)mod 3=0)and((x+nxlamp)mod 4=0))then
              colora(x,y)
              else
              if(gotoxyb(x,y))then
                   begin
                   textcolor(inverticolori(schermata[x,y].color));
                   textbackground(inverticolori(schermata[x,y].ground));
                   write(schermata[x,y].text);
                   end;
           s:=readkey;
           until(qtasto('cbpt78941236qazxdewsh'+chr(8)+chr(13)+chr(0),s));
           if(s=chr(8))then
                       begin
                       strumento:=0;
                       Disegna(EMPTY,OGGOGG[m],MM[m],'a');
                       strumento:=4;
                       gotoxy(1,1);
                       if(m>0)then
                              begin
                              m:=m-1;
                              if(m=0)then bb:=true;
                              unifica;
                              corniceTab:=cancTab;
                              for i:=1 to mn do
                                  corniceTab[OGG[i,1],OGG[i,2]]:=true;
                              end
                              else
                              bb:=true;
                       end
                       else
                       begin
                       seHideShowCIB(OGG,mn,s);
                       if(s=chr(0))then
                                   s:=readkey;
                       muovi(s,x,y);
                       ResetTools;
                       if(s=chr(13))then
                                    begin
                                    for i:=1 to mn do
                                        if((OGG[i,1]=x)and(OGG[i,2]=y))then
                                             besc:=true;
                                    if(not besc)then
                                                begin
                                                m:=m+1;
                                                OGGOGG[m]:=Dsecchio(MM[m],TABI,x,y,caccaTab);
                                                unifica;
                                                corniceTab:=cancTab;
                                                for i:=1 to mn do
                                                      corniceTab[OGG[i,1],OGG[i,2]]:=true;
                                                end;
                                    for i:=1 to mn do
                                        if(gotoxyb(OGG[i,1],OGG[i,2]))then
                                           if (((OGG[i,2]+nylamp)mod 3=0)and((OGG[i,1]+nxlamp)mod 4=0))then
                                           colora(OGG[i,1],OGG[i,2])
                                           else
                                           begin
                                           textcolor(inverticolori(schermata[OGG[i,1],OGG[i,2]].color));
                                           textbackground(inverticolori(schermata[OGG[i,1],OGG[i,2]].ground));
                                           write(schermata[OGG[i,1],OGG[i,2]].text);
                                           end;
                                    end;
                       end;
           if(besc)then
                   begin
                   strumento:=0;
                   nn:=attenzione(12,1,0,'would you confirm the selection?','YES£2 NO£4');
                   strumento:=4;
                   if(nn=2)then
                          begin
                          besc:=false;
                          for i:=1 to mn do
                           if(gotoxyb(OGG[i,1],OGG[i,2]))then
                                begin
                                textcolor(inverticolori(schermata[OGG[i,1],OGG[i,2]].color));
                                textbackground(inverticolori(schermata[OGG[i,1],OGG[i,2]].ground));
                                write(schermata[OGG[i,1],OGG[i,2]].text);
                                end;
                          end;
                   end;

           AREA:=OGG;  ma:=mn;
           TAREA:=corniceTab;
           xmax:=OGG[1,1];xmin:=OGG[1,1]; ymax:=OGG[1,2];ymin:=OGG[1,2];
           for i:=1 to mn do
               begin
               if(OGG[i,1]<xmin)then
                                xmin:=OGG[i,1];
               if(OGG[i,1]>xmax)then
                                xmax:=OGG[i,1];
               if(OGG[i,2]<ymin)then
                                ymin:=OGG[i,2];
               if(OGG[i,2]>ymax)then
                                ymax:=OGG[i,2];
               end;
           sp:=s;
           until((besc)or(bb)or(s='t'));

           end;
           end;
           if(s='t')then bb:=false;
           until(not bb);
           if(s<>'t')then
           begin
           if(s=chr(13))then
           begin
           corniceTab:=cancTab;
           for i:=1 to m do
              setta(OGG[i,1],OGG[i,2]);
           end;
           strumento:=0;
           for i:=1 to ma do
              setta(AREA[i,1],AREA[i,2]);
           strumento:=4;
           if(nCopy=1)then
                      begin
                      l:=abs(x2-x)+1;
                      h:=abs(y2-y)+1;
                      end
                      else
                      begin
                      if(nCopy=2)then begin xmin:=xmin+1; xmax:=xmax-1; ymin:=ymin+1; ymax:=ymax-1; end;
                      l:=xmax-xmin+1;
                      h:=ymax-ymin+1;
                      end;

      natt:=attenzione(12,1,0,'which function do you want','COPY£1 MOVE£1');

      if(natt=1)then
        begin
           textcolor(15);textbackground(0);
           ss:=copy(chr223,1,72);
           gotoxy(4,15);write(chr(219),ss,chr(219));
           ss:=copy(spazio,1,72);
           for i:=16 to 40 do
                begin
                gotoxy(4,i);write(chr(219),ss,chr(219));
                end;
           ss:=copy(chr220,1,72);
           gotoxy(4,41);write(chr(219),ss,chr(219));
           textbackground(sfondo);
           for i:=15 to 41 do
            begin
            gotoxy(77,i);write(chr(219));
            end;
           textbackground(0);
           textcolor(12); gotoxy(28,17);
           write('Save the image in a letter');
           textcolor(12);
           gotoxy(7,37);
           write('Description:');
           i:=1;
           while((ImmagineLHM[i,1]<>0)and(i<27))do
                i:=i+1;
           if(i=27)then i:=15;
           n:=i;
           textcolor(15);
           for i:=1 to 26 do
              begin
              textcolor(7);
              rettangolo(n_posx(i),n_posy(i),5,3,0);
              if(ImmagineLHM[i,1]=0)then
                                   textcolor(15)
                                   else
                                   textcolor(12);
              gotoxy(n_posx(i)+2,n_posy(i)+1);
              write(chr(ord(stastiera[i])-32));
              end;
           repeat
           descrivi(n);
           repeat
           repeat
           v:=19;
           repeat
           v:=v+1;
           if(v=20)then
                 begin
                 textcolor(14);
                 rettangolo(n_posx(n),n_posy(n),5,3,0);
                 v:=2;
                 end;
           if(v=10)then
                 begin
                 descrivi(n);
                 textcolor(15);
                 rettangolo(n_posx(n),n_posy(n),5,3,0);
                 end;
           delay(24);
           until(keypressed);
           textcolor(7);
           rettangolo(n_posx(n),n_posy(n),5,3,0);
           s:=readkey;
           until(qtasto('78941236QWERTYUIOPASDFGHJKLZXCVBNM'+sTastiera+chr(13)+chr(0),s));
           if((ord(s)>64)and(ord(s)<91))then
                      s:=chr(ord(s)+32);
           if((ord(s)>96)and(ord(s)<123))then
                      n:=nTastiera(s)
                      else
                      begin
                      if(s=chr(0))then
                                  s:=readkey;
                      if((qtasto('741qaz'+chr(75),s))and(n<>1)and(n<>11)and(n<>20))then
                            n:=n-1;
                      if((qtasto('963edx'+chr(77),s))and(n<>10)and(n<>19)and(n<>26))then
                            n:=n+1;
                      if((qtasto('789qwe'+chr(72),s))and(n>10))then
                             if(n>19)then
                                     n:=n-8
                                     else
                                     n:=n-10;
                      if((qtasto('123zsx'+chr(80),s))and(n<20))then
                             if(n<11)then
                                     begin
                                     n:=n+10;
                                     if(n=20)then
                                             n:=19;
                                     end
                                     else
                                     begin
                                     if(n=11)then
                                             n:=20
                                             else
                                             if(n=19)then
                                                     n:=26
                                                     else
                                                     n:=n+8;
                                     end;
                      end;
           until(not qtasto('78941236'+sTastiera,s));
           descrivi(n);
           overW:=true;
           if(ImmagineLHM[n,1]<>0)then
                                 begin
                                 if(attenzione(12,2,24,'are you sure to overwrite the saving?','YES£2 NO£4')=2)then
                                                         overW:=false
                                                         else
                                                         overW:=true;
                                 for i:=24 to 32 do
                                      begin
                                      gotoxy(17,i);
                                      write(copy(spazio,1,47));
                                      end;
                                 textcolor(15);
                                 for i:=1 to 26 do
                                          begin
                                          textcolor(7);
                                          rettangolo(n_posx(i),n_posy(i),5,3,0);
                                          if(ImmagineLHM[i,1]=0)then
                                                        textcolor(15)
                                                        else
                                                        textcolor(12);
                                          gotoxy(n_posx(i)+2,n_posy(i)+1);
                                          write(chr(ord(stastiera[i])-32));
                                          end;
                                 end;
           if(overW)then
                    begin
                    gotoxy(n_posx(n)+2,n_posy(n)+1); textcolor(9);
                    write(chr(ord(stastiera[n])-32));
                    end;
           until(overW);

           immagineLHM[n,1]:=l;  immagineLHM[n,2]:=h;
           immagineLHM[n,3]:=0;
           Descrizione[n]:='';
           gotoxy(20,37); write(copy(spazio,1,52));
           for i:=1 to ma do
              for j:=1 to ma-1 do
                  if(AREA[j,2]>AREA[j+1,2])then
                         begin
                         cacca:=AREA[j+1,2];
                         AREA[j+1,2]:=AREA[j,2];
                         AREA[j,2]:=cacca;
                         cacca:=AREA[j+1,1];
                         AREA[j+1,1]:=AREA[j,1];
                         AREA[j,1]:=cacca;
                         end;
           ii:=1; jj:=1;
           while(jj<ma)do
           begin
           while((AREA[ii,2]=AREA[jj,2])and(jj<ma))do
                jj:=jj+1;
           for i:=ii to jj-1 do
              for j:=ii to jj-2 do
                  if(AREA[j,1]>AREA[j+1,1])then
                         begin
                         cacca:=AREA[j+1,2];
                         AREA[j+1,2]:=AREA[j,2];
                         AREA[j,2]:=cacca;
                         cacca:=AREA[j+1,1];
                         AREA[j+1,1]:=AREA[j,1];
                         AREA[j,1]:=cacca;
                         end;
           ii:=jj;
           end;

           for i:=1 to ma do
                 incrImm(immagine,n,immagineLHM[n,3],AREA[i,1],AREA[i,2],schermata[AREA[i,1],AREA[i,2]].color,schermata[AREA[i,1],AREA[i,2]].ground,schermata[AREA[i,1],AREA[i,2]].text);

           gotoxy(24,35); textcolor(14);
           write('Give a description of your image');
           c:=color;
           g:=ground;
           color:=15;
           ground:=0;
           i:=20; j:=37;
           repeat
           until(scrittura(Descrizione[n],i,j)=chr(13));
           color:=c;
           ground:=g;
           end;

           strumento:=0;
           for i:=15 to 41 do
              for j:=4 to 77 do
                   setta(j,i);

      end;
      if(natt=2)then
      begin
           immagineLHM[27,1]:=l;  immagineLHM[27,2]:=h;
           immagineLHM[27,3]:=0;
           for i:=1 to ma do
              for j:=1 to ma-1 do
                  if(AREA[j,2]>AREA[j+1,2])then
                         begin
                         cacca:=AREA[j+1,2];
                         AREA[j+1,2]:=AREA[j,2];
                         AREA[j,2]:=cacca;
                         cacca:=AREA[j+1,1];
                         AREA[j+1,1]:=AREA[j,1];
                         AREA[j,1]:=cacca;
                         end;
           ii:=1; jj:=1;
           while(jj<ma)do
           begin
           while((AREA[ii,2]=AREA[jj,2])and(jj<ma))do
                jj:=jj+1;
           for i:=ii to jj-1 do
              for j:=ii to jj-2 do
                  if(AREA[j,1]>AREA[j+1,1])then
                         begin
                         cacca:=AREA[j+1,2];
                         AREA[j+1,2]:=AREA[j,2];
                         AREA[j,2]:=cacca;
                         cacca:=AREA[j+1,1];
                         AREA[j+1,1]:=AREA[j,1];
                         AREA[j,1]:=cacca;
                         end;
           ii:=jj;
           end;
      for i:=1 to ma do
          begin
          incrImm(immagine,27,immagineLHM[27,3],AREA[i,1],AREA[i,2],schermata[AREA[i,1],AREA[i,2]].color,schermata[AREA[i,1],AREA[i,2]].ground,schermata[AREA[i,1],AREA[i,2]].text);
          schermata[AREA[i,1],AREA[i,2]].ground:=sfondo;schermata[AREA[i,1],AREA[i,2]].text:=chr(0);schermata[AREA[i,1],AREA[i,2]].color:=sfondo;
          end;

      gostTab:=canctab;
      incolla('£');
      gostTab:=canctab;

      end;
           corniceTab:=cancTab;
           title:=false;
           TArea:=cancTab;
           pulisci;
           FinestraTools(true);
           strumento:=4;
           inputCopia:='t';
           end;

procedure inputDimensione();
          var i,j,x,x2,y,y2,m,mp,xx1,xx2,yy1,yy2:integer;
              OGG,POGG:oggetto;
              PTAB:tabella;
              s:char;
          begin
          if(not Hide)then
                      HideShow;
          HideShowDime;
          title:=true;
          x:=9; x2:=72; y:=12; y2:=49;
          m:=0;
          corniceTab:=cancTab;
          gostTab:=cancTab;
          OGG:=DRettangolo(m,x,y,x2,y2);
          Disegna(EMPTY,OGG,m,chrGomma);
          repeat
          xx1:=x;xx2:=x2;yy1:=y;yy2:=y2;
          s:=attenditasto('h78941236qazxdews'+chr(13)+chr(8)+chr(0));
          if(s='h')then
                  begin
                  gostTab:=cancTab;
                  for i:=1 to m do
                     gostTab[OGG[i,1],OGG[i,2]]:=true;
                  HideShowDime;
                  gostTab:=cancTab;
                  end;
          if(s=chr(0))then
          s:=readkey;
          if((qtasto('741qaz',s))and(x>0))then begin x:=x-1;x2:=x2-1; end;
          if((qtasto('963edx',s))and(x2<81))then begin x:=x+1;x2:=x2+1; end;
          if((qtasto('789qwe',s))and(y>0))then begin y:=y-1;y2:=y2-1; end;
          if((qtasto('123zsx',s))and(y2<80))then begin y:=y+1;y2:=y2+1; end;
          if((s=chr(75))and(x+2<x2))then x2:=x2-1;
          if((s=chr(77))and(x2<81))then x2:=x2+1;
          if((s=chr(72))and(y+2<y2))then y2:=y2-1;
          if((s=chr(80))and(y2<80))then y2:=y2+1;

          if(not((x=xx1)and(y=yy1)and(x2=xx2)and(y2=yy2)))then
                    begin
                    POGG:=OGG;
                    mp:=m;
                    PTAB:=corniceTab;
                    OGG:=DRettangolo(m,x,y,x2,y2);
                    disegna(corniceTab,POGG,mp,'a');
                    disegna(PTAB,OGG,m,chrGomma);
                    end;
          until((s=chr(13))or(s=chr(8))or(s='t'));
          Disegna(EMPTY,OGG,m,'a');
          gostTab:=cancTab;
          if(not HideDime)then
                   HideShowDime;
          title:=false;
          gotoxy(1,1);
          x1s:=x+1;x2s:=x2-1;
          y1s:=y+1;y2s:=y2-1;
          if((s=chr(8))or(s='t'))then begin pulisci; strumento:=0; goto casoInizio; end;
          end;

procedure inputTools();
          var i,j,x,y,l,h,v:integer;
              s:string;
              c,cc:char;
              b,boolColonne,boolL,boolRighe,boolH:boolean;
          begin
          if(Hide)then
                  HideShow;
          if(strumento=8)then
                         b:=true
                         else
                         b:=false;
          textcolor(15);textbackground(0);
          s:=copy(chr223,1,72);
          gotoxy(4,13);write(chr(219),s,chr(219));
          gotoxy(4,15);write(chr(219),s,chr(219));
          s:=copy(spazio,1,72);
          for i:=14 to 52 do
               if(i<>15)then
                begin
                gotoxy(4,i);write(chr(219),s,chr(219));
                end;
          s:=copy(chr220,1,72);
          gotoxy(4,53);write(chr(219),s,chr(219));
          textbackground(sfondo);
          for i:=13 to 53 do
            begin
            gotoxy(77,i);write(chr(219));
            end;
          textbackground(0);
          textcolor(12);
          gotoxy(6,14);
          write('TOOLS');
          for i:=1 to 13 do
          if(i<13)then
            begin
            textcolor(7);
            textbackground(1);
            x:=20-(i mod 2)*14;
            y:=((i-1)div 2)*5+18;
            l:=15-(i mod 2)*3;
            h:=3;
            gotoxy(x+1,y+1);
            if(i mod 2=0)then
                         write('             ')
                         else
                         write('          ');
            rettangolo(x,y,l,h,0);
            textbackground(1);
            textcolor(15);gotoxy((l-length(strumenti[i]))div 2+x,y+1);
            write(strumenti[i]);
            end
            else
            begin
            textcolor(7);textbackground(2);
            gotoxy(7,49);write('                           ');
            rettangolo(6,48,29,3,0);
            textbackground(2);textcolor(15);gotoxy(17,49);write('COMPILE');
            end;
          textbackground(0);
          for i:=16 to 52 do
              begin
              gotoxy(36,i);
              write(chr(179),chr(179));
              end;

          casoTools:
          x:=1-(strumento mod 2);
          y:=(strumento-1)div 2;
          if(strumento=0)then
                         x:=0;

          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if((v mod 20)=0)then
                 begin
                 textcolor(14);
                 if(y<6)then
                        begin
                        textbackground(1);
                        rettangolo(6+(x*14),y*5+18,12+(3*x),3,0)
                        end
                        else
                        begin
                        textbackground(2);
                        rettangolo(6,48,29,3,0);
                        end;
                 end;
          if(((v+10)mod 20)=0)then
                  begin
                  textcolor(7);
                  if(y<6)then
                        begin
                        textbackground(1);
                        rettangolo(6+(x*14),y*5+18,12+(3*x),3,0)
                        end
                        else
                        begin
                        textbackground(2);
                        rettangolo(6,48,29,3,0);
                        end;
                  end;
          delay(22);
          if(v=35)then
                  begin
                  Nptc:=15+y*2+x;IsTrasparent:=false;
                  if(y=6)then begin
                          textbackground(0);
                          for j:=16 to 52 do
                             begin
                             gotoxy(38,j);
                             write('                                       ');
                             end;
                             end
                             else
                  Drawcode(PAINTCODE,38,16);
                  if(Nptc=21)then
                             begin
                             textcolor(15);textbackground(0);gotoxy(63,32);
                             write(nColonne);
                             gotoxy(63,36);write(lcella);
                             gotoxy(63,41);write(nrighe);
                             gotoxy(63,45);write(hcella);
                             end;
                  end;

          if(v=10000000)then v:=2;
          until(keypressed);
          textcolor(7);
          if(y<6)then
                 begin
                 textbackground(1);
                 rettangolo(6+(x*14),y*5+18,12+(3*x),3,0)
                 end
                 else
                 begin
                 textbackground(2);
                 rettangolo(6,48,29,3,0);
                 end;
          c:=readkey;
          until(qtasto('78941236qazxdews'+chr(13)+chr(0),c));
          if(s=chr(0))then
                      s:=readkey;
          if((qtasto('741qaz'+chr(75),c))and(x>0))then
                            x:=x-1;
          if((qtasto('963edx'+chr(77),c))and(x<1))then
                            x:=x+1;
          if((qtasto('789qwe'+chr(72),c))and(y>0))then
                            y:=y-1;
          if((qtasto('123zsx'+chr(80),c))and(y<6))then
                            y:=y+1;
          if((c=chr(13))and(y=6))then
                    begin
                    strumento:=13;
                    if(attenzione(12,2,0,'Are you sure to compile the Project?','YES£2 NO£4')=2)then
                          c:=' ';
                    for i:=6 to 10 do
                      if(i mod 2=0)then
                      begin
                      textcolor(7);
                      textbackground(1);
                      gotoxy(20-(i mod 2)*14+1,((i-1)div 2)*5+18+1);
                      if(i mod 2=0)then
                         write('             ')
                         else
                         write('          ');
                      rettangolo(20-(i mod 2)*14,((i-1)div 2)*5+18,15-(i mod 2)*3,3,0);
                      textbackground(1);
                      textcolor(15);gotoxy((15-(i mod 2)*3-length(strumenti[i]))div 2+20-(i mod 2)*14,((i-1)div 2)*5+18+1);
                      write(strumenti[i]);
                      end
                    end;
          until(c=chr(13));
          strumento:=y*2+x+1;
          if(y=6)then strumento:=13;
          textbackground(0);
          for j:=16 to 52 do
              begin
              gotoxy(38,j);
              write('                                       ');
              end;

          if(strumento=11)then
                          begin
                          Nptc:=10;isTrasparent:=true;PTCBackground:=0;
                          DrawCode(PAINTCODE,38,16);
                          Nptc:=Dimensione+10;
                          DrawCode(PAINTCODE,38,16);
                          gotoxy(56,36);textcolor(15);textbackground(0);
                          write(Dimensione);
                          gotoxy(57,41);textcolor(15);textbackground(0);
                          write(spRighe);
                          gotoxy(52,46);textcolor(15);textbackground(0);
                          if(Layout)then
                                    write('CENTRE')
                                    else
                                    write('SIDE  ');
                          x:=2;y:=4;



          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 textcolor(14);
                 if(y<4)then
                        begin
                        textbackground(0);
                        rettangolo(40,30+5*y,20,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,50,12,3,0);
                        end;
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  textcolor(7);
                  if(y<4)then
                        begin
                        textbackground(0);
                        rettangolo(40,30+5*y,20,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,50,12,3,0);
                        end;
                  end;
          delay(22);
          until(keypressed);
          textcolor(7);
          if(y<4)then
                        begin
                        textbackground(0);
                        rettangolo(40,30+5*y,20,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,50,12,3,0);
                        end;
          c:=readkey;
          if( (((c='+')or(c='-'))and(y<3))or((c=' ')and(y=3)) )then
                      begin
                      if(y=1)then
                             begin
                             if((c='+')and(Dimensione<3))then
                                        Dimensione:=Dimensione+1;
                             if((c='-')and(Dimensione>1))then
                                        Dimensione:=Dimensione-1;
                             textbackground(0);textcolor(15);
                             gotoxy(56,36);write(Dimensione);
                             for j:=16 to 32 do
                             begin
                             gotoxy(38,j);
                             write('                                       ');
                             end;
                             Nptc:=Dimensione+10;isTrasparent:=true;PTCBackground:=0;
                             DrawCode(PAINTCODE,38,16);
                             end
                             else
                             if(y=2)then
                                    begin
                                    if((c='+')and(spRighe<9))then
                                        spRighe:=spRighe+1;
                                    if((c='-')and(spRighe>1))then
                                        spRighe:=spRighe-1;
                                    textbackground(0);textcolor(15);
                                    gotoxy(57,41);write(spRighe);
                                    end
                                    else
                                    begin
                                    Layout:=not Layout;
                                    textbackground(0);textcolor(15);
                                    gotoxy(52,46);if(Layout)then write('CENTRE') else write('SIDE  ');
                                    end;
                      end;

          until(qtasto('78941236qazxdews'+chr(13)+chr(0),c));
          if(s=chr(0))then
                      s:=readkey;
          if((qtasto('741qaz'+chr(75),c))and(x>1))then
                            x:=x-1;
          if((qtasto('963edx'+chr(77),c))and(x<2))then
                            x:=x+1;
          if((qtasto('789qwe'+chr(72),c))and(y>1))then
                            y:=y-1;
          if((qtasto('123zsx'+chr(80),c))and(y<4))then
                            y:=y+1;

          until((c=chr(13))and(y=4));

          if((c=chr(13))and(y=4)and(x=1))then
            begin
            textbackground(0);
            for j:=16 to 52 do
              begin
              gotoxy(38,j);
              write('                                       ');
              end;
            goto casoTools;
            end;


                          end;






if(strumento=7)then
                          begin
                          Nptc:=14;isTrasparent:=true;PTCBackground:=0;
                          DrawCode(PAINTCODE,38,16);

                          gotoxy(57,31);textcolor(15);textbackground(0);
                          write(nColonne);
                          gotoxy(57,35);textcolor(15);textbackground(0);
                          write(lcella);
                          gotoxy(57,40);textcolor(15);textbackground(0);
                          write(nRighe);
                          gotoxy(57,44);textcolor(15);textbackground(0);
                          write(hcella);

                          nColonnemax:=79 div (lcella+1);
                          lcellamax:=(79 div nColonne)-1;
                          nRighemax:=79 div (hcella+1);
                          hcellamax:=(79 div nRighe)-1;

                          gotoxy(70,31);textcolor(11);textbackground(0);
                          write(nColonnemax,' ');
                          gotoxy(70,35);textcolor(11);textbackground(0);
                          write(lcellamax,' ');
                          gotoxy(70,40);textcolor(11);textbackground(0);
                          write(nRighemax,' ');
                          gotoxy(70,44);textcolor(11);textbackground(0);
                          write(hcellamax,' ');



                          x:=2;y:=5;
                          boolColonne:=false;
                          boolL:=false;
                          boolRighe:=false;
                          boolH:=false;


          repeat
          repeat
          v:=19;
          repeat
          v:=v+1;
          if(v=20)then
                 begin
                 textcolor(14);
                 if(y<5)then
                        begin
                        textbackground(0);
                        rettangolo(40,26+(4*y)+((y-1) div 2),21,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,48,12,3,0);
                        end;
                 v:=2;
                 end;
          if(v=10)then
                  begin
                  textcolor(7);
                  if(y<5)then
                        begin
                        textbackground(0);
                        rettangolo(40,26+(4*y)+((y-1) div 2),21,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,48,12,3,0);
                        end;
                  end;
          delay(22);
          until(keypressed);
          textcolor(7);
          if(y<5)then
                        begin
                        textbackground(0);
                        rettangolo(40,26+(4*y)+((y-1) div 2),21,3,0)
                        end
                        else
                        begin
                        textbackground(6-(x*2));
                        rettangolo(23+x*19,48,12,3,0);
                        end;
          c:=readkey;
          if( (((c='+')or(c='-'))and(y<5)))then
                      begin
                      if(y=1)then
                             begin
                             if((boolColonne=true)and(lcella>1))then
                                        begin
                                        lcella:=lcella-1;
                                        gotoxy(57,35);textcolor(15);textbackground(0);
                                        write(lcella,' ');
                                        nColonnemax:=79 div (lcella+1);
                                        gotoxy(70,31);textcolor(11);textbackground(0);
                                        write(nColonnemax,' ');
                                        end;
                             boolColonne:=false;
                             if(c='+')then
                                     if(nColonne<nColonnemax)then
                                        nColonne:=nColonne+1
                                        else
                                        begin
                                        boolColonne:=true;
                                        for i:=1 to 4 do
                                          begin
                                          textcolor(12+(i mod 2)*3);
                                          textbackground(12+((i+1) mod 2)*3);
                                          gotoxy(70,31);write(nColonnemax,' ');
                                          end;
                                        textcolor(11);
                                        textbackground(0);
                                        gotoxy(70,31);write(nColonnemax,' ');
                                        end;
                             if((c='-')and(ncolonne>1))then
                                        ncolonne:=ncolonne-1;

                             lcellamax:=(79 div nColonne)-1;
                             gotoxy(70,35);textcolor(11);textbackground(0);
                             write(lcellamax,' ');
                             nColonnemax:=79 div (lcella+1);
                             gotoxy(70,31);write(nColonnemax,' ');
                             textbackground(0);textcolor(15);
                             gotoxy(57,31);write(ncolonne,' ');

                             end
                             else
                             if(y=2)then
                                    begin
                                    if((boolL=true)and(nColonne>1))then
                                        begin
                                        nColonne:=ncolonne-1;
                                        gotoxy(57,31);textcolor(15);textbackground(0);
                                        write(nColonne,' ');
                                        lcellamax:=(79 div nColonne)-1;
                                        gotoxy(70,35);textcolor(11);textbackground(0);
                                        write(lcellamax,' ');
                                        end;
                                    boolL:=false;
                                    if(c='+')then
                                    begin

                                      if(lCella<lCellamax)then
                                        lCella:=lCella+1
                                        else
                                        begin
                                        boolL:=true;
                                        for i:=1 to 4 do
                                          begin
                                          textcolor(12+(i mod 2)*3);
                                          textbackground(12+((i+1) mod 2)*3);
                                          gotoxy(70,35);write(lCellamax,' ');
                                          end;
                                        textcolor(11);
                                        textbackground(0);
                                        gotoxy(70,35);write(lCellamax,' ');
                                        end;
                                      end;
                                    if((c='-')and(lCella>1))then
                                        lcella:=lcella-1;

                                    nColonnemax:=(79 div (lcella+1));
                                    gotoxy(70,31);textcolor(11);textbackground(0);
                                    write(nColonnemax,' ');
                                    lcellamax:=(79 div nColonne)-1; gotoxy(20,30);
                                    gotoxy(70,35);textcolor(11);textbackground(0);
                                    write(lcellamax,' ');
                                    textbackground(0);textcolor(15);
                                    gotoxy(57,35);write(lcella,' ');

                                    end
                                    else
                             if(y=3)then
                             begin
                             if((boolRighe=true)and(hcella>1))then
                                        begin
                                        hcella:=hcella-1;
                                        gotoxy(57,44);textcolor(15);textbackground(0);
                                        write(hcella,' ');
                                        nRighemax:=79 div (hcella+1);
                                        gotoxy(70,40);textcolor(11);textbackground(0);
                                        write(nRighemax,' ');
                                        end;
                             boolRighe:=false;
                             if(c='+')then
                                     if(nRighe<nRighemax)then
                                        nRighe:=nRighe+1
                                        else
                                        begin
                                        boolRighe:=true;
                                        for i:=1 to 4 do
                                          begin
                                          textcolor(12+(i mod 2)*3);
                                          textbackground(12+((i+1) mod 2)*3);
                                          gotoxy(70,40);write(nRighemax,' ');
                                          end;
                                        textcolor(11);
                                        textbackground(0);
                                        gotoxy(70,40);write(nRighemax,' ');
                                        end;
                             if((c='-')and(nRighe>1))then
                                        nRighe:=nRighe-1;

                             hcellamax:=(79 div nRighe)-1;
                             gotoxy(70,44);textcolor(11);textbackground(0);
                             write(hcellamax,' ');
                             nRighemax:=(79 div (Hcella+1));
                             gotoxy(70,40);textcolor(11);textbackground(0);
                             write(nRighemax,' ');
                             textbackground(0);textcolor(15);
                             gotoxy(57,40);write(nRighe,' ');

                             end
                             else
                             if(y=4)then
                                    begin
                                    if((boolH=true)and(nRighe>1))then
                                        begin
                                        nRighe:=nRighe-1;
                                        gotoxy(57,40);textcolor(15);textbackground(0);
                                        write(nRighe,' ');
                                        hcellamax:=(79 div nRighe)-1;
                                        gotoxy(70,44);textcolor(11);textbackground(0);
                                        write(hcellamax,' ');
                                        end;
                                    boolH:=false;
                                    if(c='+')then
                                      if(HCella<HCellamax)then
                                        HCella:=HCella+1
                                        else
                                        begin
                                        boolH:=true;
                                        for i:=1 to 4 do
                                          begin
                                          textcolor(12+(i mod 2)*3);
                                          textbackground(12+((i+1) mod 2)*3);
                                          gotoxy(70,44);write(HCellamax,' ');
                                          end;
                                        textcolor(11);
                                        textbackground(0);
                                        gotoxy(70,44);write(HCellamax,' ');
                                        end;
                                    if((c='-')and(HCella>1))then
                                        Hcella:=Hcella-1;

                                    nRighemax:=(79 div (Hcella+1));
                                    gotoxy(70,40);textcolor(11);textbackground(0);
                                    write(nRighemax,' ');
                                    hcellamax:=(79 div nRighe)-1;
                                    gotoxy(70,44);textcolor(11);textbackground(0);
                                    write(hcellamax,' ');
                                    textbackground(0);textcolor(15);
                                    gotoxy(57,44);write(Hcella,' ');

                                    end;
                      end;


          until(qtasto('78941236qazxdews'+chr(13)+chr(0),c));
          if(s=chr(0))then
                      s:=readkey;
          if((qtasto('741qaz'+chr(75),c))and(x>1))then
                            x:=x-1;
          if((qtasto('963edx'+chr(77),c))and(x<2))then
                            x:=x+1;
          if((qtasto('789qwe'+chr(72),c))and(y>1))then
                            y:=y-1;
          if((qtasto('123zsx'+chr(80),c))and(y<5))then
                            y:=y+1;

          until((c=chr(13))and(y=5));

          if((c=chr(13))and(y=5)and(x=1))then
            begin
            textbackground(0);
            for j:=16 to 52 do
              begin
              gotoxy(38,j);
              write('                                       ');
              end;
            goto casoTools;
            end;


                          end;







          for j:=53 downto 13 do
              for i:=4 to 77 do
                 setta(i,j);
          if(b)then
               if(not Hide)then
                           begin
                           Hide:=true;
                           HideShow;
                           end;
          case strumento of
          1:cc:=inputMatita;
          2:cc:=inputGomma;
          3:cc:=inputRighello;
          5:cc:=inputSecchio;
          4:cc:=inputCopia;
          6:cc:=inputRetta;
          7:cc:=inputGriglia;
          8:cc:=inputScacchiera;
          9:cc:=inputTesto;
          10:cc:=inputRettangolo;
          11:cc:=inputTitolo;
          12:cc:=inputCerchio;
          end;
          if(strumento<13)then
          if(cc='t')then
                    inputTools
                    else
                    strumento:=0;
          end;

procedure Compila();
          var i,ii,j,z,ms,c,b,m,n,nn:integer;
              t:char;
              s,ss,sss,porco:string;
              AST:array[1..8000]of recordTesto;
              bb:boolean;
              frase:array[1..80]of string;
              NOTA:array[1..3]of char;
          begin
          if(CreaModifica=1)then
                            nomefile:='input.ptc';
          nomefile:=nomefile+'.txt';
          assign(file1,nomefile);
          ms:=0;
          c:=-1;b:=-1;bb:=false;

          for i:=y1s to y2s do
             for j:=x1s to x2s do
                begin
                if(schermata[j,i].ground=16)then  schermata[j,i].ground:=0;
                if(schermata[j,i].ground>7)then schermata[j,i].ground:=schermata[j,i].ground-8;
                if(schermata[j,i].text=chr(219))then  schermata[j,i].ground:= schermata[j,i].color-(8*(schermata[j,i].color div 8));
                if(schermata[j,i].color=schermata[j,i].ground)then schermata[j,i].text:=chr(0);
                if(qtasto('qwertyuiopasdfghjklzxcvbnm\1234567890''|!"$%&/()=?^<>,.-;:_+*@#[]{} '+smTastiera,schermata[j,i].text)) then
                                begin
                                if((c=schermata[j,i].color)and(schermata[j,i].ground=b)and(bb))then
                                              begin
                                              AST[ms].s:=AST[ms].s+schermata[j,i].text;
                                              schermata[j,i].text:=chr(0);
                                              end
                                              else
                                              begin
                                              ms:=ms+1;
                                              AST[ms].x:=j-x1s+1;AST[ms].y:=i-y1s+1;
                                              AST[ms].color:=schermata[j,i].color;
                                              AST[ms].ground:=schermata[j,i].ground;
                                              AST[ms].s:=schermata[j,i].text;
                                              schermata[j,i].text:=chr(0);
                                              c:=AST[ms].color;
                                              b:=AST[ms].ground;
                                              bb:=true;
                                              end;
                                if(j=x2s)then
                                         bb:=false;
                                end
                                else
                                bb:=false;
                end;
          rewrite(file1);
          str(sfondo,s);

          writefile('***************************************************************************'+chr(13));
          writefile('*********************** IMPLEMENT THESE FUNCTIONS *************************'+chr(13));
          writefile('***************************************************************************'+chr(13)+chr(13));
          writefile('uses crt;'+chr(13)+chr(13));
          writefile('type PTCType=record'+chr(13));
          writefile('     pc:array[1..80]of string;'+chr(13));
          writefile('     s:array[1..500]of string;'+chr(13));
          writefile('     end;'+chr(13));
          writefile('     PTCArray=array[1..100]of PTCType;'+chr(13)+chr(13));
          writefile('var Nptc,PTCBackground:integer;'+chr(13));
          writefile('    PAINTCODE:PTCArray;'+chr(13));
          writefile('    IsTrasparent:boolean;'+chr(13)+chr(13));
          writefile('procedure DrawCode(A:PTCArray;x,y:integer);       // "x,y" are the coords of the first corner (left/up) you can change them..'+chr(13));
          writefile('          var i,j,z,jj,n,nn,c,g,leng:integer;'+chr(13));
          writefile('              t:char;'+chr(13));
          writefile('              s,ss:string;'+chr(13));
          writefile('          const strChar:string =chr(176)+chr(177)+chr(178)+chr(219)+chr(220)+chr(223)+chr(254)+chr(95)');writefile('+chr(238)+chr(196)+chr(197)+chr(180)+chr(191)+chr(192)+chr(193)+chr(194)+chr(195)+chr(217)+chr(218)+chr(179)+chr(221)+chr(185)+chr(186)+chr(187)+chr(188)+chr(200)+chr(201)+chr(202)+chr(203)+chr(204)+chr(205)+chr(206)+chr(0);'+chr(13));
          writefile('          begin'+chr(13));
          writefile('          i:=1;'+chr(13));
          writefile('          while((length(A[Nptc].pc[i])>0)and(i<81))do i:=i+1;'+chr(13));
          writefile('          jj:=i-1;'+chr(13));
          writefile('          for i:=1 to jj do'+chr(13));
          writefile('            begin'+chr(13));
          writefile('            n:=length(A[Nptc].pc[i])div 3; gotoxy(x,y+i-1);'+chr(13));
          writefile('            for j:=1 to n do'+chr(13));
          writefile('              begin'+chr(13));
          writefile('              s:=copy(A[Nptc].pc[i],j*3-2,3);'+chr(13));
          writefile('              nn:=((ord(s[1])-41)*125*125)+((ord(s[2])-41)*125)+(ord(s[3])-41);'+chr(13));
          writefile('              str(nn,s); s:=copy(''000000'',1,7-length(s))+s;'+chr(13));
          writefile('              val(copy(s,1,2),c);val(copy(s,3,1),g);val(copy(s,6,2),leng);'+chr(13));
          writefile('              val(copy(s,4,2),nn);t:=strChar[nn];'+chr(13));
          writefile('              if((t=chr(0))and(g=PTCBackground)and(IsTrasparent))then'+chr(13));
          writefile('                  begin gotoxy(wherex+leng,y+i-1); end'+chr(13));
          writefile('                  else'+chr(13));
          writefile('                  begin'+chr(13));
          writefile('                  textcolor(c);'+chr(13));
          writefile('                  textbackground(g);'+chr(13));
          writefile('                  for z:=1 to leng do write(t);'+chr(13));
          writefile('                  end;'+chr(13));
          writefile('              end;'+chr(13));
          writefile('            end;'+chr(13));
          writefile('          i:=1;'+chr(13));
          writefile('          while((length(A[Nptc].s[i])>0)and(i<500))do i:=i+1;'+chr(13));
          writefile('          jj:=i-1;'+chr(13));
          writefile('          for i:=1 to jj do'+chr(13));
          writefile('            begin'+chr(13));
          writefile('            s:=A[Nptc].s[i];'+chr(13));
          writefile('            val(copy(s,5,2),c);textcolor(c);'+chr(13));
          writefile('            val(copy(s,7,1),c);textbackground(c);'+chr(13));
          writefile('            val(copy(s,1,2),c);val(copy(s,3,2),g);gotoxy(c+x-1,g+y-1);'+chr(13));
          writefile('            ss:=copy(s,8,length(s)-7);write(ss);'+chr(13));
          writefile('            end;'+chr(13));
          writefile('         end;'+chr(13)+chr(13));
          writefile('***************************************************************************'+chr(13));
          writefile('************************ ADD THESE LINES IN YOUR CODE *********************'+chr(13));
          writefile('***************************************************************************'+chr(13)+chr(13));
          writefile('PTCBackground:='+s+';'+chr(13));
          writefile('IsTrasparent:=');
          if(SfondoInvisibile)then
                    writefile('true;'+chr(13))
                    else
                    writefile('false;'+chr(13));
          writeFile('Nptc:=1;               // you can change this number'+chr(13)+chr(13));
          bb:=false;
          ii:=y1s;

          while(ii<=y2s)do
             begin
             s:='';
             frase[ii]:='';
             n:=0;
             t:=schermata[x1s,ii].text; c:=schermata[x1s,ii].color; b:=schermata[x1s,ii].ground;
               j:=x1s;
               while (j<=x2s) do
                 begin
                  if((schermata[j,ii].color=c)and(schermata[j,ii].ground=b)and(schermata[j,ii].text=t)and(j<>x2s))then
                         n:=n+1
                         else                                                // colore / sfondo / carattere / lunghezza
                         begin
                         caso6:                                              // da 41 a 165
                         s:='';
                         str(c,ss); if(c<10)then s:='0';
                         s:=s+ss;   str(b,ss);s:=s+ss;
                         z:=1;
                         while((stringaCaratteri[z]<>t)and(z<34))do
                                z:=z+1;
                         str(z,ss); if(z<10)then s:=s+'0'; s:=s+ss;
                         str(n,ss); if(n<10)then s:=s+'0'; s:=s+ss;

                         val(s,nn,cacca);

                         z:=4;NOTA[1]:=chr(41);nota[2]:=chr(41);nota[3]:=chr(41);
                         while (nn>=125) do
                            begin
                            z:=z-1;
                            NOTA[z]:=chr(41+(nn mod 125));
                            nn:=(nn div 125);
                            end;
                         if(z=3)then begin NOTA[2]:=chr(41+nn); NOTA[1]:=')';end;
                         if(z=2)then  NOTA[1]:=chr(41+nn);
                         s:='';
                         for z:=1 to 3 do
                            s:=s+NOTA[z];
                         Frase[ii]:=Frase[ii]+s;
                         n:=1;
                         t:=schermata[j,ii].text; c:=schermata[j,ii].color; b:=schermata[j,ii].ground;
                         end;
                  j:=j+1;
                  if(j=x2s+1)then goto caso6;
                  end;

             ii:=ii+1;
             end;

          n:=length(Frase[y1s]);
          i:=y1s;
             while(i<=y2s)do
             begin
              if(length(Frase[i])>n)then
                     n:=length(Frase[i]);
             i:=i+1;
             end;
          n:=n+28;
          if(n<150)then n:=150;

          j:=28;
          ii:=y1s;
          while(ii<=y2s)do
             begin
             if(j+length(Frase[ii])-10<n)then
             begin
             j:=j+length(Frase[ii])+28;
             nn:=ii;
             nn:=nn-y1s+1;
             str(nn,s);
             writefile('PAINTCODE[Nptc].pc['+s+']:=(''');
             writefile(Frase[ii]);
             writefile(''');');
             ii:=ii+1;
             end
             else
             begin
             writefile(chr(13));
             j:=28;
             end;
             end;

         if(ms>0)then
          begin
          writefile(chr(13));
          n:=length(AST[1].s);
          i:=1;
             while(i<=ms)do
             begin
              if(length(AST[i].s)>n)then
                     n:=length(AST[i].s);
             i:=i+1;
             end;
          n:=n+35;
          if(n<150)then n:=150;

          j:=35;
          ii:=1;
          while(ii<=ms)do
             begin
             if(j+length(AST[ii].s)-10<n)then
             begin
             j:=j+length(AST[ii].s)+35;
             nn:=ii;
             str(nn,s);
             writefile('PAINTCODE[Nptc].s['+s+']:=(''');
             str(AST[ii].x,s);s:=copy('00',1,2-length(s))+s;writefile(s);
             str(AST[ii].y,s);s:=copy('00',1,2-length(s))+s;writefile(s);
             str(AST[ii].color,s);s:=copy('00',1,2-length(s))+s;writefile(s);
             str(AST[ii].ground,s);writefile(s);
             porco:='';
             for i:=1 to length(AST[ii].s) do
                   begin
                   porco:=porco+AST[ii].s[i];
                   if(AST[ii].s[i]='''')then
                      porco:=porco+'''';
                   end;
             writefile(porco);
             writefile(''');');
             ii:=ii+1;
             end
             else
             begin
             writefile(chr(13));
             j:=35;
             end;
             end;
          end;

          writefile(chr(13)+chr(13)+'DrawCode(PAINTCODE,1,1);              //you can change these coords');

          end;


procedure inizializzazioneDati;
          var i,j:integer;
          begin
          pulisciBKP:=false;
          lrettangolo:=40;
          hrettangolo:=15;
          nColonne:=3;
          nRighe:=2;
          lcella:=10;
          hcella:=3;
          Dimensione:=3;
          spRighe:=3;
          Layout:=true;
          SfondoInvisibile:=false;
          CHGrid[1,1]:=chr(218);CHGrid[1,2]:=chr(191);CHGrid[1,3]:=chr(217);CHGrid[1,4]:=chr(192);CHGrid[1,5]:=chr(194);CHGrid[1,6]:=chr(180);CHGrid[1,7]:=chr(193);CHGrid[1,8]:=chr(195);CHGrid[1,9]:=chr(197);CHGrid[1,10]:=chr(196);CHGrid[1,11]:=chr(179);
          CHGrid[2,1]:=chr(201);CHGrid[2,2]:=chr(187);CHGrid[2,3]:=chr(188);CHGrid[2,4]:=chr(200);CHGrid[2,5]:=chr(203);CHGrid[2,6]:=chr(185);CHGrid[2,7]:=chr(202);CHGrid[2,8]:=chr(204);CHGrid[2,9]:=chr(206);CHGrid[2,10]:=chr(205);CHGrid[2,11]:=chr(186);
          car[1,1]:=chr(176);car[2,1]:=chr(177);car[3,1]:=chr(178);car[1,2]:=chr(219);car[2,2]:=chr(220);car[3,2]:=chr(223);
          car[1,3]:=chr(254);car[2,3]:=chr(95);car[3,3]:=chr(238);car[1,4]:=chr(196);car[2,4]:=chr(197);car[3,4]:=chr(180);
          car[1,5]:=chr(191);car[2,5]:=chr(192);car[3,5]:=chr(193);car[1,6]:=chr(194);car[2,6]:=chr(195);car[3,6]:=chr(217);
          car[1,7]:=chr(218);car[2,7]:=chr(179);car[3,7]:=chr(221);car[1,8]:=chr(185);car[2,8]:=chr(186);car[3,8]:=chr(187);
          car[1,9]:=chr(188);car[2,9]:=chr(200);car[3,9]:=chr(201);car[1,10]:=chr(202);car[2,10]:=chr(203);car[3,10]:=chr(204);
          car[1,11]:=chr(205);car[2,11]:=chr(206);car[3,11]:=chr(0);
          for i:=1 to 80 do
              begin
              chr223:=chr223+chr(223);
              chr220:=chr220+chr(220);
              spazio:=spazio+' ';
              chr0:=chr0+chr(0);
              end;
          for i:=1 to 26 do
            ImmagineLHM[i,1]:=0;
          CH[1,1]:=chr(223);CH[1,2]:=chr(220);CH[1,3]:=chr(219);CH[1,4]:=chr(219);CH[1,5]:=chr(219);CH[1,6]:=chr(219);CH[1,7]:=chr(219);
          CH[2,1]:=chr(196);CH[2,2]:=chr(196);CH[2,3]:=chr(179);CH[2,4]:=chr(218);CH[2,5]:=chr(191);CH[2,6]:=chr(217);CH[2,7]:=chr(192);
          CH[3,1]:=chr(205);CH[3,2]:=chr(205);CH[3,3]:=chr(186);CH[3,4]:=chr(201);CH[3,5]:=chr(187);CH[3,6]:=chr(188);CH[3,7]:=chr(200);
          EMPTY:=cancTab;
          gostTab:=cancTab;
          corniceTab:=cancTab;
          m:=0;
          Hide:=true;
          HideDime:=true;
          title:=false;
          strumento:=0;
          bbim:=false;
          ymaxcln:=0;
          StrumentoSecondario:=false;
          color2:=15;
          ground2:=1;
          text2:=chr(178);
          x:=41;y:=35;
          TArea:=cancTab;
          nFeatureEs:=2;
          nFeature:=2;
          CFeature[2,1]:=1;
          CFeature[3,1]:=1;CFeature[3,2]:=4;
          CFeature[4,1]:=4;CFeature[4,2]:=7;
          CFeature[5,1]:=6;CFeature[5,2]:=4;
          CFeature[6,1]:=6;CFeature[6,2]:=4;
          nGrid:=1;
          nRettang:=1;
          Ap[1,1]:='+***++';Ap[2,1]:='****++';Ap[3,1]:='++**++';Ap[4,1]:='++**++';Ap[5,1]:='******';Ap[1,2]:='*****+';Ap[2,2]:='+++***';Ap[3,2]:='++***+';Ap[4,2]:='+**+++';Ap[5,2]:='******';
          Ap[1,3]:='*****+';Ap[2,3]:='+++***';Ap[3,3]:='+****+';Ap[4,3]:='+++***';Ap[5,3]:='*****+';Ap[1,4]:='+++**+';Ap[2,4]:='++***+';Ap[3,4]:='+**+*+';Ap[4,4]:='******';Ap[5,4]:='+++**+';
          Ap[1,5]:='******';Ap[2,5]:='**++++';Ap[3,5]:='*****+';Ap[4,5]:='+++***';Ap[5,5]:='*****+';Ap[1,6]:='******';Ap[2,6]:='**++++';Ap[3,6]:='*****+';Ap[4,6]:='**++**';Ap[5,6]:='*****+';
          Ap[1,7]:='******';Ap[2,7]:='++++**';Ap[3,7]:='+++**+';Ap[4,7]:='++**++';Ap[5,7]:='++**++';Ap[1,8]:='******';Ap[2,8]:='**++**';Ap[3,8]:='******';Ap[4,8]:='**++**';Ap[5,8]:='******';
          Ap[1,9]:='******';Ap[2,9]:='**++**';Ap[3,9]:='******';Ap[4,9]:='++++**';Ap[5,9]:='******';Ap[1,10]:='+****+';Ap[2,10]:='**++**';Ap[3,10]:='******';Ap[4,10]:='**++**';Ap[5,10]:='**++**';
          Ap[1,11]:='*****+';Ap[2,11]:='**++**';Ap[3,11]:='*****+';Ap[4,11]:='**++**';Ap[5,11]:='*****+';Ap[1,12]:='******';Ap[2,12]:='**++++';Ap[3,12]:='**++++';Ap[4,12]:='**++++';Ap[5,12]:='******';
          Ap[1,13]:='*****+';Ap[2,13]:='**++**';Ap[3,13]:='**++**';Ap[4,13]:='**++**';Ap[5,13]:='*****+';Ap[1,14]:='******';Ap[2,14]:='**++++';Ap[3,14]:='******';Ap[4,14]:='**++++';Ap[5,14]:='******';
          Ap[1,15]:='******';Ap[2,15]:='**++++';Ap[3,15]:='****++';Ap[4,15]:='**++++';Ap[5,15]:='**++++';Ap[1,16]:='******';Ap[2,16]:='**++++';Ap[3,16]:='**+***';Ap[4,16]:='**++**';Ap[5,16]:='******';
          Ap[1,17]:='**++**';Ap[2,17]:='**++**';Ap[3,17]:='******';Ap[4,17]:='**++**';Ap[5,17]:='**++**';Ap[1,18]:='**';Ap[2,18]:='**';Ap[3,18]:='**';Ap[4,18]:='**';Ap[5,18]:='**';
          Ap[1,19]:='++++**';Ap[2,19]:='++++**';Ap[3,19]:='++++**';Ap[4,19]:='**++**';Ap[5,19]:='******';Ap[1,20]:='**++**';Ap[2,20]:='**+**+';Ap[3,20]:='****++';Ap[4,20]:='**+**+';Ap[5,20]:='**++**';
          Ap[1,21]:='**++++';Ap[2,21]:='**++++';Ap[3,21]:='**++++';Ap[4,21]:='**++++';Ap[5,21]:='******';Ap[1,22]:='**++++**';Ap[2,22]:='***++***';Ap[3,22]:='**+**+**';Ap[4,22]:='**++++**';Ap[5,22]:='**++++**';
          Ap[1,23]:='**+++**';Ap[2,23]:='***++**';Ap[3,23]:='**+*+**';Ap[4,23]:='**++***';Ap[5,23]:='**+++**';Ap[1,24]:='******';Ap[2,24]:='**++**';Ap[3,24]:='**++**';Ap[4,24]:='**++**';Ap[5,24]:='******';
          Ap[1,25]:='******';Ap[2,25]:='**++**';Ap[3,25]:='******';Ap[4,25]:='**++++';Ap[5,25]:='**++++';Ap[1,26]:='*******+';Ap[2,26]:='**+++**+';Ap[3,26]:='**++***+';Ap[4,26]:='********';Ap[5,26]:='+++++***';
          Ap[1,27]:='******';Ap[2,27]:='**++**';Ap[3,27]:='******';Ap[4,27]:='**+**+';Ap[5,27]:='**++**';Ap[1,28]:='******';Ap[2,28]:='**++++';Ap[3,28]:='******';Ap[4,28]:='++++**';Ap[5,28]:='******';
          Ap[1,29]:='******';Ap[2,29]:='++**++';Ap[3,29]:='++**++';Ap[4,29]:='++**++';Ap[5,29]:='++**++';Ap[1,30]:='**++**';Ap[2,30]:='**++**';Ap[3,30]:='**++**';Ap[4,30]:='**++**';Ap[5,30]:='******';
          Ap[1,31]:='**++++**';Ap[2,31]:='**++++**';Ap[3,31]:='+**++**+';Ap[4,31]:='++****++';Ap[5,31]:='+++**+++';Ap[1,32]:='**++++**';Ap[2,32]:='**++++**';Ap[3,32]:='**+**+**';Ap[4,32]:='***++***';Ap[5,32]:='**++++**';
          Ap[1,33]:='**+++**';Ap[2,33]:='+**+**+';Ap[3,33]:='++***++';Ap[4,33]:='+**+**+';Ap[5,33]:='**+++**';Ap[1,34]:='**++**';Ap[2,34]:='**++**';Ap[3,34]:='+****+';Ap[4,34]:='++**++';Ap[5,34]:='++**++';
          Ap[1,35]:='******';Ap[2,35]:='+++**+';Ap[3,35]:='++**++';Ap[4,35]:='+**+++';Ap[5,35]:='******';Ap[1,36]:='**';Ap[2,36]:='**';Ap[3,36]:='**';Ap[4,36]:='++';Ap[5,36]:='**';
          Ap[1,37]:='******';Ap[2,37]:='**++**';Ap[3,37]:='+++**+';Ap[4,37]:='++++++';Ap[5,37]:='+++**+';Ap[1,38]:='+**';Ap[2,38]:='**+';Ap[3,38]:='+++';Ap[4,38]:='+++';Ap[5,38]:='+++';
          for i:=1 to 80 do
            for j:=1 to 80 do
                TABI[i,j]:=1;
          CirconfCampione:=Dcerchio(40,25,17,1.4,mCirconfCamp,caccaTab);
          for i:=1 to mCirconfCamp do
            TABI[CirconfCampione[i,1],CirconfCampione[i,2]]:=0;
          CirconfCampione:=Dsecchio(mCirconfCamp,TABI,40,33,caccaTab);
          CerchioCampione:=Dsecchio(mCerchioCamp,TABI,40,25,caccaTab);
          RettFea:=DRettangoloPieno(mRettFea,67,31,76,37,caccaTab);
          Caricamento:=Dcerchio(40,35,7,1,mCaricamento,caccaTab);
          end;
procedure inizializzazionePTC;
          begin
          Nptc:=1;                   // pagina iniziale..
          PAINTCODE[Nptc].pc[1]:=('+9`xYF+9lf{+9`xYF+9€+9\');PAINTCODE[Nptc].pc[2]:=('+9_xYE+9lfy-\fv+9cxYE+9^cHu+9{+9\');
          PAINTCODE[Nptc].pc[3]:=('+9]xYF+9lf{-\+9b)C]+9\xYE+9\cHw+9s@~Ž+9a+9\');PAINTCODE[Nptc].pc[4]:=('+9\y{_+9kfx-\fw+9d`.+9]y{\xYCcHy+9q-g\@~+9`+9\');
          PAINTCODE[Nptc].pc[5]:=('y{^+9lfz-\+9e`.‘+9]cH{+9m-g^<’Ž@~+9_+9\');
          PAINTCODE[Nptc].pc[6]:=('y{]+9_jMujN\jOCjMu7M]jLŽjOCjN]+9]f{xn‘+9\,’+9`,¢*†cC,¢*†cC+9_cHw+9cxWw+9_xYN@~Ž+9^+9\');
          PAINTCODE[Nptc].pc[7]:=('y{]+9^jOC7M\jN\7M\jMujN\jMujOCjMujLŽ7M\jOCfx-\fvxn“,’+9`,¢*†cC,¢*†cC+9_cHwcJC+9bxWw+9_hCxYEhCxYEhCxYE@~+9]+9\');
          PAINTCODE[Nptc].pc[8]:=('yzu+9_jMujODjN\7M]jN_7M\jLŽfy-\xn•,’Ž+9`,¢*†cC,¢*†cC+9_cHwe?]+9axWw+9^-g\xYN@~+9\+9\');
          PAINTCODE[Nptc].pc[9]:=('+9`jLŽjOCjL+9_jLŽjN\jMujOCfx+9\xn‘+9]xn‘+9`,¢*†cC,¢*†cC+9_cHwe>w+9`xWw+9]-gaxYDhCxYC@~•+9\');
          PAINTCODE[Nptc].pc[10]:=('+9`jOCjN\jMujN\+9^fujLjOCjLŽfv+9]xn‘+9_xn‘+9_,¢*†cC,¢*†cC+9_cHwe>x+9_xWw+9\-gbxYF@~•@~Ž');
          PAINTCODE[Nptc].pc[11]:=('+9`7M]jMujLŽ+9\fw7M\jMu7M\jOC-\+9^`.‘+9_`.‘+9_,¢*†cC,¢*†cC+9_cHw…=Že=‘+9^xWw-ga<’hCxYE@~•@~Ž');
          PAINTCODE[Nptc].pc[12]:=('+9`7M\jN\jMujLŽjN\7M]jLjN\jOC+9_F``.—+9_,¢*†cC,¢*†cC+9_cHw…=v`‘+9]xWw-g^<’’xYF@~•@~Ž');
          PAINTCODE[Nptc].pc[13]:=('+9`jMu7M\jOCjMx7M\jMujLŽjOD+9_`.ŽF``.’F``.Ž+9_,¢*†cC,¢*†cC+9_cHw…=+9\vax+9\xWw<’•xYDhCxYC@~•@~Ž');
          PAINTCODE[Nptc].pc[14]:=('+9`jN\jMvjLjMujLŽjOCjN\jMv+9``.—F`+9_,¢*†cC,¢*†cC+9_cHw…=+9]vaxxWw<’’@~Ž<’xYF@~•@~Ž');
          PAINTCODE[Nptc].pc[15]:=('+9_fujOCjMujLfv+9e`.‘,’Ž+9^`.‘+9_,¢*†cC,¢*†cC+9_cHw…=+9^vb^xWw<’‘@~<’Ž@~ŽhCxYE@~•@~Ž');
          PAINTCODE[Nptc].pc[16]:=('+9^fvjMujOC7M\jMu-\+9f`.ŽF``.Ž,’Ž+9^`.‘+9_,¢*†cC,¢*†cC+9_cHw…=+9_xYDxWw+9\<’@~’xYF@~•@~Ž');
          PAINTCODE[Nptc].pc[17]:=('+9^fv7M]jOD+9g`.F`Ž,”\,’Ž+9^`.‘+9_,¢*†cC,¢*†cC+9_cHw…=+9`xYCxWw+9\<’+9\@~‘xYDhCxYC@~•@~Ž');
          PAINTCODE[Nptc].pc[18]:=('+9_fujLjMv+9g`.‘,’Ž+9^`.‘+9_,¢*†cC,¢*†cC+9_cHw…=Ž+9bxWw+9`@~xYF@~•@~Ž');
          PAINTCODE[Nptc].pc[19]:=('…=Ž+9_jMujOC7M\jMu+9g`.‘,’Ž+9^`.‘+9_,¢*†cC,¢*†cC+9_cHw…=Ž+9bxWw+9a@~hCxYE@~•+9\');
          PAINTCODE[Nptc].pc[20]:=('…=Ž+9ˆ…=+9`xW{+9a@~—+9]+9\');PAINTCODE[Nptc].pc[21]:=('…=+9†…=+9bxWy+9c@~”+9_+9\');
          PAINTCODE[Nptc].pc[22]:=('…=+9d†a+9`‰y—+9a-`Zf]+9axWwiCf@~‘+9`+9\');PAINTCODE[Nptc].pc[23]:=('…=+9b…=™+9_‰yg3•‰y+9_Zf\gMbZf\+9axWuiCg+9d+9\');
          PAINTCODE[Nptc].pc[24]:=('+9\…>x+9`Q¡™+9_‰yŽg3‰y‘g3‰yŽ+9_M_Zf\-]zf^+9aiCg+9d+9\');
          PAINTCODE[Nptc].pc[25]:=('+9]…>x+9_xV‘+9g‰yŽg3‰y+9]‰yg3‰yŽ+9^…?\Zf]:f]+9]-^gM\Zf\+9`iC_+9l+9\');
          PAINTCODE[Nptc].pc[26]:=('+9_…>w+9^EW_+9g‰yŽg3‰yŽ+9_‰yŽg3‰yŽ+9]…?]-^Zf\+9^M_Zf\+9_iC_+9l+9\');
          PAINTCODE[Nptc].pc[27]:=('+9`…?_+9\Ko‘+9g‰yŽg3‰yŽ+9_‰yŽg3‰yŽ…?_-_+9_-_+9_iC_+9l+9\');
          PAINTCODE[Nptc].pc[28]:=('+9b…?^1¡‘+9g‰yŽg3‰yŽ+9_‰yŽg3‰yŽ…?]+9]Zf_+9_Zf\‡M]Zf\+9_iCg+9d+9\');
          PAINTCODE[Nptc].pc[29]:=('+9d†cCIy‘†cC+9f‰yŽg3‰yŽ+9]†cD‰yŽg3‰yŽ+9_-\gM\-]+9_-_+9_iCg+9d+9\');
          PAINTCODE[Nptc].pc[30]:=('+9ecG‘†cH+9a‰yŽ†cI‰yŽg3‰yŽ+9_Zf\-\Zf]+9_-_+9_iC_+9l+9\');
          PAINTCODE[Nptc].pc[31]:=('+9e1Rx+9\†cS+9]‰yŽg3‰yŽ+9_zf_+9^zf`+9_iC_+9l+9\');
          PAINTCODE[Nptc].pc[32]:=('+9ep.‘+9g‰yŽg3‰y+9]‰yg3‰yŽ+9_Zf_+9]Zf\-_+9`iC])C\iC\+9l+9\');
          PAINTCODE[Nptc].pc[33]:=('+9eqR€+9_‰yŽg3‰y‘g3‰yŽ+9_:fcZf]+9aiC\)C]iCa)C\iC]+9d+9\');
          PAINTCODE[Nptc].pc[34]:=('+9ep~™+9_‰yg3•‰y+9_Zf\-c+9biC\)C]iC\)C\iC])C^iC]+9d+9\');
          PAINTCODE[Nptc].pc[35]:=('+9fjL˜+9`‰y—+9aZf\M^Zf\-\Zf\+9d)C_iC\)C_iC\)C\+9d+9\');PAINTCODE[Nptc].pc[36]:=('+:-+9\');PAINTCODE[Nptc].pc[37]:=('+:-+9\');
          PAINTCODE[Nptc].pc[38]:=('+:-+9\');PAINTCODE[Nptc].pc[39]:=('+:-+9\');PAINTCODE[Nptc].pc[40]:=('+:-+9\');PAINTCODE[Nptc].pc[41]:=('+:-+9\');
          PAINTCODE[Nptc].pc[42]:=('+:-+9\');PAINTCODE[Nptc].pc[43]:=('+:-+9\');PAINTCODE[Nptc].pc[44]:=('+9ghCŠ ¥hC+9_hCŠ ¥hC+9f+9\');
          PAINTCODE[Nptc].pc[45]:=('+9ghC+9shC+9_hC+9shC+9f+9\');PAINTCODE[Nptc].pc[46]:=('+9ghC+9`‹9h+9ahC+9_hC+9^‹9l+9_hC+9f+9\');
          PAINTCODE[Nptc].pc[47]:=('+9ghC+9shC+9_hC+9shC+9f+9\');PAINTCODE[Nptc].pc[48]:=('+9ghCŠ AhC+9_hCŠ AhC+9f+9\');
          PAINTCODE[Nptc].s[1]:=('30020076');PAINTCODE[Nptc].s[2]:=('3103007\');PAINTCODE[Nptc].s[3]:=('26040075');PAINTCODE[Nptc].s[4]:=('2705007\');
          PAINTCODE[Nptc].s[5]:=('22070074');PAINTCODE[Nptc].s[6]:=('2308007\');PAINTCODE[Nptc].s[7]:=('1811007\');PAINTCODE[Nptc].s[8]:=('1016007\');
          PAINTCODE[Nptc].s[9]:=('4422007lib.h');PAINTCODE[Nptc].s[10]:=('602210001010011110');PAINTCODE[Nptc].s[11]:=('4423097 main()');
          PAINTCODE[Nptc].s[12]:=('5923100100101101100');PAINTCODE[Nptc].s[13]:=('4324057ring');PAINTCODE[Nptc].s[14]:=('4824007a=');
          PAINTCODE[Nptc].s[15]:=('5024127"se');PAINTCODE[Nptc].s[16]:=('5924100111010100111');PAINTCODE[Nptc].s[17]:=('4525027if');
          PAINTCODE[Nptc].s[18]:=('4925007x!=');PAINTCODE[Nptc].s[19]:=('52250970');PAINTCODE[Nptc].s[20]:=('59251000101');PAINTCODE[Nptc].s[21]:=('4326007(){');
          PAINTCODE[Nptc].s[22]:=('5026057bool');PAINTCODE[Nptc].s[23]:=('59261001100');PAINTCODE[Nptc].s[24]:=('4327007cons');PAINTCODE[Nptc].s[25]:=('5127007int&');
          PAINTCODE[Nptc].s[26]:=('59271000110');PAINTCODE[Nptc].s[27]:=('5228147++');PAINTCODE[Nptc].s[28]:=('5928100010100110101');PAINTCODE[Nptc].s[29]:=('4329007[');
          PAINTCODE[Nptc].s[30]:=('44290971');PAINTCODE[Nptc].s[31]:=('4529007][');PAINTCODE[Nptc].s[32]:=('5129007E=F ');PAINTCODE[Nptc].s[33]:=('5929100001110101000');
          PAINTCODE[Nptc].s[34]:=('4430007}');PAINTCODE[Nptc].s[35]:=('5130007ut<<');PAINTCODE[Nptc].s[36]:=('59301001011');PAINTCODE[Nptc].s[37]:=('4331127"hel');
          PAINTCODE[Nptc].s[38]:=('5031127world');PAINTCODE[Nptc].s[39]:=('593110001 0');PAINTCODE[Nptc].s[40]:=('5032007cin>');PAINTCODE[Nptc].s[41]:=('593210000');
          PAINTCODE[Nptc].s[42]:=('62321001');PAINTCODE[Nptc].s[43]:=('4333027nclude<>');PAINTCODE[Nptc].s[44]:=('59331001');PAINTCODE[Nptc].s[45]:=('62331000 11 1');
          PAINTCODE[Nptc].s[46]:=('693310010');PAINTCODE[Nptc].s[47]:=('4434007export->');PAINTCODE[Nptc].s[48]:=('59341001');PAINTCODE[Nptc].s[49]:=('62341000');
          PAINTCODE[Nptc].s[50]:=('643410000');PAINTCODE[Nptc].s[51]:=('693410001');PAINTCODE[Nptc].s[52]:=('4535057int');PAINTCODE[Nptc].s[53]:=('4935007A');
          PAINTCODE[Nptc].s[54]:=('64351001');PAINTCODE[Nptc].s[55]:=('69351000');PAINTCODE[Nptc].s[56]:=('1946153START DRAWING');
          PAINTCODE[Nptc].s[57]:=('4746153VIEW INSTRUCTIONS');

          Nptc:=2;           //istruzioni 1..
          PAINTCODE[Nptc].pc[1]:=(')”-)“\');PAINTCODE[Nptc].pc[2]:=(')“|‰ˆC‰6‰ƒ\)“z)“\');PAINTCODE[Nptc].pc[3]:=(')“|‰‰*)“_qTG)“_‰‰*)“z)“\');
          PAINTCODE[Nptc].pc[4]:=(')“|‰‰*)“_qTC‰“])“\qTC)“_‰‰*)“z)“\');PAINTCODE[Nptc].pc[5]:=(')“|‰‰*)“_qTC‰“])“\qTC)“_‰‰*)“z)“\');
          PAINTCODE[Nptc].pc[6]:=(')“|‰‰*)“_qTG)“_‰‰*)“z)“\');PAINTCODE[Nptc].pc[7]:=(')“f‰ˆC‰3‰ƒ\)“e‰‰*)“h‰‰*)“e‰ˆC‰3‰ƒ\)“d)“\');
          PAINTCODE[Nptc].pc[8]:=(')“f‰‰*)“`qTG‰‰*)“e‰‰*qTG)“^qTG‰‰*)“e‰‰*qTG)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[9]:=(')“f‰‰*)“`qTC‰“\)“]qTC‰‰*)“e‰‰*qTC‰“\)“]qTC)“^qTC‰“\)“]qTC‰‰*)“e‰‰*qTC‰“\)“]qTC)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[10]:=(')“f‰‰*)“`qTC)“^qTC‰‰*)“e‰‰*qTC)“^qTC)“^qTC)“^qTC‰‰*)“e‰‰*qTC)“^qTC)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[11]:=(')“f‰‰*)“`qTG‰‰*)“e‰‰*qTG)“^qTG‰‰*)“e‰‰*qTG)“`‰‰*)“d)“\');PAINTCODE[Nptc].pc[12]:=(')“f‰‰*qTG)“`‰‰*)“e‰„C‰6‰‡\)“e‰‰*)“`qTG‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[13]:=(')“f‰‰*qTC‰“\)“]qTC)“`‰‰*)“ccaa)“^\)“^caa)“c‰‰*)“`qTC‰“\)“]qTC‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[14]:=(')“f‰‰*qTC)“^qTC)“`‰‰*)“`ca_)“b^)“bca])“b‰‰*)“`qTC)“^qTC‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[15]:=(')“f‰‰*qTG)“`‰‰*)“_ca])“d`)“j‰‰*)“`qTG‰‰*)“d)“\');PAINTCODE[Nptc].pc[16]:=(')“f‰„C‰3‰‡\)“l\)“l‰„C‰3‰‡\)“d)“\');
          PAINTCODE[Nptc].pc[17]:=(')“r_)“h\)“h_ca\)“o)“\');PAINTCODE[Nptc].pc[18]:=(')“r^)“i\)“i^ca\)“o)“\');
          PAINTCODE[Nptc].pc[19]:=(')“r\)“\^)“g\)“h])“\\)“p)“\');PAINTCODE[Nptc].pc[20]:=(')“v])“f\)“g])“s)“\');
          PAINTCODE[Nptc].pc[21]:=(')“mca\)“d])“e\)“e^)“cca\)“k)“\');PAINTCODE[Nptc].pc[22]:=(')“lca])“e^)“_p.–)“`])“eca])“j)“\');
          PAINTCODE[Nptc].pc[23]:=(')“^‰ˆC‰4‰ƒ\ca])“h\p.’)Cbp.’])“gca]‰ˆC‰4‰ƒ\)“\)“\');
          PAINTCODE[Nptc].pc[24]:=(')“^‰‰*)“aqTG‰‰*ca\)“gp.‘)Cjp.‘)“gca\‰‰*qTG)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[25]:=(')“^‰‰*)“aqTC‰“\)“]qTC‰‰*ca\)“fp.)Cpp.)“fca\‰‰*qTC‰“\)“]qTC)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[26]:=(')“^‰‰*)“aqTC)“^qTC‰‰*ca\)“ep.)C`‰Cg)Cap.)“eca\‰‰*qTC)“^qTC)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[27]:=(')“^‰‰*)“aqTG‰‰*)“]\)“bp.)Ctp.)“b\)“]‰‰*qTG)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[28]:=(')“^‰‰*qTG)“a‰‰*)“\])“bp.Ž)C^‰Cp)C^p.Ž)“b])“\‰‰*)“aqTG‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[29]:=(')“^‰‰*qTC‰“])“\qTC)“a‰‰*ep.Ž)Cvp.Že‰‰*)“aqTC‰“])“\qTC‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[30]:=(')“^‰‰*qTC‰“])“\qTC)“a‰‰*)“\])“bp.Ž)C^‰Cp)C^p.Ž)“b])“\‰‰*)“aqTC‰“])“\qTC‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[31]:=(')“^‰‰*qTG)“\qTG‰‰*)“]\)“bp.)Ctp.)“b\)“]‰‰*qTG)“\qTG‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[32]:=(')“^‰‰*)“aqTC‰“\)“]qTC‰‰*ca\)“ep.)C_‰C_ou_‰Cb)C_p.)“eca\‰‰*qTC‰“\)“]qTC)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[33]:=(')“^‰‰*)“aqTC)“^qTC‰‰*ca\)“fp.)Cpp.)“fca\‰‰*qTC)“^qTC)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[34]:=(')“^‰‰*)“aqTG‰‰*ca\)“gp.‘)Cjp.‘)“gca\‰‰*qTG)“a‰‰*)“\)“\');
          PAINTCODE[Nptc].pc[35]:=(')“^‰„C‰4‰‡\ca])“g]p.’)Cbp.’])“gca]‰„C‰4‰‡\)“\)“\');PAINTCODE[Nptc].pc[36]:=(')“w^)“`p.–)“`])“eca])“j)“\');
          PAINTCODE[Nptc].pc[37]:=(')“v])“f\)“e^)“t)“\');PAINTCODE[Nptc].pc[38]:=(')“r\)“\^)“g\)“g^)“\\)“p)“\');
          PAINTCODE[Nptc].pc[39]:=(')“r^)“i\)“i^)“p)“\');PAINTCODE[Nptc].pc[40]:=(')“qca\_)“h\)“h_ca\)“o)“\');
          PAINTCODE[Nptc].pc[41]:=(')“f‰ˆC‰3‰ƒ\)“l\)“kca\‰ˆC‰3‰ƒ\)“d)“\');PAINTCODE[Nptc].pc[42]:=(')“f‰‰*qTG)“`‰‰*)“l\)“l‰‰*)“`qTG‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[43]:=(')“f‰‰*qTC‰“\)“]qTC)“`‰‰*)“j`)“j‰‰*)“`qTC‰“\)“]qTC‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[44]:=(')“f‰‰*qTC)“^qTC)“`‰‰*)“aca^)“b^)“bca^)“a‰‰*)“`qTC)“^qTC‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[45]:=(')“f‰‰*qTG)“`‰‰*)“ccaa)“^\)“^caa)“c‰‰*)“`qTG‰‰*)“d)“\');PAINTCODE[Nptc].pc[46]:=(')“f‰‰*)“`qTG‰‰*)“e‰ˆC‰6‰ƒ\)“e‰‰*qTG)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[47]:=(')“f‰‰*)“`qTC‰“\)“]qTC‰‰*)“e‰‰*qTG)“^qTG‰‰*)“e‰‰*qTC‰“\)“]qTC)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[48]:=(')“f‰‰*)“`qTC)“^qTC‰‰*)“e‰‰*qTC‰“\)“]qTC)“^qTC‰“\)“]qTC‰‰*)“e‰‰*qTC)“^qTC)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[49]:=(')“f‰‰*)“`qTG‰‰*)“e‰‰*qTC)“^qTC)“^qTC)“^qTC‰‰*)“e‰‰*qTG)“`‰‰*)“d)“\');
          PAINTCODE[Nptc].pc[50]:=(')“f‰„C‰3‰‡\)“e‰‰*qTG)“^qTG‰‰*)“e‰„C‰3‰‡\)“d)“\');PAINTCODE[Nptc].pc[51]:=(')“|‰‰*)“h‰‰*)“z)“\');
          PAINTCODE[Nptc].pc[52]:=(')“|‰‰*)“_qTG)“_‰‰*)“z)“\');PAINTCODE[Nptc].pc[53]:=(')“|‰‰*)“_qTC‰“])“\qTC)“_‰‰*)“z)“\');
          PAINTCODE[Nptc].pc[54]:=(')“|‰‰*)“_qTC‰“])“\qTC)“_‰‰*)“z)“\');PAINTCODE[Nptc].pc[55]:=(')“|‰‰*)“_qTG)“_‰‰*)“z)“\');PAINTCODE[Nptc].pc[56]:=(')“|‰„C‰6‰‡\)“z)“\');
          PAINTCODE[Nptc].pc[57]:=(')”-)“\');
          PAINTCODE[Nptc].s[1]:=('4004151/\');PAINTCODE[Nptc].s[2]:=('4005151||');PAINTCODE[Nptc].s[3]:=('19091517');PAINTCODE[Nptc].s[4]:=('3609151w');
          PAINTCODE[Nptc].s[5]:=('44091518');PAINTCODE[Nptc].s[6]:=('61091519');PAINTCODE[Nptc].s[7]:=('1413151q');PAINTCODE[Nptc].s[8]:=('6613151e');
          PAINTCODE[Nptc].s[9]:=('12251514');PAINTCODE[Nptc].s[10]:=('68251516');PAINTCODE[Nptc].s[11]:=('3526150You can move');
          PAINTCODE[Nptc].s[12]:=('3128150the cursor in these 8');PAINTCODE[Nptc].s[13]:=('0629151/-');PAINTCODE[Nptc].s[14]:=('7429151-\');
          PAINTCODE[Nptc].s[15]:=('0630151\-');PAINTCODE[Nptc].s[16]:=('3130150drections by pressing');PAINTCODE[Nptc].s[17]:=('7430151-/');
          PAINTCODE[Nptc].s[18]:=('1232151a');PAINTCODE[Nptc].s[19]:=('3432150the ');PAINTCODE[Nptc].s[20]:=('3832110keys');PAINTCODE[Nptc].s[21]:=('4232150 listed');
          PAINTCODE[Nptc].s[22]:=('6832151d');PAINTCODE[Nptc].s[23]:=('14431511');PAINTCODE[Nptc].s[24]:=('66431513');PAINTCODE[Nptc].s[25]:=('1947151z');
          PAINTCODE[Nptc].s[26]:=('6147151x');PAINTCODE[Nptc].s[27]:=('3648151s');PAINTCODE[Nptc].s[28]:=('44481512');PAINTCODE[Nptc].s[29]:=('4053151||');
          PAINTCODE[Nptc].s[30]:=('4054151\/');

          Nptc:=3;         //istruzioni 2..
          PAINTCODE[Nptc].pc[1]:=(')”-)“\');PAINTCODE[Nptc].pc[2]:=(')”-)“\');PAINTCODE[Nptc].pc[3]:=(')”-)“\');PAINTCODE[Nptc].pc[4]:=(')”-)“\');
          PAINTCODE[Nptc].pc[5]:=(')“hqTK)“”)“\');PAINTCODE[Nptc].pc[6]:=(')“hqTC)“bqTC)“”)“\');PAINTCODE[Nptc].pc[7]:=(')“hqTC)“\‰“`)“\qTC)“”)“\');
          PAINTCODE[Nptc].pc[8]:=(')“hqTC)“bqTC)“k‰}*)“^‰“w)“d)“\');PAINTCODE[Nptc].pc[9]:=(')“hqTE)“`qTC)“”)“\');PAINTCODE[Nptc].pc[10]:=(')“jqTC)“`qTC)“o‰“o)“l)“\');
          PAINTCODE[Nptc].pc[11]:=(')“jqTC)“`qTC)“”)“\');PAINTCODE[Nptc].pc[12]:=(')“jqTC)“`qTC)“”)“\');PAINTCODE[Nptc].pc[13]:=(')“jqTI)“”)“\');
          PAINTCODE[Nptc].pc[14]:=(')”-)“\');PAINTCODE[Nptc].pc[15]:=(')”-)“\');PAINTCODE[Nptc].pc[16]:=(')”-)“\');PAINTCODE[Nptc].pc[17]:=(')“fqTO)“i‰}*)“^‰“w)“d)“\');
          PAINTCODE[Nptc].pc[18]:=(')“fqTC)“\‰“d)“\qTC)“’)“\');PAINTCODE[Nptc].pc[19]:=(')“fqTC)“fqTC)“n‰“w)“c)“\');PAINTCODE[Nptc].pc[20]:=(')“fqTO)“’)“\');
          PAINTCODE[Nptc].pc[21]:=(')”-)“\');PAINTCODE[Nptc].pc[22]:=(')”-)“\');PAINTCODE[Nptc].pc[23]:=(')”-)“\');PAINTCODE[Nptc].pc[24]:=(')“bqTW)“e‰}*)“^‰“x)“c)“\');
          PAINTCODE[Nptc].pc[25]:=(')“bqTC)“b‰“`)“bqTC)“Ž)“\');PAINTCODE[Nptc].pc[26]:=(')“bqTC)“nqTC)“i‰“`)“{)“\');PAINTCODE[Nptc].pc[27]:=(')“bqTW)“Ž)“\');
          PAINTCODE[Nptc].pc[28]:=(')”-)“\');PAINTCODE[Nptc].pc[29]:=(')”-)“\');PAINTCODE[Nptc].pc[30]:=(')”-)“\');PAINTCODE[Nptc].pc[31]:=(')“hqTK)“k‰}*)“^‰“x)“c)“\');
          PAINTCODE[Nptc].pc[32]:=(')“hqTC)“\‰“`)“\qTC)“”)“\');PAINTCODE[Nptc].pc[33]:=(')“hqTC)“bqTC)“o‰“s)“h)“\');PAINTCODE[Nptc].pc[34]:=(')“hqTK)“”)“\');
          PAINTCODE[Nptc].pc[35]:=(')“…‰“m)“n)“\');PAINTCODE[Nptc].pc[36]:=(')”-)“\');PAINTCODE[Nptc].pc[37]:=(')”-)“\');
          PAINTCODE[Nptc].pc[38]:=(')“fqTG)“^qTG)“i‰}*)“^‰“x)“c)“\');PAINTCODE[Nptc].pc[39]:=(')“fqTC‰“\)“]qTC)“^qTC‰“\)“]qTC)“’)“\');
          PAINTCODE[Nptc].pc[40]:=(')“fqTC)“^qTC)“^qTC)“^qTC)“m‰“x)“c)“\');PAINTCODE[Nptc].pc[41]:=(')“fqTG)“^qTG)“’)“\');PAINTCODE[Nptc].pc[42]:=(')”-)“\');
          PAINTCODE[Nptc].pc[43]:=(')”-)“\');PAINTCODE[Nptc].pc[44]:=(')”-)“\');PAINTCODE[Nptc].pc[45]:=(')“jqTG)“m‰}*)“^‰“y)“b)“\');
          PAINTCODE[Nptc].pc[46]:=(')“jqTC‰“\)“]qTC)“–)“\');PAINTCODE[Nptc].pc[47]:=(')“jqTC)“^qTC)“q‰“{)“`)“\');PAINTCODE[Nptc].pc[48]:=(')“jqTG)“–)“\');
          PAINTCODE[Nptc].pc[49]:=(')“…‰“q)“j)“\');PAINTCODE[Nptc].pc[50]:=(')”-)“\');PAINTCODE[Nptc].pc[51]:=(')”-)“\');PAINTCODE[Nptc].pc[52]:=(')“jqTG)“–)“\');
          PAINTCODE[Nptc].pc[53]:=(')“jqTC‰“])“\qTC)“–)“\');PAINTCODE[Nptc].pc[54]:=(')“jqTC‰“])“\qTC)“m‰}*)“^‰“y)“b)“\');PAINTCODE[Nptc].pc[55]:=(')“jqTG)“–)“\');
          PAINTCODE[Nptc].pc[56]:=(')“…‰“x)“c)“\');PAINTCODE[Nptc].pc[57]:=(')“dqTG)“\qTG)“\qTG)“)“\');
          PAINTCODE[Nptc].pc[58]:=(')“dqTC‰“])“\qTC)“\qTC‰“])“\qTC)“\qTC‰“])“\qTC)“k‰“p)“k)“\');
          PAINTCODE[Nptc].pc[59]:=(')“dqTC‰“])“\qTC)“\qTC‰“])“\qTC)“\qTC‰“])“\qTC)“)“\');PAINTCODE[Nptc].pc[60]:=(')“dqTG)“\qTG)“\qTG)“)“\');
          PAINTCODE[Nptc].s[1]:=('1607151Enter');PAINTCODE[Nptc].s[2]:=('4308151To confirm the placement and');PAINTCODE[Nptc].s[3]:=('4310151select the functions');
          PAINTCODE[Nptc].s[4]:=('4317151To delete the object created');PAINTCODE[Nptc].s[5]:=('1418151BackSpace');
          PAINTCODE[Nptc].s[6]:=('4419151(useful for the bucket tool)');PAINTCODE[Nptc].s[7]:=('4324151To change the setting of some');
          PAINTCODE[Nptc].s[8]:=('1625151Space');PAINTCODE[Nptc].s[9]:=('4326151tools');PAINTCODE[Nptc].s[10]:=('4331151Necessary to paste your items');
          PAINTCODE[Nptc].s[11]:=('1632151Shift');PAINTCODE[Nptc].s[12]:=('4333151saved with the copy tool');PAINTCODE[Nptc].s[13]:=('4335151example: Shift+"g"');
          PAINTCODE[Nptc].s[14]:=('4338151sometimes you can enlarge and');PAINTCODE[Nptc].s[15]:=('1339151+');PAINTCODE[Nptc].s[16]:=('2139151-');
          PAINTCODE[Nptc].s[17]:=('4340151reduce your object with "+,-"');PAINTCODE[Nptc].s[18]:=('4345151It can recognize the colour of');
          PAINTCODE[Nptc].s[19]:=('1746151r');PAINTCODE[Nptc].s[20]:=('4347151the pixel in which you are above');
          PAINTCODE[Nptc].s[21]:=('4349151It is useful and fast!');PAINTCODE[Nptc].s[22]:=('1753151/\');PAINTCODE[Nptc].s[23]:=('1754151||');
          PAINTCODE[Nptc].s[24]:=('4354151When you are using a rectangle');PAINTCODE[Nptc].s[25]:=('4356151you can change its height and');
          PAINTCODE[Nptc].s[26]:=('1158151/-');PAINTCODE[Nptc].s[27]:=('1758151||');PAINTCODE[Nptc].s[28]:=('2358151-\');
          PAINTCODE[Nptc].s[29]:=('4358151width with these keys');PAINTCODE[Nptc].s[30]:=('1159151\-');PAINTCODE[Nptc].s[31]:=('1759151\/');
          PAINTCODE[Nptc].s[32]:=('2359151-/');

          Nptc:=4;    //Create Change..
          PAINTCODE[Nptc].pc[1]:=(')C£)C\');PAINTCODE[Nptc].pc[2]:=(')C£)C\');PAINTCODE[Nptc].pc[3]:=(')C£)C\');PAINTCODE[Nptc].pc[4]:=(')C£)C\');
          PAINTCODE[Nptc].pc[5]:=(')C£)C\');PAINTCODE[Nptc].pc[6]:=(')C£)C\');PAINTCODE[Nptc].pc[7]:=(')C£)C\');PAINTCODE[Nptc].pc[8]:=(')C£)C\');
          PAINTCODE[Nptc].pc[9]:=(')C£)C\');PAINTCODE[Nptc].pc[10]:=(')C£)C\');PAINTCODE[Nptc].pc[11]:=(')CbhC‰~,hC)CahC‹t,hC');
          PAINTCODE[Nptc].pc[12]:=(')CbhC0HwhC)CahCEWwhC');PAINTCODE[Nptc].pc[13]:=(')CbhC0HwhC)CahCEWwhC');
          PAINTCODE[Nptc].pc[14]:=(')CbhC0Hf‰“a0HfhC)CahCEWf‹‰aEWfhC');PAINTCODE[Nptc].pc[15]:=(')CbhC0HwhC)CahCEWwhC');
          PAINTCODE[Nptc].pc[16]:=(')CbhC0Hd‰“\0H\‰“c0HdhC)CahCEWd‹‰eEWdhC');PAINTCODE[Nptc].pc[17]:=(')CbhC0HwhC)CahCEWwhC');
          PAINTCODE[Nptc].pc[18]:=(')CbhC0HwhC)CahCEWwhC');PAINTCODE[Nptc].pc[19]:=(')CbhC0HwhC)CahCEWwhC');PAINTCODE[Nptc].pc[20]:=(')CbhC‰}EhC)CahC‹sEhC');
          PAINTCODE[Nptc].s[1]:=('2014151CREATE');PAINTCODE[Nptc].s[2]:=('5614154CHANGE');PAINTCODE[Nptc].s[3]:=('1816151A');
          PAINTCODE[Nptc].s[4]:=('2016151 NEW ONE');PAINTCODE[Nptc].s[5]:=('5416154AN OLD ONE');

          Nptc:=6;    //Fiile not found..
          PAINTCODE[Nptc].pc[1]:=('\EN)C])C\');PAINTCODE[Nptc].pc[2]:=('\EC)Ce\EE)C\');PAINTCODE[Nptc].pc[3]:=('\EC)Ce\EE\EC');PAINTCODE[Nptc].pc[4]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[5]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[6]:=('\EC)C_\\_)C`\EC');PAINTCODE[Nptc].pc[7]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[8]:=('\EC)C`\\^)C`\EC');PAINTCODE[Nptc].pc[9]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[10]:=('\EC)C_\\`)C_\EC');
          PAINTCODE[Nptc].pc[11]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[12]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[13]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[14]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[15]:=('\EP\EC');
          PAINTCODE[Nptc].s[1]:=('0606080File');PAINTCODE[Nptc].s[2]:=('0708080not');PAINTCODE[Nptc].s[3]:=('0610080found');

          Nptc:=7;    //corrupted file..
          PAINTCODE[Nptc].pc[1]:=('\EN)C])C\');PAINTCODE[Nptc].pc[2]:=('\EC)Ce\EE)C\');PAINTCODE[Nptc].pc[3]:=('\EC)Ce\EE\EC');PAINTCODE[Nptc].pc[4]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[5]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[6]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[7]:=('\EC)C]\\d)C]\EC');PAINTCODE[Nptc].pc[8]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[9]:=('\EC)C_\\_)C`\EC');PAINTCODE[Nptc].pc[10]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[11]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[12]:=('\EC)Ch\EC');
          PAINTCODE[Nptc].pc[13]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[14]:=('\EC)Ch\EC');PAINTCODE[Nptc].pc[15]:=('\EP\EC');
          PAINTCODE[Nptc].s[1]:=('0407080corrupted');PAINTCODE[Nptc].s[2]:=('0609080file');

          Nptc:=5;    // file found..
          PAINTCODE[Nptc].pc[1]:=('hN)C])C\');PAINTCODE[Nptc].pc[2]:=('hC)CehE)C\');PAINTCODE[Nptc].pc[3]:=('hC)CehEhC');PAINTCODE[Nptc].pc[4]:=('hC)ChhC');
          PAINTCODE[Nptc].pc[5]:=('hC)ChhC');PAINTCODE[Nptc].pc[6]:=('hC)ChhC');PAINTCODE[Nptc].pc[7]:=('hC)C_‰C_)C`hC');PAINTCODE[Nptc].pc[8]:=('hC)ChhC');
          PAINTCODE[Nptc].pc[9]:=('hC)C^‰Ca)C_hC');PAINTCODE[Nptc].pc[10]:=('hC)ChhC');PAINTCODE[Nptc].pc[11]:=('hC)ChhC');PAINTCODE[Nptc].pc[12]:=('hC)ChhC');
          PAINTCODE[Nptc].pc[13]:=('hC)ChhC');PAINTCODE[Nptc].pc[14]:=('hC)ChhC');PAINTCODE[Nptc].pc[15]:=('hPhC');
          PAINTCODE[Nptc].s[1]:=('0607150File');PAINTCODE[Nptc].s[2]:=('0509150 found');


          Nptc:=8;    // undo ecc..
          PAINTCODE[Nptc].pc[1]:=(')CwhCŠP£hC');PAINTCODE[Nptc].pc[2]:=(')CwhCŠfqhC');PAINTCODE[Nptc].pc[3]:=(')CbhC‹s™hC)CbhCŠfqhC');
          PAINTCODE[Nptc].pc[4]:=(')CbhC‹‰ghC)CbhCŠfqhC');PAINTCODE[Nptc].pc[5]:=(')CbhC‹s5hC)CbhCŠP?hC');
          PAINTCODE[Nptc].s[1]:=('0904154    UNDO    ');

          Nptc:=9;    // istruioni 3..
          PAINTCODE[Nptc].pc[1]:=('0I+0H\');PAINTCODE[Nptc].pc[2]:=('0H]hC‰-šhC0H]hC‰-šhC0H]hC‰-šhC0HfhC‰-›hC');
          PAINTCODE[Nptc].pc[3]:=('0H]hC)C_v*`)C_hC0H]hC)C\v*e)C]hC0H]hC)C^v*b)C^hC0HfhC‰C`v*_‰C`hC');
          PAINTCODE[Nptc].pc[4]:=('0H]hC)C_u”C)CchC0H]hC)C\u”C)CfhC0H]hC)C^u”C)CdhC0HfhC‰C`u”C‰CchC');
          PAINTCODE[Nptc].pc[5]:=('0H]hC)C`†cE)C`hC0H]hC)C`>R^)C`hC0H]hC)C^‰1Ž)C\‰C^)C\„rŽ)C^hC0HfhC‰C^/_1‰C^hC');
          PAINTCODE[Nptc].pc[6]:=('0H]hC)C`†cE)C`hC0H]hC)C`>R^)C`hC0H]hC)ChhC0HfhC‰C^0H\‰“a0H\‰C^hC');
          PAINTCODE[Nptc].pc[7]:=('0H]hC)ChhC0H]hC)ChhC0H]hC)C]‰Cd)C]hC0HfhC‰C^/_•‰C^hC');
          PAINTCODE[Nptc].pc[8]:=('0H]hC)C^‰Ca)C_hC0H]hC)C_‰C_)C`hC0H]hC)ChhC0HfhC‰CihC');
          PAINTCODE[Nptc].pc[9]:=('0H]hC‰-6hC0H]hC‰-6hC0H]hC‰-6hC0HfhC‰C\V*]‰C_V*]‰C`hC');PAINTCODE[Nptc].pc[10]:=('0H™hC‰CihC');
          PAINTCODE[Nptc].pc[11]:=('0H™hC‰-7hC');PAINTCODE[Nptc].pc[12]:=('0Hl)“€0Hr0H\');PAINTCODE[Nptc].pc[13]:=('0Hl)“€0Hr0H\');
          PAINTCODE[Nptc].pc[14]:=('0Hl)“€0Hr0H\');PAINTCODE[Nptc].pc[15]:=('0Hl)“€0Hr0H\');PAINTCODE[Nptc].pc[16]:=('0Hl)“€0Hr0H\');
          PAINTCODE[Nptc].pc[17]:=('0HjhC‰~@hC0Hg0H\');PAINTCODE[Nptc].pc[18]:=('0HjhC0H^)“€0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[19]:=('0HjhC0H^)“g0H\‰“j0H])“b0HchC0Hg0H\');PAINTCODE[Nptc].pc[20]:=('0HjhC0H^)“€0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[21]:=('0HjhC0H^)“]‰“bvz`‰“fvz\‰“\)“e0HchC0Hg0H\');PAINTCODE[Nptc].pc[22]:=('0HjhC0H^)“dCNC)“v0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[23]:=('0HjhC0H^)“]‰“bvze‰“lvz\‰“\0HbhC0Hg0H\');PAINTCODE[Nptc].pc[24]:=('0HjhC0H^)“dCNC)“v0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[25]:=('0HjhC0H^)“]‰“hvzb‰“fvz\‰“\)“]0HchC0Hg0H\');PAINTCODE[Nptc].pc[26]:=('0HjhC0H^)“jCNC)“p0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[27]:=('0HjhC‰“\0H]‰“dvz_‰“fvz\‰“ohC0Hg0H\');PAINTCODE[Nptc].pc[28]:=('0HjhC0H^)“dCNC)“v0HchC0Hg0H\');
          PAINTCODE[Nptc].pc[29]:=('0HjhC‰}YhC0Hg0H\');
          PAINTCODE[Nptc].s[1]:=('0803120COLOR');PAINTCODE[Nptc].s[2]:=('2203120BACKGROUND');PAINTCODE[Nptc].s[3]:=('4103120PATTERN');
          PAINTCODE[Nptc].s[4]:=('6903120TOOL');PAINTCODE[Nptc].s[5]:=('4305150-->');PAINTCODE[Nptc].s[6]:=('6806151PENCIL');
          PAINTCODE[Nptc].s[7]:=('4007150chr (197)');PAINTCODE[Nptc].s[8]:=('0708150Yellow');PAINTCODE[Nptc].s[9]:=('2508150Cyan');
          PAINTCODE[Nptc].s[10]:=('6509070X=');PAINTCODE[Nptc].s[11]:=('680915040');PAINTCODE[Nptc].s[12]:=('7109070Y=');PAINTCODE[Nptc].s[13]:=('740915030');
          PAINTCODE[Nptc].s[14]:=('3319151You can choose:');PAINTCODE[Nptc].s[15]:=('22211511. The ');PAINTCODE[Nptc].s[16]:=('2921121COLOR');
          PAINTCODE[Nptc].s[17]:=('3421151 pressing "');PAINTCODE[Nptc].s[18]:=('4521121c');PAINTCODE[Nptc].s[19]:=('4621151"');
          PAINTCODE[Nptc].s[20]:=('22231512. The ');PAINTCODE[Nptc].s[21]:=('2923121BACKGROUND');PAINTCODE[Nptc].s[22]:=('3923151 color pressing "');
          PAINTCODE[Nptc].s[23]:=('5623121b');PAINTCODE[Nptc].s[24]:=('5723151"');PAINTCODE[Nptc].s[25]:=('22251513. The pixel ');
          PAINTCODE[Nptc].s[26]:=('3525121PATTERN');PAINTCODE[Nptc].s[27]:=('4225151 pressing "');PAINTCODE[Nptc].s[28]:=('5325121p');
          PAINTCODE[Nptc].s[29]:=('5425151"');PAINTCODE[Nptc].s[30]:=('1727151 ');PAINTCODE[Nptc].s[31]:=('2027151  4. The ');PAINTCODE[Nptc].s[32]:=('2927121TOOL');
          PAINTCODE[Nptc].s[33]:=('3327151 pressing "');PAINTCODE[Nptc].s[34]:=('4427121t');PAINTCODE[Nptc].s[35]:=('4527151"                   ');

          Nptc:=10;     //Titolo SetUp..
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C)C\');
          PAINTCODE[Nptc].pc[5]:=(')C)C\');PAINTCODE[Nptc].pc[6]:=(')C)C\');PAINTCODE[Nptc].pc[7]:=(')C)C\');PAINTCODE[Nptc].pc[8]:=(')C)C\');
          PAINTCODE[Nptc].pc[9]:=(')C)C\');PAINTCODE[Nptc].pc[10]:=(')C)C\');PAINTCODE[Nptc].pc[11]:=(')C)C\');PAINTCODE[Nptc].pc[12]:=(')C)C\');
          PAINTCODE[Nptc].pc[13]:=(')C)C\');PAINTCODE[Nptc].pc[14]:=(')C)C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');PAINTCODE[Nptc].pc[16]:=(')C)C\');
          PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')Cr‰Cj)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');PAINTCODE[Nptc].pc[20]:=(')C]Zf\U‘ŸZf\)Ck)C\');
          PAINTCODE[Nptc].pc[21]:=(')C]Zf\)C]‰Cg)C_Zf\)C_‰C\‚Ž\‰Ca‚Ž\‰C\)C])C\');PAINTCODE[Nptc].pc[22]:=(')C]Zf\U‘;Zf\)C_‰C]oua‰C])C])C\');
          PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C)C\');PAINTCODE[Nptc].pc[25]:=(')C]Zf\U‘ŸZf\)C\‰C\)Ch‰C\)C\');
          PAINTCODE[Nptc].pc[26]:=(')C]Zf\)C\‰Ci)C^Zf\)C^‰C]‚Ž\‰Ca‚Ž\‰C])C\)C\');PAINTCODE[Nptc].pc[27]:=(')C]Zf\U‘;Zf\)C_‰C]oua‰C^)C\)C\');
          PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C]Zf\U‘ŸZf\)Ck)C\');
          PAINTCODE[Nptc].pc[31]:=(')C]Zf\)C\‰Cf)CaZf\)C_‰C]‚Ž`‰C\)C_)C\');PAINTCODE[Nptc].pc[32]:=(')C]Zf\U‘;Zf\)Ck)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');
          PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C_Zf\XZ—Zf\)CbZf\W7—Zf\)C^)C\');PAINTCODE[Nptc].pc[36]:=(')C_Zf\‹‰eZf\)CbZf\ŠfeZf\)C^)C\');
          PAINTCODE[Nptc].pc[37]:=(')C_Zf\XZ3Zf\)CbZf\W73Zf\)C^)C\');
          PAINTCODE[Nptc].s[1]:=('2418150To change them:');PAINTCODE[Nptc].s[2]:=('0621150Dimension = ');PAINTCODE[Nptc].s[3]:=('2721150"');
          PAINTCODE[Nptc].s[4]:=('2821140+');PAINTCODE[Nptc].s[5]:=('2921150" or "');PAINTCODE[Nptc].s[6]:=('3521140-');PAINTCODE[Nptc].s[7]:=('3621150"');
          PAINTCODE[Nptc].s[8]:=('2722150  ');PAINTCODE[Nptc].s[9]:=('2922110[1..3]');PAINTCODE[Nptc].s[10]:=('3522150  ');PAINTCODE[Nptc].s[11]:=('2425150 ');
          PAINTCODE[Nptc].s[12]:=('3825150 ');PAINTCODE[Nptc].s[13]:=('0526150Line-Spacing =');PAINTCODE[Nptc].s[14]:=('2626150 "');PAINTCODE[Nptc].s[15]:=('2826140+');
          PAINTCODE[Nptc].s[16]:=('2926150" or "');PAINTCODE[Nptc].s[17]:=('3526140-');PAINTCODE[Nptc].s[18]:=('3626150" ');PAINTCODE[Nptc].s[19]:=('2727150  ');
          PAINTCODE[Nptc].s[20]:=('2927110[1..9]');PAINTCODE[Nptc].s[21]:=('3527150   ');PAINTCODE[Nptc].s[22]:=('0531150Layout =   ');
          PAINTCODE[Nptc].s[23]:=('2731150 "');PAINTCODE[Nptc].s[24]:=('2931140space');PAINTCODE[Nptc].s[25]:=('3431150"');PAINTCODE[Nptc].s[26]:=('0636154   UNDO   ');
          PAINTCODE[Nptc].s[27]:=('2536152    OK    ');

          Nptc:=11;     // titolo 1..
          PAINTCODE[Nptc].pc[1]:=(')Cv)C\');PAINTCODE[Nptc].pc[2]:=(')Cv)C\');PAINTCODE[Nptc].pc[3]:=(')Cv)C\');PAINTCODE[Nptc].pc[4]:=(')Cv)C\');
          PAINTCODE[Nptc].pc[5]:=(')Cv)C\');PAINTCODE[Nptc].pc[6]:=(')Cv)C\');PAINTCODE[Nptc].pc[7]:=(')CgqTF)CaqTGqTC');
          PAINTCODE[Nptc].pc[8]:=(')CfqTD)C]qTD)CcqTD)C\');PAINTCODE[Nptc].pc[9]:=(')CfqTH)C\hE)C^qTD)C\)C\');PAINTCODE[Nptc].pc[10]:=(')CfqTD)C]qTD)CaqTD)C])C\');
          PAINTCODE[Nptc].pc[11]:=(')CfqTD)C]qTD)C`qTGqTC');

          Nptc:=12;     // titolo 2..
          PAINTCODE[Nptc].pc[1]:=(')Cw)C\');PAINTCODE[Nptc].pc[2]:=(')Cw)C\');PAINTCODE[Nptc].pc[3]:=(')Cw)C\');PAINTCODE[Nptc].pc[4]:=(')CfqTF)CcqTGqTC');
          PAINTCODE[Nptc].pc[5]:=(')CfqTF)CcqTGqTC');PAINTCODE[Nptc].pc[6]:=(')CeqTD)C]qTD)CeqTD)C\');PAINTCODE[Nptc].pc[7]:=(')CeqTD)C]qTD)CeqTD)C\');
          PAINTCODE[Nptc].pc[8]:=(')CeqTH)CdqTD)C\)C\');PAINTCODE[Nptc].pc[9]:=(')CeqTH)C]hF)C^qTD)C\)C\');PAINTCODE[Nptc].pc[10]:=(')CeqTD)C]qTD)CcqTD)C])C\');
          PAINTCODE[Nptc].pc[11]:=(')CeqTD)C]qTD)CcqTD)C])C\');PAINTCODE[Nptc].pc[12]:=(')CeqTD)C]qTD)CbqTGqTC');PAINTCODE[Nptc].pc[13]:=(')CeqTD)C]qTD)CbqTGqTC');

          Nptc:=13;     // titolo 3..
          PAINTCODE[Nptc].pc[1]:=(')C})C\');PAINTCODE[Nptc].pc[2]:=(')CaqTJ)CdqTMqTC');PAINTCODE[Nptc].pc[3]:=(')CaqTJ)CdqTMqTC');
          PAINTCODE[Nptc].pc[4]:=(')CaqTJ)CdqTMqTC');PAINTCODE[Nptc].pc[5]:=(')C_qTF)C_qTF)ChqTF)C\)C\');PAINTCODE[Nptc].pc[6]:=(')C_qTF)C_qTF)ChqTF)C\)C\');
          PAINTCODE[Nptc].pc[7]:=(')C_qTF)C_qTF)ChqTF)C\)C\');PAINTCODE[Nptc].pc[8]:=(')C_qTN)CfqTF)C^)C\');PAINTCODE[Nptc].pc[9]:=(')C_qTN)C]hF)C`qTF)C^)C\');
          PAINTCODE[Nptc].pc[10]:=(')C_qTN)CfqTF)C^)C\');PAINTCODE[Nptc].pc[11]:=(')C_qTF)C_qTF)CdqTF)C`)C\');PAINTCODE[Nptc].pc[12]:=(')C_qTF)C_qTF)CdqTF)C`)C\');
          PAINTCODE[Nptc].pc[13]:=(')C_qTF)C_qTF)CdqTF)C`)C\');PAINTCODE[Nptc].pc[14]:=(')C_qTF)C_qTF)CbqTMqTC');PAINTCODE[Nptc].pc[15]:=(')C_qTF)C_qTF)CbqTMqTC');
          PAINTCODE[Nptc].pc[16]:=(')C_qTF)C_qTF)CbqTMqTC');

          Nptc:=14;     // setUpGriglia..
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C]bt˜u¤Cu¥—u¤C‚|3‚~\)C])C\');
          PAINTCODE[Nptc].pc[4]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[5]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');
          PAINTCODE[Nptc].pc[6]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[7]:=(')C]bt˜v)uu¥—v)u‚|3‚}u)C])C\');
          PAINTCODE[Nptc].pc[8]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[9]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');
          PAINTCODE[Nptc].pc[10]:=(')C]btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[11]:=(')C]bt˜u£\u¥—u£\‚|3‚‚\)C])C\');PAINTCODE[Nptc].pc[12]:=(')C)C\');
          PAINTCODE[Nptc].pc[13]:=(')Cr‰Cj)C\');PAINTCODE[Nptc].pc[14]:=(')Cu‰C\‚Ž\‰Ca‚Ž\‰C\)C])C\');PAINTCODE[Nptc].pc[15]:=(')C]Zf\U‘ Zf\)Cj)C\');
          PAINTCODE[Nptc].pc[16]:=(')C]Zf\)C]‰Ch)C_Zf\)C^oue)C])C\');PAINTCODE[Nptc].pc[17]:=(')C]Zf\U‘<Zf\)C^‰Cg)C\');PAINTCODE[Nptc].pc[18]:=(')C€‰C\)C\');
          PAINTCODE[Nptc].pc[19]:=(')C]Zf\U‘ Zf\)Ci‰C\)C\');PAINTCODE[Nptc].pc[20]:=(')C]Zf\)C\‰Ci)C_Zf\)C_oud)C\‰C\)C\');PAINTCODE[Nptc].pc[21]:=(')C]Zf\U‘<Zf\)C]‰Ch)C\');
          PAINTCODE[Nptc].pc[22]:=(')Ct‰C\)Cg)C\');PAINTCODE[Nptc].pc[23]:=(')Ct‰C\)Cg)C\');PAINTCODE[Nptc].pc[24]:=(')C]Zf\U‘ Zf\)C]‰C\)Cf‰C\)C\');
          PAINTCODE[Nptc].pc[25]:=(')C]Zf\)C\‰C\)C\‰Cf)C`Zf\)C]‰C\)C\oud)C])C\');PAINTCODE[Nptc].pc[26]:=(')C]Zf\U‘<Zf\)C]‰Ch‰C\');PAINTCODE[Nptc].pc[27]:=(')C€‰C\)C\');
          PAINTCODE[Nptc].pc[28]:=(')C]Zf\U‘ Zf\)Ci‰C\)C\');PAINTCODE[Nptc].pc[29]:=(')C]Zf\)C]‰Cg)C`Zf\)C_oud)C\‰C\)C\');PAINTCODE[Nptc].pc[30]:=(')C]Zf\U‘<Zf\)C]‰Ch)C\');
          PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C_Zf\XZ—Zf\)CbZf\W7—Zf\)C^)C\');
          PAINTCODE[Nptc].pc[34]:=(')C_Zf\‹‰eZf\)CbZf\ŠfeZf\)C^)C\');PAINTCODE[Nptc].pc[35]:=(')C_Zf\XZ3Zf\)CbZf\W73Zf\)C^)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');
          PAINTCODE[Nptc].s[1]:=('2413150To change them:');PAINTCODE[Nptc].s[2]:=('2714150"');PAINTCODE[Nptc].s[3]:=('2814140+');
          PAINTCODE[Nptc].s[4]:=('2914150" or "');PAINTCODE[Nptc].s[5]:=('3514140-');PAINTCODE[Nptc].s[6]:=('3614150"');
          PAINTCODE[Nptc].s[7]:=('0616150N. Columns = ');PAINTCODE[Nptc].s[8]:=('2716110 [1.. 39 ]');PAINTCODE[Nptc].s[9]:=('2717150            ');
          PAINTCODE[Nptc].s[10]:=('3818150 ');PAINTCODE[Nptc].s[11]:=('3819150 ');PAINTCODE[Nptc].s[12]:=('0520150Dime. Column =');
          PAINTCODE[Nptc].s[13]:=('2820110[1.. 78 ]');PAINTCODE[Nptc].s[14]:=('3820150 ');PAINTCODE[Nptc].s[15]:=('2621150             ');
          PAINTCODE[Nptc].s[16]:=('2622150 ');PAINTCODE[Nptc].s[17]:=('2623150 ');PAINTCODE[Nptc].s[18]:=('2624150 ');PAINTCODE[Nptc].s[19]:=('3824150 ');
          PAINTCODE[Nptc].s[20]:=('0525150 ');PAINTCODE[Nptc].s[21]:=('0725150N. Lines  =');PAINTCODE[Nptc].s[22]:=('2625150 ');
          PAINTCODE[Nptc].s[23]:=('2825110[1.. 39 ]');PAINTCODE[Nptc].s[24]:=('2626150              ');PAINTCODE[Nptc].s[25]:=('3827150 ');
          PAINTCODE[Nptc].s[26]:=('3828150 ');PAINTCODE[Nptc].s[27]:=('0629150Dime. Line =');PAINTCODE[Nptc].s[28]:=('2829110[1.. 78 ]');
          PAINTCODE[Nptc].s[29]:=('3829150 ');PAINTCODE[Nptc].s[30]:=('2630150             ');PAINTCODE[Nptc].s[31]:=('0634154   UNDO   ');
          PAINTCODE[Nptc].s[32]:=('2534152    OK    ');

          Nptc:=15;  //Interfaccia matita
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C)C\');
          PAINTCODE[Nptc].pc[5]:=(')C)C\');PAINTCODE[Nptc].pc[6]:=(')C)C\');PAINTCODE[Nptc].pc[7]:=(')C)C\');PAINTCODE[Nptc].pc[8]:=(')C^€/we†aŠSa^O_+)C^)C\');
          PAINTCODE[Nptc].pc[9]:=(')C^€/we)CqSaa\B)C\');PAINTCODE[Nptc].pc[10]:=(')C^€/we†aŠSa^O_)C^)C\');PAINTCODE[Nptc].pc[11]:=(')C)C\');
          PAINTCODE[Nptc].pc[12]:=(')C)C\');PAINTCODE[Nptc].pc[13]:=(')C)C\');PAINTCODE[Nptc].pc[14]:=(')C)C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');
          PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
          PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')Cd‰C`‚Ž`‰Cf)Cc)C\');PAINTCODE[Nptc].pc[23]:=(')Cg‰Cj)Cf)C\');
          PAINTCODE[Nptc].pc[24]:=(')C)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')C)C\');PAINTCODE[Nptc].pc[27]:=(')C^oub‰Ct)C^)C\');
          PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')Ch‰Ci‚Ž`‰C\)C`)C\');PAINTCODE[Nptc].pc[30]:=(')C)C\');PAINTCODE[Nptc].pc[31]:=(')C)C\');
          PAINTCODE[Nptc].pc[32]:=(')C^ou_)C]‰C])C]‰Cp)C_)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');PAINTCODE[Nptc].pc[34]:=(')Ch‰Cq)C^)C\');
          PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
          PAINTCODE[Nptc].s[1]:=('1022150Use "');PAINTCODE[Nptc].s[2]:=('1522140space');PAINTCODE[Nptc].s[3]:=('2022150" to switch');
          PAINTCODE[Nptc].s[4]:=('1323150its properties:');PAINTCODE[Nptc].s[5]:=('0427110POINTS ');PAINTCODE[Nptc].s[6]:=('1127150-> Will draw a point when');
          PAINTCODE[Nptc].s[7]:=('1429150you''ll press "');PAINTCODE[Nptc].s[8]:=('2829140ENTER');PAINTCODE[Nptc].s[9]:=('3329150"');
          PAINTCODE[Nptc].s[10]:=('0432110LINE');PAINTCODE[Nptc].s[11]:=('1032150->');PAINTCODE[Nptc].s[12]:=('1432150Will drow a line when');
          PAINTCODE[Nptc].s[13]:=('1434150you''ll move the cursor');

          Nptc:=16;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C)C\');
          PAINTCODE[Nptc].pc[5]:=(')C`)Žu)‘¢)ŒChH)C_)C\');PAINTCODE[Nptc].pc[6]:=(')C`)‹\cJW)‹\hI)C^)C\');PAINTCODE[Nptc].pc[7]:=(')C`)‹\cJW)‹\hI)C^)C\');
          PAINTCODE[Nptc].pc[8]:=(')C`)‹\cJW)‹\hI)C^)C\');PAINTCODE[Nptc].pc[9]:=(')C`)‹\cJW)‹\hI)C^)C\');PAINTCODE[Nptc].pc[10]:=(')C`)‹\cJW)‹\hI)C^)C\');
          PAINTCODE[Nptc].pc[11]:=(')C`)Ž)‘¢)*hH)C_)C\');PAINTCODE[Nptc].pc[12]:=(')C)C\');PAINTCODE[Nptc].pc[13]:=(')C)C\');PAINTCODE[Nptc].pc[14]:=(')C)C\');
          PAINTCODE[Nptc].pc[15]:=(')C)C\');PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');
          PAINTCODE[Nptc].pc[19]:=(')C)C\');PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');
          PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C`‰Ca‚Ž\‰Ca‚Ž\‰Cj)C_)C\');PAINTCODE[Nptc].pc[25]:=(')Ci‰Cf)Ch)C\');
          PAINTCODE[Nptc].pc[26]:=(')C)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');
          PAINTCODE[Nptc].pc[30]:=(')C`‰Cy)C^)C\');PAINTCODE[Nptc].pc[31]:=(')Cm‰C_)Ck)C\');PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');
          PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
          PAINTCODE[Nptc].s[1]:=('0624150Use  "');PAINTCODE[Nptc].s[2]:=('1224140+');PAINTCODE[Nptc].s[3]:=('1324150" or "');PAINTCODE[Nptc].s[4]:=('1924140-');
          PAINTCODE[Nptc].s[5]:=('2024150" to change the');PAINTCODE[Nptc].s[6]:=('1525150eraser size');
          PAINTCODE[Nptc].s[7]:=('0630150Use "     " to erase the whole');PAINTCODE[Nptc].s[8]:=('1130140space');PAINTCODE[Nptc].s[9]:=('1931150page');

          Nptc:=17;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C)C\');
          PAINTCODE[Nptc].pc[5]:=(')C)C\');PAINTCODE[Nptc].pc[6]:=(')C)C\');PAINTCODE[Nptc].pc[7]:=(')C)C\');PAINTCODE[Nptc].pc[8]:=(')C^Zf|)C])C\');
          PAINTCODE[Nptc].pc[9]:=(')C^Zf|)C])C\');PAINTCODE[Nptc].pc[10]:=(')C^Zf|)C])C\');PAINTCODE[Nptc].pc[11]:=(')C^Zf\-{)C])C\');
          PAINTCODE[Nptc].pc[12]:=(')C^Zf\-zZf\)C])C\');PAINTCODE[Nptc].pc[13]:=(')C)C\');PAINTCODE[Nptc].pc[14]:=(')C)C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');
          PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
          PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');
          PAINTCODE[Nptc].pc[24]:=(')C)C\');PAINTCODE[Nptc].pc[25]:=(')C_‰C{)C])C\');PAINTCODE[Nptc].pc[26]:=(')C)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');
          PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C)C\');PAINTCODE[Nptc].pc[31]:=(')C)C\');
          PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');
          PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
          PAINTCODE[Nptc].s[1]:=('05110070  1  2  3  4  5  6  7  8  9  10');PAINTCODE[Nptc].s[2]:=('0512007|  |  |  |  |  |  |  |  |  |  |');
          PAINTCODE[Nptc].s[3]:=('0525150Use it the same way of a segment');

          Nptc:=18;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C)C\');
PAINTCODE[Nptc].pc[5]:=(')C)C\');PAINTCODE[Nptc].pc[6]:=(')C]ouv)Cd)C\');PAINTCODE[Nptc].pc[7]:=(')C)C\');PAINTCODE[Nptc].pc[8]:=(')Ci‰Ca‚Ž`‰Cg)C\)C\');
PAINTCODE[Nptc].pc[9]:=(')Ci‰Cr)C\)C\');PAINTCODE[Nptc].pc[10]:=(')Ci‚Ž_‰C]‚Žg‰C^)C]‰C\)C\');PAINTCODE[Nptc].pc[11]:=(')Ci‚Ža)C\‰Ce‚Ž`‰C\)C\)C\');
PAINTCODE[Nptc].pc[12]:=(')Ci‰Cp)C^)C\');PAINTCODE[Nptc].pc[13]:=(')Ci‰Ce)C\‰C\)Cg)C\');PAINTCODE[Nptc].pc[14]:=(')C)C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');
PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C]ou~)C\)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')Ce‚Žn)Cd)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C_‰Cy)C_)C\');
PAINTCODE[Nptc].pc[24]:=(')C_‰C{)C])C\');PAINTCODE[Nptc].pc[25]:=(')Cm‰C_)Ck)C\');PAINTCODE[Nptc].pc[26]:=(')C_‰Cz)C^)C\');
PAINTCODE[Nptc].pc[27]:=(')Ca‰Cv)C`)C\');PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')Cm‚Ž_)Ck)C\');
PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')Ch‰Ci)Cf)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');PAINTCODE[Nptc].pc[34]:=(')C)C\');
PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0306110FIRST STEP: Select the area');PAINTCODE[Nptc].s[2]:=('1508150Use  "');PAINTCODE[Nptc].s[3]:=('2108140space');
PAINTCODE[Nptc].s[4]:=('2608150"  to switch');PAINTCODE[Nptc].s[5]:=('1509150the method of selection');PAINTCODE[Nptc].s[6]:=('1510140LINE');
PAINTCODE[Nptc].s[7]:=('1910150 ,');PAINTCODE[Nptc].s[8]:=('2110140 RECTANGLE  ');PAINTCODE[Nptc].s[9]:=('3310150and');PAINTCODE[Nptc].s[10]:=('3810150 ');
PAINTCODE[Nptc].s[11]:=('1511140BUCKET');PAINTCODE[Nptc].s[12]:=('2211150( press  "');PAINTCODE[Nptc].s[13]:=('3211140ENTER');
PAINTCODE[Nptc].s[14]:=('3711150"');PAINTCODE[Nptc].s[15]:=('1512150on a preselected area');PAINTCODE[Nptc].s[16]:=('1513150to confirm');
PAINTCODE[Nptc].s[17]:=('2613150)');PAINTCODE[Nptc].s[18]:=('0318110SECOND STEP: Choose to copy or move');
PAINTCODE[Nptc].s[19]:=('1121140        COPY       ');PAINTCODE[Nptc].s[20]:=('0523150 Save  the image in a  capital');
PAINTCODE[Nptc].s[21]:=('0524150letter and give it a description');PAINTCODE[Nptc].s[22]:=('1925150then');
PAINTCODE[Nptc].s[23]:=('0526150by pressing the  letter you can');PAINTCODE[Nptc].s[24]:=('0727150past it  wherever  you want');
PAINTCODE[Nptc].s[25]:=('1930140MOVE');PAINTCODE[Nptc].s[26]:=('1432150cut  and paste');

          Nptc:=19;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')Cn-g\@~)Ck)C\');PAINTCODE[Nptc].pc[3]:=(')Ck-g^<’Ž@~)Cj)C\');
PAINTCODE[Nptc].pc[4]:=(')Ch-ga<’Ž@~‘)Ci)C\');PAINTCODE[Nptc].pc[5]:=(')Cf-gb<’@~’)Ch)C\');PAINTCODE[Nptc].pc[6]:=(')Ce-gb<’@~“)Cg)C\');
PAINTCODE[Nptc].pc[7]:=(')Cd-ga<’’@~”)Cf)C\');PAINTCODE[Nptc].pc[8]:=(')Cc-g`<’“@~–)Ce)C\');PAINTCODE[Nptc].pc[9]:=(')Cb-g^<’–@~—)Cd)C\');
PAINTCODE[Nptc].pc[10]:=(')Ca<’–@~<’@~˜)Cc)C\');PAINTCODE[Nptc].pc[11]:=(')Ca<’–@~<’Ž@~™)Cb)C\');PAINTCODE[Nptc].pc[12]:=(')Cb<’’@~Ž<’@~)Cb)C\');
PAINTCODE[Nptc].pc[13]:=(')Cb<’‘@~<’Ž@~)Cc)C\');PAINTCODE[Nptc].pc[14]:=(')Cc<’@~¡)Cc)C\');PAINTCODE[Nptc].pc[15]:=(')Cc<’)C\@~Ÿ)Cd)C\');
PAINTCODE[Nptc].pc[16]:=(')Cg@~)Ce)C\');PAINTCODE[Nptc].pc[17]:=(')Ch@~š)Cg)C\');PAINTCODE[Nptc].pc[18]:=(')Ci@~—)Ci)C\');
PAINTCODE[Nptc].pc[19]:=(')Cj@~“)Cl)C\');PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');
PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')C)C\');
PAINTCODE[Nptc].pc[27]:=(')C)C\');PAINTCODE[Nptc].pc[28]:=(')C^‰C|)C])C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C^‰C|)C])C\');
PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');PAINTCODE[Nptc].pc[34]:=(')C)C\');
PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0428150Paint  a portion  of  the drawing');PAINTCODE[Nptc].s[2]:=('0430150that has the same characteristics');

          Nptc:=20;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')Cz†cE)C_)C\');
PAINTCODE[Nptc].pc[5]:=(')Cx…?^)Ca)C\');PAINTCODE[Nptc].pc[6]:=(')Cu…?_)Cc)C\');PAINTCODE[Nptc].pc[7]:=(')Cs…>w)Cf)C\');
PAINTCODE[Nptc].pc[8]:=(')Cp…=‘)Ch)C\');PAINTCODE[Nptc].pc[9]:=(')Cn…=)Ck)C\');PAINTCODE[Nptc].pc[10]:=(')Clyy)Cm)C\');
PAINTCODE[Nptc].pc[11]:=(')Ciyzx)Co)C\');PAINTCODE[Nptc].pc[12]:=(')Cgyzw)Cr)C\');PAINTCODE[Nptc].pc[13]:=(')Cdy{_)Ct)C\');
PAINTCODE[Nptc].pc[14]:=(')CbxYE)Cw)C\');PAINTCODE[Nptc].pc[15]:=(')C`xYE)Cy)C\');PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');
PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');
PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C_‰Cz)C^)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');
PAINTCODE[Nptc].pc[26]:=(')C_‰Cz)C^)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');PAINTCODE[Nptc].pc[28]:=(')C_‰Co‚Ž`‰Ca)C^)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');
PAINTCODE[Nptc].pc[30]:=(')C_‰Cz)C^)C\');PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')C_‰Cc)Cu)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');
PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0524150Place the first vertex and drag');PAINTCODE[Nptc].s[2]:=('0526150the other with the cursor, each');
PAINTCODE[Nptc].s[3]:=('0528150time you''ll press  "');PAINTCODE[Nptc].s[4]:=('2528140space');PAINTCODE[Nptc].s[5]:=('3028150"  the');
PAINTCODE[Nptc].s[6]:=('0530150the  mobile   vertex   will  be');PAINTCODE[Nptc].s[7]:=('0532150switched');

          Nptc:=21;
          PAINTCODE[Nptc].pc[1]:=('‰C‰C\');PAINTCODE[Nptc].pc[2]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[3]:=('‰C\)C\bt˜u¤Cu¥—u¤C‚|3‚~\)C])C\');
PAINTCODE[Nptc].pc[4]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[5]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');
PAINTCODE[Nptc].pc[6]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[7]:=('‰C\)C\bt˜v)uu¥—v)u‚|3‚}u)C])C\');
PAINTCODE[Nptc].pc[8]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[9]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');
PAINTCODE[Nptc].pc[10]:=('‰C\)C\btŽ)CeuŸ\)CeuŸ\)Ce‚„*)C])C\');PAINTCODE[Nptc].pc[11]:=('‰C\)C\bt˜u£\u¥—u£\‚|3‚‚\)C])C\');PAINTCODE[Nptc].pc[12]:=('‰C\)C€)C\');
PAINTCODE[Nptc].pc[13]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[14]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[15]:=('‰C\)C~‰C\)C\)C\');
PAINTCODE[Nptc].pc[16]:=('‰C\)CbZf\U‘ Zf\)Cd)C\');PAINTCODE[Nptc].pc[17]:=('‰C\)CbZf\)C]‰Ch)C_Zf\)C]‰Cb)C\');PAINTCODE[Nptc].pc[18]:=('‰C\)CbZf\U‘<Zf\)Cc‰C\)C\');
PAINTCODE[Nptc].pc[19]:=('‰C\)C‰C\)C\');PAINTCODE[Nptc].pc[20]:=('‰C\)CbZf\U‘ Zf\)Cc‰C\)C\');PAINTCODE[Nptc].pc[21]:=('‰C\)CbZf\)C\‰Ci)C_Zf\)C]‰C_)C\‰C])C\');
PAINTCODE[Nptc].pc[22]:=('‰C\)CbZf\U‘<Zf\)Cd)C\');PAINTCODE[Nptc].pc[23]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[24]:=('‰C\)C‰C\)C\');
PAINTCODE[Nptc].pc[25]:=('‰C\)CbZf\U‘ Zf\)Cd)C\');PAINTCODE[Nptc].pc[26]:=('‰C\)CbZf\)C\‰C\)C\‰Cf)C`Zf\)C]‰Cb‰C\');
PAINTCODE[Nptc].pc[27]:=('‰C\)CbZf\U‘<Zf\)Cc‰C\)C\');PAINTCODE[Nptc].pc[28]:=('‰C\)C‰C\)C\');PAINTCODE[Nptc].pc[29]:=('‰C\)CbZf\U‘ Zf\)Cc‰C\)C\');
PAINTCODE[Nptc].pc[30]:=('‰C\)CbZf\)C]‰Cg)C`Zf\)C]‰C^)C\‰C^)C\');PAINTCODE[Nptc].pc[31]:=('‰C\)CbZf\U‘<Zf\)Cd)C\');PAINTCODE[Nptc].pc[32]:=('‰C\)C€)C\');
PAINTCODE[Nptc].pc[33]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[34]:=('‰Cd‚Ž`‰Cs)C\');PAINTCODE[Nptc].pc[35]:=('‰C\)C€)C\');PAINTCODE[Nptc].pc[36]:=('‰C\)Ch‰Cf)Ch)C\');
PAINTCODE[Nptc].pc[37]:=('‰C\)C€)C\');
PAINTCODE[Nptc].s[1]:=('0101150                                       ');PAINTCODE[Nptc].s[2]:=('0102150 ');PAINTCODE[Nptc].s[3]:=('0103150 ');
PAINTCODE[Nptc].s[4]:=('0104150 ');PAINTCODE[Nptc].s[5]:=('0105150 ');PAINTCODE[Nptc].s[6]:=('0106150 ');PAINTCODE[Nptc].s[7]:=('0107150 ');
PAINTCODE[Nptc].s[8]:=('0108150 ');PAINTCODE[Nptc].s[9]:=('0109150 ');PAINTCODE[Nptc].s[10]:=('0110150 ');PAINTCODE[Nptc].s[11]:=('0111150 ');
PAINTCODE[Nptc].s[12]:=('0112150 ');PAINTCODE[Nptc].s[13]:=('0113150 ');PAINTCODE[Nptc].s[14]:=('0114150 ');PAINTCODE[Nptc].s[15]:=('0115150 ');
PAINTCODE[Nptc].s[16]:=('3715150 ');PAINTCODE[Nptc].s[17]:=('0116150 ');PAINTCODE[Nptc].s[18]:=('0117150 ');PAINTCODE[Nptc].s[19]:=('1217150N. Columns = ');
PAINTCODE[Nptc].s[20]:=('3217150       ');PAINTCODE[Nptc].s[21]:=('0118150 ');PAINTCODE[Nptc].s[22]:=('3818150 ');PAINTCODE[Nptc].s[23]:=('0119150 ');
PAINTCODE[Nptc].s[24]:=('3819150 ');PAINTCODE[Nptc].s[25]:=('0120150 ');PAINTCODE[Nptc].s[26]:=('3820150 ');PAINTCODE[Nptc].s[27]:=('0121150 ');
PAINTCODE[Nptc].s[28]:=('1121150Dime. Column =');PAINTCODE[Nptc].s[29]:=('3221150    ');PAINTCODE[Nptc].s[30]:=('3721150  ');
PAINTCODE[Nptc].s[31]:=('0122150 ');PAINTCODE[Nptc].s[32]:=('0123150 ');PAINTCODE[Nptc].s[33]:=('0124150 ');PAINTCODE[Nptc].s[34]:=('3824150 ');
PAINTCODE[Nptc].s[35]:=('0125150 ');PAINTCODE[Nptc].s[36]:=('0126150 ');PAINTCODE[Nptc].s[37]:=('1126150 ');PAINTCODE[Nptc].s[38]:=('1326150N. Lines  =');
PAINTCODE[Nptc].s[39]:=('3226150        ');PAINTCODE[Nptc].s[40]:=('0127150 ');PAINTCODE[Nptc].s[41]:=('3827150 ');PAINTCODE[Nptc].s[42]:=('0128150 ');
PAINTCODE[Nptc].s[43]:=('3828150 ');PAINTCODE[Nptc].s[44]:=('0129150 ');PAINTCODE[Nptc].s[45]:=('3829150 ');PAINTCODE[Nptc].s[46]:=('0130150 ');
PAINTCODE[Nptc].s[47]:=('1230150Dime. Line =');PAINTCODE[Nptc].s[48]:=('3230150   ');PAINTCODE[Nptc].s[49]:=('3630150   ');PAINTCODE[Nptc].s[50]:=('0131150 ');
PAINTCODE[Nptc].s[51]:=('0132150 ');PAINTCODE[Nptc].s[52]:=('0133150 ');PAINTCODE[Nptc].s[53]:=('0134150 Press  "');PAINTCODE[Nptc].s[54]:=('1034140space');
PAINTCODE[Nptc].s[55]:=('1534150"  to change the texture');PAINTCODE[Nptc].s[56]:=('0135150 ');PAINTCODE[Nptc].s[57]:=('0136150 ');
PAINTCODE[Nptc].s[58]:=('1536150of the grid');

          Nptc:=22;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');
PAINTCODE[Nptc].pc[4]:=(')CacHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWv)C_)C\');PAINTCODE[Nptc].pc[5]:=(')CaxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHv)C_)C\');
PAINTCODE[Nptc].pc[6]:=(')CacHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWv)C_)C\');PAINTCODE[Nptc].pc[7]:=(')CaxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHvxWvcHv)C_)C\');
PAINTCODE[Nptc].pc[8]:=(')CajMv†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv†av)C_)C\');PAINTCODE[Nptc].pc[9]:=(')Ca†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv)C_)C\');
PAINTCODE[Nptc].pc[10]:=(')CajMv†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv†av)C_)C\');PAINTCODE[Nptc].pc[11]:=(')Ca†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv†avjMv)C_)C\');
PAINTCODE[Nptc].pc[12]:=(')Cap0]\vp0]\vp0]\vp0]\vp0]\vp0]\vp0]\v)C_)C\');PAINTCODE[Nptc].pc[13]:=(')Ca\vp0]\vp0]\vp0]\vp0]\vp0]\vp0]\vp0])C_)C\');
PAINTCODE[Nptc].pc[14]:=(')Cap0]\vp0]\vp0]\vp0]\vp0]\vp0]\vp0]\v)C_)C\');PAINTCODE[Nptc].pc[15]:=(')Ca\vp0]\vp0]\vp0]\vp0]\vp0]\vp0]\vp0])C_)C\');
PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');
PAINTCODE[Nptc].pc[24]:=(')C]‰Cx‚Žb)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')C)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');
PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C]‰C~)C\)C\');PAINTCODE[Nptc].pc[30]:=(')C)C\');PAINTCODE[Nptc].pc[31]:=(')C]‰C~)C\)C\');
PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C]‰Cc)Cw)C\');PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');
PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0324150Use the same commands of the ');PAINTCODE[Nptc].s[2]:=('3224140segment');
PAINTCODE[Nptc].s[3]:=('0329150You can use  two different textures');PAINTCODE[Nptc].s[4]:=('0331150thanks to the changes in the layout');
PAINTCODE[Nptc].s[5]:=('0333150settings');

          Nptc:=23;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C)C\');PAINTCODE[Nptc].pc[4]:=(')C_‰>u‰B-‰<C)C^)C\');
PAINTCODE[Nptc].pc[5]:=(')C_‰;\)Cx‰;\)C^)C\');PAINTCODE[Nptc].pc[6]:=(')C_‰;\)Cx‰;\)C^)C\');PAINTCODE[Nptc].pc[7]:=(')C_‰;\)C^„4f)Cj‰;\)C^)C\');
PAINTCODE[Nptc].pc[8]:=(')C_‰;\)Cx‰;\)C^)C\');PAINTCODE[Nptc].pc[9]:=(')C_‰;\)CirŽg)C^‰;\)C^)C\');PAINTCODE[Nptc].pc[10]:=(')C_‰;\)Cx‰;\)C^)C\');
PAINTCODE[Nptc].pc[11]:=(')C_‰;\)Cx‰;\)C^)C\');PAINTCODE[Nptc].pc[12]:=(')C_‰=Ž‰B-‰=*)C^)C\');PAINTCODE[Nptc].pc[13]:=(')C)C\');
PAINTCODE[Nptc].pc[14]:=(')C)C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');
PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');
PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');
PAINTCODE[Nptc].pc[26]:=(')C`‰Cy)C^)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');PAINTCODE[Nptc].pc[28]:=(')Ci‰Cg)Cg)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');
PAINTCODE[Nptc].pc[30]:=(')C)C\');PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');
PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0907142Stay hungry');PAINTCODE[Nptc].s[2]:=('2009115Stay foolish');PAINTCODE[Nptc].s[3]:=('0626150You can write normally a text ');
PAINTCODE[Nptc].s[4]:=('1528150on the  page');

          Nptc:=24;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')C)C\');PAINTCODE[Nptc].pc[3]:=(')C^qTCo_”oc1os•o[–)C])C\');
PAINTCODE[Nptc].pc[4]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[5]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[6]:=(')C^qTC)Czo[Ž)C])C\');
PAINTCODE[Nptc].pc[7]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[8]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[9]:=(')C^qTC)Czo[Ž)C])C\');
PAINTCODE[Nptc].pc[10]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[11]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[12]:=(')C^qTC)Czo[Ž)C])C\');
PAINTCODE[Nptc].pc[13]:=(')C^qTC)Czo[Ž)C])C\');PAINTCODE[Nptc].pc[14]:=(')C^qTCo_0oc1os•o[–)C])C\');PAINTCODE[Nptc].pc[15]:=(')C)C\');
PAINTCODE[Nptc].pc[16]:=(')C)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');
PAINTCODE[Nptc].pc[24]:=(')C\‰Cc‚Ž`‰Cs)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')Cg‰Ck)Ce)C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');
PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C)C\');
PAINTCODE[Nptc].pc[31]:=(')C^‰C`‚Ž\‰C^‚Ž\‰Cb‚Ž\‰C^‚Ž\‰C^‚Ž]‰C^‚Ž]‰C\)C])C\');PAINTCODE[Nptc].pc[32]:=(')Cm‰Ca)Ci)C\');PAINTCODE[Nptc].pc[33]:=(')C`‰Cx)C_)C\');
PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0224150Press  "');PAINTCODE[Nptc].s[2]:=('1024140space');PAINTCODE[Nptc].s[3]:=('1524150"  to change the texture');
PAINTCODE[Nptc].s[4]:=('1326150of the rectangle');PAINTCODE[Nptc].s[5]:=('0431150Use "');PAINTCODE[Nptc].s[6]:=('0931140+');
PAINTCODE[Nptc].s[7]:=('1031150" "');PAINTCODE[Nptc].s[8]:=('1331140-');PAINTCODE[Nptc].s[9]:=('1431150" and "');PAINTCODE[Nptc].s[10]:=('2131140>');
PAINTCODE[Nptc].s[11]:=('2231150" "');PAINTCODE[Nptc].s[12]:=('2531140<');PAINTCODE[Nptc].s[13]:=('2631150" "');PAINTCODE[Nptc].s[14]:=('2931140/\');
PAINTCODE[Nptc].s[15]:=('3131150" "');PAINTCODE[Nptc].s[16]:=('3431140\/');PAINTCODE[Nptc].s[17]:=('3631150"');PAINTCODE[Nptc].s[18]:=('1932150      ');
PAINTCODE[Nptc].s[19]:=('0633150     to change  its size     ');

          Nptc:=25;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')CaqTJ)CdqTN)C^)C\');PAINTCODE[Nptc].pc[3]:=(')CaqTJ)CdqTN)C^)C\');
PAINTCODE[Nptc].pc[4]:=(')CaqTJ)CdqTN)C^)C\');PAINTCODE[Nptc].pc[5]:=(')C_qTF)C_qTF)ChqTF)C`)C\');PAINTCODE[Nptc].pc[6]:=(')C_qTF)C_qTF)ChqTF)C`)C\');
PAINTCODE[Nptc].pc[7]:=(')C_qTF)C_qTF)ChqTF)C`)C\');PAINTCODE[Nptc].pc[8]:=(')C_qTN)CfqTF)Cb)C\');PAINTCODE[Nptc].pc[9]:=(')C_qTN)C]hF)C`qTF)Cb)C\');
PAINTCODE[Nptc].pc[10]:=(')C_qTN)CfqTF)Cb)C\');PAINTCODE[Nptc].pc[11]:=(')C_qTF)C_qTF)CdqTF)Cd)C\');PAINTCODE[Nptc].pc[12]:=(')C_qTF)C_qTF)CdqTF)Cd)C\');
PAINTCODE[Nptc].pc[13]:=(')C_qTF)C_qTF)CdqTF)Cd)C\');PAINTCODE[Nptc].pc[14]:=(')C_qTF)C_qTF)CbqTN)C^)C\');PAINTCODE[Nptc].pc[15]:=(')C_qTF)C_qTF)CbqTN)C^)C\');
PAINTCODE[Nptc].pc[16]:=(')C_qTF)C_qTF)CbqTN)C^)C\');PAINTCODE[Nptc].pc[17]:=(')C)C\');PAINTCODE[Nptc].pc[18]:=(')C)C\');PAINTCODE[Nptc].pc[19]:=(')C)C\');
PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C]ouv)Cd)C\');PAINTCODE[Nptc].pc[23]:=(')C)C\');
PAINTCODE[Nptc].pc[24]:=(')Ci‰Cr)C\)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')Ci‰Cq)C])C\');PAINTCODE[Nptc].pc[27]:=(')C)C\');
PAINTCODE[Nptc].pc[28]:=(')Ci‰Ci)Ce)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C)C\');PAINTCODE[Nptc].pc[31]:=(')C]ouw)Cc)C\');
PAINTCODE[Nptc].pc[32]:=(')C)C\');PAINTCODE[Nptc].pc[33]:=(')Cj‰Cq)C\)C\');PAINTCODE[Nptc].pc[34]:=(')C)C\');PAINTCODE[Nptc].pc[35]:=(')C)C\');
PAINTCODE[Nptc].pc[36]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0322110FIRST STEP: Select the area');PAINTCODE[Nptc].s[2]:=('1524150Thanks  to a  rectangle');
PAINTCODE[Nptc].s[3]:=('1526150function,  choose  the');PAINTCODE[Nptc].s[4]:=('1528150place to write');
PAINTCODE[Nptc].s[5]:=('0331110SECOND STEP: Write the title');PAINTCODE[Nptc].s[6]:=('1633150type the text you want');

          Nptc:=26;
          PAINTCODE[Nptc].pc[1]:=(')C)C\');PAINTCODE[Nptc].pc[2]:=(')Cjp.–)Ci)C\');PAINTCODE[Nptc].pc[3]:=(')Cgp.‘)Cbp.‘)Cf)C\');
PAINTCODE[Nptc].pc[4]:=(')Cep.)Chp.)Cd)C\');PAINTCODE[Nptc].pc[5]:=(')Cdp.)Clp.)Cc)C\');PAINTCODE[Nptc].pc[6]:=(')Ccp.)Cnp.)Cb)C\');
PAINTCODE[Nptc].pc[7]:=(')Ccp.Ž)Cpp.Ž)Cb)C\');PAINTCODE[Nptc].pc[8]:=(')Cbp.)Cpp.)Ca)C\');PAINTCODE[Nptc].pc[9]:=(')Cbp.Ž)Crp.Ž)Ca)C\');
PAINTCODE[Nptc].pc[10]:=(')Cbp.Ž)Crp.Ž)Ca)C\');PAINTCODE[Nptc].pc[11]:=(')Cbp.Ž)Crp.Ž)Ca)C\');PAINTCODE[Nptc].pc[12]:=(')Cbp.)Cpp.)Ca)C\');
PAINTCODE[Nptc].pc[13]:=(')Ccp.Ž)Cpp.Ž)Cb)C\');PAINTCODE[Nptc].pc[14]:=(')Ccp.)Cnp.)Cb)C\');PAINTCODE[Nptc].pc[15]:=(')Cdp.)Clp.)Cc)C\');
PAINTCODE[Nptc].pc[16]:=(')Cep.)Chp.)Cd)C\');PAINTCODE[Nptc].pc[17]:=(')Cgp.‘)Cbp.‘)Cf)C\');PAINTCODE[Nptc].pc[18]:=(')Cjp.–)Ci)C\');
PAINTCODE[Nptc].pc[19]:=(')C)C\');PAINTCODE[Nptc].pc[20]:=(')C)C\');PAINTCODE[Nptc].pc[21]:=(')C)C\');PAINTCODE[Nptc].pc[22]:=(')C)C\');
PAINTCODE[Nptc].pc[23]:=(')C)C\');PAINTCODE[Nptc].pc[24]:=(')C]‰C`‚Ž\‰Cm‚Ž\‰Cf)C\');PAINTCODE[Nptc].pc[25]:=(')C)C\');PAINTCODE[Nptc].pc[26]:=(')Ci‰Cf)Ch)C\');
PAINTCODE[Nptc].pc[27]:=(')C)C\');PAINTCODE[Nptc].pc[28]:=(')C)C\');PAINTCODE[Nptc].pc[29]:=(')C)C\');PAINTCODE[Nptc].pc[30]:=(')C`‰C`‚Ž\‰Cb‚Ž\‰Ck)C^)C\');
PAINTCODE[Nptc].pc[31]:=(')C)C\');PAINTCODE[Nptc].pc[32]:=(')Cc‰Cs)Ca)C\');PAINTCODE[Nptc].pc[33]:=(')C)C\');PAINTCODE[Nptc].pc[34]:=(')C]‰C~)C\)C\');
PAINTCODE[Nptc].pc[35]:=(')C)C\');PAINTCODE[Nptc].pc[36]:=(')C)C\');PAINTCODE[Nptc].pc[37]:=(')C)C\');
PAINTCODE[Nptc].s[1]:=('0324150Use "');PAINTCODE[Nptc].s[2]:=('0824140+');PAINTCODE[Nptc].s[3]:=('0924150" to enlarge and "');
PAINTCODE[Nptc].s[4]:=('2724140-');PAINTCODE[Nptc].s[5]:=('2824150" to reduce');PAINTCODE[Nptc].s[6]:=('1526150 the circle');
PAINTCODE[Nptc].s[7]:=('0630150Use "');PAINTCODE[Nptc].s[8]:=('1130140<');PAINTCODE[Nptc].s[9]:=('1230150" and "');PAINTCODE[Nptc].s[10]:=('1930140>');
PAINTCODE[Nptc].s[11]:=('2030150"  to change the');PAINTCODE[Nptc].s[12]:=('0932150eccentricity coefficient');
PAINTCODE[Nptc].s[13]:=('0334150remember: k= 1.00 -> perfect circle');

          Nptc:=27;
          PAINTCODE[Nptc].pc[1]:=('0H¥0H\');PAINTCODE[Nptc].pc[2]:=('0H¥0H\');PAINTCODE[Nptc].pc[3]:=('0H¥0H\');PAINTCODE[Nptc].pc[4]:=('0H¥0H\');
PAINTCODE[Nptc].pc[5]:=('0HfcJH0H^cJH0H^cJD0H_cJD0H^cJH0H^cJD0H^cJD0HbcJH0H`0H\');
PAINTCODE[Nptc].pc[6]:=('0Hfe?a0H^e?a0H^e?]0H_e?]0H^e?a0H^e?]0H^e?]0Hbe?a0H`0H\');
PAINTCODE[Nptc].pc[7]:=('0Hfe>v0Hbe>v0H]e>v0H^e>w0H]e>w0H^e>v0H]e>v0H^e>v0H^e>v0Hbe>v0Hd0H\');
PAINTCODE[Nptc].pc[8]:=('0Hfe=0Hbe=0H]e=0H^e=0H]e=0H^e=0H]e=0H^e=0H^e=0Hbe=0Hd0H\');
PAINTCODE[Nptc].pc[9]:=('0Hfe=0Hbe=0H]e=0H^e=0H\e=0H\e=0H^e=“0H^e=0H^e=0Hbe=“0H`0H\');
PAINTCODE[Nptc].pc[10]:=('0Hfv`0Hbv`0H]v`0H^v`0H\v`0H\v`0H^v`“0H^v`0H^v`0Hbv`“0H`0H\');
PAINTCODE[Nptc].pc[11]:=('0Hfvav0Hbvav0H]vav0H^vav0H_vav0H^vav0Hbvav0H^vav0Hbvav0Hd0H\');
PAINTCODE[Nptc].pc[12]:=('0Hfvb]0Hbvb]0H]vb]0H^vb]0H_vb]0H^vb]0Hbvb]0H^vb]0Hbvb]0Hd0H\');
PAINTCODE[Nptc].pc[13]:=('0HfxYH0H^xYH0H^xYD0H_xYD0H^xYD0HbxYD0H^xYH0H^xYH0H`0H\');
PAINTCODE[Nptc].pc[14]:=('0HfxYH0H^xYH0H^xYD0H_xYD0H^xYD0HbxYD0H^xYH0H^xYH0H`0H\');PAINTCODE[Nptc].pc[15]:=('0H¥0H\');PAINTCODE[Nptc].pc[16]:=('0H¥0H\');
PAINTCODE[Nptc].pc[17]:=('0Hb‰ˆC‰j‰ƒ\0H\');PAINTCODE[Nptc].pc[18]:=('0Hb‰‰*0Hœ‰‰*0H\');PAINTCODE[Nptc].pc[19]:=('0Hb‰‰*0Hf‰“…0Hg‰‰*0H\');
PAINTCODE[Nptc].pc[20]:=('0Hb‰‰*0Hœ‰‰*0H\');PAINTCODE[Nptc].pc[21]:=('0Hb‰‰*0H\‰“~ƒab‰“o0H]‰‰*0H\');PAINTCODE[Nptc].pc[22]:=('0Hb‰‰*0Hœ‰‰*0H\');
PAINTCODE[Nptc].pc[23]:=('0Hb‰‰*0H\‰“dƒaf‰“†0H\‰‰*0H\');PAINTCODE[Nptc].pc[24]:=('0Hb‰‰*0Hœ‰‰*0H\');PAINTCODE[Nptc].pc[25]:=('0Hb‰„C‰j‰‡\0H\');
PAINTCODE[Nptc].pc[26]:=('0H¥0H\');PAINTCODE[Nptc].pc[27]:=('0H¥0H\');PAINTCODE[Nptc].pc[28]:=('0H¥0H\');PAINTCODE[Nptc].pc[29]:=('0HsZf|0Hl0H\');
PAINTCODE[Nptc].pc[30]:=('0HsZf\gMzZf\0Hl0H\');PAINTCODE[Nptc].pc[31]:=('0HsZf|0Hl0H\');PAINTCODE[Nptc].pc[32]:=('0H¥0H\');PAINTCODE[Nptc].pc[33]:=('0H¥0H\');
PAINTCODE[Nptc].pc[34]:=('0H¥0H\');PAINTCODE[Nptc].pc[35]:=('0H¥0H\');PAINTCODE[Nptc].pc[36]:=('0HqcJE0Ha‰“x0Hi0H\');PAINTCODE[Nptc].pc[37]:=('0HpcJF0HŒ0H\');
PAINTCODE[Nptc].pc[38]:=('0HrcJD0Ha‰“x0Hi0H\');PAINTCODE[Nptc].pc[39]:=('0HrcJD0HŒ0H\');PAINTCODE[Nptc].pc[40]:=('0HpcJH0H_‰“x0Hi0H\');
PAINTCODE[Nptc].pc[41]:=('0H¥0H\');PAINTCODE[Nptc].pc[42]:=('0H¥0H\');PAINTCODE[Nptc].pc[43]:=('0H¥0H\');PAINTCODE[Nptc].pc[44]:=('0H¥0H\');
PAINTCODE[Nptc].pc[45]:=('0H¥0H\');PAINTCODE[Nptc].pc[46]:=('0HpcJG0H`‰“x0Hi0H\');PAINTCODE[Nptc].pc[47]:=('0HscJE0HŠ0H\');
PAINTCODE[Nptc].pc[48]:=('0HrcJE0H`‰“x0Hi0H\');PAINTCODE[Nptc].pc[49]:=('0HqcJD0H0H\');PAINTCODE[Nptc].pc[50]:=('0HpcJH0H_‰“gƒaf0Ho0H\');
PAINTCODE[Nptc].pc[51]:=('0H¥0H\');PAINTCODE[Nptc].pc[52]:=('0H¥0H\');
PAINTCODE[Nptc].s[1]:=('2019151This is the second part of the application');PAINTCODE[Nptc].s[2]:=('1021151with this function you can finally ');
PAINTCODE[Nptc].s[3]:=('4521141convert');PAINTCODE[Nptc].s[4]:=('5221151 your drawing into a');PAINTCODE[Nptc].s[5]:=('1023151suitable ');
PAINTCODE[Nptc].s[6]:=('1923141source code');PAINTCODE[Nptc].s[7]:=('3023151 saved as a .txt file in the program folder');
PAINTCODE[Nptc].s[8]:=('2630097WHAT YOU CAN DO WITH THIS CODE:');PAINTCODE[Nptc].s[9]:=('3236151You  can  copy  its data  and');
PAINTCODE[Nptc].s[10]:=('3238151functions, then paste them on');PAINTCODE[Nptc].s[11]:=('3240151your  developing  application');
PAINTCODE[Nptc].s[12]:=('3246151You can reload the drowing in');PAINTCODE[Nptc].s[13]:=('3248151this application  by renaming');
PAINTCODE[Nptc].s[14]:=('3250151the file as ');PAINTCODE[Nptc].s[15]:=('4450141"input.ptc"');
          end;

begin
inizializzazioneDati;
inizializzazionePTC;

randomize();
cursoroff;
clrscr;
textbackground(3);
clrscr;
textcolor(15);write('PUT FULL SCREEN');
delay(1900);
clrscr;

introduzione;

creaProgetto;


clrscr;
textbackground(sfondo);
clrscr;



text:=car[1,1];
ground:=5;
color:=9;

CasoInizio:
HideShow;

repeat
repeat
ss:=cursore(x,y,0,'t');
until(ss='t');
casoInputTools:
inputTools;
until(strumento=13);

inputDimensione;
Compila;

end.
