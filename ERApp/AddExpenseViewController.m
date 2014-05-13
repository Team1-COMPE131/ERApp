//
//  AddExpenseViewController.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "UIImage+Scale.h"
#import "SBJson.h"

@interface AddExpenseViewController () {
    BOOL kbDismiss;
    UITextField *vendor;
    UITextField *location;
    UITextField *amount;
    UITextView *note;
    NSMutableString *expenseType;
    NSMutableString *currency;
    BOOL imageSelected;
    UIImage *selImage;
    UIAlertView *procAlert;
}
-(void)cancel:(id)sender;
-(void)addReport:(id)sender;
@end

@implementation AddExpenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Add Expense"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addReport:)];
    [self.navigationItem setRightBarButtonItem:add];
    vendor = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [vendor setDelegate:self];
    [vendor setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [vendor setAutocorrectionType:UITextAutocorrectionTypeNo];
    [vendor setKeyboardType:UIKeyboardTypeDefault];
    [vendor setTextColor:[UIColor darkGrayColor]];
    [vendor setReturnKeyType:UIReturnKeyNext];
    [vendor setClearButtonMode:UITextFieldViewModeWhileEditing];
    [vendor setPlaceholder:@"Name of Expense"];
    location = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [location setDelegate:self];
    [location setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [location setAutocorrectionType:UITextAutocorrectionTypeNo];
    [location setKeyboardType:UIKeyboardTypeDefault];
    [location setTextColor:[UIColor darkGrayColor]];
    [location setReturnKeyType:UIReturnKeyNext];
    [location setClearButtonMode:UITextFieldViewModeWhileEditing];
    [location setPlaceholder:@"Location (e.g. San Jose, CA)"];
    amount = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [amount setDelegate:self];
    [amount setKeyboardType:UIKeyboardTypeDecimalPad];
    [amount setTextColor:[UIColor darkGrayColor]];
    [amount setReturnKeyType:UIReturnKeyNext];
    [amount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [amount setPlaceholder:@"Amount (e.g. 9.25)"];
    note = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 300, 122)];
    [note setDelegate:self];
    [note setTextColor:[UIColor darkGrayColor]];
    [note setFont:[UIFont systemFontOfSize:16.0f]];
    expenseType = [[NSMutableString alloc] initWithString:@"Rent"];
    currency = [[NSMutableString alloc] initWithString:@"USD"];
    kbDismiss = NO;
    imageSelected = NO;
    procAlert = [[UIAlertView alloc] initWithTitle:@"Submitting Expense..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 3;
    else if (section==1) {
        if (imageSelected) {
            return 2;
        }
        return 1;
    }
    else if (section==2) return 2;
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UITextField *tx in cell.contentView.subviews) {
        if ([tx isKindOfClass:[UITextField class]]) {
            [tx removeFromSuperview];
        }
    }
    
    for (UIImageView *tx in cell.contentView.subviews) {
        if ([tx isKindOfClass:[UIImageView class]]) {
            [tx removeFromSuperview];
        }
    }
    
    for (UITextView *tx in cell.contentView.subviews) {
        if ([tx isKindOfClass:[UITextView class]]) {
            [tx removeFromSuperview];
        }
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.contentView addSubview:vendor];
        }
        else if (indexPath.row==1) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.contentView addSubview:location];
        }
        else if (indexPath.row==2) {
            UITableViewCell *spCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Special"];
            [spCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [spCell.textLabel setText:@"Expense Type"];
            [spCell.detailTextLabel setText:expenseType];
            return spCell;
        }
    }
    else if(indexPath.section==1) {
        if (indexPath.row==0) {
            UITableViewCell *ss = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SS"];
            [ss.textLabel setTextAlignment:NSTextAlignmentCenter];
            if (imageSelected) {
                [ss.textLabel setText:@"Tap to Replace Expense Receipt"];
            }
            else {
                [ss.textLabel setText:@"Tap to Add Expense Receipt"];
            }
            return ss;
        }
        else {
            UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            [imView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.contentView addSubview:imView];
            [imView setImage:selImage];
        }
    }
    else if(indexPath.section==2) {
        if (indexPath.row==0) {
            [cell.contentView addSubview:amount];
        }
        else {
            UITableViewCell *spCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Special"];
            [spCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [spCell.textLabel setText:@"Currency"];
            [spCell.detailTextLabel setText:currency];
            return spCell;
        }
    }
    else if(indexPath.section==3) {
        [cell.contentView addSubview:note];
    }
    
    return cell;
}

