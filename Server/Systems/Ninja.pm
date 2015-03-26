package Ninja;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGetNinjaRevision($strData, $objClient) {}

method handleGetNinjaLevel($strData, $objClient) {}

method handleGetCards($strData, $objClient) {}

method handleGetFireLevel($strData, $objClient) {}

method handleGetWaterLevel($strData, $objClient) {}

method handleGetSnowLevel($strData, $objClient) {}

1;
