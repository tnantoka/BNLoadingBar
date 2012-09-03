//
//  BNLoadingBar.h
//  BNLoadingBar
//
//  Created by Tatsuya Tobioka on 12/09/03.
//  Copyright (c) 2012年 Tatsuya Tobioka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BNLoadingBarPositionTopLeft,
    BNLoadingBarPositionBottomLeft,
    BNLoadingBarPositionTopRight,
    BNLoadingBarPositionBottomRight
} BNLoadingBarPosition;

@interface BNLoadingBar : NSObject

+ (void)showForView:(UIView *)view withMessage:(NSString *)message;
+ (void)showForView:(UIView *)view withMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator;
+ (void)showForView:(UIView *)view withMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator position:(BNLoadingBarPosition)position;

+ (void)hideForView:(UIView *)view;
+ (void)hideForView:(UIView *)view delay:(float)delay;
+ (void)hideForView:(UIView *)view delay:(float)delay position:(BNLoadingBarPosition)position;

@end
