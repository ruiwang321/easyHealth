//
//  ShowDetailModel.h
//  EasyHealth
//
//  Created by yanchao on 15/12/1.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowDetailModel : NSObject
//==医院,药店详情页
proStr(name)
proStr(img)
proStr(address)
proStr(tel)

//医院特有
proStr(level)
proStr(mail)
proStr(message)
proStr(mtype)
proStr(url)
//药店特有
proStr(type)
proStr(business)


//==药品信息详情页
proStr(description)
proStr(factory)
proStr(id)
proStr(keywords)
proStr(price)
proStr(tag)

proStr(title)

//==疾病专用
proStr(department)  //!<疾病:医院所属科室
proStr(causetext)  //!<疾病:致病原因
proStr(symptomtext) //!<疾病:症状详情
proStr(foodtext)    //!<疾病:食疗详情
proStr(drugtext)    //!<疾病:用药详情
proStr(checktext)  //!<疾病:检查详情
@end
