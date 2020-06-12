//
//  Main.m
//  hookSublimeText
//
//  Created by lovecode666 on 2020/6/11.
//  Copyright © 2020 mll<coleflowersma#gmail.com>. All rights reserved.
//
#import <objc/runtime.h>
#import "Main.h"
#import "hookSublimeText.h"

@implementation NSObject (SublimeText)

// - PXWindowDelegate

- (void)m_st_windowWillExitFullScreen:(id)arg1 {
    NSLog(@"SublimeText m_st_windowWillExitFullScreen");
    [self m_st_windowWillExitFullScreen:arg1];
    [self m_hidden_registerMarkView];
}

- (void)m_st_windowWillEnterFullScreen:(id)arg1 {
    NSLog(@"SublimeText m_st_windowWillEnterFullScreen");
    [self m_st_windowWillEnterFullScreen:arg1];
    [self m_hidden_registerMarkView];
}

- (void)m_st_commandLine:(id)arg1 {
    NSLog(@"SublimeText m_st_commandLine");
    [self m_st_commandLine:arg1];
    [self m_hidden_registerMarkView];
}

// - PXWindow
- (void)m_st_update {
    NSLog(@"SublimeText m_st_update");
    [self m_st_update];
    [self m_hidden_registerMarkView];
}

- (void)m_hidden_registerMarkView {
    NSDictionary *mark = [[NSUserDefaults standardUserDefaults] objectForKey:@"removedMark"];
    if (mark) {
        if ([[mark allKeys] containsObject:[self m_set_key]]) {
            __unused NSNumber *num = [mark valueForKey:[self m_set_key]];
            //TODO
            //return;
        }
    }
    
    NSArray *titleBars = [self ns_title_bar_views];
    if (!titleBars) {
        return;
    }
    
    for (id item in titleBars) {
        [self m_hidden_registerMarkView:item];
    }
    
    [self m_set_removeMark];
}

// Sublime Text 里有一个同名的c函数🐶
- (NSArray *)ns_title_bar_views {
    NSMutableArray *bars = @[].mutableCopy;

    NSArray *windows = [[NSApplication sharedApplication] windows];
    
    for (NSWindow *win in windows) {
        id titleBarView = [self ns_title_bar_view:win];
        
        if (!titleBarView) {
            continue;
        }
        
        [bars addObject:titleBarView];
    }
    
    return bars.copy;
}

- (id)ns_title_bar_view:(NSWindow *)win {
    id res = nil;
    NSView *contenView = [win contentView];
    NSArray *views = [[contenView superview] subviews];

    Class titleBarClass = NSClassFromString(@"NSTitlebarContainerView");
    for (id item in views) {
      if ([item isKindOfClass:titleBarClass]) {
          res = item;
          break;

      }
    }

    if (res) {
      NSArray *views = [res subviews];
      for (id item in views) {
          if ([item isKindOfClass:NSClassFromString(@"NSTitlebarView")]) {
              res = item;
              break;
          }
      }
    }

    return res;
}

- (void)m_hidden_registerMarkView:(id)titleBarView {
    NSLog(@"-- hidden --");
    if (!titleBarView) {
        return;
    }
    
    NSArray *views = [titleBarView subviews];

    for (id item in views) {
        if ([item isKindOfClass:NSClassFromString(@"NSTextField")]) {
            NSTextField *txtView = (NSTextField *)item;
            
            if ([txtView.stringValue isEqualToString:@"UNREGISTERED"]) {
                // [txtView removeFromSuperview];
                // [txtView setHidden:YES];
                
                [txtView setFrame:NSMakeRect(0, 0, 0, 0)];
            }
        }
    }
}

- (NSString *)m_set_key {
    NSString *key = [NSString stringWithFormat:@"removed_%ld", [[NSApplication sharedApplication] windows].count];
    return key;
}

- (void)m_set_removeMark {
    NSMutableDictionary *mark = @{}.mutableCopy;
    [mark setValue:@1 forKey:[self m_set_key]];
    
    [[NSUserDefaults standardUserDefaults] setObject:mark forKey:@"removedMark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// - PXApplication
- (void)m_st_terminate:(id)arg1 {
    NSLog(@"SublimeText m_st_terminate");
    [self m_st_terminate:arg1];
}

// - PXView
- (void)m_st_paste:(id)arg1 {
    NSLog(@"SublimeText m_st_paste");
    [self m_st_paste:arg1];
    [self m_hidden_registerMarkView];
}

@end

static void __attribute__((constructor)) initialize(void) {

    NSLog(@"++++++++ hookSublimeText loaded ++++++++");
    
    // 每次 hook 复位
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"removedMark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CBHookInstanceMethod(PXWindowDelegate, @selector(windowWillEnterFullScreen:), @selector(m_st_windowWillEnterFullScreen:));
    CBHookInstanceMethod(PXWindowDelegate, @selector(windowWillExitFullScreen:), @selector(m_st_windowWillExitFullScreen:));
   
    // CBHookInstanceMethod(PXWindowDelegate, @selector(commandLine:), @selector(m_st_commandLine:));
    
    CBHookInstanceMethod(PXWindow, @selector(update), @selector(m_st_update));
    
    CBHookInstanceMethod(PXApplication, @selector(terminate:), @selector(m_st_terminate:));
    
    CBHookInstanceMethod(PXView, @selector(paste:), @selector(m_st_paste:));
}
