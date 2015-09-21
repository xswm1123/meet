//
//  FieldProfileViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "FieldProfileViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"

@interface FieldProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lb_birthday;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_male;
@property (weak, nonatomic) IBOutlet UIButton *famaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_famale;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong) UIImage * photoImage;
/**
 *  pick
 */
@property (weak, nonatomic) IBOutlet UIView *addressBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;
@property (nonatomic,strong)  UIView * pickerBG;
@property (nonatomic,strong) UIPickerView* picker;
@property (nonatomic,copy) NSString * pickTempValue;
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation FieldProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.saveBtn.layer.shadowOffset=CGSizeMake(0, 2);
    self.saveBtn.layer.shadowColor=TempleColor.CGColor;
    self.saveBtn.layer.shadowRadius=0;
    self.saveBtn.layer.shadowOpacity=0.6;
    self.lb_famale.font=[UIFont fontWithName:iconFont size:18];
    self.lb_famale.text=@"\U0000e616";
    self.lb_famale.textColor=iconRed;
    self.lb_male.font=[UIFont fontWithName:iconFont size:18];
    self.lb_male.text=@"\U0000e617";
    self.lb_male.textColor=iconGreen;
    /**
     *  pick
     */
    self.pickerBG=[[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVCE_WITH, 250)];
    self.pickerBG.backgroundColor=NAVI_COLOR;
    [self.view addSubview:self.pickerBG];
    self.picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, DEVCE_WITH, 210)];
    self.picker.delegate=self;
    self.picker.dataSource=self;
    self.picker.backgroundColor=[UIColor whiteColor];
    [self.pickerBG addSubview:self.picker];
    UIButton* cancel =[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(dismissPickerAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBG addSubview:cancel];
    UIButton* confirm =[[UIButton alloc]initWithFrame:CGRectMake(DEVCE_WITH-70, 0, 60, 40)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setBackgroundColor:[UIColor clearColor]];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [confirm addTarget:self action:@selector(confirmTheName) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBG addSubview:confirm];
    [self getPickerData];

}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}
-(void)confirmTheName{
    self.lb_city.text=[NSString stringWithFormat:@"%@ %@ %@",[self.provinceArray objectAtIndex:[self.picker selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.picker selectedRowInComponent:1]] ,[self.townArray objectAtIndex:[self.picker selectedRowInComponent:2]]];
    [self dismissPickerAnimation];
}
/**
 *  呼出picker动画
 */
