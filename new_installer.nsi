Unicode true
!include "MUI.nsh"
!define MUI_ICON "inst/icon.ico"
!define MUI_UNICON "inst/icon.ico"

!define APPNAME "iNZight"
!define COMPANY "The University of Auckland"

# define version from env vars (otherwise it's a dev version)
!define APPVERSION "0.0.0.9000"
!if "$%INSTALLER_VERSION%" != "${U+24}%INSTALLER_VERSION%"
!define /redef APPVERSION "$%INSTALLER_VERSION%"
!endif

# apparently this should be specified for all installers
RequestExecutionLevel user

# define installation directory, icon, etc.
InstallDir $DOCUMENTS\iNZightVIT
Name "${APPNAME} ${APPVERSION}"
Icon "inst/icon.ico"
outFile "${APPNAME}-${APPVERSION}-installer.exe"
InstallDirRegKey HKCU "Software\iNZight" ""

# additional meta information about the program
VIProductVersion "${APPVERSION}.0"
VIAddVersionKey "ProductName" "${APPNAME}"
VIAddVersionKey "ProductVersion" "${APPVERSION}"
VIAddVersionKey "CompanyName" "${COMPANY}"
VIAddVersionKey "FileDescription" "An easy to use data visualization tool."
VIAddVersionKey "FileVersion" "${APPVERSION}"

Var StartMenuFolder

!define MUI_ABORTWARNING

;Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
;Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\iNZight"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;Languages
!insertmacro MUI_LANGUAGE "English"

;Installer Sections
Section "Install" SecInstall
  SetOutPath $INSTDIR

    ; File /r "R"
    ; File /r "library"
    File /r ".inzight"
    File /r ".vit"
    File /r ".update"
    File /r "inst"
    File "launcher.R"

    ;Store installation folder
    WriteRegStr HKCU "Software\iNZight" "" $INSTDIR

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

        ;Create shortcuts
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

    !insertmacro MUI_STARTMENU_WRITE_END


;   CreateDirectory "$SMPROGRAMS\${COMPANY}\${APPNAME}"
;   CreateShortCut "$SMPROGRAMS\${COMPANY}\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\${APPNAME}.exe"
;   CreateShortCut "$SMPROGRAMS\${COMPANY}\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
;   WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

;Descriptions
    LangString DESC_SecInsatll ${LANG_ENGLISH} "Installs ${APPNAME} ${APPVERSION} to your computer."
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
    !insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstaller Section

Section "Uninstall"

    ;ADD YOUR OWN FILES HERE...

    RMDIR /r $INSTDIR\.inzight
    RMDIR /r $INSTDIR\.vit
    RMDIR /r $INSTDIR\.update
    RMDIR /r $INSTDIR\inst
    Delete "$INSTDIR\launcher.R"
    Delete "$INSTDIR\Uninstall.exe"

    RMDir "$INSTDIR"

    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

    Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
    RMDir "$SMPROGRAMS\$StartMenuFolder"

DeleteRegKey /ifempty HKCU "Software\iNZight"

SectionEnd
