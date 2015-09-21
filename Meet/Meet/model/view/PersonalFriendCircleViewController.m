//
//  PersonalFriendCircleViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/17.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "PersonalFriendCircleViewController.h"
#import "FriendCircleHeaderView.h"
//third
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "PostTextAndPictureViewController.h"
#import "PersonalHomePageViewController.h"

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin ([ShareValue shareInstance].userInfo.nickname)
@interface PersonalFriendCircleViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,HeaderViewDelegate,PECropViewControllerDelegate,MWPhotoBrowserDelegate,ZYQAssetPickerControllerDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) FriendCircleHeaderView * circleHeader;
@property (nonatomic,strong) UIImage * coverImage;
@property (nonatomic,strong) NSMutableArray * circleList;
@property (nonatomic,strong) UIImagePickerController * coverPicker;
@property (nonatomic,strong) UIImagePickerController * messagePicker;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray * photos;
@end

@implementation PersonalFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.pageSize=10;
    self.circleHeader=[[FriendCircleHeaderView alloc]init];
    self.tableView.tableHeaderView=self.circleHeader;
    [self sizeHeaderToFit];
    self.tableView.backgroundColor=NAVI_COLOR;
    self.tableView.separatorColor=cellColor;
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"refresh");
        //         [self configDataWithPageSize:self.pageSize];
        [self.tableView.header endRefreshing];
    }];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.pageSize<40) {
            self.pageSize+=10;
            [self configDataWithPageSize:self.pageSize];
        }else{
            [self.tableView.footer endRefreshing];
            [self.tableView.footer noticeNoMoreData];
        }
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configDataWithPageSize:self.pageSize];
}
-(void)initView{
//    /**
//     *  添加右边按钮
//     *
//     */
//    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
//    rightView.backgroundColor=[UIColor clearColor];
//    UILabel * rightLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
//    rightLb.font=[UIFont fontWithName:iconFont size:20];
//    rightLb.text=@"\U0000e625";
//    rightLb.textColor=TempleColor;
//    rightLb.textAlignment=NSTextAlignmentRight;
//    [rightView addSubview:rightLb];
//    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
//    if (self.memberId.length>0) {
//        self.navigationItem.rightBarButtonItem=nil;
//    }else{
//        self.navigationItem.rightBarButtonItem=rightItem;
//    }
//    
//    rightLb.userInteractionEnabled=YES;
//    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postFriendCircle)];
//    [rightLb addGestureRecognizer:tapRight];
//    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(postTextMessage:)];
//    [rightLb addGestureRecognizer:longPress];
//    
//    
}
- (void)sizeHeaderToFit
{
    UIView *headerView = self.tableView.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    headerView.frame = ({
        CGRect headerFrame = headerView.frame;
        headerFrame.size.height = height;
        headerFrame;
    });
    
    self.tableView.tableHeaderView = headerView;
    [self updateViewConstraints];
}
- (void)configDataWithPageSize:(NSInteger)pageSize{
    //加载个人信息
    GetPersonalInfoRequest * requests =[[GetPersonalInfoRequest alloc]init];
    requests.memberId=self.memberId;
    [SystemAPI GetPersonalInfoRequest:requests success:^(GetPersonalInfoResponse *response) {
        NSDictionary * resultDic =response.data;
        //封面
        self.circleHeader.coverImageUrl=[resultDic objectForKey:@"circlePic"];
        self.circleHeader.photoIVUrl=[resultDic objectForKey:@"avatar"];
        self.circleHeader.name=[resultDic objectForKey:@"nickname"];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    self.circleList=nil;
    self.circleList=[NSMutableArray array];
    _tableDataSource=nil;
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource=nil;
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    /**
     加载数据
     */
    GetMyFriendCircleRequest * request=[[GetMyFriendCircleRequest alloc]init];
    if (pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%d",pageSize];
    }
        request.targetId=self.memberId;
    [SystemAPI GetMyFriendCircleRequest:request success:^(GetMyFriendCircleResponse *response) {
        NSArray * arr=(NSArray*)response.data;
        self.circleList=[NSMutableArray arrayWithArray:arr];
        for (NSDictionary * dic in arr) {
            WFMessageBody * message=[[WFMessageBody alloc]init];
            NSArray * resultArr=[dic objectForKey:@"result"];
            NSDictionary * resultDic =[resultArr firstObject];
            
            if ([[resultDic objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
                message.posterContent=@"";
            }else{
                message.posterContent =[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"content"]];
            }
            message.posterPostImage = [resultDic objectForKey:@"picUrlList"];
            message.posterImgstr = [resultDic objectForKey:@"avatar"];
            
            message.posterName = [resultDic objectForKey:@"nickname"];
            message.postDate=[resultDic objectForKey:@"created"];
            message.memberId=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"memberId"]];
            message.circleId=[resultDic objectForKey:@"circleId"];
            message.time=[dic objectForKey:@"time"];
            //回复部分
            NSArray * replies=[resultDic objectForKey:@"commentList"];
            NSMutableArray * bodys=[NSMutableArray array];
            for (NSDictionary * reply in replies) {
                WFReplyBody *body1 = [[WFReplyBody alloc] init];
                body1.replyUser = [reply objectForKey:@"nickname"];
                body1.repliedUser = [NSString stringWithFormat:@"%@",[reply objectForKey:@"parentNickname"]];
                body1.replyInfo = [reply objectForKey:@"content"];
                [bodys addObject:body1];
            }
            message.posterReplies = [NSMutableArray arrayWithArray:bodys];
            
            [_contentDataSource addObject:message];
        }
        [self loadTextData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
    
}
#pragma mark -加载数据
- (void)loadTextData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
            
            WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messBody;
            
            [ymDataArray addObject:ymData];
            
        }
        [self calculateHeight:ymDataArray];
        
    });
}
#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        ymData.favourHeight =0;
        
        [_tableDataSource addObject:ymData];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableDataSource.count>0) {
        YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
        BOOL unfold = ym.foldOrNot;
        return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    if (_tableDataSource.count>0) {
        [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
        cell.data=[_tableDataSource objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:self.tableView rect:targetRect isFavour:ym.hasFavour];
}



- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [self.tableView reloadData];
    
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    _selectedIndexPath = sender.appendIndexPath;
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];
    
}
#pragma 点击头像
-(void)clickPhotoIv:(NSInteger)index viewCell:(YMTableViewCell *)cell{
    YMTextData * data=cell.data;
    NSString * memberId=data.messageBody.memberId;
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=memberId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [self.tableView reloadData];
    
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    self.images=[imageViews copy];
    self.photos=nil;
    self.photos=[NSMutableArray array];
    for (int i=0; i<imageViews.count; i++) {
        UIImageView * image=imageViews[i];
        //        [image sd_setImageWithURL:[NSURL URLWithString:imageViews[i]]];
        MWPhoto * photo=[MWPhoto photoWithImage:image.image];
        [self.photos addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:clickTag-9999];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.images.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}


#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
    
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
        
        
    }else{
        //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        [self.view addSubview:replyView];
    }
}
//点击send以后的动作
#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }
    
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [self.tableView reloadData];
    
    /**
     *  评论朋友圈
     */
    NSDictionary * dic=[self.circleList objectAtIndex:inputTag];
    NSArray * resultArr=[dic objectForKey:@"result"];
    NSDictionary * resultDic =[resultArr firstObject];
    NSString * parentMemberId;
    if (_replyIndex == -1) {
        parentMemberId=@"0";
    }else{
        NSArray * arr=[resultDic objectForKey:@"commentList"];
        NSDictionary * comDic=[arr objectAtIndex:_replyIndex];
        parentMemberId=[NSString stringWithFormat:@"%@",[comDic objectForKey:@"parentMemberId"]];
    }
    NSString * circleID=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"circleId"]];
    CommentFriendCircleRequest * request =[[CommentFriendCircleRequest alloc]init];
    request.content=replyText;
    request.parentMemberId=parentMemberId;
    request.circleId=circleID;
    [SystemAPI CommentFriendCircleRequest:request success:^(CommentFriendCircleResponse *response) {
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
#pragma  删除评论
-(void)deletePostAtIndex:(NSInteger)postId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DeleteCirclePostRequest * request =[[DeleteCirclePostRequest alloc]init];
    request.circleId=postId;
    [SystemAPI DeleteCirclePostRequest:request success:^(DeleteCirclePostResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self configDataWithPageSize:self.pageSize];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==666) {
        /**
         *  photo
         */
        self.coverPicker=[[UIImagePickerController alloc]init];
        self.coverPicker.delegate=self;
        
        if (buttonIndex==0) {
            self.coverPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController: self.coverPicker animated:YES completion:NULL];
        }
        if (buttonIndex==1) {
            self.coverPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController: self.coverPicker animated:YES completion:NULL];
        }
        
    }else
    {
        if (actionSheet.tag==777) {
            /**
             *  photo
             */
            self.messagePicker=[[UIImagePickerController alloc]init];
            self.messagePicker.delegate=self;
            if (buttonIndex==1) {
                self.messagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController: self.messagePicker animated:YES completion:NULL];
            }
            if (buttonIndex==0) {
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                picker.maximumNumberOfSelection = 9;
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.showEmptyGroups=NO;
                picker.delegate=self;
                picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                        NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                        return duration >= 5;
                    } else {
                        return YES;
                    }
                }];
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            
            
        }else{
            if (buttonIndex == 0) {
                //delete
                YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
                WFMessageBody *m = ymData.messageBody;
                [m.posterReplies removeObjectAtIndex:_replyIndex];
                ymData.messageBody = m;
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                
                
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
                
                [self.tableView reloadData];
                
            }else{
                
            }}
        
        _replyIndex = -1;
    }
}
#pragma 点击切换封面和进入个人好友圈
-(void)changeHeaderViewBackView:(FriendCircleHeaderView *)View{
    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相机选择", nil];
    as.tag=666;
    [as showInView:self.view.window];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker==self.coverPicker) {
        self.coverImage=image;
        [picker dismissViewControllerAnimated:YES completion:^{
            //            [self uploadCoverImage];
            //编辑照片
            [self openEditor:image];
        }];
    }
    if (picker==self.messagePicker ) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"pictureMessage" sender:image];
        }];
    }
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray * images =[NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [images addObject:tempImg];
    }
    [self performSegueWithIdentifier:@"pictureMessage" sender:images];
}

