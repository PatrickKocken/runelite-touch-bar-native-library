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
#import "JavaGroupTouchBarItem.h"

#include <jni.h>
#include <string>

#include <Cocoa/Cocoa.h>

#import "JNIContext.h"
#import "JavaTouchBarUtils.h"

#import "JavaTouchBar.h"

@interface JavaGroupTouchBarItem() {
    NSGroupTouchBarItem *_touchBarItem;
    
    JavaTouchBar *_javaTouchBar;
    NSTouchBar *_groupTouchBar;
}

@end

@implementation JavaGroupTouchBarItem

-(NSTouchBarItem*) getTouchBarItem {
    if(self.javaRepr == NULL) {
        return nil;
    }
    
    if(_touchBarItem == nil) {
        JNIEnv *env; JNIContext context(&env);
        
        NSString *identifier = [super getIdentifier:env reload:TRUE];
        
        jobject groupTouchBar = JNIContext::CallObjectMethod(env, self.javaRepr, "getGroupTouchBar", "dev/kocken/nativebridge/JavaTouchBar");
        
        _javaTouchBar = [[JavaTouchBar alloc] init];
        [_javaTouchBar setJavaRepr:groupTouchBar];
        
        _touchBarItem = [[NSGroupTouchBarItem alloc] initWithIdentifier:identifier];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar = [_javaTouchBar createNSTouchBar];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar.delegate = self;
        
        env->DeleteLocalRef(groupTouchBar);
    }
    
    return _touchBarItem;
}

-(NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    return [JavaTouchBarUtils touchBar:touchBar makeItemForIdentifier:identifier usingJavaTouchBar:_javaTouchBar];
}

@end
