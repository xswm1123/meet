//
//  SystemHttpResquest.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "X_BaseHttpRequest.h"

@interface SystemHttpResquest : X_BaseHttpRequest

@end
//用户
/**
 *  发送验证码
 */
@interface GetCheckCodeRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * mobile;//手机号码
@end
/**
 *  忘记密码
 */
@interface ForgetPasswordRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * mobile;//手机号码
@property (nonatomic,strong) NSString * code;//验证码
@property (nonatomic,strong) NSString * password;//密码
@end
/**
 *  登录
 */
@interface LoginRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * account;//手机号码或相遇ID
@property (nonatomic,strong) NSString * password;//密码
@end
/**
 *  注册
 */
@interface RegisterRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * mobile;//手机号码
@property (nonatomic,strong) NSString * code;//验证码
@property (nonatomic,strong) NSString * password;//密码
@property (nonatomic,strong) NSString * recommendMeetid;//推荐人相遇ID
@property (nonatomic,strong) NSString * avatar;//头像
@property (nonatomic,strong) NSString * nickname;//昵称
@property (nonatomic,strong) NSString * birthday;//生日：yyyy-MM-dd
@property (nonatomic,strong) NSString * address;//所在城市
@property (nonatomic,strong) NSString * sex;//性别：1、男2、女
@end
//大厅
/**
 *  上传视频
 */
@interface UploadVideoRequest : X_BaseHttpRequest
//file
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * title;//视频标题
@property (nonatomic,strong) NSString * categoryId;//女神分类
@end
/**
 *  给视频送礼物
 */
@interface SendGiftToVideoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * videoId;//视频ID
@property (nonatomic,strong) NSString * itemId;//用户礼物ID
@property (nonatomic,strong) NSString * num;//赠送数量
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  评论视频
 */
@interface CommentVideoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * videoId;//视频ID
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * content;//评论内容
@end
/**
 *  获得收到的礼物列表
 */
@interface GetVideoReceivedGiftsListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * videoId;//视频ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  获得礼物评论
 */
@interface GetGiftsCommentsListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * videoId;//视频ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  获得视频详情
 */
@interface GetVideoDetailsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * videoId;//视频ID
@end
/**
 *  获得用户上传的视频列表
 */
@interface GetUserUploadedVideosListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sortField;//排序（热门：viewCount,最新：created）
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@property (nonatomic,strong) NSString * categoryId;//女神分类
@end
//商家
/**
 *  店铺获得的礼物
 */
@interface GetStoreReceivedGiftListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  给商家送礼物
 */
@interface SendGiftToStoreRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID;
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * num;//礼物数量
@property (nonatomic,strong) NSString * itemId;//用户的礼物ID
@end
/**
 *  获得商家评论列表
 */
@interface GetStoreCommentsListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  店铺评论
 */
@interface CommentStoreRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID;
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * content;//评论内容
@end
/**
 *  收藏店铺
 */
@interface CollectStoreRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID;
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  获得商家详情
 */
@interface GetStoreDetailsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * storeId;//商家ID;
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@end
/**
 *  获得商家列表
 */
@interface GetStoreListsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * categoryId;//类目ID
@property (nonatomic,strong) NSString * areaId;//地区ID
@property (nonatomic,strong) NSString * key;//关键词
@property (nonatomic,strong) NSString * sortField;//排序（离我最近：distance,价格最优：price，默认排序:default）
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,assign) NSInteger pageSize;//页大小，默认为20
@end
/**
 *  获得商家类目
 */
@interface GetStoreCatagoryRequest : X_BaseHttpRequest

@end
/**
 *  获得所有城市列表
 */
@interface GetAllCitysRequest : X_BaseHttpRequest

@end

//发现
/**
 *  发表朋友圈信息
 */
@interface PostFriendCircleRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * content;//内容
@property (nonatomic,strong) NSString * picUrl;//图片地址（多个图片,分隔）
@property (nonatomic,strong) NSString * videoUrl;//视频地址
@end
/**
 *  获得朋友圈列表
 */
@interface GetFriendCircleListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  改变朋友圈封面
 */
@interface ModifyFriendCircleCoverRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * picUrl;//图片地址
@end
/**
 *  排行榜
 */
