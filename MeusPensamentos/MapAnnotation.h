//
//  MapAnnotation.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 28/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "MeuPensamento.h"

@interface MapAnnotation : MKPointAnnotation

@property (strong, nonatomic) MeuPensamento *pensamento;

@end
