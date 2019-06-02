!define APPNAME "iNZightVIT"
!define COMPANY "The University of Auckland"
# define version from env vars/magical stuff
!define VERSION "3.4.0"

# apparently this should be specified for all installers
RequestExecutionLevel user

# define installation directory, icon, etc.
InstallDir $DOCUMENTS\${APPNAME}
Name "${APPNAME} ${VERSION}"
# Icon "icon.ico"
OutFile ${APPNAME}-installer.exe"

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
 
SectionEnd
