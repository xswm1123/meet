//
//  BaseSegmentControl.m
//  Meet
//
//  Created by Anita Lee on 15/8/4.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseSegmentControl.h"
#import "ServerConfig.h"

@implementation BaseSegmentControl
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
    self.clipsToBounds=YES;
    self.layer.cornerRadius=8;
    self.layer.borderColor=TempleColor.CGColor;
    self.layer.borderWidth=1;
    self.tintColor=TempleColor;
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateSelected];
    self.selectedSegmentIndex=0;
}



@end