@interface GetRankingListRequest : X_BaseHttpRequest

@end
/**
 *  排行榜详情
 */
@interface GetRankingDetailsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * sortField;//onlineTime:总排行meili:魅力totalPay:总消费gold总财富
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,assign) NSInteger pageSize;//页大小，默认为10
@end
/**
 *  附近的用户
 */
@interface GetNearByUserRequest : X_BaseHttpRequest
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sex;//1、男2、女
@property (nonatomic,strong) NSString * minAge;//年龄最小值
@property (nonatomic,strong) NSString * maxAge;//年龄最大值
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,assign) NSInteger pageSize;//页大小，默认为10
@end
/**
 *  评论朋友圈
 */
@interface CommentFriendCircleRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * content;//评论内容
@property (nonatomic,strong) NSString * parentMemberId;//上级用户ID，如果直接对朋友圈评论，则传0
@property (nonatomic,strong) NSString * circleId;//朋友圈ID
@end
/**
 *  用户个人朋友圈
 */
@interface GetPersonalFriendCircleRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * srcId;//访问者ID
@property (nonatomic,strong) NSString * targetId;//被访问者ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
//相遇
/**
 *  获得联系人列表
 */
@interface GetFriendsListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@end
/**
 *  获得我创建的群组
 */
@interface GetMyCreatedGroupsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  获得我加入的群组
 */
@interface GetMyJoinedGroupsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  获取个人信息
 */
@interface GetPersonalInfoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  修改个人头像
 */
@interface ModifyUserPhotoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,copy) NSString * avatar;//头像URL
@end
/**
 *  获取个人主页信息
 */
@interface GetHomePageInfoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * srcId;//访问者ID
@property (nonatomic,strong) NSString * targetId;//被访问者ID
@end
/**
 *  获取个人主页礼物
 */
@interface GetHomePageGiftsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,assign) NSInteger  pageSize;//页大小，默认为10
@end
/**
 *  发送好友请求
 */
@interface SendFriendRstRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * friendId;//好友ID
@property (nonatomic,strong) NSString * content;//请求内容
@end
/**
 *  修改个人信息
 */
@interface ModifyUserInfoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property(nonatomic,strong) NSString * nickname;//昵称
@property(nonatomic,strong) NSString * birthday;//生日
@property(nonatomic,strong) NSString * sign;//个性签名
@property(nonatomic,strong) NSString * affection;//情感状态
@property(nonatomic,strong) NSString * appearance;//外貌特征
@property(nonatomic,strong) NSString * profession;//从事职业
@property(nonatomic,strong) NSString * hobby;//兴趣爱好
@property(nonatomic,strong) NSString * address;//所在地
@end
/**
 *  获取群组标签
 */
@interface GetGroupTagsRequest : X_BaseHttpRequest
@end
/**
 *  获取黑名单列表
 */
@interface GetBlackListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  取消黑名单
 */
@interface CancelBlackListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * blackId;//黑名单用户ID
@end
/**
 *  创建群组
 */
@interface CreateGroupRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * name;//群组名
@property (nonatomic,strong) NSString * picUrl;//图片地址
@property (nonatomic,strong) NSString * areaId;//地区ID
@property (nonatomic,strong) NSString * maxNum;//最大人数
@property (nonatomic,strong) NSString * categoryId;//标签ID
//@property (nonatomic,strong) NSString * description;//描述
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@end
/**
 *  搜索好友
 */
@interface SearchUserRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * key;//关键词
@end
/**
 *  搜索群组
 */
@interface SearchGroupRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * key;//关键词
@property (nonatomic,strong) NSString * categoryId;//标签ID
@end
/**
 *  群组申请
 */
@interface ApplyGroupRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * groupId;//关键词
@property (nonatomic,strong) NSString * content;//标签ID
@end
/**
 *  获取好友验证
 */
@interface GetFriendApplyMessageRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  获取礼物消息
 */
@interface GetGiftMessageRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  添加黑名单
 */
@interface AddBlackListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sysId;//系统消息ID
@property (nonatomic,strong) NSString * blackId;//黑名单用户ID
@end
/**
 *  拒绝群组申请
 */
