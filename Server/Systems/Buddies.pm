package Buddies;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGetBuddies($strData, $objClient) {
       my $strBuddies = $self->handleFetchBuddies($objClient);
       $objClient->write('%xt%gb%-1%' . ($strBuddies ? $strBuddies : '%'));
}

method handleFetchBuddies($objClient) {
       my $strInfo = '';
       foreach (keys %{$objClient->{buddies}}) {
	               my $arrInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `nickname` FROM users WHERE `ID` = '$_'");
	        	      $strInfo .= $_ . '|' . $arrInfo->{nickname} . '|' . $objClient->getOnline($_) . '%';
       }
       return $strInfo;
}

method handleBuddyRequest($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       $objPlayer->{buddyRequests}->{$objClient->{ID}} = 1;
       $objPlayer->sendXT(['br', '-1', $objClient->{ID}, $objClient->{username}]);  
}

method handleBuddyAccept($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       delete($objPlayer->{buddyRequests}->{$objClient->{ID}});
       $objClient->{buddies}->{$intBudID} = $objPlayer->{username};
       $objPlayer->{buddies}->{$objClient->{ID}} = $objClient->{username};
       my $cbStr = '';
       my $pbStr = '';
       while (my ($playerID, $playerName) = each(%{$objClient->{buddies}})) {
              $cbStr .= $playerID . '|' . $playerName . ',';
       }
       while (my ($playerID, $playerName) = each(%{$objPlayer->{buddies}})) {
              $pbStr .= $playerID . '|' . $playerName . ',';
       }
       $objClient->updateBuddies($cbStr, $objClient->{ID});
       $objPlayer->updateBuddies($pbStr, $objPlayer->{ID});
       $objPlayer->sendXT(['ba', '-1', $objClient->{ID}, $objClient->{username}]);
}

method handleBuddyRemove($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       delete($objClient->{buddies}->{$intBudID});
       delete($objPlayer->{buddies}->{$objClient->{ID}});
       my $cbStr = '';
       my $pbStr = '';
       while (my ($playerID, $playerName) = each(%{$objClient->{buddies}})) {
              $cbStr .= $playerID . '|' . $playerName . ',';
       }
       while (my ($playerID, $playerName) = each(%{$objPlayer->{buddies}})) {
              $pbStr .= $playerID . '|' . $playerName . ',';
       }
       $objClient->updateBuddies($cbStr, $objClient->{ID});
       $objPlayer->updateBuddies($pbStr, $objPlayer->{ID});
       $objPlayer->sendXT(['rb', '-1', $objClient->{ID}, $objClient->{username}]);
}

method handleBuddyFind($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       $objClient->sendXT(['bf', '-1', $objPlayer->{room}]);
}

1;
