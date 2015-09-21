//
//  CustomerControlButton.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerControlButton : UIButton
- (instancetype)initWithImageNames:(NSArray *)imageNames;

@property (nonatomic, strong)NSArray *imageNames;
@property (nonatomic) NSUInteger currentImageIndex;
@end
