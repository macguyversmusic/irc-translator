unit irc_translator;
//based on zomkbot source from opensc.ws

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, ScktComp, token,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdURI,
  strutils;

type
  TForm1 = class(TForm)
    cs: TClientSocket;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Main1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    Edit1: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    function getxml(const Tag, Text: string): string;
    procedure csError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure translate(txtext, fromlang, tolang: String);
    procedure DelSubStr(substr: string; var strn: string);

  private
    { Private-Deklarationen }
  public
    Procedure AddLog(logstring: String);
    Function timestamp: String;
    Procedure ircparse(data: String);
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  translatedtxt, chan: string;
  serveron: Integer;
  servercon: string;
  srvr1, srvr2, srvr3, srvr4, srvr5, connectsrvr, nick: string;

Function TForm1.timestamp;
Begin
  timestamp := TimeToStr(now);
end;

procedure TForm1.AddLog(logstring: String);
Begin
  Memo1.Lines.Add(logstring);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  nick := 'SYC_transla1'; // must be 12 or less chars
  srvr1 := 'newyork.ny.us.undernet.org';
  srvr2 := 'Diemen.NL.EU.Undernet.Org';
  srvr3 := 'Lidingo.SE.EU.Undernet.org';
  srvr4 := 'Budapest.HU.EU.UnderNet.org';
  srvr5 := 'bucharest.ro.eu.undernet.org';
  AddLog('zonk*Bot started...');
  serveron := 0;
  Start1.Click;

end;

procedure TForm1.csError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  AddLog('Something wrong?');
  ErrorCode := 0;
  serveron := serveron + 1;
  Start1.Click;
end;

procedure TForm1.csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Disconnected from server');
  Start1.Click;

end;

procedure TForm1.translate(txtext, fromlang, tolang: String);

var
  test:string;
  https: TIdHTTP;
  URL: string;
begin
  https := TIdHTTP.Create(nil);
  URL := TIdURI.URLEncode('http://api.microsofttranslator.com/v2/Http.svc/' +
    'Translate?appId=FADB439F07A7D1C5CE96558491E863CA3E1B854E' + '&text=' +
    txtext + '&from=' + fromlang + '&to=' + tolang);
  try
    https.HTTPOptions := [hoForceEncodeParams];
    https.Request.ContentType := 'application/x-www-form-urlencoded';
    translatedtxt := getxml('string', https.get(URL));
    test:=translatedtxt;
  finally
    https.Free;
  end;
end; // FADB439F07A7D1C5CE96558491E863CA3E1B854E

function TForm1.getxml(const Tag, Text: string): string;
var
  StartPos1, StartPos2, EndPos: Integer;
  i: Integer;
begin
  result := '';
  StartPos1 := Pos('<' + Tag, Text);
  EndPos := Pos('</' + Tag + '>', Text);
  StartPos2 := 0;
  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      StartPos2 := i + 1;
      break;
    end;

  if (StartPos2 > 0) and (EndPos > StartPos2) then
    result := Copy(Text, StartPos2, EndPos - StartPos2);
end;

procedure TForm1.csConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Connected...');
  Socket.SendText('USER abb blub bla blub' + #10);
  Socket.SendText('NICK ' + nick + #10);

end;

Procedure TForm1.ircparse(data: String);
var
  content: String;
  tmp, tmp2, tmp3, tmp4, tmp5,tmp6,tmp7, somenick: String;
  index: Integer;
Begin
  lowercase(data);
  // AddLog(data);
  if data[1] = ':' then // servermeldungen, msgs usw.
  Begin
    tmp := GetFirstToken(data);
    tmp2 := GetNextToken;
    tmp3 := GetremainingTokens;
     tmp3 := GetNextToken;
    tmp4 := GetRemainingTokens;
    delete(tmp, 1, 1);
    index := Pos('!', tmp);
    if Index > 0 then
    begin
    end;
  end

  else // steuercommands wie ping
  Begin
    if lowercase(GetFirstToken(data)) = 'ping' then
    begin
      // AddLog('*** PING PONG');
      content := GetRemainingTokens;
      cs.Socket.SendText('PONG ' + content + #10#13);

    end;
  end;


  if ansicontainsstr(data, 'PRIVMSG #') then
  begin
    delete(tmp, 1, 1);
    if Index > 0 then
      delete(tmp4, 1, 1);
    translate(trim(tmp4), 'ro', 'en');
    Memo1.Lines.Add(trim(translatedtxt));

  end;

  if ansicontainsstr(data, ':on') then
  begin
    AddLog('ready to go');
    // cs.Socket.SendText('JOIN #fbnbt' + #10#13);
    // cs.Socket.SendText('JOIN #suckme' + #10#13);
  end;

  if tmp2 = 'PART' then
  begin
    AddLog(tmp + ' left the channel');
  end;
  if tmp2 = 'JOIN' then
  begin
    AddLog(tmp + ' joined the channel');
  end;
  if tmp2 = 'QUIT' then
  begin
    AddLog(tmp + ' quit the server');
  end;
  if ansicontainsstr(tmp4, 'ACTION') then
  begin
    AddLog(tmp5);
  end;
  if ansicontainsstr(data, nick) then
    if tmp2 = 'JOIN' then
    begin
      chan := tmp3;
    end;

end;

procedure TForm1.DelSubStr(substr: string; var strn: string);
var
  k, L, origL: Integer;
  remaining: string;
begin
  k := Pos(substr, strn);
  if (k <> 0) then
  begin
    L := length(substr);
    origL := length(strn);
    remaining := Copy(strn, k + L, length(strn) - k - L);
    delete(strn, k, L);
  end;
end;

procedure TForm1.csRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s, temp: String;
  i: Integer;
begin
  s := Socket.ReceiveText;
  Memo1.Lines.Add(s);
  while (Pos(#10, s) <> 0) do // in einzelne zeilen zerlegen
  Begin
    temp := Copy(s, 1, Pos(#10, s) - 1);
    delete(s, 1, Pos(#10, s)); // "ausgeschnittene" zeile l?schen
    ircparse(temp); // zeilen uebergeben zum parsen
    // AddLog(temp);
  end;
end;

procedure TForm1.Start1Click(Sender: TObject);
begin
  serveron := serveron + 1;
  if serveron = 6 then
    serveron := 1;
  if serveron = 1 then
    servercon := srvr1;
  if serveron = 2 then
    servercon := srvr2;
  if serveron = 3 then
    servercon := srvr3;
  if serveron = 4 then
    servercon := srvr4;
  if serveron = 5 then
    servercon := srvr5;
  Memo1.Lines.Add('Trying ' + servercon);
  cs.Host := servercon;
  cs.Port := 6667;
  cs.Active := true;
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  cs.Socket.SendText('QUIT blub');
  if cs.Active = true then
    cs.Active := false;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: String;
begin
  s := Edit1.Text;
  if Key = VK_RETURN then
  Begin
    if s[1] = '#' then
    Begin
      delete(s, 1, 1);

      cs.Socket.SendText(s + #10); // raw senden
      // aliase hier... evtl aus konfig datei laden?
    end
    else
    Begin
      translate(s, 'en', 'ro');
      // memo1.Lines.Add(translatedtxt);
      cs.Socket.SendText('privmsg #hackinganonymous :' + translatedtxt + #10);
      Memo1.Lines.Add(translatedtxt);
      // raw senden
    end;
    Edit1.Text := '';
  end;
end;

end.
