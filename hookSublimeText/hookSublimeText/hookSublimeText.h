//
//  hookSublimeText.h
//  hookSublimeText
//
//  Created by lovecode666 on 2020/6/11.
//  Copyright © 2020 mll<coleflowersma#gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRSwizzle.h"

//! Project version number for hookSublimeText.
FOUNDATION_EXPORT double hookSublimeTextVersionNumber;

//! Project version string for hookSublimeText.
FOUNDATION_EXPORT const unsigned char hookSublimeTextVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <hookSublimeText/PublicHeader.h>

#define CBGetClass(classname) objc_getClass(#classname)

#define CBRegisterClass(superclassname, subclassname) { Class class = objc_allocateClassPair(CBGetClass(superclassname), #subclassname, 0);objc_registerClassPair(class); }

#define CBHookInstanceMethod(classname, ori_sel, new_sel) { NSError *error; [CBGetClass(classname) jr_swizzleMethod:ori_sel withMethod:new_sel error:&error]; if(error) NSLog(@"%@", error); }

#define CBHookClassMethod(classname, ori_sel, new_sel) { NSError *error; [CBGetClass(classname) jr_swizzleClassMethod:ori_sel withClassMethod:new_sel error:&error]; if(error) NSLog(@"%@", error); }

#define CBGetInstanceValue(obj, valuename) object_getIvar(obj, class_getInstanceVariable([obj class], #valuename))

#define CBSetInstanceValue(obj, valuename, value) object_setIvar(obj, class_getInstanceVariable([obj class], #valuename), value)

