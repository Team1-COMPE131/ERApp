//
//  UpdateDelegate.h
//  ERApp
//
//  Created by Kevin Jung on 5/12/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"

@protocol UpdateDelegate <NSObject>
-(void)expenseUpdatedWithExpense:(Expense*)ex andNewReceipt:(UIImage*)r;
@end
