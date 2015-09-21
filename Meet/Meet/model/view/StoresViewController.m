//
//  StoresViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoresViewController.h"
#import "StoresListTableViewCell.h"
#import "StoreDetailsViewController.h"
#import "ExchangeCityViewController.h"

@interface StoresViewController ()<UITableViewDataSource,UITableViewDelegate,SelectCityDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *v_restrantsBG;
@property (weak, nonatomic) IBOutlet UIView *v_hotelBG;
@property (weak, nonatomic) IBOutlet UIView *v_KTVBG;
@property (weak, nonatomic) IBOutlet UIView *v_coffeeBG;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIButton *restrantBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotelBtn;
@property (weak, nonatomic) IBOutlet UIButton *KTVBtn;
@property (weak, nonatomic) IBOutlet UIButton *coffeeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchBG;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *btnBGs;

//data
@property (nonatomic,strong) NSMutableArray * storeCategory;
@property (nonatomic,strong) NSMutableArray * listData;
@property (nonatomic,copy) NSString * tempCityId;

@end
#define StoresListTableViewCellId @"StoresListTableViewCell"
@implementation StoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.tempCityId=[[ShareValue shareInstance].cityId copy];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(locationDidChanged:) name:NOTIFICATION_CITY_UPDATED object:nil];
    [self getStoreCategoryList];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithSegment:self.segmentControl];
    }];
}
-(void)locationDidChanged:(NSNotification*)noti{
    [ShareValue shareInstance].city=noti.object;
    [self setCity];
}
-(void)setCity{
    NSString * CityTitle=[NSString stringWithFormat:@"%@ \U0000e637",[ShareValue shareInstance].city];
    if (CityTitle.length>0) {
        [self.cityBtn setTitle:CityTitle forState:UIControlStateNormal];
    }else{
        [self.cityBtn setTitle:@"未知 \U0000e637" forState:UIControlStateNormal];
    }
}
-(void)initView{
   
    self.searchBG.backgroundColor=NAVI_COLOR;
    self.cityBtn.titleLabel.font=[UIFont fontWithName:iconFont size:16];
    [self setCity];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoresListTableViewCell" bundle:nil] forCellReuseIdentifier:StoresListTableViewCellId];
    self.tableView.backgroundColor=NAVI_COLOR;
    self.segmentControl.clipsToBounds=YES;
    self.segmentControl.layer.cornerRadius=8;
    self.segmentControl.layer.borderColor=TempleColor.CGColor;
    self.segmentControl.layer.borderWidth=1;
    self.segmentControl.tintColor=TempleColor;
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateSelected];
    self.segmentControl.selectedSegmentIndex=0;
    self.restrantBtn.selected=YES;
    for (UIButton * btn in self.btns) {
        btn.backgroundColor=cellColor;
    }
    for (UIView * view in self.btnBGs) {
        view.backgroundColor=cellColor;
    }
    self.v_restrantsBG.backgroundColor=TempleColor;
}
- (IBAction)selectCity:(id)sender {
    
}
- (IBAction)clickRestrantBtn:(id)sender {
    self.restrantBtn.selected=YES;
    self.hotelBtn.selected=NO;
    self.KTVBtn.selected=NO;
    self.coffeeBtn.selected=NO;
    self.v_restrantsBG.backgroundColor=TempleColor;
    self.v_hotelBG.backgroundColor=[UIColor clearColor];
    self.v_KTVBG.backgroundColor=[UIColor clearColor];
    self.v_coffeeBG.backgroundColor=[UIColor clearColor];
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self loadListDatasWithCategoryId:0 SortId:@"distance"];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self loadListDatasWithCategoryId:0 SortId:@"price"];
    }
    if (self.segmentControl.selectedSegmentIndex==2) {
        [self loadListDatasWithCategoryId:0 SortId:@"default"];
    }
    
}
- (IBAction)clickHotelBtn:(id)sender {
    self.restrantBtn.selected=NO;
    self.hotelBtn.selected=YES;
    self.KTVBtn.selected=NO;
    self.coffeeBtn.selected=NO;
    self.v_restrantsBG.backgroundColor=[UIColor clearColor];
    self.v_hotelBG.backgroundColor=TempleColor;
    self.v_KTVBG.backgroundColor=[UIColor clearColor];
    self.v_coffeeBG.backgroundColor=[UIColor clearColor];
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self loadListDatasWithCategoryId:1 SortId:@"distance"];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self loadListDatasWithCategoryId:1 SortId:@"price"];
    }
    if (self.segmentControl.selectedSegmentIndex==2) {
        [self loadListDatasWithCategoryId:1 SortId:@"default"];
    }

}
- (IBAction)clickKTVBtn:(id)sender {
    self.restrantBtn.selected=NO;
    self.hotelBtn.selected=NO;
    self.KTVBtn.selected=YES;
    self.coffeeBtn.selected=NO;
    self.v_restrantsBG.backgroundColor=[UIColor clearColor];
    self.v_hotelBG.backgroundColor=[UIColor clearColor];
    self.v_KTVBG.backgroundColor=TempleColor;
    self.v_coffeeBG.backgroundColor=[UIColor clearColor];
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self loadListDatasWithCategoryId:2 SortId:@"distance"];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self loadListDatasWithCategoryId:2 SortId:@"price"];
    }
    if (self.segmentControl.selectedSegmentIndex==2) {
        [self loadListDatasWithCategoryId:2 SortId:@"default"];
    }

}
- (IBAction)clickCoffeeBtn:(id)sender {
    self.restrantBtn.selected=NO;
    self.hotelBtn.selected=NO;
    self.KTVBtn.selected=NO;
    self.coffeeBtn.selected=YES;
    self.v_restrantsBG.backgroundColor=[UIColor clearColor];
    self.v_hotelBG.backgroundColor=[UIColor clearColor];
    self.v_KTVBG.backgroundColor=[UIColor clearColor];
    self.v_coffeeBG.backgroundColor=TempleColor;
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self loadListDatasWithCategoryId:3 SortId:@"distance"];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self loadListDatasWithCategoryId:3 SortId:@"price"];
    }
    if (self.segmentControl.selectedSegmentIndex==2) {
        [self loadListDatasWithCategoryId:3 SortId:@"default"];
    }

}
- (IBAction)segmentVauleChanged:(id)sender {
    //排序（离我最近：distance,价格最优：price，默认排序:default）
    UISegmentedControl * sege=sender;
    [self getDataWithSegment:sege];
}
-(void)getDataWithSegment:(UISegmentedControl*)sege{
    if (sege.selectedSegmentIndex==0) {
        if (self.restrantBtn.selected==YES) {
            [self loadListDatasWithCategoryId:0 SortId:@"distance"];
        }
        if (self.hotelBtn.selected==YES) {
            [self loadListDatasWithCategoryId:1 SortId:@"distance"];
        }
        if (self.KTVBtn.selected==YES) {
            [self loadListDatasWithCategoryId:2 SortId:@"distance"];
        }
        if (self.coffeeBtn.selected==YES) {
            [self loadListDatasWithCategoryId:3 SortId:@"distance"];
        }
    }
    if (sege.selectedSegmentIndex==1) {
        if (self.restrantBtn.selected==YES) {
            [self loadListDatasWithCategoryId:0 SortId:@"price"];
        }
        if (self.hotelBtn.selected==YES) {
            [self loadListDatasWithCategoryId:1 SortId:@"price"];
        }
        if (self.KTVBtn.selected==YES) {
            [self loadListDatasWithCategoryId:2 SortId:@"price"];
        }
        if (self.coffeeBtn.selected==YES) {
            [self loadListDatasWithCategoryId:3 SortId:@"price"];
        }
        
    }
    if (sege.selectedSegmentIndex==2) {
        if (self.restrantBtn.selected==YES) {
            [self loadListDatasWithCategoryId:0 SortId:@"default"];
        }
        if (self.hotelBtn.selected==YES) {
            [self loadListDatasWithCategoryId:1 SortId:@"default"];
        }
        if (self.KTVBtn.selected==YES) {
            [self loadListDatasWithCategoryId:2 SortId:@"default"];
        }
        if (self.coffeeBtn.selected==YES) {
            [self loadListDatasWithCategoryId:3 SortId:@"default"];
        }
        
    }

}
/**
 *  获得商家类目
 *
 */
