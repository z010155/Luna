package Navigation;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleJoinPlayer($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intRoom = $arrData[5];
       if (!$arrData[6]) {
            $arrData[6] = 0;
       }       
       if (!$arrData[7]) {
            $arrData[7] = 0;
       }
       if ($intRoom < 1000) {
            $intRoom = $intRoom + 1000;
       }
       $objClient->sendXT(['jp', '-1', $intRoom]); 
       $objClient->joinRoom($intRoom, $arrData[6], $arrData[7]);
}

method handleJoinRoom($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intRoom = $arrData[5];
       my $intX = $arrData[6];
       my $intY = $arrData[7];
       $objClient->joinRoom($intRoom, $intX, $intY);
}

method handleJoinServer($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $loginKey = $arrData[6];
       my $dbInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `loginKey`, `invalidLogins` FROM users WHERE `ID` = '$objClient->{ID}'");
       if ($loginKey ne '' || $loginKey ne $dbInfo->{loginKey}) {
           $objClient->sendError(101);
           $objClient->updateInvalidLogins($dbInfo->{invalidLogins} + 1, $objClient->{username});
           return $self->{child}->{modules}->{base}->removeClientBySock($objClient->{sock});
       }
       $objClient->updateKey('', $objClient->{username});
       $objClient->sendXT(['js', '-1', 0, $objClient->{isEPF}, $objClient->{isStaff}]);
       $objClient->sendXT(['lp', '-1', $objClient->buildClientString, $objClient->{coins}, 0, 1440, 100, $objClient->{age}, 4, $objClient->{age}, 7]);
       $objClient->sendXT(['gps', '-1', $objClient->{ID}, join('|', @{$objClient->{stamps}})]);
       $objClient->joinRoom($self->{child}->generateRoom);     
}

method handleJoinGame($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $gameRoom = $arrData[5];
       $objClient->joinRoom($gameRoom);
}

method handleGetRoomSynced($strData, $objClient) {
       my $strClients = '';
       foreach (values %{$self->{clients}}) {
                if ($_->{room} == $objClient->{room}) {
                    $strClients .= $_->buildClientString . '%';
                }
       }
       $objClient->write('%xt%grs%-1%' . ($strClients ? $strClients : '%'));
}

1;
