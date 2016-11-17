//
//  SignatureCreatorView.m
//  SignatureCreatorObjC
//
//  Created by Neil Francis Hipona on 11/17/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "SignatureCreatorView.h"

@interface SignatureCreatorView()

@property (nonatomic, strong) UIBezierPath *signaturePath;
@property (nonatomic, strong) UITouch *signatureTouch;
@property (nonatomic, strong) NSMutableArray *pointsArray;

@end

@implementation SignatureCreatorView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pointsArray = [@[] mutableCopy];
    self.lineWidth = 1;
    self.signatureColor = [UIColor blackColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.signatureColor setStroke];

    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);

    for (UIBezierPath *path in self.pointsArray) {
        [path stroke];

        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    }
}


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

- (void)resetSignature {
    
    self.pointsArray = [@[] mutableCopy];
    [self setNeedsDisplay];
}

- (void)undo {
    
    [self.pointsArray removeLastObject];
    [self setNeedsDisplay];
}

@end
