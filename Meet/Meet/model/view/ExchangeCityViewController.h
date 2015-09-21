//
//  ExchangeCityViewController.h
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseViewController.h"
@class ExchangeCityViewController;
@protocol SelectCityDelegate <NSObject>

-(void)getCityName:(NSDictionary*) city;

@end
@interface ExchangeCityViewController : BaseViewController
@property (nonatomic,weak) id<SelectCityDelegate> delegate;
@end
