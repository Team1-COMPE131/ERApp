//
//  Expense.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "Expense.h"

@implementation Expense
@synthesize expenseID, vendor, location, type, amount, currency, time, receipt, note;

-(id)initWithID:(NSString *)eid vendor:(NSString *)v location:(NSString *)l type:(NSString *)ty amount:(double)a currency:(NSString *)c time:(NSString *)t receipt:(UIImage *)r note:(NSString *)n {
    self = [super init];
    if (self) {
        expenseID = eid;
        vendor = v;
        location = l;
        type = ty;
        amount = a;
        currency = c;
        time = t;
        receipt = r;
        note = n;
    }
    return self;
}

@end