//
//  PensamentoImage.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 05/06/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeuPensamento;

@interface PensamentoImage : NSManagedObject

@property (nonatomic, retain) NSData * cell;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MeuPensamento *pensamento;

@end
