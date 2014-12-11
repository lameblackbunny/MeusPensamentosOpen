//
//  MeuPensamento.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 05/06/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PensamentoImage;

@interface MeuPensamento : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) PensamentoImage *image;

@end
