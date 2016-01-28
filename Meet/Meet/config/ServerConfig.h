//
//  ServerConfig.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#ifndef MyFramework_ServerConfig_h
#define MyFramework_ServerConfig_h
/**
 *  接口返回成功与否标志code
 *
 *  @param !
 *
 *  @return
 */
#define DEFINE_SUCCESSCODE @"1"
/**
 *  环境配置
 *
 *  @param ! URL
 *
 *  @return
 */
//测试环境   com.brant.imdelivery   com.doone.beeTheOne 138185888802 811202
#define BASE_SERVERLURL @"http://xy.immet.cm/"
//#define BASE_SERVERLURL @"http://192.168.2.102:8080/"
//生产环境
//#define BASE_SERVERLURL @"http://120.55.75.55:8080/"

//从服务器更新APP URL
/*
 https下载
 */
#define URL_UPDATING_APP @"itms-services://?action=download-manifest&url=https://bee.doone.com.cn/client/hphwd.plist"
/**
 *  上传文件路径
 *
 */
#define URL_UPLOADFILES @"xy/rest/common/upload"//上传文件接口
/**
 *  接口action
 *
 */

#define ChangeCurrentLocation @"xy/rest/personal/inner/changeLocation"//改变地理位置
#define GetCheckCode @"xy/rest/personal/sendCode"//发送验证码
#define ForgetPassword @"xy/rest/personal/forgetPwd"//忘记密码
#define Login @"xy/rest/personal/login"//登录
#define Register @"xy/rest/personal/register"//注册
#define UploadVideo @"xy/rest/hall/inner/uploadVideo"//上传视频
#define SendGiftToVideo @"xy/rest/hall/inner/giveItemForVideo"//给视频送礼物
#define CommentVideo @"xy/rest/hall/inner/addVideoComment"//评论视频
#define GetVideoReceivedGiftList @"xy/rest/hall/getVideoItem"//获得收到的礼物列表
#define GetVideoComments @"xy/rest/hall/getVideoComment"//获得视频评论
#define GetVideoDetails @"xy/rest/hall/getVideoDetail"//获得视频详情
#define GetCanSendGift @"xy/rest/personal/inner/getMemberItem"//获得可以来赠送的礼物
#define GetVideoList @"xy/rest/hall/getVideoListByCategoryId"//获得用户上传的视频列表
#define GetGiftToStores @"xy/rest/store/getStoreItem"//店铺获得的礼物
#define SendGiftToStore @"xy/rest/store/inner/giveItemForStore"//给商家送礼物
#define SendGiftToPerson @"xy/rest/personal/inner/giveItemForMember"//送礼物给个人
#define GetStoreCommentList @"xy/rest/store/getStoreComment"//获得商家评论列表
#define CommentStore @"xy/rest/store/inner/addStoreComment"//店铺评论
#define CollectStore @"xy/rest/store/inner/collectStore"//收藏店铺
#define GetStoreDetails @"xy/rest/store/getStoreDetail"//获得商家详情
#define GetStoresList @"xy/rest/store/getStoreList"//获得商家列表
#define GetStoreCatagory @"xy/rest/store/getStoreCategoryList"//获得商家类目
#define GetAllCitys @"xy/rest/common/getArea"//获得所有城市列表
#define PostFirendCircle @"xy/rest/find/inner/addFriendCircle"//发表朋友圈信息
#define GetFriendCircleLsit @"xy/rest/find/inner/getFriendCircle"//获得朋友圈列表
#define ModifyFriendCircleCover @"xy/rest/find/inner/changeCirclePic"//改变朋友圈封面
#define CommentFriendCircle @"xy/rest/find/inner/addCircleComment"//评论朋友圈
#define GetNearByUser @"xy/rest/find/inner/getNearbyMember"//附近的人
#define GetNearByGroup @"xy/rest/find/inner/getNearbyGroup"//附近的群组
#define GetRankingList @"xy/rest/find/getRanking"//排行榜
#define GetRaningDetails @"xy/rest/find/getRankingDetail"//排行榜详情
#define GetMyRank @"xy/rest/find/inner/getMyRanking"//获得我自己的排名
#define GetPersonalFriendCircle @"xy/rest/find/inner/getMyCircle"//用户个人朋友圈-包括查看别人
#define GetFriendsList @"xy/rest/xiangyu/inner/getContactList"//获得联系人列表
#define GetMyCreatedGroups @"xy/rest/xiangyu/inner/getMyAddGroup"//获得我创建的群组
#define GetMyJoinedGroups @"xy/rest/xiangyu/inner/getMyJoinGroup"//获得我加入的群组
#define GetPersonalInfo @"xy/rest/personal/inner/getMemberById"//获取个人信息
#define ModifyUserPhoto @"xy/rest/personal/inner/updateAvatar"//修改头像
#define GetHomePageInfo @"xy/rest/personal/inner/getPersonalHome"//获取好友个人主页
#define GetHomePageGifts @"xy/rest/personal/inner/getMemberGiveItem"//获取个人主页礼物
#define SendFriendRst @"xy/rest/xiangyu/inner/applyFriend"//发送好友请求
#define ModifyUserInfo @"xy/rest/personal/inner/updateMember"//修改个人信息
#define GetGroupTags @"xy/rest/xiangyu/getGroupCategory"//获取群组标签
#define GetBlackList @"xy/rest/xiangyu/inner/getBlackList"//获取黑名单列表
#define CancelBlackList @"xy/rest/xiangyu/inner/deleteBlack"//取消黑名单
#define CreateGroup @"xy/rest/xiangyu/inner/addGroup"//创建群组
#define SearchUser @"xy/rest/xiangyu/inner/getMemberByKey"//搜索好友
#define SearchGroup @"xy/rest/xiangyu/inner/getGroupByKey"//搜索群组
#define ApplyGroup @"xy/rest/xiangyu/inner/applyGroup"//群组申请
#define GetFriendApplyMessage @"xy/rest/xiangyu/inner/getFriendValid"//获取好友验证消息
#define GetGiftMessage @"xy/rest/xiangyu/inner/getItemMessage"//获取赠送的礼物
#define AddBlackList @"xy/rest/xiangyu/inner/addBlack"//添加黑名单
#define RefuseGroupApply @"xy/rest/xiangyu/inner/refuseGroupValid"//拒绝群组申请
#define RefuseFriendApply @"xy/rest/xiangyu/inner/refuseFriendValid"//拒绝好友申请
#define AgreeGroupApply @"xy/rest/xiangyu/inner/agreeGroupValid"//同意群组申请
#define AgreeFriendApply @"xy/rest/xiangyu/inner/agreeFriendValid"//同意好友申请
#define GetMyCollectedStores @"xy/rest/personal/inner/getCollectStore"//获得我收藏的店铺列表
#define GetMyVideos @"xy/rest/personal/inner/getVideoByMemberId"//获得我的视频列表
#define DeleteMyVideo @"xy/rest/personal/inner/deleteVideo"//删除视频
#define UploadHomePagePics @"xy/rest/personal/inner/uploadPic"//上传个人相册
#define GetPromotion @"xy/rest/find/inner/getRecommendNum"//获得推广的信息
#define GiveZan @"xy/rest/personal/inner/zan"//点赞
#define GetHomePageAlbum @"xy/rest/personal/inner/getPersonalPic"//获得个人主页相册
#define GetMyStoreDetails @"xy/rest/find/inner/getMyStore"//获取个人商铺的详情
#define CreateMyStore @"xy/rest/xiangyu/inner/storeManager"//创建或修改个人商铺
#define GetLastVisitUsers @"xy/rest/find/inner/getNearbyViewMember"//获取最近来访的人
#define DeleteHomePageAlbum @"xy/rest/personal/inner/deleteMemberPic"//删除个人相册图片
#define FeedBack @"xy/rest/xiangyu/inner/feedback"//建议反馈
#define ReportUser @"xy/rest/personal/inner/report"//举报
#define ModifyPassword @"xy/rest/personal/inner/updatePwd"//修改密码
#define GetMyFriendCircle @"xy/rest/find/inner/getMyCircle"//获取我的个人好友圈
#define DeleteCirclePost @"xy/rest/personal/inner/deleteCircle"//删除朋友圈
#define GetNearlyVisitCount @"xy/rest/find/inner/getCountNearbyViewMember"//获取最新访客数
//商城中心
#define GetMallCategory @"xy/rest/find/getItemCategoryList"//获取商品类目
#define GetItemById @"xy/rest/find/getItem"//根据ID获取商品类目
#define CreateGoldTrade @"xy/rest/find/inner/addGoldTrade"//生成金币交易记录
#define BuyItemByGold @"xy/rest/find/inner/buyItem"//用金币购买礼物
//金币领取相关接口如下：
#define GetGoldInfo @"xy/rest/find/inner/getGoldGive"//获取领取金币的相关信息
#define GetGoldForEveryday @"xy/rest/find/inner/goldGetForEveryday"//每日领取金币
#define GetGoldByOnlineTime @"xy/rest/find/inner/goldGetForOnlineTime"//在线时长领取金币
//支付
#define GetVIPTpyes @"xy/rest/common/inner/getVipPriceList"//获取VIP套餐
#define CreatePayOrder @"xy/rest/pay/inner/addTradeOrder"//生成支付订单
#define CreateWeChatPrePay @"xy/rest/pay/weixin_notify"//生成微支付预支付订单
//个推
#define UpdateGetuiCid @"xy/rest/personal/inner/changeClientId"//更新个推CID
//内购临时接口
#define IAPPurchase @"xy/rest/pay/inner/paySuccess"//
/**
 *  一期增加及修改
 */
