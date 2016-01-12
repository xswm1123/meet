//
//  PersonalCenterViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "DiscoveryTableViewCell.h"
#import "RechargeVipViewController.h"
#import "RCDChatViewController.h"
#define DiscoveryTableViewCellID @"DiscoveryTableViewCell"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_userId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) CGFloat cacheSize;
@property (nonatomic,strong) UIImage * photoImage;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:DiscoveryTableViewCellID];
    self.tableView.backgroundColor=NAVI_COLOR;
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[ShareValue shareInstance].userInfo.avatar] placeholderImage:placeHolder];
    self.lb_name.text=[ShareValue shareInstance].userInfo.nickname;
    self.lb_userId.text=[NSString stringWithFormat:@"用户ID:%@",[ShareValue shareInstance].userInfo.meetid];
}
- (IBAction)editAction:(id)sender {
    [self performSegueWithIdentifier:@"editProfile" sender:nil];
}
- (IBAction)homePage:(id)sender {
    [self performSegueWithIdentifier:@"personalHomePage" sender:nil];
}
- (IBAction)modifyUserPhoto:(id)sender {
    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相机选择", nil];
    
    [as showInView:self.view.window];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    /**
     *  photo
     */
    UIImagePickerController * imagePick=[[UIImagePickerController alloc]init];
    imagePick.delegate=self;
    if (buttonIndex==0) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController: imagePick animated:YES completion:NULL];
    }
    if (buttonIndex==1) {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController: imagePick animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
//        [self uploadPhoto];
        [self openEditor:image];
    }];
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
    self.photoImage = croppedImage;
    [self uploadPhoto];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
-(void)uploadPhoto{
    /**
     *  上传头像
     */
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@IMG_%@",self.title,[formatter stringFromDate:now]];
//    self.photoImage=[ImageInfo makeThumbnailFromImage:self.photoImage scale:0.5];
    ImageInfo * details=[[ImageInfo alloc]initWithImage:self.photoImage];
    [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
        NSArray * arr=(NSArray*)response.data;
        NSString* url=[arr firstObject];
        NSLog(@"url:%@",url);
        /**
         修改头像
         */
        ModifyUserPhotoRequest * request =[[ModifyUserPhotoRequest alloc]init];
        request.avatar=url;
        [SystemAPI ModifyUserPhotoRequest:request success:^(ModifyUserPhotoResponse *response) {
             [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:response.message toView:ShareAppDelegate.window];
            self.photoIV.image=self.photoImage;
            LMUserInfo * user =[ShareValue shareInstance].userInfo;
            user.avatar=url;
            [ShareValue shareInstance].userInfo=user;
        } fail:^(BOOL notReachable, NSString *desciption) {
             [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }];
        
    } fail:^(BOOL NotReachable, NSString *descript) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:descript toView:ShareAppDelegate.window];
    } class:[UploadFilesResponse class]];
}

#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 3;
    }
    if (section==3) {
        return 2;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:DiscoveryTableViewCellID];
    if (!cell) {
        cell=[[DiscoveryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiscoveryTableViewCellID];
    }
    cell.arrow.textColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    cell.arrow.text=@"\U0000e639";
    cell.arrow.font=[UIFont fontWithName:iconFont size:20];
    
    if (indexPath.section==0) {
        cell.lb_icon.text=@"\U0000e61d";
        cell.lb_title.text=@"账号与安全";
        cell.lb_icon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];
    }
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                cell.lb_icon.text=@"\U0000e634";
                cell.lb_title.text=@"通知设置";
                cell.lb_icon.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
                break;
            case 1:
                cell.lb_icon.text=@"\U0000e631";
                cell.lb_title.text=@"黑名单";
                cell.lb_icon.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
                break;
                
            default:
                break;
        }
        
    }
    if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
                cell.lb_icon.text=@"\U0000e632";
                cell.lb_title.text=@"相遇评分";
                cell.lb_icon.textColor=[UIColor colorWithRed:219/255.0 green:40/255.0 blue:163/255.0 alpha:1.0];
                break;
            case 1:
                cell.lb_icon.text=@"\U0000e633";
                cell.lb_title.text=@"清除缓存";
                cell.lb_icon.textColor=[UIColor colorWithRed:232/255.0 green:80/255.0 blue:63/255.0 alpha:1.0];
                break;
            case 2:
                cell.lb_icon.text=@"\U0000e628";
                cell.lb_title.text=@"商家管理";
                cell.lb_icon.textColor=[UIColor colorWithRed:243/255.0 green:197/255.0 blue:45/255.0 alpha:1.0];
                break;
