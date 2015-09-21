//
//  CALayer+SbConfiguration.m
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "CALayer+SbConfiguration.h"


@implementation CALayer (SbConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
