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
       my $puffleID = $arrData[5];
       my $puffleName = $arrData[6];
       if ($objClient->{coins} < 800) {
           return $objClient->sendError(401);
       }
       my $puffleString = $objClient->addPuffle($puffleID, $puffleName);
       my $adoptTime = time;
       my $postcardType = 111;
       my $postcardID = $objClient->sendPostcard($objClient->{ID}, 'sys', 0, 'Thanks For Adopting Me!', $postcardType, $adoptTime);
       $objClient->sendXT(['mr', '-1', 'sys', 0, $postcardType, $puffleName, $adoptTime, $postcardID]);
       $objClient->sendXT(['pn', '-1', $objClient->{coins}, $puffleString]);
       $objClient->sendXT(['pgu', '-1', $objClient->getPuffles($objClient->{ID})]);
}

method handleGetPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID));
       $objClient->sendXT(['pg', '-1', $objClient->getPuffles($puffleID)]);
}

method handlePuffleBath($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       if ($objClient->{coins} < 5) {
           return $objClient->sendError(401);
       }
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->setCoins($objClient->{coins} - 5);
       $objClient->sendRoom('%xt%pb%-1%'.$objClient->{coins}.'%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%');
}

method handlePuffleFeed($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       my $puffleTreat = $arrData[6];
       return if (!int($puffleID) || !int($puffleTreat) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       if ($objClient->{coins} < 5) {
           return $objClient->sendError(401);
       }
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->setCoins($objClient->{coins} - 5);
       $objClient->sendRoom('%xt%pt%-1%'.$objClient->{coins}.'%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%'.$puffleTreat.'%');
}

method handlePuffleRest($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%pr%-1%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%');
}

method handlePufflePip($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%pir%-1%'.$petDetails->{puffleID}.'%'.$arrData[6].'%'.$arrData[7].'%');
}

method handlePufflePlay($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       # OK, Play Types - 0:normal, 1:super, 2:great
       $objClient->sendRoom('%xt%pp%-1%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%'.int(rand(2)).'%');
}

method handlePuffleFeedFood($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       if ($objClient->{coins} < 10) {
           return $objClient->sendError(401);
       }
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->setCoins($objClient->{coins} - 10);
       $objClient->sendRoom('%xt%pf%-1%'.$objClient->{coins}.'%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%');
}

method handlePufflePir($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%pir%-1%'.$petDetails->{puffleID}.'%'.$arrData[6].'%'.$arrData[7].'%');
}

method handlePuffleMove($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%pm%-1%'.$arrData[5].'%'.$arrData[6].'%'.$arrData[7].'%');
}

method handlePuffleUser($strData, $objClient) {
       $objClient->sendXT(['pgu', '-1', $objClient->getPuffles($objClient->{ID})]);
}           

method handlePuffleIsPlaying($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%ip%-1%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%'.$arrData[6].'%'.$arrData[7].'%');

}

method handlePuffleIsFeeding($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%if%-1%'.$objClient->{coins}.'%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%'.$arrData[6].'%'.$arrData[7].'%');

}

method handlePuffleIsResting($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]) || $self->{child}->{modules}->{mysql}->countRows("SELECT `ownerID` FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'") eq 0);
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       $objClient->sendRoom('%xt%ir%-1%'.$petDetails->{puffleID}.'|'.$petDetails->{puffleName}.'|'.$petDetails->{puffleType}.'|100|100|100%'.$arrData[6].'%'.$arrData[7].'%');
}

method handleSendPuffleFrame($strData, $objClient) {
       my @arrData = split('%', $strData);
       # Not sure if it's valid... will check later
       $objClient->sendRoom('%xt%ps%-1%'.$arrData[5].'%'.$arrData[6].'%');
}

method handlePuffleWalk($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]));
       my $petDetails = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT * FROM puffles WHERE `puffleID` = '$puffleID' AND `ownerID` = '$objClient->{ID}'");
       if ($petDetails) {
                my $walkStr = $petDetails->{puffleID} . '|' . $petDetails->{puffleName} . '|' . $petDetails->{puffleType} . '|100|100|100|0|0|0|0|0|0';
           if ($arrData[6] eq 1) {
                $objClient->updatePlayerCard('upa', 'hand', 75 . $petDetails->{puffleType});
                $objClient->sendRoom('%xt%pw%-1%'. $objClient->{ID} . '%' . $walkStr . '|1%');
           } else {
                $objClient->updatePlayerCard('upa', 'hand', 0);
                $objClient->sendRoom('%xt%pw%-1%'. $objClient->{ID} . '%' . $walkStr . '|0%');
           }
       }
}

1;
