//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"
#import "WFReplyBody.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"
#import "ServerConfig.h"
#import "BaseViewController.h"
#import "NSString+URLEncode.h"

#define kImageTag 9999
#define videoHeight (self.videoBG.frame.size.height+5)


@implementation YMTableViewCell
{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = NAVI_COLOR;
        
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:8.0];
        _userHeaderImage.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto)];
        [_userHeaderImage addGestureRecognizer:tap];
        [self.contentView addSubview:_userHeaderImage];
        
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(TableHeader + 10,3, screenWidth - 120, TableHeader/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:18.0];
        _userNameLbl.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_userNameLbl];
        
        
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        
        replyImageView = [[UIImageView alloc] init];
        
        replyImageView.backgroundColor = cellColor;
        [self.contentView addSubview:replyImageView];
        
        _replyBtn = [YMButton buttonWithType:0];
        [_replyBtn setImage:[UIImage imageNamed:@"comment.png"] forState:0];
        [self.contentView addSubview:_replyBtn];
        
        self.dateLabel=[[UILabel alloc]init];
        self.dateLabel.font=[UIFont systemFontOfSize:14.0];
        self.dateLabel.textColor=[UIColor lightGrayColor];
        self.dateLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.dateLabel];
        
        self.deleteButton =[[UIButton alloc]init];
        self.deleteButton.frame=CGRectZero;
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        NSAttributedString * str =[[NSAttributedString alloc]initWithString:@"删除" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        
        [self.deleteButton setAttributedTitle:str forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteButton];
        
        self.videoBG=[[UIView alloc]init];
        self.videoBG.backgroundColor=[UIColor clearColor];
        self.videoBG.userInteractionEnabled=YES;
        UITapGestureRecognizer * playTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
        [self.videoBG addGestureRecognizer:playTap];
        [self.contentView addSubview:self.videoBG];
//        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _favourImage.image = [UIImage imageNamed:@"zan.png"];
//        [self.contentView addSubview:_favourImage];
    }
    return self;
}

- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setYMViewWith:(YMTextData *)ymData{
  
    tempDate = ymData;
    
#pragma mark -  //头像 昵称 简介
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:tempDate.messageBody.posterImgstr] placeholderImage:placeHolder];
    _userNameLbl.text = tempDate.messageBody.posterName;
    _dateLabel.text=tempDate.messageBody.postDate;
    
    NSString * time =[NSString stringWithFormat:@"%@",tempDate.messageBody.time];
    if (time.length>0) {
        _userHeaderImage.image=nil;
        UILabel * label =[[UILabel alloc]init];
        label.frame=CGRectMake(0, 0, _userHeaderImage.frame.size.width, _userHeaderImage.frame.size.height);
        label.textAlignment=NSTextAlignmentCenter;
        label.text=time;
        label.backgroundColor=[UIColor whiteColor];
        label.clipsToBounds=YES;
        label.layer.cornerRadius=5;
        label.font=[UIFont boldSystemFontOfSize:20];
        label.adjustsFontSizeToFitWidth=YES;
        [_userHeaderImage addSubview:label];
    }else{
        for (UIView * view in _userHeaderImage.subviews) {
            [view removeFromSuperview];
        }
    }
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
  
#pragma mark - // /////////添加说说view

    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(TableHeader+10, 30, screenWidth - 2 * offSet_X, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    textView.isPost=YES;
    
    textView.backgroundColor=[UIColor clearColor];
//    textView.textColor=[UIColor lightGrayColor];
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, 30, screenWidth - offSet_X-5, hhhh);
    
    [_ymShuoshuoArray addObject:textView];
    
    //按钮
    foldBtn.frame = CGRectMake(offSet_X - 10, 30 + hhhh + 10 , 50, 20 );
    
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [foldBtn setTitle:@"收起" forState:0];
    }
    
#pragma mark - /////// //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
    
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(65+(85*(i%3)), TableHeader-35 + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30), 80, ShowImage_H)];
        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
//        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag + i;
        [image sd_setImageWithURL:[NSURL URLWithString:[ymData.showImageArray objectAtIndex:i]] placeholderImage:placeHolder];
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
         tap.appendArray = _imageArray;
    }
#pragma 视频部分
    if (ymData.messageBody.videoUrl.length>0) {
        self.videoBG.hidden=NO;
         self.videoBG.frame=CGRectMake(65, TableHeader-35 + 10 + hhhh + kDistance + (ymData.islessLimit?0:30), screenWidth - offSet_X-5, 180);
        //创建player
        NSString *urlStr=ymData.messageBody.videoUrl;
        urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlStr];
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
        self.player=[AVPlayer playerWithPlayerItem:playerItem];
        //创建播放器层
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame=CGRectMake(0, 0, self.videoBG.frame.size.width, self.videoBG.frame.size.height);
        self.player.volume=0.0;
        playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
        [self.videoBG.layer addSublayer:playerLayer];
       
        [self.player play];
    }else{
        self.videoBG.hidden=YES;
        self.videoBG.frame=CGRectZero;
        [self.player pause];
    }
