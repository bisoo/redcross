//
//  CommonController.m
//  stilms
//
//  Created by coretechmobile on 13. 7. 25..
//  Copyright (c) 2013년 coretechmobile. All rights reserved.
//

#import "CommonController.h"

@implementation CommonController
@synthesize contextPath;
@synthesize logoutValue;
static CommonController *commonData =nil;//
- (id)init{
    self = [super init];
    if(self){
        //contextPath = @"http://192.168.0.131:8081/edu_mobile";
        contextPath = @"http://www.redcross.or.kr/edu_mobile";
        logoutValue = [[NSString alloc]init];
    }
    return self;
}

-(CommonController *)getInstance{
    
    if (commonData == nil) {
        commonData = [self init];
    }
    
    return commonData;
    
}


@end

