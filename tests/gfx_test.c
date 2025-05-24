#include "gfx.h"
#include <stdio.h>
#include <string.h>

static unsigned char framebuffer[1000];
static vbe_modeinfoblock_t mib = {0};
static vbe_controlinfoblock_t cib = {0};

int main() {
    mib.x_resolution = 10;
    mib.y_resolution = 10;
    mib.bits_per_pixel = 8;
    mib.phys_base_ptr = (unsigned int)(framebuffer);
    init_gfx(&mib,&cib);
    set_color(0xff,0,0);
    set_clip(2,2,8,8);
    fill_rectangle(0,0,10,10);
    int count=0;
    for(int y=0;y<10;y++)
        for(int x=0;x<10;x++)
            if(framebuffer[y*10+x]) count++;
    printf("pixels=%d\n",count);
    return 0;
}
