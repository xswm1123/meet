//
//  PersonalHomePageViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "HomeFilesTableViewCell.h"
#import "HomeGroupsTableViewCell.h"
#import "HomeVideoTableViewCell.h"
#import "HomeStoresTableViewCell.h"
#import "GiftListTableViewCell.h"
#import "AddFriendViewController.h"
#import "GiveGiftAlertView.h"
#import "MyVideosViewController.h"
#import "MyCollectedStoresViewController.h"
#import "RCDChatViewController.h"
#import "MyVideosTableViewCell.h"
#import "FriendCircleViewController.h"
#import "StoreCenterViewController.h"
#import "PersonalFriendCircleViewController.h"

#define Files @"filesCell"
#define Groups @"groupsCell"
#define Video @"videoCell"
#define Stores @"storesCell"
#define Gifts @"giftsCell"
#define videoL @"videoList"

@interface PersonalHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,GiveGiftAlertDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_cityAndAge;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconSex;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconGift;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconCircle;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconMessage;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconZan;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconVideo;
@property (weak, nonatomic) IBOutlet UILabel *lb_meili;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_homePage;
@property (weak, nonatomic) IBOutlet UIButton *btn_groups;
@property (weak, nonatomic) IBOutlet UIButton *btn_albums;
@property (weak, nonatomic) IBOutlet UIButton *btn_gifts;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *btnBgs;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *btnBgs_all;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starToMeiliDistance;
@property (nonatomic,strong) UILabel * rightLabel;
@property (nonatomic,strong) UIScrollView * imageScroll;
@property (nonatomic,strong) NSArray * filesArr;
@property (nonatomic,strong) NSArray * JoinedGroupsArr;
@property (nonatomic,strong) NSArray * CreatedGroupsArr;
@property (nonatomic,strong) NSMutableArray * albumArr;
@property (nonatomic,strong) NSArray * giftsArr;
@property (nonatomic,strong) NSDictionary * detailsInfoDic;
//data
@property (nonatomic,strong) NSArray * filesOptions;
@property (nonatomic,strong) NSArray * picList;
@property (nonatomic,strong) NSMutableArray * albumList;
@property (nonatomic,assign) BOOL isCanViewAll;
//video
@property (nonatomic,strong) NSMutableArray * videoList;
//send gift
@property (nonatomic,strong) UIView * mask;
@property (nonatomic,strong) GiveGiftAlertView * giveView;
@property (nonatomic,strong) NSDictionary * giveInfo;
//pic
@property (nonatomic,strong) UIImage * photoImage;
@property (nonatomic,strong) NSMutableArray * showImageIVs;
@property (nonatomic,strong) NSMutableArray * photos;
@property (nonatomic,strong) NSTimer * timer;
//photo
@property (nonatomic,strong) NSMutableArray * postImages;
@property (nonatomic,strong) NSMutableArray * imageIVs;
@property (nonatomic,strong) NSMutableArray * imageUrls;
@property (nonatomic,assign) NSInteger  imageCount;
@property (nonatomic,strong) UILabel * warningLabel;
@end
@implementation PersonalHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeFilesTableViewCell" bundle:nil] forCellReuseIdentifier:Files];
     [self.tableView registerNib:[UINib nibWithNibName:@"HomeGroupsTableViewCell" bundle:nil] forCellReuseIdentifier:Groups];
     [self.tableView registerNib:[UINib nibWithNibName:@"HomeVideoTableViewCell" bundle:nil] forCellReuseIdentifier:Video];
     [self.tableView registerNib:[UINib nibWithNibName:@"HomeStoresTableViewCell" bundle:nil] forCellReuseIdentifier:Stores];
    [self.tableView registerNib:[UINib nibWithNibName:@"GiftListTableViewCell" bundle:nil] forCellReuseIdentifier:Gifts];
     [self.tableView registerNib:[UINib nibWithNibName:@"MyVideosTableViewCell" bundle:nil] forCellReuseIdentifier:videoL];
}
-(void)initView{
     //提示如果没有照片 点击添加
    self.warningLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, self.coverImageView.frame.size.height/2,DEVCE_WITH, 20)];
    self.warningLabel.text=@"点击上传相册照片";
    self.warningLabel.textAlignment=NSTextAlignmentCenter;
    self.warningLabel.textColor=[UIColor lightGrayColor];
    [self.scrollView addSubview:self.warningLabel];
    
    
    self.tableView.backgroundColor=NAVI_COLOR;
    self.bannerView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    if (!self.memberId.length>0||[self.memberId isEqualToString:[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.id]]) {
        self.bottomView.hidden=YES;
        self.warningLabel.hidden=YES;
    }
    self.lb_iconZan.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.lb_iconZan.font=[UIFont fontWithName:iconFont size:15];
    self.lb_iconVideo.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.lb_iconVideo.font=[UIFont fontWithName:iconFont size:15];
    self.lb_iconVideo.text=@"  \U0000e609";
    self.lb_iconSex.font=[UIFont fontWithName:iconFont size:18];
    //bottomView label
    self.lb_iconGift.font=[UIFont fontWithName:iconFont size:24];
    NSString * gift=@"\U0000e61b";
    NSString * allGift=[NSString stringWithFormat:@"%@送礼物",gift];
    NSMutableAttributedString * Gatt=[[NSMutableAttributedString alloc]initWithString:allGift];
    [Gatt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:24],NSForegroundColorAttributeName:iconRed} range:NSMakeRange(0, gift.length)];
    [Gatt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(gift.length, allGift.length-gift.length)];
    self.lb_iconGift.attributedText=Gatt;

    self.lb_iconCircle.font=[UIFont fontWithName:iconFont size:24];
    NSString * Circle=@"\U0000e60d";
    NSString * allCircle=[NSString stringWithFormat:@"%@好友圈",Circle];
    NSMutableAttributedString * Catt=[[NSMutableAttributedString alloc]initWithString:allCircle];
    [Catt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:24],NSForegroundColorAttributeName:iconGreen} range:NSMakeRange(0, Circle.length)];
    [Catt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(Circle.length, allCircle.length-Circle.length)];
    self.lb_iconCircle.attributedText=Catt;
    
    self.lb_iconMessage.font=[UIFont fontWithName:iconFont size:24];
    NSString * Message=@"\U0000e61a";
    NSString * allMessage=[NSString stringWithFormat:@"%@发消息",Message];
    NSMutableAttributedString * Matt=[[NSMutableAttributedString alloc]initWithString:allMessage];
    [Matt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:24],NSForegroundColorAttributeName:iconBlue} range:NSMakeRange(0, Message.length)];
    [Matt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(Message.length, allMessage.length-Message.length)];
    self.lb_iconMessage.attributedText=Matt;
    
    [self clear];
    self.btn_homePage.selected=YES;
    self.btn_homePage.backgroundColor=cellColor;
    UIView * fview=[self.btnBgs objectAtIndex:0];
    fview.backgroundColor=TempleColor;
    
    /**
     *  添加右边按钮
     *
     */
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    self.rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    self.rightLabel.font=[UIFont fontWithName:iconFont size:25];
    self.rightLabel.text=@"\U0000e601";
    self.rightLabel.textColor=TempleColor;
    self.rightLabel.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:self.rightLabel];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
    self.rightLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFriend)];
    [self.rightLabel addGestureRecognizer:tapRight];
    /**
     *  init data
     */
    self.filesOptions=@[@"等级身份",@"个人财富",@"相遇ID",@"个性签名",@"感情状况",@"外貌特点",@"职业性质",@"兴趣爱好"];
    /**
     *  加载默认的数据
     */
    [self loadDefaultData];
    /**
     *  创建展示照片scroll
     *
     */
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.imageScroll removeFromSuperview];
    self.imageScroll=[[UIScrollView alloc]initWithFrame:self.tableView.frame];
    self.imageScroll.showsHorizontalScrollIndicator=NO;
    self.imageScroll.showsVerticalScrollIndicator=NO;
    self.imageScroll.backgroundColor=[UIColor clearColor];
    if ([self.btn_albums isSelected]) {
        [self showImages];
    }
    
}
-(void)loadDefaultData{
    GetHomePageInfoRequest * request  = [[GetHomePageInfoRequest alloc]init];
    if (!self.memberId) {
        /**
         *  加载自己的数据
         */
        request.targetId=[ShareValue shareInstance].userInfo.id;
        
    }else{
        /**
         *  加载目标的ID数据
         */
        request.targetId=self.memberId;
    }
    [SystemAPI GetHomePageInfoRequest:request success:^(GetHomePageInfoResponse *response) {
        NSDictionary * infoDic=response.data;
        self.detailsInfoDic = [response.data copy];
        [self.btn_albums setTitle:[NSString stringWithFormat:@"相册(%@)",[infoDic objectForKey:@"picCount"]] forState:UIControlStateNormal];
        
        self.lb_iconZan.text=[NSString stringWithFormat:@"  \U0000e61e%@",[infoDic objectForKey:@"zanCount"]];
        self.lb_meili.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"meili"]];
        //标题   头像
        self.navigationItem.title=[infoDic objectForKey:@"nickname"];
        [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"avatar"]] placeholderImage:placeHolder];
        NSArray * imgArr=[infoDic objectForKey:@"picUrlList"];
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[imgArr firstObject]] placeholderImage:circlePlaceHolder];
        self.filesArr=@[[infoDic objectForKey:@"level"],[infoDic objectForKey:@"gold"],[infoDic objectForKey:@"meetid"],[infoDic objectForKey:@"sign"],[infoDic objectForKey:@"affection"],[infoDic objectForKey:@"appearance"],[infoDic objectForKey:@"profession"],[infoDic objectForKey:@"hobby"]];
        //地址
        NSString * address=[infoDic objectForKey:@"address"];
        NSArray * arr=[address componentsSeparatedByString:@"市"];
        NSString* add=[NSString stringWithFormat:@"%@市",[arr firstObject]];
        self.lb_cityAndAge.text=[NSString stringWithFormat:@"%@",add];
        self.lb_cityAndAge.text=[self.lb_cityAndAge.text stringByAppendingString:[NSString stringWithFormat:@"%@岁",[infoDic objectForKey:@"age"]]];
        //处理star
        int starCount=[[infoDic objectForKey:@"star"] intValue];
        for (int i =0; i<5; i++) {
            UIImageView * im=[self.stars objectAtIndex:i];
            if (i<starCount) {
                im.hidden=NO;
            }else{
                im.hidden=YES;
            }
        }
        self.starToMeiliDistance.constant=220-20*(5-starCount);
        [self updateViewConstraints];
        //性别 1nan 2nv
        NSString * sex=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sex"]];
        if ([sex isEqualToString:@"1"]) {
            self.lb_iconSex.textColor=iconGreen;
            self.lb_iconSex.text=@"\U0000e617";
        }else{
            self.lb_iconSex.textColor=iconRed;
            self.lb_iconSex.text=@"\U0000e616";
        }
        //是否可以加好友
        if (![[infoDic objectForKey:@"canAddFriend"] intValue]) {
            //            self.rightLabel.text=@"";
            self.rightLabel.hidden=YES;
        }else{
            //            self.rightLabel.text=@"\U0000e601";
            self.rightLabel.hidden=NO;
        }
        //照片
        self.picList=[NSArray arrayWithArray:(NSArray*)[infoDic objectForKey:@"picUrlList"]];
        [self showRandomCoverImage];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showRandomCoverImage) userInfo:nil repeats:YES];
        if (!self.picList.count>0) {
            self.warningLabel.hidden=NO;
        }else{
             self.warningLabel.hidden=YES;
        }
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    //加载相册
    GetHomePageAlbumRequest * alr=[[GetHomePageAlbumRequest alloc]init];
    if (self.memberId.length>0) {
        alr.targetId=self.memberId;
    }else{
        alr.targetId=[ShareValue shareInstance].userInfo.id;
    }
    [SystemAPI GetHomePageAlbumRequest:alr success:^(GetHomePageAlbumResponse *response) {
        self.albumList= [NSMutableArray arrayWithArray:[response.data objectForKey:@"picUrlList"]];
        self.isCanViewAll=[[response.data objectForKey:@"canViewAll"] boolValue];
        if (!self.isCanViewAll) {
            if (self.albumList.count>8) {
                [self.albumList removeObjectsInRange:NSMakeRange(8, self.albumList.count-8)];
            }
        }
        if ([self.btn_albums isSelected]) {
            [self showImages];
        }
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)showRandomCoverImage{
    if (self.picList.count>0) {
        int random = arc4random()%self.picList.count;
        [UIView animateWithDuration:0.5 animations:^{
            self.coverImageView.alpha=0.1;
        } completion:^(BOOL finished) {
            [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[self.picList objectAtIndex:random]]];
            [UIView animateWithDuration:1 animations:^{
                self.coverImageView.alpha=1;
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer=nil;
   
}
/**
 *  加好友
 */
-(void)addFriend{
    [self performSegueWithIdentifier:@"addFriend" sender:self.memberId];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addFriend"]) {
        AddFriendViewController * vc=segue.destinationViewController;
        vc.memberId=sender;
    }
    if ([segue.identifier isEqualToString:@"video"]) {
        MyVideosViewController * vc=segue.destinationViewController;
        if (self.memberId.length>0) {
            vc.memberId=self.memberId;
        }else{
            vc.memberId=[ShareValue shareInstance].userInfo.id;
        }
        
    }
    if ([segue.identifier isEqualToString:@"collect"]) {
        MyCollectedStoresViewController * vc=segue.destinationViewController;
        if (self.memberId.length>0) {
            vc.memberId=self.memberId;
        }else{
            vc.memberId=[ShareValue shareInstance].userInfo.id;
        }

    }
    if ([segue.identifier isEqualToString:@"friendCircle"]) {
        PersonalFriendCircleViewController * vc=[segue  destinationViewController];
        vc.memberId=sender;
    }
    
}
-(void)clear{
    for (UIView * view in self.btnBgs_all) {
        view.backgroundColor=cellColor;
    }
    for (UIView * view in self.btnBgs) {
        view.backgroundColor=[UIColor clearColor];
    }
    for (UIButton * btn in self.allBtns) {
        btn.backgroundColor=[UIColor clearColor];
        btn.selected=NO;
    }
}
- (IBAction)showHomePage:(id)sender {
    [self clear];
    self.btn_homePage.selected=YES;
    self.btn_homePage.backgroundColor=cellColor;
    UIView * fview=[self.btnBgs objectAtIndex:0];
    fview.backgroundColor=TempleColor;
    self.imageScroll.hidden=YES;
     self.tableView.hidden=NO;
    self.tableView.scrollEnabled=NO;
    [self.tableView reloadData];
}
- (IBAction)showGroups:(id)sender {
    [self clear];
    self.btn_groups.selected=YES;
    self.btn_groups.backgroundColor=cellColor;
    UIView * fview=[self.btnBgs objectAtIndex:1];
    fview.backgroundColor=TempleColor;
     self.imageScroll.hidden=YES;
     self.tableView.hidden=NO;
    self.tableView.scrollEnabled=YES;
     [self.tableView reloadData];
   
    GetMyVideosRequest * request =[[GetMyVideosRequest alloc]init];
    if (self.memberId.length>0 ) {
        request.memberId=self.memberId;
    }else{
        request.memberId=[ShareValue shareInstance].userInfo.id;
    }
    request.pageSize=@"50";
    [SystemAPI GetMyVideosRequest:request success:^(GetMyVideosResponse *response) {
        self.videoList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        
    }];

    
}
- (IBAction)showAlbums:(id)sender {
    [self clear];
    self.btn_albums.selected=YES;
    self.btn_albums.backgroundColor=cellColor;
    UIView * fview=[self.btnBgs objectAtIndex:2];
    fview.backgroundColor=TempleColor;
    self.imageScroll.hidden=NO;
    self.tableView.hidden=YES;
    [self showImages];
}
-(void)showImages{
    self.showImageIVs=[NSMutableArray array];
    NSArray * subs=[self.imageScroll subviews];
    for (id view in subs) {
        [view removeFromSuperview];
    }
    CGFloat imageWidth=(DEVCE_WITH-50)/4;
    for (int i =0; i<self.albumList.count; i++) {
        UIImageView * imageView=[[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.albumList objectAtIndex:i]] placeholderImage:placeHolder];
        imageView.frame=CGRectMake(10+(imageWidth+10)*(i%4), 10+(imageWidth+10)*(i/4), imageWidth, imageWidth);
        imageView.userInteractionEnabled=YES;
        imageView.tag=i;
        [self.imageScroll addSubview:imageView];
        [self.showImageIVs addObject:imageView];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewImages:)]];
        if (!self.memberId.length>0) {
            UILongPressGestureRecognizer * longp=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAlbum:)];
            [imageView addGestureRecognizer:longp];
        }
    }
    self.imageScroll.contentSize=CGSizeMake(DEVCE_WITH, 10+(imageWidth+10)*(self.albumList.count/4));
    [self.scrollView addSubview:self.imageScroll];
}
-(void)deleteAlbum:(UILongPressGestureRecognizer*) press{
    UIImageView * imv=(UIImageView*)press.view;
    switch (press.state) {
        case UIGestureRecognizerStateEnded:
            [self showAlertDeleteWithTag:imv.tag];
            break;
            
        default:
            break;
    }
}
-(void)showAlertDeleteWithTag:(NSInteger)tag{
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=tag+10000;
    [al show];
}

