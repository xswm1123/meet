//
//  ChooseAddressViewController.h
//  Meet
//
//  Created by Anita Lee on 15/10/7.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import "BaseViewController.h"
@class ChooseAddressViewController;
@protocol ChooseAddressDelegate <NSObject>

-(void)getAddressFromMap:(NSString*)address;

@end

@interface ChooseAddressViewController : BaseViewController
@property(nonatomic,weak)id<ChooseAddressDelegate> delegate;
@end
