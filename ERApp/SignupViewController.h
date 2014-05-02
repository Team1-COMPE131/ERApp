//
//  SignupViewController.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface SignupViewController : UIViewController<ASIHTTPRequestDelegate> {
    ASIFormDataRequest *datReq;
}

-(void)dismiss;
-(void)verifyInfo;
-(void)signup;

@end
