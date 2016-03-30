//
//  UserInfoModel.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/3.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/**
 *  账户或昵称
 */
@property (nonatomic, copy) NSString *account;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  头像URL 需要在前面添加【http://tnfs.tngou.net/image】或者【http://tnfs.tngou.net/img】
 前者可以再图片后面添加宽度和高度
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  性别 1:男 0:女 -1:保密
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  个性签名
 */
@property (nonatomic, copy) NSString *signature;
@end