-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==3) {
        return 132.0f;
    }
    else if (indexPath.section==1 && indexPath.row==1 && imageSelected) {
        return 200.0f;
    }
    return 44.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==3) {
        return @"Notes";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row==2) {
        OptionSelectorViewController *optView = [[OptionSelectorViewController alloc] initWithType:0 preSelection:[[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] text]];
        [optView setDelegate:self];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController pushViewController:optView animated:YES];
    }
    else if(indexPath.section==1&&indexPath.row==0) {
        UIActionSheet *pick = [[UIActionSheet alloc] initWithTitle:@"Add Expense Receipt" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Photo Library", @"Take a Picture", nil];
        [pick setTag:222];
        [pick showInView:self.navigationController.view];
    }
    else if (indexPath.section==2 && indexPath.row==1) {
        OptionSelectorViewController *optView = [[OptionSelectorViewController alloc] initWithType:1 preSelection:[[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] text]];
        [optView setDelegate:self];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController pushViewController:optView animated:YES];
    }
}

#pragma mark Private Methods

-(void)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addReport:(id)sender {
    kbDismiss = YES;
    [vendor resignFirstResponder];
    [location resignFirstResponder];
    [amount resignFirstResponder];
    [note resignFirstResponder];
    if ([[vendor text] length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Submit" message:@"Please provide the Expense Name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[location text] length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Submit" message:@"Please provide the Location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[location text] length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Submit" message:@"Please provide the Amount of Expense." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [procAlert show];
    
    if (imageSelected) {
        ASIFormDataRequest *imageReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://erapp.kevjung.com/receipt_proc.php"]];
        [imageReq setData:UIImageJPEGRepresentation(selImage, 1.0f) withFileName:@"receipt.jpg" andContentType:@"image/jpeg" forKey:@"receipt"];
        __unsafe_unretained ASIFormDataRequest *_imageReq = imageReq;
        [imageReq setCompletionBlock:^{
            if ([_imageReq responseStatusCode]==200) {
                datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/create-expense"]];
                [datReq setDelegate:self];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
                [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
                [datReq setPostValue:[vendor text] forKey:@"Vendor"];
                [datReq setPostValue:[location text] forKey:@"Location"];
                [datReq setPostValue:expenseType forKey:@"Type"];
                [datReq setPostValue:[amount text] forKey:@"Amount"];
                [datReq setPostValue:currency forKey:@"Currency"];
                [datReq setPostValue:[note text] forKey:@"Note"];
                [datReq setPostValue:[_imageReq responseString] forKey:@"Receipt"];
                [datReq startAsynchronous];
            }
            else {
                [procAlert dismissWithClickedButtonIndex:0 animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Submit" message:@"An error occurred while submitting your expense report. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        [imageReq startAsynchronous];
    }
    else {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/create-expense"]];
        [datReq setDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq setPostValue:[vendor text] forKey:@"Vendor"];
        [datReq setPostValue:[location text] forKey:@"Location"];
        [datReq setPostValue:expenseType forKey:@"Type"];
        [datReq setPostValue:[amount text] forKey:@"Amount"];
        [datReq setPostValue:currency forKey:@"Currency"];
        [datReq setPostValue:[note text] forKey:@"Note"];
        [datReq startAsynchronous];
    }
}

#pragma mark ASIHTTPRequest

-(void)requestFinished:(ASIHTTPRequest *)request {
    [procAlert dismissWithClickedButtonIndex:0 animated:YES];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *d = [parser objectWithString:request.responseString];
    if ([d objectForKey:@"Error"]!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Submit" message:[d objectForKey:@"Error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        datReq = nil;
        return;
    }
    datReq = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    [procAlert dismissWithClickedButtonIndex:0 animated:YES];
    datReq = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"Please make sure you are connected to a network." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark UIText[]Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==vendor) {
        [location becomeFirstResponder];
    }
    else if(textField==location) {
        [amount becomeFirstResponder];
    }
    else if(textField==amount) {
        [note becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (SCREEN_IS_4_INCH) {
        [table setFrame:CGRectMake(0, 0, 320, 568-UIKEYBOARD_SIZE)];
    }
    else {
        [table setFrame:CGRectMake(0, 0, 320, 480-UIKEYBOARD_SIZE)];
    }
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (kbDismiss) {
        kbDismiss = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.3];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (SCREEN_IS_4_INCH) {
            [table setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else {
            [table setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [UIView commitAnimations];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (SCREEN_IS_4_INCH) {
        [table setFrame:CGRectMake(0, 0, 320, 568-UIKEYBOARD_SIZE)];
    }
    else {
        [table setFrame:CGRectMake(0, 0, 320, 480-UIKEYBOARD_SIZE)];
    }
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (kbDismiss) {
        kbDismiss = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.3];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (SCREEN_IS_4_INCH) {
            [table setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else {
            [table setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [UIView commitAnimations];
    }
}

#pragma mark SelectDelegate

-(void)selected:(NSString *)selection withType:(int)type {
    if (type==0) {
        [expenseType setString:selection];
    }
    else if(type==1) {
        [currency setString:selection];
    }
    [table reloadData];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imageSelected = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [(UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage] imageScaledToScale:0.15f];
    selImage = image;
    [table reloadData];
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==222) {
        if (buttonIndex==0) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
        else if(buttonIndex==1) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
    }
}

@end
