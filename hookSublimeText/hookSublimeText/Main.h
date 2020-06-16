//
//  Main.h
//  hookSublimeText
//
//  Created by lovecode666 on 2020/6/11.
//  Copyright © 2020 mll<coleflowersma#gmail.com> All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface PXWindowDelegate : NSObject

- (void)windowWillEnterFullScreen:(id)arg1;
- (void)windowWillExitFullScreen:(id)arg1;
- (BOOL)acceptsFirstResponder;
- (void)windowDidChangeBackingProperties:(id)arg1;
- (void)commandLine:(id)arg1;

@end

@interface PXWindow : NSWindow

- (void)update;

@end

@interface PXApplication : NSApplication

- (void)terminate:(id)arg1;

@end

@interface PXView : NSView

- (void)paste:(id)arg1;

@end

@interface HttpConnectionDelegate : NSObject
- (void)connection:(id)arg1 didReceiveData:(id)arg2;
- (void)connection:(id)arg1 didReceiveResponse:(id)arg2;
@end
