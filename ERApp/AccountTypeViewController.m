//
//  AccountTypeViewController.m
//  ERApp
//
//  Created by Kevin Jung on 5/9/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "AccountTypeViewController.h"

@interface AccountTypeViewController ()

@end

@implementation AccountTypeViewController
@synthesize delegate;

-(id)initWithType:(NSInteger)type {
    self = [super initWithNibName:@"AccountTypeViewController" bundle:nil];
    if (self) {
        accountType = type;
        [self.navigationItem setTitle:@"Select Account Type"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (indexPath.row==0) {
        if (accountType == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        [cell.textLabel setText:@"Individual"];
    }
    else {
        if (accountType == 1) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        [cell.textLabel setText:@"Corporate"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    accountType = indexPath.row;
    if (accountType==0) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else if (accountType==1) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    [delegate accountTypeSelected:accountType];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