#define GetIndexCategory @"xy/rest/hall/getVideoCategoryList"//获得主页类目
#define GetIndexVideoList @"xy/rest/hall/getVideoListByCategoryId"//根据类目获得视频列表
#define DeleteCircleComment @"xy/rest/find/inner/deleteCircleComment"//删除朋友圈评论
/**
 *  第三方登录有关
 */
#define Islogin @"xy/rest/personal/isLogin" //判断第三方是否登录
#define RegisterExtern @"xy/rest/personal/registerExtern"//注册第三方登录
#define BlindMobile @"xy/rest/personal/inner/bindMobile"//绑定手机
#define BlindExtern @"xy/rest/personal/inner/bindExtern"//绑定第三方
/**
 *  约吧
 */
#define GetDatingData @"xy/rest/find/inner/getYuebaPage"//约吧
#define PublishDating @"xy/rest/find/inner/publishYueba"//发布约吧
/**
 *  分享回调
 */
#define ShareCallBack @"xy/rest/personal/inner/shareCallback"
/**
 *  定义机器、机型、系统的配置
 */
#define DEVCE_WITH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IOS8_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

#define ShareAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define NAVI_COLOR ([UIColor colorWithRed:38.0/255.0 green:42.0/255.0 blue:59.0/255.0 alpha:1.0])
#define TempleColor ([UIColor colorWithRed:201/255.0 green:32/255.0 blue:115/255.0 alpha:1.0])

