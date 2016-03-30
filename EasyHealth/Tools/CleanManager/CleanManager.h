//
//  CleanManager.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/7.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CleanManager : NSObject

/**
 *  计算单个文件大小
 */
+ (float)fileSizeAtPath:(NSString *)path;

/**
 *  计算文件夹大小
 */
+ (float)folderSizeAtPath:(NSString *)path;

/**
 *  清除文件
 */
+ (void)clearCache:(NSString *)path;

@end
