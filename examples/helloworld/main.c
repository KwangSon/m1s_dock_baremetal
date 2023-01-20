#include "bflb_mtimer.h"
#include "board.h"

int main(void)
{
    board_init();
    while (1) {
        bflb_mtimer_delay_ms(1000);
    }
}
