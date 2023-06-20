Unicode true
!define APPNAME "iNZightVIT"
!define COMPANY "The University of Auckland"
# define version from env vars (otherwise it's a dev version)
!define VERSION "0.0.0.9000"
!if "$%INSTALLER_VERSION%" != "${U+24}%INSTALLER_VERSION%"
!define /redef VERSION "$%INSTALLER_VERSION%"
!endif

# apparently this should be specified for all installers
RequestExecutionLevel user

# define installation directory, icon, etc.
InstallDir $DOCUMENTS\${APPNAME}
Name "${APPNAME} ${VERSION}"
Icon "inst/icon.ico"
outFile "${APPNAME}-installer.exe"

# additional meta information about the program
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
VIProductVersion "${VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${APPNAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "GPL-2"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "An easy to use data visualisation tool."
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"


# request directory location (default is My Documents)
page directory

page instfiles

Section "install"
    setOutPath $INSTDIR

    # add R
    File /r "R"
    File /r "library"
    File /r ".inzight"
    File /r ".vit"
    File /r ".update"
    File /r "inst"
    File "launcher.R"

    CreateDirectory $INSTDIR\.cache
    CreateDirectory $INSTDIR\.config
    CreateDirectory $INSTDIR\data
    CreateDirectory $INSTDIR\modules

    # Make things hidden:
    SetFileAttributes R HIDDEN
    SetFileAttributes .inzight HIDDEN
    SetFileAttributes .vit HIDDEN
    SetFileAttributes .update HIDDEN
    SetFileAttributes .library HIDDEN
    SetFileAttributes inst HIDDEN
    SetFileAttributes .cache HIDDEN
    SetFileAttributes .config HIDDEN
    SetFileAttributes launcher.R HIDDEN


    # include uninstaller
    writeUninstaller "$INSTDIR\Uninstall.exe"

    # create the shortcuts to run stuff
    setOutPath $INSTDIR\.inzight
    createShortcut "$INSTDIR\iNZight.lnk" "$INSTDIR\R\bin\x64\Rgui.exe" "--quiet --no-save --no-restore" "$INSTDIR\inst\icon.ico" "" SW_SHOWMINIMIZED
    createShortcut "$DESKTOP\iNZight.lnk" "$INSTDIR\R\bin\x64\Rgui.exe" "--quiet --no-save --no-restore" "$INSTDIR\inst\icon.ico" "" SW_SHOWMINIMIZED

    setOutPath $INSTDIR\.vit
    createShortcut "$INSTDIR\VIT.lnk" "$INSTDIR\R\bin\x64\Rgui.exe" "--quiet --no-save --no-restore" "$INSTDIR\inst\icon.ico" "" SW_SHOWMINIMIZED
    createShortcut "$DESKTOP\VIT.lnk" "$INSTDIR\R\bin\x64\Rgui.exe" "--quiet --no-save --no-restore" "$INSTDIR\inst\icon.ico" "" SW_SHOWMINIMIZED

    setOutPath $INSTDIR\.update
    createShortcut "$INSTDIR\Update.lnk" "$INSTDIR\R\bin\x64\Rgui.exe" "--quiet --no-save --no-restore" "$INSTDIR\inst\icon.ico" "" SW_SHOWNORMAL


SectionEnd


## Define the uninstaller
function un.onInit
    MessageBox MB_OKCANCEL "Permanently remove ${APPNAME}?" IDOK next
        Abort
    next:
functionEnd

Section "uninstall"
    # remove files
    RMdir /r $INSTDIR\R
    RMdir /r $INSTDIR\library
    RMDIR /r $INSTDIR\.inzight
    RMDIR /r $INSTDIR\.vit
    RMDIR /r $INSTDIR\.update
    RMDIR /r $INSTDIR\inst
    RMDIR /r $INSTDIR\.config
    RMDIR /r $INSTDIR\.cache
    delete $INSTDIR\launcher.R

    # remove desktop shortcuts
    delete $DESKTOP\iNZight.lnk
    delete $DESKTOP\VIT.lnk

    # remove shortcuts
    delete $INSTDIR\iNZight.lnk
    delete $INSTDIR\VIT.lnk
    delete $INSTDIR\Update.lnk

    # remove uninstaller
    delete $INSTDIR\Uninstall.exe

    # remove directory
    RMDir $INSTDIR

    # and finished
    MessageBox MB_OK "iNZightVIT has been uninstalled."
SectionEnd
