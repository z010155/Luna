package Bait;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{pluginType} = 'XT';
       $obj->{property} = {
              'i#ai' => { 
                     handler => 'handleItemBlocking',
                     isEnabled => 0
              }
       };
       return $obj;
}

method handleItemBlocking($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intItem = $arrData[5];
       if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$intItem}->{isBait}) {
           $objClient->sendError(800);
           $objClient->updateBan($objClient, 'PERM');
           return $self->{child}->{modules}->{base}->removeClient($objClient->{sock});
       }
}

1;
