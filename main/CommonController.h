//
//  CommonController.h
//  stilms
//
//  Created by coretechmobile on 13. 7. 25..
//  Copyright (c) 2013년 coretechmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonController : NSObject{
    
}

- (CommonController *)getInstance;
@property (nonatomic,strong) NSString *contextPath;
@property (nonatomic,strong) NSString *logoutValue;
@end
