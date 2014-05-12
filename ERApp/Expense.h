//
//  Expense.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject {
    NSString *expenseID;
    NSString *vendor;
    NSString *location;
    NSString *type;
    double amount;
    NSString *currency;
    NSString *time;
    NSString *receipt;
    NSString *note;
}

-(id)initWithID:(NSString*)eid vendor:(NSString*)v location:(NSString*)l type:(NSString*)ty amount:(double)a currency:(NSString*)c time:(NSString*)t receipt:(NSString*)r note:(NSString*)n;

@property (nonatomic,readonly) NSString *expenseID;
@property (nonatomic,readonly) NSString *vendor;
@property (nonatomic,readonly) NSString *location;
@property (nonatomic,readonly) NSString *type;
@property (nonatomic,readonly) double amount;
@property (nonatomic,readonly) NSString *currency;
@property (nonatomic,readonly) NSString *time;
@property (nonatomic,readonly) NSString *receipt;
@property (nonatomic,readonly) NSString *note;

@end
