use strict;
use warnings;

our $loginConfig = {
    servPort => 6112,
    servType => 'login',
    debugging => 1
};

our $gameConfig = {
    servHost => '127.0.0.1',
    servName => 'Alpine',
    servPort => 6113,
    servType => 'game',
    debugging => 1,
    userPrefix => '!',
    staffPrefix => '#',
    botProp => {
            onServ => 1,
            botID => 0,
            botName => 'Mystic',
            bitMask => 1, # Default is 1 = English
            botColour => 14
            botHead => 1007,
            botFace => 106,
            botNeck => 0,
            botBody => 221,
            botHand => 0,
            botFeet => 0,
            botFlag => 0,
            botPhoto => 0,
            botXPos => 100,
            botYPos => 100,
            botFrame => 12,
            botMember => 1, 
            botRank => 999
    }
};

our $redeemConfig = {
    servPort => 6114,
    servType => 'redem',
    debugging => 1
};

our $dbConfig = {
    dbHost => '127.0.0.1',
    dbName => 'Luna',
    dbUser => 'root',
    dbPass => '1337hax'
};
