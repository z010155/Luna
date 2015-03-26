package Pets;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleAdoptPuffle($strData, $objClient) {}

method handleGetPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->write('%xt%pg%'.$arrData[5].'%');
}

method handlePuffleBath($strData, $objClient) {}

method handlePuffleFeed($strData, $objClient) {}

method handlePuffleRest($strData, $objClient) {}

method handlePuffleIsResting($strData, $objClient) {}

method handlePufflePlay($strData, $objClient) {}

method handlePuffleFeedFood($strData, $objClient) {}

method handlePuffleIsPlaying($strData, $objClient) {}

method handlePuffleMove($strData, $objClient) {}

method handlePuffleClick($strData, $objClient) {}

method handlePuffleUser($strData, $objClient) {}           

method handlePufflePip($strData, $objClient) {}

method handlePufflePir($strData, $objClient) {}

method handlePuffleWalk($strData, $objClient) {}

1;