#pragma mark - /////点赞部分
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_ymFavourArray removeAllObjects];
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    float backView_Y = 0;
    float backView_H = 0;
    
    
    
//    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X + 30, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - 2 * offSet_X - 30, 0)];
//    favourView.delegate = self;
//    favourView.attributedData = ymData.attributedDataFavour;
//    favourView.isDraw = YES;
//    favourView.isFold = NO;
//    favourView.canClickAll = NO;
//    favourView.textColor = [UIColor redColor];
//    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
//    favourView.frame = CGRectMake(offSet_X + 30,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X * 2 - 30, ymData.favourHeight);
//    [self.contentView addSubview:favourView];
//    backView_H += ((ymData.favourHeight == 0)?(-kReply_FavourDistance):ymData.favourHeight);
//    [_ymFavourArray addObject:favourView];

//点赞图片的位置
//    _favourImage.frame = CGRectMake(offSet_X + 8, favourView.frame.origin.y, (ymData.favourHeight == 0)?0:20,(ymData.favourHeight == 0)?0:20);
    
    
#pragma mark - ///// //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
            //  NSLog(@"here");
            
        }
        
    }
    
    [_ymTextArray removeAllObjects];
  
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X+5,15 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance)+videoHeight, screenWidth - offSet_X -15, 0)];
        
        if (i == 0) {
            backView_Y =20 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30);
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.isPost=NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        _ilcoreText.backgroundColor=cellColor;
        _ilcoreText.superview.backgroundColor=cellColor;
        
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X+5,15+videoHeight + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance), screenWidth - offSet_X -15, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
       
        origin_Y += [_ilcoreText getTextHeight] + 3 ;
        if (i==0) {
//            origin_Y=0;
        }
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count -1)*3;
    
    
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        
        replyImageView.frame = CGRectMake(offSet_X, backView_Y+videoHeight - 10 + balanceHeight + 5 + kReplyBtnDistance, 0, 0);
        _replyBtn.frame = CGRectMake(screenWidth - 25 ,15+videoHeight + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 20, 20);
        self.dateLabel.frame=CGRectMake(offSet_X ,15+videoHeight + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 80, 20);
        if ([ymData.messageBody.memberId integerValue]==[[ShareValue shareInstance].userInfo.id integerValue]) {
             self.deleteButton.hidden=NO;
            self.deleteButton.tag=[ymData.messageBody.circleId integerValue];
              self.deleteButton.frame=CGRectMake(offSet_X+80 ,15+videoHeight + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 40, 20);
        }else{
             self.deleteButton.hidden=YES;
        }
      
    }else{
        
        replyImageView.frame = CGRectMake(offSet_X, backView_Y+videoHeight - 10 + balanceHeight + 5 + kReplyBtnDistance, screenWidth - offSet_X -10, backView_H + 20 - 8);//微调
        
        _replyBtn.frame = CGRectMake(screenWidth - 5 - 20 , replyImageView.frame.origin.y - 24, 20, 20);
        self.dateLabel.frame= CGRectMake(offSet_X , replyImageView.frame.origin.y - 24, 80, 20);
        
        if ([ymData.messageBody.memberId integerValue]==[[ShareValue shareInstance].userInfo.id integerValue]) {
             self.deleteButton.hidden=NO;
            self.deleteButton.tag=[ymData.messageBody.circleId integerValue];
            self.deleteButton.frame=CGRectMake(offSet_X+80 , replyImageView.frame.origin.y - 24, 40, 20);
        }else{
            self.deleteButton.hidden=YES;
        }
    }
}
#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    });
}


- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
  
    [_delegate longClickRichText:_stamp replyIndex:index];
      
}


- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    NSLog(@"clickString:%@",clickString);
//    NSString * message =[NSString stringWithFormat:@"%@可能是一个电话号码，您是否需要拨打？",clickString];
    if ([clickString isTelephone]) {
        [self.delegate callWithNumber:clickString];
        return;
    }
    
    if ([clickString isEqualToString:@""]) {
       //reply
        //NSLog(@"reply");
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
       //do nothing
//        [WFHudView showMsg:clickString inView:nil];
        [_delegate clickReplyNickNameWithReplyIndex:index viewCell:self];
    }
    
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
}
-(void)clickPhoto{
    [_delegate clickPhotoIv:0 viewCell:self];
}
-(void)deletePost:(UIButton*)button{
    [self.delegate deletePostAtIndex:button.tag];
}
-(void)playVideo{
    [self.delegate playVideoWithPlayer:self.player cell:self];
}
@end
