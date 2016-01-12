//
//  StoreDetailsViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "StoreDetailsInfoTableViewCell.h"
#import "VideoCommnetsListTableViewCell.h"
#import "GiftListTableViewCell.h"
#import "GiveGiftAlertView.h"
#import "StoreCenterViewController.h"
#import "RCDChatViewController.h"
#import "PersonalHomePageViewController.h"

#define INFO_CELL @"INFO_CELL"
#define COMMENT_CELL @"COMMENT_CELL"
#define GIFT_CELL @"GIFT_CELL"

@interface StoreDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,GiveGiftAlertDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *infoBG;
@property (weak, nonatomic) IBOutlet BaseView *btnsBG;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BaseView *inputView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconGift;
@property (weak, nonatomic) IBOutlet UILabel *lb_meiliCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_distance;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_groupName;
@property (weak, nonatomic) IBOutlet UIButton *applyStoreBtn;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *btnBgs;
@property (weak, nonatomic) IBOutlet UIButton *storeInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_comment;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *infoBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomDistance;
//data
@property (nonatomic,assign) BOOL isCollect;
@property (nonatomic,strong) UIBarButtonItem * rightItem;
@property (nonatomic,strong) UILabel * rightLb;
@property (nonatomic,strong) NSString * storeDesc;
@property (nonatomic,strong) NSMutableArray * commentLists;
@property (nonatomic,strong) NSMutableArray * giftLists;
@property (nonatomic,strong) NSArray * picList;
@property (nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray * photos;
@property (nonatomic,strong) NSDictionary * detailsInfo;
//give gift
@property (nonatomic,strong) UIView * mask;
@property (nonatomic,strong) GiveGiftAlertView * giveView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBGHeightConstant;
@property (nonatomic,strong) NSDictionary * giveInfo;
@end

@implementation StoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadDatas];
    // Do any additional setup after loading the view.
}
/**
 加载数据
 */