-(void)deleteAlbumActionWithIndex:(NSInteger)index{
  NSString * picUrl=  [self.albumList objectAtIndex:index];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DeleteHomePageAlbumRequest * request =[[DeleteHomePageAlbumRequest alloc]init];
    request.picUrl=picUrl;
    [SystemAPI DeleteHomePageAlbumRequest:request success:^(DeleteHomePageAlbumResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self loadDefaultData];
    } fail:^(BOOL notReachable, NSString *desciption) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
-(void)reviewImages:(UIGestureRecognizer*)tap{
    UIImageView * imageView =(UIImageView*)tap.view;
        self.photos=[NSMutableArray array];
        for (UIImageView * image in self.showImageIVs) {
            MWPhoto * photo=[MWPhoto photoWithImage:image.image];
            [self.photos addObject:photo];
        }
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = YES;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.startOnGrid = YES;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:imageView.tag];
        [self.navigationController pushViewController:browser animated:YES];
}
#pragma MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.showImageIVs.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (IBAction)showGifts:(id)sender {
    [self clear];
    self.btn_gifts.selected=YES;
    self.btn_gifts.backgroundColor=cellColor;
    UIView * fview=[self.btnBgs objectAtIndex:3];
    fview.backgroundColor=TempleColor;
     self.imageScroll.hidden=YES;
    self.tableView.hidden=NO;
    self.tableView.scrollEnabled=NO;
    [self.tableView reloadData];
    GetHomePageGiftsRequest * request=[[GetHomePageGiftsRequest alloc]init];
    if (!self.memberId) {
        /**
         *  加载自己的数据
         */
        request.memberId=[ShareValue shareInstance].userInfo.id;
        
    }else{
        /**
         *  加载目标的ID数据
         */
        request.memberId=self.memberId;
    }
    [SystemAPI GetHomePageGiftsRequest:request success:^(GetHomePageGiftsResponse *response) {
        self.giftsArr=(NSArray *)response.data;
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];

}
#pragma tableView delegate 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.btn_homePage isSelected]) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.btn_homePage isSelected]) {
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                HomeStoresTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Stores];
                cell.lb_count.text=[NSString stringWithFormat:@"%@",[self.detailsInfoDic objectForKey:@"collectStoreCount"]];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.list=[self.detailsInfoDic objectForKey:@"collectStorePicUrlList"];
                return cell;
            }
        }
        if (indexPath.section==0) {
            HomeFilesTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Files];
            cell.marks.text=[self.filesOptions objectAtIndex:indexPath.row];
            NSString * option =[NSString stringWithFormat:@"%@",[self.filesArr objectAtIndex:indexPath.row]];
            if (indexPath.row==0) {
                cell.level=[[self.detailsInfoDic objectForKey:@"level"] integerValue];
                cell.type=[[self.detailsInfoDic objectForKey:@"type"] integerValue];
            }else{
                cell.desc.text=option;
            }
            cell.marks.text=[self.filesOptions objectAtIndex:indexPath.row];
            return cell;
        }
    }
    if ([self.btn_groups isSelected]) {
        MyVideosTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:videoL];
        if (!cell) {
            cell=[[MyVideosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoL];
        }
        NSDictionary * dic =[self.videoList objectAtIndex:indexPath.row];
        cell.infoDic=dic;
        return cell;
    }
    if ([self.btn_albums isSelected]) {
        UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce"];
        return cell;
    }
    if ([self.btn_gifts isSelected]) {
        GiftListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Gifts];
        NSDictionary * dic=[self.giftsArr objectAtIndex:indexPath.row];
        cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
        cell.lb_desc.text=[dic objectForKey:@"summary"];
        cell.lb_goldCount.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
        cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
        cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.btn_homePage isSelected]) {
        if (indexPath.section==0) {
            return 50;
        }
        if (indexPath.section==1) {
            return 80;
        }
    }
    if ([self.btn_groups isSelected]) {
        return 90;
    }
    if ([self.btn_gifts isSelected]) {
        return 70;
    }
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.btn_homePage isSelected]) {
        if (section==0) {
            return 8;
        }
        if (section==1) {
            return 1;
        }
    }
    if ([self.btn_gifts isSelected]) {
        return self.giftsArr.count;
    }
    if ([self.btn_groups isSelected]) {
        return self.videoList.count;
    }
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //个人资料
    if ([self.btn_homePage isSelected]) {
        if (indexPath.section==1) {
//            if (indexPath.row==0) {
//                [self performSegueWithIdentifier:@"video" sender:nil];
//            }
            if (indexPath.row==0) {
                [self performSegueWithIdentifier:@"collect" sender:nil];
            }
        }
    }
    //视频
    if ([self.btn_groups isSelected]) {
        NSDictionary * dic =[self.videoList objectAtIndex:indexPath.row];
        NSString *urlStr=[dic objectForKey:@"video"];
        urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self presentMoviePlayerViewControllerAnimated:movieViewController];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor=[UIColor clearColor];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.btn_homePage isSelected]) {
        return 20;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorColor:NAVI_COLOR];
    if ([self.btn_homePage isSelected]) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
}
/**
 *  删除视频
 *
 */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.btn_groups isSelected]) {
        int srcId=self.memberId.intValue;
        int tarId =[ShareValue shareInstance].userInfo.id.intValue;
        if (srcId==tarId) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic =[self.videoList objectAtIndex:indexPath.row];
    DeleteMyVideoRequest * request =[[DeleteMyVideoRequest alloc]init];
    request.videoId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [SystemAPI DeleteMyVideoRequest:request success:^(DeleteMyVideoResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.videoList removeObject:dic];
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

- (IBAction)showFriendCircle:(id)sender {
    [self performSegueWithIdentifier:@"friendCircle" sender:self.memberId];
}
- (IBAction)sendGiftAction:(UITapGestureRecognizer *)sender {
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
-(void)moveToMarketCenter{
    [self.mask removeFromSuperview];
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreCenterViewController * vc=[sb instantiateViewControllerWithIdentifier:@"market"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)miss:(UIGestureRecognizer*)tap{
    [self.mask removeFromSuperview];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag>=10000) {
        if (buttonIndex==1) {
            [self deleteAlbumActionWithIndex:alertView.tag-10000];
        }
    }else{
    if (buttonIndex==1) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        SendGiftToPersonRequest * request =[[SendGiftToPersonRequest alloc]init];
        request.memberId=[NSString stringWithFormat:@"%@",self.memberId];
        request.num=@"1";
        request.itemId=[NSString stringWithFormat:@"%@",[self.giveInfo objectForKey:@"itemId"]];
        [SystemAPI SendGiftToPersonRequest:request success:^(SendGiftToPersonResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view.window];
            [self showGifts:nil];
            [self.mask removeFromSuperview];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
    }
}
- (IBAction)sendMessageAction:(id)sender {
    RCConversationModel * model=[[RCConversationModel alloc]init:
                                 RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
    model.conversationType=ConversationType_PRIVATE;
    model.targetId= [NSString stringWithFormat:@"%@",[self.detailsInfoDic objectForKey:@"memberId"]];
    model.conversationTitle=[self.detailsInfoDic objectForKey:@"nickname"];
    model.senderUserId=[ShareValue shareInstance].userInfo.id;
    model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = [NSString stringWithFormat:@"%@",[self.detailsInfoDic objectForKey:@"memberId"]];
    _conversationVC.userName = [self.detailsInfoDic objectForKey:@"nickname"];
    _conversationVC.title = [self.detailsInfoDic objectForKey:@"nickname"];
    _conversationVC.conversation = model;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    [self.navigationController pushViewController:_conversationVC animated:YES];
}
- (IBAction)zanAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GiveZanRequest * request=[[GiveZanRequest alloc]init];
    if (self.memberId.length>0) {
        request.targetId=self.memberId;
    }else{
        request.targetId=[ShareValue shareInstance].userInfo.id;
    }
    [SystemAPI GiveZanRequest:request success:^(GiveZanResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self loadDefaultData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
    
}
- (IBAction)showVideoAction:(id)sender {
    NSDictionary * dic =[self.detailsInfoDic objectForKey:@"video"];
    NSString * videoUrl =[dic objectForKey:@"video"];
    videoUrl=[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:videoUrl];
    MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [self presentMoviePlayerViewControllerAnimated:movieViewController];
}
//上传封面相册
- (IBAction)uploadPicsAction:(id)sender {
    if (!self.memberId.length>0) {
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
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    self.postImages=[NSMutableArray array];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                [self.postImages addObject:tempImg];
        }
    self.imageUrls=[NSMutableArray array];
    self.imageCount=self.postImages.count;
    [self uploadPostImages];
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
}
-(void)uploadPostImages{
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    UIImage * imv=self.postImages[self.imageCount-1];
    UIImage * upImage=[ImageInfo makeThumbnailFromImage:imv scale:0.5];
    ImageInfo * details=[[ImageInfo alloc]initWithImage:upImage];
    [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
        NSArray * arr=(NSArray*)response.data;
        NSString* url=[arr firstObject];
        [self.imageUrls addObject:url];
        --self.imageCount;
        if (self.imageCount>0) {
            [self uploadPostImages];
            
        }else{
            [self createGroup];
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        
    } class:[UploadFilesResponse class]];
}
-(void)createGroup{
    /**
     创建
     */
    UploadHomePagePicsRequest * request =[[UploadHomePagePicsRequest alloc]init];
    NSString* urls=[[NSString alloc]init];
    for (int i =0 ; i<self.imageUrls.count; i++) {
        if (i==0) {
            urls=[urls stringByAppendingString:[self.imageUrls objectAtIndex:i]];
        }else{
            urls=[urls stringByAppendingString:[NSString stringWithFormat:@",%@",[self.imageUrls objectAtIndex:i]]];
        }
    }
    request.pic=urls;
        [SystemAPI  UploadHomePagePicsRequest:request success:^(UploadHomePagePicsResponse *response) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:response.message toView:ShareAppDelegate.window];
            [self loadDefaultData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
}
@end
