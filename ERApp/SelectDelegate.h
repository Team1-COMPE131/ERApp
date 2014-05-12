//
//  SelectDelegate.h
//  ERApp
//
//  Created by Kevin Jung on 5/11/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectDelegate <NSObject>

-(void)selected:(NSString*)selection withType:(int)type;

@end