-(void)loadDatas{
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@""]];
    self.lb_name.text=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"title"]];
    self.lb_meiliCount.text=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"meili"]];
    self.lb_price.text=[NSString stringWithFormat:@"人均:￥%@",[self.infoDic objectForKey:@"price"]];
    self.lb_distance.font=[UIFont fontWithName:iconFont size:18];
    self.lb_distance.text=@"\U0000e60f";
    self.lb_distance.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
    NSString * names=[NSString stringWithFormat:@"%@%@",@"\U0000e60f",[self.infoDic objectForKey:@"distance"]];
    NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
    [str addAttribute:NSForegroundColorAttributeName value:iconBlue range:NSMakeRange(0, self.lb_distance.text.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(self.lb_distance.text.length, str.length-self.lb_distance.text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(self.lb_distance.text.length, str.length-self.lb_distance.text.length)];
    self.lb_distance.attributedText=str;
    //请求详情
    GetStoreDetailsRequest * request=[[GetStoreDetailsRequest alloc]init];
    request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
    [SystemAPI GetStoreDetailsRequest:request success:^(GetStoreDetailsResponse *response) {
        self.detailsInfo=[NSDictionary dictionaryWithDictionary:response.data];
        if ([[response.data objectForKey:@"memberId"] isKindOfClass:[NSNull class]]) {
            self.infoBGHeightConstant.constant=218-45;
        }else{
            self.infoBGHeightConstant.constant=218;
        }
        [self updateViewConstraints];
        self.lb_address.text=[NSString stringWithFormat:@"%@",[response.data objectForKey:@"address"]];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"评论%@",[response.data objectForKey:@"commentNum"]] forState:UIControlStateNormal];
        [self.giftBtn setTitle:[NSString stringWithFormat:@"礼物%@",[response.data objectForKey:@"itemValue"]] forState:UIControlStateNormal];
         self.lb_phoneNumber.text=[NSString stringWithFormat:@"%@",[response.data objectForKey:@"phone"]];
        self.isCollect=[[NSString stringWithFormat:@"%@",[response.data objectForKey:@"isCollect"]] boolValue];
        self.picList=[response.data objectForKey:@"picUrlList"];
        [self loadPhotos];
        if (self.isCollect) {
            self.rightLb.textColor=TempleColor;
        }
        NSArray * groups=[response.data objectForKey:@"groupList"];
        NSString* name=[[NSString alloc]init];
        for (NSDictionary * dic in groups) {
            name=[name stringByAppendingString:[NSString stringWithFormat:@"  %@",[dic objectForKey:@"name"]]];
        }
        self.lb_groupName.text=name;
        
        self.storeDesc=[NSString stringWithFormat:@"%@",[response.data objectForKey:@"description"]];
        if (!self.storeDesc.length>0) {
            self.storeDesc=@"暂无商家信息";
        }
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
    
}
/**
 加载评论信息
 */
-(void)loadComments{
    GetStoreCommentsListRequest * request=[[GetStoreCommentsListRequest alloc]init];
    request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
    request.pageSize=@"1000";
    [SystemAPI GetStoreCommentsListRequest:request success:^(GetStoreCommentsListResponse *response) {
        self.commentLists=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
}
/**
 加载礼物列表
 */
-(void)loadGifts{
    GetStoreReceivedGiftListRequest * request=[[GetStoreReceivedGiftListRequest alloc]init];
    request.pageSize=@"1000";
     request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
    [SystemAPI GetStoreReceivedGiftListRequest:request success:^(GetStoreReceivedGiftListResponse *response) {
        self.giftLists =[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.giftBtn setTitle:[NSString stringWithFormat:@"礼物%d",(int)self.giftLists.count] forState:UIControlStateNormal];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
}
/**
 *  初始化界面
 */
-(void)initView{
    self.scrollView.backgroundColor=NAVI_COLOR;
    self.tableView.backgroundColor=NAVI_COLOR;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.separatorColor=NAVI_COLOR;
    self.lb_iconGift.font=[UIFont fontWithName:iconFont size:28];
    self.lb_iconGift.text=@"\U0000e61b";
    self.lb_iconGift.textColor=TempleColor;
    //rightItem
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    self.rightLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    self.rightLb.font=[UIFont fontWithName:iconFont size:30];
    self.rightLb.text=@"\U0000e607";
    self.rightLb.textColor=[UIColor lightGrayColor];
    self.rightLb.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:self.rightLb];
    self.rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=self.rightItem;
    self.rightLb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectStore)];
    [self.rightLb addGestureRecognizer:tapRight];
    /**
     *  btns
     */
    self.storeInfoBtn.selected=YES;
    self.inputView.hidden=YES;
    self.tableViewBottomDistance.constant=2;
    [self updateViewConstraints];
    //tableView 默认注册detailsInfoCell
    self.tableView.estimatedRowHeight = 60;
    self.tableView.fd_debugLogEnabled = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:INFO_CELL];
    for (UIButton * btn in self.infoBtns) {
        btn.backgroundColor=cellColor;
    }
    for (UIView * view in self.btnBgs) {
        view.backgroundColor=cellColor;
    }
    UIView * fview=[self.btnBgs objectAtIndex:0 ];
    fview.backgroundColor=TempleColor;
    self.callBtn.layer.cornerRadius=5;
    self.callBtn.layer.borderColor=iconGreen.CGColor;
    self.callBtn.layer.borderWidth=1;
    [self.callBtn setTitleColor:iconGreen forState:UIControlStateNormal];
    
    self.chatBtn.layer.cornerRadius=5;
    self.chatBtn.layer.borderColor=TempleColor.CGColor;
    self.chatBtn.layer.borderWidth=1;
     [self.chatBtn setTitleColor:TempleColor forState:UIControlStateNormal];
}
/**
 *  收藏商家
 */
-(void)collectStore{
//    if (self.isCollect) {
//        [MBProgressHUD showMessag:@"亲，您已经收藏过该店铺啦~" toView:self.view.window];
//    }else{
        CollectStoreRequest * request=[[CollectStoreRequest alloc]init];
         request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
        [SystemAPI CollectStoreRequest:request success:^(CollectStoreResponse *response) {
            self.rightLb.textColor=TempleColor;
            [MBProgressHUD showSuccess:response.message toView:self.view.window];
        } fail:^(BOOL notReachable, NSString *desciption) {
             [MBProgressHUD showError:desciption toView:self.view.window];
        }];
//    }
}
/**
 *  送礼物
 */
- (IBAction)giveGiftAction:(id)sender {
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
        al.tag=500;
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
/**
 *  一键拨号
 */
- (IBAction)callStoreAction:(id)sender {
    NSString * message=[NSString stringWithFormat:@"您是否确定要拨打此商家的号码:%@",self.lb_phoneNumber.text];
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:message  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            SendGiftToStoreRequest * request =[[SendGiftToStoreRequest alloc]init];
            request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
            request.num=@"1";
            request.itemId=[NSString stringWithFormat:@"%@",[self.giveInfo objectForKey:@"itemId"]];
            [SystemAPI SendGiftToStoreRequest:request success:^(SendGiftToStoreResponse *response) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [MBProgressHUD showSuccess:response.message toView:self.view.window];
                [self loadGifts];
                [self.mask removeFromSuperview];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [MBProgressHUD showError:desciption toView:self.view.window];
            }];
        }
    }else{
        if (buttonIndex==1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.lb_phoneNumber.text]]];
        }

    }
}
/**
 *  申请加入
 */
