//
//  BaseButton.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseButton.h"
#import "ServerConfig.h"

@implementation BaseButton

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
- (instancetype)initWithImageNames:(NSArray *)imageNames
{
    self = [super init];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor=TempleColor;
    self.layer.cornerRadius=5;
    self.layer.shadowOffset=CGSizeMake(0, 2);
    self.layer.shadowColor=TempleColor.CGColor;
    self.layer.shadowRadius=0;
    self.layer.shadowOpacity=0.6;
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}


@end
