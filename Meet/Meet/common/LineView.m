//
//  LineView.m
//  Meet
//
//  Created by Anita Lee on 15/8/9.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "LineView.h"
#import "ServerConfig.h"

@implementation LineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    self.backgroundColor=NAVI_COLOR;
}

@end
