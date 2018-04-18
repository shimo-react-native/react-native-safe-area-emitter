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
    BOOL _listenRootSafeArea;
    BOOL _listenSafeArea;
    CGFloat _statusBarHeight;
    UIEdgeInsets _rootSafeAreaInsets;
}

@property (nonatomic, strong) UIView *rootView;

@end

@implementation RNSafeArea

RCT_EXPORT_MODULE();

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);;
        _rootSafeAreaInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_REMAP_METHOD(getRootSafeArea,
                 getRootSafeAreaWithResolver
                 : (RCTPromiseResolveBlock)resolve rejecter
                 : (RCTPromiseRejectBlock)reject) {
    UIEdgeInsets safeAreaInsets;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [self getSafeAreaInsetsForView:self.rootView];
    } else {
        safeAreaInsets = UIEdgeInsetsMake(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 0, 0, 0);
    }
    resolve([self getSafeAreaFromInsets:safeAreaInsets]);
}

RCT_REMAP_METHOD(getSafeArea,
                 getSafeAreaWithReactTag
                 : (nonnull NSNumber *)reactTag Resolver
                 : (RCTPromiseResolveBlock)resolve rejecter
                 : (RCTPromiseRejectBlock)reject) {
    UIView *view = [self.bridge.uiManager viewForReactTag:reactTag];
    resolve([self getSafeAreaFromInsets:[self getSafeAreaInsetsForView:view]]);
}

- (NSDictionary *)constantsToExport {
    return @{@"rootSafeArea": [self getSafeAreaFromInsets:[self getSafeAreaInsetsForView:self.rootView]]};
}

- (NSArray<NSString *> *)supportedEvents {
    return @[RNSafeAreaEventName, RNRootSafeAreaEventName];
}

- (void)startObserving {
    _rootSafeAreaInsets = [self getSafeAreaInsetsForView:self.rootView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(safeAreaInsetsDidChange:)
                                                 name:RNSafeAreaInsetsDidChange
                                               object:nil];
    if (@available(iOS 11.0, *)) {
        // use safe area
    } else {
        _statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidChangeStatusBarFrame:)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification
                                                   object:nil];
    }
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addListener:(NSString *)eventName {
    [super addListener:eventName];
    if ([eventName isEqualToString:RNSafeAreaEventName]) {
        _listenSafeArea = true;
    } else if ([eventName isEqualToString:RNRootSafeAreaEventName]) {
        _listenRootSafeArea = true;
    }
}

- (void)removeListeners:(double)count {
    [super removeListeners:count];
}

#pragma mark - Notification

- (void)applicationDidChangeStatusBarFrame:(NSNotification *)notification {
    // time delay is must, or statusBarFrame will be old
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        [self sendRootSafeAreaEvent];
    });
}

- (void)safeAreaInsetsDidChange:(NSNotification *)notification {
    UIView *view = (UIView *)notification.object;
    if ([view isKindOfClass:[RCTRootView class]] && _listenRootSafeArea) {
        _rootSafeAreaInsets = [self getSafeAreaInsetsForView:view];
        [self sendRootSafeAreaEvent];
    }
    if (_listenSafeArea) {
        UIEdgeInsets safeAreaInsets = [self getSafeAreaInsetsForView:view];
        NSDictionary *safeArea = [self getSafeAreaFromInsets:safeAreaInsets];
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

#pragma mark - Getter

- (UIView *)rootView {
    if (!_rootView) {
        UIWindow *window = RCTSharedApplication().keyWindow;
        if (window) {
            UIViewController *rootViewController = window.rootViewController;
            if (rootViewController) {
                _rootView = rootViewController.view;
            }
        }
    }
    return _rootView;
}

#pragma mark - Private

- (void)sendRootSafeAreaEvent {
    UIEdgeInsets safeAreaInsets;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = _rootSafeAreaInsets;
    } else {
        safeAreaInsets = UIEdgeInsetsMake(_statusBarHeight, 0, 0, 0);
    }
    [self sendEventWithName:RNRootSafeAreaEventName
                       body:[self getSafeAreaFromInsets:safeAreaInsets]];
}

- (UIEdgeInsets)getSafeAreaInsetsForView:(UIView *)view {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (view) {
        if (@available(iOS 11.0, *)) {
            safeAreaInsets = view.safeAreaInsets;
        } else {
            safeAreaInsets = UIEdgeInsetsMake(_statusBarHeight, 0, 0, 0);
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
