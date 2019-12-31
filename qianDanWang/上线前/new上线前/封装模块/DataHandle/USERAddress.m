//
//  USERAddress.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/26.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERAddress.h"

static USERAddress *_defaulthandle = nil;

@interface USERAddress ()
@property(nonatomic,strong)FMDatabase *fMDB;

@end


@implementation USERAddress

+(USERAddress *)shareUSERAddress{
    
    if (_defaulthandle == nil) {
        _defaulthandle = [[USERAddress alloc] init];
        
    }
    return _defaulthandle;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_defaulthandle == nil) {
        _defaulthandle = [super allocWithZone:zone];
    }
    return _defaulthandle;
}




-(FMDatabase *)fMDB
{
    if (!_fMDB) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"address.sqlite"];
        
        _fMDB = [FMDatabase databaseWithPath:path];
        [self initTable];
    }
    return _fMDB;
}


// 初始化数据表
-(void)initTable{
    [_fMDB open];
    
    [_fMDB executeUpdate:@"CREATE TABLE address (id INTEGER PRIMARY KEY AUTOINCREMENT,addName TEXT,addPhone TEXT,addCity TEXT,addxiangxi TEXT)"];
    
    [_fMDB close];
}


-(void)addOneData:(USERAdd *)user{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"insert into address (addName,addPhone,addCity,addxiangxi) values(%@,%@,%@,%@)",user.addName,user.addPhone,user.addCity,user.addxiangxi];
    
    [self.fMDB close];
}

-(void)deleteDataByID:(int)delID{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"DELETE FROM address WHERE id = %d",delID];
    
    [self.fMDB close];
}

-(NSArray *)getAllDatas{
    [self.fMDB open];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [self.fMDB executeQuery:@"SELECT * FROM address"];
    while ([result next])
    {
        USERAdd *model = [[USERAdd alloc] init];
        [arr addObject:model];
        
        model.addID = [result intForColumnIndex:0];
        model.addName = [result stringForColumnIndex:1];
        model.addPhone = [result stringForColumnIndex:2];
        model.addCity = [result stringForColumnIndex:3];
        model.addxiangxi = [result stringForColumnIndex:4];
        
    }
    [self.fMDB close];
    
    return [arr copy];
}

-(void)deleteTable{
    [self.fMDB open];
    //如果表格存在 则销毁
    BOOL result1 = [self.fMDB executeUpdate:@"drop table if exists address"];
    
    if (result1 ) {
//        NSLog(@"--------------------删除表1成功");
    } else {
//        NSLog(@"--------------------删除表1失败");
    }
    [self.fMDB close];
}

@end
