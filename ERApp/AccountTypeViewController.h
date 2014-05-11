//
//  AccountTypeViewController.h
//  ERApp
//
//  Created by Kevin Jung on 5/9/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountTypeDelegate.h"

@interface AccountTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    __weak id <AccountTypeDelegate> delegate;
    IBOutlet UITableView *table;
    NSInteger accountType;
}
-(id)initWithType:(NSInteger)type;
@property (nonatomic,weak) id <AccountTypeDelegate> delegate;
@end
