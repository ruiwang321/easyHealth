//
//  ApisDefine.h
//  EasyHealth
//
//  Created by yanchao on 15/11/22.
//  Copyright © 2015年 EasyHealthTeam. All rights reserved.
//

#ifndef ApisDefine_h
#define ApisDefine_h

//基本api地址
#define API_BASE_URL    @"http://www.tngou.net/api/"

//基本图片接口
#define API_PIC         @"http://tnfs.tngou.net/image"
//基本搜索接口
#define API_Search      @"http://www.tngou.net/api/search"


#pragma mark --首页
//资讯
//取得健康资讯分类，可以通过分类id取得资讯列表
#define API_INFO_CLASSIFY   [API_BASE_URL stringByAppendingPathComponent:@"info/classify"]
//取得健康资讯列表，也可以用分类id作为参数取得列表
#define API_INFO_LIST       [API_BASE_URL stringByAppendingPathComponent:@"info/list"]
//取得最新的健康资讯，通过id取得大于该id的新闻
#define API_INFO_NEWS       [API_BASE_URL stringByAppendingPathComponent:@"info/news"]
//取得资讯详情，通过热点id取得该对应详细内容信息
#define API_INFO_SHOW       [API_BASE_URL stringByAppendingPathComponent:@"info/show"]

//知识
//取得健康知识分类，可以通过分类id取得问答列表
#define API_LORE_CLASSIFY   [API_BASE_URL stringByAppendingPathComponent:@"lore/classify"]
//取得健康知识列表，也可以用分类id作为参数
#define API_LORE_LIST       [API_BASE_URL stringByAppendingPathComponent:@"lore/list"]
//取得最新的健康知识，通过id取得大于该id的知识
#define API_LORE_NEWS       [API_BASE_URL stringByAppendingPathComponent:@"lore/news"]
//取得健康知识，通过热点id取得该对应详细内容信息
#define API_LORE_SHOW       [API_BASE_URL stringByAppendingPathComponent:@"lore/show"]

//图书
//取得健康知识列表，也可以用分类id作为参数
#define API_BOOK_LIST       [API_BASE_URL stringByAppendingPathComponent:@"book/list"]
//取得健康知识，通过健康图书id取得该对应详细内容信息
#define API_BOOK_SHOW       [API_BASE_URL stringByAppendingPathComponent:@"book/show"]

//食品信息
//取得食品分类，可以通过分类id取得问答列表(已有本地plist)
#define API_FOOD_CLASSIFY   [API_BASE_URL stringByAppendingPathComponent:@"food/classify"]
//取得食品列表，也可以用分类id作为参数
#define API_FOOD_LIST       [API_BASE_URL stringByAppendingPathComponent:@"food/list"]
//取得食品名称详情，通过name取得食品详情
#define API_FOOD_NAME       [API_BASE_URL stringByAppendingPathComponent:@"food/name"]
//取得食品信息，通过食物id取得该对应详细内容信息
#define API_FOOD_SHOW       [API_BASE_URL stringByAppendingPathComponent:@"food/show"]

//菜谱信息
//取得菜谱分类，可以通过分类id取得问答列表(已有本地plist)
#define API_COOK_CLASSIFY   [API_BASE_URL stringByAppendingPathComponent:@"cook/classify"]
//取得菜谱列表，也可以用分类id作为参数
#define API_COOK_LIST       [API_BASE_URL stringByAppendingPathComponent:@"cook/list"]
//取得菜谱名称详情，通过name取得菜谱详情
#define API_COOK_NAME   [API_BASE_URL stringByAppendingPathComponent:@"cook/name"]
//取得菜谱信息，菜谱id取得该对应详细内容信息
#define API_COOK_SHOW   [API_BASE_URL stringByAppendingPathComponent:@"cook/show"]



#pragma mark --分类
//药品信息
//取得药品分类，可以通过分类id取得药品列表(已有本地plist)
#define API_DRUG_CLASSIFY   [API_BASE_URL stringByAppendingPathComponent:@"drug/classify"]
//取得药品列表，也可以用分类id作为参数
#define API_DRUG_LIST       [API_BASE_URL stringByAppendingPathComponent:@"drug/list"]
//取得药品名称详情，通过name取得药品详情
#define API_DRUG_NAME       [API_BASE_URL stringByAppendingPathComponent:@"drug/name"]
//取得药品信息，通过id取得该对应详细内容信息
#define API_DRUG_SHOW       [API_BASE_URL stringByAppendingPathComponent:@"drug/show"]
//通过国药准字查询药品信息
#define API_DRUG_NUMBER     [API_BASE_URL stringByAppendingPathComponent:@"drug/number"]
//通过条形码查询药品信息
#define API_DRUG_CODE       [API_BASE_URL stringByAppendingPathComponent:@"drug/code"]

