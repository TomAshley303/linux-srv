<?php

// Another keep alive script. This time much simpler in PHP. Can put call in loop or add script to cron.

function isProc($procName) {
    $pid=exec("pidof $procName");
    exec("ps -p $pid", $output);

    if (count($output) > 1) {
        return true;
    }
    else {
        return false;
    }
}

if(!isProc('jobManager')){
    exec("nohup /var/www/bin/jobManager > /dev/null 2>&1 &");
}
