//
//  UIView+safeArea.m
//  RNSafeArea
//
//  Created by Bell Zhong on 2017/11/24.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import "UIView+safeArea.h"

#import <objc/runtime.h>

NSString *const RNSafeAreaInsetsDidChange = @"RNSafeAreaInsetsDidChange";

@implementation UIView (safeArea)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originPresentMethod = class_getInstanceMethod(self, @selector(safeAreaInsetsDidChange));
        if (originPresentMethod) {
            Method presentMethod = class_getInstanceMethod(self, @selector(rns_safeAreaInsetsDidChange));
            method_exchangeImplementations(originPresentMethod, presentMethod);
        }
    });
}

- (void)rns_safeAreaInsetsDidChange {
    [self rns_safeAreaInsetsDidChange];
    [[NSNotificationCenter defaultCenter] postNotificationName:RNSafeAreaInsetsDidChange
                                                        object:self];
}

@end
