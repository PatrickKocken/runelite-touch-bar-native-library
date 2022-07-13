/**
 * JTouchBar
 *
 * Copyright (c) 2018 - 2019 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
#import "JavaTouchBarResponder.h"

#import "JavaTouchBarUtils.h"

@implementation JavaTouchBarResponder

-(void) setTouchBar:(JavaTouchBar *)javaTouchBar window:(NSWindow*)window {
    self.javaTouchBar = javaTouchBar;
    
    // prepare touchbar, handling creation exceptions on the current thread.
    [self makeTouchBar];
    
    if(@available(macOS 10_12_2, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.javaTouchBar == nil) {
                window.nextResponder = self.nextResponder;
            }
            else {
                self.nextResponder = window.nextResponder;
                window.nextResponder = self;
            }
            
            window.touchBar = [self makeTouchBar];
        });
    }
    else {
        // TODO WARN USER/DEVELOPER
    }
}

-(NSTouchBar *) makeTouchBar {
    if(_javaTouchBar == nil) {
        return nil;
    }
    
    _touchBar = [_javaTouchBar createNSTouchBar];
    if(_touchBar == nil) {
        return nil;
    }
    
    _touchBar.delegate = self;
    
    return _touchBar;
}

-(NSTouchBarItem *) touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    return [JavaTouchBarUtils touchBar:touchBar makeItemForIdentifier:identifier usingJavaTouchBar:_javaTouchBar];
}

@end
