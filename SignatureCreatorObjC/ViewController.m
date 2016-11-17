//
//  ViewController.m
//  SignatureCreatorObjC
//
//  Created by Neil Francis Hipona on 11/17/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "ViewController.h"
#import "SignatureCreatorView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet SignatureCreatorView *signatureView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.signatureView.backgroundColor = [UIColor greenColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)optionButtons:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            [self.signatureView redo];
            break;
            
        case 2:
            [self.signatureView saveSignatureWithBlendMode:kCGBlendModeNormal completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"isSuccess: %d error: %@", success, error);
            }];
            break;

        case 3:
            [self.signatureView renderSignatureWithBlendMode:kCGBlendModeNormal];
            break;

        case 4:
            [self.signatureView reset];
            break;

        default:
            [self.signatureView undo];

            break;
    }
}

@end
