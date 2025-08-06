if (should_blink) {

    blink_timer--;

    if (blink_timer <= 0) {
        should_blink = false;
        blink_timer = 90; 
        should_blink = false;
    }
}