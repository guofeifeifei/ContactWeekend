//
//  Contactdefine.h
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#ifndef Contactdefine_h
#define Contactdefine_h
typedef NS_ENUM(NSInteger, ClassifyListType) {
    
    ClassifyListTypeShowRepertoire = 1, //演出剧目
    ClassifyListTypeTouristPlace,//景点场剧
    ClassifyListTypeStudyPUZ,//学习益智
    ClassifyListTypeTravel,//亲子旅游
    
    
};


//首页数据接口
//以后把所有的接口放在HWDefine中
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"

//活动专题接口
#define kThemeDetail @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"

//精选活动接口
#define KGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=1&type=1"


//热门专题
#define KHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=1"

//按钮
#define kClassList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"


//#define kClassList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"

#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"


//新浪微博
#define kAppKey @"2731707913"
#define kAppSecret @"b577adb568bb5572ecbe7121ec7a59ca"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"

//微信分享
#define kWeixinAppID @"wx29b93928456c25ed"
#define kWeixinAppSecret @"3e576c3c9e3ab80829a01c7a3d196cc2"
#define kWeixinRedirectURL


#endif /* Contactdefine_h */
