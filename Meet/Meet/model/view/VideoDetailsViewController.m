//
//  VideoDetailsViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//
#ifdef __OBJC__
#import "VideoDetailsViewController.h"
#import "VideoCommnetsListTableViewCell.h"
#import "MoreGiftsViewController.h"
#import "AddFriendViewController.h"
#import "GiveGiftAlertView.h"
#import "ShareAlertView.h"
#import "PersonalHomePageViewController.h"
//xxtea加密
#include "XXTEA.h"
#endif
//#include "encrypt_utils.h"

#define VideoCommentsID @"VideoCommnetsListTableViewCell"

@interface VideoDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,GiveGiftAlertDelegate,UIAlertViewDelegate,ShareAlertViewDelegate,VideoCommentsDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIView *videoBG;
@property (weak, nonatomic) IBOutlet UIView *giftBG;
@property (weak, nonatomic) IBOutlet UIImageView *videoScreen;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconGift;
@property (weak, nonatomic) IBOutlet UILabel *lb_giftCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *tf_comment;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet BaseView *giftListGB;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starToMeiLiDistance;

@property (nonatomic,strong) NSMutableArray * commentDatas;
@property (nonatomic,strong) NSMutableArray * giftDatas;
@property (weak, nonatomic) IBOutlet BaseView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewDistanceToBottom;
//video play
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) NSString *videoUrl;//视频播放地址
@property (nonatomic,strong) NSDictionary * detailsInfo;
//send gift
@property (nonatomic,strong) UIView * mask;
@property (nonatomic,strong) GiveGiftAlertView * giveView;
@property (nonatomic,strong) NSDictionary * giveInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistanceToView;
@end
#define imageWith ((DEVCE_WITH-50)/4)
@implementation VideoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCommnetsListTableViewCell" bundle:nil] forCellReuseIdentifier:VideoCommentsID];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.fd_debugLogEnabled = YES;
    [self initView];
    [self loadVideoDetailsInfo];
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerWillEnterFullscreen:) name:MPMoviePlayerScalingModeDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
    [self.tableView setSeparatorColor:NAVI_COLOR];
}
-(void)initView{
    self.scrollView.backgroundColor=NAVI_COLOR;
    self.tableView.backgroundColor=NAVI_COLOR;
    self.lb_iconGift.font=[UIFont fontWithName:iconFont size:28];
    self.lb_iconGift.text=@"\U0000e61b";
    self.giftBG.layer.cornerRadius=27;
    self.photoIV.layer.cornerRadius=25;
    //rightItem
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    UILabel * rightLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightLb.font=[UIFont fontWithName:iconFont size:30];
    rightLb.text=@"\U0000e606";
    rightLb.textColor=TempleColor;
    rightLb.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:rightLb];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
    rightLb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFriend)];
    [rightLb addGestureRecognizer:tapRight];
}
/**
 *  加载视频详情数据
 */