#define iconFont @"iconfont" // 字体图标
#define cellColor ([UIColor colorWithRed:51/255.0 green:56/255.0 blue:77/255.0 alpha:1.0])
/**
 *  icon各种颜色
 */
#define iconGreen ([UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0])
#define iconBlue ([UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0])
#define iconRed ([UIColor colorWithRed:219/255.0 green:40/255.0 blue:163/255.0 alpha:1.0])
#define iconOrange ([UIColor colorWithRed:232/255.0 green:80/255.0 blue:63/255.0 alpha:1.0])
#define iconYellow ([UIColor colorWithRed:243/255.0 green:197/255.0 blue:45/255.0 alpha:1.0])
#define iconPurpule ([UIColor colorWithRed:156/255.0 green:88/255.0 blue:182/255.0 alpha:1.0])
/**
 *  placeholder
 */
#define placeHolder ([UIImage imageNamed:@"placehloder.png"])
#define circlePlaceHolder ([UIImage imageNamed:@"circle.jpg"])

/**
 *  第三方SDK KEY&授权信息
 */
//融云 融云新的app_key:k51hidwq1mupb
#define RIM_KEY @"tdrvipksr8ew5"
//百度统计SDK
#define BaiDu_statistics @"4de65c6e3b"
//百度地图
//#define BaiduMapKey @"bcnVr9sWUGGegvnzPwpfCt1E" //com.immet.meet 企业版本
#define BaiduMapKey @"qBwFnu4Myl1ZET1tWvOCofVm" //com.immet.meets AppStore
//个推
#define GeTui_kAppId           @"sMQ6Urvq5I9glrLfkPRas4"
#define GeTui_kAppKey          @"7kNxJmGvT1757cM0HBjd84"
#define GeTui_kAppSecret       @"t2AJVNtTAfAXhHBiEjHiqA"
/**
 *  极光推送
 */
#define JpushKey @"c1d260b352b9a1e69bc26022"
/**
 *  微信支付帐号：
 *
 */
#define WeiChatKey @"wxe00f626e25bd0b41"
/**
 *  通知等ID
 */
#define NOTIFICATION_CITY_UPDATED @"NOTIFICATION_CITY_UPDATED"
#define NOTIFICATION_UNREAD_SYSTEMMESSAGE @"NOTIFICATION_UNREAD_SYSTEMMESSAGE"
#define NOTIFICATION_UNREAD_LASTVISITMESSAGE @"NOTIFICATION_UNREAD_LASTVISITMESSAGE"
#define NOTIFICATION_UNREAD_CIRCLEMESSAGE @"NOTIFICATION_UNREAD_CIRCLEMESSAGE"
#define NOTIFICATION_POST_MESSAGE @"NOTIFICATION_POST_MESSAGE"
/**
 *  相遇，比陌陌更懂你！我在相遇，相遇号：10080.快来加入我们吧！http:www.immet.cm
 */
#define UmengShareContent ([NSString stringWithFormat:@"相遇，比陌陌更懂你！我在相遇，相遇号：%@.快来加入我们吧！http:www.immet.cm",[ShareValue shareInstance].userInfo.meetid])
#endif
