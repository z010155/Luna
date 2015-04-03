package Election;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleDonateCoins($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $id = $arrData[5]; # Poll ID? dunno.
       my $ammount = $arrData[6]; # Amount of coins to donate
       if ($objClient->{coins} < $ammount || !int($ammount)) {
              return $objClient->sendError(401);
       }
       $objClient->setCoins($objClient->{coins} - $ammount);
       $objClient->sendXT(['dc', $id, $objClient->{coins}]);
}

method handleSetPoll($strData, $objClient) {
       my @arrData = split('%', $strData);
       # Don't have handlers right now
}

1;
