//
//  CookClassifyModel.h
//  easyHealthy
//
//  Created by 王睿 on 15/11/27.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "ClassifyBasicModel.h"

@interface CookClassifyModel : ClassifyBasicModel

proStr(id)
proStr(name)
proArray(liteClassifys)

+ (NSArray *)classifyModelsList;

@end
