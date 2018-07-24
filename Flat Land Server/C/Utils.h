//
//  Utils.h
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/18/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#include <stdio.h>

#define Init_opcode 0
#define Check_opcode 1
#define Update_opcode 2
#define Server_op_opcode 3
#define MAX_NAME_LEN 6

#define SERVER_EXIT ((uint8_t)1)

struct PlayerInitPacket{
    uint8_t opcode;
    char name[6];
    uint8_t id;
    uint8_t config;
};

struct PlayerConnectionCheckPacket{
    uint8_t opcode;
    int32_t hash;
};

struct PlayerControlPacket {
    uint8_t opcode;
    float dx;
    float dy;
    float angle;
};

struct ServerOpPacket{
    uint8_t opcode;
    uint8_t server_code;
};

typedef union{
    struct PlayerInitPacket initPacket;
    struct PlayerControlPacket controlPacket;
    struct PlayerConnectionCheckPacket connectionCheckPacket;
    struct ServerOpPacket serverOpPacket;
}PlayerPacket;

char* getPlayerName(struct PlayerInitPacket packet);
struct ServerOpPacket* getServerOpcodePacket(uint8_t code);
struct PlayerInitPacket* getInitPacket(char* name, uint8_t id, uint8_t config);
struct PlayerConnectionCheckPacket* getCheckPacket(int32_t hash);
struct PlayerControlPacket* getControlPacket(float dx, float dy, float angle);

#endif /* Utils_h */
