//
//  SaveListModel.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveListModel : NSObject
/**
 *  收藏标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  对象类型
 */
@property (nonatomic, copy) NSString *otype;
/**
 *  对象id
 */
@property (nonatomic, copy) NSString *oid;
/**
 *  收藏标签
 */
@property (nonatomic, copy) NSString *tag;
/**
 *  收藏时间
 */
@property (nonatomic, copy) NSString *time;

@end
