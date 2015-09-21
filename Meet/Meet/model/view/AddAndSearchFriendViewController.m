//
//  AddAndSearchFriendViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AddAndSearchFriendViewController.h"
#import "SearchFriendResultViewController.h"
#import "SearchGroupResultViewController.h"

@interface AddAndSearchFriendViewController ()
@property (weak, nonatomic) IBOutlet BaseSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet BaseView *tagBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTF;
@property (nonatomic,strong) NSString *option;
@property (nonatomic,strong) NSArray * tags;
@property (nonatomic,strong) NSMutableArray * tagsBtn;
@property (nonatomic,strong) UILabel * markLabel;
@property (weak, nonatomic) IBOutlet BaseButton *searchBtn;
@end

@implementation AddAndSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 100, DEVCE_WITH-16, 40)];
    self.markLabel.text=@"开发中，敬请期待";
    self.markLabel.hidden=YES;
    self.markLabel.textColor=[UIColor whiteColor];
    self.markLabel.textAlignment=NSTextAlignmentCenter;
    self.markLabel.font=[UIFont systemFontOfSize:30];
    [self.view addSubview:self.markLabel];

    self.tagBg.hidden=YES;
    self.distanceToTF.constant=16;
    [self updateViewConstraints];
    [self getTags];
}
-(void)getTags{
    GetGroupTagsRequest * reqeust =[[ GetGroupTagsRequest alloc]init];
    [SystemAPI GetGroupTagsRequest:reqeust success:^(GetGroupTagsResponse *response) {
        self.tags=[(NSArray *)response.data copy];
        [self configTags];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)configTags{
    self.tagsBtn=[NSMutableArray array];
    CGFloat btnWidth=(DEVCE_WITH-72)/4;
    for (int i =0; i<self.tags.count; i++) {
        NSDictionary * dic =[self.tags objectAtIndex:i];
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(30+((btnWidth+4)*(i%4)), 35+((30+10)*(i/4)), btnWidth, 30)];
        btn.clipsToBounds=YES;
        btn.layer.cornerRadius=5;
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        btn.tag=[[dic objectForKey:@"id"] integerValue];
        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagsBtn addObject:btn];
        [self.tagBg addSubview:btn];
        
    }
}
-(void)chooseTag:(UIButton*) btn{
    btn.selected=YES;
    [btn setBackgroundColor:TempleColor];
    for (UIButton * tagBtn in self.tagsBtn) {
        if (btn.tag!=tagBtn.tag) {
            tagBtn.selected=NO;
            [tagBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

- (IBAction)segmentValueChanged:(BaseSegmentControl*)sender {
    if (sender.selectedSegmentIndex==0) {
        self.tf_search.text=@"";
        self.tf_search.placeholder=@"输入ID";
        self.tagBg.hidden=YES;
        self.distanceToTF.constant=16;
        [self updateViewConstraints];
        self.markLabel.hidden=YES;
        self.tf_search.hidden=NO;
        self.searchBtn.hidden=NO;
    }
    if (sender.selectedSegmentIndex==1) {
        self.tf_search.text=@"";
        self.tf_search.placeholder=@"输入搜索条件";
        self.tagBg.hidden=YES;
        self.markLabel.hidden=NO;
        self.tf_search.hidden=YES;
        self.searchBtn.hidden=YES;
        self.distanceToTF.constant=180;
        [self updateViewConstraints];
        
    }
}
- (IBAction)searchAction:(id)sender {
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self searchFriend];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self searchGroup];

    }
}
-(void)searchFriend{
    if ([self isReadyToSearch]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SearchUserRequest * request =[[SearchUserRequest alloc]init];
        request.key=self.tf_search.text;
        [SystemAPI SearchUserRequest:request success:^(SearchUserResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view.window];
            NSArray * arr=(NSArray*)response.data;
            [self performSegueWithIdentifier:@"friendResult" sender:[arr firstObject]];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
}
-(void)searchGroup{
    if ([self isReadyToSearch]) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SearchGroupRequest * request  =[[SearchGroupRequest alloc]init];
        request.key=self.tf_search.text;
        NSString * tagId;
        for (UIButton * btn in self.tagsBtn) {
            if ([btn isSelected]) {
                tagId=[NSString stringWithFormat:@"%d",(int)btn.tag];
            }
        }
        request.categoryId=tagId;
        [SystemAPI SearchGroupRequest:request
                              success:^(SearchGroupResponse *response) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  [MBProgressHUD showSuccess:response.message toView:self.view.window];
                                  [self performSegueWithIdentifier:@"groupResult" sender:(NSArray*)response.data];
                              } fail:^(BOOL notReachable, NSString *desciption) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  [MBProgressHUD showError:desciption toView:self.view.window];
                              }];
    }
}
-(BOOL)isReadyToSearch{
    if (self.tf_search.text.length==0) {
        [MBProgressHUD showError:@"请输入搜索内容！" toView:self.view];
        return NO;
    }
    return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"friendResult"]) {
        SearchFriendResultViewController * vc=segue.destinationViewController;
        vc.infoDic=sender;
    }
    if ([segue.identifier isEqualToString:@"groupResult"]) {
        SearchGroupResultViewController * vc=segue.destinationViewController;
        vc.groupList=sender;
    }
}
@end