//            case 3:
//                cell.lb_icon.text=@"\U0000e60a";
//                cell.lb_title.text=@"提现";
//                cell.lb_icon.textColor=[UIColor colorWithRed:243/255.0 green:197/255.0 blue:45/255.0 alpha:1.0];
//                break;
            default:
                break;
        }
    }
    if (indexPath.section==3) {
        switch (indexPath.row) {
            case 0:
                cell.lb_icon.text=@"\U0000e636";
                cell.lb_title.text=@"关于我们";
                cell.lb_icon.textColor=[UIColor colorWithRed:156/255.0 green:88/255.0 blue:182/255.0 alpha:1.0];
                break;
            case 1:
                cell.lb_icon.text=@"\U0000e635";
                cell.lb_title.text=@"退出";
                cell.lb_icon.textColor=[UIColor colorWithRed:156/255.0 green:88/255.0 blue:182/255.0 alpha:1.0];
                break;
                

            default:
                break;
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3) {
        return 0.1;
    }
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, tableView.frame.size.width, 15);
    view.backgroundColor=NAVI_COLOR;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"account" sender:nil];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"noti" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"blackList" sender:nil];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1041964050" ]]];
                    break;
                    case 1:
                    /**
                     *  开子线程清除缓存
                     */
                    [self setupOperationToClearCache];
                    break;
                case 2:
                    [self handleLogicWithInfo];
                    break;
//                case 3:
//                    [MBProgressHUD showError:@"开发中,敬请期待..." toView:self.view.window];
//                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                    
                case 0:
                    [self performSegueWithIdentifier:@"about" sender:nil];
                    break;
                case 1:
                    //退出
                    [self logout];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)handleLogicWithInfo{
    if ([[ShareValue shareInstance].userInfo.type integerValue] ==2) {
        if ([ShareValue shareInstance].userInfo.isStore) {
            [self performSegueWithIdentifier:@"storeManager" sender:nil];
        }else{
            [self chatWithServiceOrNot];
        }
    }else{
        [self showStoreWarning];
    }
}
-(void)chatWithServiceOrNot{
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还不是商家，您可以联系客户--相遇小秘书，获取相关的信息！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=300;
    [al show];
}
-(void)chatWithService{
    RCConversationModel * model=[[RCConversationModel alloc]init:
                                 RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
    model.conversationType=ConversationType_PRIVATE;
    model.targetId=@"1";
    model.conversationTitle=@"相遇小秘书";
    model.senderUserId=[ShareValue shareInstance].userInfo.id;
    model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = @"1";
    _conversationVC.userName = @"相遇小秘书";
    _conversationVC.title = @"相遇小秘书";
    _conversationVC.conversation = model;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    [self.navigationController pushViewController:_conversationVC animated:YES];
}
-(void)showStoreWarning{
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还不是会员，请前往会员中心充值成为会员。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=400;
    [al show];
}
-(void)logout{
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出登录嘛？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=500;
    [al show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            [ShareValue shareInstance].userInfo=nil;
            UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
            [self presentViewController:sb.instantiateInitialViewController animated:YES completion:^{
                
            }];
        }
    }
    if (alertView.tag==400) {
        if (buttonIndex==1) {
            UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RechargeVipViewController * vc=[sb instantiateViewControllerWithIdentifier:@"RechargeVipViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (alertView.tag==300) {
        if (buttonIndex==1) {
             [self chatWithService];
        }
    }
}
/**
 *  清除缓存
 */
-(void)setupOperationToClearCache{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearCache];
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
    
}
-(void)clearCache{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    self.cacheSize=[self folderSizeAtPath:cachPath]/1024.0/1024.0;
//    NSLog(@"cachPath:%@",cachPath);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    //test
    NSString * tempPath=NSTemporaryDirectory();
    NSArray *tempFiles = [[NSFileManager defaultManager] subpathsAtPath:tempPath];
    for (NSString *p in tempFiles) {
        if ([p hasSuffix:@"MOV"]) {
            NSLog(@"p:%@",p);
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    
}
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize=[fileManager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        return folderSize;
    }
    return 0;
}
-(void)clearCacheSuccess{
    UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"清理成功！" message:[NSString stringWithFormat:@"共清理了%.2fMB缓存。",self.cacheSize] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}

@end
