//
//  Main.m
//  hookSublimeText
//
//  Created by lovecode666 on 2020/6/11.
//  Copyright © 2020 mll<coleflowersma#gmail.com>. All rights reserved.
//

#import <objc/runtime.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <stdio.h> 
#include "rd_route.h"
 
#import "Main.h"
#import "hookSublimeText.h"
#import "NMHooker.h"
  
 

typedef void (^CompletionHandler)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError);

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
    // NSLog(@"SublimeText m_st_update");
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
    // NSLog(@"-- hidden --");
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

// - HttpConnectionDelegate

- (void)m_st_connection:(id)arg1 didReceiveData:(id)arg2 {
    NSLog(@"SublimeText m_st_connection conn : %@", [arg1 class]);
    
    NSURLConnection *conn = (NSURLConnection *)arg1;
    if (conn.currentRequest) {
        NSURLRequest *req = conn.currentRequest;
        NSString *urlStr = req.URL.absoluteString;
        NSLog(@"req url : %@", urlStr);
        NSLog(@"req method : %@", req.HTTPMethod);
        NSLog(@"req body : %@", req.HTTPBody);
        NSDictionary *headers = req.allHTTPHeaderFields;
        NSLog(@"req headers : %@", headers);
    }
    NSString *body = [[NSString alloc] initWithData:(NSData *)arg2 encoding:NSUTF8StringEncoding];
     NSString *log2 = [NSString stringWithFormat:@"-m_st_connection--->body<---- : %@", body];
     NSLog(log2);
    
    [self m_st_connection:arg1 didReceiveData:arg2];
}

- (void)m_st_connection:(id)arg1 didReceiveResponse:(id)arg2 {
    NSLog(@"SublimeText m_st_connection dataResponse : %@", [arg2 class]);
    [self m_st_connection:arg1 didReceiveResponse:arg2];
}

@end


@implementation NSObject (NSURLConnection)
// - NSURLConnection
 

// 同步请求方法
+ (nullable NSData *)hook_sendSynchronousRequest:(NSURLRequest *)request
                               returningResponse:(NSURLResponse * _Nullable * _Nullable)response
                                           error:(NSError **)error {
    NSString *url = request.URL.absoluteString;
    NSString *log = [NSString stringWithFormat:@"----->url<-----:%@", url];
    NSLog(@"----------");
    
    //发起请求
    NSData *data = [[self class] hook_sendSynchronousRequest:request returningResponse:response error:error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)(*response);
  
    *response = httpResponse;
    
    NSLog(@"-------->over<--------");
    
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"---->body<---- : %@", body);
    
    return data;
}

// 异步请求方法
+ (void)hook_sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError)) handler {
    NSLog(@"-------->start<--------");
    
    CompletionHandler hook_handler = ^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  
        NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"---->body<---- : %@", body);
        
        if (handler) {
            NSLog(@"-------->over<--------");
            handler(httpResponse, data, connectionError);
        }
    };
    NSLog(@"-------->over<--------");
    [[self class] hook_sendAsynchronousRequest:request queue:queue completionHandler:hook_handler];
    return;
}

@end

void *(*original2)(int,int) = NULL;

void * my_strerror_2(char a, int64_t b)
{
    NSLog(@"hooked %lld - %lld ", a, b);
    return original2(a, b);
}

intptr_t g_slide;

//保存模块偏移基地址的值
static void _register_func_for_add_image(const struct mach_header *header, intptr_t slide) {
    Dl_info image_info;
    int result = dladdr(header, &image_info);
    if (result == 0) {
        NSLog(@"load mach_header failed");
        return;
    }
    // 获取当前的可执行文件路径
    NSString *execName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSString *execPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", execName];
    if (strcmp([execPath UTF8String], image_info.dli_fname) == 0) {
        g_slide = slide;
    }
}

void *(*ori_settings_get_bool)(void*, void*, void*, void*) = NULL;

// 处理 settings::get<bool>(v142, "update_check", "");
bool settings_get_bool(void *arg1, void *arg2, void* arg3, bool* is) {
    if (strcmp("update_check", arg2) == 0) {
        *is = NULL;
        return false;
    }
    return ori_settings_get_bool(arg1, arg2, arg3, is);
}

