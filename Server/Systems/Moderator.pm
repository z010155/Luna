package Moderator;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleKick($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       my $objPlayer = $objClient->getClientByID($intPID);
       if ($objClient->{isStaff}) {
           $objPlayer->sendError(5);
           $self->{child}->{modules}->{base}->removeClient($objPlayer->{sock});
       } else {
           $objClient->sendError(800);
           $self->{child}->{modules}->{base}->removeClient($objClient->{sock});
       }
}

method handleMute($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       my $objPlayer = $objClient->getClientByID($intPID);
       if ($objClient->{isStaff}) {
           if (!$objPlayer->{isMuted}) {
               $objClient->updateMute($objPlayer, 1);
               $objClient->botSay($objPlayer->{username} . ' Has Been Muted By: ' . $objClient->{username});
           } elsif ($objPlayer->{isMuted}) {
               $objClient->updateMute($objPlayer, 0);
               $objClient->botSay($objPlayer->{username} . ' Has Been Unmuted By: ' . $objClient->{username});
           }
       } else {
           $objClient->sendError(800);
           $self->{child}->{modules}->{base}->removeClient($objClient->{sock});
       }
}

method handleBan($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       my $objPlayer = $objClient->getClientByID($intPID);
       if ($objClient->{isStaff}) {
           if ($objPlayer->{isBanned} eq '') {
               $objClient->updateBan($objPlayer, 'PERM');
               $objPlayer->sendError(603);
               $objClient->botSay($objClient->{username} . ' Has Permanently Banned ' . $objPlayer->{username});
               $self->{child}->{modules}->{base}->removeClient($objPlayer->{sock});
           }
       } else {
           $objClient->sendError(800);
           $self->{child}->{modules}->{base}->removeClient($objClient->{sock});
       }
}

1;