-(void)showPickerAnimation{
    CGRect frame=self.pickerBG.frame;
    frame.origin.y=DEVICE_HEIGHT- frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBG.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  pick消失动画
 */
-(void)dismissPickerAnimation{
    CGRect frame=self.pickerBG.frame;
    frame.origin.y=DEVICE_HEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBG.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)choosePhoto:(id)sender {
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
    [self.photoBtn setImage:image forState:UIControlStateNormal];
    self.photoImage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)selectMaleAction:(id)sender {
    self.maleBtn.selected=YES;
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    self.famaleBtn.selected=NO;
     [self.famaleBtn setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
}
- (IBAction)selectFamaleAction:(id)sender {
    self.maleBtn.selected=NO;
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    self.famaleBtn.selected=YES;
    [self.famaleBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
}
- (IBAction)saveAction:(id)sender {
    if ([self isReadyToSubmmit]) {
        /**
         *  上传头像
         */
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        NSDate *now = [NSDate new];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@IMG_%@",self.title,[formatter stringFromDate:now]];
        self.photoImage=[ImageInfo makeThumbnailFromImage:self.photoImage scale:0.2];
        ImageInfo * details=[[ImageInfo alloc]initWithImage:self.photoImage];
        [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
            NSArray * arr=(NSArray*)response.data;
            NSString* url=[arr firstObject];
            NSLog(@"url:%@",url);
            /**
             注册
             */
            RegisterRequest * request=[[RegisterRequest alloc]init];
            request.mobile=self.phoneNmuber;
            request.password=self.password;
            request.code=self.code;
            if (self.recommanderID.length>0) {
                request.recommendMeetid=self.recommanderID;
            }
            request.avatar=url;
            request.nickname=self.tf_nickName.text;
            request.birthday=self.lb_birthday.text;
            request.address=self.lb_city.text;
            if ([self.maleBtn isSelected]) {
                request.sex=@"1";
            }else{
                request.sex=@"2";
            }
            
            [SystemAPI RegisterRequest:request success:^(RegisterResponse *response) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [MBProgressHUD showSuccess:response.message toView:ShareAppDelegate.window];
//                [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                [self loginAction];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [MBProgressHUD showError:desciption toView:self.view.window];
            }];
            
        } fail:^(BOOL NotReachable, NSString *descript) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:descript toView:self.view.window];
        } class:[UploadFilesResponse class]];
    }
    
}
-(void)loginAction{
    LoginRequest * request=[[LoginRequest alloc]init];
    request.account=self.phoneNmuber;
    request.password=self.password;
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [SystemAPI LoginRequest:request success:^(LoginResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:response.data];
        [ShareValue shareInstance].userInfo=user;
        RCUserInfo * info=[[RCUserInfo alloc]initWithUserId:[response.data objectForKey:@"id"] name:[response.data objectForKey:@"mobile"] portrait:[response.data objectForKey:@"avatar"]];
        [ShareValue shareInstance].RCUser=info;
        [ShareValue shareInstance].password=self.password;
        [self loginInRCM];
        [self showIndexVC];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view.window];
    }];

}
-(void)loginInRCM{
    [[RCIM sharedRCIM] connectWithToken:[ShareValue shareInstance].userInfo.rongToken
                                success:^(NSString *userId) {
                                    [[RCIM sharedRCIM]
                                     refreshUserInfoCache:[ShareValue shareInstance].RCUser
                                     withUserId:[ShareValue shareInstance].RCUser.userId];
                                    //登陆demoserver成功之后才能调demo 的接口
                                    [RCDDataSource syncGroups];
                                    [RCDDataSource syncFriendList:^(NSMutableArray * result) {
                                        
                                    }];
                                    
                                    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
                                        for (NSString *userID in blockUserIds) {
                                            
                                            // 暂不取用户信息，界面展示的时候在获取
                                            RCUserInfo*userInfo = [[RCUserInfo alloc]init];
                                            userInfo.userId = userID;
                                            userInfo.portraitUri = nil;
                                            userInfo.name = nil;
                                            [[RCDataBaseManager shareInstance] insertBlackListToDB:userInfo];
                                        }
                                        
                                    } error:^(RCErrorCode status) {
                                        NSLog(@"同步黑名单失败，status = %ld",(long)status);
                                    }];
                                    //设置当前的用户信息
                                    
                                    //同步群组
                                    //调用connectWithToken时数据库会同步打开，不用再等到block返回之后再访问数据库，因此不需要这里刷新
                                    //这里仅保证之前已经成功登陆过，如果第一次登陆必须等block 返回之后才操作数据
                                }
                                  error:^(RCConnectErrorCode status) {
                                      
                                  }
                         tokenIncorrect:^{
                             
                         }];
}
-(void)showIndexVC{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:sb.instantiateInitialViewController animated:YES completion:^{
        
    }];
}
-(BOOL)isReadyToSubmmit{
    if (self.tf_nickName.text.length==0) {
        [MBProgressHUD showError:@"请输入昵称！" toView:self.view.window];
        return NO;
    }
    if ([self.lb_birthday.text isEqualToString:@"生日"]) {
        [MBProgressHUD showError:@"请选择生日！" toView:self.view.window];
        return NO;
    }
    if ([self.lb_city.text isEqualToString:@"所在地"]) {
        [MBProgressHUD showError:@"请选择地区！" toView:self.view.window];
        return NO;
    }
//    if (![self.maleBtn isSelected]||[self.famaleBtn isSelected]) {
//        [MBProgressHUD showError:@"请选择性别！" toView:self.view.window];
//        return NO;
//    }
    if (!self.photoImage) {
        [MBProgressHUD showError:@"请选择头像！" toView:self.view.window];
        return NO;
    }
    
    return YES;
}
/**
 *  选择生日
 *
 *  @param sender
 */
- (IBAction)chooseBirthday:(id)sender {
     [self.tf_nickName resignFirstResponder];
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-MM-dd"];
    UIDatePicker* dp=[[UIDatePicker alloc]initWithFrame:CGRectMake(-20, 40, [UIScreen mainScreen].bounds.size.width, 216)];
    dp.datePickerMode=UIDatePickerModeDate;
    dp.date=[frm dateFromString:@"1990-01-01"];
    if (IOS8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [frm setDateFormat:@"YYYY-MM-dd"];
            self.lb_birthday.text=[frm stringFromDate:dp.date];
        }];
        [alertController.view addSubview:dp];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n"] delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [dp addTarget:self action:@selector(datePickerValueChanged:WithGesture:) forControlEvents:UIControlEventValueChanged];
        [sheet addSubview:dp];
        [sheet showFromToolbar:self.navigationController.toolbar];
    }

}
-(void)datePickerValueChanged:(UIDatePicker*)sender WithGesture:(UITapGestureRecognizer*)gesture
{
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"YYYY-MM-dd"];
    self.lb_birthday.text=[frm stringFromDate:sender.date];
}

/**
 *  选择地区
 *
 *  @param sende
 */
- (IBAction)chooseCity:(id)sender {
    [self.tf_nickName resignFirstResponder];
    [self showPickerAnimation];
}
#pragma 监听键盘
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame;
    CGFloat distance=0;
    CGFloat yLocation=0;
    
    if (keyboardFrame.origin.y<self.addressBG.frame.origin.y+self.addressBG.frame.size.height) {
        distance=self.addressBG.frame.origin.y+self.addressBG.frame.size.height-keyboardFrame.origin.y;
    }
    frame=CGRectMake(0, yLocation, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.distanceToTop.constant=30-distance-40;
        [self updateViewConstraints];
    } completion:^(BOOL bl){
    }];
    
}
- (void)keyboardDisappear:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - self.bottomLayoutGuide.length;
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.distanceToTop.constant=30;
        [self updateViewConstraints];
    } completion:nil];
}

@end