-(void)loadVideoDetailsInfo{
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"avatar"]]]];
    self.lb_name.text=[self.infoDic objectForKey:@"nickname"];
    [self.videoScreen sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"picUrl"]]]];
    
    GetVideoDetailsRequest *request=[[GetVideoDetailsRequest alloc]init];
    request.videoId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"videoId"]];
    [SystemAPI GetVideoDetailsRequest:request success:^(GetVideoDetailsResponse *response) {
        self.detailsInfo=[response.data copy];
        self.lb_count.text=[NSString stringWithFormat:@"%@",[response.data objectForKey:@"meili"]];
        if ([[response.data objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
            self.lb_desc.text=@"暂无标题";
        }else{
            self.lb_desc.text=[NSString stringWithFormat:@"%@",[response.data objectForKey:@"title"]];
        }
       
        NSArray * gifts=[response.data objectForKey:@"itemList"];
        self.lb_giftCount.text=[NSString stringWithFormat:@"%d",(int)gifts.count];
        self.videoUrl=[response.data objectForKey:@"videoUrl"];
        //处理star
        int starCount=[[response.data objectForKey:@"star"] intValue];
        for (int i =0; i<5; i++) {
            UIImageView * im=[self.stars objectAtIndex:i];
            if (i<starCount) {
                im.hidden=NO;
            }else{
                im.hidden=YES;
            }
        }
        self.starToMeiLiDistance.constant=144-20*(5-starCount);
        [self updateViewConstraints];

        [self setUpVideoPlayController];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    /**
     *  加载视频评论
     */
    [self loadVideoComments];
    /**
     *  加载礼物列表
     *
     */
    [self loadGiftList];
}
-(void)loadGiftList{
    GetVideoReceivedGiftsListRequest * giftRequest=[[GetVideoReceivedGiftsListRequest alloc]init];
    giftRequest.videoId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"videoId"]];
    [SystemAPI GetVideoReceivedGiftsListRequest:giftRequest success:^(GetVideoReceivedGiftsListResponse *response) {
        self.giftDatas =[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self showGiftImages];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)loadVideoComments{
    GetGiftsCommentsListRequest * commentRequest=[[GetGiftsCommentsListRequest alloc]init];
    commentRequest.videoId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"videoId"]];
    [SystemAPI GetGiftsCommentsListRequest:commentRequest success:^(GetGiftsCommentsListResponse *response) {
        self.commentDatas =[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
/**
 *  加载礼物的四张图片
 */
-(void)showGiftImages{
   
        
        for (int i=0; i<self.giftDatas.count; i++) {
            NSDictionary * dic=self.giftDatas[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10+(imageWith+10)*i,30,imageWith,70)];
            UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWith+10)*i,100,imageWith,20)];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=iconYellow;
            lab.text=[dic objectForKey:@"title"];
            lab.font=[UIFont systemFontOfSize:14];
                [imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
                [self.giftListGB addSubview:imgview];
                [self.giftListGB addSubview:lab];
        }
    

}

-(void)addFriend{
    [self performSegueWithIdentifier:@"addFriend" sender:nil];
}
- (IBAction)moreGift:(id)sender {
     [self performSegueWithIdentifier:@"moreGifts" sender:self.giftDatas];
}
- (IBAction)sendComment:(id)sender {
    if (self.tf_comment.text.length==0) {
        [MBProgressHUD showError:@"请输入评论内容！" toView:self.view.window];
        return;
    }
    CommentVideoRequest * request=[[CommentVideoRequest alloc]init];
    request.videoId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"videoId"]];
    request.content=self.tf_comment.text;
    [SystemAPI CommentVideoRequest:request success:^(CommentVideoResponse *response) {
        [self loadVideoComments];
        self.tf_comment.text=@"";
        [self.tf_comment resignFirstResponder];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCommnetsListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:VideoCommentsID];
    cell.delegate=self;
    if (!cell) {
        cell=[[VideoCommnetsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCommentsID];
    }
    
    NSDictionary * dic=[self.commentDatas objectAtIndex:indexPath.row];
    cell.lb_name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
     cell.lb_content.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
     cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    cell.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//        VideoCommnetsListTableViewCell* cell=(VideoCommnetsListTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        CGSize size=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    
//        if (size.height<60.0) {
//            return 60.0;
//        }else{
//        return size.height+3;
//        }
    return [tableView fd_heightForCellWithIdentifier:VideoCommentsID cacheByIndexPath:indexPath configuration:^(VideoCommnetsListTableViewCell* cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        NSDictionary * dic=[self.commentDatas objectAtIndex:indexPath.row];
        cell.lb_name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        cell.lb_content.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
        cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    }];
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic =[self.commentDatas objectAtIndex:indexPath.row];
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"moreGifts"]) {
        MoreGiftsViewController * vc=segue.destinationViewController;
        vc.giftDats=sender;
    }
    if ([segue.identifier isEqualToString:@"addFriend"]) {
        AddFriendViewController * vc=segue.destinationViewController;
        vc.memberId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"memberId"]];
    }
}
/**
 *  评论视频
 */
#pragma 注册监听，通知键盘的收放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppear:(NSNotification *)notification
{

    //1. 通过notification的userInfo获取键盘的坐标系信息
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //2. 计算输入框的坐标
//    CGRect frame = self.inputView.frame;
//    frame.origin.y = keyboardFrame.origin.y - self.inputView.frame.size.height;
    //3. 动画地改变坐标
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];

    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
//        self.inputView.frame = frame;
        self.bottomDistanceToView.constant=keyboardFrame.size.height;
        [self updateViewConstraints];
    } completion:nil];
}

- (void)keyboardDisappear:(NSNotification *)notification
{
//    CGRect frame = self.inputView.frame;
//    frame.origin.y = self.scrollView.frame.size.height - frame.size.height - self.bottomLayoutGuide.length;
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
//        self.inputView.frame = frame;
        self.bottomDistanceToView.constant=0.0;
         [self updateViewConstraints];
    } completion:nil];
}
/**
 *  播放视频
 */
- (IBAction)playVideo:(id)sender {
    [self.videoScreen addSubview:_moviePlayer.view];
    [self.moviePlayer play];
}
-(void)setUpVideoPlayController{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    NSURL *url=[self getNetworkUrl];
    _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
    _moviePlayer.controlStyle=MPMovieControlStyleEmbedded;
    _moviePlayer.view.frame=CGRectMake(0, 0, self.videoScreen.frame.size.width, self.videoScreen.frame.size.height);
}
/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    //网络地址
    NSString *urlStr=self.videoUrl;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
    //本地视频地址
