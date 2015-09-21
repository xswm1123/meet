//
//  FriendCircleHeaderView.h
//  Meet
//
//  Created by Anita Lee on 15/8/13.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendCircleHeaderView;
@protocol HeaderViewDelegate <NSObject>
/**
 *  点击切换封面
 *
 *  @param View
 */
-(void)changeHeaderViewBackView:(FriendCircleHeaderView*)View;
/**
 *  点击进入个人好友圈
 */
-(void)showMyFriendCircleVC;

@end

@interface FriendCircleHeaderView : UIView
@property (nonatomic,strong)UIImage * backgroundImage;
@property (nonatomic,strong)UIImage * photoIV;
@property (nonatomic,strong) NSString * coverImageUrl;
@property (nonatomic,strong) NSString * photoIVUrl;

@property (nonatomic,strong) NSString * name;
@property (nonatomic,weak) id<HeaderViewDelegate> delegate;
@end