-(void)getStoreCategoryList{
    GetStoreCatagoryRequest * request = [[GetStoreCatagoryRequest alloc]init];
    [SystemAPI GetStoreCatagoryRequest:request success:^(GetStoreCatagoryResponse *response) {
        NSArray * names=(NSArray*)response.data;
        self.storeCategory=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        for (int i=0; i<self.btns.count; i++) {
            UIButton * btn=[self.btns objectAtIndex:i];
            NSDictionary * dic=[names objectAtIndex:i];
            [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        }
        [self loadListDatasWithCategoryId:0 SortId:@"distance"];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
/**
 *  默认加载离我最近的餐厅数据
 *  排序（离我最近：distance,价格最优：price，默认排序:default）
 */
-(void)loadListDatasWithCategoryId:(int)cid SortId:(NSString*)sortId{
    NSDictionary * caDic=[self.storeCategory objectAtIndex:cid];
    NSString * caId=[NSString stringWithFormat:@"%@",[caDic objectForKey:@"id"]];
    GetStoreListsRequest * request=[[GetStoreListsRequest alloc]init];
    request.categoryId=caId;
    request.sortField=sortId;
    request.areaId=self.tempCityId;
    request.lat=[ShareValue shareInstance].currentLocation.latitude;
    request.lng=[ShareValue shareInstance].currentLocation.longitude;
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.listData=nil;
    [SystemAPI GetStoreListsRequest:request success:^(GetStoreListsResponse *response) {
        self.listData=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
         [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view.window];
    }];
}
#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoresListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:StoresListTableViewCellId];
    if (!cell) {
        cell=[[StoresListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoresListTableViewCellId];
    }
    NSDictionary * dic =[self.listData objectAtIndex:indexPath.section];
    cell.distance.font=[UIFont fontWithName:iconFont size:18];
    cell.distance.text=@"\U0000e60f";
    cell.distance.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
    NSString * names=[NSString stringWithFormat:@"%@%@",@"\U0000e60f",[dic objectForKey:@"distance"]];
    NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
    [str addAttribute:NSForegroundColorAttributeName value:iconBlue range:NSMakeRange(0, cell.distance.text.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(cell.distance.text.length, str.length-cell.distance.text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(cell.distance.text.length, str.length-cell.distance.text.length)];
    cell.distance.attributedText=str;
    
    cell.storeName.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    cell.cost.text=[NSString stringWithFormat:@"人均:￥%@",[dic objectForKey:@"price"]];
    cell.collectNumber.text=[NSString stringWithFormat:@"收藏：%@",[dic objectForKey:@"collectNum"]];
    cell.star=[NSString stringWithFormat:@"%@",[dic objectForKey:@"star"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic=[self.listData objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"storeDetails" sender:dic];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"storeDetails"]) {
        StoreDetailsViewController * vc=segue.destinationViewController;
        vc.infoDic=sender;
    }
    if ([segue.identifier isEqualToString:@"exchangeCity"]) {
        ExchangeCityViewController * vc=segue.destinationViewController;
        vc.delegate=self;
    }
}
-(void)getCityName:(NSDictionary *)city{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CITY_UPDATED object:nil];
    NSString * CityTitle=[NSString stringWithFormat:@"%@ \U0000e637",[city objectForKey:@"name"]];
    [self.cityBtn setTitle:CityTitle forState:UIControlStateNormal];
    self.tempCityId=[[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] copy];
    NSLog(@"city:%@",city);
    [self getStoreCategoryList];
}
@end
