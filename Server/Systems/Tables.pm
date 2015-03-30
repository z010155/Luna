package Tables;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleJoinTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       return if(!int($arrData[5]));
       $objClient->sendXT(['jt', '-1']); #TableID%SeatID
}

method handleGetTable($strData, $objClient) {
       $objClient->sendXT(['gt', '-1']);
}

method handleUpdateTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%ut%'.$arrData[5].'%'.$arrData[6].'%'); # TableID%Players
}

method handleLeaveTable($strData, $objClient) {
       # really there's nothing to send
}

1;
