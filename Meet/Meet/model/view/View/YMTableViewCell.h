//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"

@class YMTableViewCell;
@protocol cellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
-(void)clickPhotoIv:(NSInteger)index viewCell:(YMTableViewCell*)cell;
-(void)deletePostAtIndex:(NSInteger)postId;
-(void)clickReplyNickNameWithReplyIndex:(NSInteger)replyIndex viewCell:(YMTableViewCell*)cell;
-(void)callWithNumber:(NSString *)phoneNmuber;
-(void)playVideoWithPlayer:(AVPlayer*)player cell:(YMTableViewCell*)cell;
@end

@interface YMTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymFavourArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<cellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) YMButton *replyBtn;
@property (nonatomic,strong) YMTextData * data;
@property (nonatomic,strong) UIImageView *favourImage;//点赞的图

/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  用户简介label
 */
@property (nonatomic,strong) UILabel *userIntroLbl;
/**
 *  时间日期
 */
@property(nonatomic,strong) UILabel * dateLabel;
/**
 *  删除按钮
 *
 */
@property(nonatomic,strong) UIButton * deleteButton;
/**
 *  视频背景view
 */
@property(nonatomic,strong) UIView * videoBG;
/**
 *  播放器对象
 */
@property (nonatomic,strong) AVPlayer *player;

- (void)setYMViewWith:(YMTextData *)ymData;

@end
