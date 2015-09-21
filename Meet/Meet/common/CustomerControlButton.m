//
//  CustomerControlButton.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "CustomerControlButton.h"

@implementation CustomerControlButton

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
        self.imageNames = imageNames;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeButton:(UIButton *)button
{
    NSUInteger index = self.currentImageIndex;
    index++;
    index %= self.imageNames.count;
    self.currentImageIndex = index;
}

- (void)setCurrentImageIndex:(NSUInteger)currentImageIndex
{
    _currentImageIndex = currentImageIndex;
    [self setImage:[UIImage imageNamed:self.imageNames[currentImageIndex]] forState:UIControlStateNormal];
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    self.currentImageIndex = 0;
}


@end