//    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"videoplayback.mp4" ofType:nil];
//    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}
-(void)mediaPlayerWillEnterFullscreen:(NSNotification*)noti{
    [self.moviePlayer play];
//    [self.moviePlayer setFullscreen:NO];
//    NSLog(@"mediaPlayerWillEnterFullscreen");
//    MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[self getNetworkUrl]];
//    [movieViewController.moviePlayer prepareToPlay];
//    movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//    // Self is the UIViewController you are presenting the movie player from.
//    [self presentMoviePlayerViewControllerAnimated:movieViewController];
//    [self presentViewController:movieViewController animated:YES completion:^{
    
//    }];
}
-(void)mediaPlayerDidEnterFullscreen:(NSNotification*) noti{
//    self.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
     [self.moviePlayer play];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.moviePlayer pause];
//    self.moviePlayer=nil;
}
- (IBAction)giveGiftToVideo:(id)sender {
    GetCanSendGiftRequest * request =[[GetCanSendGiftRequest alloc]init];
    [SystemAPI GetCanSendGiftRequest:request
                             success:^(GetCanSendGiftResponse *response) {
                                 NSArray * data =(NSArray*)response.data;
                                 [self showGiveViewWithData:data];
                             } fail:^(BOOL notReachable, NSString *desciption) {
                                 [self showGiveViewWithData:[NSArray new]];
                             }];
}
-(void)showGiveViewWithData:(NSArray*)data{
    self.mask=[[UIView alloc]initWithFrame:self.view.window.bounds];
    self.mask.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss:)];
    [self.mask addGestureRecognizer:tap];
    [self.view addSubview:self.mask];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GiveGiftAlertView"owner:self options:nil];
    GiveGiftAlertView * view = [nib objectAtIndex:0];
    view.delegate=self;
    view.data=data;
    view.frame=CGRectMake(0, DEVICE_HEIGHT-200, DEVCE_WITH, 200);
    [self.mask addSubview:view];
}
-(void)giveGift:(GiveGiftAlertView *)alertView withGiftInfo:(NSDictionary *)giftInfo{
    if (giftInfo) {
        self.giveInfo=giftInfo;
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定赠送该礼物？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
}
-(void)miss:(UIGestureRecognizer*)tap{
    [self.mask removeFromSuperview];
}
-(void)moveToMarketCenter{
    [self.mask removeFromSuperview];
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreCenterViewController * vc=[sb instantiateViewControllerWithIdentifier:@"market"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        SendGiftToVideoRequest * request =[[SendGiftToVideoRequest alloc]init];
        request.videoId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"videoId"]];
        request.num=@"1";
        request.itemId=[NSString stringWithFormat:@"%@",[self.giveInfo objectForKey:@"itemId"]];
        [SystemAPI SendGiftToVideoRequest:request success:^(SendGiftToVideoResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view.window];
            [self loadGiftList];
            [self.mask removeFromSuperview];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
}
- (IBAction)showHomePage:(id)sender {
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"memberId"]];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击评论头像 显示个人主页
-(void)showHomePageWithCell:(VideoCommnetsListTableViewCell *)cell{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=cell.memberId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shareSocialAction:(id)sender {
    self.mask=[[UIView alloc]initWithFrame:self.view.window.bounds];
    self.mask.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss:)];
    [self.mask addGestureRecognizer:tap];
    [self.view addSubview:self.mask];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShareAlertView"owner:self options:nil];
    ShareAlertView * view = [nib objectAtIndex:0];
    view.delegate=self;
    view.mark=@"share";
    view.frame=CGRectMake(0, DEVICE_HEIGHT-200, DEVCE_WITH, 200);
    [self.mask addSubview:view];
}
-(void)shareAlertView:(ShareAlertView *)alertView didSelectedAtButtonIndex:(NSInteger)buttonIndex{
    //xxTea 加密
    NSString * key =@"yckjyxgs!@#$%321";
  const   char * charKey =[key cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    //url
    NSString * praUrl=[self.detailsInfo objectForKey:@"videoUrl"];
    const char * charPraUrl =[praUrl cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    char * parResult =encryptxxtea(charPraUrl, charKey);
    NSString * enPraUrl=[NSString stringWithCString:parResult encoding:NSStringEncodingConversionAllowLossy];
    //screen
    NSString * praScreen=[self.detailsInfo objectForKey:@"videoUrl"];
    const char * charPraScreen =[praScreen cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    char * parResult2 =encryptxxtea(charPraScreen, charKey);
    NSString * enPraUrl2=[NSString stringWithCString:parResult2 encoding:NSStringEncodingConversionAllowLossy];
    
    NSString * videoUrl=[NSString stringWithFormat:@"http://xy.immet.cm/xy/video.jsp?video=%@&pic=%@",enPraUrl,enPraUrl2];
    NSString * content=@"我在相遇，赶紧来看这逗B小视频吧，猛戳播放！";
    NSString * title =@"相遇";
    //wechat
    if (buttonIndex==0) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = videoUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];

    }
    //sina
    if (buttonIndex==1) {
        UMSocialUrlResource * resource =[[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeVideo url:videoUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    //qq
    if (buttonIndex==2) {
        [UMSocialData defaultData].extConfig.qqData.url = videoUrl;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    //friendCircle
    if (buttonIndex==3) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = videoUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];

    }
}
@end
