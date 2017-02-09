//
//  main.m
//  Neovim4Unity
//
//  Created by Joni Strömberg on 15/11/2016.
//  Copyright © 2016 Yonstorm. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[]) {
    //int test = kCoreEventClass;
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, argv);
}
