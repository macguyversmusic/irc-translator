program irctranslate;

uses
  Forms,
  irc_translator in 'irc_translator.pas' {Form1},
  Token in 'Token.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
