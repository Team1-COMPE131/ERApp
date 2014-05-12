//
//  OptionSelectorViewController.m
//  ERApp
//
//  Created by Kevin Jung on 5/11/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "OptionSelectorViewController.h"

@interface OptionSelectorViewController () {
    int type;
    long selection;
    NSString *preselection;
}

@end

@implementation OptionSelectorViewController
@synthesize delegate;

-(id)initWithType:(int)t preSelection:(NSString*)sel {
    self = [super initWithNibName:@"OptionSelectorViewController" bundle:nil];
    if (self) {
        type = t;
        if (type==0) {
            [self.navigationItem setTitle:@"Select Expense Type"];
        }
        else if (type==1) {
            [self.navigationItem setTitle:@"Select Currency"];
        }
        preselection = sel;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    options = [[NSMutableArray alloc] init];
    if (type==0) {
        [options addObjectsFromArray:@[@"Rent", @"Utilities", @"Insurance", @"Fees", @"Wages", @"Taxes", @"Interest", @"Supplies", @"Depreciation", @"Maintenance", @"Travel", @"Meal", @"Entertainment", @"Training", @"Miscellaneous"]];
    }
    else if (type==1) {
        [options addObjectsFromArray:@[@"USD", @"EUR", @"KRW", @"JPY", @"CNY"]];
    }
    for (int i=0; i<[options count]; i++) {
        if ([[options objectAtIndex:i] isEqualToString:preselection]) {
            selection = i;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [options count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==selection) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.textLabel setText:[options objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long saved = selection;
    selection = indexPath.row;
    [delegate selected:[options objectAtIndex:selection] withType:type];
    [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:saved inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selection inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
