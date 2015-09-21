//
//  ImplamentationViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/13.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ImplamentationViewController.h"

@interface ImplamentationViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ImplamentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xy.immet.cm/xy/mianze.jsp"]]];
}

@end
