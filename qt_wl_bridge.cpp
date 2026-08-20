// qt_wl_bridge.cpp — 从 Qt Wayland 平台插件提取 wl_display*
//
// 编译为 libqt-wl-bridge.so，C# 端 P/Invoke 调用。
// 在 Qt 主程序进程内加载，通过 QNativeInterface::QWaylandApplication
// 拿到 Qt 已有的 wl_display*（和 wl_seat* / wl_keyboard*）。
//
// 这样 kbmon-csharp 不再自己 wl_display_connect，而是复用 Qt 的连接，
// 能收到 Qt 主窗口的键盘焦点事件。

#include <QGuiApplication>
#include <QtGui/qguiapplication_platform.h>

extern "C" {

/// 返回 Qt Wayland 平面插件的 wl_display*。未初始化或非 Wayland 返回 nullptr。
void* qt_wl_get_display() {
    auto app = qobject_cast<QGuiApplication*>(QGuiApplication::instance());
    if (!app) return nullptr;
    auto* wlApp = app->nativeInterface<QNativeInterface::QWaylandApplication>();
    if (!wlApp) return nullptr;
    return wlApp->display();
}

/// 返回 Qt 绑定的 wl_seat*。未初始化或非 Wayland 返回 nullptr。
void* qt_wl_get_seat() {
    auto app = qobject_cast<QGuiApplication*>(QGuiApplication::instance());
    if (!app) return nullptr;
    auto* wlApp = app->nativeInterface<QNativeInterface::QWaylandApplication>();
    if (!wlApp) return nullptr;
    return wlApp->seat();
}

/// 返回 Qt 已绑定的 wl_keyboard*（如果有）。
/// 注意：这个 keyboard 由 Qt 平面插件管理，调用方不应 destroy 它。
void* qt_wl_get_keyboard() {
    auto app = qobject_cast<QGuiApplication*>(QGuiApplication::instance());
    if (!app) return nullptr;
    auto* wlApp = app->nativeInterface<QNativeInterface::QWaylandApplication>();
    if (!wlApp) return nullptr;
    return wlApp->keyboard();
}

/// 返回最后输入 serial（用于 grab 等操作）。
unsigned int qt_wl_get_last_serial() {
    auto app = qobject_cast<QGuiApplication*>(QGuiApplication::instance());
    if (!app) return 0;
    auto* wlApp = app->nativeInterface<QNativeInterface::QWaylandApplication>();
    if (!wlApp) return 0;
    return wlApp->lastInputSerial();
}

} // extern "C"
