//
//  BNLoadingBar.h
//  BNLoadingBar
//
//  Created by Tatsuya Tobioka on 12/09/03.
//  Copyright (c) 2012年 Tatsuya Tobioka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNLoadingBar : NSObject

+ (void)showForView:(UIView *)view WithMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator;
+ (void)hideForView:(UIView *)view;
+ (void)hideForView:(UIView *)view delay:(float)delay;

@end
