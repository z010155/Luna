package Redemption;

use strict;
use warnings;

use Method::Signatures;
use Array::Utils qw(array_diff);

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleRedemptionJoinServer($strData, $objClient) {
       my $intStr = join(',', map { $_; } 1..16);
       $objClient->sendXT(['rjs', '-1', $intStr, 0]);	             
}

method handleRedemptionGetBookQuestion($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPage = $self->{child}->{modules}->{crypt}->generateInt(1, 80);
       my $intLine = $self->{child}->{modules}->{crypt}->generateInt(1, 50);
       my $intWord = $self->{child}->{modules}->{crypt}->generateInt(1, 25);
       $objClient->sendXT(['rgbq', '-1', $arrData[5], $intPage, $intLine, $intWord]);
}

method handleRedemptionSendBookAnswer($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intCoins = $arrData[5];
       $objClient->sendXT(['rsba', '-1', $intCoins]);
       $objClient->updateCoins($objClient->{coins} + $intCoins);		
}

method handleRedemptionSendCode($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strName = $arrData[5];        
       if (length($strName) > 13) {
           return $objClient->sendError(21703);
       } elsif (length($strName) < 13) {
           return $objClient->sendError(21702);
       } elsif (!exists($self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName})) {
           return $objClient->sendError(20720);
       }       
       my $strItems = $self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName}->{items};
       my $intCoins = $self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName}->{cost};
       my @arrItems = split(',', $strItems);
       if (!array_diff(@arrItems, @{$objClient->{inventory}})) {
           return $objClient->sendError(20721);
       }
       $objClient->sendXT(['rsc', '-1', 'CAMPAIGN', $strItems, $intCoins]);  
       $objClient->updateCoins($objClient->{coins} - $intCoins);
       foreach (@arrItems) {
                $objClient->addItem($_);
       }
}

method handleRedemptionSendGoldenCode($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strName = $arrData[5];
       if (length($strName) > 13) {
           return $objClient->sendError(21703);
       } elsif (length($strName) < 13) {
           return $objClient->sendError(21702);
       } elsif (!exists($self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName})) {
           return $objClient->sendError(20720);
       } elsif ($self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName}->{type} eq 'normal') {
           return $self->{child}->{modules}->{base}->removeClientBySock($objClient->{sock});
       }
       my $strItems = $self->{child}->{modules}->{crumbs}->{redeemCrumbs}->{$strName}->{items};
       my @arrItems = split(',', $strItems);
       if (!array_diff(@arrItems, @{$objClient->{inventory}})) {
           return $objClient->sendError(20721);
       }
       $objClient->sendXT(['rsgc', '-1', 'GOLDEN', $strItems]);  
       foreach (@arrItems) {
                $objClient->addItem($_);
       }
}

1;
