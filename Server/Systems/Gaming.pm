package Gaming;

use strict;
use warnings;

use Math::Round qw(round);
use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{puck} = '0%0%0%0';
       return $obj;
}

method handleGameOver($strData, $objClient) {
       my @arrData = split('%', $strData);
       if ($objClient->{room} <= 899 || $objClient->{room} >= 1000) {
              return $objClient->sendXT(['zo', '-1', $objClient->{coins}, '', 0, 0, 0]);
       }
       if ($arrData[5] > 99999) {
              $objClient->sendError(611);
              return $self->{child}->{modules}->{base}->removeClientBySock($objClient->{sock});
       }
       my $coins = round($arrData[5] / 10);
       $objClient->setCoins($objClient->{coins} + $coins);
       # No stamps yet, later?
       $objClient->sendXT(['zo', '-1', $objClient->{coins}, '', 0, 0, 0]);
}

method handleMovePuck($strData, $objClient) {
       my @arrData = split('%', $strData);
       $self->{puck} = $arrData[6] . '%' . $arrData[7] . '%' . $arrData[8] . '%' . $arrData[9];
       $objClient->sendRoom('%xt%zm%-1%'.$arrData[5].'%'.$self->{puck}.'%');
}

method handleGetZone($strData, $objClient) {
       my @arrData = split('%', $strData);
       if ($objClient->{room} == 802) {
             return $objClient->sendXT(['gz', '802', $self->{puck}]);
       }
}

1;
