//
//  Expense.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject {
    NSString *title;
    int category;
    double amount;
    NSDate *date;
    NSData *receipt;
}

-(id)initWithExpense:(NSDictionary*)expenseData;
-(NSString*)getTitle;
-(int)getCategory;
-(double)getAmount;
-(NSDate*)getDate;
-(NSData*)getReceipt;

@end
