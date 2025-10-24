/* ppc_driver.c - Example CPU driver (addresses depend on your memory map)
   Compile with powerpc64le-linux-gnu-gcc cross-compiler for Microwatt.
*/
#include <stdint.h>
#include <stdio.h>

#define AES_BASE 0x40000000UL
#define W(addr) (*(volatile uint32_t *)(AES_BASE + (addr)))

#define ADDR_KEY0  0x00
#define ADDR_KEY4  0x04
#define ADDR_KEY8  0x08
#define ADDR_KEY12 0x0C
#define ADDR_PT0   0x10
#define ADDR_PT4   0x14
#define ADDR_PT8   0x18
#define ADDR_PT12  0x1C
#define ADDR_CTRL  0x20
#define ADDR_STATUS 0x24
#define ADDR_CT0   0x28
#define ADDR_CT4   0x2C
#define ADDR_CT8   0x30
#define ADDR_CT12  0x34

int main() {
    uint32_t key[4] = {0x00010203,0x04050607,0x08090a0b,0x0c0d0e0f};
    uint32_t pt[4]  = {0x00112233,0x44556677,0x8899aabb,0xccddeeff};

    // write key and plaintext
    W(ADDR_KEY0) = key[0];
    W(ADDR_KEY4) = key[1];
    W(ADDR_KEY8) = key[2];
    W(ADDR_KEY12)= key[3];

    W(ADDR_PT0) = pt[0];
    W(ADDR_PT4) = pt[1];
    W(ADDR_PT8) = pt[2];
    W(ADDR_PT12)= pt[3];

    // start
    W(ADDR_CTRL) = 1;

    // poll
    while ((W(ADDR_STATUS) & 0x1) == 0) { ; }

    uint32_t ct[4];
    ct[0] = W(ADDR_CT0);
    ct[1] = W(ADDR_CT4);
    ct[2] = W(ADDR_CT8);
    ct[3] = W(ADDR_CT12);

    printf("Ciphertext: %08x %08x %08x %08x\n", ct[0], ct[1], ct[2], ct[3]);
    return 0;
}
