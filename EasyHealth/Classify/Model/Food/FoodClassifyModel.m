//
//  FoodClassifyModel.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/29.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "FoodClassifyModel.h"
#import "FoodLiteClassifyModel.h"

@implementation FoodClassifyModel

@synthesize id;

+ (NSArray *)classifyModelsList {
    NSMutableArray *tempArr = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
    NSArray *dicArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in dicArr) {
        FoodClassifyModel *model = [[FoodClassifyModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        NSMutableArray *liteArr = [NSMutableArray array];
        for (NSDictionary *liteDic in dic[@"liteClassify"]) {
            FoodLiteClassifyModel *liteModel = [[FoodLiteClassifyModel alloc] init];
            [liteModel setValuesForKeysWithDictionary:liteDic];
            [liteArr addObject:liteModel];
        }
        model.liteClassifys = liteArr;
        [tempArr addObject:model];
    }
    return tempArr;
}
@end