@interface RefuseGroupApplyRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * sysId;//系统消息ID
@end
/**
 *  拒绝好友申请
 */
@interface RefuseFriendApplyRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sysId;//系统消息ID
@property (nonatomic,strong) NSString * applyId;//申请者ID
@end
/**
 *  同意群组申请
 */
@interface AgreeGroupApplyRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * groupId;//群组ID
@property (nonatomic,strong) NSString * sysId;//系统消息ID
@property (nonatomic,strong) NSString * applyId;//申请者ID
@end
/**
 *  同意好友申请
 */
@interface AgreeFriendApplyRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sysId;//系统消息ID
@property (nonatomic,strong) NSString * applyId;//申请者ID
@end
//商城中心
/**
 *  获取商品类目
 */
@interface GetMallCategoryRequest : X_BaseHttpRequest

@end
/**
 *  根据ID获取商品类目
 */
@interface GetItemByIdRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * categoryId;//类目ID
@end
/**
 *  生成金币交易记录
 */
@interface CreateGoldTradeRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * num;//金币数量;
@property (nonatomic,strong) NSString * pay;//支付金额
@property (nonatomic,strong) NSString * payType;//(1、微支付2、支付宝)
@end
/**
 *  用金币购买礼物
 */
@interface BuyItemByGoldRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * itemId;//商品ID
@property (nonatomic,strong) NSString * num;//购买数量;
@end
/**
 *  获取领取金币的相关信息
 */
@interface GetGoldInfoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  每日领取金币
 */
@interface GetGoldForEverydayRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * gold;//数量;
@end
/**
 *  在线时长领取金币
 */
@interface GetGoldByOnlineTimeRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * gold;//数量;
@end
/**
 *  生成新的支付订单
 */
@interface CreatePayOrderRequest : X_BaseHttpRequest
@property (nonatomic,assign) NSInteger payType;//1、支付宝2、微支付
@property (nonatomic,assign) NSInteger tradeType;//1、金币充值2、会员充值
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) NSInteger gold;//金币数量
@property (nonatomic,assign) NSInteger month;//充值月份
@property (nonatomic,assign) NSInteger day;//体验天数
@property (nonatomic,assign) double price;//支付金额
@property (nonatomic,assign) NSInteger vipPriceId;
@end
/**
 *  改变地理位置
 */
@interface ChangeCurrentLocationRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@end
/**
 *  获得自己的排行榜
 */
@interface GetMyRankRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sortField;//
@end
/**
 *  获得可以用来赠送的礼物
 */
@interface GetCanSendGiftRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  送礼物给个人
 */
@interface SendGiftToPersonRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//被赠送ID
@property (nonatomic,strong) NSString * giveId;//赠送者ID
@property (nonatomic,strong) NSString * itemId;//商品ID
@property (nonatomic,strong) NSString * num;//数量;
@end
/**
 *  获得我收藏的商家
 */
@interface GetMyCollectedStoresRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  获取我发的视频列表
 */
@interface GetMyVideosRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@property (nonatomic,strong) NSString * targetId;//目标ID
@end
/**
 *  删除视频
 */
@interface DeleteMyVideoRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * videoId;
@end
/**
 *  附近的群组
 */
@interface GetNearByGroupRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) double lng;//经度
@property (nonatomic,assign) double lat;//纬度
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  微支付预支付订单
 */
@interface CreateWeChatPrePayRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * orderId;//
@property (nonatomic,assign) double  order_price;//
@property (nonatomic,strong) NSString * product_name;//
@property (nonatomic,strong) NSString * userId;//
@end
/**
 *  上传个人相册
 */
@interface UploadHomePagePicsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * pic;//
@end
/**
 *  获得推广信息
 */
@interface GetPromotionRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  点赞
 */
@interface GiveZanRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * srcId;//点赞人的ID
@property (nonatomic,strong) NSString * targetId;//被点赞的人ID
@end
/**
 *  获取个人主页相册
 */
@interface GetHomePageAlbumRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * srcId;//
@property (nonatomic,strong) NSString * targetId;//
@end
/**
 *  获取个人的商家详情
 */
@interface GetMyStoreDetailsRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  创建或修改个人商家
 */
