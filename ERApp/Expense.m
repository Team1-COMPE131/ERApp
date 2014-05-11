//
//  Expense.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "Expense.h"

@implementation Expense

-(id)initWithExpense:(NSDictionary *)expenseData {
    self = [self initWithTitle:[expenseData objectForKey:@"title"] category:[[expenseData objectForKey:@"category"] intValue] amount:[[expenseData objectForKey:@"amount"] doubleValue] date:[expenseData objectForKey:@"date"] receipt:[expenseData objectForKey:@"receipt"]];
    return self;
}

-(id)initWithTitle:(NSString *)t category:(int)c amount:(double)a date:(NSDate *)d receipt:(NSData *)r {
    self = [super init];
    if (self) {
        title = t;
        category = c;
        amount = a;
        date = d;
        receipt = r;
    }
    return self;
}

-(NSString*)getTitle {
    return title;
}

-(int)getCategory {
    return category;
}

-(double)getAmount {
    return amount;
}

-(NSDate*)getDate {
    return date;
}

-(NSData*)getReceipt {
    return receipt;
}

@end
