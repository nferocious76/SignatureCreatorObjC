//
//  SignatureCreatorView.m
//  SignatureCreatorObjC
//
//  Created by Neil Francis Hipona on 11/17/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "SignatureCreatorView.h"
#import <Photos/Photos.h>

@interface SignatureCreatorView()

@property (nonatomic, strong) UIBezierPath *signaturePath;
@property (nonatomic, strong) UITouch *signatureTouch;

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) NSMutableArray *pointsHistoryArray;


@end

@implementation SignatureCreatorView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pointsArray = [@[] mutableCopy];
    self.pointsHistoryArray = [@[] mutableCopy];
    
    self.lineWidth = 1;
    self.signatureColor = [UIColor blackColor];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.signatureColor setStroke];
    [self.backgroundColor setFill];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect iFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGContextFillRect(context, iFrame);
    CGContextSetAlpha(context, self.alpha);

    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);

    for (UIBezierPath *path in self.pointsArray) {
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = self.lineWidth;
        
        [path stroke];
    }
}

#pragma mark - Touch configuration

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // use the first touch
    for (UITouch *touch in touches) {
        self.signatureTouch = touch;
        
        CGPoint touchLocation = [touch locationInView:self];
        
        [self setNewPoint:touchLocation];

        break;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if ([touch isEqual:self.signatureTouch]) {
            
            CGPoint touchLocation = [touch locationInView:self];
            [self addNewLinePoint:touchLocation];
            [self setNewPoint:touchLocation];

            break;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if ([touch isEqual:self.signatureTouch]) {
            
            CGPoint touchLocation = [touch locationInView:self];
            [self addNewLinePoint:touchLocation];
            
            break;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if ([touch isEqual:self.signatureTouch]) {
            
            CGPoint touchLocation = [touch locationInView:self];
            [self addNewLinePoint:touchLocation];
            
            break;
        }
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Helpers

- (void)setNewPoint:(CGPoint)point {
    
    // re-initialize
    self.signaturePath = [UIBezierPath bezierPath];
    [self.signaturePath moveToPoint:point];
}

- (void)addNewLinePoint:(CGPoint)linePoint {
    
    [self.signaturePath addLineToPoint:linePoint];
    [self.signaturePath closePath];
    
    [self.pointsArray addObject:self.signaturePath];
}

- (UIImage *__nullable)renderSignature:(CGBlendMode)blendMode useBlendMode:(BOOL)useMode {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (useMode) {
        CGContextSetBlendMode(context, blendMode);
    }
    
    [self.layer renderInContext:context];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return signatureImage;

}

#pragma mark - User Controls

- (void)undo {

    if ([self.pointsArray lastObject]) {
        UIBezierPath *mostRecent = [self.pointsArray lastObject];
        [self.pointsHistoryArray addObject:mostRecent];
    }
    
    [self.pointsArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)redo {
    
    if ([self.pointsHistoryArray lastObject]) {
        UIBezierPath *mostRecent = [self.pointsHistoryArray lastObject];
        [self.pointsArray addObject:mostRecent];
    }
    
    [self.pointsHistoryArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)reset {
    
    self.pointsArray = [@[] mutableCopy];
    self.pointsHistoryArray = [@[] mutableCopy];
    
    [self setNeedsDisplay];
}

- (void)saveSignatureWithCompletionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler {
    
    UIImage *signatureImage = [self renderSignature:kCGBlendModeNormal useBlendMode:NO];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:signatureImage];
    } completionHandler:completionHandler];    
}

- (void)saveSignatureWithBlendMode:(CGBlendMode)blendMode completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler {
    
    UIImage *signatureImage = [self renderSignatureWithBlendMode:blendMode];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:signatureImage];
    } completionHandler:completionHandler];
}

- (UIImage *__nullable)renderSignature {
    
    return [self renderSignature:kCGBlendModeNormal useBlendMode:NO];
}

- (UIImage *__nullable)renderSignatureWithBlendMode:(CGBlendMode)blendMode {

    return [self renderSignature:blendMode useBlendMode:YES];
}


@end
