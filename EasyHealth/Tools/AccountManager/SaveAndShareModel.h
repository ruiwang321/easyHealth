//
//  SaveAndShareModel.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/5.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveAndShareModel : NSObject 
/**
 *  对象ID
 */
@property (nonatomic, copy) NSString *id;
/**
 *  对象类型：博客blog，论坛bbs，知识lore
 */
@property (nonatomic, copy) NSString *type;
/**
 *  对象标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  收藏标签
 */
@property (nonatomic, copy) NSString *keyword;

@end
