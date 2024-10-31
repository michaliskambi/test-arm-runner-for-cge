{ Simple "menu" user interface, that allows to run the game or quit.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMenu;

interface

uses Classes,
  CastleComponentSerialize, CastleUIControls, CastleControls;

type
  { Simple "menu" user interface, that allows to run the game or quit. }
  TViewMenu = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    ButtonPlay, ButtonQuit: TCastleButton;
    LabelSystemInfo: TCastleLabel;
  private
    procedure ClickPlay(Sender: TObject);
    procedure ClickQuit(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
  end;

var
  ViewMenu: TViewMenu;

implementation

uses SysUtils, Process,
  CastleApplicationProperties, CastleWindow, CastleFilesUtils, CastleUtils,
  GameViewPlay;

{ TViewMenu ----------------------------------------------------------------- }

constructor TViewMenu.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmenu.castle-user-interface';
end;

procedure TViewMenu.Start;

  { Run given ExeName (like 'uname' -- we will search it on $PATH automatically)
    with given Parameters (like ['-a']).
    Returns output as String.

    In case of any failure (exception, program exit status non-zero) put it
    in the output string too -- so this is nice to display to user,
    we don't need to return exception/error status to Pascal caller in this case. }
  function RunCommandCaptureOutput(const ExeName: String;
    const Parameters: array of String): String;
  var
    ExeFull: String;
    ExitStatus: Integer;
  begin
    ExeFull := FindExe(ExeName);
    if ExeFull = '' then
      Exit(ExeName + ' not found on $PATH');

    if RunCommandIndir(GetCurrentDir, ExeFull, Parameters, Result, ExitStatus, []) <> 0 then
      Exit('Failed running ' + ExeName);

    if ExitStatus <> 0 then
      Result := Result + NL +
        'WARNING: exit status non-zero: ' + IntToStr(ExitStatus);
  end;

begin
  inherited;
  ButtonPlay.OnClick := {$ifdef FPC}@{$endif} ClickPlay;
  ButtonQuit.OnClick := {$ifdef FPC}@{$endif} ClickQuit;
  // Hide "Quit" button on mobile/console platforms, where users don't expect such button
  ButtonQuit.Exists := ApplicationProperties.ShowUserInterfaceToQuit;

  LabelSystemInfo.Caption := Format('System Information:' + NL +
    'OS: %s' + NL +
    'CPU: %s' + NL +
    'Kernel: %s' + NL +
    'Linux Distro: %s', [
      {$I %FPCTARGETOS%},
      {$I %FPCTARGETCPU%},
      RunCommandCaptureOutput('uname', ['-a']),
      RunCommandCaptureOutput('lsb_release', ['-a'])
    ]);
end;

procedure TViewMenu.ClickPlay(Sender: TObject);
begin
  Container.View := ViewPlay;
end;

procedure TViewMenu.ClickQuit(Sender: TObject);
begin
  Application.Terminate;
end;

end.
