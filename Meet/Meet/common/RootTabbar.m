//
//  RootTabbar.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/6.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RootTabbar.h"
#import "ServerConfig.h"

@implementation RootTabbar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect bounds=[self bounds];

    [NAVI_COLOR set];
    UIRectFill(bounds);
    
}
@end
