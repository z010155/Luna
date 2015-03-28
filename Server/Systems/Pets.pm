package Pets;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleAdoptPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       if ($objClient->{coins} < 800) {
              return $objClient->sendError(401);
       }
       my $puffleString = $objClient->addPuffle($arrData[5], $arrData[6]);
       $objClient->sendXT(['pn', '-1', $objClient->{coins}, $puffleString]);
       $objClient->sendXT(['pgu', '-1', $objClient->getPuffles($objClient->{ID})]);
}

method handleGetPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendXT(['pg', '-1', $objClient->getPuffles($arrData[5])]);
}

method handlePuffleBath($strData, $objClient) {}

method handlePuffleFeed($strData, $objClient) {}

method handlePuffleRest($strData, $objClient) {}

method handlePuffleIsResting($strData, $objClient) {}

method handlePufflePlay($strData, $objClient) {}

method handlePuffleFeedFood($strData, $objClient) {}

method handlePuffleIsPlaying($strData, $objClient) {}

method handlePuffleMove($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendXT(['pm', '-1', $arrData[5], $arrData[6], $arrData[7]]);
}

method handlePuffleClick($strData, $objClient) {
       $objClient->sendXT(['phg', '1836', '1']);
}

method handlePuffleUser($strData, $objClient) {}           

method handlePufflePip($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendXT(['pip', '-1', $arrData[5], $arrData[6], $arrData[7]]);
}

method handlePufflePir($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendXT(['pip', '-1', $arrData[5], $arrData[6], $arrData[7]]);
}

method handlePuffleWalk($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '".$arrData[5]."'");
       if ($petDetails) {
             $objClient->updatePlayerCard('upa', 'hand', '75'.$petDetails->{puffleType});
             my $walkStr = $petDetails->{puffleID} . '|' . $petDetails->{puffleName} . '|' . $petDetails->{puffleType} . '|0|0|0|0|0|1';
             $objClient->sendRoom('%xt%pw%-1%'.$objClient->{ID}.'%'.$walkStr.'%');
       }
}

1;
