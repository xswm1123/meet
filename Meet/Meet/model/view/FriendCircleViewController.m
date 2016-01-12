//
//  FriendCircleViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "FriendCircleViewController.h"
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
#import "PersonalFriendCircleViewController.h"
#import "UploadVideoViewController.h"

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin ([ShareValue shareInstance].userInfo.nickname)
//#define kAdmin @"willie"

@interface FriendCircleViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,HeaderViewDelegate,PECropViewControllerDelegate,MWPhotoBrowserDelegate,ZYQAssetPickerControllerDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
}
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) FriendCircleHeaderView * circleHeader;
@property (nonatomic,strong) UIImage * coverImage;
@property (nonatomic,strong) NSMutableArray * circleList;
@property (nonatomic,strong) UIImagePickerController * coverPicker;
@property (nonatomic,strong) UIImagePickerController * messagePicker;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray * photos;
@property (strong ,nonatomic) AVPlayer *player;//播放器，用于录制完视频后播放视频
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSString * videoUrl;

@end

@implementation FriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    [ShareValue shareInstance].circleMessage=[NSNumber numberWithInt:0];
    [ShareValue shareInstance].postMessage=nil;
    [self initView];
    self.pageSize=10;
    self.circleHeader=[[FriendCircleHeaderView alloc]init];
    self.circleHeader.coverImageUrl=[ShareValue shareInstance].userInfo.circlePic;
    self.circleHeader.photoIVUrl=[ShareValue shareInstance].userInfo.avatar;
    self.circleHeader.name=[ShareValue shareInstance].userInfo.nickname;
    self.circleHeader.delegate=self;
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
        if (self.pageSize<1000) {
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
    Reachability  * manager= [Reachability reachabilityWithHostName: BASE_SERVERLURL];
    NSLog(@"status:%ld",(long)[manager currentReachabilityStatus]);
    if ([manager currentReachabilityStatus]>0) {
        [self configDataWithPageSize:self.pageSize];
    }
}
-(void)initView{
    /**
     *  添加右边按钮
     *
     */
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    UILabel * rightLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    rightLb.font=[UIFont fontWithName:iconFont size:20];
    rightLb.text=@"\U0000e625";
    rightLb.textColor=TempleColor;
    rightLb.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:rightLb];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    if (self.memberId.length>0) {
        self.navigationItem.rightBarButtonItem=nil;
    }else{
        self.navigationItem.rightBarButtonItem=rightItem;
    }
    
    rightLb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postFriendCircle)];
    [rightLb addGestureRecognizer:tapRight];
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(postTextMessage:)];
    [rightLb addGestureRecognizer:longPress];
    

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
    
    _replyIndex = -1;//代表是直接评论
    /**
     加载数据
     */
    GetFriendCircleListRequest * request=[[GetFriendCircleListRequest alloc]init];
    if (pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%ld",pageSize];
    }
    if (self.memberId.length>0) {
        request.memberId=self.memberId;
    }
    [SystemAPI GetFriendCircleListRequest:request success:^(GetFriendCircleListResponse *response) {
        self.circleList=[NSMutableArray array];
        _tableDataSource = [[NSMutableArray alloc] init];
        _contentDataSource = [[NSMutableArray alloc] init];
        NSArray * arr=(NSArray*)response.data;
        self.circleList=[NSMutableArray arrayWithArray:arr];
        for (NSDictionary * dic in arr) {
            WFMessageBody * message=[[WFMessageBody alloc]init];
            if ([[dic objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
                message.posterContent=@"";
            }else{
                message.posterContent =[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
            }
            message.posterPostImage = [dic objectForKey:@"picUrlList"];
            message.posterImgstr = [dic objectForKey:@"avatar"];
            message.posterName = [dic objectForKey:@"nickname"];
            message.postDate=[dic objectForKey:@"created"];
            message.time=@"";
            message.circleId=[dic objectForKey:@"circleId"];
            message.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
            if ([[dic objectForKey:@"videoUrl"] isKindOfClass:[NSNull class]]) {
                message.videoUrl=@"";
            }else{
                message.videoUrl=[dic objectForKey:@"videoUrl"];
            }
            //回复部分
            NSArray * replies=[dic objectForKey:@"commentList"];
            NSMutableArray * bodys=[NSMutableArray array];
            for (NSDictionary * reply in replies) {
                WFReplyBody *body1 = [[WFReplyBody alloc] init];
                body1.commentId=[reply objectForKey:@"commentId"];
                body1.replyUser = [reply objectForKey:@"nickname"];
                body1.replyUserId=[NSString stringWithFormat:@"%@",[reply objectForKey:@"memberId"]];
                body1.repliedUser = [NSString stringWithFormat:@"%@",[reply objectForKey:@"parentNickname"]];
                 body1.repliedUserId=[NSString stringWithFormat:@"%@",[reply objectForKey:@"parentMemberId"]];
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
    if (_tableDataSource.count>indexPath.row) {
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
        if (ym.messageBody.videoUrl.length>0) {
            return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance)+180;
        }
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
    if (indexPath.row<_tableDataSource.count) {
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
    browser.displayActionButton = YES;
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
    if (replyIndex!=-1) {
        WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = b.replyInfo;
    }
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    if (replyIndex!=-1) {

    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
    }
    else{
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
    NSString * parentMemberId;
    if (_replyIndex == -1) {
        parentMemberId=@"0";
    }else{
        NSArray * arr=[dic objectForKey:@"commentList"];
        NSDictionary * comDic=[arr objectAtIndex:_replyIndex];
        parentMemberId=[NSString stringWithFormat:@"%@",[comDic objectForKey:@"memberId"]];
    }
    NSString * circleID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"circleId"]];
    CommentFriendCircleRequest * request =[[CommentFriendCircleRequest alloc]init];
    request.content=replyText;
    request.parentMemberId=parentMemberId;
    request.circleId=circleID;
    [SystemAPI CommentFriendCircleRequest:request success:^(CommentFriendCircleResponse *response) {
        [self configDataWithPageSize:self.pageSize];
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
            //发表视频
            if (buttonIndex==2) {
                [self postVideo];
            }
            
        }else{
            if (buttonIndex == 0) {
            //delete
            YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
             WFMessageBody *m = ymData.messageBody;
                //删除评论
                WFReplyBody *b = [m.posterReplies objectAtIndex:_replyIndex];
                DeleteCircleCommentRequest * request =[[DeleteCircleCommentRequest alloc]init];
                request.commentId=b.commentId;
                [SystemAPI DeleteCircleCommentRequest:request success:^(DeleteCircleCommentResponse *response) {
                    [self configDataWithPageSize:self.pageSize];
                } fail:^(BOOL notReachable, NSString *desciption) {
                    
                }];
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
            [self performSegueWithIdentifier:@"pictureMessage" sender:@[image]];
        }];
    }
    if (picker==self.imagePicker) {
         NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
            NSLog(@"video...");
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSString *urlStr=[url path];
            self.videoUrl=urlStr;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }
         [self dismissViewControllerAnimated:YES completion:nil];
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
    UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalFriendCircleViewController * vc=[sb instantiateViewControllerWithIdentifier:@"PersonalFriendCircleViewController"];
    vc.memberId=[ShareValue shareInstance].userInfo.id;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击回复的名字
-(void)clickReplyNickNameWithReplyIndex:(NSInteger)replyIndex viewCell:(YMTableViewCell *)cell{
    UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalFriendCircleViewController * vc=[sb instantiateViewControllerWithIdentifier:@"PersonalFriendCircleViewController"];
    NSLog(@"replyIndex:%ld",replyIndex);
    NSArray * commentList=cell.data.messageBody.posterReplies;
    WFReplyBody * body =[commentList objectAtIndex:replyIndex];
    vc.memberId=body.replyUserId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)postFriendCircle{
    UIActionSheet * as =[[UIActionSheet alloc]initWithTitle:@"请选择您要发表的消息类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍照上传",@"视频", nil];
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
-(void)callWithNumber:(NSString *)phoneNmuber{
    NSString * message =[NSString stringWithFormat:@"%@可能是一个电话号码，您是否需要拨打？",phoneNmuber];
   
        UIAlertController * al=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * actionConfirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNmuber]]];
        }];
        [al addAction:actionCancel];
        [al addAction:actionConfirm];
    [self presentViewController:al animated:YES completion:^{
        
    }];

}
-(void)playVideoWithPlayer:(AVPlayer *)player cell:(YMTableViewCell *)cell{
    [player pause];
    NSString * urlStr =cell.data.messageBody.videoUrl;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [self presentMoviePlayerViewControllerAnimated:movieViewController];
}
//录制小视频上传
-(void)postVideo{
    NSLog(@"postVideo");
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;//wifi
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        _imagePicker.videoMaximumDuration=15.0;
        _imagePicker.allowsEditing=YES;//允许编辑
        
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UploadVideoViewController * vc =[sb instantiateViewControllerWithIdentifier:@"UploadVideoViewController"];
        vc.url=url;
        vc.mark=@"postVideo";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