//编辑照照片
- (void)openEditor:(UIImage*)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = sender;
    
    UIImage *image =sender;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    RootNavigationViewController  *navigationController = [[RootNavigationViewController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.coverImage = croppedImage;
    [self uploadCoverImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pictureMessage"]) {
        PostTextAndPictureViewController * vc=segue.destinationViewController;
        vc.images=sender;
    }
}
-(void)uploadCoverImage{
    /**
     *  上传头像
     */
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    ImageInfo * details=[[ImageInfo alloc]initWithImage:self.coverImage];
    [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
        NSArray * arr=(NSArray*)response.data;
        NSString* url=[arr firstObject];
        LMUserInfo  * user=[LMUserInfo new];
        user=[ShareValue shareInstance].userInfo;
        user.circlePic=url;
        [ShareValue shareInstance].userInfo=user;
        [self changeCoverImage];
    } fail:^(BOOL NotReachable, NSString *descript) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:descript toView:ShareAppDelegate.window];
    } class:[UploadFilesResponse class]];
}
-(void)changeCoverImage{
    ModifyFriendCircleCoverRequest * request=[[ModifyFriendCircleCoverRequest alloc]init];
    request.picUrl=[ShareValue shareInstance].userInfo.circlePic;
    [SystemAPI ModifyFriendCircleCoverRequest:request success:^(ModifyFriendCircleCoverResponse *response) {
        self.circleHeader.coverImageUrl=[ShareValue shareInstance].userInfo.circlePic;
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
//点击头像？
-(void)showMyFriendCircleVC{
    NSLog(@"sadadad");
}
-(void)postFriendCircle{
    UIActionSheet * as =[[UIActionSheet alloc]initWithTitle:@"请选择您要发表的消息类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照上传", nil];
    as.tag=777;
    [as showInView:self.view.window];
}
-(void)postTextMessage:(UIGestureRecognizer*)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateEnded:
            [self performSegueWithIdentifier:@"pictureMessage" sender:nil];
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }
    
}
@end