//疾病信息
//取得疾病列表，也可以用分类id作为参数(已有本地plist)
#define API_DISEASE_LIST    [API_BASE_URL stringByAppendingPathComponent:@"disease/list"]
//取得身体部位疾病，也可以用身体id作为参数
#define API_DISEASE_PLACE   [API_BASE_URL stringByAppendingPathComponent:@"disease/place"]
//取得科室疾病，也可以用科室id作为参数
#define API_DISEASE_DEPART  [API_BASE_URL stringByAppendingPathComponent:@"disease/department"]
//取得疾病名称详情，通过name取得疾病详情
#define API_DISEASE_NAME    [API_BASE_URL stringByAppendingPathComponent:@"disease/name"]
//取得疾病信息，id取得该对应详细内容信息
#define API_DISEASE_SHOW    [API_BASE_URL stringByAppendingPathComponent:@"disease/show"]
//==获取科室(已有本地plist)
//取得全部科室
#define API_DEPARTMENT_ALL  [API_BASE_URL stringByAppendingPathComponent:@"department/all"]
//取得科室列表
#define API_DEPARTMENT_CLASSIFY  [API_BASE_URL stringByAppendingPathComponent:@"department/classify"]
//==身体部位(已有本地plist)
//取得全部部位（两层)
#define API_PLACE_ALL       [API_BASE_URL stringByAppendingPathComponent:@"place/all"]
//传入模糊部分id获得详细部位，不传则获取模糊部位
#define API_PLACE_CLASSIFY  [API_BASE_URL stringByAppendingPathComponent:@"place/classify"]


#pragma mark ---附近
//==医院信息
//取得医院列表，可以通过地域城市id取得医院列表
#define API_HOSPITAL_LIST   [API_BASE_URL stringByAppendingPathComponent:@"hospital/list"]
//通过位置坐标 x,y取得周边医院
#define API_HOSPITAL_LOCATION  [API_BASE_URL stringByAppendingPathComponent:@"hospital/location"]
//取得医院，id取得该对应详细内容信息
#define API_HOSPITAL_SHOW   [API_BASE_URL stringByAppendingPathComponent:@"hospital/show"]
//医院名称，取得医院信息
#define API_HOSPITAL_NAME   [API_BASE_URL stringByAppendingPathComponent:@"hospital/name"]
//医院科室，取得医院特色科室
#define API_HOSPITAL_FEATURE   [API_BASE_URL stringByAppendingPathComponent:@"hospital/feature"]

//==药店信息
//取得药店列表，可以通过地域城市id取得药店列表
#define API_STORE_LIST      [API_BASE_URL stringByAppendingPathComponent:@"store/list"]
//通过位置坐标 x,y取得周边药店
#define API_STORE_LOCATION  [API_BASE_URL stringByAppendingPathComponent:@"store/location"]
//取得药房药店，id取得该对应详细内容信息
#define API_STORE_SHOW      [API_BASE_URL stringByAppendingPathComponent:@"store/show"]
//药店名称，取得药店信息
#define API_STORE_NAME      [API_BASE_URL stringByAppendingPathComponent:@"store/name"]

//==地市信息(已有本地plist)
//取得地域信息
#define API_AREA_REGION     [API_BASE_URL stringByAppendingPathComponent:@"area/region"]
//取得省份信息
#define API_AREA_PROVINCE   [API_BASE_URL stringByAppendingPathComponent:@"area/province"]
//取得城市信息
#define API_AREA_CITY       [API_BASE_URL stringByAppendingPathComponent:@"area/city"]


#pragma mark ---我

// 应用ID
#define CLIENT_ID @"357839"
// 应用KEY
#define CLIENT_SECRET @"ae6a51c9b5c3d23f9fbb7a17341860ea"
// 回调地址
#define REDIRECT_URL @"http://www.tngou.net/api/oauth2/response"

//==登录接口
// 本地登录
/*
 client_id      是	string	OAuth2客户ID
 redirect_uri	是	string	回调地址
 state          否	string	可选参数
 */
#define API_ACCOUNT_AUTHORIZE [API_BASE_URL stringByAppendingPathComponent:@"oauth2/authorize"]
//
/*
 client_id      是	string	OAuth2客户ID
 client_secret	是	string	安全密文
 code           是	string	调用oauth2/authorize 接口返回的授权码
 */
#define API_ACCOUNT_ACCESSTOKEN [API_BASE_URL stringByAppendingPathComponent:@"oauth2/accesstoken"]
//新浪微博第三方登录
#define API_ACCOUNT_OPEN_XINLANG [API_BASE_URL stringByAppendingPathComponent:@"oauth2/open/sina"]
//QQ第三方登陆
#define API_ACCOUNT_OPEN_QQ [API_BASE_URL stringByAppendingPathComponent:@"oauth2/open/qq"]
//非web登录
#define API_ACCOUNT_LOGIN [API_BASE_URL stringByAppendingPathComponent:@"oauth2/login"]
//注册
#define API_ACCOUNT_REGISTER [API_BASE_URL stringByAppendingPathComponent:@"oauth2/reg"]

//获取用户信息
#define API_ACCOUNT_USERINFO [API_BASE_URL stringByAppendingPathComponent:@"user"]

//收藏关系
#define API_ACCOUNT_SAVE [API_BASE_URL stringByAppendingPathComponent:@"favorite"]
//添加收藏
#define API_ACCOUNT_SAVE_ADD [API_BASE_URL stringByAppendingPathComponent:@"favorite/add"]
//删除收藏
#define API_ACCOUNT_SAVE_DEL [API_BASE_URL stringByAppendingPathComponent:@"favorite/delete"]
//收藏列表
#define API_ACCOUNT_SAVE_LIST [API_BASE_URL stringByAppendingPathComponent:@"my/favorite"]




#endif /* ApisDefine_h */