- (IBAction)applyJoinInStore:(id)sender {
}
/**
 *  商家信息
 */
- (IBAction)showStroeInfo:(id)sender {
     self.storeInfoBtn.selected=YES;
    self.inputView.hidden=YES;
    self.tableViewBottomDistance.constant=2;
    [self updateViewConstraints];
    self.commentBtn.selected=NO;
    self.giftBtn.selected=NO;
    for (int i=0 ; i<self.btnBgs.count; i++) {
        UIView * fview=[self.btnBgs objectAtIndex:i];
        if (i==0) {
            fview.backgroundColor=TempleColor;
        }else{
            fview.backgroundColor=[UIColor clearColor];
        }
    }
     [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:INFO_CELL];
    [self.tableView reloadData];
   
}
/**
 *  评论
 */
- (IBAction)showComment:(id)sender {
    self.storeInfoBtn.selected=NO;
    self.inputView.hidden=NO;
    self.tableViewBottomDistance.constant=38;
    [self updateViewConstraints];
    self.commentBtn.selected=YES;
    self.giftBtn.selected=NO;
    for (int i=0 ; i<self.btnBgs.count; i++) {
        UIView * fview=[self.btnBgs objectAtIndex:i];
        if (i==1) {
            fview.backgroundColor=TempleColor;
        }else{
            fview.backgroundColor=[UIColor clearColor];
        }
    }
     [self.tableView registerNib:[UINib nibWithNibName:@"VideoCommnetsListTableViewCell" bundle:nil] forCellReuseIdentifier:COMMENT_CELL];
//     [self.tableView reloadData];
     [self loadComments];
}

/**
 *  礼物
 */
- (IBAction)showGifts:(id)sender {
    self.storeInfoBtn.selected=NO;
    self.inputView.hidden=YES;
    self.tableViewBottomDistance.constant=2;
    [self updateViewConstraints];
    self.commentBtn.selected=NO;
    self.giftBtn.selected=YES;
    for (int i=0 ; i<self.btnBgs.count; i++) {
        UIView * fview=[self.btnBgs objectAtIndex:i];
        if (i==2) {
            fview.backgroundColor=TempleColor;
        }else{
            fview.backgroundColor=[UIColor clearColor];
        }
    }
     [self.tableView registerNib:[UINib nibWithNibName:@"GiftListTableViewCell" bundle:nil] forCellReuseIdentifier:GIFT_CELL];
//     [self.tableView reloadData];
    [self loadGifts];
}
/**
 *  评论商家
 */