uint64_t (*ori_settings_find)(void *, void *, void *) = NULL;
uint64_t settings_find(void *arg1, void *arg2, void *arg3) {
    uint64_t res = ori_settings_find(arg1, arg2, arg3);
    // printf(" ----> settings_find <----%s| \n", (char *)res);
    return res;
}

void *(*ori_blocking_check_for_update)(void*, void* , void*, void*) = NULL;
void blocking_check_for_update(void *arg1, void* arg2,  void* arg3, void* arg4)
{
    printf("---> 请求更新 <-----");
    // ori_blocking_check_for_update(arg1, arg2, arg3, arg4);
    
    printf("d--->arg:%s<---\n", arg2);
    printf("d--->arg:%s<---\n", arg3);
    printf("d--->arg:%s<---\n", arg4);
}

static void __attribute__((constructor)) initialize(void) {
    // _dyld_register_func_for_add_image(_register_func_for_add_image);
    
    NSLog(@"++++++++ hookSublimeText loaded ++++++++");
  
    // blocking_check_for_update
    // c++filt __Z25blocking_check_for_updateRKNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEES7_P5valuePS5_
    //blocking_check_for_update(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, value*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >*)
     rd_route_byname("_Z25blocking_check_for_updateRKNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEES7_P5valuePS5_", NULL, blocking_check_for_update, (void **)&ori_blocking_check_for_update);
    
    // bool settings::get<bool>(substring, bool*) const
    // NSString *exe = @"/Applications/Sublime Text.app/Contents/MacOS/Sublime Text";
    // rd_route_byname("_ZNK8settings3getIbEEb9substringPT_", NULL, settings_get_bool, (void **)&ori_settings_get_bool);
    
    // rd_route((void *)(0x100062016+g_slide), hook_testMethod, NULL);
    
    // 每次 hook 复位
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"removedMark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CBHookInstanceMethod(PXWindowDelegate, @selector(windowWillEnterFullScreen:), @selector(m_st_windowWillEnterFullScreen:));
    CBHookInstanceMethod(PXWindowDelegate, @selector(windowWillExitFullScreen:), @selector(m_st_windowWillExitFullScreen:));
    
    // CBHookInstanceMethod(PXWindowDelegate, @selector(commandLine:), @selector(m_st_commandLine:));
    
    CBHookInstanceMethod(PXWindow, @selector(update), @selector(m_st_update));
    
    CBHookInstanceMethod(PXApplication, @selector(terminate:), @selector(m_st_terminate:));
    
    CBHookInstanceMethod(PXView, @selector(paste:), @selector(m_st_paste:));
    
    // hook HttpConnectionDelegate
    CBHookInstanceMethod(HttpConnectionDelegate, @selector(connection:didReceiveData:), @selector(m_st_connection:didReceiveData:));
    CBHookInstanceMethod(CBHookInstanceMethod, @selector(connection:didReceiveResponse:), @selector(m_st_connection:didReceiveResponse:));
 
    // hook net request
    // 同步请求
    // CBHookInstanceMethod(NSURLConnection, @selector(sendSynchronousRequest:returningResponse:error:), @selector(hook_sendSynchronousRequest:returningResponse:error:));
    //[NMHooker hookClass:@"NSURLConnection" sel:@"sendSynchronousRequest:returningResponse:error:" withClass:@"NSURLConnection" andSel:@"hook_sendSynchronousRequest:returningResponse:error:"];
    //CBHookClassMethod(NSURLConnection, @selector(sendSynchronousRequest:returningResponse:error:), @selector(hook_sendSynchronousRequest:returningResponse:error:));
    
    //异步请求
    //[NMHooker hookClass:@"NSURLConnection" sel:@"sendAsynchronousRequest:queue:completionHandler:" withClass:@"NSURLConnection" andSel:@"hook_sendAsynchronousRequest:queue:completionHandler:"];
    // CBHookInstanceMethod(NSURLConnection, @selector(sendAsynchronousRequest:queue:completionHandler:), @selector(hook_sendAsynchronousRequest:queue:completionHandler:));
    //CBHookClassMethod(NSURLConnection,  @selector(sendAsynchronousRequest:queue:completionHandler:), @selector(hook_sendAsynchronousRequest:queue:completionHandler:));
}
