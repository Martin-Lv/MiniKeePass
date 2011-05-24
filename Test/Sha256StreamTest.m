//
//  Sha256StreamTest.m
//  MobileKeePass
//
//  Created by Jason Rush on 5/22/11.
//  Copyright 2011 Self. All rights reserved.
//

#import "Sha256StreamTest.h"
#import "Sha256OutputStream.h"
#import "DataOutputStream.h"

@implementation Sha256StreamTest

- (void)testSha256Stream {
    // Prepare some data
    const char* outputBuffer = "1234567890";
    
    // Create the output stream
    DataOutputStream *dataOutputStream = [[DataOutputStream alloc] init];
    Sha256OutputStream *sha256OutputStream = [[Sha256OutputStream alloc] initWithOutputStream:dataOutputStream];
    
    // Write out the data
    for (int i = 0; i < 5; i++) {
        NSUInteger numWritten = [sha256OutputStream write:outputBuffer length:10];
        STAssertTrue(numWritten == 10, @"Did not write expected number of bytes (%d)", numWritten);
    }
    
    [sha256OutputStream close];
    
    uint8_t *h1 = [sha256OutputStream getHash];
    
    uint8_t h2[32];
    uint32_t *b = (uint32_t*)h2;
    b[0] = CFSwapInt32BigToHost(0xf58fffba);
    b[1] = CFSwapInt32BigToHost(0x129aa67e);
    b[2] = CFSwapInt32BigToHost(0xc63bf125);
    b[3] = CFSwapInt32BigToHost(0x71a42977);
    b[4] = CFSwapInt32BigToHost(0xc0b785d3);
    b[5] = CFSwapInt32BigToHost(0xb2a93cc0);
    b[6] = CFSwapInt32BigToHost(0x538557c9);
    b[7] = CFSwapInt32BigToHost(0x1da2115d);
    
    // Check if the hashs differ
    BOOL differs = NO;
    for (int i = 0; i < 32 && !differs; i++) {
        differs |= (h1[i] != h2[i]);
    }
    
    STAssertFalse(differs, @"Hashs do not match");
}

@end
