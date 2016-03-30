//
//  CookClassifyModel.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/27.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "CookClassifyModel.h"

#import "CookLiteClassifyModel.h"

@implementation CookClassifyModel

@synthesize id;

+ (NSArray *)classifyModelsList {
    NSMutableArray *tempArr = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Cook" ofType:@"plist"];
    NSArray *dicArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in dicArr) {
        CookClassifyModel *model = [[CookClassifyModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        NSMutableArray *liteArr = [NSMutableArray array];
        for (NSDictionary *liteDic in dic[@"liteClassify"]) {
            CookLiteClassifyModel *liteModel = [[CookLiteClassifyModel alloc] init];
            [liteModel setValuesForKeysWithDictionary:liteDic];
            [liteArr addObject:liteModel];
        }
        model.liteClassifys = liteArr;
        [tempArr addObject:model];
    }
    return tempArr;
}

@end
