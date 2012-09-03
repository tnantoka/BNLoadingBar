//
//  BNViewController.m
//  BNLoadingBar
//
//  Created by Tatsuya Tobioka on 12/09/03.
//  Copyright (c) 2012年 Tatsuya Tobioka. All rights reserved.
//

#import "BNViewController.h"

#import "BNLoadingBar.h"

@interface BNViewController ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation BNViewController

- (void)dealloc {
    [_webView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 310, 34)];
    locationField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    locationField.placeholder = @"http://";
    locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    locationField.delegate = self;
    locationField.keyboardType = UIKeyboardTypeURL;
    locationField.returnKeyType = UIReturnKeyGo;
    locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.titleView = locationField;
    [locationField release];
    
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStyleBordered target:self action:@selector(showAction:)];
    UIBarButtonItem *withoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Without Indicator" style:UIBarButtonItemStyleBordered target:self action:@selector(withoutAction:)];
    UIBarButtonItem *hideItem = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleBordered target:self action:@selector(hideAction:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             showItem,
                             withoutItem,
                             flexibleItem,
                             hideItem,
                             nil];
    self.toolbarItems = toolbarItems;
    
    [showItem release];
    [withoutItem release];
    [hideItem release];
    [flexibleItem release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

# pragma mark - Button actions

- (void)showAction:(id)sender {
    [BNLoadingBar showForView:self.view WithMessage:@"Loading..." hasIndicator:YES];
}

- (void)withoutAction:(id)sender {
    [BNLoadingBar showForView:self.view WithMessage:@"Loading..." hasIndicator:NO];
}

- (void)hideAction:(id)sender {
    [BNLoadingBar hideForView:self.view];
}


# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (textField.text.length < 1) {
        return YES;
    }
    
    NSURL *url = [NSURL URLWithString:textField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    return YES;
}

# pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [BNLoadingBar showForView:self.view WithMessage:@"Loading..." hasIndicator:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [BNLoadingBar hideForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [BNLoadingBar showForView:self.view WithMessage:[error localizedDescription] hasIndicator:NO];
    [BNLoadingBar hideForView:self.view delay:2.0f];
}


@end