- (IBAction)sendComment:(id)sender {
    
    if (self.tf_comment.text.length==0) {
        [MBProgressHUD showError:@"请输入评论内容！" toView:self.view.window];
        return;
    }
    CommentStoreRequest * request=[[CommentStoreRequest alloc]init];
     request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
     request.content=self.tf_comment.text;
    [SystemAPI CommentStoreRequest:request success:^(CommentStoreResponse *response) {
        [self showComment:nil];
        self.tf_comment.text=@"";
        [self.tf_comment resignFirstResponder];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD showError:desciption  toView:self.view.window];
    }];
}
/**
 *  监听键盘
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
//    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
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
        self.scrollViewBottomDistance.constant=keyboardFrame.size.height+20;
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
        self.scrollViewBottomDistance.constant=0.0;
        [self updateViewConstraints];
    } completion:nil];
}

#pragma tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.storeInfoBtn.selected==YES) {
        return 1;
    }
    if (self.commentBtn.selected==YES) {
        [self.commentBtn setTitle:[NSString stringWithFormat:@"评论%d",(int)self.commentLists.count] forState:UIControlStateNormal];
        return self.commentLists.count;
    }
    if (self.giftBtn.selected==YES) {
        return self.giftLists.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.storeInfoBtn.selected==YES) {
        return [tableView fd_heightForCellWithIdentifier:INFO_CELL cacheByIndexPath:indexPath configuration:^(StoreDetailsInfoTableViewCell* cell) {
            // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
           cell.info.text=self.storeDesc;
        }];
    }
    if (self.commentBtn.selected==YES) {
        return [tableView fd_heightForCellWithIdentifier:COMMENT_CELL cacheByIndexPath:indexPath configuration:^(VideoCommnetsListTableViewCell* cell) {
            // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
            NSDictionary * dic=[self.commentLists objectAtIndex:indexPath.row];
            cell.lb_name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
            cell.lb_content.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
            cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
            cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        }];;
    }
    if (self.giftBtn.selected==YES) {
        
        return 70;
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.storeInfoBtn.selected==YES) {
        StoreDetailsInfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:INFO_CELL];
       tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        cell.info.text=self.storeDesc;
        return cell;
    }
    if (self.commentBtn.selected==YES) {
        VideoCommnetsListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:COMMENT_CELL];
         tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        NSDictionary * dic=[self.commentLists objectAtIndex:indexPath.row];
        cell.lb_name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        cell.lb_content.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
        cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        return cell;
    }
    if (self.giftBtn.selected==YES) {
        GiftListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:GIFT_CELL];
         tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        NSDictionary * dic=[self.giftLists objectAtIndex:indexPath.row];
        cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
        cell.lb_desc.text=[NSString stringWithFormat:@"赠送“%@”%@个",[dic objectForKey:@"title"],[dic objectForKey:@"num"]];
        cell.lb_goldCount.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
        cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
        cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        return cell;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.commentBtn.selected==YES) {
        NSDictionary * dic=[self.commentLists objectAtIndex:indexPath.row];
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
        vc.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)loadPhotos{
    self.images=[NSMutableArray array];
    for (NSString * url in self.picList) {
        UIImageView * im=[[UIImageView alloc]init];
        [im sd_setImageWithURL:[NSURL URLWithString:url]];
        [self.images addObject:im];
    }
}
- (IBAction)showMorePhotos:(UITapGestureRecognizer *)sender {
    self.photos=[NSMutableArray array];
    for (UIImageView * image in self.images) {
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
    [browser setCurrentPhotoIndex:0];
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
- (IBAction)showCustomerService:(id)sender {
    RCConversationModel * model=[[RCConversationModel alloc]init:
                                 RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
    model.conversationType=ConversationType_PRIVATE;
    model.targetId=[NSString stringWithFormat:@"%@",[self.detailsInfo objectForKey:@"memberId"]];
    model.conversationTitle=[self.detailsInfo objectForKey:@"nickname"];
    model.senderUserId=[ShareValue shareInstance].userInfo.id;
    model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = [NSString stringWithFormat:@"%@",[self.detailsInfo objectForKey:@"memberId"]];
    _conversationVC.userName = [self.detailsInfo objectForKey:@"nickname"];
    _conversationVC.title =[self.detailsInfo objectForKey:@"nickname"];
    _conversationVC.conversation = model;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    [self.navigationController pushViewController:_conversationVC animated:YES];
}


@end
