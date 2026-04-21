; Inno Setup script for Sapi Windows installer
; Build with:
;   iscc /DAppVersion=1.2.3 /DSourceExe="C:\path\to\sapi.exe" /DOutputDir="C:\out" /DOutputBaseFilename="sapi-setup-1.2.3" sapi-installer.iss

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

#ifndef SourceExe
  #define SourceExe "sapi.exe"
#endif

#ifndef OutputDir
  #define OutputDir "."
#endif

#ifndef OutputBaseFilename
  #define OutputBaseFilename "sapi-setup"
#endif

#define AppName "Sapi"
#define AppPublisher "dSlyders"
#define AppExeName "sapi.exe"

[Setup]
AppId={{D96E70D4-56D9-4E0F-9B0A-28B9C9D35E8C}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={localappdata}\Sapi\bin
DisableDirPage=yes
ArchitecturesInstallIn64BitMode=x64
OutputDir={#OutputDir}
OutputBaseFilename={#OutputBaseFilename}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ChangesEnvironment=yes
PrivilegesRequired=lowest
UninstallDisplayIcon={app}\{#AppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#SourceExe}"; DestDir: "{app}"; DestName: "{#AppExeName}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\Sapi CLI"; Filename: "{app}\{#AppExeName}"

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Check: NeedsAddPath(ExpandConstant('{app}'))

[Code]
function NeedsAddPath(Param: string): boolean;
var
  Paths: string;
begin
  if RegQueryStringValue(HKCU, 'Environment', 'Path', Paths) then
  begin
    Result := Pos(';' + Uppercase(Param) + ';', ';' + Uppercase(Paths) + ';') = 0;
  end
  else
  begin
    Result := True;
  end;
end;
