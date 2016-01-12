//
//  ChooseAddressViewController.m
//  Meet
//
//  Created by Anita Lee on 15/10/7.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import "ChooseAddressViewController.h"

@interface ChooseAddressViewController ()<BMKMapViewDelegate>
{
    CLLocationCoordinate2D _coordinate;
    NSString *_address;
    BMKPointAnnotation *_annotation;
    BMKGeoCodeSearch *_search;
    BMKPointAnnotation * MyAnnotation;
}

@property (weak, nonatomic) IBOutlet UILabel *lb_current;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    MyAnnotation.coordinate = [ShareValue shareInstance].currentLocation;
    MyAnnotation.title = [ShareValue shareInstance].address;
    [self.mapView addAnnotation:MyAnnotation];
    self.lb_current.text=[ShareValue shareInstance].address;
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(locationDidChanged:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
}
-(void)initView{
    self.lb_current.adjustsFontSizeToFitWidth=YES;
    MyAnnotation = [[BMKPointAnnotation alloc]init];
    self.mapView.showsUserLocation=YES;
    BMKCoordinateRegion region=BMKCoordinateRegionMake([ShareValue shareInstance].currentLocation, BMKCoordinateSpanMake(1.0,1.0));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.ChangeWithTouchPointCenterEnabled=YES;
    self.mapView.scrollEnabled=YES;
    self.mapView.zoomLevel=16;
}
-(void)locationDidChanged:(NSNotification * )noti{
    [ShareValue shareInstance].address=noti.object;
    MyAnnotation.title = [ShareValue shareInstance].address;
    self.lb_current.text=[ShareValue shareInstance].address;
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:NOTIFICATION_LOCATION_UPDATED object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [[MapUtils shareInstance] startLocationUpdate];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    [self.delegate getAddressFromMap:self.lb_current.text];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * t=[touches anyObject];
    CGPoint center=[t locationInView:_mapView];
    CLLocationCoordinate2D poor=[_mapView convertPoint:center toCoordinateFromView:_mapView];
    [ShareValue shareInstance].currentLocation=poor;
    [[MapUtils shareInstance] startGeoCodeSearch];
    MyAnnotation.coordinate = [ShareValue shareInstance].currentLocation;
    MyAnnotation.title = [ShareValue shareInstance].address;
    self.lb_current.text=[ShareValue shareInstance].address;
}
/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(locationDidChanged:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    [ShareValue shareInstance].currentLocation=coordinate;
    [[MapUtils shareInstance] startGeoCodeSearch];
    MyAnnotation.coordinate = [ShareValue shareInstance].currentLocation;
    MyAnnotation.title = [ShareValue shareInstance].address;
    self.lb_current.text=[ShareValue shareInstance].address;
}


@end
