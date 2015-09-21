//
//  GiveGiftAlertView.h
//  Meet
//
//  Created by Anita Lee on 15/9/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiveGiftAlertView;
@protocol GiveGiftAlertDelegate <NSObject>

-(void)giveGift:(GiveGiftAlertView*)alertView withGiftInfo:(NSDictionary*)giftInfo;
-(void)moveToMarketCenter;

@end

@interface GiveGiftAlertView : UIView
@property (nonatomic,strong) NSArray * data;
@property (nonatomic,weak) id<GiveGiftAlertDelegate> delegate;
@end
