//
//  BuyGiftsAlertView.h
//  Meet
//
//  Created by Anita Lee on 15/9/7.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuyGiftsAlertView;
@protocol BuGiftAlertDelegate <NSObject>

-(void)buyAlertView:(BuyGiftsAlertView*)alertView clickedAtButtonIndex:(NSInteger)buttonIndex;

@end

@interface BuyGiftsAlertView : UIView
@property (nonatomic,strong) NSString * currentGold;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * buyCount;
@property (nonatomic,strong) NSString * giftName;
@property (nonatomic,strong) NSString * giftPrice;
@property (nonatomic,strong) NSString * itemId;
@property (nonatomic,weak) id<BuGiftAlertDelegate> delegate;
-(void)dismiss;
@end
