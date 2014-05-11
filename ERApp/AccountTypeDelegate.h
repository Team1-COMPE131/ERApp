//
//  AccountTypeDelegate.h
//  ERApp
//
//  Created by Kevin Jung on 5/9/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccountTypeDelegate <NSObject>
-(void)accountTypeSelected:(NSInteger)type;
@end
