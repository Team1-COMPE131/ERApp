//
//  OptionSelectorViewController.h
//  ERApp
//
//  Created by Kevin Jung on 5/11/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDelegate.h"

@interface OptionSelectorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    __weak id<SelectDelegate> delegate;
    IBOutlet UITableView *table;
    NSMutableArray *options;
}

-(id)initWithType:(int)type preSelection:(NSString*)sel;
@property (nonatomic,weak) id<SelectDelegate> delegate;
@end
