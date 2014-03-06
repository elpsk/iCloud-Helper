//
//  APRoundedMenu.m
//  Milano Blu
//
//  Created by Alberto Pasca on 27/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APRoundedMenu.h"
#import <QuartzCore/QuartzCore.h>


@implementation APRoundedMenu

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  UIRectCorner corners;
  switch ( self.style ) {
    case 1:
      corners = UIRectCornerBottomLeft | UIRectCornerTopRight;
      break;
    case 3:
      corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
      break;
    case 4:
      corners = UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
      break;
    case 2:
    default:
      corners = UIRectCornerBottomRight | UIRectCornerTopRight;
      break;
  }

  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:corners
                                                       cornerRadii:CGSizeMake(20.0, 30.0)];

  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.frame         = self.bounds;
  maskLayer.path          = maskPath.CGPath;
  self.layer.mask         = maskLayer;
}


@end