@interface CreateMyStoreRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * areaId;
@property (nonatomic,assign) NSInteger categoryId;//
@property (nonatomic,assign) double lng;//
@property (nonatomic,assign) double lat;//
@property (nonatomic,strong) NSString * address;//
@property (nonatomic,strong) NSString * picUrl;//
@property (nonatomic,strong) NSString * title;//
@property (nonatomic,assign) double price;//
@property (nonatomic,strong) NSString * phone;//
@property (nonatomic,strong) NSString * desc;//
@property (nonatomic,strong) NSString * id;//
@property (nonatomic,strong) NSString * storeId;
@end
/**
 *  获取最近来访
 */
@interface GetLastVisitUsersRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) double lng;//
@property (nonatomic,assign) double lat;//
@end
/**
 *  删除个人相册图片
 */
@interface DeleteHomePageAlbumRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * picUrl;//
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  建议反馈
 */
@interface FeedBackRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * meetid;//
@property (nonatomic,strong) NSString * mobile;//
@property (nonatomic,strong) NSString * content;//
@property (nonatomic,strong) NSString * type;
@end
/**
 *  修改密码
 */
@interface ModifyPasswordRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * oldPwd;
@property (nonatomic,strong,getter=theNewPwd) NSString * newPwd;
@end
/**
 *  访问个人好友圈
 */
@interface GetMyFriendCircleRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * srcId;//
@property (nonatomic,strong) NSString * targetId;//
@property (nonatomic,strong) NSString * pageNumber;//当前页，默认为1
@property (nonatomic,strong) NSString * pageSize;//页大小，默认为10
@end
/**
 *  删除朋友圈
 */
@interface DeleteCirclePostRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,assign) NSInteger circleId;//
@end
/**
 *  举报
 */
@interface ReportUserRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * targetId;//
@property (nonatomic,strong) NSString * content;//
@property (nonatomic,strong) NSString * category;//
@property (nonatomic,strong) NSString * type;//
@end
/**
 *  获取最新的访客数
 */
@interface GetNearlyVisitCountRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * created;//
@end
/**
 *  更新个推CID
 */
@interface UpdateGetuiCidRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * clientId;//CID
@end
/**
 *  获得主页类目
 */
@interface GetIndexCategoryRequest : X_BaseHttpRequest

@end
/**
 *  根据类目获取主页视频列表
 */
@interface GetIndexVideoListRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * sortField;//
@property (nonatomic,strong) NSString * categoryId;//
@property (nonatomic,strong) NSString * pageNumber;//
@property (nonatomic,strong) NSString * pageSize;//
@end
/**
 *  内购临时接口
 */
@interface IAPPurchaseRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * month;//
@property (nonatomic,strong) NSString * gold;//
@end
/**
 *  删除朋友圈评论
 */
@interface DeleteCircleCommentRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * commentId;//评论ID
@end
/**
 *  第三方登录相关
 */
/**
 *  是否登录了第三方
 */
@interface IsLoginReqeust : X_BaseHttpRequest
@property(nonatomic,strong) NSString * openid;
@property (nonatomic,strong) NSString * loginType;//(1、qq2、wechat)
@end
/**
 *  注册第三方
 */
@interface RegisterExternRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * birthday;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * openid;
@property (nonatomic,strong) NSString * loginType;
@end
/**
 *  绑定手机
 */
@interface BlindMobileRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSString * code;
@end
/**
 *  绑定第三方
 */
@interface BlindExternRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property(nonatomic,strong) NSString * openid;
@property (nonatomic,strong) NSString * loginType;//(1、qq2、wechat)
@end
/**
 *  约吧
 */
@interface GetDatingDataRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@property (nonatomic,strong) NSString * pageNumber;//
@property (nonatomic,assign) NSInteger  pageSize;//
@end
/**
 *  发布约吧
 */
@interface PublishDatingRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  分享回调
 */
@interface ShareCallBackRequest : X_BaseHttpRequest
@property (nonatomic,strong) NSString * memberId;//用户ID
@end
/**
 *  获取VIP套餐
 */
@interface GetVIPTypesRequest : X_BaseHttpRequest

@end
