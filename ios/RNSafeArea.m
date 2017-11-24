//
//  RNSafeArea.m
//  RNSafeArea
//
//  Created by Bell Zhong on 2017/11/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNSafeArea.h"
#import "UIView+safeArea.h"

#import <React/RCTRootView.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <React/RCTUIManager.h>

static NSString *const RNSafeAreaEventName = @"SafeAreaEvent";
static NSString *const RNRootSafeAreaEventName = @"RootSafeAreaEvent";

@interface RNSafeArea () {
    BOOL _hasListeners;
    BOOL _listenRootSafeArea;
    BOOL _listenSafeArea;
}

@end

@implementation RNSafeArea

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(safeAreaInsetsDidChange:)
                                                     name:RNSafeAreaInsetsDidChange
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_REMAP_METHOD(getRootSafeArea,
                 getRootSafeAreaWithResolver
                 : (RCTPromiseResolveBlock)resolve rejecter
                 : (RCTPromiseRejectBlock)reject) {
    UIView *rootView = nil;
    UIWindow *window = RCTSharedApplication().keyWindow;
    if (window) {
        UIViewController *rootViewController = window.rootViewController;
        if (rootViewController) {
            rootView = rootViewController.view;
        }
    }
    resolve([self getSafeAreaFromInsets:[self getSafeAreaInsetsForView:rootView]]);
}

RCT_REMAP_METHOD(getSafeArea,
                 getSafeAreaWithReactTag
                 : (nonnull NSNumber *)reactTag Resolver
                 : (RCTPromiseResolveBlock)resolve rejecter
                 : (RCTPromiseRejectBlock)reject) {
    UIView *view = [self.bridge.uiManager viewForReactTag:reactTag];
    resolve([self getSafeAreaFromInsets:[self getSafeAreaInsetsForView:view]]);
}

- (NSArray<NSString *> *)supportedEvents {
    return @[RNSafeAreaEventName, RNRootSafeAreaEventName];
}

- (void)startObserving {
    _hasListeners = YES;
}

- (void)stopObserving {
    _hasListeners = NO;
}

- (void)addListener:(NSString *)eventName {
    [super addListener:eventName];
    if (eventName) {
        if ([eventName isEqualToString:RNSafeAreaEventName]) {
            _listenSafeArea = true;
        } else if ([eventName isEqualToString:RNRootSafeAreaEventName]) {
            _listenRootSafeArea = true;
        }
    }
}

- (void)removeListeners:(NSInteger)count {
    [super removeListeners:count];
}

#pragma mark - Notification

- (void)safeAreaInsetsDidChange:(NSNotification *)notification {
    if (_hasListeners) {
        UIView *view = (UIView *)notification.object;
        UIEdgeInsets safeAreaInsets = [self getSafeAreaInsetsForView:view];
        NSDictionary *safeArea = [self getSafeAreaFromInsets:safeAreaInsets];

        if ([view isKindOfClass:[RCTRootView class]] && _listenRootSafeArea) {
            [self sendEventWithName:RNRootSafeAreaEventName
                               body:safeArea];
        }
        if (_listenSafeArea) {
            NSNumber *reactTag = view.reactTag;
            if (!reactTag) {
                reactTag = @0;
            }
            NSDictionary *safeAreaContainer = @{
                @"reactTag": reactTag,
                @"safeArea": safeArea
            };
            [self sendEventWithName:RNSafeAreaEventName
                               body:safeAreaContainer];
        }
    }
}

#pragma mark - Private

- (UIEdgeInsets)getSafeAreaInsetsForView:(UIView *)view {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (view) {
        if (@available(iOS 11.0, *)) {
            safeAreaInsets = view.safeAreaInsets;
        }
    }
    return safeAreaInsets;
}

- (NSDictionary *)getSafeAreaFromInsets:(UIEdgeInsets)safeAreaInsets {
    return @{
        @"top": @(safeAreaInsets.top),
        @"left": @(safeAreaInsets.left),
        @"right": @(safeAreaInsets.right),
        @"bottom": @(safeAreaInsets.bottom)
    };
}

@end
