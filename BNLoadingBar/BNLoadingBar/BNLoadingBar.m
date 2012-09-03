//
//  BNLoadingBar.m
//  BNLoadingBar
//
//  Created by Tatsuya Tobioka on 12/09/03.
//  Copyright (c) 2012年 Tatsuya Tobioka. All rights reserved.
//

#import "BNLoadingBar.h"

#import <QuartzCore/QuartzCore.h>

#define DURATION 0.2f
#define DELAY 0.0f

@interface BNLoadingBarInnerView : UIView
@property (nonatomic, assign) BNLoadingBarPosition position;
@end
@implementation BNLoadingBarInnerView
@end

@implementation BNLoadingBar

+ (void)showForView:(UIView *)view withMessage:(NSString *)message {
    [self showForView:view withMessage:message hasIndicator:YES];
}

    
+ (void)showForView:(UIView *)view withMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator {
    [self showForView:view withMessage:message hasIndicator:hasIndicator position:BNLoadingBarPositionBottomLeft];
}

+ (void)showForView:(UIView *)view withMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator position:(BNLoadingBarPosition)position {

    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[BNLoadingBarInnerView class]]) {
            [self hideForView:view delay:DELAY position:position];
            //return;
        }
    }
    
    float margin = 3.0f;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = CGRectMake(margin, margin, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
    
    float messageLabelX = hasIndicator ? indicator.frame.origin.x + indicator.frame.size.width + margin : margin;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageLabelX, margin, 0, 0)];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:13.0f];
    [messageLabel sizeToFit];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.center = CGPointMake(messageLabel.center.x, indicator.center.y);
    messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    float maxWidth = view.frame.size.width * 0.9;
    if (messageLabel.frame.size.width > maxWidth) {
        messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, maxWidth, messageLabel.frame.size.height);
    }
    
    float height = indicator.frame.size.height + margin * 2;
    float width = messageLabelX + messageLabel.frame.size.width + margin;

    float loadingBarX;
    float loadingBarY;
    
    switch (position) {
        case BNLoadingBarPositionTopLeft:
            loadingBarX = 0;
            loadingBarY = 0;
            break;
        case BNLoadingBarPositionBottomLeft:
            loadingBarX = 0;
            loadingBarY = view.bounds.size.height - height;
            break;
        case BNLoadingBarPositionTopRight:
            loadingBarX = view.bounds.size.width - width;
            loadingBarY = 0;
            break;
        case BNLoadingBarPositionBottomRight:
            loadingBarY = view.bounds.size.height - height;
            loadingBarX = view.bounds.size.width - width;
            break;
    }
        
    BNLoadingBarInnerView *loadingBar = [[BNLoadingBarInnerView alloc] initWithFrame:CGRectMake(loadingBarX, loadingBarY, width, height)];
    loadingBar.position = position;
    loadingBar.layer.shadowOpacity = 0.2f;
    loadingBar.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    loadingBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    loadingBar.backgroundColor = [UIColor blackColor];

    if (hasIndicator) {
        [loadingBar addSubview:indicator];
    }
    [loadingBar addSubview:messageLabel];    
    
    loadingBar.layer.opacity = 0.0f;
    [view addSubview:loadingBar];

#if !__has_feature(objc_arc)
    [indicator release];
    [messageLabel release];
    [loadingBar release];
#endif
    
    [UIView animateWithDuration:DURATION animations:^{
        loadingBar.layer.opacity = 0.8f;
    }];

}

+ (void)hideForView:(UIView *)view delay:(float)delay {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[BNLoadingBarInnerView class]]) {
            [UIView animateWithDuration:DURATION delay:delay options:0 animations:^{
                v.layer.opacity = 0.0f;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
}

+ (void)hideForView:(UIView *)view {
    [self hideForView:view delay:DELAY];
}

+ (void)hideForView:(UIView *)view delay:(float)delay position:(BNLoadingBarPosition)position {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[BNLoadingBarInnerView class]]) {
            if (((BNLoadingBarInnerView *)v).position == position) {
                [UIView animateWithDuration:DURATION delay:delay options:0 animations:^{
                    v.layer.opacity = 0.0f;
                } completion:^(BOOL finished) {
                    [v removeFromSuperview];
                }];
            }
        }
    }    
}

@end
