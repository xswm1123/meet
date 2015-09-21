//
//  EditProfileViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileTableViewCell.h"
#import "ExchangeCityViewController.h"

#define EditCell @"EditProfileTableViewCell"

@interface EditProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SelectCityDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * tfsArr;
@property (nonatomic,strong) NSIndexPath  * fieldPath;
@property (nonatomic,strong) NSArray * emotionArr;
@property (nonatomic,strong) NSArray * appearanceArr;
@property (nonatomic,strong) NSArray * professionArr;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tfsArr = [NSMutableArray array];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView setSeparatorColor:NAVI_COLOR];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditProfileTableViewCell" bundle:nil] forCellReuseIdentifier:EditCell];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    /**
     *  情感状况： {"单身","恋爱中","已婚","离异","带小孩","丧偶","同性","秘密"};
     外貌特征：{"骨感","苗条","匀称","微胖","健壮","丰满"};
     职业：{"公务员/事业单位人员","商业/个体经营者","计算机/互联网/电商/通讯","金融/银行/证券/投资/保险","文化/体育/传媒/广告","艺术/娱乐/表演/模特","美术/设计/创意","法律/医疗/卫生/制药","教育/培训","美容/保健","酒店/旅游/餐饮","房产/中介/装修","生产/加工/制造","军人/警察/学生","自由职业者/企业主","其他"};
     */
    self.emotionArr=@[@"单身",@"恋爱中",@"已婚",@"离异",@"带小孩",@"丧偶",@"同性",@"秘密"];
    self.appearanceArr=@[@"骨感",@"苗条",@"匀称",@"微胖",@"健壮",@"丰满"];
    self.professionArr=@[@"公务员/事业单位人员",@"商业/个体经营者",@"计算机/互联网/电商/通讯",@"金融/银行/证券/投资/保险",@"文化/体育/传媒/广告",@"艺术/娱乐/表演/模特",@"美术/设计/创意",@"法律/医疗/卫生/制药",@"教育/培训",@"美容/保健",@"酒店/旅游/餐饮",@"房产/中介/装修",@"生产/加工/制造",@"军人/警察/学生",@"自由职业者/企业主",@"其他"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [self.tableView scrollToRowAtIndexPath:self.fieldPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 4;
    }
    if (section==3) {
        return 1;
    }
    if (section==4) {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditProfileTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:EditCell];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.tf_desc.delegate=self;
    switch (indexPath.section) {
        case 0:
            cell.lb_option.text=@"昵称";
            cell.tf_desc.hidden=NO;
            cell.lb_value.hidden=YES;
            cell.tf_desc.text=[ShareValue shareInstance].userInfo.nickname;
            [self.tfsArr addObject:cell.tf_desc];
            break;
        case 1:
            if (indexPath.row==0) {
                cell.lb_option.text=@"生日";
                cell.tf_desc.hidden=YES;
                cell.lb_value.hidden=NO;
                NSString * bir=[ShareValue shareInstance].userInfo.birthday;
                NSArray * arr = [bir componentsSeparatedByString:@" "];
                cell.lb_value.text=[arr firstObject];
                [self.tfsArr addObject:cell.lb_value];
            }
            if (indexPath.row==1) {
                cell.lb_option.text=@"个性签名";
                cell.tf_desc.hidden=NO;
                cell.lb_value.hidden=YES;
                cell.tf_desc.text=[ShareValue shareInstance].userInfo.sign;
                [self.tfsArr addObject:cell.tf_desc];
            }
            break;
        case 2:
            if (indexPath.row==0) {
                cell.lb_option.text=@"情感状况";
                cell.tf_desc.hidden=YES;
                cell.lb_value.hidden=NO;
                cell.lb_value.text=[ShareValue shareInstance].userInfo.affection;
                [self.tfsArr addObject:cell.lb_value];
            }
            if (indexPath.row==1) {
                cell.lb_option.text=@"外貌特征";
                cell.tf_desc.hidden=YES;
                cell.lb_value.hidden=NO;
                cell.lb_value.text=[ShareValue shareInstance].userInfo.appearance;
                [self.tfsArr addObject:cell.lb_value];
            }
            if (indexPath.row==2) {
                cell.lb_option.text=@"从事职业";
                cell.tf_desc.hidden=YES;
                cell.lb_value.hidden=NO;
                cell.lb_value.text=[ShareValue shareInstance].userInfo.profession;
                [self.tfsArr addObject:cell.lb_value];
            }
            if (indexPath.row==3) {
                cell.lb_option.text=@"兴趣爱好";
                cell.tf_desc.hidden=NO;
                cell.lb_value.hidden=YES;
                cell.tf_desc.text=[ShareValue shareInstance].userInfo.hobby;
                [self.tfsArr addObject:cell.tf_desc];
            }
            break;
        case 3:
            if (indexPath.row==0) {
                cell.lb_option.text=@"所在地区";
                cell.tf_desc.hidden=YES;
                cell.lb_value.hidden=NO;
                cell.lb_value.text=[ShareValue shareInstance].userInfo.address;
                [self.tfsArr addObject:cell.lb_value];
            }
            break;
        case 4:
            cell.lb_option.hidden=YES;
            cell.tf_desc.hidden=YES;
            cell.lb_value.hidden=YES;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.backgroundColor=[UIColor clearColor];
            [self createSaveBtnOnCell:cell];
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        //生日
        if (indexPath.row==0) {
            UILabel * lb =[self.tfsArr objectAtIndex:1];
            [self ChooseBirthdayWithDate:lb.text];
        }
    }
    if (indexPath.section==2) {
        //情感状况
        if (indexPath.row==0) {
            [self chooseEmotionTypes];
        }
        //外貌特征
        if (indexPath.row==1) {
            [self chooseApperanceTypes];
        }
        //从事职业
        if (indexPath.row==2) {
            [self chooseProfessionTypes];
        }
    }
    if (indexPath.section==3) {
        //选择地区
        if (indexPath.row==0) {
            UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ExchangeCityViewController * vc=[sb instantiateViewControllerWithIdentifier:@"ExchangeCityViewController"];
            vc.delegate=self;
            [self.navigationController pushViewController:vc animated:YES];
        }
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
-(void)createSaveBtnOnCell:(EditProfileTableViewCell*)cell{
    BaseButton * btn=[[BaseButton alloc]initWithFrame:CGRectMake(20, 4, DEVCE_WITH-40, 40)];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cell.contentView addSubview:btn];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    EditProfileTableViewCell * cell =(EditProfileTableViewCell*)textField.superview.superview;
   self.fieldPath =[self.tableView indexPathForCell:cell];
}
-(void)saveAction{
    for (UITextField * tf in self.tfsArr) {
        NSLog(@"text:%@",tf.text);
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ModifyUserInfoRequest * request =[[ModifyUserInfoRequest alloc]init];
    request.nickname=((UITextField*)[self.tfsArr objectAtIndex:0]).text;
    request.birthday=((UILabel*)[self.tfsArr objectAtIndex:1]).text;
    request.sign=((UITextField*)[self.tfsArr objectAtIndex:2]).text;
    request.affection=((UILabel*)[self.tfsArr objectAtIndex:3]).text;
    request.appearance=((UILabel*)[self.tfsArr objectAtIndex:4]).text;
    request.profession=((UILabel*)[self.tfsArr objectAtIndex:5]).text;
    request.hobby=((UITextField*)[self.tfsArr objectAtIndex:6]).text;
    request.address=((UILabel*)[self.tfsArr objectAtIndex:7]).text;
    [SystemAPI ModifyUserInfoRequest:request success:^(ModifyUserInfoResponse *response) {
        LMUserInfo *  user = [[LMUserInfo alloc]initWithDictionary:response.data];
        [ShareValue shareInstance].userInfo=user;
        self.tfsArr=[NSMutableArray array];
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view.window];
    }]; 
}
/**
 *  选择各种数据
 */
//选择生日
-(void)ChooseBirthdayWithDate:(NSString *)dates{
    UILabel * lb =[self.tfsArr objectAtIndex:1];
    
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-MM-dd"];
    NSDate * dpDate=[frm dateFromString:dates];
    UIDatePicker* dp=[[UIDatePicker alloc]initWithFrame:CGRectMake(-20, 40, [UIScreen mainScreen].bounds.size.width, 216)];
    dp.datePickerMode=UIDatePickerModeDate;
    dp.date=dpDate;
    if (IOS8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择您的生日\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [frm setDateFormat:@"YYYY-MM-dd"];
            lb.text=[frm stringFromDate:dp.date];
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
    UILabel * lb =[self.tfsArr objectAtIndex:1];
    lb.text=[frm stringFromDate:sender.date];
}
//选择情感状态
-(void)chooseEmotionTypes{
    UIActionSheet * as =[[UIActionSheet alloc]initWithTitle:@"请选择情感状态" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"单身",@"恋爱中",@"已婚",@"离异",@"带小孩",@"丧偶",@"同性",@"秘密", nil];
    as.tag=100;
    [as showInView:self.view.window];
}
//选择外貌特征
-(void)chooseApperanceTypes{
    UIActionSheet * as =[[UIActionSheet alloc]initWithTitle:@"请选择外貌特征" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"骨感",@"苗条",@"匀称",@"微胖",@"健壮",@"丰满", nil];
    as.tag=200;
    [as showInView:self.view.window];
}
//选择职业
-(void)chooseProfessionTypes{
    UIActionSheet * as =[[UIActionSheet alloc]initWithTitle:@"请选择外貌特征" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"公务员/事业单位人员",@"商业/个体经营者",@"计算机/互联网/电商/通讯",@"金融/银行/证券/投资/保险",@"文化/体育/传媒/广告",@"艺术/娱乐/表演/模特",@"美术/设计/创意",@"法律/医疗/卫生/制药",@"教育/培训",@"美容/保健",@"酒店/旅游/餐饮",@"房产/中介/装修",@"生产/加工/制造",@"军人/警察/学生",@"自由职业者/企业主",@"其他", nil];
    as.tag=300;
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==100) {
        UILabel * la=[self.tfsArr objectAtIndex:3];
        if (buttonIndex!=self.emotionArr.count) {
            la.text=[self.emotionArr objectAtIndex:buttonIndex];
        }
    }
    if (actionSheet.tag==200) {
        UILabel * la=[self.tfsArr objectAtIndex:4];
        if (buttonIndex!=self.appearanceArr.count) {
            la.text=[self.appearanceArr objectAtIndex:buttonIndex];
        }
    }
    if (actionSheet.tag==300) {
        UILabel * la=[self.tfsArr objectAtIndex:5];
        if (buttonIndex!=self.professionArr.count) {
            la.text=[self.professionArr objectAtIndex:buttonIndex];
        }
    }
}
//选择地区
-(void)getCityName:(NSDictionary *)city{
    UILabel * la=[self.tfsArr objectAtIndex:7];
    NSString * CityTitle=[NSString stringWithFormat:@"%@",[city objectForKey:@"name"]];
    la.text=CityTitle;
}
@end
