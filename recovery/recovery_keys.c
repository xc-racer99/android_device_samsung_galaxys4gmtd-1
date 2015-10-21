#include <linux/input.h>

#include "recovery_ui.h"
#include "common.h"
#include "extendedcommands.h"


int device_handle_key(int key_code, int visible) {
    if (visible) {
        switch (key_code) {
            case KEY_VOLUMEDOWN:
            case 139: // MENU
                return HIGHLIGHT_DOWN;

            case KEY_VOLUMEUP:
            case 102: // HOME
                return HIGHLIGHT_UP;

            case 217: // SEARCH
                return SELECT_ITEM;

            case 158: // BACK
                    return GO_BACK;

            case KEY_POWER:
                return SELECT_ITEM;
            default:
                return NO_ACTION;
        }
    }

    return NO_ACTION;
}
