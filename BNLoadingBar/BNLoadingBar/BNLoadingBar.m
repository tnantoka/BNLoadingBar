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

@interface BNLoadingBarInnerView : UIView
@end
@implementation BNLoadingBarInnerView
@end


@interface BNLoadingBarWebViewDelegate : NSObject <UIWebViewDelegate>

@property (nonatomic, assign) id originDelegate;

@end
@implementation BNLoadingBarWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([_originDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_originDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [BNLoadingBar showForView:webView WithMessage:@"Loading..." hasIndicator:YES];
    
    if ([_originDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_originDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_originDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_originDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_originDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_originDelegate webView:webView didFailLoadWithError:error];
    }
}

@end


@implementation BNLoadingBar

+ (void)showForView:(UIView *)view WithMessage:(NSString *)message hasIndicator:(BOOL)hasIndicator {

    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[BNLoadingBarInnerView class]]) {
            return;
        }
    }
    
    float margin = 3.0f;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = CGRectMake(margin, margin, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
    
    float x = hasIndicator ? indicator.frame.origin.x + indicator.frame.size.width + margin : margin;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, margin, 0, 0)];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:13.0f];
    [messageLabel sizeToFit];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.center = CGPointMake(messageLabel.center.x, indicator.center.y);
    
    float height = indicator.frame.size.height + margin * 2;
    float width = x + messageLabel.frame.size.width + margin;

    UIView *loadingBar = [[BNLoadingBarInnerView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - height, width, height)];
    loadingBar.layer.shadowOpacity = 0.2f;
    loadingBar.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    loadingBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
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

+ (void)hideForView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[BNLoadingBarInnerView class]]) {
            [UIView animateWithDuration:DURATION animations:^{
                v.layer.opacity = 0.0f;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
}

+ (void)showForWebView:(UIWebView *)webView {
    BNLoadingBarWebViewDelegate *loadingBarDelegate = [[BNLoadingBarWebViewDelegate alloc] init];
    loadingBarDelegate.originDelegate = webView.delegate;
    webView.delegate = loadingBarDelegate;

#if !__has_feature(objc_arc)
    [loadingBarDelegate autorelease];
#endif
}



@end
