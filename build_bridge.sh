
#   export KBMON_DEV_PREFIX="/tmp/qt6:/tmp/wld:/tmp/xkb"
set -e

QT_INCLUDE=$(find /usr/include /tmp/qt6/usr/include 2>/dev/null \
    -path '*/qt6/QtGui/qguiapplication.h' -printf '%h\n' | head -1)
QT_LIB=$(find /usr/lib /tmp/qt6/usr/lib 2>/dev/null \
    -name 'libQt6Core.so' -printf '%h\n' | head -1)

if [ -z "$QT_INCLUDE" ] || [ -z "$QT_LIB" ]; then
    echo "error"
    echo "  include: $QT_INCLUDE"
    echo "  lib: $QT_LIB"
    exit 1
fi
echo "Qt6 include: $QT_INCLUDE"
echo "Qt6 lib: $QT_LIB"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

g++ -shared -fPIC \
    -I${QT_INCLUDE}/.. \
    -I${QT_INCLUDE} \
    -I${QT_INCLUDE%/QtGui} \
    -L"$QT_LIB" \
    -o "$SCRIPT_DIR/libqt-wl-bridge.so" \
    "$SCRIPT_DIR/qt_wl_bridge.cpp" \
    -lQt6Core -lQt6Gui \
    -Wl,-rpath,'$ORIGIN' \
    -Wl,--disable-new-dtags

echo "✓ $(ls -la $SCRIPT_DIR/libqt-wl-bridge.so)"

nm -D "$SCRIPT_DIR/libqt-wl-bridge.so" | grep 'qt_wl_'
