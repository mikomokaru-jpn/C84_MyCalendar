//------------------------------------------------------------------------------
//  AppDelegate.m
//------------------------------------------------------------------------------
#import "AppDelegate.h"
@interface AppDelegate ()

@property UAView *uaView;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _uaView = [[UAView alloc] initWithPoint:NSMakePoint(30, 30)];
    [[_window contentView] addSubview:_uaView];
}
// WindowDelegate ********************************************************
//Docのアイコンをクリックしたらウィンドウを再表示する
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)flag {
    if (!flag){
        for (NSWindow *openWindow in sender.windows) {
            if (openWindow == _window){
                [openWindow makeKeyAndOrderFront:self];
            }
        }
    }
    return YES;
}
@end
